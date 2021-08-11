//Save unit data
// [<unit>] call jebus_fnc_saveUnit;
// Returns an array
// [<unitType>, <unitLoadout>, <unitSkill>]

if (!isServer) exitWith {};

params ["_unit"];

private ["_unitData"];

_unitData = [];

_unitData pushBack (typeOf _unit);
_unitData pushBack (getPosATL _unit);
_unitData pushBack (getUnitLoadout _unit);
_unitData pushBack (skill _unit);
_unitData pushBack (vehicleVarName _unit);
_unitData pushBack (getObjectTextures _unit # 1);

_unitData;