public class ServerControllerAboutDialog : Gtk.Window{
    private void about_clicked() {
      var about = new AboutDialog();
      about.set_version("0.0.1");
      about.set_program_name("ServerController");
      about.set_comments("Remote server control application written in Vala for elementaryOS.");
      about.run();
      about.hide();
    }
}

int main(string[] args){
    new ServerControllerAboutDialog();
    about_clicked();
    return 0;
}