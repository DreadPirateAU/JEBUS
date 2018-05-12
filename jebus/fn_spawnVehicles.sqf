//Spawn vehicles
//[<vehicleData>, <>] call jebus_fnc_spawnVehicles;

params [
	"_vehicleData"
	,"_newGroup"
	,"_tmpRespawnPos"
	,"_defaultRespawnPos"
	,"_respawnDir"
	,"_special"
];

private "_newVehiclePosition";

{
	_currentVehicle = (_vehicleData select _forEachIndex);
	_newVehicleType = _currentVehicle select 0;
	
	if (_tmpRespawnPos isEqualTo _defaultRespawnPos) then {
        _newVehiclePosition = (_currentVehicle select 1);
    } else {
        if (_forEachIndex == 0) then {
            _newVehiclePosition = _tmpRespawnPos;
        } else {
            _newVehiclePosition = _tmpRespawnPos findEmptyPosition [5, 50, _newVehicleType];
        };
    };
	
	_newVehicle = createVehicle [_newVehicleType, _newVehiclePosition, [], 0, _special];
	_newGroup addVehicle _newVehicle;
	_newGroup setFormDir _respawnDir;
    _newVehicle setDir _respawnDir;
	
	_newVehicle enableSimulationGlobal false;
	_newVehicle lock (_currentVehicle select 2);
	clearItemCargoGlobal _newVehicle;
	clearMagazineCargoGlobal _newVehicle;
	clearWeaponCargoGlobal _newVehicle;
	clearBackpackCargoGlobal _newVehicle;
	{
		_newVehicle addItemCargoGlobal [_x,1];
	} forEach (_currentVehicle select 3);
	{
		_newVehicle addMagazineCargoGlobal [_x,1];
	} forEach (_currentVehicle select 4);
	{
		_newVehicle addWeaponCargoGlobal [_x,1];
	} forEach (_currentVehicle select 5);
	{
		_newVehicle addBackpackCargoGlobal [_x,1];
	} forEach (_currentVehicle select 6);
	{
		_newVehicle setPylonLoadOut [(_forEachIndex + 1), _x];
    } forEach (_currentVehicle select 7);
	{
        _newVehicle setObjectMaterialGlobal [_forEachIndex, _x];
    } forEach (_currentVehicle select 8);
	{
		_newVehicle setObjectTextureGlobal [_forEachIndex, _x];
	} forEach (_currentVehicle select 9);
	_thisAnimationNames = (_currentVehicle select 10);
    _thisAnimationPhases = (_currentVehicle select 11);
    {
        _newVehicle animateSource [_x, _thisAnimationPhases select _forEachIndex];
    } forEach _thisAnimationNames;
	
	_crew = [(_currentVehicle select 12), _newGroup, _tmpRespawnPos] call jebus_fnc_spawnUnits;
	{
		_x moveInAny _newVehicle;
	} forEach _crew;
	
	_newVehicle enableSimulationGlobal true;
	if (_newVehicle isKindOf "Plane" && _special == "FLY") then {
		_newVehicle setVelocity [
			60 * sin _respawnDir,
			60 * cos _respawnDir,
			0
		];
    };
	{_x addCuratorEditableObjects [[_newVehicle], true]} forEach allCurators;
	sleep 0.1;
} forEach _vehicleData;