open Batteries

let read_lines input =
	let l = ref [] in
	try
		while true do
			l := input_line input :: !l
		done;
		failwith "Exited while true loop!"
	with
	| End_of_file -> List.rev !l

let () =
	let elements = read_lines stdin in
	let p = print_endline in
	
	p "type t =";
	elements |> List.iter (fun e -> p ("\t| " ^ e));
	p "";
	
	p "let elements = [|";
	p ("\t" ^ String.concat ";\n\t" elements);
	p "|]";
	p "";
	
	p "let length = Array.length elements";
	p "";
	
	p "let max_index = length - 1";
	p "";
	
	p "let of_index i =";
	p "\tassert(0 <= i && i <= max_index);";
	p "\telements.(i)";
	p "";
	
	p "let to_index e = function";
	elements |> List.iteri (fun i e -> p ("\t| " ^ e ^ " -> " ^ (string_of_int i)));
	p "";
	
	p "let of_string s = function";
	elements |> List.iter (fun e -> p ("\t| \"" ^ (String.escaped e) ^ "\" -> " ^ e));
	p "\t| _ -> assert false";
	p "";
	
	p "let to_string e = function";
	elements |> List.iter (fun e -> p ("\t| " ^ e ^ " -> \"" ^ (String.escaped e) ^ "\""));
	p ""

