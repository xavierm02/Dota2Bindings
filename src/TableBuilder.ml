let fill_table ~(table:GPack.table) ~width ~height ~content  =
	for y = 0 to height - 1 do
		for x = 0 to width - 1 do
			match content x y with
			| Some widget -> table#attach ~left:x ~top:y widget
			| None -> ()
		done
	done

let fill_table_with_headers ~(table:GPack.table) ~width ~height ~content ~top_headers ~left_headers =
	fill_table
		~table:table
		~width:(width + 1)
		~height:(height + 1)
		~content:(fun x y ->
			match x, y with
			| 0, 0 -> None
			| _, 0 -> top_headers (x - 1)
			| 0, _ -> left_headers (y - 1)
			| _, _ -> content (x - 1) (y - 1)
		)
