//
//  themes.swift
//  SwiftSourceHighlighter
//
//  Created by Dennis Baker on 3/17/17.
//  Copyright © 2017 Dennis Baker. All rights reserved.
//

import Foundation

// These specify how the CSS is injected into the code.
// url(string) - creates a CSS link element in your document pointing to the specified 
//              web URL. You will have to manually copy a valid theme file to the URL.
//              When using this option, the theme setting is ignored.
// autoURL - This works as above, but creates the link based on the theme selected. 
//              The theme file must be manually copied to the folder of the linking file.
// inline - This is the easiest method and preferred for many use cases. The file is read 
//              and the CSS style is injected in it's entirety to the HTML.
// omit - With this option, this library does nothing with CSS, you have to copy the CSS
//              and include the link in your html on your own.
//
public enum HighlighterCSSOptions {
    case url(String)
    case autoURL
    case inline
    case omit
}


public enum HighlighterTheme: String {
    case agate = "agate.css"
    case monokai = "monokai.css"
    case androidstudio = "androidstudio.css"
    case obsidian = "obsidian.css"
    case arduino_light = "arduino-light.css"
    case codepen_embed = "codepen-embed.css"
    case ocean = "ocean.css"
    case arta = "arta.css"
    case color_brewer = "color-brewer.css"
    case paraiso_dark = "paraiso-dark.css"
    case ascetic = "ascetic.css"
    case darcula = "darcula.css"
    case paraiso_light = "paraiso-light.css"
    case atelier_cave_dark = "atelier-cave-dark.css"
    case dark = "dark.css"
    case atelier_cave_light = "atelier-cave-light.css"
    case darkula = "darkula.css"
    case atelier_dune_dark = "atelier-dune-dark.css"
    case default_highlighter = "default.css"
    case purebasic = "purebasic.css"
    case atelier_dune_light = "atelier-dune-light.css"
    case docco = "docco.css"
    case qtcreator_dark = "qtcreator_dark.css"
    case atelier_estuary_dark = "atelier-estuary-dark.css"
    case dracula = "dracula.css"
    case qtcreator_light = "qtcreator_light.css"
    case atelier_estuary_light = "atelier-estuary-light.css"
    case far = "far.css"
    case railscasts = "railscasts.css"
    case atelier_forest_dark = "atelier-forest-dark.css"
    case foundation = "foundation.css"
    case rainbow = "rainbow.css"
    case atelier_forest_light = "atelier-forest-light.css"
    case github_gist = "github-gist.css"
    case atelier_heath_dark = "atelier-heath-dark.css"
    case github = "github.css"
    case atelier_heath_light = "atelier-heath-light.css"
    case googlecode = "googlecode.css"
    case solarized_dark = "solarized-dark.css"
    case atelier_lakeside_dark = "atelier-lakeside-dark.css"
    case grayscale = "grayscale.css"
    case solarized_light = "solarized-light.css"
    case atelier_lakeside_light = "atelier-lakeside-light.css"
    case gruvbox_dark = "gruvbox-dark.css"
    case sunburst = "sunburst.css"
    case atelier_plateau_dark = "atelier-plateau-dark.css"
    case gruvbox_light = "gruvbox-light.css"
    case tomorrow_night_blue = "tomorrow-night-blue.css"
    case atelier_plateau_light = "atelier-plateau-light.css"
    case hopscotch = "hopscotch.css"
    case tomorrow_night_bright = "tomorrow-night-bright.css"
    case atelier_savanna_dark = "atelier-savanna-dark.css"
    case hybrid = "hybrid.css"
    case tomorrow_night_eighties = "tomorrow-night-eighties.css"
    case atelier_savanna_light = "atelier-savanna-light.css"
    case idea = "idea.css"
    case tomorrow_night = "tomorrow-night.css"
    case atelier_seaside_dark = "atelier-seaside-dark.css"
    case ir_black = "ir-black.css"
    case tomorrow = "tomorrow.css"
    case atelier_seaside_light = "atelier-seaside-light.css"
    case kimbie_dark = "kimbie.dark.css"
    case vs = "vs.css"
    case atelier_sulphurpool_dark = "atelier-sulphurpool-dark.css"
    case kimbie_light = "kimbie.light.css"
    case xcode = "xcode.css"
    case atelier_sulphurpool_light = "atelier-sulphurpool-light.css"
    case magula = "magula.css"
    case xt256 = "xt256.css"
    case atom_one_dark = "atom-one-dark.css"
    case mono_blue = "mono-blue.css"
    case zenburn = "zenburn.css"
    case atom_one_light = "atom-one-light.css"
    case monokai_sublime = "monokai-sublime.css"
}


