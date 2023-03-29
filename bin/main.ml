exception NotValidChoice
open Test_task

let () =
  let choice = Sys.argv.(1) in
  let r =
    match choice with
    | "server" -> Server.server ()
    | "client" -> Client.client ()
    | _ -> raise NotValidChoice
  in
  Lwt_main.run r |> ignore
