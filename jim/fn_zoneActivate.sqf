params ["_zone"];

if (!isServer) exitWith {};

//Double check whether zone is active
if (_zone getVariable "Active") exitWith {};

_zone setVariable ["Active", true];
_zonePos = getPos _zone;
_marker = _zone getVariable "Marker";
_marker setMarkerAlpha 1;
_buildingPositions = (_zone getVariable "BuildingPositions") call BIS_fnc_arrayShuffle;

_spawnPos = [_zonePos, 0, 70] call BIS_fnc_findSafePos;
_spawnPos pushback 0; //BIS_fnc_findSafePos only returns [x,y], need to add z-axis

_patrolGroup = createGroup (infantryPool # 0);
_garrisonGroup = createGroup (infantryPool # 0);

_possibleUnits = infantryPool # 2;

for [{_i = 0},{_i < (4 + floor(random 5))},{_i = _i + 1}] do {
	[selectRandom _possibleUnits, _patrolGroup, _spawnPos] call jebus_fnc_spawnUnit;
};

for [{_i = 0},{_i < (2 + floor(random 3))},{_i = _i + 1}] do {
	[selectRandom _possibleUnits, _garrisonGroup, _spawnPos] call jebus_fnc_spawnUnit;
};

{
	if (_forEachIndex >= (count _buildingPositions)) then {deleteVehicle _x};
	_x setPos (_buildingPositions select _forEachIndex);
	_x disableAI "PATH";
} forEach (units _garrisonGroup);

//[_zonePos, units _group, 70] execVM "SHK_buildingpos.sqf";
//[_group, _zonePos, 70, 1] execVM "BIN_taskPatrol.sqf";
//[leader _group, _marker, "showmarker"] execVM "ups.sqf";
[_patrolGroup, _zonePos, 50] call BIS_fnc_taskPatrol;
//[leader _group,100,5,4,true] execVM "tog_garrison_script.sqf";

while {[_zonePos, 500] call jebus_fnc_playerInRadius} do {
	if ([_zonePos, 100] call jebus_fnc_playerInRadius && ({alive _x} count (units _patrolGroup + units _garrisonGroup)) < 1) exitWith {
		deleteVehicle _zone;
		_marker setMarkerAlpha 0.5;
		_marker setMarkerColor "ColorGreen";
	};
	
	sleep 1;
};

if (!isNull _zone) then {
	_zone setVariable ["Active", false];
	_marker setMarkerAlpha 0.5;
	[leader _patrolGroup] call jebus_fnc_deleteGroup;
	[leader _garrisonGroup] call jebus_fnc_deleteGroup;
};
