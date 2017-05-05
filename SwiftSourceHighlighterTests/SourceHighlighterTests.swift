//
//  CodeHighlighterTests.swift
//  SwiftBlog
//
//  Created by Dennis Baker on 2/25/17.
//  Copyright © 2017 Dennis Baker. All rights reserved.
//

import XCTest

// A few basic tests to verify we're actually 
class SourceHighlighterTests: XCTestCase {
    
    let html = "<html><body><pre><code>let x = 123;print(\"Hello World \\(x)\")\n</code></pre></body></html>"
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    /// Check that the highlighter class is adding the appropriate code highlights
    func testHighlighterAddingClasses() {
        let highlightedHTML = SourceHighlighter().highlight(html)

        XCTAssert(html != highlightedHTML, "Ooops these should be different")
        XCTAssert(highlightedHTML.range(of: "hljs-string") != nil) // Has it highlighted a String?
        XCTAssert(highlightedHTML.range(of: "hljs-built_in") != nil) // Has it highlighted a built in?
    }
    
    func testInlineCSS() {
        let highlightedHTML = SourceHighlighter(cssPlacement: .inline).highlight(html)
        
        XCTAssert(html != highlightedHTML, "Ooops these should be different")
        // Check there is a style tag at the end of the file
        XCTAssert(highlightedHTML.range(of: "</style></html>") != nil)
        // Check for a few class definitions
        XCTAssert(highlightedHTML.range(of: ".hljs") != nil)
        XCTAssert(highlightedHTML.range(of: ".hljs-comment,") != nil)
    }
    
    // check assigning a theme works by verifying a known string is injected
    func testThemeAssignment() {
        let xcodeHTML = SourceHighlighter(
            cssPlacement: .inline,
            theme: .xcode)
                .highlight(html)
        
        XCTAssert(xcodeHTML.range(of: "XCode style") != nil)
        
        let arduinoHTML = SourceHighlighter(
            cssPlacement: .inline,
            theme: .arduino_light)
            .highlight(html)
        
        XCTAssert(arduinoHTML.range(of: "Arduino® Light Theme") != nil)
    }

    func testAutoURL() {
        // Auto URL uses a link to a CDN
        let rainbowHTML = SourceHighlighter(
            cssPlacement: .autoURL,
            theme: .rainbow)
            .highlight(html)
        XCTAssert(rainbowHTML.range(of: "rainbow.css") != nil)
    }
    
    
    func testLinkedCSS() {
        let highlightedHTML = SourceHighlighter(cssPlacement: .url("test.css")).highlight(html)
        
        XCTAssert(html != highlightedHTML, "Ooops these should be different")
        // Check there is a link tag for the specified url
        XCTAssert(highlightedHTML.range(
            of: "link.*test.css",
            options: .regularExpression) != nil)
    }
    
}
