open Unix

let reset,outgoing,get =
  let cont = ref 0.0 in
  let r () = cont:= 0.0 in
  let o () = cont := gettimeofday () in
  let g () = gettimeofday() -. !cont in
  r,o,g
