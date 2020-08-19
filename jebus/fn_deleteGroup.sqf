params ["_group"];

{
	deleteVehicle (vehicle _x); 
	deleteVehicle _x
} forEach units (_group);

deleteGroup _group;
