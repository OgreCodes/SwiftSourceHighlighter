//
//  SourceHighlighter.swift
//  SwiftBlog
//
//  Created by Dennis Baker on 2/25/17.
//  Copyright © 2017 Dennis Baker. All rights reserved.
//

import Foundation
import JavaScriptCore

/// Takes a HTML containing source code sections and adds
/// tags to highlight the source to make it easier to read.
///
/// Basic Usage:
///
///     let finalHTML = SourceHighlighter().highlight(sourceHTML)
///
/// By default it appends the CSS inline at the end of the source HTML. 
/// It can also inline the CSS or link to a CSS file of your choice
/// using a chainable method as follows:
///
///     let xcodeHTML = SourceHighlighter(
///         cssPlacement: .url("test.css"),
///         theme: .xcode)
///         .highlight(html)
///
/// This framework includes a copy of `highlight.js, but you can include your own
/// version by building a URL to a copy of the library from your bundle.
/// For example:
///
///     let customHighlighter =
///         Bundle.main.bundleURL.appendingPathComponent("highlight.pack.js")
///     let sourceHighlighter = SourceHighlighter(highlightURL: customHighlighter)
///
/// Take a look at the tests for more examples.


public class SourceHighlighter {
    var highlightURL: URL!
    let context = JSContext()!
    let regexPattern: String
    let cssPlacement: HighlighterCSSOptions
    let theme: HighlighterTheme
    
    public init(highlightURL: URL? = nil,
         regexPattern: String = "(?:<pre>.*?<code>)(.+?)(?:<\\/code>.*?<\\/pre>)",
         cssPlacement: HighlighterCSSOptions = .inline,
         theme: HighlighterTheme = .agate
        ) {

        self.regexPattern = regexPattern
        self.cssPlacement = cssPlacement
        self.theme = theme
        // Default to using highlightjs from this bundle.
        self.highlightURL = highlightURL ??
            Bundle(for: SourceHighlighter.self).bundleURL
                .appendingPathComponent("highlight", isDirectory: true)
                .appendingPathComponent("highlight.pack.js")
        context.exceptionHandler = self.jsErrorHandler
    }

    func jsErrorHandler(_: JSContext?, _ maybeError: JSValue?) {
        let error = maybeError?.toString() ?? "Unknown Error"
        assertionFailure("Javascript Error: \(error)")
        NSLog("Javascript Error: \(error)")
    }

    /// This function generates an array of matching codeblocks
    func fetchMatchingCodeBlocks(sourceHTML: String) -> [NSTextCheckingResult] {
        let regex = try! NSRegularExpression(
            pattern: regexPattern,
            options: [.dotMatchesLineSeparators, .caseInsensitive])
        
        let range = NSMakeRange(0, sourceHTML.characters.count)
        let matches = regex.matches(in: sourceHTML, options: .reportCompletion, range: range)
        return matches
    }
    
    // Set up the highlighter and creates the javascript context for running
    // code highlighting.
    func getJSHighlighter() -> JSValue {
        // highlight.js, javascript source code highlighter
        // Lets not be coy here, without the highlighter we're sunk.
        guard let highlightJS = try? String(contentsOf: highlightURL) else {
            fatalError()
        }

        // The highlighter requires the Window object be defined
        // Inspiration https://blog.risingstack.com/running-node-modules-in-your-ios-project/
        _ = context.evaluateScript("var window = this;")
        _ = context.evaluateScript(highlightJS)
        
        // a simple javascript helper function that calls the highlighter and returns just the needed value.
        _ = context.evaluateScript("function jsHighlight(html) { return hljs.highlightAuto(html).value }")
        return context.objectForKeyedSubscript("jsHighlight")
    }
    
    public func highlight(_ sourceHTML: String) -> String {
        var html = sourceHTML
        let jsHighlighter = getJSHighlighter()

        // Apply code highlighting in reverse order so early changes don't invalidate indexes.

        for match in fetchMatchingCodeBlocks(sourceHTML: html).reversed() {
            let matchedText: String = (html as NSString).substring(with: match.rangeAt(1))
            let newText = jsHighlighter.call(withArguments: [matchedText]).toString()
            html = (html as NSString).replacingCharacters(in: match.rangeAt(1), with: newText!) as String
        }
        return injectCSS(html)
    }
    
    func injectCSS(_ html: String) -> String {
        let injectedHTML:String
        switch cssPlacement {
        case .inline:
            // Dump CSS immediately prior to the end of the html.
            let cssFile = Bundle(for: SourceHighlighter.self).bundleURL
                .appendingPathComponent("highlight", isDirectory: true)
                .appendingPathComponent("styles", isDirectory: true)
                .appendingPathComponent(theme.rawValue)
            let cssText = try! String(contentsOf: cssFile)
            let injectedCSS = "<style>\(cssText)</style>"
            injectedHTML = html.replacingOccurrences(of: "</html>", with: "\(injectedCSS)</html>")
        case .url(let url):
            // Add a link to the 
            let cssLink = "<link rel=\"stylesheet\" type=\"text/css\" href=\"\(url)\">"
            injectedHTML = html.replacingOccurrences(of: "</html>", with: "\(cssLink)</html>")
        case .autoURL:
            let url = theme.rawValue
            let cssLink = "<link rel=\"stylesheet\" type=\"text/css\" href=\"\(url)\">"
            injectedHTML = html.replacingOccurrences(of: "</html>", with: "\(cssLink)</html>")
        case .omit:
            injectedHTML = html
        }
        return injectedHTML
    }
}
