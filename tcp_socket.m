
function tcp_socket()
  pkg load sockets

  % Close socket running from previous calls 
  persistent server_socket;
  if !isempty(server_socket)
    try
      %fclose(server_socket);
    catch
    end_try_catch
    server_socket = [];
  endif

  server_port = 5555;
  server_socket = socket(AF_INET, SOCK_STREAM, 0);
  setsockopt(server_socket, SOL_SOCKET, SO_REUSEADDR, 1);
  bind(server_socket, server_port);
  listen(server_socket, 1);

  disp("Octave TCP Server is listening on port 5555...");

  unwind_protect
    while true
      client_socket = accept(server_socket);  
      disp("Client connected!");

      while true
        msg = recv(client_socket, 1024);
        
        if isempty(msg)
          disp("Client disconnected");
          break;
        endif
        msgchar = char(msg);
        disp(["Received: ", msgchar]);

        % Send back a response
        send(client_socket, "Hello from Octave server!\n");
      endwhile

      % Close sockets
      %fclose(client_socket);
    endwhile
  unwind_protect_cleanup
    if exist("server_socket", "var")
      try
        %fclose(server_socket);
      catch
      end_try_catch
      server_socket = [];
    endif
  end_unwind_protect
end
