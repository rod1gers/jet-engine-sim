
function server_socket = tcp_socket()
  pkg load sockets
  server_port = 6000;
  
  % Close socket running from previous calls 
  persistent old_socket;
  
  if !isempty(old_socket)
    disp(["Reusing existing TCP server on port ", num2str(server_port), "..."]);
    server_socket = old_socket;
    return;
  endif  
  server_socket = socket(AF_INET, SOCK_STREAM, 0);
  setsockopt(server_socket, SOL_SOCKET, SO_REUSEADDR, 1);
  bind(server_socket, server_port);
  listen(server_socket, 1);
  
  disp(["Octave TCP Server is listening on port ", num2str(server_port), "..."]);

  old_socket = server_socket;
end