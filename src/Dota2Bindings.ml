open Batteries

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
  
  let vbox = GPack.vbox ~packing:window#add () in

  (* Menu bar *)
  let menubar = GMenu.menu_bar ~packing:vbox#pack () in
  let factory = new GMenu.factory menubar in
  let open MenuBuilder in
  MenuBuilder.build_menu_content factory [
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
  ];

  window#show ();
  GMain.Main.main ()

let () = main ()
