using Gtk;

public class ServerController : Gtk.Window {
    public TreeIter iter;
    public Gtk.Entry status = new Gtk.Entry();

    private string get_data(string data_type, string device){

        Settings settings = new Settings();
        string file_location = settings.retrieve_data("default_devices_directory");
        string file = file_location.concat(device);
        string[2] file_lines = {};

        //read the device file and return the data for display purposes...
        try{
            File device_file = File.new_for_path(file);

            FileInputStream @is = device_file.read ();
            DataInputStream dis = new DataInputStream(@is);
            string line;

            while((line = dis.read_line()) != null){
                file_lines += line;
            }

        }catch(Error file_error){
            stdout.printf("%s", file_error.message);
        }

        if(data_type == "name"){
            return file_lines[0];
        }else{
            return file_lines[1];
        }
    }

    private string[] list_devices(){
        string[] files = {};

        //create settings objec
        Settings settings = new Settings();
        string file_location = settings.retrieve_data("default_devices_directory");

        try{

            //create a connection with the client
            //if connection successful then
            //add the name to file array
            Connection connect = new Connection();

            string name;
            var d = Dir.open(file_location);
            while ((name = d.read_name()) != null) {
                
                if(connect.create_socket_second_connection(name)){

                    files += name;

                }
            }

        }catch(Error e){
            stdout.printf("%s", e.message);
        }

        //return the files so we can get the data and list it
        return files;

    }

    private void devices_online(Gtk.ListStore listmodel){
        //clear the listview
        listmodel.clear();

        //list of devices returned after connection check
        string[] devices = list_devices();


        //loop through the devices getting the data and adding the device
        //to the listview GUI
        foreach (var device in devices) {    

            string name = get_data("name", device);
            string ping = get_data("ping", device);


            listmodel.append (out iter);
            listmodel.set (iter, 0, name, 1, device, 2, ping);
        }
        
    }

    public ServerController(){

        //create elementaryOS header bar
        var header = new Gtk.HeaderBar();
        header.set_show_close_button(true);
        header.set_title("ServerController");
        header.set_subtitle("Remote System Controller");

        //create a grid for header buttons
        Gtk.Grid headerLayout = new Gtk.Grid();


        //add new device button to header bar
        Gtk.Image new_icon = new Gtk.Image.from_icon_name("list-add",IconSize.SMALL_TOOLBAR);
        Gtk.ToolButton new_device = new Gtk.ToolButton(new_icon, "Add New Device");
        new_device.is_important = true;


        new_device.clicked.connect(() => {
            AddDialog add_new = new AddDialog();
            add_new.main_win({});
            status.set_text("Attempting to add device... Refeshing live clients.");
        });        
        headerLayout.attach(new_device, 0 , 0 , 1, 1);

        //add refresh button to the header bar
        Gtk.Image refresh_icon = new Gtk.Image.from_icon_name("view-refresh",IconSize.SMALL_TOOLBAR);
        Gtk.ToolButton refresh = new Gtk.ToolButton(refresh_icon, "Refresh Devices");
        refresh.is_important = true;
        //refresh.clicked.connect(
        //    connection.devices_online(iter);
        //);
        headerLayout.attach(refresh, 1 , 0 , 1, 1);

        header.add(headerLayout);


        //window controls
        this.set_titlebar(header);
        this.destroy.connect(Gtk.main_quit);
        this.set_default_size(950, 630);
        this.border_width = 2;
		this.window_position = Gtk.WindowPosition.CENTER;

        init_ui();

        //SHOW EVERTTHING
        this.show_all();
    }

    private void init_ui(){

        //create box layout
        Gtk.Box box = new Gtk.Box(Gtk.Orientation.VERTICAL, 10);

        //create list for the devices to be displayed
        var view = new TreeView ();
        Gtk.ListStore listmodel = new Gtk.ListStore (4, typeof (string), typeof (string), typeof (string), typeof (string));
        view.set_model (listmodel);


        //create label widget
        // Added the status box first so im able to update
        // the label once the connections thread has completed.
        Gtk.Entry status = new Gtk.Entry();
        status.set_text("loading clients...");
        status.set_editable(false);

        //give a class to the statusstrip
        status.get_style_context().add_class("statusStrip");

        //add status bar to the box(end)
        box.pack_end(status, false, false, 0);

        //create column titles
        view.insert_column_with_attributes (-1, "Device Name                  ", new CellRendererText (), "text", 0);
        view.insert_column_with_attributes (-1, "IP Address", new CellRendererText (), "text", 1);
        view.insert_column_with_attributes (-1, "Ping(ms)", new CellRendererText (), "text", 2);

        var cell = new CellRendererText ();
        cell.set ("foreground_set", true);

        if(Thread.supported()){        
            //need to create a thread to run this method so gui can load whilst the connections are being tested.
                
            try {
                
                Thread<void*> thread = new Thread<void*>.try ("Conntections Thread.", () => { 

                    //run the devices_online function to check who's listening
                    devices_online (listmodel);

                    //update the status bar text
                    status.set_text("Fetched online clients. Awaiting commands..."); 

                    //return null
                    return null;
                });

            }catch(Error thread_error){

                //console print thread error message
                warning("%s", thread_error.message);
            }	

        }else{

            //create message box showing error
            Gtk.MessageDialog msg = new Gtk.MessageDialog (this, Gtk.DialogFlags.MODAL, Gtk.MessageType.ERROR, Gtk.ButtonsType.OK, "Multi threading not supported. Unable to load clients.");
    		msg.show ();
            msg.response.connect ((response_id) => {
                if(response_id == Gtk.ResponseType.OK){
                    
                    //kill message box and window.
                    msg.destroy();
                    Gtk.main_quit();
                }
		    });

        }

        //add the listview to the box for display
        box.pack_start(view, true, true, 0);

        this.add(box);
    }   
}

int main(string[] args){
    Gtk.init(ref args);

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

    new ServerController();
    Gtk.main();
    return 0;
}