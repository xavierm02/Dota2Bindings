type menu_item = {
	item_text: string;
	item_callback: unit -> unit
}

and menu_part =
  | Item of menu_item
  | Submenu of menu

and menu_content = menu_part list

and menu = {
	menu_text: string;
	menu_content: menu_content
};;

type unitunit = unit -> unit

let item
	~text: text
	~callback: callback
	=
	Item {
		item_text = text;
		item_callback = callback
	}

let submenu
	~text: text
	~content: content
	=
	Submenu {
		menu_text = text;
		menu_content = content
	}

let rec build_menu_content : 'a.  (#GMenu.menu_shell as 'a) GMenu.factory -> menu_content -> unit = fun factory menu_content ->
	menu_content |> List.iter (function
		| Item item -> factory#add_item item.item_text ~callback:item.item_callback |> ignore
		| Submenu submenu ->
			let subfactory = new GMenu.factory (factory#add_submenu submenu.menu_text) in
			build_menu_content subfactory submenu.menu_content
	)

	
