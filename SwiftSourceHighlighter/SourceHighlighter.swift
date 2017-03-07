//
//  SourceHighlighter.swift
//  SwiftBlog
//
//  Created by Dennis Baker on 2/25/17.
//  Copyright © 2017 Dennis Baker. All rights reserved.
//

import Foundation
import JavaScriptCore

enum CSSOptions {
    case url(String)
    case inline
    case omit
}


/// Takes a HTML containing source code sections and adds
/// tags to highlight the source to make it easier to read.
///
/// Basic Usage:
///
///     let finalHTML = SourceHighlighter().highlight(sourceHTML)
///
/// By default it appends a link to a CSS file on a CDN to the source 
/// but it can also inline the CSS or link to a CSS file of your choice
/// using a chainable method as follows:
///
///     let highlighter = SourceHighlighter(options: .inlineCSS)
///     let highlighted = highlighter.highlight(html)
///

/// By default this uses the copy of Highlight.js included in this framework,
/// with support for swift objectivec markdwon php cs html css javascript
/// handlebars bash coffeescript sql ruby apache nginx cpp xml python
///
/// Specify the highlightURL in the init to override this. For example:
///
///     let customHighlighter =
///         Bundle.main.bundleURL.appendingPathComponent("highlight.pack.js")
///     let sourceHighlighter = SourceHighlighter(highlightURL: customHighlighter)
///

class SourceHighlighter {
    var highlightURL: URL!
    let context = JSContext()!
    let regexPattern: String
    let cssPlacement: CSSOptions
    let theme = "agate.css"
    
    init(highlightURL: URL? = nil,
         regexPattern: String = "(?:<pre>.*?<code>)(.+?)(?:<\\/code>.*?<\\/pre>)",
         cssPlacement: CSSOptions = .inline) {

        self.regexPattern = regexPattern
        self.cssPlacement = cssPlacement
        // Default to using highlightjs from this bundle.
        self.highlightURL = highlightURL ??
            Bundle(for: SourceHighlighter.self).bundleURL
                .appendingPathComponent("highlight.pack.js")
        context.exceptionHandler = self.jsErrorHandler
    }

    func jsErrorHandler(_: JSContext?, _ maybeError: JSValue?) {
        let error = maybeError?.toString() ?? "Unknown Error"
        assertionFailure("Javascript Error: \(error)")
        NSLog("Javascript Error: \(error)")
    }

    /// This function generates an array of
    func fetchMatchingCodeBlocks(sourceHTML: String) -> [NSTextCheckingResult] {
        let regex = try! NSRegularExpression(
            pattern: regexPattern,
            options: [.dotMatchesLineSeparators, .caseInsensitive])
        
        let range = NSMakeRange(0, sourceHTML.characters.count)
        let matches = regex.matches(in: sourceHTML, options: .reportCompletion, range: range)
        return matches
    }
    
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
            let cssFile = Bundle(for: SourceHighlighter.self).bundleURL
                .appendingPathComponent(theme)
            let cssText = try! String(contentsOf: cssFile)
            let injectedCSS = "<style>\(cssText)</style>"
            injectedHTML = html.replacingOccurrences(of: "</html>", with: "\(injectedCSS)</html>")
            NSLog("Inline")
        case .url(let url):
            let cssLink = "<link rel=\"stylesheet\" type=\"text/css\" href=\"\(url)\">"
            injectedHTML = html.replacingOccurrences(of: "</html>", with: "\(cssLink)</html>")
            NSLog(url)
        case .omit:
            injectedHTML = html
        }
        return injectedHTML
    }
}
