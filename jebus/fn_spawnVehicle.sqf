//Spawn vehicle
//[<vehicleData>] call jebus_fnc_spawnVehicle;

if (!isServer) exitWith {};

params [
	"_vehicleData"
	,"_newGroup"
	,"_tmpRespawnPos"
	,"_special"
];

_vehicleData params [
	"_vehicleType"
	,"_vehiclePos"
	,"_vehicleDir"
	,"_vehicleLocked"
	,"_vehicleFuel"				
	,"_vehicleItemCargo"
	,"_vehicleMagazineCargo"
	,"_vehicleWeaponCargo"
	,"_vehicleBackpackCargo"
	,"_vehicleObjectMaterials"
	,"_vehicleObjectTextures"
	,"_vehicleAnimationNames"
	,"_vehicleAnimationPhases"
	,"_vehicleVarName"
	,"_vehicleCrewData"
];

if (_tmpRespawnPos select 2 < 0) then {
	_tmpRespawnPos set [2, 0];
};

//Fix for certain GM vehicles
if (_vehicleType isKindOf "gm_wheeled_base"  || _vehicleType isKindOf "gm_tracked_base") then {
	_tmpRespawnPos set [2, (_tmpRespawnPos select 2) + 2];
} else {
	_tmpRespawnPos set [2, (_tmpRespawnPos select 2) + 0.1];
};

if (_vehicleType isKindOf "StaticWeapon") then {
	_special = "CAN_COLLIDE";
};

_newVehicle = createVehicle [_vehicleType, _tmpRespawnPos, [], 0, _special];
waitUntil {alive _newVehicle};
_newVehicle setDir _vehicleDir;

_newVehicle lock _vehicleLocked;
_newVehicle setFuel _vehicleFuel;
clearItemCargoGlobal _newVehicle;
clearMagazineCargoGlobal _newVehicle;
clearWeaponCargoGlobal _newVehicle;
clearBackpackCargoGlobal _newVehicle;
{_newVehicle addItemCargoGlobal [_x,1];} forEach _vehicleItemCargo;
{_newVehicle addMagazineCargoGlobal [_x,1];} forEach _vehicleMagazineCargo;
{_newVehicle addWeaponCargoGlobal [_x,1];} forEach _vehicleWeaponCargo;
{_newVehicle addBackpackCargoGlobal [_x,1];} forEach _vehicleBackpackCargo;
{_newVehicle setObjectMaterialGlobal [_forEachIndex, _x];} forEach _vehicleObjectMaterials;
{_newVehicle setObjectTextureGlobal [_forEachIndex, _x];} forEach _vehicleObjectTextures;
{_newVehicle animateSource [_x, _vehicleAnimationPhases select _forEachIndex];} forEach _vehicleAnimationNames;

if (!(_vehicleVarName isEqualTo "")) then {
	[_newVehicle, _vehicleVarName] remoteExec ["setVehicleVarName", 0, _newVehicle];
	missionNamespace setVariable [_vehicleVarName, _newVehicle, true];
};

_crew = [];

{
	_newUnit =  [_x # 0, _newGroup, _tmpRespawnPos] call jebus_fnc_spawnUnit;
	_crew pushBack _newUnit;
	if (unitISUAV _newVehicle) then {
		_newUnit moveInAny _newVehicle;
	} else {
		switch toLower (_x # 1) do {
			case 'driver': {_newUnit assignAsDriver _newVehicle; _newUnit moveInDriver _newVehicle}; 
			case 'commander': {_newUnit assignAsCommander _newVehicle; _newUnit moveInCommander _newVehicle}; 
			case 'gunner': {_newUnit assignAsGunner _newVehicle; _newUnit moveInGunner _newVehicle}; 
			case 'cargo': {_newUnit assignAsCargoIndex [_newVehicle,(_x # 2)]; _newUnit moveInCargo [_newVehicle,(_x # 2)]}; 
			case 'turret': {_newUnit assignAsTurret [_newVehicle,(_x # 3)]; _newUnit moveInturret [_newVehicle,(_x # 3)]}; 
			default {_newUnit moveInAny _newVehicle};
		};
	};
} forEach _vehicleCrewData;

waituntil {count crew _newVehicle == count (_crew)};

if (_newVehicle isKindOf "Plane" && (_vehiclePos select 2 > 50)) then {
	_newVehicle setPos (_newVehicle modelToWorld [0,0,500]);
	_newVehicle engineOn true;
	_newVehicle setVelocity [
		100 * sin _vehicleDir,
		100 * cos _vehicleDir,
		0
	];
};

_newVehicle;
