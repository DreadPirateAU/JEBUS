//Save group data
// [<unit>, <delete>] call jebus_fnc_saveGroup;
// Returns an array
// [<unitSide>, <vehicleData>, <infantryData>, <waypoints>]

if (!isServer) exitWith {};

params [
	"_unit"
	,"_delete"
];

// Make sure unit is a unit and not a group (Thanks to S.Crowe)
if (typeName _unit == "GROUP") then { _unit = leader _unit; };

_groupData = [];
_infantryData = [];
_vehicleData = [];
_vehicles = [];
_waypoints = [];

//Save group data
_unitSide = side _unit;
_unitGroup = (group _unit);
_unitsInGroup = units _unitGroup;

//Save waypoint data
_waypoints = [_unitGroup] call jebus_fnc_saveWaypoints;

//Freeze units
{
	_x disableAI "ALL";
	_x enableSimulationGlobal false;
    (vehicle _x) enableSimulationGlobal false;
} forEach _unitsInGroup;

{	
    if ( (vehicle _x) == _x) then {
		_infantryData pushBack ([_x] call jebus_fnc_saveUnit);
    } else {
		if (!(driver (vehicle _x) == _x)) exitWith {};
		_vehicleData pushBack ([vehicle _x] call jebus_fnc_saveVehicle);
	};
} forEach _unitsInGroup;

_groupData = [_unitSide, _vehicleData, _infantryData, _waypoints];

_groupData;