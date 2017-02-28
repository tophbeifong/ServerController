public class ServerControllerAboutDialog : Gtk.Window{
    public ServerControllerAboutDialog(){
        this.title = "About";
        this.destroy.connect(Gtk.main_quit);
        this.set_default_size(350, 380);
        this.border_width = 10;
		this.window_position = Gtk.WindowPosition.CENTER;

        init_ui();
    }

    private void init_ui(){

        //create box layout
        Gtk.Box box = new Gtk.Box(Gtk.Orientation.VERTICAL, 0);

        //all widgets, box will do fine as i only want a vertical layout.
        Gtk.Label header = new Gtk.Label("ServerController");
        Gtk.Label main_text = new Gtk.Label("A remote system control application build for elementaryOS.");
        Gtk.Label version = new Gtk.Label("Version 0.0.1(active development)");
        Gtk.Button close = new Gtk.Button.with_label("Close");

        header.get_style_context().add_class("headerLabel");

        //functionallity for the close button
        close.clicked.connect(Gtk.destroy);

        //add widgets to the box
        box.pack_start(header, false, false, 0);
        box.pack_start(main_text, false, false, 20);
        box.pack_start(version, false, false, 0);
        box.pack_end(close, false, false, 15);

        this.add(box);

        this.show_all();

    }
}

int main(string[] args){
    Gtk.init(ref args);

    //Settings settings = new Settings();

    var css_provider = new Gtk.CssProvider();
    try{
        //css stylesheet...
        css_provider.load_from_path("settings/styles.css"/*settings.retrieve_data("custom_styles_directory")*/);
    }catch(Error e){
        warning("%s", e.message);
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