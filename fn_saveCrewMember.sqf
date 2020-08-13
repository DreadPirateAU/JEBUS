//Save unit data
// [<unit>] call jebus_fnc_saveUnit;
// Returns an array
// [<unitType>, <unitLoadout>, <unitSkill>]

if (!isServer) exitWith {};

params ["_crewMember"];

_crewMember params [
	"_unit"
	,"_role"
	,"_cargoIndex"
	,"_turretPath"
];

private ["_crewMemberData"];

_crewMemberData = [];

_crewMemberData pushBack ([_unit] call jebus_fnc_saveUnit);
_crewMemberData pushBack _role;
_crewMemberData pushBack _cargoIndex;
_crewMemberData pushBack _turretPath;

_crewMemberData;