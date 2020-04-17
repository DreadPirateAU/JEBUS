//Spawn group
// [<groupData>] call jebus_fnc_spawnGroup

if (!isServer) exitWith {};

params [
	"_groupData"
	,"_spawnPos"
	,"_special"
];

_groupData params [
	"_unitSide"
	,"_vehicleData"
	,"_infantryData"
	,"_waypoints"
];

 _newGroup = createGroup _unitSide;

{
	_relativePos = (_x # 1) vectorDiff (_vehicleData # 0 # 1);
	_newVehiclePosition = _spawnPos vectorAdd _relativePos;
	_newVehicle = [_x, _newGroup, _newVehiclePosition, _special] call jebus_fnc_spawnVehicle;
	waitUntil {alive _newVehicle};
}forEach _vehicleData;
 
{
	private "_relativePos";
	
	if (_vehicleData isEqualTo []) then {
		_relativePos = (_x # 1) vectorDiff (_infantryData # 0 # 1);
	} else {
		_relativePos = (_x # 1) vectorDiff (_vehicleData # 0 # 1);	
	};
	
	_newUnitPosition = _spawnPos vectorAdd _relativePos;
	[_x, _newGroup, _newUnitPosition] call jebus_fnc_spawnUnit;
}forEach _infantryData;

//Apply waypoints
[_newGroup, _waypoints] call jebus_fnc_applyWaypoints;

_newGroup;