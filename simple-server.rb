require 'socket'               # Get sockets from stdlib

server = TCPServer.open(8686)  # Socket to listen on port 2000
loop {                         # Servers run forever
  client = server.accept       # Wait for a client to connect
  data = client.gets()  # Send the time to the client
  puts data
}
  
