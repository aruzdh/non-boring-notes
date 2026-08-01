#import "translated_terms.typ": *
#import "@preview/showybox:2.0.4": showybox
#import "@preview/ctheorems:1.1.3": thmenv, thmrules
#import "@preview/fletcher:0.5.8" as fletcher: diagram, edge, node
#import "@preview/codly:1.3.0": *
#import "@preview/codly-languages:0.1.10": *
#import "@preview/cetz:0.5.2"
#import "@preview/unify:0.8.1": *

#let template(
  title: "Lecture Notes Title",
  short_title: none,
  subtitle: none,
  authors: (),
  description: none,
  abstract: none,
  creation_date: none,
  updated_date: true,

  paper_size: "a4",
  paper_color: "#ffffff",
  text_color: "#000000",
  landscape: false,
  cols: 1,
  paragraph_indent: 1em,
  justify: true,

  text_font: ("Charter", "XCharter", "Libertinus Serif", "Linux Libertine", "Source Serif 4", "Georgia", "serif"),
  code_font: ("IoskeleyMono Nerd Font", "MonoLisa", "JetBrains Mono", "Fira Code", "Cascadia Code", "monospace"),
  math_font: ("Erewhon Math", "Libertinus Math", "STIX Two Math", "New Computer Modern Math", "Cambria Math", "serif"),
  equation_size: 1.1em,
  text_lang: "en",

  heading_numbering: "1.1",
  show_prefix: true,
  show_numbering: true,
  h1_prefix: "lecture",
  math_equation_numbering: false,
  bibliography_file: none,
  bibstyle: "ieee",

  fancy_header: true,
  accent: "#222354",

  toc: true,
  toc_depth: 3,
  lof: false,
  lot: false,
  lol: false,
  body,
) = {
  let accent_color = rgb(accent)
  let text_color = rgb(text_color)

  // Show and Set
  show: thmrules
  show: codly-init.with()
  codly(
    fill: rgb("#fafafa"),
    zebra-fill: none,
    number-format: n => text(fill: rgb("#9b9fa6"), size: 0.8em)[#n],
    languages: codly-languages,
  )
  show heading: it => {
    it
    v(15pt, weak: true)
  }
  show link: it => {
    let author_names = authors.map(author => author.name)
    if it.body.has("text") and it.body.text in author_names {
      it
    } else {
      underline(stroke: (dash: "loosely-dash-dotted"), offset: 2pt, text(fill: accent_color, it))
    }
  }
  show raw: set text(font: code_font)
  show raw.where(block: false): it => box(
    fill: luma(250),
    stroke: 0.5pt + luma(200),
    inset: (x: 3pt),
    outset: (y: 3pt),
    radius: 2pt,
  )[#it]

  // Level-1 heading numbering format
  show selector(heading.where(level: 1)): set heading(numbering: (..nums) => (
    if show_prefix and show_numbering {
      get_translation(translated_terms.at(h1_prefix)) + { " " + nums.pos().map(str).join(".") } + ":"
    } else if show_prefix {
      get_translation(translated_terms.at(h1_prefix)) + ":"
    } else if show_numbering { " " + nums.pos().map(str).join(".") + ":" } else { "—" }
  ))

  show math.equation: set text(font: math_font, size: equation_size)
  // Context-aware equation numbering: (Chapter.Equation)
  set math.equation(numbering: (..nums) => {
    if math_equation_numbering {
      context {
        let h1 = query(selector(heading.where(level: 1)).before(here()))
        if h1.len() > 0 {
          let n = counter(heading.where(level: 1)).at(h1.last().location()).first()
          numbering("(1.1)", n, ..nums)
        } else {
          numbering("(1)", ..nums)
        }
      }
    }
  })

  show heading.where(level: 1): it => {
    counter(math.equation).update(0)
    it
  }

  set enum(indent: 10pt, body-indent: 6pt)
  set list(indent: 10pt, body-indent: 6pt)
  set text(font: text_font, size: 10.5pt, lang: text_lang, fill: text_color)
  set par(justify: justify, linebreaks: "optimized", first-line-indent: paragraph_indent)
  set document(title: title, author: authors.map(author => author.name))
  set heading(numbering: if show_numbering { heading_numbering })
  set page(
    paper: paper_size,
    fill: rgb(paper_color),
    columns: cols,
    flipped: landscape,
    numbering: "1",
    number-align: center,
    header: context {
      if not fancy_header { return }
      if counter(page).get().first() == 1 { return none }

      let elems = query(selector(heading.where(level: 1)).before(here()))

      if elems.len() == 0 { return none }

      let current_heading = elems.last()
      let head_title = text(fill: accent_color, {
        if short_title != none { short_title } else { title }
      })

      (
        head_title
          + h(1fr)
          + emph(
            if current_heading.numbering != none and show_numbering {
              let prefix = if show_prefix { get_translation(translated_terms.at(h1_prefix)) + " " } else { "" }
              let numbering = if show_numbering { counter(heading.where(level: 1)).display("1 — ") } else { "" }
              text(fill: accent_color, prefix + numbering + current_heading.body)
            } else { current_heading.body },
          )
      )
      v(-6pt)
      line(length: 100%, stroke: (thickness: 0.6pt, paint: accent_color, dash: "solid"))
    },
  )

  // Document Structure

  align(center, [
    #set text(18pt, weight: "bold")
    #title
  ])

  if subtitle != none {
    align(center, [
      #set text(14pt, weight: "semibold")
      #subtitle
    ])
  }

  if description != none {
    align(center, box(width: 90%)[
      #set text(size: 11pt, style: "italic")
      #description
    ])
  }

  if abstract != none {
    pad(x: 2em, [
      #set text(size: 0.9em)
      #text(weight: "bold")[Abstract:] #abstract
    ])
  }

  if authors.len() > 0 {
    align(center, box(inset: (y: 10pt), {
      authors
        .map(author => {
          text(11pt, weight: "semibold")[
            #if "link" in author {
              link(author.link)[#author.name]
            } else { author.name }
          ]
        })
        .join(", ", last: if authors.len() > 2 { ", and" } else { "and" })
    }))
  }

  let create_date(date, label) = {
    text(
      size: 11pt,
      [*#get_translation(translated_terms.at(label))*] + ": " + date.display("[month] / [day] / [year repr:full]"),
    )
  }

  let date = if creation_date != none { create_date(creation_date, "created") }
  let last_updated_date = create_date(datetime.today(), "last_updated")

  let date_columns = if (creation_date != none) and updated_date { 2 } else if (creation_date != none) or updated_date {
    1
  } else { 0 }

  if (creation_date != none) or updated_date {
    columns(date_columns)[
      #align(center)[
        #if creation_date != none { date }
        #if date_columns == 2 { colbreak() }
        #if updated_date { last_updated_date }
      ]
    ]
  }

  if toc {
    heading(level: 1, outlined: false, numbering: none)[#get_translation(translated_terms.contents)]
    outline(indent: auto, title: none, depth: toc_depth)
  }

  if lof {
    v(4pt)
    heading(level: 1, outlined: false, numbering: none)[#get_translation(translated_terms.lof)]
    outline(indent: auto, title: none, target: figure.where(kind: image))
  }

  if lot {
    v(4pt)
    heading(level: 1, outlined: false, numbering: none)[#get_translation(translated_terms.lot)]
    outline(indent: auto, title: none, target: figure.where(kind: table))
  }

  if lol {
    v(4pt)
    heading(level: 1, outlined: false, numbering: none)[#get_translation(translated_terms.lol)]
    outline(indent: auto, title: none, target: figure.where(kind: raw))
  }

  v(15pt)

  body

  if bibliography_file != none {
    align(center)[#v(0.5em) * — #sym.space.quad —  #sym.space.quad —  * #v(0.5em)]
    bibliography(bibliography_file, title: [#get_translation(translated_terms.references)], style: bibstyle)
  }
}

// Boxes
#let boxnumbering = "1.1.1.1.1.1"
#let boxcounting = "heading"

// General box
#let box_thm(
  identifier,
  title,
  base-color,
  numbered: true,
  breakable: true,
) = thmenv(
  identifier,
  boxcounting,
  none,
  (name, number, body, ..args) => {
    showybox(
      breakable: breakable,
      frame: (
        border-color: base-color,
        body-color: base-color.lighten(96%),
        thickness: (left: 2pt, right: 2pt, rest: 0pt),
        radius: (right: 3pt, left: 3pt),
        inset: (x: 12pt, y: 12pt),
      ),
      footer-style: (
        color: base-color,
      ),
      ..args.named(),
      [
        #text(fill: base-color, weight: "bold")[#title]
        #if numbered [
          #text(fill: base-color, weight: "bold")[ #number]
        ]
        #if name != none [
          #text(fill: base-color.darken(20%), style: "italic")[ (#name)]
        ]
        #text(fill: base-color, weight: "bold")[.]
        #h(0.4em)
        #body
      ],
    )
  },
).with(numbering: boxnumbering)

#let color-purple = rgb("#9a77cf")
#let color-pink = rgb("#ff71ce")
#let color-blue = rgb("#118dc3")
#let color-green = rgb("#1da912")
#let color-orange = rgb("#ee9025")
#let color-yellow = rgb("#eea825")
#let color-red = rgb("#e05661")
#let color-gray = rgb("#9b9fa6")

// Particular boxes
#let theorem = box_thm(
  "theorem",
  get_translation(translated_terms.theorem),
  color-purple,
)

#let corollary = box_thm(
  "corollary",
  get_translation(translated_terms.corollary),
  color-purple,
)

#let lemma = box_thm(
  "lemma",
  get_translation(translated_terms.lemma),
  color-purple,
)

#let proposition = box_thm(
  "proposition",
  get_translation(translated_terms.proposition),
  color-purple,
)

#let hypothesis = box_thm(
  "hypothesis",
  get_translation(translated_terms.hypothesis),
  color-pink,
)

#let definition = box_thm(
  "definition",
  get_translation(translated_terms.definition),
  color-blue,
)

#let example = box_thm(
  "example",
  get_translation(translated_terms.example),
  color-green,
)

#let note = box_thm(
  "note",
  get_translation(translated_terms.note),
  color-yellow,
)

#let attention = box_thm(
  "attention",
  get_translation(translated_terms.attention),
  color-red,
)

#let important = box_thm(
  "important",
  get_translation(translated_terms.important),
  color-red,
)

#let exercise = box_thm(
  "exercise",
  get_translation(translated_terms.exercise),
  color-orange,
)

#let tip = box_thm(
  "tip",
  get_translation(translated_terms.tip),
  numbered: false,
  color-pink,
)

#let remark = box_thm(
  "remark",
  get_translation(translated_terms.remark),
  numbered: false,
  color-gray,
)

// Miscellaneous
#let quote(cite: none, body) = [
  #set text(size: 0.97em)
  #pad(left: 1.5em)[
    #block(
      breakable: true,
      width: 100%,
      fill: gray.lighten(95%),
      radius: (left: 0pt, right: 5pt),
      stroke: (left: 5pt + gray, rest: 1pt + silver.lighten(50%)),
      inset: 1em,
    )[#body]
  ]
]

#let proof = thmenv(
  "proof",
  boxcounting,
  none,
  (name, number, body, ..args) => {
    block(
      width: 100%,
      breakable: true,
      inset: (top: 0.5em, bottom: 0.5em),
      [*_#get_translation(translated_terms.proof)._*] + body + [#h(1fr) $qed$],
    )
  },
).with(numbering: none)


// Useful functions

// A minimal box to write indent text
#let indent(body) = [
  #block(
    width: 90%,
    inset: (left: 1.5em),
    [ #body ],
  )
]

// Use it to have a good text format inside a 'underbrace' or 'overbrace' function.
#let smash(body, side: center) = math.display(
  box(
    width: 0pt,
    align(
      side.inv(),
      box(width: float.inf * 1pt, $ script(body) $),
    ),
  ),
)

// Make a title and subtitle
#let maketitle(title, subtitle: "", position: center) = [
  #align(position)[
    #text(18pt)[ = #title ]
    #text(13pt, style: "italic")[ #subtitle ]
  ]
]

// A pretty (dashed) horizontal line
#let horizontalrule(color: gray, dashed: false) = {
  line(
    length: 100%,
    stroke: (
      paint: color,
      thickness: 1pt,
      dash: if dashed { ("dot", 2pt, 4pt, 2pt) } else { none },
    ),
  )
}

// A math box to emphasize an equation
#let mathbox(content, higher: false) = {
  box(
    stroke: 0.5pt,
    inset: (x: 6pt, y: 3pt),
    outset: (x: 2pt, y: if higher { 8pt } else { 4pt }),
    if higher { $display(#content)$ } else { $#content$ },
  )
}

// A centered math box to emphasize an observation
#let mathnote(content) = align(center)[(#content)]

