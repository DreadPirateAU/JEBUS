while {true} do {
	{
		_x addCuratorEditableObjects [allUnits, true];
		_x addCuratorEditableObjects [vehicles, true];
		sleep 10;
	} forEach allCurators; 
};
