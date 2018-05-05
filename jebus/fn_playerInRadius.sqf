// Detects if player is within a given radius
// [<position>, <radius>] call jebus_fnc_playerInRadius

params [
	"_position"
	,"_radius"
];

private ["_returnValue"];

_returnValue = false;

if ((player distance2D _position) < _radius) then {
	_returnValue = true;
};

//if (isMultiplayer) then {
{
	if ((_x distance2D _position) < _radius) exitWith { _returnValue = true; };
} forEach playableUnits;
//};

_returnValue;
