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

let type_description_of_lines lines =
	let split_spaces = Str.split (Str.regexp "[ |\t]+") in
	lines |> List.map (fun line ->
		match line |> split_spaces with
		| [c] -> (c, None)
		| [c; "of"; t] -> (c, Some t)
		| _ -> failwith "Bad format!"
	)

let () =
	let elements = read_lines stdin |> type_description_of_lines in
	let p = print_endline in
	
	p "open Batteries";
	p "";
	
	p "type t =";
	elements |> List.iter (function
		| (c, None) -> p ("\t| " ^ c)
		| (c, Some t) -> p ("\t| " ^ c ^ " of " ^ t ^ ".t")
	);
	p "";
	
	p "let elements = Array.concat [";
	elements
		|> List.map (function
			| (c, None) -> "[| " ^ c ^ " |]"
			| (c, Some t) -> "(" ^ t ^ ".elements |> Array.map (fun x -> " ^ c ^ " x))"
		)
		|> String.concat ";\n\t"
		|> (^) "\t"
		|> p;
	p "]";
	p "";
	
	p "let length = Array.length elements";
	p "";
	
	p "let max_index = length - 1";
	p "";
	
	p "let of_index i =";
	p "\tassert(0 <= i && i <= max_index);";
	p "\telements.(i)";
	p "";
	
	p "let constructor_index = function";
	elements |> List.iteri (fun i l ->
		match l with
		| (c, None) -> p ("\t| " ^ c ^ " -> " ^ (i |> string_of_int))
		| (c, Some _) -> p ("\t| " ^ c ^ " _ -> " ^ (i |> string_of_int))
	);
	p "";
	
	p "let constructor_start_index =";
	p "\tlet array = Array.make length 0 in";
	p "\tlet i = ref 0 in";
	elements |> List.iteri (fun i l ->
		let s = "\tarray.(" ^ (i |> string_of_int) ^ ") <- !i;" in
		match l with
		| (c, None) -> p (s ^ " incr i;")
		| (c, Some t) -> p (s ^ " i := !i + " ^ t ^ ".length;")
	);
	p "\tarray";
	p "";
	
	p "let index_in_subtype = function";
	elements |> List.iter (function
		| (c, None) -> p ("\t| " ^ c ^ " -> 0")
		| (c, Some t) -> p ("\t| " ^ c ^ " x -> x |> " ^ t ^ ".to_index")
	);
	p "";
	
	p "let to_index x = (constructor_start_index.(constructor_index x)) + (index_in_subtype x)";
	p "";
	
	p "let _ = assert (elements |> Array.for_all (fun x -> x |> to_index |> of_index = x))";
	p "";
	
	p "let of_string = function";
	elements |> List.iter (function
		| (c, None) -> p ("\t| \"" ^ (String.escaped c) ^ "\" -> " ^ c)
		| (c, Some t) -> ()
	);
	p "\t| s ->";
	p "\t\tlet c, x = String.split s \" \" in";
	p "\t\tmatch c with";
	elements |> List.iter (function
		| (c, None) -> ()
		| (c, Some t) -> p ("\t\t| \"" ^ (String.escaped c) ^ "\" -> " ^ c ^ " (x |> " ^ t ^ ".of_string)")
	);
	p "\t| _ -> assert false";
	p "";
	
	p "let to_string = function";
	elements |> List.iter (function
		| (c, None) -> p ("\t| " ^ c ^ " -> \"" ^ (String.escaped c) ^ "\"")
		| (c, Some t) -> p ("\t| " ^ c ^ " x -> \"" ^ (String.escaped c) ^ " \" ^ (x |> " ^ t ^ ".to_string)")
	);
	p "";
	
	p "let _ = assert (elements |> Array.for_all (fun x -> x |> to_string |> of_string = x))";
	p ""

