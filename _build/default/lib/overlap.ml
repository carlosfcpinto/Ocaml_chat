open Lwt

let reader input_channel output_channel =
  let rec read_loop () =
   catch (fun () -> 
      Lwt_io.read_line_opt input_channel >>=
        fun msg ->
          match msg with 
          |Some m ->if m = "Message received " then 
                      Lwt_io.printl (m ^ " Roundtrip time = " ^ (string_of_float (Time.get ()))) >>=
                        fun _ -> Time.reset (); read_loop ()
                    else
                      Lwt_io.printl m >>= fun _ ->
                      Lwt_io.write_line output_channel "Message received " >>=
                      fun _ -> read_loop()
          |None -> return_unit )
    (function Unix.Unix_error _ -> fail_with "Error when reading" |e -> fail e)
  in read_loop ()

let write_to_socket output_channel = 
  let rec write_loop () =
    catch (fun() -> 
      Lwt_io.read_line Lwt_io.stdin >>= 
      fun msg -> 
      Lwt_io.write_line output_channel msg  >>= 
      fun _ -> 
        Time.outgoing (); write_loop ())
    (function Unix.Unix_error _ -> fail_with "Error when writing" |e -> fail e)
  in write_loop ()

let handle_connection file_descriptor =
  let input_channel = Lwt_io.of_fd ~mode:Lwt_io.Input file_descriptor in
  let output_channel = Lwt_io.of_fd ~mode:Lwt_io.Output file_descriptor in
  let connection_loop () =
      choose [
        reader input_channel output_channel;
        write_to_socket output_channel;
      ]
  in connection_loop () 

