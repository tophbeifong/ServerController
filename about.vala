public class ServerControllerAboutDialog : Gtk.Window{
    public ServerControllerAboutDialog(){
        this.title = "About";
        this.destroy.connect(Gtk.main_quit);
        this.set_default_size(550, 400);
        this.border_width = 2;
		this.window_position = Gtk.WindowPosition.CENTER;

        init_ui();
    }

    private void init_ui(){

        //create box layout
        Gtk.Box box = new Gtk.Box(Gtk.Orientation.VERTICAL, 150);

        Settings settings = new Settings();

        //all widgets, box will do fine as i only want a vertical layout.
        Gtk.Label header = new Gtk.Label("ServerController");
        Gtk.Label main_text = new Gtk.Label("A remote system control application build for elementaryOS by ");
        Gtk.Label version = new Gtk.Label("Version 0.0.1(active development)");
        Gtk.Button close = new Gtk.Button.with_label("Close");

        //functionallity for the close button
        close.clicked.connect(Gtk.main_quit);

        //add widgets to the box
        box.pack_start(header);
        box.pack_start(main_text);
        box.pack_start(version);
        box.pack_end(close, false, false, 15);

        this.add(box);

        this.show_all();

    }
}

int main(string[] args){
    Gtk.init(ref args);

    var css_provider = new Gtk.CssProvider();
    try{
        //struggling to find the styles file... :/
        css_provider.load_from_path("settings/styles.css");
    }catch(Error e){
        warning("No Styles...");
    }

    Gtk.StyleContext.add_provider_for_screen(
        Gdk.Screen.get_default(),
        css_provider,
        Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION
    );

    new ServerControllerAboutDialog();
    Gtk.main();
    return 0;
}