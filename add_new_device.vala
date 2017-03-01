public class AddDialog : Gtk.Dialog {
	private Gtk.Entry name_entry;
	private Gtk.Entry ip_entry;

	public AddDialog () {
		this.title = "Add New";
		this.border_width = 5;
		set_default_size (350, 100);
		create_widgets ();
	}

	private void create_widgets () {
		// Create and setup widgets
		this.name_entry = new Gtk.Entry ();
		this.ip_entry = new Gtk.Entry ();
		Gtk.Label name_label = new Gtk.Label.with_mnemonic ("_Device Name:");
		name_label.mnemonic_widget = this.name_entry;
		Gtk.Label ip_label = new Gtk.Label.with_mnemonic   ("_IP Address: ");
		ip_label.mnemonic_widget = this.ip_entry;

		// Layout widgets
		Gtk.Box hbox = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 20);
		hbox.pack_start (name_label, false, true, 0);
		hbox.pack_start (this.name_entry, true, true, 0);

		//create a second horizontal box for ip and label
		Gtk.Box hboxtwo = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 20);
		hboxtwo.pack_start (ip_label, false, true, 0);
		hboxtwo.pack_start (this.ip_entry, true, true, 0);

		//create button
		Gtk.Button add = new Gtk.Button.with_label("Add Device");

		//pack it all
		Gtk.Box content = get_content_area () as Gtk.Box;
		content.pack_start (hbox, false, true, 0);
		content.pack_start (hboxtwo, false, true, 0);
		content.pack_end(add, false, false, 0);
		content.spacing = 10;


		// Add buttons to button area at the bottom
		add.clicked.connect(() => {

			//get the text and write method
			string name = name_entry.get_text();
			string ip = ip_entry.get_text();
			write_device(name, ip);
		});
		
	}

	private void write_device (string name, string ip) {
		try{
			//get the devices directory from the settings methods
			Settings settings = new Settings();
			string directory = settings.retrieve_data("default_devices_directory");
			string full_file_path = directory.concat(ip);

			//create a new file
			var new_device_file = File.new_for_path(full_file_path);

			if(new_device_file.query_exists()){
				//create message box showing error if file already exists...
				Gtk.MessageDialog msg = new Gtk.MessageDialog (this, Gtk.DialogFlags.MODAL, Gtk.MessageType.ERROR, Gtk.ButtonsType.OK, "Device file already exists. Please try again.");
				msg.show ();
				msg.response.connect ((response_id) => {
					if(response_id == Gtk.ResponseType.OK){
						
						//kill message box and window.
						msg.destroy();
					}
				});
			}else{

				//output the data and exit dialog
				var dos = new DataOutputStream (new_device_file.create (FileCreateFlags.REPLACE_DESTINATION));

				dos.put_string(name);
				dos.put_string("\n72");

				//hide dialog window...
				Gtk.main_quit();
			}

		}catch(Error e){
			warning("");
		}
	}

	public static void main_win (string[] args) {
		Gtk.init (ref args);

		AddDialog dialog = new AddDialog ();
		dialog.destroy.connect (() => {
			dialog.destroy();
		});

		dialog.show_all ();

		Gtk.main ();
	}
}