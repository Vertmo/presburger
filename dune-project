(lang dune 3.17)
(using coq 0.10)

(name presburger)

(generate_opam_files true)

(source
 (github vertmo/presburger))

(authors "Hugo Herbelin"
         "Maxime Dénès"
         "Pierre-Marie Pédrot"
         "Pierre Letouzey"
         "Basile Pesin")

(maintainers "Basile Pesin <basile.pesin@vertmo.org>")

(license LICENSE)

(package
 (name presburger)
 (synopsis "Presburger's algorithm")
 (description "A formalisation of Presburger's algorithm")
 (depends ocaml rocq-prover)
 (allow_empty)
 (tags
  ("presburger" "rocq")))

; See the complete stanza docs at https://dune.readthedocs.io/en/stable/reference/dune-project/index.html
