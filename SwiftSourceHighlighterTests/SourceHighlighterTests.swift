//
//  CodeHighlighterTests.swift
//  SwiftBlog
//
//  Created by Dennis Baker on 2/25/17.
//  Copyright © 2017 Dennis Baker. All rights reserved.
//

import XCTest

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
//        let bundle = Bundle(for: SourceHighlighter.self)
        let sourceEncoder = SourceHighlighter(html:html) //, jsDirectoryURL: bundle.bundleURL)
        let resultHTML = sourceEncoder.getRenderedHTML()

        XCTAssert(html != resultHTML, "Ooops these should be different")
        XCTAssert(resultHTML!.range(of: "hljs-string") != nil) // Has it highlighted a String?
        XCTAssert(resultHTML!.range(of: "hljs-built_in") != nil) // Has it highlighted a built in?
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            
        }
    }
    
}
