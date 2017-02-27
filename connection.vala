public class Connection {

    public bool create_socket_second_connection(string device_ip){
        //create socket for single second connection...
        var client_connection = new SocketClient();

        try{
            var resolver = Resolver.get_default ();
            var addresses = resolver.lookup_by_name (device_ip, null);
            var address = addresses.nth_data (0);

            stdout.printf("Attempting connection...\n\n");

            //create the socket... eventually will all be multi-threaded...
            //had to hard code the port in as i kept getting errors complaining about converting "method" to uint16
            //feel free to help me out...
            var connected = client_connection.connect (new InetSocketAddress (address, 8686));

            //success
            stdout.printf("Connection successful");

            var message = @"Connection test with servercontroller for elementaryOS\r\n";
            connected.output_stream.write (message.data);

            return true;
        }catch(Error error_message){
            stdout.printf("Unable to create socket connection: Code line 18, file connection.vala - client = %s \n", device_ip);   
        }

        //add conditional to check socket has been created correctly

        return false;
    }
}