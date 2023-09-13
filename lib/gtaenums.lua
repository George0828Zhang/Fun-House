-- Author: George Chang (George0828Zhang)
-- Credits:
-- https://github.com/Yimura/GTAV-Classes
-- https://alexguirre.github.io/rage-parser-dumps/

eDamageType = {
    UNKNOWN = 0,
    NONE = 1,
    MELEE = 2,
    BULLET = 3,
    BULLET_RUBBER = 4,
    EXPLOSIVE = 5,
    FIRE = 6,
    COLLISION = 7,
    FALL = 8,
    DROWN = 9,
    ELECTRIC = 10,
    BARBED_WIRE = 11,
    FIRE_EXTINGUISHER = 12,
    SMOKE = 13,
    WATER_CANNON = 14,
    TRANQUILIZER = 15
}
eExplosion = {
    DONTCARE = -1,
    GRENADE = 0,
    GRENADELAUNCHER = 1,
    STICKYBOMB = 2,
    MOLOTOV = 3,
    ROCKET = 4,
    TANKSHELL = 5,
    HI_OCTANE = 6,
    CAR = 7,
    PLANE = 8,
    PETROL_PUMP = 9,
    BIKE = 10,
    DIR_STEAM = 11,
    DIR_FLAME = 12,
    DIR_WATER_HYDRANT = 13,
    DIR_GAS_CANISTER = 14,
    BOAT = 15,
    SHIP_DESTROY = 16,
    TRUCK = 17,
    BULLET = 18,
    SMOKEGRENADELAUNCHER = 19,
    SMOKEGRENADE = 20,
    BZGAS = 21,
    FLARE = 22,
    GAS_CANISTER = 23,
    EXTINGUISHER = 24,
    PROGRAMMABLEAR = 25,
    TRAIN = 26,
    BARREL = 27,
    PROPANE = 28,
    BLIMP = 29,
    FLAME_EXPLODE = 30,
    TANKER = 31,
    PLANE_ROCKET = 32,
    VEHICLE_BULLET = 33,
    GAS_TANK = 34,
    BIRD_CRAP = 35,
    RAILGUN = 36,
    BLIMP2 = 37,
    FIREWORK = 38,
    SNOWBALL = 39,
    PROXMINE = 40,
    VALKYRIE_CANNON = 41,
    AIR_DEFENSE = 42,
    PIPEBOMB = 43,
    VEHICLEMINE = 44,
    EXPLOSIVEAMMO = 45,
    APCSHELL = 46,
    BOMB_CLUSTER = 47,
    BOMB_GAS = 48,
    BOMB_INCENDIARY = 49,
    BOMB_STANDARD = 50,
    TORPEDO = 51,
    TORPEDO_UNDERWATER = 52,
    BOMBUSHKA_CANNON = 53,
    BOMB_CLUSTER_SECONDARY = 54,
    HUNTER_BARRAGE = 55,
    HUNTER_CANNON = 56,
    ROGUE_CANNON = 57,
    MINE_UNDERWATER = 58,
    ORBITAL_CANNON = 59,
    BOMB_STANDARD_WIDE = 60,
    EXPLOSIVEAMMO_SHOTGUN = 61,
    OPPRESSOR2_CANNON = 62,
    MORTAR_KINETIC = 63,
    VEHICLEMINE_KINETIC = 64,
    VEHICLEMINE_EMP = 65,
    VEHICLEMINE_SPIKE = 66,
    VEHICLEMINE_SLICK = 67,
    VEHICLEMINE_TAR = 68,
    SCRIPT_DRONE = 69,
    RAYGUN = 70,
    BURIEDMINE = 71,
    SCRIPT_MISSILE = 72,
    RCTANK_ROCKET = 73,
    BOMB_WATER = 74,
    BOMB_WATER_SECONDARY = 75,
    MINE_CNCSPIKE = 76,
    BZGAS_MK2 = 77,
    FLASHGRENADE = 78,
    STUNGRENADE = 79,
    CNC_KINETICRAM = 80,
    SCRIPT_MISSILE_LARGE = 81,
    SUBMARINE_BIG = 82,
    EMPLAUNCHER_EMP = 83,
    RAILGUNXM3 = 84,
    BALANCED_CANNONS = 85,
}
eFireType = {
    NONE = 0,
    MELEE = 1,
    INSTANT_HIT = 2,
    DELAYED_HIT = 3,
    PROJECTILE = 4,
    VOLUMETRIC_PARTICLE = 5
}
eWeaponFlags = {
    CarriedInHand = 0,
	Automatic = 1,
	Silenced = 2,
	FirstPersonScope = 3,
	ArmourPenetrating = 4,
	ApplyBulletForce = 5,
	Gun = 6,
	CanLockonOnFoot = 7,
	CanLockonInVehicle = 8,
	Homing = 9,
	CanFreeAim = 10,
	Heavy = 11,
	TwoHanded = 12,
	Launched = 13,
	MeleeBlade = 14,
	MeleeClub = 15,
	AnimReload = 16,
	AnimCrouchFire = 17,
	CreateVisibleOrdnance = 18,
	TreatAsOneHandedInCover = 19,
	TreatAsTwoHandedInCover = 20,
	Thrown = 21,
	Bomb = 22,
	UsableOnFoot = 23,
	UsableUnderwater = 24,
	UsableClimbing = 25,
	UsableInCover = 26,
	AllowEarlyExitFromFireAnimAfterBulletFired = 27,
	DisableRightHandIk = 28,
	DisableLeftHandIkInCover = 29,
	DontSwapWeaponIfNoAmmo = 30,
	UseLoopedReloadAnim = 31,
	DoesRevivableDamage = 32,
	NoFriendlyFireDamage = 33,
	Detonator = 34,
	DisplayRechargeTimeHUD = 35,
	OnlyFireOneShot = 36,
	OnlyFireOneShotPerTriggerPress = 37,
	UseLegDamageVoice = 38,
	Lasso = 39,
	CanBeFiredLikeGun = 40,
	OnlyAllowFiring = 41,
	NoLeftHandIK = 42,
	NoLeftHandIKWhenBlocked = 43,
	RiotShield = 44,
	IgnoreStrafing = 45,
	Vehicle = 46,
	EnforceAimingRestrictions = 47,
	ForceEjectShellAfterFiring = 48,
	NonViolent = 49,
	NonLethal = 50,
	Scary = 51,
	AllowCloseQuarterKills = 52,
	DisablePlayerBlockingInMP = 53,
	StaticReticulePosition = 54,
	CanPerformArrest = 55,
	_0xF1DA2249 = 56,
	AllowMeleeIntroAnim = 57,
	ManualDetonation = 58,
	SuppressGunshotEvent = 59,
	HiddenFromWeaponWheel = 60,
	AllowDriverLockOnToAmbientPeds = 61,
	NeedsGunCockingInCover = 62,
	ThrowOnly = 63,
	NoAutoRunWhenFiring = 64,
	DisableIdleVariations = 65,
	HasLowCoverReloads = 66,
	HasLowCoverSwaps = 67,
	DontBreakRopes = 68,
	CookWhileAiming = 69,
	UseLeftHandIkWhenAiming = 70,
	DropWhenCooked = 71,
	NotAWeapon = 72,
	RemoveEarlyWhenEnteringVehicles = 73,
	DontBlendFireOutro = 74,
	DiscardWhenOutOfAmmo = 75,
	DelayedFiringAfterAutoSwap = 76,
	EnforceFiringAngularThreshold = 77,
	ForcesActionMode = 78,
	CreatesAPotentialExplosionEventWhenFired = 79,
	CreateBulletExplosionWhenOutOfTime = 80,
	DelayedFiringAfterAutoSwapPreviousWeapon = 81,
	DisableCombatRoll = 82,
	NoWheelStats = 83,
	ProcessGripAnim = 84,
	DisableStealth = 85,
	DangerousLookingMeleeWeapon = 86,
	QuitTransitionToIdleIntroOnWeaponChange = 87,
	DisableLeftHandIkWhenOnFoot = 88,
	IgnoreHelmets = 89,
	Rpg = 90,
	NoAmmoDisplay = 91,
	TorsoIKForWeaponBlock = 92,
	LongWeapon = 93,
	_0xAF443B5F = 94,
	_0xE3C63C3B = 95,
	_0x1E3D23FF = 96,
	AssistedAimVehicleWeapon = 97,
	CanBlowUpVehicleAtZeroBodyHealth = 98,
	IgnoreAnimReloadRateModifiers = 99,
	DisableIdleAnimationFilter = 100,
	PenetrateVehicles = 101,
	_0xBDBBC7FE = 102,
	HomingToggle = 103,
	ApplyVehicleDamageToEngine = 104,
	Turret = 105,
	DisableAimAngleChecksForReticule = 106,
	AllowMovementDuringFirstPersonScope = 107,
	DriveByMPOnly = 108,
	PlacedOnly = 109,
	CreateWeaponWithNoModel = 110,
	RemoveWhenUnequipped = 111,
	BlockAmbientIdles = 112,
	NotUnarmed = 113,
	UseFPSAimIK = 114,
	DisableFPSScope = 115,
	DisableFPSAimForScope = 116,
	EnableFPSRNGOnly = 117,
	EnableFPSIdleOnly = 118,
	MeleeHatchet = 119,
	UseAlternateFPDrivebyClipset = 120,
	AttachFPSLeftHandIKToRight = 121,
	OnlyUseAimingInfoInFPS = 122,
	UseFPSAnimatedRecoil = 123,
	UseFPSSecondaryMotion = 124,
	HasFPSProjectileWeaponAnims = 125,
	AllowMeleeBlock = 126,
	DontPlayDryFireAnim = 127,
	SwapToUnarmedWhenOutOfThrownAmmo = 128,
	PlayOutOfAmmoAnim = 129,
	DisableIdleAnimationFilterWhenReloading = 130,
	OnFootHoming = 131,
	DamageCausesDisputes = 132,
	UsePlaneExplosionDamageCapInMP = 133,
	FPSOnlyExitFireAnimAfterRecoilEnds = 134,
	SkipVehiclePetrolTankDamage = 135,
	DontAutoSwapOnPickUp = 136,
	DisableTorsoIKAboveAngleThreshold = 137,
	MeleeFist = 138,
	NotAllowedForDriveby = 139,
	AttachReloadObjectToRightHand = 140,
	CanBeAimedLikeGunWithoutFiring = 141,
	MeleeMachete = 142,
	HideReticule = 143,
	UseHolsterAnimation = 144,
	BlockFirstPersonStateTransitionWhileFiring = 145,
	ForceFullFireAnimation = 146,
	DisableLeftHandIkInDriveby = 147,
	CanUseInVehMelee = 148,
	UseVehicleWeaponBoneForward = 149,
	UseManualTargetingMode = 150,
	IgnoreTracerVfxMuzzleDirectionCheck = 151,
	IgnoreHomingCloseThresholdCheck = 152,
	LockOnRequiresAim = 153,
	DisableCameraPullAround = 154,
	VehicleChargedLaunch = 155,
	ForcePedAsFiringEntity = 156,
	FiringEntityIgnoresExplosionDamage = 157,
	IdlePhaseBasedOnTrigger = 158,
	HighSpinRate = 159,
	EnabledOnlyWhenVehTransformed = 160,
	IncendiaryGuaranteedChance = 161,
	UseCameraHeadingForHomingTargetCheck = 162,
	UseWeaponRangeForTargetProbe = 163,
	SkipProjectileLOSCheck = 164,
	UseRevolverBehaviour = 165,
	UseSingleActionBehaviour = 166,
	_0x68F30C0A = 167,
	UseInstantAnimBlendFromIdleToFire = 168,
	UseInstantAnimBlendFromFireToIdle = 169,
	_0x53D0CED3 = 170,
	FireAnimRateScaledToTimeBetweenShots = 171,
	_0xC2A180AE = 172,
	_0xC03C4B08 = 173,
	_0x7CACFF1F = 174,
	BoatWeaponIsNotSearchLight = 175,
	AllowFireInterruptWhenReady = 176,
	ResponsiveRecoilRecovery = 177,
	OnlyLockOnToAquaticVehicles = 178,
}
eAmmoSpecialType = {
    None = 0,
    ArmorPiercing = 1,
    Explosive = 2,
    FMJ = 3,
    HollowPoint = 4,
    Incendiary = 5,
    Tracer = 6
}
eEffectGroup = {
    WEAPON_EFFECT_GROUP_PUNCH_KICK = 0,
    WEAPON_EFFECT_GROUP_MELEE_WOOD = 1,
    WEAPON_EFFECT_GROUP_MELEE_METAL = 2,
    WEAPON_EFFECT_GROUP_MELEE_SHARP = 3,
    WEAPON_EFFECT_GROUP_MELEE_GENERIC = 4,
    WEAPON_EFFECT_GROUP_PISTOL_SMALL = 5,
    WEAPON_EFFECT_GROUP_PISTOL_LARGE = 6,
    WEAPON_EFFECT_GROUP_PISTOL_SILENCED = 7,
	WEAPON_EFFECT_GROUP_RUBBER = 8,
    WEAPON_EFFECT_GROUP_SMG = 9,
    WEAPON_EFFECT_GROUP_SHOTGUN = 10,
    WEAPON_EFFECT_GROUP_RIFLE_ASSAULT = 11,
    WEAPON_EFFECT_GROUP_RIFLE_SNIPER = 12,
    WEAPON_EFFECT_GROUP_ROCKET = 13,
    WEAPON_EFFECT_GROUP_GRENADE = 14,
    WEAPON_EFFECT_GROUP_MOLOTOV = 15,
    WEAPON_EFFECT_GROUP_FIRE = 16,
    WEAPON_EFFECT_GROUP_EXPLOSION = 17,
    WEAPON_EFFECT_GROUP_LASER = 18,
    WEAPON_EFFECT_GROUP_STUNGUN = 19,
    WEAPON_EFFECT_GROUP_HEAVY_MG = 20,
    WEAPON_EFFECT_GROUP_VEHICLE_MG = 21
}
eAmmoFlags = {
    InfiniteAmmo = 0,
    AddSmokeOnExplosion = 1,
    Fuse = 2,
    FixedAfterExplosion = 3
}
eProjectileFlags = {
    Sticky = 0,
    DestroyOnImpact = 1,
    ProcessImpacts = 2,
    HideDrawable = 3,
    TrailFxInactiveOnceWet = 4,
    TrailFxRemovedOnImpact = 5,
    DoGroundDisturbanceFx = 6,
    CanBePlaced = 7,
    NoPullPin = 8,
    DelayUntilSettled = 9,
    CanBeDestroyedByDamage = 10,
    CanBounce = 11,
    DoubleDamping = 12,
    StickToPeds = 13,
    H_0x2E3F9CBA = 14,
    H_0x6EE86D27 = 15,
    ApplyDamageOnImpact = 16,
    SetOnFireOnImpact = 17,
    DontFireAnyEvents = 18,
    AlignWithTrajectory = 19,
    ExplodeAtTrailFxPos = 20,
    ProximityDetonation = 21,
    AlignWithTrajectoryYAxis = 22,
    HomingAttractor = 23,
    Cluster = 24
}