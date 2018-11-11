//	Zeus extensions for CA, by Bubbus.
//
//	f_fnc_spawngroup does not add spawned units to zeus so they can't move them around etc.  We fix that here.
//
//	PARAMETERS:
//
//		See parameters for f_fnc_spawngroup.

params ["_units", "_camPos", "_gear", "_side"];

_group = [_units, _camPos, _gear, _side] call f_fnc_spawngroup;

{
	_units = units _group;
	_curator = _x;
	_curator addCuratorEditableObjects [_units, true];

} forEach allCurators;

if ((!isNil "zeus_spawn_vcom") and {!zeus_spawn_vcom}) then
{
	_group setVariable ["Vcm_Disable", true, true];
};

if ((!isNil "zeus_spawn_guerrillas") and {zeus_spawn_guerrillas}) then
{
	[_group] call f_fnc_groupGuerrillaAI;
};

if ((!isNil "zeus_spawn_suppress") and {zeus_spawn_suppress}) then
{
	[_group] call f_fnc_groupSuppressiveAI;
};
