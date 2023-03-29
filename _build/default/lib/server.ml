open Lwt
open Lwt_unix

let create_socket port =
  catch (fun () ->
    let sock = socket PF_INET SOCK_STREAM 0 in 
    bind sock (ADDR_INET (Unix.inet_addr_loopback, port))>|= fun () ->
    listen sock 1;
    sock)
  (function Unix.Unix_error _ -> fail_with "Failed to create socket" |e -> fail e)

let create_server sock =
  let rec server_loop () =
  accept sock >>= fun (sock, sockaddress) -> 
    Lwt_io.printl (match Lwt_unix.state sock with Opened -> "Opened connection at " ^ (match sockaddress with |ADDR_UNIX a -> a |ADDR_INET (_,b) -> string_of_int b) 
    |Closed -> "Closed" |_ -> "Aborted") >>= fun _
  -> Overlap.handle_connection sock >>= fun _ -> Lwt_io.printl "Client closed connection" >>= fun _ -> server_loop () 
  in server_loop ()

let server () =
  (create_socket 8800 >>= fun socket -> 
  create_server socket)
