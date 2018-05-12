//Spawn units and apply loadout and skill
// [<unitData>, <group>, <spawnPos>, <vehicle>] call jebus_fnc_spawnUnits;
// Returns a list of the spawned units

params [
	"_unitData"
	,"_newGroup"
	,"_tmpRespawnPos"
];

private [
	"_newUnit"
	,"_spawnedUnits"
];

_spawnedUnits = [];

{
	_newUnit = _newGroup createUnit [(_x select 0), _tmpRespawnPos, [], 0, "NONE"];
	sleep 0.1;
	// copyToClipboard str ((_x select 1) select _forEachIndex);
	_newUnit setUnitLoadout (_x select 1);
	_newUnit setSkill (_x select 2);
	_spawnedUnits pushBack _newUnit;
	sleep 0.1;
} forEach _unitData;

sleep 0.1;

{_x addCuratorEditableObjects [units _newGroup,false]} forEach allCurators;

_spawnedUnits;