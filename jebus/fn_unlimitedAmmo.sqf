// Gives an AI unit unlimited ammo
// [<unit>] call jebus_fnc_unlimitedAmmo

params ["_unit"];

_unit addEventHandler ["Reloaded", 
{
	params ["_unit", "_weapon", "_muzzle", "_newmag", "_oldmag"];
	
	_ammoCount = _oldmag select 1;
	_magazineClass = _oldmag select 0;
	
	if (_ammoCount < 1) then {
		if (_magazineClass isEqualTo "") exitWith {};
		_unit addMagazine _magazineClass
	};

}];