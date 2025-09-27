# Function to send data to the ECU

function send_msg_to_ecu(client_socket, data, value, unit)
  
  #  data = the label of the data,e.g Inlet Velocity
  #  value = The actual value reading, e.g 20.45
  #  unit = The SI Unit that its read in ,e.g m/s
  msg = sprintf("%s= %.2f %s\n", data, value, unit);
  send(client_socket, msg);
end