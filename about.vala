public class ServerControllerAboutDialog : Gtk.Window{
    public ServerControllerAboutDialog{
        this.set_title = "About ServerController";
        this.destroy.connect(Gtk.main_quit);
        this.set_default_size(950, 630);
        this.border_width = 2;
		this.window_position = Gtk.WindowPosition.CENTER;
    }
}

int main(string[] args){
    Gtk.init(ref args);
    new ServerController();
    Gtk.main();
    return 0;
}