// Unsticks an AI unit
// [<unit>] call jebus_fnc_unstick

params ["_unit"];

_unit setPos (player modelToWorld [0,-3,0.5]);
_unit enableAI "ALL";

