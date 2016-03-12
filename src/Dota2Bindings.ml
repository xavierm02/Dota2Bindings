open Batteries
open Types
open Sig
(*open Command*)
module HT = struct
	include Hashtbl
	include Hashtbl.Exceptionless
end

let locale = GtkMain.Main.init ()

let main () =
	let commands = Hashtbl.create 0 in
	
	let window = GWindow.window
		~width:(Gdk.Screen.width ())
		~height:(Gdk.Screen.height ())
		~allow_shrink:true
		~title:"Test" (* TODO *)
		()
	in

	window#connect#destroy ~callback:GMain.Main.quit |> ignore;
	
	let current_button = ref None in
	let current_keystroke = Hashtbl.create 0 in
	
	window#event#connect#key_press ~callback:(fun event ->
		begin
			match !current_button with
			| None -> ()
			| Some (button, _) ->
				begin
					button#set_label (GdkEvent.Key.string event) |> ignore
				
				end
		end;
		true
	) |> ignore;
	
	let keystroke_button command =
		let button = GButton.button
			~label:(command |> Command.to_string)
			()
		in
		button#connect#pressed (fun _ ->
			current_button := Some (button, command)
		) |> ignore;
		button#connect#released (fun _ ->
			()
		) |> ignore;
		button
	in
	
	window#event#connect#key_release ~callback:(fun _ -> current_button := None; true) |> ignore;
	
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
				let ability = Ability.of_index x in
				let button = keystroke_button (Ability (ability, Self)) in
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
