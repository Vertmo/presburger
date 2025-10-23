(lang dune 3.17)
(using coq 0.10)

(name presburger)

(generate_opam_files true)

(source
 (github username/reponame))

(authors "Author Name <author@example.com>")

(maintainers "Maintainer Name <maintainer@example.com>")

(license LICENSE)

(documentation https://url/to/documentation)

(package
 (name presburger)
 (synopsis "Presburger's algorithm")
 (description "A formalisation of Presburger's algorithm")
 (depends ocaml rocq-prover)
 (allow_empty)
 (tags
  ("presburger" "rocq")))

; See the complete stanza docs at https://dune.readthedocs.io/en/stable/reference/dune-project/index.html
