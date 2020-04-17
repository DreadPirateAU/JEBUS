// Adds a "Recruit" action to all group members
// [<group>, <debug>] spawn jebus_fnc_recruit

params ["_unit"];

_displayName = gettext (configfile >> "CfgVehicles" >> typeOf _unit >> "displayName");
player groupChat format["%1 (%2), you are dismissed", name _unit, _displayName];
deleteVehicle _unit;