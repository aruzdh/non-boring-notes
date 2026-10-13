#let get_translation(translations) = {
  if type(translations) != dictionary { return translations }
  return context {
    let current_lang = if text.lang != none and text.lang in translations {
      text.lang
    } else {
      "en"
    }

    let localized_string = translations.at(current_lang, default: translations.at("en", default: ""))
    if localized_string == "" and "en" in translations {
      localized_string = translations.at("en")
    }
    return localized_string
  }
}

#let translated_terms = (
  contents: (
    de: "Inhaltsverzeichnis",
    en: "Contents",
    es: "Contenido",
  ),
  references: (
    de: "Quellen",
    en: "References",
    es: "Referencias",
  ),
  chapter: (
    de: "Kapitel",
    en: "Chapter",
    es: "Capítulo",
  ),
  lof: (
    de: "Abbildungsverzeichnis",
    en: "List of Figures",
    es: "Índice de Figuras",
  ),
  lot: (
    de: "Tabellenverzeichnis",
    en: "List of Tables",
    es: "Índice de Tablas",
  ),
  lecture: (
    de: "Vorlesung",
    en: "Lecture",
    es: "Clase",
  ),
  lol: (
    de: "Quellcodeverzeichnis",
    en: "List of Listings",
    es: "Índice de Listados",
  ),
  created: (
    de: "Erstellt",
    en: "Created",
    es: "Creado",
  ),
  last_updated: (
    de: "Zuletzt aktualisiert",
    en: "Last updated",
    es: "Última actualización",
  ),
  abstract: (
    de: "Zusammenfassung",
    en: "Abstract",
    es: "Resumen",
  ),
  conjunction: (
    de: "und",
    en: "and",
    es: "y",
  ),
  assumption: (
    de: "Annahme",
    en: "Assumption",
    es: "Suposición",
  ),
  attention: (
    de: "Achtung",
    en: "Attention",
    es: "Atención",
  ),
  axiom: (
    de: "Axiom",
    en: "Axiom",
    es: "Axioma",
  ),
  caution: (
    de: "Vorsicht",
    en: "Caution",
    es: "Precaución",
  ),
  conclusion: (
    de: "Fazit",
    en: "Conclusion",
    es: "Conclusión",
  ),
  corollary: (
    de: "Korollar",
    en: "Corollary",
    es: "Corolario",
  ),
  definition: (
    de: "Definition",
    en: "Definition",
    es: "Definición",
  ),
  example: (
    de: "Beispiel",
    en: "Example",
    es: "Ejemplo",
  ),
  exercise: (
    de: "Übung",
    en: "Exercise",
    es: "Ejercicio",
  ),
  hypothesis: (
    de: "Hypothese",
    en: "Hypothesis",
    es: "Hipótesis",
  ),
  important: (
    de: "Wichtig",
    en: "Important",
    es: "Importante",
  ),
  lemma: (
    de: "Lemma",
    en: "Lemma",
    es: "Lema",
  ),
  note: (
    de: "Hinweis",
    en: "Note",
    es: "Nota",
  ),
  postulate: (
    de: "Postulat",
    en: "Postulate",
    es: "Postulado",
  ),
  problem: (
    de: "Problem",
    en: "Problem",
    es: "Problema",
  ),
  proof: (
    de: "Beweis",
    en: "Proof",
    es: "Demostración",
  ),
  property: (
    de: "Eigenschaft",
    en: "Property",
    es: "Propiedad",
  ),
  proposition: (
    de: "Proposition",
    en: "Proposition",
    es: "Proposición",
  ),
  quote: (
    de: "Zitat",
    en: "Quote",
    es: "Cita",
  ),
  remark: (
    de: "Bemerkung",
    en: "Remark",
    es: "Observación",
  ),
  solution: (
    de: "Lösung",
    en: "Solution",
    es: "Solución",
  ),
  theorem: (
    de: "Satz",
    en: "Theorem",
    es: "Teorema",
  ),
  tip: (
    de: "Tipp",
    en: "Tip",
    es: "Consejo",
  ),
  warning: (
    de: "Warnung",
    en: "Warning",
    es: "Advertencia",
  ),
  topic: (
    de: "Thema",
    en: "Topic",
    es: "Tema",
  ),
  unit: (
    de: "Einheit",
    en: "Unit",
    es: "Unidad",
  ),
  question: (
    de: "Frage",
    en: "Question",
    es: "Pregunta",
  ),
)

// Joins items with commas and a translated "and" before the last one.
// Only English uses a serial comma ("A, B, and C").
#let join_with_and(items) = context {
  let lang = if text.lang in translated_terms.conjunction { text.lang } else { "en" }
  let conjunction = translated_terms.conjunction.at(lang)
  let last = if lang == "en" and items.len() > 2 { ", " + conjunction } else { conjunction }
  items.join(", ", last: last)
}
