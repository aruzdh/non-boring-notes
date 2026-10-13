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
    en: "Contents",
    es: "Contenido",
    it: "Indice",
  ),
  references: (
    en: "References",
    es: "Referencias",
    it: "Riferimenti bibliografici",
  ),
  chapter: (
    en: "Chapter",
    es: "Capítulo",
    it: "Capitolo",
  ),
  lof: (
    en: "List of Figures",
    es: "Índice de Figuras",
    it: "Indice delle figure",
  ),
  lot: (
    en: "List of Tables",
    es: "Índice de Tablas",
    it: "Indice delle tabelle",
  ),
  lecture: (
    en: "Lecture",
    es: "Clase",
    it: "Lezione",
  ),
  lol: (
    en: "List of Listings",
    es: "Índice de Listados",
    it: "Indice dei listati",
  ),
  created: (
    en: "Created",
    es: "Creado",
    it: "Creato",
  ),
  last_updated: (
    en: "Last updated",
    es: "Última actualización",
    it: "Ultimo aggiornamento",
  ),
  assumption: (
    en: "Assumption",
    es: "Suposición",
    it: "Assunzione",
  ),
  attention: (
    en: "Attention",
    es: "Atención",
    it: "Attenzione",
  ),
  axiom: (
    en: "Axiom",
    es: "Axioma",
    it: "Assioma",
  ),
  caution: (
    en: "Caution",
    es: "Precaución",
    it: "Prudenza",
  ),
  conclusion: (
    en: "Conclusion",
    es: "Conclusión",
    it: "Conclusione",
  ),
  corollary: (
    en: "Corollary",
    es: "Corolario",
    it: "Corollario",
  ),
  definition: (
    en: "Definition",
    es: "Definición",
    it: "Definizione",
  ),
  example: (
    en: "Example",
    es: "Ejemplo",
    it: "Esempio",
  ),
  exercise: (
    en: "Exercise",
    es: "Ejercicio",
    it: "Esercizio",
  ),
  hypothesis: (
    en: "Hypothesis",
    es: "Hipótesis",
    it: "Ipotesi",
  ),
  important: (
    en: "Important",
    es: "Importante",
    it: "Importante",
  ),
  lemma: (
    en: "Lemma",
    es: "Lema",
    it: "Lemma",
  ),
  note: (
    en: "Note",
    es: "Nota",
    it: "Nota",
  ),
  postulate: (
    en: "Postulate",
    es: "Postulado",
    it: "Postulato",
  ),
  problem: (
    en: "Problem",
    es: "Problema",
    it: "Problema",
  ),
  proof: (
    en: "Proof",
    es: "Demostración",
    it: "Dimostrazione",
  ),
  property: (
    en: "Property",
    es: "Propiedad",
    it: "Proprietà",
  ),
  proposition: (
    en: "Proposition",
    es: "Proposición",
    it: "Proposizione",
  ),
  quote: (
    en: "Quote",
    es: "Cita",
    it: "Citazione",
  ),
  remark: (
    en: "Remark",
    es: "Observación",
    it: "Osservazione",
  ),
  solution: (
    en: "Solution",
    es: "Solución",
    it: "Soluzione",
  ),
  theorem: (
    en: "Theorem",
    es: "Teorema",
    it: "Teorema",
  ),
  tip: (
    en: "Tip",
    es: "Consejo",
    it: "Suggerimento",
  ),
  warning: (
    en: "Warning",
    es: "Advertencia",
    it: "Avvertimento",
  ),
  topic: (
    en: "Topic",
    es: "Tema",
    it: "Argomento",
  ),
  unit: (
    en: "Unit",
    es: "Unidad",
    it: "Unità",
  ),
  question: (
    en: "Question",
    es: "Pregunta",
    it: "Domanda",
  ),
)
