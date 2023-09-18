-- Author: George Chang (George0828Zhang)
-- Credits:
-- https://github.com/Yimura/GTAV-Classes
-- https://alexguirre.github.io/rage-parser-dumps/

gta_offset_types = {
    CAmmoInfo={
        Model={0x0014, "hash"},
        Audio={0x0018, "hash"},
        AmmoMax={0x0020, "int"},
        AmmoMax50={0x0024, "int"},
        AmmoMax100={0x0028, "int"},
        AmmoMaxMP={0x002C, "int"},
        AmmoMax50MP={0x0030, "int"},
        AmmoMax100MP={0x0034, "int"},
        AmmoFlags={0x0038, "flags32"},
        AmmoSpecialType={0x003c, "enum"},
        -- The all entris following are for projectiles only!
        Damage={0x0040, "float"},
        LifeTime={0x0044, "float"},
        FromVehicleLifeTime={0x0048, "float"},
        LifeTimeAfterImpact={0x004c, "float"},
        LifeTimeAfterExplosion={0x0050, "float"},
        ExplosionTime={0x0054, "float"},
        LaunchSpeed={0x0058, "float"},
        SeparationTime={0x005c, "float"},
        TimeToReachTarget={0x0060, "float"},
        Damping={0x0064, "float"},
        GravityFactor={0x0068, "float"},
        RicochetTolerance={0x006c, "float"},
        PedRicochetTolerance={0x0070, "float"},
        VehicleRicochetTolerance={0x0074, "float"},
        FrictionMultiplier={0x0078, "float"},
        Explosion={
            _base={val=0x007C},
            Default={0x00, "enum"},
            HitCar={0x04, "enum"},
            HitTruck={0x08, "enum"},
            HitBike={0x0C, "enum"},
            HitBoat={0x10, "enum"},
            HitPlane={0x14, "enum"}
        },
        FuseFx={0x0094, "hash"},
        ProximityFx={0x0098, "hash"},
        TrailFx={0x009c, "hash"},
        TrailFxUnderWater={0x00a0, "hash"},
        PrimedFx={0x00a4, "hash"},
        FuseFxFP={0x00a8, "hash"},
        PrimedFxFP={0x00ac, "hash"},
        TrailFxFadeInTime={0x00b0, "float"},
        TrailFxFadeOutTime={0x00b4, "float"},
        DisturbFxDefault={0x00b8, "hash"},
        DisturbFxSand={0x00bc, "hash"},
        DisturbFxWater={0x00c0, "hash"},
        DisturbFxDirt={0x00c4, "hash"},
        DisturbFxFoliage={0x00c8, "hash"},
        DisturbFxProbeDist={0x00cc, "float"},
        DisturbFxScale={0x00d0, "float"},
        GroundFxProbeDistance={0x00d4, "float"},
        FxAltTintColour={0x00d8, "bool"},
        LightOnlyActiveWhenStuck={0x00d9, "bool"},
        LightFlickers={0x00da, "bool"},
        LightSpeedsUp={0x00db, "bool"},
        LightBone={0x00dc, "gunbone"},
        LightColour={0x00e0, "vec3"},
        LightIntensity={0x00f0, "float"},
        LightRange={0x00f4, "float"},
        LightFalloffExp={0x00f8, "float"},
        LightFrequency={0x00fc, "float"},
        LightPower={0x0100, "float"},
        CoronaSize={0x0104, "float"},
        CoronaIntensity={0x0108, "float"},
        CoronaZBias={0x010c, "float"},
        ProximityAffectsFiringPlayer={0x0110, "bool"},
        ProximityCanBeTriggeredByPeds={0x0111, "bool"},
        ProximityActivationTime={0x0114, "float"},
        ProximityRepeatedDetonationActivationTime={0x0118, "float"},
        ProximityTriggerRadius={0x011c, "float"},
        ProximityFuseTimePed={0x0120, "float"},
        ProximityFuseTimeVehicleMin={0x0124, "float"},
        ProximityFuseTimeVehicleMax={0x0128, "float"},
        ProximityFuseTimeVehicleSpeed={0x012c, "float"},
        ProximityLightColourUntriggered={0x0130, "vec3"},
        ProximityLightFrequencyMultiplierTriggered={0x0140, "float"},
        TimeToIgnoreOwner={0x0144, "float"},
        ChargedLaunchTime={0x0148, "float"},
        ChargedLaunchSpeedMult={0x014c, "float"},
        ClusterExplosionTag={0x0150, "enum"},
        ClusterExplosionCount={0x0154, "int"},
        ClusterMinRadius={0x0158, "float"},
        ClusterMaxRadius={0x015c, "float"},
        ClusterInitialDelay={0x0160, "float"},
        ClusterInbetweenDelay={0x0164, "float"},
        ProjectileFlags={0x0168, "flags32"},
        -- The following 3 are for thrown weapons only!
        ThrownForce={0x0170, "float"},
        ThrownForceFromVehicle={0x0174, "float"},
        AmmoMaxMPBonus={0x0178, "float"},
        -- The following are for rocket weapons only!
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
        Slot={0x001C, "hash"}, -- makes weapon unusable
        DamageType={0x0020, "enum"},
        Explosion={
            _base={val=0x0024},
            Default={0x00, "enum"},
            HitCar={0x04, "enum"},
            HitTruck={0x08, "enum"},
            HitBike={0x0C, "enum"},
            HitBoat={0x10, "enum"},
            HitPlane={0x14, "enum"}
        },
        FrontClearTestParams={
            _base={val=0x003C},
            ShouldPerformFrontClearTest={0x00, "bool"},
            ForwardOffset={0x04, "float"},
            VerticalOffset={0x08, "float"},
            HorizontalOffset={0x0c, "float"},
            CapsuleRadius={0x10, "float"},
            CapsuleLength={0x14, "float"}
        },
        FireType={0x0054, "enum"},
        WheelSlot={0x0058, "enum"},
        -- AmmoInfo={0x0060, "ref_ammo"}, -- named ref: can't change ref if new ammo's addr not known
        -- AimingInfo={0x0068, "ref_aiming"},  -- named ref
        ClipSize={0x0070, "int"},
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
        OverrideForces={
            0x00e8, "at_array",
            ItemTemplate={
                -- _base set at runtime
                BoneTag={0x00, "enum"},
                ForceFront={0x04, "float"},
                ForceBack={0x08, "float"}
            },
            ItemSize=0xc,
            Count={0x00f0, "int16"}
        },
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
        Fx={
            _base={val=0x0170},
            EffectGroup={0x0, "enum"},
            FlashFx={0x4, "hash"},
            FlashFxAlt={0x8, "hash"},
            FlashFxFP={0xc, "hash"},
            FlashFxFPAlt={0x10, "hash"},
            MuzzleSmokeFx={0x14, "hash"},
            MuzzleSmokeFxFP={0x18, "hash"},
            MuzzleSmokeFxMinLevel={0x1c, "float"},
            MuzzleSmokeFxIncPerShot={0x20, "float"},
            MuzzleSmokeFxDecPerSec={0x24, "float"},
            MuzzleOverrideOffset={0x30, "vec3"},
            ShellFx={0x44, "hash"},
            ShellFxFP={0x48, "hash"},
            TracerFx={0x4c, "hash"},
            PedDamageHash={0x50, "hash"},
            TracerFxChanceSP={0x54, "float"},
            TracerFxChanceMP={0x58, "float"},
            FlashFxChanceSP={0x60, "float"},
            FlashFxChanceMP={0x64, "float"},
            FlashFxAltChance={0x68, "float"},
            FlashFxScale={0x6c, "float"},
            FlashFxLightEnabled={0x70, "bool"},
            FlashFxLightCastsShadows={0x71, "bool"},
            FlashFxLightOffsetDist={0x74, "float"},
            FlashFxLightRGBAMin={0x80, "vec3"},
            FlashFxLightRGBAMax={0x90, "vec3"},
            FlashFxLightIntensityMinMax={0xa0, "vec2"},
            FlashFxLightRangeMinMax={0xa8, "vec2"},
            FlashFxLightFalloffMinMax={0xb0, "vec2"},
            GroundDisturbFxEnabled={0xb8, "bool"},
            GroundDisturbFxDist={0xbc, "float"},
            GroundDisturbFxNameDefault={0xc0, "hash"},
            GroundDisturbFxNameSand={0xc4, "hash"},
            GroundDisturbFxNameDirt={0xc8, "hash"},
            GroundDisturbFxNameWater={0xcc, "hash"},
            GroundDisturbFxNameFoliage={0xd0, "hash"}
        },
        InitialRumbleDuration={0x0250, "int"},
        InitialRumbleIntensity={0x0254, "float"},
        InitialRumbleIntensityTrigger={0x0258, "float"},
        RumbleDuration={0x025c, "int"},
        RumbleIntensity={0x0260, "float"},
        RumbleIntensityTrigger={0x0264, "float"},
        RumbleDamageIntensity={0x0268, "float"},
        InitialRumbleDurationFps={0x026c, "int"},
        InitialRumbleIntensityFps={0x0270, "float"},
        RumbleDurationFps={0x0274, "int"},
        RumbleIntensityFps={0x0278, "float"},
        NetworkPlayerDamageModifier={0x027c, "float"},
        NetworkPedDamageModifier={0x0280, "float"},
        NetworkHeadShotPlayerDamageModifier={0x0284, "float"},
        LockOnRange={0x0288, "float"},
        WeaponRange={0x028c, "float"},
        AiSoundRange={0x0290, "float"},
        AiPotentialBlastEventRange={0x0294, "float"},
        DamageFallOffRangeMin={0x0298, "float"},
        DamageFallOffRangeMax={0x029c, "float"},
        DamageFallOffModifier={0x02a8, "float"},
        VehicleWeaponHash={0x02b4, "float"},
        DefaultCameraHash={0x02b8, "hash"},
        AimCameraHash={0x02bc, "hash"},
        FireCameraHash={0x02c0, "hash"},
        CoverCameraHash={0x02c4, "hash"},
        CoverReadyToFireCameraHash={0x02c8, "hash"},
        RunAndGunCameraHash={0x02cc, "hash"},
        CinematicShootingCameraHash={0x02d0, "hash"},
        AlternativeOrScopedCameraHash={0x02d4, "hash"},
        RunAndGunAlternativeOrScopedCameraHash={0x02d8, "hash"},
        CinematicShootingAlternativeOrScopedCameraHash={0x02dc, "hash"},
        PovTurretCameraHash={0x02e0, "hash"},
        RecoilShakeHash={0x02e4, "hash"},
        RecoilShakeHashFirstPerson={0x02e8, "hash"},
        AccuracyOffsetShakeHash={0x02ec, "hash"},
        MinTimeBetweenRecoilShakes={0x02f0, "float"},
        RecoilShakeAmplitude={0x02f4, "float"},
        ExplosionShakeAmplitude={0x02f8, "float"},
        CameraFov={0x02fc, "float"},
        FirstPersonAimFovMin={0x0300, "float"},
        FirstPersonAimFovMax={0x0304, "float"},
        FirstPersonScopeFov={0x0308, "float"},
        FirstPersonScopeAttachmentFov={0x030c, "float"},
        FirstPersonDrivebyIKOffset={0x0310, "vec3"},
        FirstPersonRNGOffset={0x0320, "vec3"},
        FirstPersonRNGRotationOffset={0x0330, "vec3"},
        FirstPersonLTOffset={0x0340, "vec3"},
        FirstPersonLTRotationOffset={0x0350, "vec3"},
        FirstPersonScopeOffset={0x0360, "vec3"},
        FirstPersonScopeAttachmentOffset={0x0370, "vec3"},
        FirstPersonScopeRotationOffset={0x0380, "vec3"},
        FirstPersonScopeAttachmentRotationOffset={0x0390, "vec3"},
        FirstPersonAsThirdPersonIdleOffset={0x03a0, "vec3"},
        FirstPersonAsThirdPersonRNGOffset={0x03b0, "vec3"},
        FirstPersonAsThirdPersonLTOffset={0x03c0, "vec3"},
        FirstPersonAsThirdPersonScopeOffset={0x03d0, "vec3"},
        FirstPersonAsThirdPersonWeaponBlockedOffset={0x03e0, "vec3"},
        FirstPersonDofSubjectMagnificationPowerFactorNear={0x03f0, "float"},
        FirstPersonDofMaxNearInFocusDistance={0x03f4, "float"},
        FirstPersonDofMaxNearInFocusDistanceBlendLevel={0x03f8, "float"},
        FirstPersonScopeAttachmentData={
            0x0400, "at_array",
            ItemTemplate={
                -- _base set at runtime
                Name={0x00, "hash"},
                FirstPersonScopeAttachmentFov={0x04, "float"},
                FirstPersonScopeAttachmentOffset={0x10, "vec3"},
                FirstPersonScopeAttachmentRotationOffset={0x20, "vec3"},
            },
            ItemSize=0x30,
            Count={0x0408, "int16"}
        },
        ZoomFactorForAccurateMode={0x0410, "float"},
        AimOffsetMin={0x0420, "vec3"},
        AimOffsetMax={0x0430, "vec3"},
        TorsoAimOffset={0x0440, "vec2"},
        TorsoCrouchedAimOffset={0x0448, "vec2"},
        AimProbeLengthMin={0x0450, "float"},
        AimProbeLengthMax={0x0454, "float"},
        AimOffsetMinFPSIdle={0x0460, "vec3"},
        AimOffsetMedFPSIdle={0x0470, "vec3"},
        AimOffsetMaxFPSIdle={0x0480, "vec3"},
        AimOffsetMinFPSLT={0x0490, "vec3"},
        AimOffsetMaxFPSLT={0x04a0, "vec3"},
        AimOffsetMinFPSRNG={0x04b0, "vec3"},
        AimOffsetMaxFPSRNG={0x04c0, "vec3"},
        AimOffsetMinFPSScope={0x04d0, "vec3"},
        AimOffsetMaxFPSScope={0x04e0, "vec3"},
        AimOffsetEndPosMinFPSIdle={0x04f0, "vec3"},
        AimOffsetEndPosMedFPSIdle={0x0500, "vec3"},
        AimOffsetEndPosMaxFPSIdle={0x0510, "vec3"},
        AimOffsetEndPosMinFPSLT={0x0520, "vec3"},
        AimOffsetEndPosMedFPSLT={0x0530, "vec3"},
        AimOffsetEndPosMaxFPSLT={0x0540, "vec3"},
        AimProbeRadiusOverrideFPSIdle={0x0550, "float"},
        AimProbeRadiusOverrideFPSIdleStealth={0x0554, "float"},
        AimProbeRadiusOverrideFPSLT={0x0558, "float"},
        AimProbeRadiusOverrideFPSRNG={0x055c, "float"},
        AimProbeRadiusOverrideFPSScope={0x0560, "float"},
        LeftHandIkOffset={0x0570, "vec3"},
        IkRecoilDisplacement={0x0580, "float"},
        IkRecoilDisplacementScope={0x0584, "float"},
        IkRecoilDisplacementScaleBackward={0x0588, "float"},
        IkRecoilDisplacementScaleVertical={0x058c, "float"},
        ReticuleHudPosition={0x0590, "vec2"},
        ReticuleHudPositionOffsetForPOVTurret={0x0598, "vec2"},
        ReticuleMinSizeStanding={0x05a0, "float"},
        ReticuleMinSizeCrouched={0x05a4, "float"},
        ReticuleScale={0x05a8, "float"},
        ReticuleStyleHash={0x05ac, "hash"},
        FirstPersonReticuleStyleHash={0x05b0, "hash"},
        PickupHash={0x05b4, "hash"},
        MPPickupHash={0x05b8, "hash"},
        HumanNameHash={0x05bc, "hash"},
        AudioCollisionHash={0x05c0, "hash"},
        MovementModeConditionalIdle={0x05c4, "hash"},
        AmmoDiminishingRate={0x05c8, "byte"},
        HudDamage={0x05c9, "byte"},
        HudSpeed={0x05ca, "byte"},
        HudCapacity={0x05cb, "byte"},
        HudAccuracy={0x05cc, "byte"},
        HudRange={0x05cd, "byte"},
        AimingBreathingAdditiveWeight={0x05d0, "float"},
        FiringBreathingAdditiveWeight={0x05d4, "float"},
        StealthAimingBreathingAdditiveWeight={0x05d8, "float"},
        StealthFiringBreathingAdditiveWeight={0x05dc, "float"},
        AimingLeanAdditiveWeight={0x05e0, "float"},
        FiringLeanAdditiveWeight={0x05e4, "float"},
        StealthAimingLeanAdditiveWeight={0x05e8, "float"},
        StealthFiringLeanAdditiveWeight={0x05ec, "float"},
        -- StatName={0x05f0, "string"}, -- no pointer:patch_string and no safe workaround
        KnockdownCount={0x05f8, "int"},
        KillshotImpulseScale={0x05fc, "float"},
        NmShotTuningSet={0x0600, "hash"},
        AttachPoints={
            0x0604, "array",
            ItemTemplate={
                -- _base set at runtime
                AttachBone={0x00, "hash"},
                Components={
                    0x08, "array",
                    ItemTemplate={
                        -- _base set at runtime
                        Name={0x00, "hash"},
                        Default={0x04, "bool"}
                    },
                    ItemSize=0x8,
                    Count={0x68, "int"}
                }
            },
            ItemSize=0x6c,
            Count={0x08f8, "int"}
        },
        GunFeedBone={0x08fc, "gunbone"},
        WeaponFlags={0x0900, "flags192"},
        -- TintSpecValues={0x0918, "STRUCT.EXTERNAL_NAMED"}, -- named ref
        -- FiringPatternAliases={0x0920, "STRUCT.EXTERNAL_NAMED"}, -- named ref
        -- ReloadUpperBodyFixupExpressionData={0x0928, "STRUCT.EXTERNAL_NAMED"}, -- named ref
        TargetSequenceGroup={0x0930, "hash"},
        BulletDirectionOffsetInDegrees={0x0934, "float"},
        BulletDirectionPitchOffset={0x0938, "float"},
        BulletDirectionPitchHomingOffset={0x093c, "float"},
        ExpandPedCapsuleRadius={0x0954, "float"},
        VehicleAttackAngle={0x0958, "float"},
        TorsoIKAngleLimit={0x095c, "float"},
        MeleeDamageMultiplier={0x0960, "float"},
        MeleeRightFistTargetHealthDamageScaler={0x0964, "float"},
        AirborneAircraftLockOnMultiplier={0x0968, "float"},
        ArmouredVehicleGlassDamageOverride={0x096c, "float"},
        -- CamoDiffuseTexIdxs={0x0970, "MAP.ATBINARYMAP"}, -- named ref + map(unk struct)
        RotateBarrelBone={0x0988, "gunbone"},
        RotateBarrelBone2={0x098a, "gunbone"}
    },
}

-- static addresses

function get_world_addr()
    local world_base = memory.scan_pattern("48 8B 05 ? ? ? ? 45 ? ? ? ? 48 8B 48 08 48 85 C9 74 07")
    if world_base:is_null() then
        log.warning("World address is null! Either the pattern changed or something else is wrong.")
        return nil
    end
    local world_offset = world_base:add(3):get_dword()
    local world_addr = world_base:add(world_offset + 7)
    if world_addr:is_null() then
        log.warning("World address is null! Either the pattern changed or something else is wrong.")
        return nil
    end
    return world_addr:deref()
end

function get_wpn_mgr_addr(world_addr)
    if world_addr == nil then world_addr = get_world_addr() end
    local cped = world_addr:add(0x8):deref()
    if cped:is_null() then
        log.warning("CPed address is null! Either the offset changed or something else is wrong.")
        return nil
    end
    local wpn_mgr = cped:add(0x10B8):deref()
    if wpn_mgr:is_null() then
        log.warning("CPedWeaponManager address is null! Either the offset changed or something else is wrong.")
        return nil
    end
    return wpn_mgr
end

-- dynamic addresses

function get_wpn_info_addr(wpn_mgr_addr)
    if wpn_mgr_addr == nil then return nil end
    local addr = wpn_mgr_addr:add(0x20):deref()
    if addr:is_null() then
        return nil
    end
    return addr
end

function get_ammo_info_addr(wpn_info_addr)
    local addr = wpn_info_addr:add(0x60):deref()
    if addr:is_null() then -- e.g. melee weapons is null
        return nil
    end
    return addr
end