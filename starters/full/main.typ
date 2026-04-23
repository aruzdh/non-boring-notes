#import "lib.typ": *

#show: template.with(
  title: [Non-boring notes],
  subtitle: [A clean and modular Typst template],
  short_title: "Usual Notes",
  description: [An usual description],
  abstract: [
    This template provides a robust structure for taking notes, whether they are for lectures,
    chapters, or personal projects. It features color-coded environments, and a modular content
    system.
  ],
  creation_date: datetime(year: 2025, month: 08, day: 11),
  authors: (
    (
      name: "Aru",
      link: "https://aruzdh.dev",
    ),
  ),
  bibliography_file: "./bibliography/bibliography.bib",
  paper_size: "us-letter",
  cols: 1,
  h1_prefix: "lecture", // chapter or lecture
  text_lang: "en",
)

#include "./content/collections/collection1.typ"

