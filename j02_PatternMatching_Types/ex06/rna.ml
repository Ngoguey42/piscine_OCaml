(* ************************************************************************** *)
(*                                                                            *)
(*                                                        :::      ::::::::   *)
(*   rna.ml                                             :+:      :+:    :+:   *)
(*                                                    +:+ +:+         +:+     *)
(*   By: ngoguey <ngoguey@student.42.fr>            +#+  +:+       +#+        *)
(*                                                +#+#+#+#+#+   +#+           *)
(*   Created: 2015/06/18 10:01:49 by ngoguey           #+#    #+#             *)
(*   Updated: 2015/06/18 10:13:31 by ngoguey          ###   ########.fr       *)
(*                                                                            *)
(* ************************************************************************** *)

type phosphate = string
type deoxyribose = string
type nucleobase = A | T | C | G | U | None
type nucleotide = phosphate * deoxyribose * nucleobase
type helix = nucleotide list
type rna = nucleobase list
					  
let generate_nucleotide c: nucleotide =
  match c with
  | 'A'						-> "phosphate", "deoxyribose", A
  | 'T'						-> "phosphate", "deoxyribose", T
  | 'C'						-> "phosphate", "deoxyribose", C
  | 'G'						-> "phosphate", "deoxyribose", G
  | _						-> "phosphate", "deoxyribose", None

let generate_helix n: helix =
  let get_nucleotide = function
	| 0						-> generate_nucleotide 'A'
	| 1						-> generate_nucleotide 'T'
	| 2						-> generate_nucleotide 'C'
	| _						-> generate_nucleotide 'G'
  in
  let rec generate_helix_helper n l =
	if n = 0 then
	  l
	else
	  generate_helix_helper (n - 1) (get_nucleotide (Random.int 4)::l)
  in
  Random.self_init ();
  if n < 0 then
	[]
  else
	generate_helix_helper n []

let helix_to_string (l: helix) =
  let base_to_string = function
	| A						-> "A"
	| T						-> "T"
	| C						-> "C"
	| G						-> "G"
	| _						-> "None"
  in
  let nucleotide_to_str (p, d, b) =
	p ^ " " ^ d ^ " " ^ base_to_string b ^ "; "
  in
  let rec helix_to_string_helper l s =
	match l with
	| []				-> s
	| hd::tl			-> helix_to_string_helper tl (nucleotide_to_str hd ^ s)
  in
  helix_to_string_helper l ""
						 
let complementary_helix (l: helix): helix=
  let rec revl src dst =
	match src with
	| []-> dst
	| hd::tl-> revl tl (hd::dst)
  in
  let complementary_base = function
	| A						-> T
	| T						-> A
	| C						-> G
	| G						-> C
	| _						-> None
  in
  let rec complementary_helix_helper l l' =
	match l with
	| []					-> l'
	| (p, d, b)::tl			-> complementary_helix_helper
								 tl ((p, d, complementary_base b) :: l')
  in
  revl (complementary_helix_helper l []) []

let generate_rna (l : helix): rna =
  let rec revl src dst =
	match src with
	| []-> dst
	| hd::tl-> revl tl (hd::dst)
  in
  let complementary_base = function
	| A						-> U
	| T						-> A
	| C						-> G
	| G						-> C
	| _						-> None
  in
  let rec generate_rna_helper l l' =
	match l with
	| []					-> l'
	| (p, d, b)::tl			-> generate_rna_helper
								 tl (complementary_base b :: l')
  in
  revl (generate_rna_helper l []) []
  
let rna_to_string (l: rna) =
  let base_to_string = function
	| A						-> "A"
	| U						-> "U"
	| C						-> "C"
	| G						-> "G"
	| _						-> "None"
  in
  let rec rna_to_string_helper l s =
	match l with
	| []				-> s
	| hd::tl			-> rna_to_string_helper tl (base_to_string hd ^ s)
  in
  rna_to_string_helper l ""
						 
	   
let test n =
  let l = generate_helix n in
  let s = helix_to_string l in
  Printf.printf "Test with [n = %d]:\n     generate+tostring: \027[35m%s\027[0m\n%!" n s;
  let l' = generate_rna l in
  let s' = rna_to_string l' in
  Printf.printf " generate_rna+tostring: \027[35m%s\027[0m\n%!" s';
  Printf.printf "\n%!"


let () =
  test (-1);
  test 0;
  test 1;
  test 2;
  test 3;
