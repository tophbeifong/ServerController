using Json;

public class Settings{

    public string retrieve_data(string data_to_get){

        //return the selected data
        return settings_parse(data_to_get);
    }

    private string settings_parse(string data){
        try {

            //open and read the json file while storing the contents in a string variable
            string res = "";
            var file = File.new_for_path ("./settings/settings.json");

            //check the file exists
            if (file.query_exists ()) {
                var dis = new DataInputStream (file.read ());
                string line;

                while ((line = dis.read_line (null)) != null) {
                    res += line;
                }

                //parse the json file
                var parser = new Json.Parser ();
                parser.load_from_data (res);
                var root_object = parser.get_root ().get_object ();

                //the data we need to return
                string data_to_send_back = root_object.get_string_member (data);
                return data_to_send_back;
            }
        } catch (Error e) {
            stderr.printf ("%s\n", e.message);
        }

        //if inable to get the information return false message
        return "Unable to get data";
    }

}