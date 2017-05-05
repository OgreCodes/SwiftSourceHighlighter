# Swift Source Highlighter

SwiftSourceHighlighter is a Swift wrapper around the `highlight.js` javascript source highlighter. It can be dropped into a Swift Project to add HTML source-code highlighting to chunks of source code. By default it is set up to integrate with HTML files created by a Markdown editor, but you can customize it for any source files. Feed an HTML file with a section of source code in it and this generates a well formatted HTML file with attractively highlighted source.

By pre-rendering the HTML instead of doing the highlighting at runtime, the page loads faster and since it lacks external dependencies, is rendered more consistently, particularly when you are offline or have unreliable connectivity.

### Features

 * Highlights code inline with a customizable regular expression.
 * Optional CSS Inlining for faster and simpler page rendering.
 * Support for all of the [themes and languages](https://highlightjs.org/static/demo/) supported by the popular `highlight.js` highlighter which allows for output similar to that in common text editors.
 * Allows custom versions of `highlight.js` to support additional languages or limit highlighting to a smaller set of languages (So you don't inadvertently get the color highlighting for the wrong language).

### Installation

The easiest way to install this framework is by dragging it into your project. There are no Swift dependencies and all Javascript is included in the project. 

### Basic Usage

    let finalHTML = SourceHighlighter().highlight(sourceHTML)

Themes are an enum so you can find them easily via tab completion.

    let rainbowHTML = SourceHighlighter(theme: .rainbow)
        .highlight(html)

You can manually upload the CSS or use a CDN and link to it explicitly as well.

    let xcodeHTML = SourceHighlighter(cssPlacement: .url("xcode.css")).highlight(html)

Since a Javascript context is created for each instance, when processing multiple source files, it is more efficient to instantiate a highlighter and feed it your sources.

	let highlighter = SourceHighlighter(cssPlacement: .url("xcode.css"))
	let output1 = highlighter.highlight(htmlSource1)
	let output2 = highlighter.highlight(htmlSource2)
	let output3 = highlighter.highlight(htmlSource3)

This framework includes a copy of `highlight.js`, but you can include your own
version by building a URL to a copy of the library from your bundle.
For example:

    let customHighlighter =
        Bundle.main.bundleURL.appendingPathComponent("highlight.pack.js")
    let sourceHighlighter = SourceHighlighter(highlightURL: customHighlighter)

Take a look at the tests for more examples.
