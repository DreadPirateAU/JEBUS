params ["_position", "_blackList"];

_returnValue = false;

{
	if (_position inArea _x) then {_returnValue = true};
} forEach _blackList;

_returnValue;