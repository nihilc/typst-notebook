#import "@local/thmbox:0.3.0": *
#import "@preview/quick-maths:0.2.1": shorthands
#import "@preview/numbly:0.1.0": numbly

// Variables
#let default-font = (
  main: "IBM Plex Sans",
  math: "IBM Plex Math",
  mono: "IBM Plex Mono",
  size: 12pt,
)
#let default-theme = (
  light: (
    fg: rgb("#000000"),
    bg: rgb("#ffffff"),
    bg-raw: rgb("#f0f0f0"),
  ),
  dark: (
    fg: rgb("#DCD7BA"),
    bg: rgb("#1F1F28"),
    bg-raw: rgb("#2a2a37"),
  ),
)

#let notebook(
  lang: "EN",
  paper: "a4",
  font: default-font,
  title: none,
  author: none,
  make-title: true,
  make-toc: true,
  toc-title: "Table of Contents",
  toc-depth: 3,
  theme: "light",
  content,
) = {
  // Variables
  let font = default-font + font

  assert(
    theme == "light" or theme == "dark",
    message: "Theme must be 'light' or 'dark'",
  )

  // Define if use dark or light theme
  let colors = if theme == "dark" {
    default-theme.dark
  } else {
    default-theme.light
  }

  // Document metadata
  set document(title: title, author: author, date: auto)

  // Page settings
  set page(
    paper: paper,
    header: context {
      let start-header-at = int(make-title) + int(make-toc)
      if (counter(page).get().at(0) > start-header-at) {
        grid(
          columns: (1fr, 1fr),
          align: (left, right),
          title, counter(page).display("1"),
        )
        line(length: 100%)
      }
    },
    fill: colors.bg,
  )

  // Text settings
  set text(lang: lang, font: font.main, size: font.size, fill: colors.fg)
  show math.equation: set text(font: font.math, size: font.size)

  // Monospace/Code settings
  show raw: set text(font: (name: font.mono, covers: "latin-in-cjk"))
  show raw.where(block: false): body => box(
    fill: colors.bg-raw,
    inset: (x: 3pt, y: 1pt),
    outset: (x: 0pt, y: 2pt),
    radius: 2pt,
    {
      set par(justify: false)
      body
    },
  )
  show raw.where(block: true): body => block(
    width: 100%,
    fill: colors.bg-raw,
    outset: (x: 0pt, y: 4pt),
    inset: (x: 8pt, y: 4pt),
    radius: 2pt,
    {
      set par(justify: false)
      body
    },
  )

  // Heading settings
  set heading(numbering: "1.")
  show heading: set block(spacing: 1em)

  // Other elements settings
  set list(indent: 2pt, marker: "•")
  set enum(indent: 2pt, numbering: n => emph[#n.], full: false)
  set line(stroke: 1pt + colors.fg)
  set rect(stroke: 1pt + colors.fg)
  set square(stroke: 1pt + colors.fg)
  show link: it => {
    if type(it.dest) == str {
      set text(fill: blue)
      it
    } else {
      it
    }
  }

  // Pakages settings
  show: thmbox-init()
  show figure.where(kind: "thmbox"): set block(breakable: true)
  show: shorthands.with(($+-$, $plus.minus$))


  // Title page
  if make-title {
    align(center + top)[
      #v(25%)
      #text(2em, weight: 500, title)
      #v(4em, weak: true)
      #author
    ]
    pagebreak(weak: true)
  }

  // Table of Contents page
  if make-toc {
    show heading: align.with(center)
    show outline.entry: set block(spacing: 1.2em)

    outline(title: toc-title, depth: toc-depth, indent: 2em)
    pagebreak(weak: true)
  }

  // Main content
  content
}

// Define custom math functions
#let mcd = math.op("mcd", limits: true)
#let mcm = math.op("mcm", limits: true)
