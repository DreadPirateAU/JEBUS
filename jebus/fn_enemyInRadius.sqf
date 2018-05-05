// Detects if enemy is within a given radius (Planes excluded)
// [<position>, <friendly side>, <radius>] call Jebus_fnc_enemyInRadius

params [
	"_position"
	,"_friendlySide"
	,"_radius"
];

private ["_returnValue"];

_nearestEnemies = [];
_nearestUnits = _position nearEntities [["Man","LandVehicle","Helicopter","Ship"], _radius];
{
	if ( (side _x getFriend (_friendlySide)) < 0.6 && (side _x != CIVILIAN) ) then { 
		_nearestEnemies = _nearestEnemies + [_x]; 
	}
} forEach _nearestUnits;

if (count _nearestEnemies > 0) then {
	_returnValue = true;
} else {
	_returnValue = false;
};

_returnValue;
