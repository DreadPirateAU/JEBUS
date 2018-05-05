// 0 = [this, <other parameters>] spawn jebus_fnc_main;

if (!isServer) exitWith {};

waituntil {!isnil "bis_fnc_init"};

private [
	"_unit"
	,"_cacheRadius"
	,"_crewList"
	,"_crewInventoryList"
	,"_crewSkillList"
	,"_debug"
	,"_exitTrigger"
	,"_firstLoop"
	,"_gaiaParameter"
	,"_gaiaZone"
	,"_infantryList"
	,"_infantryInventoryList"
	,"_infantrySkillList"
	,"_initString"
	,"_initialDelay"
	,"_lives"
	,"_newGroup"
	,"_newVehicle"
	,"_pauseRadius"
	,"_reduceRadius"
	,"_respawnDelay"
	,"_respawnDir"
	,"_respawnMarkers"
	,"_respawnPos"
	,"_special"
	,"_tmpGroup"
	,"_tmpRespawnPos"
	,"_tmpZone"
	,"_trigger"
	,"_unitGroup"
	,"_unitSide"
	,"_unitsInGroup"
	,"_vehicleList"
	,"_vehiclePositionList"
	,"_vehicleItemList"
	,"_vehicleLockedList"
	,"_vehicleMagazineList"
	,"_vehiclePylonList"
	,"_vehicleWeaponList"
	,"_waypointList"
];

_unit = _this select 0;

// Make sure unit is a unit and not a group (Thanks to S.Crowe)
if (typeName _unit == "GROUP") then { _unit = leader _unit; };

_respawnPos = getPos _unit;
_respawnDir = getDir _unit;
_unitSide = side _unit;

_unitGroup = (group _unit);
_unitsInGroup = units _unitGroup;

_waypointList = [];
_infantryList = [];
_infantryInventoryList = [];
_infantrySkillList = [];
_vehicleList = [];
_vehiclePositionList = [];
_vehicleLockedList = [];
_vehicleItemList = [];
_vehicleMagazineList = [];
_vehiclePylonList = [];
_vehicleWeaponList = [];
_crewList = [];
_crewInventoryList = [];
_crewSkillList = [];
_respawnPosList = [];
_respawnPosList pushBack _respawnPos;

//Set up default parameters
_lives = -1;
_cacheRadius = 0;
_reduceRadius = 0;
_pauseRadius = 200;
_respawnDelay = 30;
_initialDelay = 0;
_gaiaParameter = "";
_gaiaZone = 0;
_special = "NONE";
_respawnMarkers = [];
_initString = "";
_debug = false;

//Get parameters
for "_parameterIndex" from 1 to (count _this - 1) do {
	switch (_this select _parameterIndex) do {
		case "LIVES=" : {_lives = _this select (_parameterIndex + 1)};
		case "DELAY=" : {_respawnDelay =  _this select (_parameterIndex + 1)};
		case "START=" : {_initialDelay = _this select (_parameterIndex + 1)};
		case "CACHE=" : {_cacheRadius =  _this select (_parameterIndex + 1)};
		case "REDUCE=" : {_reduceRadius =  _this select (_parameterIndex + 1)};
		case "GAIA_MOVE=" : {_gaiaParameter = "MOVE"; _gaiaZone = _this select (_parameterIndex + 1)};
		case "GAIA_NOFOLLOW=" : {_gaiaParameter = "NOFOLLOW"; _gaiaZone =  _this select (_parameterIndex + 1)};
		case "GAIA_FORTIFY=" : {_gaiaParameter = "FORTIFY"; _gaiaZone = _this select (_parameterIndex + 1)};
		case "FLYING" : {_special = "FLY"};
		case "RESPAWNMARKERS=" : {_respawnMarkers = _this select (_parameterIndex + 1)};
		case "PAUSE=" : {_pauseRadius = _this select (_parameterIndex + 1)};
		case "EXIT=" : {_exitTrigger = _this select (_parameterIndex + 1)};
		case "INIT=" : {_initString = _this select (_parameterIndex + 1)};
		case "DEBUG" : {_debug = true};
	};
};

//Add additional respawn positions where applicable
{
	_respawnPosList pushBack (getMarkerPos _x);
} forEach _respawnMarkers;

//Determine number of lives if passed an array
if (typeName _lives == "ARRAY") then {
	_minLives = _lives select 0;
	_maxLives = _lives select 1;
	_lives = _minLives + floor random (_maxLives - _minLives);
};

//Check for synchronized trigger
if (count (synchronizedObjects _unit) > 0) then {
	_trigger = (synchronizedObjects _unit) select 0;
	if (_debug) then {systemChat "Synchronized trigger activation present"};
};

//Freeze units
{
	_x enableSimulationGlobal false;
} forEach _unitsInGroup;

//Save waypoint data
_waypointList = [_unitGroup] call jebus_fnc_saveWaypoints;

//Save unit data and delete
{
	if ( (vehicle _x) isKindOf "LandVehicle" || (vehicle _x) isKindOf "Air" || (vehicle _x) isKindOf "Ship") then {
		_vehicleList append [typeOf (vehicle _x)];
		_vehiclePositionList append [getPos (vehicle _x)];
		_vehicleLockedList append [locked (vehicle _x)];
		_vehicleItemList append [itemCargo (vehicle _x)];
		_vehicleMagazineList append [magazineCargo (vehicle _x)];
		_vehicleWeaponList append [weaponCargo (vehicle _x)];
		_vehiclePylonList append [getPylonMagazines (vehicle _x)];
		_tmpCrew = crew (vehicle _x);
		sleep 0.1;
		deleteVehicle (vehicle _x);
		sleep 0.1;
		_tmpCrewList = [];
		_tmpCrewInventoryList = [];
		_tmpCrewSkillList = [];
		{
			_tmpCrewList append [typeOf (vehicle _x)];
			_tmpCrewInventoryList append [getUnitLoadout _x];
			_tmpCrewSkillList append [skill _x];
			deleteVehicle _x;
			sleep 0.1
		} forEach _tmpCrew;

		_crewList set [(count _vehicleList - 1), _tmpCrewList];
		_crewInventoryList set [(count _vehicleList - 1), _tmpCrewInventoryList];
		_crewSkillList set [(count _vehicleList - 1), _tmpCrewSkillList];
	} else {
		 _infantryList append [typeOf (vehicle _x)];
		 _infantryInventoryList append [getUnitLoadout _x];
		 _infantrySkillList append [skill _x];
		deleteVehicle (vehicle _x);
		sleep 0.1;
	};
	
	sleep 0.1;
	
} forEach _unitsInGroup;

deleteGroup _unitGroup;
sleep 1;

_firstLoop = true;

//Main loop
while { _lives != 0 } do {
	//Wait for trigger activation (Thanks to pritchardgsd)
	if (! isNil "_trigger") then {
		while {! (triggerActivated _trigger)} do {
			sleep 10;
			if (_debug) then {systemChat "Waiting for trigger activation"};
		};
	};
	
	if (_firstLoop && _initialDelay > 0) then {
		sleep _initialDelay;
		_firstLoop = false;
		systemChat "First Loop!";
	};
	
	if (_debug) then {systemChat "Spawning group."};

	_newGroup = createGroup _unitSide;
	_newGroup setVariable ["groupInitialising", true, false];

	_tmpRespawnPos = selectRandom _respawnPosList;

	while {[_tmpRespawnPos, _unitSide, _pauseRadius] call jebus_fnc_enemyInRadius} do {
		if (_debug) then {systemChat "Enemies in pause radius. Waiting."};
		sleep 5;
	};

	//Spawn vehicles - spawn, disable sim, add crew, enable sim......
	for "_vehicleIndex" from 0 to (count _vehicleList - 1) do {
		private "_newVehiclePosition";
		
		_newVehicleType = (_vehicleList select _vehicleIndex); 
		if (_tmpRespawnPos isEqualTo _respawnPos) then {
			_newVehiclePosition = (_vehiclePositionList select _vehicleIndex);
		} else {
			if (_vehicleIndex == 0) then {
				_newVehiclePosition = _tmpRespawnPos;
			} else {
				_newVehiclePosition = _tmpRespawnPos findEmptyPosition [5, 50, _newVehicleType];
			};
		};
		_newVehicle = createVehicle [_newVehicleType, _newVehiclePosition, [], 0, _special];
		_newGroup setFormDir _respawnDir;
		_newVehicle setDir _respawnDir;
		_newGroup addVehicle _newVehicle;
		_newVehicle enableSimulationGlobal false;
		_newVehicle lock (_vehicleLockedList select _vehicleIndex);
		clearItemCargoGlobal _newVehicle;
		clearMagazineCargoGlobal _newVehicle;
		clearWeaponCargoGlobal _newVehicle;
		{
			_newVehicle addItemCargoGlobal [_x,1];
		} forEach (_vehicleItemList select _vehicleIndex);
		{
			_newVehicle addMagazineCargoGlobal [_x,1];
		} forEach (_vehicleMagazineList select _vehicleIndex);
		{
			_newVehicle addWeaponCargoGlobal [_x,1];
		} forEach (_vehicleWeaponList select _vehicleIndex);
		{
			_newVehicle setPylonLoadOut [(_forEachIndex + 1), _x];;
		} forEach (_vehiclePylonList select _vehicleIndex);
		
		sleep 0.1;

		_tmpGroup = [_tmpRespawnPos, _unitSide, (_crewList select _vehicleIndex)] call BIS_fnc_spawnGroup;
		{
			_tmpInventory = _crewInventoryList select _vehicleIndex;
			_x setUnitLoadout (_tmpInventory select _forEachIndex);
			_tmpSkill = _crewSkillList select _vehicleIndex;
			_x setSkill (_tmpSkill select _forEachIndex);
			sleep 0.1;
			_x moveInAny _newVehicle;
		} forEach (units _tmpGroup);

		waituntil { 
			sleep 1;
			count crew _newVehicle == count (units _tmpGroup)
		};

		if (_newVehicle isKindOf "Plane" && _special == "FLY") then {
			_newVehicle setVelocity [
				60 * sin _respawnDir,
				60 * cos _respawnDir,
				0
			];
		};
		
		_newVehicle enableSimulationGlobal true;
		
		sleep 0.1;
		
		(units _tmpGroup) joinSilent _newGroup;

		{_x addCuratorEditableObjects [[_newVehicle],true]} forEach allCurators;
		sleep 0.1;
	};

	//Spawn infantry
	_tmpGroup = [_tmpRespawnPos, _unitSide, _infantryList] call BIS_fnc_spawnGroup;
	sleep 0.1;
	{
		_x setUnitLoadout (_infantryInventoryList select _forEachIndex);
		_x setSkill (_infantrySkillList select _forEachIndex);
		sleep 0.1;
	} forEach (units _tmpGroup);
	
	(units _tmpGroup) joinSilent _newGroup;
	
	sleep 0.1;
	
	{_x addCuratorEditableObjects [units _newGroup,false]} forEach allCurators;

	//Initiate caching
	if ("CACHE=" in _this) then {
		[_newGroup, _cacheRadius, _debug] spawn jebus_fnc_cache;
	};
	
	//Initiate reducing
	if ("REDUCE=" in _this) then {
		[_newGroup, _reduceRadius, _debug] spawn jebus_fnc_reduce;
	};
	
	_newGroup allowfleeing 0;
	
	//Initiate GAIA
	if (_gaiaParameter in ["MOVE", "NOFOLLOW", "FORTIFY"]) then {
		if (_debug) then {systemChat _gaiaParameter};
		switch (typeName _gaiaZone) do {
			case "ARRAY" : {
				_tmpZone = selectRandom _gaiaZone;
				if (typeName _tmpZone == "SCALAR") then {_tmpZone = str (_tmpZone);};
			};
			case "SCALAR" : {_tmpZone = str (_gaiaZone);};
			default {_tmpZone = _gaiaZone};
		};

		_newGroup setVariable ["GAIA_ZONE_INTEND",[_tmpZone, _gaiaParameter], false];
	};

	//Apply waypoints
	[_newGroup, _waypointList, _debug] call jebus_fnc_applyWaypoints;
	
	//Execute init string
	_proxyThis = leader _newgroup;
	call compile format [_initString];
	
	_newGroup setVariable ["groupInitialising", nil];

	//Check every 5 seconds to see if group is eliminated
	waituntil {
		sleep 5;
		{alive _x} count (units _newGroup) < 1;
	};

	if (_debug) then {systemChat "Group eliminated. Waiting for respawn."};

	//Respawn delay
	if (typeName _respawnDelay == "ARRAY") then {
		_minTime = _respawnDelay select 0;
		_maxTime = _respawnDelay select 1;
		_tempRespawnDelay = _minTime + random (_maxTime - _minTime);
		if (_debug) then {systemChat format ["Respawn delay = %1 seconds", _tempRespawnDelay]};
		sleep _tempRespawnDelay;
	} else {
		if (_debug) then {systemChat format ["Respawn delay = %1 seconds", _respawnDelay]};
		sleep _respawnDelay;
	};

	//Check if exit trigger has been activated
	if (! isNil "_exitTrigger") then {
		if (triggerActivated _exitTrigger) then {
			if (_debug) then {systemChat "Exit trigger activated"};
			_lives = 1;
		};
	};

	_lives = _lives - 1;

	if (_debug) then {
		if (_lives < 0) then {systemChat "Infinite lives."} else
		{systemChat format["Lives remaining = %1", _lives]};
	};

	//Clean up empty groups
    {
          if ((count (units _x)) isEqualTo 0) then {
			if (isNil {_x getVariable "groupInitialising"}) then {
               deleteGroup _x;
			};
          };
     } count allGroups;

};

if (_debug) then {systemChat "Exiting script."};
