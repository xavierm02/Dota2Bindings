open Batteries
open Command

let locale = GtkMain.Main.init ()

let main () =
	let window = GWindow.window
		~width:(Gdk.Screen.width ())
		~height:(Gdk.Screen.height ())
		~allow_shrink:true
		~title:"Test" (* TODO *)
		()
	in

	window#connect#destroy ~callback:GMain.Main.quit |> ignore;

	let vbox = GPack.vbox () in
	window#add vbox#coerce;

	let open MenuBuilder in begin
		add_menu_bar ~packing:vbox#pack [
			submenu
				~text: "File"
				~content: [
					item
						~text: "Open"
						~callback: (fun () -> ()) (* TODO *)
					;
					item
						~text: "Exit"
						~callback: GMain.Main.quit
				]
			;
			submenu
				~text: "Edit"
				~content: [] (* TODO *)
		]
	end;
	
	let current_button = ref None in
	
	let notebook = GPack.notebook () in
	vbox#pack notebook#coerce;
	
	let _abilities_tab = begin
		let tab = GPack.vbox () in
		let button = GButton.button () in
		tab#pack button#coerce;
		notebook#append_page tab#coerce
	end in
	
	let _items_tab = begin
		let tab = GPack.vbox () in
		let button = GButton.button () in
		tab#pack button#coerce;
		notebook#append_page tab#coerce
	end in
	
	let _test_tab = begin
		let tab = GPack.table () in
		TableBuilder.fill_table_with_headers
			~table:tab
			~width:Ability.length
			~height:CastMethod.length
			~content:(fun x y ->
				let label = Printf.sprintf "%d %d" x y in
				let button = GButton.button ~label:label () in
				button#connect#pressed (fun _ -> current_button := Some (button, x, y)) |> ignore;
				button#connect#released (fun _ -> current_button := None) |> ignore;
				Some button#coerce
			)
			~top_headers:(fun x -> Some (GMisc.label ~text:(x |> Ability.of_index |> Ability.to_string) ())#coerce)
			~left_headers:(fun x -> Some (GMisc.label ~text:(x |> CastMethod.of_index |> CastMethod.to_string) ())#coerce);
		notebook#append_page tab#coerce
	end in
	notebook#goto_page _test_tab;

	window#show ();
	GMain.Main.main ()

let () = main ()
