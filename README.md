# Ocaml_chat

### OCaml and Dune Version

Using OCaml 5.0.0, and Dune 2.0.
Makes extensive use of the Lwt and Unix modules.

### Building

Should be built using the command 

`dune build`

### Running

`dune exec test_task <mode>`
`mode` can be either `client` or `server`.
If `client` is selected, a prompt is encountered to input an address of type `127.0.0.1:8800` or simply a port, `8800`.
`server` mode uses port `8800` by default.
