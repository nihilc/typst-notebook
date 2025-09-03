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
  theme-light-fg: "#000000",
  theme-light-bg: "#ffffff",
  theme-light-raw: "#f0f0f0",
  theme-dark-fg: "#DCD7BA",
  theme-dark-bg: "#1F1F28",
  theme-dark-raw: "#2a2a37",
  content,
) = {
  // Variables
  assert(
    theme == "light" or theme == "dark",
    message: "Theme must be 'light' or 'dark'",
  )
  let font = default-font + font
  let fg-color = if theme == "dark" { rgb(theme-dark-fg) } else {
    rgb(theme-light-fg)
  }
  let bg-color = if theme == "dark" { rgb(theme-dark-bg) } else {
    rgb(theme-light-bg)
  }
  let raw-color = if theme == "dark" { rgb(theme-dark-raw) } else {
    rgb(theme-light-raw)
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
    fill: bg-color,
  )

  // Text settings
  set text(lang: lang, font: font.main, size: font.size, fill: fg-color)
  show math.equation: set text(font: font.math, size: font.size)

  // Monospace/Code settings
  show raw: set text(font: (name: font.mono, covers: "latin-in-cjk"))
  show raw.where(block: false): body => box(
    fill: raw-color,
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
    fill: raw-color,
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
  set line(stroke: 1pt + fg-color)
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

