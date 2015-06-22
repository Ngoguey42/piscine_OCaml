(* ************************************************************************** *)
(*                                                                            *)
(*                                                        :::      ::::::::   *)
(*   micronap.ml                                        :+:      :+:    :+:   *)
(*                                                    +:+ +:+         +:+     *)
(*   By: ngoguey <ngoguey@student.42.fr>            +#+  +:+       +#+        *)
(*                                                +#+#+#+#+#+   +#+           *)
(*   Created: 2015/06/22 10:27:35 by ngoguey           #+#    #+#             *)
(*   Updated: 2015/06/22 10:51:18 by ngoguey          ###   ########.fr       *)
(*                                                                            *)
(* ************************************************************************** *)

(*
ocamlopt unix.cmxa micronap.ml && ./a.out NUMBER
*)

let my_sleep () = Unix.sleep 1

let dosleep t =
  for i = 1 to t do
	my_sleep ()
  done

let read_input str =
  let t = int_of_string str in
  if t < 0 then
	failwith (str ^ " is negative")
  else
	dosleep t
  
let () =
  try
	begin
	  let input = Sys.argv.(1) in
	  read_input input
	end
  with
  | Invalid_argument m
	-> print_endline ("Catched \"" ^ m ^ "\" please give some arguments")
  | Failure "int_of_string"
	-> print_endline ("Catched \"" ^ "int_of_string" ^ "\" please give a number")
  | Failure m
	-> print_endline ("Catched \"" ^ m ^ "\" please give a positive number")