#import "lib.typ": *

#show: template.with(
  title: [Non-boring notes],
  authors: (
    (
      name: "Aru",
      link: "https://aruzdh.dev",
    ),
  ),
  paper_size: "us-letter",
  updated_date: false,
  toc: false,
  cols: 1,
  show_prefix: false,
  show_numbering: false,
  text_lang: "en",
)

#include "./content/collections/collection1.typ"

