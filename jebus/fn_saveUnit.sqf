//Save unit data
// [<unit>] call jebus_fnc_saveUnit;
// Returns an array
// [<unitType>, <unitLoadout>, <unitSkill>]

params [
	"_unit"
];

private ["_unitData"];

_unitData = [];

_unitData pushBack (typeOf _unit);
_unitData pushBack (getUnitLoadout _unit);
_unitData pushBack (skill _unit);
deleteVehicle (vehicle _unit);
sleep 0.1;

_unitData;