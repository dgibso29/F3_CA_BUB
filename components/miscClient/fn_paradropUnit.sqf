/*

init.sqf:

if (isServer) then {
  //_parachutearea = ""; // Name of area markers players will spawn in, bias towards the center!
  // OR
  //_parachutearea = [[0,1500,3000],[0,1500,3000]]; // Gaussian where first array is x(left to right) and second is y(up and down) with [min,normal,max]
  missionNamespace setVariable ['f_var_parachuteArea',_parachutearea, true];

  waitUntil {time>2; sleep 0.1;};
  {
  [_x] remoteExec ["ca_fnc_parachute", _x, false];
  } forEach playableUnits;
};

in f_JIP_playerRespawn.sqf:
end of file add:
[_unit] call ca_fnc_parachute;
In future this is done in ca\respawn\ca_onDeath.sqf i just cannot be asked to update this info atm.

Remember to change the settings for respawn to in init.sqf!
f_var_JIP_JIPMenu = false;		// Do JIP players get the JIP menu?
f_var_JIP_RespawnMenu = false;	// Do respawning players get the JIP menu?
f_var_JIP_RemoveCorpse = false;	// Remove the old corpse of respawning players?
f_var_JIP_Spectate = false;		// JIP players go into spectate straight away?


*/


params ["_player"];
_position = [];

//Getting a good position from the parsed values
switch (typename f_var_parachuteArea) do {
	case "STRING": { _position = [f_var_parachuteArea] call cba_fnc_randPosArea;};
	case "ARRAY": {
    _position = [];

    _xrandom = random (f_var_parachuteArea select 0);
  	_yrandom = random (f_var_parachuteArea select 1);

  	_position set [0,_xrandom];
  	_position set [1,_yrandom];
    };
};



	_position set [2,300];
  _player setPos _position;

  _chute = createVehicle ["B_Parachute_02_F", _position, [], 0, "Fly"];

	_chute setPos _position;

	_player moveInDriver _chute;

	[_player] join grpNull;
