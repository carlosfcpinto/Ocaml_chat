(lang dune 2.0)

(name test_task)

(generate_opam_files false)

(source
 (github username/reponame))

(authors "Carlos Pinto")

(package
 (name test_task)
 (synopsis "Simple one-on-one chat")
 (description "Simple one-on-one chat written in OCaml, making extensive use of Lwt and Unix modules")
 (depends ocaml dune)
 (tags
  (topics "to describe" your project)))

