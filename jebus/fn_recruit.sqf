// Adds a "Recruit" action to all group members
// [<group>, <debug>] spawn jebus_fnc_recruit

params [
	"_group"
	,"_debug"
];

if (_debug) then { systemChat format["%1 - Adding Recruit Action", _group] };

_recruit = {
	params ["_target", "_caller", "_actionId", "_arguments"];
	
	[_target] join _caller;
	_target removeAction _actionID;
	_displayName = gettext (configfile >> "CfgVehicles" >> typeOf _target >> "displayName");
	_title = format["Dismiss %1 (%2)", name _target, _displayName];
	_condition = "_target in (groupSelectedUnits player)";
	[_target, [_title, jebus_fnc_dismiss, [], 0, false, true, "", _condition]] remoteExec["addAction"];
};

{
	_unit = _x;
	
	//Add recruit action
	if ((vehicle _x) != _x) exitWith{systemChat format["%1 - Don't use RECRUIT on vehicles", _group]};
	_displayName = gettext (configfile >> "CfgVehicles" >> typeOf _unit >> "displayName");
	_title = format["Recruit %1 (%2)", name _unit, _displayName];
	_condition = "leader (group _this) == _this";
	_radius = 3;
	[_unit, [_title, _recruit, [], 0, false, true, "", _condition, _radius]] remoteExec["addAction"];
	
	//Add unstick action
	_title = "Unstick AI";
	_condition = "_target in (groupSelectedUnits player)";
	[_unit, [_title, jebus_fnc_unstick, [], 0, false, true, "", _condition]] remoteExec["addAction"];
} forEach (units _group);
