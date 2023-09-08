gta_offset_types = {
    CAmmoInfo={
        Model={0x0014, "hash"},
        Audio={0x0018, "hash"},
        -- AmmoMax value="20" />
        -- AmmoMax50 value="20" />
        -- AmmoMax100 value="20" />
        -- AmmoMaxMP value="20" />
        -- AmmoMax50MP value="20" />
        -- AmmoMax100MP value="20" />
        AmmoFlags={0x0038, "flags32"},
        AmmoSpecialType={0x003c, "enum"},
        
        LifeTime={0x0044, "float"},
        FromVehicleLifeTime={0x0048, "float"},
        LaunchSpeed={0x0058, "float"},
        Explosion={--0x007C
            Default={0x007C, "enum"},
            HitCar={0x007C+0x4, "enum"},
            HitTruck={0x007C+0x8, "enum"},
            HitBike={0x007C+0xC, "enum"},
            HitBoat={0x007C+0x10, "enum"},
            HitPlane={0x007C+0x14, "enum"}
        },
        FuseFx={0x0094, "hash"},
        ProximityFx={0x0098, "hash"},
        TrailFx={0x009c, "hash"},
        -- <TrailFxUnderWater />
        -- <FuseFxFP />
        -- <PrimedFxFP />
        -- <TrailFxFadeInTime value="0.000000" />
        -- <TrailFxFadeOutTime value="0.000000" />
        -- <PrimedFx />
        -- <DisturbFxDefault>proj_disturb_dust</DisturbFxDefault>
        -- <DisturbFxSand>proj_disturb_dust</DisturbFxSand>
        -- <DisturbFxWater>proj_disturb_dust</DisturbFxWater>
        -- <DisturbFxDirt>proj_disturb_dust</DisturbFxDirt>
        -- <DisturbFxFoliage>proj_disturb_dust</DisturbFxFoliage>
        -- <DisturbFxProbeDist value="0.000000" />
        -- <DisturbFxScale value="0.000000" />
        -- <GroundFxProbeDistance value="2.500000" />
        -- <LightOnlyActiveWhenStuck value="false" />
        -- <LightFlickers value="false" />
        -- <LightSpeedsUp value="false" />
        -- <LightBone />
        -- <LightColour x="0.000000" y="0.000000" z="0.000000" />
        -- <LightIntensity value="0.000000" />
        -- <LightRange value="0.000000" />
        -- <LightFalloffExp value="0.000000" />
        -- <LightFrequency value="0.000000" />
        -- <LightPower value="0.000000" />
        -- <CoronaSize value="0.000000" />
        -- <CoronaIntensity value="0.000000" />
        -- <CoronaZBias value="0.000000" />
        -- <ProjectileFlags>DestroyOnImpact ProcessImpacts DoGroundDisturbanceFx</ProjectileFlags>
        -- <ProximityActivationTime value="3.000000" />
        -- <ProximityTriggerRadius value="-1.000000" />
        -- <ProximityFuseTimePed value="1.000000" />
        -- <ProximityFuseTimeVehicleMin value="0.500000" />
        -- <ProximityFuseTimeVehicleMax value="0.050000" />
        -- <ProximityFuseTimeVehicleSpeed value="30.000000" />
        -- <ProximityLightColourUntriggered x="0.000000" y="0.000000" z="0.000000" />
        -- <ProximityLightFrequencyMultiplierTriggered value="4.000000" />
        -- <ChargedLaunchTime value="-1.000000" />
        -- <ChargedLaunchSpeedMult value="1.000000" />
        -- <ClusterExplosionTag>GRENADE</ClusterExplosionTag>
        -- <ClusterExplosionCount value="5" />
        -- <ClusterMinRadius value="5.000000" />
        -- <ClusterMaxRadius value="10.000000" />
        -- <ClusterInitialDelay value="0.500000" />
        -- <ClusterInbetweenDelay value="0.250000" />
        ForwardDragCoeff={0x0170, "float"},
        SideDragCoeff={0x0174, "float"},
        TimeBeforeHoming={0x0178, "float"},
        TimeBeforeSwitchTargetMin={0x017c, "float"},
        TimeBeforeSwitchTargetMax={0x0180, "float"},
        ProximityRadius={0x0184, "float"},
        PitchChangeRate={0x0188, "float"},
        YawChangeRate={0x018c, "float"},
        RollChangeRate={0x0190, "float"},
        MaxRollAngleSin={0x0194, "float"},
        LifeTimePlayerVehicleLockedOverrideMP={0x0198, "float"},
        HomingRocketParams={-- 0x019c
            ShouldUseHomingParamsFromInfo={0x019c, "bool"},
            ShouldIgnoreOwnerCombatBehaviour={0x019c+0x01, "bool"},
            TimeBeforeStartingHoming={0x019c+0x04, "float"},
            TimeBeforeHomingAngleBreak={0x019c+0x08, "float"},
            TurnRateModifier={0x019c+0x0c, "float"},
            PitchYawRollClamp={0x019c+0x10, "float"},
            DefaultHomingRocketBreakLockAngle={0x019c+0x14, "float"},
            DefaultHomingRocketBreakLockAngleClose={0x019c+0x18, "float"},
            DefaultHomingRocketBreakLockCloseDistance={0x019c+0x1c, "float"}
        }
    },
    CWeaponInfo={
        Model={0x0014, "hash"},
        Audio={0x0018, "hash"},
        DamageType={0x0020, "enum"},
        Explosion={
            Default={0x0024, "enum"},
            HitCar={0x0028, "enum"},
            HitTruck={0x002C, "enum"},
            HitBike={0x0030, "enum"},
            HitBoat={0x0034, "enum"},
            HitPlane={0x0038, "enum"}
        },
        FireType={0x0054, "enum"},
        AmmoInfo={0x0060, "ref"},
        ClipSize={0x0070, "int"}, -- doesn't seem to work
        AccuracySpread={0x0074, "float"},
        AccurateModeAccuracyModifier={0x0078, "float"},
        RunAndGunAccuracyModifier={0x007c, "float"},
        RunAndGunAccuracyMinOverride={0x0080, "float"},
        RecoilAccuracyMax={0x0084, "float"},
        RecoilErrorTime={0x0088, "float"},
        RecoilRecoveryRate={0x008c, "float"},
        RecoilAccuracyToAllowHeadShotAI={0x0090, "float"},
        MinHeadShotDistanceAI={0x0094, "float"},
        MaxHeadShotDistanceAI={0x0098, "float"},
        HeadShotDamageModifierAI={0x009c, "float"},
        RecoilAccuracyToAllowHeadShotPlayer={0x00a0, "float"},
        MinHeadShotDistancePlayer={0x00a4, "float"},
        MaxHeadShotDistancePlayer={0x00a8, "float"},
        HeadShotDamageModifierPlayer={0x00ac, "float"},
        Damage={0x00B0, "float"},
        DamageTime={0x00B0, "float"},
        DamageTimeInVehicle={0x00b4, "float"},
        DamageTimeInVehicleHeadShot={0x00bc, "float"},
        HitLimbsDamageModifier={0x00c8, "float"},
        NetworkHitLimbsDamageModifier={0x00cc, "float"},
        LightlyArmouredDamageModifier={0x00d0, "float"},
        VehicleDamageModifier={0x00d4, "float"},
        Force={0x00d8, "float"},
        ForceHitPed={0x00dc, "float"},
        ForceHitVehicle={0x00e0, "float"},
        ForceHitFlyingHeli={0x00e4, "float"},
        -- <OverrideForces> -- unknown offsets
        ForceMaxStrengthMult={0x00f8, "float"},
        ForceFalloffRangeStart={0x00fc, "float"},
        ForceFalloffRangeEnd ={0x0100, "float"},
        ForceFalloffMin={0x0104, "float"},
        ProjectileForce={0x0108, "float"},
        FragImpulse={0x010c, "float"},
        Penetration={0x0110, "float"},
        VerticalLaunchAdjustment={0x0114, "float"},
        DropForwardVelocity={0x0118, "float"},
        Speed={0x011c, "float"},
        BulletsInBatch={0x0120, "int"},
        BatchSpread={0x0124, "float"},
        ReloadTimeMP={0x0128, "float"},
        ReloadTimeSP={0x012c, "float"},
        VehicleReloadTime={0x0130, "float"},
        AnimReloadRate={0x0134, "float"},
        BulletsPerAnimLoop={0x0138, "int"},
        TimeBetweenShots={0x013c, "float"},
        TimeLeftBetweenShotsWhereShouldFireIsCached={0x0140, "float"},
        SpinUpTime={0x0144, "float"},
        SpinTime={0x0148, "float"},
        SpinDownTime={0x014c, "float"},
        AlternateWaitTime={0x0150, "float"},
        BulletBendingNearRadius={0x0154, "float"},
        BulletBendingFarRadius={0x0158, "float"},
        BulletBendingZoomedRadius={0x015c, "float"},
        FirstPersonBulletBendingNearRadius={0x0160, "float"},
        FirstPersonBulletBendingFarRadius={0x0164, "float"},
        FirstPersonBulletBendingZoomedRadius={0x0168, "float"},
        Fx={ -- 0x0170
            EffectGroup={0x0170, "enum"},
            FlashFx={0x0170+0x4, "hash"},
            FlashFxAlt={0x0170+0x8, "hash"},
            FlashFxFP={0x0170+0xc, "hash"},
            FlashFxFPAlt={0x0170+0x10, "hash"},
            MuzzleSmokeFx={0x0170+0x14, "hash"},
            MuzzleSmokeFxFP={0x0170+0x18, "hash"},
            MuzzleSmokeFxMinLevel={0x0170+0x1c, "float"},
            MuzzleSmokeFxIncPerShot={0x0170+0x20, "float"},
            MuzzleSmokeFxDecPerSec={0x0170+0x24, "float"},
            MuzzleOverrideOffset={0x0170+0x30, "vec3"},
            ShellFx={0x0170+0x44, "hash"},
            ShellFxFP={0x0170+0x48, "hash"},
            TracerFx={0x0170+0x4c, "hash"},
            PedDamageHash={0x0170+0x50, "hash"},
            TracerFxChanceSP={0x0170+0x54, "float"},
            TracerFxChanceMP={0x0170+0x58, "float"},
            FlashFxChanceSP={0x0170+0x60, "float"},
            FlashFxChanceMP={0x0170+0x64, "float"},
            FlashFxAltChance={0x0170+0x68, "float"},
            FlashFxScale={0x0170+0x6c, "float"},
            FlashFxLightEnabled={0x0170+0x70, "bool"},
            FlashFxLightCastsShadows={0x0170+0x71, "bool"},
            FlashFxLightOffsetDist={0x0170+0x74, "float"},
            FlashFxLightRGBAMin={0x0170+0x80, "vec3"},
            FlashFxLightRGBAMax={0x0170+0x90, "vec3"},
            FlashFxLightIntensityMinMax={0x0170+0xa0, "vec2"},
            FlashFxLightRangeMinMax={0x0170+0xa8, "vec2"},
            FlashFxLightFalloffMinMax={0x0170+0xb0, "vec2"},
            GroundDisturbFxEnabled={0x0170+0xb8, "bool"},
            GroundDisturbFxDist={0x0170+0xbc, "float"},
            GroundDisturbFxNameDefault={0x0170+0xc0, "hash"},
            GroundDisturbFxNameSand={0x0170+0xc4, "hash"},
            GroundDisturbFxNameDirt={0x0170+0xc8, "hash"},
            GroundDisturbFxNameWater={0x0170+0xcc, "hash"},
            GroundDisturbFxNameFoliage={0x0170+0xd0, "hash"}
        },
        WeaponFlags={0x0900, "flags192"}
    },
}