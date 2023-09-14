# Weapon Editor


## Components
Currently, it seems like the value of `<AttachBone>bone_name</AttachBone>` does not matter, the game follows a fixed set of bones for each weapon and the set also follows a particular order below.

* Using bones different from the original CWeaponInfo definition for the weapon may not work.
    - For example, adding `WAPScop` to service carbine, the scopes will be attached at gun root instead.
* Do not change the order of AttachBones. In general, the order follows:
    1. WAPClip
    2. WAPFlsh / WAPFlshLasr / WAPLasr
    3. WAPScop
    4. WAPSupp
    5. WAPGrip
    6. WAPBarrel
    7. gun_root

The best practice now is to simply add `<Item>` to `<Components>` of a desired bone. Don't go beyond 12 components, it leads to undefined behaviour. 

For example, you can add scopes for weapons with `<AttachBone>WAPScop</AttachBone>` in their CWeaponInfo, like so:
```
<Item>
    <AttachBone>WAPScop</AttachBone>
    <Components>
        <Item>
          <Name>COMPONENT_AT_SIGHTS</Name>
          <Default value="true" />
        </Item>
        <Item>
          <Name>COMPONENT_AT_SCOPE_SMALL</Name>
          <Default value="false" />
        </Item>
        <Item>
          <Name>COMPONENT_AT_SCOPE_SMALL_02</Name>
          <Default value="false" />
        </Item>
        <Item>
            <Name>COMPONENT_AT_SCOPE_SMALL_MK2</Name>
            <Default value="false" />
        </Item>
        <Item>
          <Name>COMPONENT_AT_SCOPE_MACRO</Name>
          <Default value="false" />
        </Item>
        <Item>
          <Name>COMPONENT_AT_SCOPE_MACRO_02</Name>
          <Default value="false" />
        </Item>
        <Item>
          <Name>COMPONENT_AT_SCOPE_MACRO_MK2</Name>
          <Default value="false" />
        </Item>
        <Item>
          <Name>COMPONENT_AT_SCOPE_MEDIUM</Name>
          <Default value="false" />
        </Item>
        <Item>
          <Name>COMPONENT_AT_SCOPE_MEDIUM_MK2</Name>
          <Default value="false" />
        </Item>
        <Item>
            <Name>COMPONENT_AT_SCOPE_MAX</Name>
            <Default value="false" />
        </Item>
        <Item>
            <Name>COMPONENT_AT_SCOPE_NV</Name>
            <Default value="false" />
        </Item>
        <Item>
            <Name>COMPONENT_AT_SCOPE_THERMAL</Name>
            <Default value="false" />
        </Item>
    </Components>
</Item>
```
There are more:
```
COMPONENT_AT_SCOPE_LARGE
COMPONENT_AT_SCOPE_LARGE_FIXED_ZOOM
COMPONENT_AT_SCOPE_LARGE_FIXED_ZOOM_MK2
COMPONENT_HEAVYRIFLE_SIGHT_01
```

<!-- COMPONENT_AT_PI_SUPP
COMPONENT_AT_PI_SUPP_02

COMPONENT_AT_AR_SUPP
COMPONENT_AT_AR_SUPP_02

COMPONENT_AT_SR_SUPP
COMPONENT_AT_SR_SUPP_03 -->