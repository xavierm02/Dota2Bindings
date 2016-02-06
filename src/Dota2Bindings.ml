open Batteries
open Ability

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
	
	let notebook = GPack.notebook () in
	vbox#pack notebook#coerce;
	
	let abilities_tab = begin
		let tab = GPack.vbox () in
		let button = GButton.button () in
		tab#pack button#coerce;
		tab
	end in
	notebook#append_page abilities_tab#coerce |> ignore;

	window#show ();
	GMain.Main.main ()

let () = main ()
