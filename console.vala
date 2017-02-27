using Gtk;

public class Console : Gtk.Window{
    public Console(){

        //window properties
        this.title = "Intergrated Console";
        this.destroy.connect(Gtk.main_quit);
        this.set_default_size(950, 330);
        this.border_width = 2;
		this.window_position = Gtk.WindowPosition.CENTER;

        //window interface
        init_ui();

        //show everything
        this.show_all();

    }

    public void init_ui(){

        //create a box for layout container
        Gtk.Box box = new Gtk.Box(Gtk.Orientation.VERTICAL, 10);

        //create text input box



        //create multiline textbox for console output/response


        
    }

    public void main(string[] args){
        Gtk.init(ref args);
        new Console();
        Gtk.main();
    }
}