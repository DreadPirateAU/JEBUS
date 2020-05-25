params [
	"_pos"
	,"_type"
];

_iedTrigger = createMine["APERSMine", _pos, [], 3];
_ied = createMine[_type, getPos _iedTrigger, [], 0];
_ied setPosATL(getPosATL _ied select 2+1);
_ied setDir(random 359);

// [_ied] spawn {
	// params ["_ied"];
	// waituntil {
		// sleep 1;
		// _nearestUnits = _ied nearEntities [["Man","LandVehicle"], 10];
		// if (!alive _ied) exitWith {true};
		// if ({(_x distance _ied) < 1.5} count _nearestUnits > 0 ) exitWith {true};
		// if ({(speed _x) > 5} count _nearestUnits > 0) exitWith {true};
		// false;
	// };

	// _ied setDamage 1;
// };

east revealMine _ied;
civilian revealMine _ied;

_ied;