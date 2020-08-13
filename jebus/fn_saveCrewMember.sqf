//Save crew member data
// [<crew member>] call jebus_fnc_saveUnit;
// Returns an array
// [<unit>, <role>, <cargoIndex>,<_turretPath>]

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
