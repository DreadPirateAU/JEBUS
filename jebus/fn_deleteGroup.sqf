params ["_unit"];

{
	deleteVehicle (vehicle _x); 
	deleteVehicle _x
} forEach units (group _unit);
