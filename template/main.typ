#import "@local/notebook:0.1.0": *

#show: notebook.with(
  lang: "ES",
  paper: "a4",
  font: (
    main: "IBM Plex Sans",
    math: "IBM Plex Math",
    mono: "IBM Plex Mono",
    size: 12pt,
  ),
  title: "Notebook Title",
  author: "Your Name",
  // make-title: false,
  // make-toc: false,
  // theme: "dark",
)
