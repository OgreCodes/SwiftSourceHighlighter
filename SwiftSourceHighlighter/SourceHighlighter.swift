//
//  SourceHighlighter.swift
//  SwiftBlog
//
//  Created by Dennis Baker on 2/25/17.
//  Copyright © 2017 Dennis Baker. All rights reserved.
//

import Foundation
import JavaScriptCore

/// Run highlighter.js against an HTML document with

/// Basic Usage (Most basic use case):
///     let sourceHighlighter = SourceHighlighter(html: html)
///     let highlightedHTML = sourceHighlighter.getRenderedHTML()
///     
/// By default this uses the copy of Highlight.js included in this framework,
///     with support for C, C++, Java, Objective-C, Swift, HTML, CSS, LESS,
///     SCSS, 
/// Specify the highlightURL in the init to override this. For example:
////    let myHighlight = Bundle.main.bundleURL.appendingPathComponent("highlight.pack.js")
///     let sourceHighlighter = SourceHighlighter(html: html, highlightURL: )
class SourceHighlighter {
    let sourceHTML: String
    let highlightURL: URL
    let context = JSContext()!
    let regexPattern: String
    
    init(html: String,
         jsDirectoryURL: URL? = nil,
         regexPattern: String = "(?:<pre>.*<code>)(.*?)(?:<\\/code>.*<\\/pre>)") {
        self.sourceHTML = html
        self.regexPattern = regexPattern
        // Default to using highlightjs from this bundle.
        self.highlightURL = jsDirectoryURL ??
            Bundle(for: NSClassFromString("SourceHighlighter")!).bundleURL
                .appendingPathComponent("highlight.pack.js")
        context.exceptionHandler = self.jsErrorHandler
    }

    func jsErrorHandler(_: JSContext?, _ maybeError: JSValue?) {
        let error = maybeError?.toString() ?? "Unknown Error"
        assertionFailure("Javascript Error: \(error)")
        NSLog("Javascript Error: \(error)")
    }

    /// This function generates an array of 
    func searchForCodeBlocks(inHTML: String) -> [NSTextCheckingResult] {
        let regex = try! NSRegularExpression(
            pattern: regexPattern,
            options: [.dotMatchesLineSeparators, .caseInsensitive])
        
        let range = NSMakeRange(0, sourceHTML.characters.count)
        let matches = regex.matches(in: sourceHTML, options: .reportCompletion, range: range)
        return matches
    }
    
    func getJSHighlighter() -> JSValue? {
        // highlight.js, javascript source code highlighter
        guard let highlightJS = try? String(contentsOf: highlightURL) else {
            return nil
        }
        // The highlighter requires the Window object be defined
        // Inspiration https://blog.risingstack.com/running-node-modules-in-your-ios-project/
        _ = context.evaluateScript("var window = this;")
        _ = context.evaluateScript(highlightJS)
        
        // a simple javascript helper function that calls the highlighter and returns just the needed value.
        _ = context.evaluateScript("function jsHighlight(html) { return hljs.highlightAuto(html).value }")
        return context.objectForKeyedSubscript("jsHighlight")
    }
    
    func getRenderedHTML() -> String? {
        var html = sourceHTML
        guard let jsHighlighter = getJSHighlighter() else {
            NSLog("Error: Can't find Highlighter")
            return nil
        }
        
        // Apply code highlighting in reverse order so early changes don't invalidate indexes.
        for match in searchForCodeBlocks(inHTML: html).reversed() {
            let matchedText: String = (html as NSString).substring(with: match.rangeAt(1))
            let newText = jsHighlighter.call(withArguments: [matchedText]).toString()
            html = (html as NSString).replacingCharacters(in: match.rangeAt(1), with: newText!) as String
        }
        return html
    }
}
