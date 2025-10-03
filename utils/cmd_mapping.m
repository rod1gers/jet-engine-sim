# COMMAND TO FUNCTION MAPPING

function commands = cmd_mapping()
  commands = containers.Map();
  commands("OPEN_STARTER_AIR_VALVE") = @openStarterAirValve;
  commands("") = @startEngine;
endfunction