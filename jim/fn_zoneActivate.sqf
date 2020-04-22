params ["_zone"];

if (!isServer) exitWith {};

//Double check whether zone is active
if (_zone getVariable "Active") exitWith {};

_zone setVariable ["Active", true];
_zonePos = getPos _zone;
_marker = _zone getVariable "Marker";
_marker setMarkerAlpha 1;

_spawnPos = [_zonePos, 0, 70] call BIS_fnc_findSafePos;
_unit = (createGroup east) createUnit ["O_Soldier_F", _spawnPos, [], 10, "NONE"];
//[_zonePos, units(group _unit), 70] execVM "SHK_buildingpos.sqf";
//[group _unit, _zonePos, 70, 1] execVM "BIN_taskPatrol.sqf";
//[_unit, _marker, "showmarker"] execVM "ups.sqf";
[group _unit, _zonePos, 50] call BIS_fnc_taskPatrol;

while {[_zonePos, 400] call jebus_fnc_playerInRadius} do {
	if ([_zonePos, 50] call jebus_fnc_playerInRadius && !alive _unit) exitWith {
		deleteVehicle _zone;
		_marker setMarkerAlpha 0.5;
		_marker setMarkerColor "ColorGreen";
	};
	
	sleep 1;
};

if (!isNull _zone) then {
	_zone setVariable ["Active", false];
	_marker setMarkerAlpha 0.5;
	if (alive _unit) then {deleteVehicle _unit};
};
