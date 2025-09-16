# Function to send data to the ECU

function send_msg_to_ecu(client_socket, data, value, unit)
  
  msg = sprintf("%s= %.2f %s\n", data, value, unit);
  send(client_socket, msg);
end