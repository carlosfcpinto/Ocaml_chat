open Lwt
open Lwt_unix

let addr_of_input addr =
  let l = String.split_on_char ':' addr in 
  if List.length l = 1 then 
    let port = int_of_string (List.nth l 0) in 
    ADDR_INET (Unix.inet_addr_loopback, port)
  else 
    let listen_addr = Unix.inet_addr_of_string (List.nth l 0) in 
    let port = int_of_string (List.nth l 1) in 
    ADDR_INET (listen_addr, port)

let connection sock addr= 
  catch (function () ->
    connect sock addr)
  (function Unix.Unix_error _ -> failwith "Unable to bind address to socket" |e -> fail e)

let client () =
  let sock = (socket PF_INET SOCK_STREAM 0) in 
  Lwt_io.write_line Lwt_io.stdout 
  "Write an address (127.0.0.1:8800) or port (8800)\nIf nothing is written default is 127.0.0.1:8800" >>= fun _ -> 
  Lwt_io.read_line_opt Lwt_io.stdin >>= fun address ->
  let final = match address with Some addr -> addr_of_input addr |None -> (ADDR_INET (Unix.inet_addr_loopback, 8800)) in 
  connection sock final >>=
  fun _ ->
    Overlap.handle_connection sock


