// Imports
// =============================================================
#import "translated_terms.typ": *
#import "@preview/showybox:2.0.3": showybox
#import "@preview/ctheorems:1.1.3": thmenv, thmrules
#import "@preview/fletcher:0.5.8" as fletcher: diagram, edge, node

// =============================================================
// Template
// =============================================================
#let template(
  // Metadata
  title: "Lecture Notes Title",
  short_title: none,
  subtitle: none,
  authors: (),
  description: none,
  abstract: none,
  creation_date: none,
  updated_date: true,
  // Document Layout
  paper_size: "a4",
  paper_color: "#ffffff",
  text_color: "#000000",
  landscape: false,
  cols: 1,
  paragraph_indent: 1em,
  // Fonts & Language
  text_font: ("Charter", "Linux Libertine", "serif"),
  code_font: ("MonoLisa", "JetBrains Mono", "Fira Code", "Cascadia Code", "monospace"),
  math_font: ("Erewhon Math", "New Computer Modern Math", "serif"),
  equation_size: 1.1em,
  text_lang: "en",
  // Numbering & References
  heading_numbering: "1.1",
  show_prefix: true,
  show_numbering: true,
  h1_prefix: "lecture",
  math_equation_numbering: false,
  bibliography_file: none,
  bibstyle: "apa",
  // Styling
  fancy_header: true,
  accent: "#262626",
  colors: (
    theorem: rgb("#5d2f8e"),
    definition: rgb("#1a5fb4"),
    example: rgb("#26a269"),
    important: rgb("#c01c28"),
    note: rgb("#626262"),
    proof: rgb("#000000"),
  ),
  // Table of Contents & Lists
  toc: true,
  toc_depth: 3,
  lof: false,
  lot: false,
  lol: false,
  body,
) = {
  // ====================
  // Initial Setup
  // ====================
  show: thmrules

  // Determine the accent color
  let accent_color = rgb(accent)

  // Construct a string title
  let str_title = title

  // ====================
  // Global Set Rules
  // ====================

  // Set document metadata
  set document(title: str_title, author: authors.map(author => author.name))

  // Configure page layout and header
  set page(
    paper: paper_size,
    fill: rgb(paper_color),
    columns: cols,
    flipped: landscape,
    numbering: "1",
    number-align: center,
    header: context {
      if not fancy_header { return }
      let elems = query(selector(heading.where(level: 1)).before(here()))
      let head_title = text(fill: accent_color, {
        if short_title != none { short_title } else { str_title }
      })

      if elems.len() == 0 {
        align(right, "")
      } else {
        let current_heading = elems.last()
        // Display title on left, current heading on right
        (
          head_title
            + h(1fr)
            + emph(
              if current_heading.numbering != none {
                let prefix = if show_prefix { get_translation(translated_terms.at(h1_prefix)) + " " } else { "" }
                let numbering = if show_numbering { counter(heading.where(level: 1)).display("1: ") } else { "" }
                prefix + numbering + current_heading.body
              } else {
                current_heading.body
              },
            )
        )
        v(-6pt) // Adjust vertical position for the line
        line(length: 100%, stroke: (thickness: 1pt, paint: accent_color, dash: "solid"))
      }
    },
  )

  // Set fonts, language, and paragraph style
  set text(font: text_font, size: 10.5pt, lang: text_lang, fill: rgb(text_color))

  set par(justify: true, linebreaks: "optimized", first-line-indent: paragraph_indent)

  // Set numbering formats
  set heading(numbering: if show_numbering { heading_numbering })


  // Configure level 1 heading numbering format
  show selector(heading.where(level: 1)): set heading(numbering: (..nums) => (
    if show_prefix {
      (
        get_translation(translated_terms.at(h1_prefix))
          + [#if show_numbering { " " + nums.pos().map(str).join(".") }]
          + ":"
      )
    } else {
      if show_numbering { heading_numbering }
    }
  ))

  // Disable numbering for specific major headings (e.g., Contents, References)
  show selector(heading.where(body: [#get_translation(translated_terms.contents)]))
    .or(heading.where(body: [#get_translation(translated_terms.lof)]))
    .or(heading.where(body: [#get_translation(translated_terms.lot)]))
    .or(heading.where(body: [#get_translation(translated_terms.lol)]))
    .or(heading.where(body: [#get_translation(translated_terms.references)])): set heading(numbering: none)

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

  // Reset equation counter on level 1 headings
  show heading.where(level: 1): it => {
    counter(math.equation).update(0)
    it
  }

  // Configure list indentation
  set enum(indent: 10pt, body-indent: 6pt)
  set list(indent: 10pt, body-indent: 6pt)

  // ====================
  // Global Show Rules
  // ====================

  // Style headings
  show heading: it => {
    it
    v(12pt, weak: true)
  }

  // Style math equations and fonts
  show math.equation: set text(font: math_font, size: equation_size)
  show math.equation: eq => {
    set block(spacing: 1.5em)
    eq
  }

  // Style inline and block code
  show raw: set text(font: code_font)
  show raw.where(block: false): it => box(
    fill: luma(245),
    stroke: 0.5pt + luma(200),
    inset: (x: 3pt),
    outset: (y: 3pt),
    radius: 2pt,
  )[#it]

  show raw.where(block: true): it => {
    block(
      width: 100%,
      fill: luma(252),
      stroke: 0.5pt + luma(230),
      radius: 4pt,
      inset: 1em,
      clip: true,
    )[
      #if it.has("lang") [
        #set text(size: 0.7em, fill: accent_color.lighten(20%))
        #place(top + right, dx: 0.5em, dy: -0.5em)[#strong(upper(it.lang))]
      ]
      #it
    ]
  }

  // Style links, except for author names
  show link: it => {
    let author_names = authors.map(author => author.name)
    if it.body.has("text") and it.body.text in author_names {
      it // Display author links as-is
    } else {
      // Other links are underlined, dotted, offset, and colored
      underline(stroke: (dash: "densely-dotted"), offset: 2pt, text(fill: accent_color, it))
    }
  }

  // Style outline entries (Table of Contents)
  show outline.entry: it => {
    text(fill: accent_color, it)
  }

  // ====================
  // Document Structure
  // ====================

  // --- Title Page ---
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
  v(18pt, weak: true)

  if abstract != none {
    pad(x: 2em, [
      #set text(size: 0.9em)
      #text(weight: "bold")[Abstract:] #abstract
    ])
    v(12pt, weak: true)
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
        .join(", ", last: if authors.len() > 2 { ", and" } else { " and" })
    }))
  }
  v(6pt, weak: true)

  // Date
  let create_date(date, label) = {
    text(
      size: 11pt,
      [*#get_translation(translated_terms.at(label))*] + ": " + date.display("[month] / [day] / [year repr:full]"),
      fill: accent_color,
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

  v(18pt, weak: true)

  // --- Table of Contents and Lists ---

  if toc or lof or lot or lol {
    if toc {
      heading(level: 1, outlined: false)[#get_translation(translated_terms.contents)]
      outline(indent: auto, title: none, depth: toc_depth)
    }
    show heading.where(level: 1): set text(size: 0.9em)
    if lof {
      v(4pt)
      heading(level: 1)[#get_translation(translated_terms.lof)]
      outline(indent: auto, title: none, target: figure.where(kind: image))
    }
    if lot {
      v(4pt)
      heading(level: 1)[#get_translation(translated_terms.lot)]
      outline(indent: auto, title: none, target: figure.where(kind: table))
    }
    if lol {
      v(4pt)
      heading(level: 1)[#get_translation(translated_terms.lol)]
      outline(indent: auto, title: none, target: figure.where(kind: raw))
    }
  }

  v(2em, weak: true)

  // --- Main Body ---
  body

  // --- Bibliography ---
  if bibliography_file != none {
    v(24pt, weak: true)
    align(center)[#v(0.5em) * \* #sym.space.quad \* #sym.space.quad \* * #v(0.5em)]
    bibliography(bibliography_file, title: [#get_translation(translated_terms.references)], style: bibstyle)
  }
}

// =============================================================
// Boxes, Rules, and Environments
// =============================================================

// Default numbering settings for theorem environments
#let boxnumbering = "1.1.1.1.1.1"
#let boxcounting = "heading"

// A math box command
#let mathbox(content, higher: false) = {
  box(
    stroke: 0.5pt,
    inset: (x: 2pt, y: 1pt),
    outset: (x: 1pt, y: if higher { 8pt } else { 3pt }),
    baseline: if higher { 6pt } else { 1pt },
    if higher { $display(#content)$ } else { $#content$ },
  )
}

// --- Theorem-like Environments ---

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
        body-color: base-color.lighten(95%),
        footer-color: base-color.lighten(95%),
        radius: 0pt,
        thickness: 0pt,
      ),
      title-style: (
        color: base-color,
      ),
      footer-style: (
        color: base-color,
      ),
      ..args.named(),
      [
        #set text(fill: base-color)
        *#upper(identifier) #if numbered { [#number] } #if name != none { [(#name)] } *]
        + body,
    )
  },
).with(numbering: boxnumbering)

// Core logical structures
#let theorem = box_thm(
  "theorem",
  get_translation(translated_terms.theorem),
  rgb("#5d2f8e"),
)

#let corollary = box_thm(
  "corollary",
  get_translation(translated_terms.corollary),
  rgb("#5d2f8e"),
)

#let lemma = box_thm(
  "lemma",
  get_translation(translated_terms.lemma),
  rgb("#5d2f8e"),
)

#let proposition = box_thm(
  "proposition",
  get_translation(translated_terms.proposition),
  rgb("#5d2f8e"),
)

#let hypothesis = box_thm(
  "hypothesis",
  get_translation(translated_terms.hypothesis),
  rgb("#5d2f8e"),
)

#let definition = box_thm(
  "definition",
  get_translation(translated_terms.definition),
  rgb("#1a5fb4"),
)

#let example = box_thm(
  "example",
  get_translation(translated_terms.example),
  rgb("#26a269"),
)

#let note = box_thm(
  "note",
  get_translation(translated_terms.note),
  rgb("#626262"),
)

#let attention = box_thm(
  "attention",
  get_translation(translated_terms.attention),
  rgb("#c01c28"),
)

#let important = box_thm(
  "important",
  get_translation(translated_terms.important),
  rgb("#c01c28"),
)

#let exercise = box_thm(
  "exercise",
  get_translation(translated_terms.exercise),
  rgb("#e66100"),
)

#let tip = box_thm(
  "tip",
  get_translation(translated_terms.tip),
  numbered: false,
  rgb("#26a269"),
)

#let remark = box_thm(
  "remark",
  get_translation(translated_terms.remark),
  numbered: false,
  rgb("#626262"),
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


// =============================================================
// Useful functions
// =============================================================

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
#let mathbox(content) = {
  box(
    stroke: 0.5pt,
    inset: (x: 18pt, y: 5pt),
    outset: (x: 1pt, y: 8pt),
    baseline: 30pt,
    [$display(#content)$ ],
  )
}

// A centered math box to emphasize an observation
#let mathnote(content) = align(center)[(#content)]

