//Spawn unit and apply loadout and skill
// [<unitData>, <group>, <spawnPos>] call jebus_fnc_spawnUnit;
// Returns the spawned unit

if (!isServer) exitWith {};

params [
	"_unitData"
	,"_newGroup"
	,"_spawnPos"
];

private ["_newUnit"];

_unitData params [
	"_unitType"
	,"_unitPos"
	,"_unitLoadout"
	,"_unitSkill"
	,"_unitVarName"
	,"_unitInsignia"
];

if (_spawnPos select 2 < 0) then {
	_spawnPos set [2, 0.1];
};

if (surfaceIsWater _spawnPos) then {
	_spawnPos = ATLToASL _spawnPos;
};

_newUnit = _newGroup createUnit [_unitType, _spawnPos, [], 0, "CAN_COLLIDE"];
waitUntil {alive _newUnit};
if (getPos _newUnit # 2 > 2) then {
	_onGround = [getPos _newUnit # 0, getPos _newUnit # 1, 0.1];
	_newUnit setPos _onGround;
};
_newUnit setUnitLoadout _unitLoadout;
_newUnit setSkill _unitSkill;
if (!(_unitVarName isEqualTo "")) then {
	[_newUnit, _unitVarName] remoteExec ["setVehicleVarName", 0, _newUnit];
	missionNamespace setVariable [_unitVarName, _newUnit, true];
};
if (!(_unitInsignia isEqualTo "")) then {
	_newUnit setObjectTextureGlobal [1, _unitInsignia];
};


[_newUnit] call jebus_fnc_unlimitedAmmo;

_newUnit;
