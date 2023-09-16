# Weapon Editor
This mod allows you to stream modded `weapons.meta` to the game while it's running. i.e. You can mod weapon stats without changing game files.

## Basics
The file `weaponsmeta.lua` contains a multiline string:
```lua
weaponsmeta = [[
<Item type="CWeaponInfo">
  ...
</Item>
<Item type="CAmmoInfo">
  ...
</Item>
]]
```
All you need is to put modded items in the string. The mod will load on start or when you press `Reload meta`. All values in `lib/gtaoffsets` are supported.

Only include the items under `<Infos>`, i.e. `<Item type="CAmmoInfo">` or `<Item type="CWeaponInfo">`. Don't include e.g. `<CWeaponInfoBlob>`. See the included `weaponsmeta.lua` in the repo for a concrete example.

You don't need the complete Infos in `weapons.meta`. Just put the modified fields and values. Two exceptions to this are `<AttachPoints>` and `<WeaponFlags>`, for them you need to include the complete list of values.

Checkout this tutorial for the meanings of each value: https://forums.gta5-mods.com/topic/36832/tutorial-basic-editing-of-weapons-meta

## Enums
For enumeration (e.g. `<Explosion>`) and flag types (e.g. `<ProjectileFlags>`), you can refer to `lib/gtaenums.lua` for lists of valid values.

## AmmoInfo
In the current state, changes on ammo are shared among weapons that use said ammo. For instance, if I put the following, then all pistols will be have hollow point.
```xml
<Item type="CAmmoInfo">
  <Name>AMMO_PISTOL</Name>
  <AmmoSpecialType>HollowPoint</AmmoSpecialType>
</Item>
```
## Model and Audio
You can change the weapon model or audio like this:
```xml
<Item type="CWeaponInfo">
  <Name>WEAPON_PETROLCAN</Name>
  <Model>W_AM_Jerrycan_SF</Model>
</Item>
```
- For audio, the sound needs to have been played before.
- For model, replacing similar guns works fine. Otherwise the new model might be misaligned or outright won't appear.
  - For the latter I recommend [ObjectSpoofer.lua](https://github.com/George0828Zhang/Fun-House/blob/main/ObjectSpoofer.lua) script for better way to "replace" weapon models.

## Attachments
You can add attachments to different guns by the following steps
1. Add an `<Item>` to a desired bone in `<AttachPoints>`. For example the following adds `COMPONENT_HEAVYSNIPER_MK2_CLIP_EXPLOSIVE` to `WAPClip`:
```xml
<Item type="CWeaponInfo">
  <Name>WEAPON_PRECISIONRIFLE</Name>
  <AttachPoints>
    <Item>
      <AttachBone>WAPClip</AttachBone>
      <Components>
        <Item>
          <Name>COMPONENT_PRECISIONRIFLE_CLIP_01</Name>
          <Default value="true" />
        </Item>
        <Item>
          <Name>COMPONENT_HEAVYSNIPER_MK2_CLIP_EXPLOSIVE</Name>
          <Default value="false" />
        </Item>
      </Components>
    </Item>
  </AttachPoints>
</Item>
```
2. Go in-game and open Yimmenu -> Weapon Editor
3. Set `Enabled` and press `Reload meta` to reload changes.
4. Equip the modded weapon now.
5. Go back to Weapon Editor and all modded attachments should appear in the box.
6. Click on an attachment to equip / remove.
7. You could set `<Default value="true" />`, and toggle `Default Attachments` in the menu. This will auto-equip default attachments for you upon weapon switch.


It seems the `<AttachBone>bone_name</AttachBone>` does not matter, the game uses a fixed set of bones for each weapon and the set also follows a particular order (the order in their original CWeaponInfo).

* Using different bones or order, the attachments will appear (and take effect) but the position is wrong.

The best practice now is to simply add `<Item>` to a desired existing bone. ***Don't go beyond 12 components per bone, it leads to undefined behaviour.***

For example, you can add new scopes for any weapon with `<AttachBone>WAPScop</AttachBone>` or `WAPScop_2` in their CWeaponInfo, like so:
```xml
<Item>
  <AttachBone>WAPScop</AttachBone>
  <Components>
    <Item>
      <Name>COMPONENT_AT_SIGHTS</Name>
      <Default value="true" />
    </Item>
    <Item>
      <Name>COMPONENT_AT_SCOPE_SMALL_MK2</Name>
      <Default value="false" />
    </Item>
    <Item>
      <Name>COMPONENT_AT_SCOPE_MACRO_MK2</Name>
      <Default value="false" />
    </Item>
    <Item>
      <Name>COMPONENT_AT_SCOPE_MEDIUM_MK2</Name>
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
Here are more components: https://wiki.rage.mp/index.php?title=Weapons_Components

## Conflicts
- Rule of thumb: If you want global effect on all weapons -> go with Yimmenu options.
- Undefined just means two values will be set back and forth.

|  weaponsmeta field    | Yimmenu |Behaviour|
| -------- | ------- |-|
| Explosion, AmmoSpecialType |   Self>Weapons>Enable Special Ammo  |Undefined|
| WeaponRange |  Self>Weapons>Infinite Range |Undefined|
| RecoilShakeAmplitude |  Self>Weapons>No Recoil |Undefined|
| AccuracySpread |  Self>Weapons>No Spread|Undefined|
| Damage, *DamageModifier |  Self>Weapons>Damage Override|Yimmenu overrides WeaponEditor|
| VEHICLE_WEAPON_* (soon be added) |  Self>Vehicle>Fun Features>Custom vehicle Weapons|Undefined|