-- File Status: Good. Need to update sets with empy+3. Fix HP balance.

-- Author: Silvermutt
-- Required external libraries: SilverLibs
-- Required addons: N/A
-- Recommended addons: WSBinder, Reorganizer
-- Misc Recommendations: Disable RollTracker

-------------------------------------------------------------------------------------------------------------------
--  Keybinds
-------------------------------------------------------------------------------------------------------------------

--  Modes:      [ F9 ]              Cycle Offense Modes
--              [ CTRL+F9 ]         Cycle Hybrid Modes
--              [ WIN+F9 ]          Cycle Weapon Skill Modes
--              [ F10 ]             Emergency -PDT Mode
--              [ ALT+F10 ]         Toggle Kiting Mode
--              [ F11 ]             Emergency -MDT Mode
--              [ F12 ]             Update Current Gear / Report Current Status
--              [ CTRL+F12 ]        Cycle Idle Modes
--              [ ALT+F12 ]         Cancel Emergency -PDT/-MDT Mode
--              [ WIN+H ]           Toggle Charm Defense Mods
--              [ WIN+D ]           Toggle Death Defense Mods
--              [ WIN+K ]           Toggle Knockback Defense Mods
--              [ WIN+A ]           AttackMode: Capped/Uncapped WS Modifier
--              [ WIN+C ]           Toggle Capacity Points Mode
--              [ CTRL+PageUp ]     Cycle Toy Weapon Mode
--              [ CTRL+PageDown ]   Cycleback Toy Weapon Mode
--              [ ALT+PageDown ]    Reset Toy Weapon Mode
--              [ WIN+W ]           Toggle Rearming Lock
--                                  (off = re-equip previous weapons if you go barehanded)
--                                  (on = prevent weapon auto-equipping)
--
--  Abilities:  [ CTRL+- ]          Rune element cycle forward.
--              [ CTRL+= ]          Rune element cycle backward.
--              [ Numpad0 ]         Use current Rune
--
--              [ CTRL+` ]          Vivacious Pulse
--              [ ALT+` ]           Temper
--
--              [ CTRL+Numpad/ ]    Berserk/Meditate/Last Resort
--              [ CTRL+Numpad* ]    Warcry/Sekkanoki/Arcane Circle
--              [ CTRL+Numpad- ]    Aggressor/Third Eye/Souleater
--
--              [ ALT+W ]           Defender (WAR sub)/Weapon Bash (DRK sub)
--
--  Spells:     [ WIN+, ]           Utsusemi: Ichi
--              [ WIN+. ]           Utsusemi: Ni
--
--              [ ALT+U ]           Blink
--              [ ALT+I ]           Stoneskin
--              [ ALT+O ]           Phalanx
--              [ ALT+P ]           Aquaveil
--              [ ALT+; ]           Regen IV
--              [ ALT+' ]           Refresh
--              [ ALT+, ]           Blaze Spikes
--              [ ALT+. ]           Ice Spikes
--              [ ALT+/ ]           Shock Spikes
--
--              [ ALT+Q ]           Wild Carrot (BLU sub)
--              [ ALT+W ]           Cocoon (BLU sub)
--              [ ALT+E ]           Refueling (BLU sub)
--
--  Other:      [ ALT+D ]           Cancel Invisible/Hide & Use Key on <t>
--              [ ALT+S ]           Turn 180 degrees in place
--
--
--              (Global-Binds.lua contains additional non-job-related keybinds)


-------------------------------------------------------------------------------------------------------------------
--  Custom Commands (preface with /console to use these in macros)
-------------------------------------------------------------------------------------------------------------------


--  gs c rune                       Uses current rune
--  gs c cycle Runes                Cycles forward through rune elements
--  gs c cycleback Runes            Cycles backward through rune elements


-------------------------------------------------------------------------------------------------------------------
-- Setup functions for this job.  Generally should not be modified.
-------------------------------------------------------------------------------------------------------------------

-- Initialization function for this job file.
function get_sets()
  -- Load and initialize Mote library
  mote_include_version = 2
  include('Mote-Include.lua') -- Executes job_setup, user_setup, init_gear_sets
  coroutine.schedule(function()
    send_command('gs reorg')
  end, 1)
  coroutine.schedule(function()
    send_command('gs c weaponset current')
  end, 5)
end

-- Executes on first load and main job change
function job_setup()
  silibs.enable_cancel_outranged_ws()
  silibs.enable_cancel_on_blocking_status()
  silibs.enable_weapon_rearm()
  silibs.enable_auto_lockstyle(3)
  silibs.enable_premade_commands()
  silibs.enable_custom_roll_text()
  silibs.enable_equip_loop()

  rayke_duration = 46
  gambit_duration = 92

  runes.element_of = {['Lux']='Light', ['Tenebrae']='Dark', ['Ignis']='Fire', ['Gelus']='Ice', ['Flabra']='Wind',
      ['Tellus']='Earth', ['Sulpor']='Lightning', ['Unda']='Water'} -- Do not modify
  expended_runes={} -- Do not modify
  rayke_target=nil -- Do not modify
  gambit_target=nil -- Do not modify

  -- /BLU Spell Maps
  blue_magic_maps = {}
  blue_magic_maps.Enmity = S{'Blank Gaze', 'Geist Wall', 'Jettatura', 'Soporific',
      'Poison Breath', 'Blitzstrahl', 'Sheep Song', 'Chaotic Eye'}
  blue_magic_maps.Cure = S{'Wild Carrot'}
  blue_magic_maps.Buffs = S{'Cocoon', 'Refueling'}

  state.Kiting:set('On')
  state.PhysicalDefenseMode = M{['description'] = 'Physical Defense Mode', 'PDT', 'Encumbrance'}
  state.DefenseMode:set('Physical') -- Default to PDT mode
  state.OffenseMode:options('Normal', 'LowAcc', 'MidAcc', 'HighAcc')
  state.CastingMode:options('Normal', 'Safe')
  state.HybridMode:options('Normal', 'LightDef')
  state.IdleMode:options('Normal', 'LightDef')
  state.Knockback = M(false, 'Knockback')
  state.DeathResist = M(false, 'Death Resist Mode')
  state.WeaponSet = M{['description']='Weapon Set', 'Epeolatry', 'Lionheart', 'Lycurgos'}
  state.AttackMode = M{['description']='Attack', 'Uncapped', 'Capped'}
  state.CP = M(false, "Capacity Points Mode")
  state.ToyWeapons = M{['description']='Toy Weapons','None','Dagger',
      'Sword','Club','Staff','Polearm','GreatSword','Scythe'}
  state.Runes = M{['description']='Runes', 'Ignis', 'Gelus', 'Flabra', 'Tellus', 'Sulpor', 'Unda', 'Lux', 'Tenebrae'}

  send_command('bind !s gs c faceaway')
  send_command('bind !d gs c interact')

  send_command('bind @w gs c toggle RearmingLock')
  send_command('bind ^insert gs c weaponset cycle')
  send_command('bind ^delete gs c weaponset cycleback')

  send_command('bind ^pageup gs c toyweapon cycle')
  send_command('bind ^pagedown gs c toyweapon cycleback')
  send_command('bind !pagedown gs c toyweapon reset')

  send_command('bind @d gs c toggle DeathResist')

  send_command('bind %numpad0 input //gs c rune')
  send_command('bind !` input /ja "Vivacious Pulse" <me>')
  send_command('bind ^` input /ma "Temper" <me>')
  send_command('bind ^- gs c cycleback Runes')
  send_command('bind ^= gs c cycle Runes')
  send_command('bind @a gs c cycle AttackMode')
  send_command('bind @c gs c toggle CP')
  send_command('bind @k gs c toggle Knockback')

  send_command('bind !u input /ma "Blink" <me>')
  send_command('bind !i input /ma "Stoneskin" <me>')
  send_command('bind !o input /ma "Phalanx" <me>')
  send_command('bind !p input /ma "Aquaveil" <me>')

  send_command('bind !; input /ma "Regen IV" <stpc>')
  send_command('bind !\' input /ma "Refresh" <stpc>')

  send_command('bind !, input /ma "Blaze Spikes" <me>')
  send_command('bind !. input /ma "Ice Spikes" <me>')
  send_command('bind !/ input /ma "Shock Spikes" <me>')
end

-- Executes on first load, main job change, **and sub job change**
function user_setup()
  silibs.user_setup_hook()
  include('Global-Binds.lua') -- Additional local binds

  if player.sub_job == 'BLU' then
    send_command('bind !q input /ma "Wild Carrot" <stpc>')
    send_command('bind !w input /ma "Cocoon" <me>')
    send_command('bind !e input /ma "Refueling" <me>')
    coroutine.schedule(function()
      send_command('aset set sub')
    end, 2)
  elseif player.sub_job == 'WAR' then
    send_command('bind !w input /ja "Defender" <me>')
    send_command('bind ^numpad/ input /ja "Berserk" <me>')
    send_command('bind ^numpad* input /ja "Warcry" <me>')
    send_command('bind ^numpad- input /ja "Aggressor" <me>')
  elseif player.sub_job == 'DRK' then
    send_command('bind !w input /ja "Weapon Bash" <t>')
    send_command('bind ^numpad/ input /ja "Last Resort" <me>')
    send_command('bind ^numpad* input /ja "Arcane Circle" <me>')
    send_command('bind ^numpad- input /ja "Souleater" <me>')
  elseif player.sub_job == 'SAM' then
    send_command('bind !w input /ja "Third Eye" <me>')
    send_command('bind ^numpad/ input /ja "Meditate" <me>')
    send_command('bind ^numpad* input /ja "Sekkanoki" <me>')
    send_command('bind ^numpad- input /ja "Hasso" <me>')
  elseif player.sub_job == 'NIN' then
    send_command('bind ^numpad0 input /ma "Utsusemi: Ichi" <me>')
    send_command('bind ^numpad. input /ma "Utsusemi: Ni" <me>')
  end

  select_default_macro_book()
end

function job_file_unload()
  send_command('unbind !s')
  send_command('unbind !d')

  send_command('unbind @w')
  send_command('unbind ^insert')
  send_command('unbind ^delete')

  send_command('unbind ^pageup')
  send_command('unbind ^pagedown')
  send_command('unbind !pagedown')

  send_command('unbind @d')

  send_command('unbind !`')
  send_command('unbind ^`')
  send_command('unbind ^-')
  send_command('unbind ^=')
  send_command('unbind @a')
  send_command('unbind @c')
  send_command('unbind @k')

  send_command('unbind !u')
  send_command('unbind !i')
  send_command('unbind !o')
  send_command('unbind !p')

  send_command('unbind !;')
  send_command('unbind !\'')
  send_command('unbind !,')
  send_command('unbind !.')
  send_command('unbind !/')
  send_command('unbind !q')
  send_command('unbind !w')
  send_command('unbind !e')

  send_command('unbind ^numpad/')
  send_command('unbind ^numpad*')
  send_command('unbind ^numpad-')
  send_command('unbind ^numpad0')
  send_command('unbind ^numpad.')
  send_command('unbind %numpad0')
end

-- Define sets and vars used by this job file.
function init_gear_sets()
  sets.org.job = {}
  
  sets.TreasureHunter = {
    body=gear.Herc_TH_body, --2
    hands=gear.Herc_TH_hands, --2
  }
  sets.TreasureHunter.RA = set_combine(sets.TreasureHunter, {})

  ------------------------------------------------------------------------------------------------
  ---------------------------------------- Defense Sets ------------------------------------------
  ------------------------------------------------------------------------------------------------

  sets.LightDef = {
    sub="Utu Grip",             -- __/__, ___ [ 70]
    ammo="Staunch Tathlum +1",  --  3/ 3, ___ [___]
    head=gear.Nyame_B_head,     --  7/ 7, 123 [ 91]
    body=gear.Nyame_B_body,     --  9/ 9, 139 [136]
    legs=gear.Nyame_B_legs,     --  8/ 8, 150 [114]
    ear1="Odnowa Earring +1",   --  3/ 5, ___ [110]
    ring2="Defending Ring",     -- 10/10, ___ [___]
    back=gear.RUN_TP_Cape,      -- 10/__, ___ [___]
  } --50 PDT / 42 MDT, 412 MEVA [521 HP]

  sets.defense.Knockback = {
    -- back="Repulse Mantle"
  }

  sets.HeavyDef = {
    ammo="Staunch Tathlum +1",      --  3/ 3, ___ [___] __
    head=gear.Nyame_B_head,         --  7/ 7, 123 [ 91] __
    body="Erilaz Surcoat +2",       -- __/__, 120 [133] __; Retain enmity; Convert dmg to MP
    hands="Turms Mittens +1",       -- __/__, 101 [ 74] __; HP+100 on parry
    legs="Erilaz Leg Guards +2",    -- 12/12, 147 [ 90]  3
    feet="Turms Leggings +1",       -- __/__, 147 [ 76]  5
    neck="Futhark Torque +2",       --  7/ 7,  30 [ 60] __
    ear1="Odnowa Earring +1",       --  3/ 5, ___ [110] __
    ear2="Ethereal Earring",        -- __/__, ___ [___] __; Convert dmg to MP
    ring1="Gelatinous Ring +1",     --  7/-1, ___ [135] __
    ring2="Moonlight Ring",         --  5/ 5, ___ [110] __
    back=gear.RUN_HPP_Cape,         -- __/__,  20 [ 80]  8
    waist="Flume Belt +1",          --  4/__, ___ [___] __; Convert dmg to MP
    -- Merits/Traits/Gifts                              19
    -- 48 PDT / 38 MDT, 688 MEVA [959 HP] 35 Inquartata
  }

  -- PDT cap is 50%, Protect V = 0%
  sets.defense.PDT = set_combine(sets.HeavyDef, {
    sub="Refined Grip +1",        --  3/ 3, ___ [ 35] __
    -- 51 PDT / 41 MDT, 688 MEVA [994 HP] 35 Inquartata
  })

  -- MDT cap is 50%, Shell V = 29%
  sets.defense.MDT = {
    sub="Utu Grip",                 -- __/__, ___ [ 70] (__, __)
    ammo="Staunch Tathlum +1",      --  3/ 3, ___ [___] (11, __)
    head=gear.Nyame_B_head,         --  7/ 7, 123 [ 91] (__, __)
    body="Erilaz Surcoat +2",       -- __/__, 120 [133] (__, __); Retain enmity; Convert dmg to MP
    hands="Turms Mittens +1",       -- __/__, 101 [ 74] (__, __)
    legs="Erilaz Leg Guards +2",    -- 12/12, 147 [ 90] (__, __)
    feet="Erilaz Greaves +2",       -- 10/10, 147 [ 38] (__, 30)
    neck="Unmoving Collar +1",      -- __/__, ___ [200] (__, __)
    ear1="Odnowa Earring +1",       --  3/ 5, ___ [110] (__, __)
    ear2="Erilaz Earring",          -- __/__,  10 [___] (__, __)
    ring1="Gelatinous Ring +1",     --  7/-1, ___ [135] (__, __)
    ring2="Moonlight Ring",         --  5/ 5, ___ [110] (__, __)
    back=gear.RUN_HPP_Cape,         -- __/__,  20 [ 80] (__, __)
    waist="Engraved Belt",          -- __/__, ___ [___] (__, 20)
    -- 47 PDT / 41 MDT, 666 MEVA [1176 HP] (11 Status Resist, 50 Element Resist)

    -- head="Erilaz Galea +3",      -- __/__, 119 [111] (__, __)
    -- body="Erilaz Surcoat +3",    -- __/__, 130 [143] (__, __); Retain enmity; Convert dmg to MP
    -- hands="Erilaz Gauntlets +3", -- 11/11,  87 [ 59] ( 8, __)
    -- legs="Erilaz Leg Guards +3", -- 13/13, 157 [ 90] (__, __)
    -- feet="Erilaz Greaves +3",    -- 11/11, 157 [ 48] (__, 35)
    -- ear1="Arete del Luna +1",    -- __/__, ___ [___] (__, __); Resist stun, bind, gravity, sleep, charm, light
    -- ear2="Sanare Earring",       -- __/__,   6 [___] (__, __); M. Def Bonus+4
    -- back=gear.RUN_HPME_Cape,     -- __/__,  45 [ 60] (__, __)
    -- 50 PDT / 42 MDT, 701 MEVA [1026 HP] (19 Status Resist, 55 Element Resist)
  }

  sets.defense.Parry = {
    hands="Turms Mittens +1",       -- Parry: Recover HP+100
    legs="Erilaz Leg Guards +2",    -- Inquartata+3
    feet="Turms Leggings +1",       -- Inquartata+5
    back=gear.RUN_HPP_Cape,         -- Parry Rate+5
  }


  ------------------------------------------------------------------------------------------------
  ---------------------------------------- Precast Sets ------------------------------------------
  ------------------------------------------------------------------------------------------------

  -- Enmity sets, caps at +200
  sets.Enmity = {
    ammo="Sapience Orb",                                -- __/__, ___ [___] < 2>
    head="Halitus Helm",                                -- __/__,  43 [ 88] < 8>
    body="Emet Harness +1",                             --  6/__,  64 [ 61] <10>
    hands="Kurys Gloves",                               --  2/ 2,  57 [ 25] < 9>
    legs="Erilaz Leg Guards +2",                        -- 12/12, 147 [ 90] <12>
    feet="Erilaz Greaves +2",                           -- 10/10, 147 [ 38] < 7>
    neck={name="Unmoving Collar +1", priority=1},       -- __/__, ___ [200] <10>
    ear1="Odnowa Earring +1",                           --  3/ 5, ___ [110] <__>
    ear2={name="Cryptic Earring", priority=1},          -- __/__, ___ [ 40] < 4>
    ring1="Moonlight Ring",                             --  5/ 5, ___ [110] <__>
    ring2="Moonlight Ring",                             --  5/ 5, ___ [110] <__>
    back={name=gear.RUN_HPD_Cape,
      augments=gear.RUN_HPD_Cape.augments, priority=1}, -- 10/__,  20 [ 80] <10>
    waist={name="Kasiri Belt", priority=1},             -- __/__, ___ [ 30] < 3>
    -- 53 PDT / 39 MDT, 478 M.Eva [982 HP] <75 Enmity>
  }

  -- PDT/MDT, M.Eva [HP] {SIRD}
  SIRD_options = {
    -- head="Erilaz Galea +2",                            -- __/__, 109 [101] {15}
    -- hands="Regal Gauntlets",                           -- __/__,  48 [205] {10}
    -- feet="Agwu's Pigaches",                            -- __/__, 134 [ 27] {10}
  }

  -- 102% SIRD required to cap; can get 10% from merits
  sets.SIRD = {
    ammo="Staunch Tathlum +1",                            --  3/ 3, ___ [___] {11}
    head="Erilaz Galea +2",                               -- __/__, 109 [101] {15}
    body=gear.Nyame_B_body,                               --  9/ 9, 139 [136] {__}
    hands={name="Regal Gauntlets", priority=1},           -- __/__,  48 [205] {10}
    legs={name=gear.Carmine_A_legs.name,
      augments=gear.Carmine_A_legs.augments, priority=1}, -- __/__,  80 [130] {20}
    feet=gear.Taeon_SIRD_feet,                            -- __/__,  89 [ 63] {10}
    neck="Moonlight Necklace",                            -- __/__,  15 [___] {15}
    ear1="Odnowa Earring +1",                             --  3/ 5, ___ [110] {__}
    ear2="Halasz Earring",                                -- __/__, ___ [___] { 5}
    ring1="Gelatinous Ring +1",                           --  7/-1, ___ [135] {__}
    ring2="Defending Ring",                               -- 10/10, ___ [___] {__}
    back=gear.RUN_HPD_Cape,                               -- 10/__,  20 [ 80] {__}
    waist="Audumbla Sash",                                --  4/__, ___ [___] {10}
    -- SIRD merits                                                            { 6}
    -- 46 PDT / 26 MDT, 500 M.Eva [960 HP] {102 SIRD}

    -- ammo="Staunch Tathlum +1",                            --  3/ 3, ___ [___] {11}
    -- head="Erilaz Galea +3",                               -- __/__, 119 [111] {20}
    -- body=gear.Nyame_B_body,                               --  9/ 9, 139 [136] {__}
    -- hands=gear.Rawhide_B_hands,                           -- __/__,  37 [ 75] {15}
    -- legs={name=gear.Carmine_A_legs.name,
    --   augments=gear.Carmine_A_legs.augments, priority=1}, -- __/__,  80 [130] {20}
    -- feet="Erilaz Greaves +3",                             -- 11/11, 157 [ 48] {__}
    -- neck="Moonlight Necklace",                            -- __/__,  15 [___] {15}
    -- ear1="Odnowa Earring +1",                             --  3/ 5, ___ [110] {__}
    -- ear2="Halasz Earring",                                -- __/__, ___ [___] { 5}
    -- ring1="Gelatinous Ring +1",                           --  7/-1, ___ [135] {__}
    -- ring2="Defending Ring",                               -- 10/10, ___ [___] {__}
    -- back={name="Moonlight Cape", priority=1},             --  6/ 6, ___ [275] {__}
    -- waist="Audumbla Sash",                                --  4/__, ___ [___] {10}
    -- SIRD merits                                                               { 6}
    -- 53 PDT / 43 MDT, 547 M.Eva [1020 HP] {102 SIRD}
  }

  sets.precast.JA = set_combine(sets.Enmity, {})

  sets.precast.JA['Vallation'] = {
    ammo="Sapience Orb",                                -- __/__, ___ [___] < 2>
    head="Halitus Helm",                                -- __/__,  43 [ 88] < 8>
    body={name="Runeist Coat +3", priority=1},        -- __/__,  94 [218] <__>; Augments Valiance/Vallation
    hands="Kurys Gloves",                               --  2/ 2,  57 [ 25] < 9>
    legs="Erilaz Leg Guards +2",                        -- 12/12, 147 [ 90] <12>
    feet="Erilaz Greaves +2",                           -- 10/10, 147 [ 38] < 7>
    neck={name="Unmoving Collar +1", priority=1},       -- __/__, ___ [200] <10>
    ear1="Odnowa Earring +1",                           --  3/ 5, ___ [110] <__>
    ear2={name="Cryptic Earring", priority=1},          -- __/__, ___ [ 40] < 4>
    ring1="Moonlight Ring",                             --  5/ 5, ___ [110] <__>
    ring2="Defending Ring",                             -- 10/10, ___ [___] <__>
    back={name=gear.RUN_HPD_Cape,
      augments=gear.RUN_HPD_Cape.augments, priority=1}, -- 10/__,  20 [ 80] <10>
    waist={name="Kasiri Belt", priority=1},             -- __/__, ___ [ 30] < 3>
    -- 52 PDT / 44 MDT, 508 M.Eva [1029 HP] <65 Enmity>
  }
  sets.precast.JA['Valiance'] = set_combine(sets.precast.JA['Vallation'], {})
  sets.precast.JA['Battuta'] = set_combine(sets.Enmity, {
    head="Futhark Bandeau +3",
  })
  sets.precast.JA['Liement'] = set_combine(sets.Enmity, {
    body="Futhark Coat +3",
  })

  sets.precast.JA['Lunge'] = {
    ammo="Seething Bomblet +1", --  7, __/__ [___]
    head="Agwu's Cap",          -- 35, __/__ [ 38]; R0
    body=gear.Nyame_B_body,     -- 30,  9/ 9 [136]
    hands=gear.Carmine_D_hands, -- 42, __/__ [ 27]
    legs="Agwu's Slops",        -- 55,  8/ 8 [ 50]
    feet=gear.Herc_MAB_feet,    -- 57,  2/__ [  9]
    neck="Baetyl Pendant",      -- 13, __/__ [___]
    ear1="Friomisi Earring",    -- 10, __/__ [___]
    ear2="Novio Earring",       --  7, __/__ [___]
    ring1="Gelatinous Ring +1", -- __,  7/-1 [135]
    ring2="Shiva Ring +1",      --  3, __/__ [___]
    back="Argochampsa Mantle",  -- 12, __/__ [___]
    waist="Eschan Stone",       --  7, __/__ [ 20]
    -- 271 MAB, 26 PDT / 16 MDT [415 HP]

    -- head="Agwu's Cap",       -- 60, __/__ [ 38]; R30
    -- body="Agwu's Robe",      -- 60, __/__ [ 61]; R30
    -- hands="Agwu's Gages",    -- 60, __/__ [ 38]; R30
    -- legs="Agwu's Slops",     -- 60, 10/10 [ 50]; R30
    -- feet="Agwu's Pigaches",  -- 60, __/__ [ 27]; R30
    -- 354 MAB, 17 PDT / 9 MDT [369 HP]
  }
  sets.precast.JA['Lunge'].Safe = {
    ammo="Seething Bomblet +1",                   --  7, __/__ [___]
    head=gear.Nyame_B_head,                       -- 30,  7/ 7 [ 91]
    body=gear.Nyame_B_body,                       -- 30,  9/ 9 [136]
    hands=gear.Carmine_D_hands,                   -- 42, __/__ [ 27]
    legs={name=gear.Nyame_B_legs, priority=1},    -- 30,  8/ 8 [114]
    feet=gear.Herc_MAB_feet,                      -- 57,  2/__ [  9]
    neck="Futhark Torque +2",                     -- __,  7/ 7 [ 60]
    ear1="Friomisi Earring",                      -- 10, __/__ [___]
    ear2="Novio Earring",                         --  7, __/__ [___]
    ring1={name="Gelatinous Ring +1", priority=1},-- __,  7/-1 [135]
    ring2="Moonlight Ring",                       -- __,  5/ 5 [110]
    back={name="Moonlight Cape", priority=1},     -- __,  6/ 6 [275]
    waist={name="Eschan Stone", priority=1},      --  7, __/__ [ 20]
  } -- 213 MAB, 51 PDT / 41 MDT [977 HP]

  sets.precast.JA['Swipe'] = set_combine(sets.precast.JA['Lunge'], {})
  sets.precast.JA['Swipe'].Safe = set_combine(sets.precast.JA['Lunge'].Safe, {})

  sets.precast.JA['Gambit'] = set_combine(sets.Enmity, {
    hands="Runeist Mitons +3"
  })
  sets.precast.JA['Rayke'] = set_combine(sets.Enmity, {
    feet="Futhark Boots +1"
  })
  sets.precast.JA['Elemental Sforzo'] = set_combine(sets.Enmity, {
    body="Futhark Coat +3",
  })
  sets.precast.JA['Swordplay'] = set_combine(sets.Enmity, {
    hands="Futhark Mitons"
  })

  -- Divine Magic skill
  sets.precast.JA['Vivacious Pulse'] = {
    ammo="Staunch Tathlum +1",                --  3/ 3, ___ [___] __
    head="Erilaz Galea +2",                   -- __/__, 109 [101] __; Enhance JA
    body=gear.Nyame_B_body,                   --  9/ 9, 139 [136] __
    hands="Turms Mittens +1",                 -- __/__, 101 [ 74] __
    legs="Erilaz Leg Guards +2",              -- 12/12, 147 [ 90] __
    feet="Turms Leggings +1",                 -- __/__, 147 [ 76] __
    neck="Incanter's Torque",                 -- __/__, ___ [___] 10
    ear1="Odnowa Earring +1",                 --  3/ 5, ___ [110] __
    ear2="Ethereal Earring",                  -- __/__, ___ [___] __
    ring1="Gelatinous Ring +1",               --  7/-1, ___ [135] __
    ring2="Defending Ring",                   -- 10/10, ___ [___] __
    back={name="Moonlight Cape", priority=1}, --  6/ 6, ___ [275] __
    waist="Engraved Belt",                    -- __/__, ___ [___] __
    -- Merits/Traits/Gifts                                        16
    -- Master Level 50                                            50
    -- Base skill                                                 398
    -- 50 PDT/44 MDT, 643 M.Eva [997 HP] 474 Divine Skill
  }

  -- Fast cast sets for spells
  sets.precast.FC = {
    ammo="Staunch Tathlum +1",                        -- {__}  3/ 3, ___ [___]
    head={name="Runeist Bandeau +3", priority=1},     -- {14} __/__,  83 [109]
    body="Erilaz Surcoat +2",                         -- {10} __/__, 120 [133]
    hands=gear.Leyline_Gloves,                        -- { 8} __/__,  62 [ 25]
    legs="Agwu's Slops",                              -- { 7}  8/ 8, 134 [ 50]
    feet={name=gear.Carmine_D_feet.name, priority=1}, -- { 8}  4/__,  80 [ 95]
    neck="Futhark Torque +2",                         -- {__}  7/ 7,  30 [ 60]
    ear1="Odnowa Earring +1",                         -- {__}  3/ 5, ___ [110]
    ear2={name="Eabani Earring", priority=1},         -- {__} __/__,   8 [ 45]
    ring1="Gelatinous Ring +1",                       -- {__}  7/-1, ___ [135]
    ring2="Moonlight Ring",                           -- {__}  5/ 5, ___ [110]
    back={name=gear.RUN_FC_Cape.name,
      augments=gear.RUN_FC_Cape.augments, priority=1},-- {10} 10/__,  20 [ 80]
    waist="Flume Belt +1",                            -- {__}  4/__, ___ [___]
    -- 57% Fast Cast, 51 PDT/27 MDT, 537 M.Eva [952 HP]

    -- legs="Agwu's Slops",                           -- { 7} 10/10, 134 [ 50]; R30
    -- 57% Fast Cast, 53 PDT/29 MDT, 537 M.Eva [952 HP]
  }

  sets.precast.FC['Enhancing Magic'] = {
    ammo="Staunch Tathlum +1",                        -- {__}  3/ 3, ___ [___]
    head={name="Runeist Bandeau +3", priority=1},     -- {14} __/__,  83 [109]
    body=gear.Nyame_B_body,                           -- {__}  9/ 9, 139 [136]
    hands=gear.Leyline_Gloves,                        -- { 8} __/__,  62 [ 25]
    legs={name="Futhark Trousers +3", priority=1},    -- {15} __/__,  89 [107]
    feet={name=gear.Carmine_D_feet.name, priority=1}, -- { 8}  4/__,  80 [ 95]
    neck="Futhark Torque +2",                         -- {__}  7/ 7,  30 [ 60]
    ear1="Odnowa Earring +1",                         -- {__}  3/ 5, ___ [110]
    ear2={name="Eabani Earring", priority=1},         -- {__} __/__,   8 [ 45]
    ring1="Gelatinous Ring +1",                       -- {__}  7/-1, ___ [135]
    ring2="Moonlight Ring",                           -- {__}  5/ 5, ___ [110]
    back={name=gear.RUN_FC_Cape.name,
      augments=gear.RUN_FC_Cape.augments, priority=1},-- {10} 10/__,  20 [ 80]
    waist={name="Kasiri Belt", priority=1},           -- {__} __/__, ___ [ 30]
    -- 55% Fast Cast, 48 PDT/28 MDT, 511 M.Eva [1042 HP]
  }
  
  sets.precast.FC['Geist Wall'] = set_combine(sets.SIRD, {})
  sets.precast.FC['Poisonga'] = set_combine(sets.SIRD, {})

  -- Add quick magic
  sets.precast.FC.Trust = set_combine(sets.precast.FC, {
    ammo="Impatiens",
    ring1="Weatherspoon Ring", --5
    ring2="Kishar Ring", --4
  })

  sets.HybridAcc = {
    ammo="Hydrocera",           -- __,  6
    head=gear.Nyame_B_head,     -- 50, 40
    body=gear.Nyame_B_body,     -- 40, 40
    hands=gear.Nyame_B_hands,   -- 40, 40
    legs=gear.Nyame_B_legs,     -- 40, 40
    feet=gear.Nyame_B_feet,     -- 53, 40
    neck="Erra Pendant",        -- __, 17
    ear1="Dignitary's Earring", -- 10, 10
    ear2="Erilaz Earring",
    -- ring1="Etana Ring",         -- 10, 10
    ring2="Metamorph Ring +1",  -- __, 16
    back=gear.RUN_WS2_Cape,     -- 20, __
    -- waist="Luminary Sash",      -- __, 10
    -- ear2="Crepuscular Earring", -- 10, 10
  } -- 273 Acc, 279 Magic Acc


  ------------------------------------------------------------------------------------------------
  ---------------------------------------- Midcast Sets ------------------------------------------
  ------------------------------------------------------------------------------------------------

  -- Initializes trusts at iLvl 119
  sets.midcast.Trust = {
    head=gear.Nyame_B_head,
    body=gear.Nyame_B_body,
    hands=gear.Nyame_B_hands,
    legs=gear.Nyame_B_legs,
    feet=gear.Nyame_B_feet,
  }

  sets.midcast.FastRecast = set_combine(sets.precast.FC, {})

  sets.midcast.Silence = set_combine(sets.HybridAcc, {})

  sets.midcast['Enhancing Magic'] = {
    ammo="Staunch Tathlum +1",                      --  3/ 3, ___ [___] (__, __)
    head="Erilaz Galea +2",                         -- __/__, 109 [101] (20, __)
    body=gear.Nyame_B_body,                         --  9/ 9, 139 [136] (__, __)
    hands={name="Runeist Mitons +3", priority=1}, --  3/__,  67 [ 85] (__, 19)
    legs=gear.Carmine_D_legs,                       -- __/__,  80 [ 50] (__, 18)
    feet="Turms Leggings +1",                       -- __/__, 147 [ 76] (__, __)
    neck="Incanter's Torque",                       -- __/__, ___ [___] (__, 10)
    ear1="Andoaa Earring",                          -- __/__, ___ [___] (__,  5)
    ear2="Mimir Earring",                           -- __/__, ___ [___] (__, 10)
    ring1="Stikini Ring +1",                        -- __/__, ___ [___] (__,  8)
    ring2="Moonlight Ring",                         --  5/ 5, ___ [110] (__, __)
    back=gear.RUN_HPP_Cape,                         -- __/__,  20 [ 80] (__, __)
    waist="Olympus Sash",                           -- __/__, ___ [___] (__,  5)
    -- Merits/Traits/Gifts                                              (20, 52)
    -- Master Levels                                                    (__, 50)
    -- Base skill                                                       (__, 388)
    -- 20 PDT/17 MDT, 562 M.Eva [638 HP] (40 Enh Duration, 565 Enh Skill)
  }

  sets.midcast.EnhancingDuration = {
    head="Erilaz Galea +2",                         -- __/__, 109 [101] (20, __)
    hands={name="Regal Gauntlets", priority=1},     -- __/__,  48 [205] (20, __)
    legs={name="Futhark Trousers +3", priority=1},  -- __/__,  89 [107] (30, __)
  }

  sets.midcast['Phalanx'] = set_combine(sets.HeavyDef, {
    ammo="Staunch Tathlum +1",                  -- _, __, 11 [ 3/ 3,   0]
    head="Futhark Bandeau +3",                  -- 7, __, __ [ 6/ 0,  56]
    body=gear.Herc_Phalanx_body,                -- 5, __, __ [__/__,  61]
    hands=gear.Herc_Phalanx_hands,              -- 5, __, __ [ 2/__,  20]
    legs=gear.Herc_Phalanx_legs,                -- 5, __, __ [ 2/__,  38]
    feet=gear.Herc_Phalanx_feet,                -- 5, __, __ [ 2/__,   9]
    neck="Futhark Torque +2",                   -- _, __, __ [ 7/ 7,  60]
    ear1="Odnowa Earring +1",                   -- _, __, __ [ 3/ 5, 110]
    ear2="Mimir Earring",                       -- _, 10, __ [__/__, ___]
    ring1="Gelatinous Ring +1",                 -- _, __, __ [ 7/-1, 135]
    ring2="Moonlight Ring",                     -- _, __, __ [ 5/ 5, 110]
    back={name="Moonlight Cape", priority=1},   -- _, __, __ [ 6/ 6, 275]
    waist="Audumbla Sash",                      -- _, __, 10 [ 4/ 0,   0]
    -- Base/Traits/Gifts                           _,440,  6 [__/__, ___]
    -- Master Levels                                  23
    -- 27 Phalanx, 473 Enh Skill, 27% Interrupt [47 PDT/25 MDT, 874 HP]
    -- 61 Total Phalanx
    
    -- ammo="Staunch Tathlum +1",               -- _, __, 11 [ 3/ 3,   0]
    -- head="Futhark Bandeau +3",               -- 7, __, __ [ 6/ 0,  56]
    -- body=gear.Herc_Phalanx_body,             -- 5, __, __ [__/__,  61]
    -- hands=gear.Herc_Phalanx_hands,           -- 5, __, __ [ 2/__,  20]
    -- legs=gear.Herc_Phalanx_legs,             -- 5, __, __ [ 2/__,  38]
    -- feet=gear.Herc_Phalanx_feet,             -- 5, __, __ [ 2/__,   9]
    -- neck="Futhark Torque +2",                -- _, __, __ [ 7/ 7,  60]
    -- ear1="Odnowa Earring +1",                -- _, __, __ [ 3/ 5, 110]
    -- ear2="Mimir Earring",                    -- _, 10, __ [__/__, ___]
    -- ring1="Gelatinous Ring +1",              -- _, __, __ [ 7/-1, 135]
    -- ring2="Moonlight Ring",                  -- _, __, __ [ 5/ 5, 110]
    -- back={name="Moonlight Cape", priority=1},-- _, __, __ [ 6/ 6, 275]
    -- waist="Audumbla Sash",                   -- _, __, 10 [ 4/ 0,   0]
    -- Base/Traits/Gifts                           _,440,  6 [__/__, ___]
    -- Master Levels                                  50
    -- 27 Phalanx, 500 Enh Skill, 27% Interrupt [47 PDT/25 MDT, 874 HP]
    -- 62 Total Phalanx
  })

  sets.midcast['Aquaveil'] = set_combine(sets.SIRD, {})

  -- Regen 4 base potency 30 hp/tic. Base duration 60s.
  sets.midcast['Regen'] = {
    head="Runeist Bandeau +3",                    -- __, 27, __, __ [__/__,  83] 109
    body=gear.Nyame_B_body,                         -- __, __, __, __ [ 9/ 9, 139] 136
    hands="Regal Gauntlets",                        -- __, __, 20, __ [__/__,  48] 205
    legs="Futhark Trousers +3",                     -- __, __, 30, __ [__/__,  89] 107
    feet="Erilaz Greaves +2",                       -- __, __, __, __ [10/10, 147]  38
    ear1="Odnowa Earring +1",                       -- __, __, __, __ [ 3/ 5, ___] 110
    ear2="Erilaz Earring",                          -- __, 10, __, __ [__/__,  10] ___
    ring1="Gelatinous Ring +1",                     -- __, __, __, __ [ 7/-1, ___] 135
    ring2="Defending Ring",                         -- __, __, __, __ [10/10, ___] ___
    back=gear.RUN_HPD_Cape,                         -- __, __, __, __ [10/__,  20]  80
    -- Merits/Traits/Gifts                             __, __, 20, __
    -- 30% Regen Potency, 64 Regen Potency, 70 Enh Duration %, 0 Regen Duration [56 PDT/40 MDT, 409 M.Eva] 1162 HP
    -- Regen IV 67 hp/tic @102 sec

    -- main=gear.Morgelai_C,                        -- __, 25, __, __ [__/__, ___] 130
    -- sub=empty,
    -- feet="Erilaz Greaves +3",                    -- __, __, __, __ [11/11, 157] 100
    -- neck="Sacro Gorget",                         -- 10, __, __, __ [__/__, ___]  50
    -- ear2="Erilaz Earring +2",                    -- __, 12, __, __ [ 6/ 6,  12] ___
    -- waist="Sroda Belt",                          -- 20, __, __, __ [__/__, ___] ___
    -- 30% Regen Potency, 64 Regen Potency, 70 Enh Duration %, 0 Regen Duration [56 PDT/40 MDT, 409 M.Eva] 1162 HP
    -- Regen IV 103 hp/tic @102 sec
  }

  sets.midcast.Refresh = set_combine(sets.HeavyDef, sets.midcast.EnhancingDuration, {
    head="Erilaz Galea +2",
    waist="Gishdubar Sash",
  })

  -- TODO: Set priorities
  sets.midcast.Stoneskin = {
    ammo="Staunch Tathlum +1",                --  3/ 3, ___ [___] __
    head=gear.Nyame_B_head,                   --  7/ 7, 123 [ 91] __
    body=gear.Nyame_B_body,                   --  9/ 9, 139 [136] __
    hands="Turms Mittens +1",                 -- __/__, 101 [ 74] __
    legs="Erilaz Leg Guards +2",              -- 12/12, 147 [ 90] __
    feet="Turms Leggings +1",                 -- __/__, 147 [ 76] __
    neck="Futhark Torque +2",                 --  7/ 7,  30 [ 60] __
    ear1="Odnowa Earring +1",                 --  3/ 5, ___ [110] __
    ear2="Ethereal Earring",                  -- __/__, ___ [___] __
    ring1="Gelatinous Ring +1",               --  7/-1, ___ [135] __
    ring2="Moonlight Ring",                   --  5/ 5, ___ [110] __
    back={name="Moonlight Cape", priority=1}, --  6/ 6, ___ [275] __
    waist="Siegel Sash",                      -- __/__, ___ [___] 20
    -- 59 PDT/53 MDT, 687 M.Eva [1157 HP] 20 Stoneskin Potency

    -- hands="Stone Mufflers",                -- __/__, ___ [ 10] 30
    -- 59 PDT/53 MDT, 586 M.Eva [1093 HP] 50 Stoneskin Potency
  }
  sets.midcast.Protect = {
    ammo="Staunch Tathlum +1",                      --  3/ 3, ___ [___] (__, __)
    head="Erilaz Galea +2",                         -- __/__, 109 [101] (20, __)
    body=gear.Nyame_B_body,                         --  9/ 9, 139 [136] (__, __)
    hands={name="Regal Gauntlets", priority=1},     -- __/__,  48 [205] (20, __)
    legs={name="Futhark Trousers +3", priority=1},  -- __/__,  89 [107] (30, __)
    feet="Turms Leggings +1",                       -- __/__, 147 [ 76] (__, __)
    neck="Futhark Torque +2",                       --  7/ 7,  30 [ 60] (__, __)
    ear1="Odnowa Earring +1",                       --  3/ 5, ___ [110] (__, __)
    ear2="Ethereal Earring",                        -- __/__, ___ [___] (__, __)
    ring1="Gelatinous Ring +1",                     --  7/-1, ___ [135] (__, __)
    -- ring2="Sheltered Ring",                         -- __/__, ___ [___] (__, __); Enhances Protect
    back={name="Moonlight Cape", priority=1},       --  6/ 6, ___ [275] (__, __)
    waist="Audumbla Sash",                          --  4/__, ___ [___] (__, __)
    -- 38 PDT/28 MDT, 557 M.Eva [1190 HP] (70 Enh Duration, N/A Enh Skill)
  }
  sets.midcast.Shell = set_combine(sets.midcast.Protect, {})

  sets.midcast.Flash = set_combine(sets.Enmity, {})
  sets.midcast.Foil = set_combine(sets.Enmity, {})
  sets.midcast.Stun = set_combine(sets.Enmity, {})

  sets.midcast.Utsusemi = set_combine(sets.SIRD, {})
  sets.midcast['Geist Wall'] = set_combine(sets.SIRD, {})
  sets.midcast['Bomb Toss'] = set_combine(sets.SIRD, sets.TreasureHunter)
  sets.midcast['Poisonga'] = set_combine(sets.SIRD, {})

  sets.midcast['Dia'] = set_combine(sets.SIRD, {})
  sets.midcast['Dia II'] = set_combine(sets.SIRD, {})
  sets.midcast['Diaga'] = set_combine(sets.SIRD, {})

  sets.midcast['Blue Magic'] = {}
  sets.midcast['Blue Magic'].Enmity = set_combine(sets.Enmity, {})
  sets.midcast['Blue Magic'].Buffs = set_combine(sets.SIRD, {})
  sets.midcast['Blue Magic'].Cure = {
    ring1="Lebeche Ring", -- 3
    waist="Gishdubar Sash", --(10)
    -- body="Vrikodara Jupon", -- 13
    -- hands="Buremte Gloves", --(13)
    -- feet="Skaoi Boots", --7
    -- neck="Phalaina Locket", -- 4(4)
    -- ear1="Roundel Earring", -- 5
    -- ear2="Mendi. Earring", -- 5
    -- back="Solemnity Cape", -- 7
  }
  sets.midcast['Blue Magic'].Cure.Safe = set_combine(sets.SIRD, {})


  ------------------------------------------------------------------------------------------------
  ------------------------------------- Weapon Skill Sets ----------------------------------------
  ------------------------------------------------------------------------------------------------

  sets.precast.WS = {
    ammo="Knobkierrie",
    head=gear.Nyame_B_head,
    body=gear.Nyame_B_body,
    hands=gear.Nyame_B_hands,
    legs=gear.Nyame_B_legs,
    feet=gear.Nyame_B_feet,
    neck="Fotia Gorget",
    ear1="Sherida Earring",
    ear2="Moonshade Earring",
    ring1="Ilabrat Ring",
    ring2="Niqmaddu Ring",
    back=gear.RUN_WS2_Cape,
    waist="Fotia Belt",
  }

  sets.precast.WS.Safe = set_combine(sets.Enmity, {})

  -- 85% STR mod, 0.718-2.25 FTP, ftp replicating
  sets.precast.WS['Resolution'] = set_combine(sets.precast.WS, {
    ammo="Seething Bomblet +1",
    head=gear.Adhemar_B_head,
    body=gear.Adhemar_A_body,
    hands=gear.Adhemar_B_hands,
    legs=gear.Samnuha_legs,
    feet=gear.Herc_TA_feet,
    neck="Fotia Gorget",
    ear1="Sherida Earring",
    ear2="Moonshade Earring",
    ring1="Regal Ring",
    ring2="Niqmaddu Ring",
    back=gear.RUN_WS1_Cape,
    waist="Fotia Belt",
  })
  sets.precast.WS['Resolution'].Safe = set_combine(sets.precast.WS.Safe, {
    ammo="Seething Bomblet +1",
    waist="Fotia Belt",
    -- head=gear.Adhemar_A_head,
  })
  sets.precast.WS['Resolution'].MaxTP = set_combine(sets.precast.WS['Resolution'], {
    neck="Caro Necklace",
    ear2="Odnowa Earring +1",
    waist="Sailfi Belt +1",
    -- ear2="Vulcan's Pearl",
  })
  sets.precast.WS['Resolution'].LowAcc = set_combine(sets.precast.WS['Resolution'], {
  })
  sets.precast.WS['Resolution'].LowAccMaxTP = set_combine(sets.precast.WS['Resolution'].LowAcc, {
    neck="Caro Necklace",
    ear2="Odnowa Earring +1",
    waist="Sailfi Belt +1",
    -- ear2="Vulcan's Pearl",
  })
  sets.precast.WS['Resolution'].MidAcc = set_combine(sets.precast.WS['Resolution'].LowAcc, {
  })
  sets.precast.WS['Resolution'].MidAccMaxTP = set_combine(sets.precast.WS['Resolution'].MidAcc, {
    neck="Caro Necklace",
    ear2="Odnowa Earring +1",
    waist="Sailfi Belt +1",
    -- ear2="Vulcan's Pearl",
  })
  sets.precast.WS['Resolution'].HighAcc = set_combine(sets.precast.WS['Resolution'].MidAcc, {
  })
  sets.precast.WS['Resolution'].HighAccMaxTP = set_combine(sets.precast.WS['Resolution'].HighAcc, {
    neck="Caro Necklace",
    ear2="Odnowa Earring +1",
    waist="Sailfi Belt +1",
    -- ear2="Vulcan's Pearl",
  })

  -- 80% DEX mod
  sets.precast.WS['Dimidiation'] = set_combine(sets.precast.WS, {
    ammo="Knobkierrie",
    head=gear.Nyame_B_head,
    body=gear.Nyame_B_body,
    hands=gear.Nyame_B_hands,
    legs=gear.Lustratio_B_legs,
    feet=gear.Lustratio_D_feet,
    neck="Caro Necklace",
    waist="Grunfeld Rope",
    ear1="Sherida Earring",
    ear2="Moonshade Earring",
    ring1="Epaminondas's Ring",
    ring2="Ilabrat Ring",
    back=gear.RUN_WS2_Cape,
  })
  sets.precast.WS['Dimidiation'].Safe = set_combine(sets.precast.WS.Safe, {
    ammo="Knobkierrie",
    head={name=gear.Nyame_B_head, priority=2},
    hands={name=gear.Nyame_B_hands, priority=2},
    legs={name=gear.Nyame_B_legs, priority=2},
    feet={name=gear.Nyame_B_feet, priority=2},
    waist="Grunfeld Rope",
  })
  sets.precast.WS['Dimidiation'].MaxTP = set_combine(sets.precast.WS['Dimidiation'], {
    ear2="Odr Earring",
  })
  sets.precast.WS['Dimidiation'].LowAcc = set_combine(sets.precast.WS['Dimidiation'], {
  })
  sets.precast.WS['Dimidiation'].LowAccMaxTP = set_combine(sets.precast.WS['Dimidiation'].LowAcc, {
    ear2="Odr Earring",
  })
  sets.precast.WS['Dimidiation'].MidAcc = set_combine(sets.precast.WS['Dimidiation'].LowAcc, {
  })
  sets.precast.WS['Dimidiation'].MidAccMaxTP = set_combine(sets.precast.WS['Dimidiation'].MidAcc, {
    ear2="Odr Earring",
  })
  sets.precast.WS['Dimidiation'].HighAcc = set_combine(sets.precast.WS['Dimidiation'].MidAcc, {
  })
  sets.precast.WS['Dimidiation'].HighAccMaxTP = set_combine(sets.precast.WS['Dimidiation'].HighAcc, {
    ear2="Odr Earring",
  })

  sets.precast.WS['Fell Cleave'] = set_combine(sets.precast.WS, {})
  sets.precast.WS['Fell Cleave'].Safe = set_combine(sets.precast.WS.Safe, {})
  sets.precast.WS['Fell Cleave'].MaxTP = set_combine(sets.precast.WS['Fell Cleave'], {})
  sets.precast.WS['Fell Cleave'].LowAcc = set_combine(sets.precast.WS['Fell Cleave'], {})
  sets.precast.WS['Fell Cleave'].LowAccMaxTP = set_combine(sets.precast.WS['Fell Cleave'].LowAcc, {})
  sets.precast.WS['Fell Cleave'].MidAcc = set_combine(sets.precast.WS['Fell Cleave'].LowAcc, {})
  sets.precast.WS['Fell Cleave'].MidAccMaxTP = set_combine(sets.precast.WS['Fell Cleave'].MidAcc, {})
  sets.precast.WS['Fell Cleave'].HighAcc = set_combine(sets.precast.WS['Fell Cleave'].MidAcc, {})
  sets.precast.WS['Fell Cleave'].HighAccMaxTP = set_combine(sets.precast.WS['Fell Cleave'].HighAcc, {})

  sets.precast.WS['Steel Cyclone'] = set_combine(sets.precast.WS['Fell Cleave'], {
    ammo="Yamarang",
    head=gear.Nyame_B_head,
    body=gear.Nyame_B_body,
    hands=gear.Nyame_B_hands,
    legs=gear.Nyame_B_legs,
    feet=gear.Nyame_B_feet,
    neck="Anu Torque",
    ear1="Telos Earring",
    ear2="Dignitary's Earring",
    ring1="Chirich Ring +1",
    ring2="Moonlight Ring",
    back=gear.RUN_WS2_Cape,
    waist="Olseni Belt",
  })
  sets.precast.WS['Steel Cyclone'].Safe = set_combine(sets.precast.WS.Safe, {})
  sets.precast.WS['Steel Cyclone'].MaxTP = set_combine(sets.precast.WS['Steel Cyclone'].MaxTP, {})
  sets.precast.WS['Steel Cyclone'].LowAcc = set_combine(sets.precast.WS['Steel Cyclone'].LowAcc, {})
  sets.precast.WS['Steel Cyclone'].LowAccMaxTP = set_combine(sets.precast.WS['Steel Cyclone'].LowAccMaxTP, {})
  sets.precast.WS['Steel Cyclone'].MidAcc = set_combine(sets.precast.WS['Steel Cyclone'].MidAcc, {})
  sets.precast.WS['Steel Cyclone'].MidAccMaxTP = set_combine(sets.precast.WS['Steel Cyclone'].MidAccMaxTP, {})
  sets.precast.WS['Steel Cyclone'].HighAcc = set_combine(sets.precast.WS['Steel Cyclone'].HighAcc, {})
  sets.precast.WS['Steel Cyclone'].HighAccMaxTP = set_combine(sets.precast.WS['Steel Cyclone'].HighAccMaxTP, {})

  sets.precast.WS['Upheaval'] = set_combine(sets.precast.WS['Steel Cyclone'], {})
  sets.precast.WS['Upheaval'].Safe = set_combine(sets.precast.WS['Steel Cyclone'].Safe, {})
  sets.precast.WS['Upheaval'].MaxTP = set_combine(sets.precast.WS['Steel Cyclone'].MaxTP, {})
  sets.precast.WS['Upheaval'].LowAcc = set_combine(sets.precast.WS['Steel Cyclone'].LowAcc, {})
  sets.precast.WS['Upheaval'].LowAccMaxTP = set_combine(sets.precast.WS['Steel Cyclone'].LowAccMaxTP, {})
  sets.precast.WS['Upheaval'].MidAcc = set_combine(sets.precast.WS['Steel Cyclone'].MidAcc, {})
  sets.precast.WS['Upheaval'].MidAccMaxTP = set_combine(sets.precast.WS['Steel Cyclone'].MidAccMaxTP, {})
  sets.precast.WS['Upheaval'].HighAcc = set_combine(sets.precast.WS['Steel Cyclone'].HighAcc, {})
  sets.precast.WS['Upheaval'].HighAccMaxTP = set_combine(sets.precast.WS['Steel Cyclone'].HighAccMaxTP, {})

  -- Magic accuracy required for Shockwave
  sets.precast.WS['Shockwave'] = set_combine(sets.HybridAcc, {
    ear2="Moonshade Earring",
  })
  sets.precast.WS['Shockwave'].Safe = set_combine(sets.Enmity, {})
  sets.precast.WS['Shockwave'].MaxTP = set_combine(sets.precast.WS['Shockwave'], {
    ear2="Erilaz Earring",
    -- ear2="Crepuscular Earring", -- 10, 10
  })
  sets.precast.WS['Shockwave'].LowAcc = set_combine(sets.precast.WS['Shockwave'], {})
  sets.precast.WS['Shockwave'].LowAccMaxTP = set_combine(sets.precast.WS['Shockwave'].LowAcc, {
    ear2="Erilaz Earring",
    -- ear2="Crepuscular Earring", -- 10, 10
  })
  sets.precast.WS['Shockwave'].MidAcc = set_combine(sets.precast.WS['Shockwave'].LowAcc, {})
  sets.precast.WS['Shockwave'].MidAccMaxTP = set_combine(sets.precast.WS['Shockwave'].MidAcc, {
    ear2="Erilaz Earring",
    -- ear2="Crepuscular Earring", -- 10, 10
  })
  sets.precast.WS['Shockwave'].HighAcc = set_combine(sets.precast.WS['Shockwave'].MidAcc, {})
  sets.precast.WS['Shockwave'].HighAccMaxTP = set_combine(sets.precast.WS['Shockwave'].HighAcc, {
    ear2="Erilaz Earring",
    -- ear2="Crepuscular Earring", -- 10, 10
  })

  sets.precast.WS['Herculean Slash'] = set_combine(sets.precast.WS['Shockwave'], {})
  sets.precast.WS['Herculean Slash'].Safe = set_combine(sets.precast.WS['Shockwave'].Safe, {})
  sets.precast.WS['Herculean Slash'].MaxTP = set_combine(sets.precast.WS['Shockwave'].MaxTP, {})
  sets.precast.WS['Herculean Slash'].LowAcc = set_combine(sets.precast.WS['Shockwave'].LowAcc, {})
  sets.precast.WS['Herculean Slash'].LowAccMaxTP = set_combine(sets.precast.WS['Shockwave'].LowAccMaxTP, {})
  sets.precast.WS['Herculean Slash'].MidAcc = set_combine(sets.precast.WS['Shockwave'].MidAcc, {})
  sets.precast.WS['Herculean Slash'].MidAccMaxTP = set_combine(sets.precast.WS['Shockwave'].MidAccMaxTP, {})
  sets.precast.WS['Herculean Slash'].HighAcc = set_combine(sets.precast.WS['Shockwave'].HighAcc, {})
  sets.precast.WS['Herculean Slash'].HighAccMaxTP = set_combine(sets.precast.WS['Shockwave'].HighAccMaxTP, {})

  sets.precast.WS['Armor Break'] = set_combine(sets.precast.WS['Shockwave'], {})
  sets.precast.WS['Armor Break'].Safe = set_combine(sets.precast.WS['Shockwave'].Safe, {})
  sets.precast.WS['Armor Break'].MaxTP = set_combine(sets.precast.WS['Shockwave'].MaxTP, {})
  sets.precast.WS['Armor Break'].LowAcc = set_combine(sets.precast.WS['Shockwave'].LowAcc, {})
  sets.precast.WS['Armor Break'].LowAccMaxTP = set_combine(sets.precast.WS['Shockwave'].LowAccMaxTP, {})
  sets.precast.WS['Armor Break'].MidAcc = set_combine(sets.precast.WS['Shockwave'].MidAcc, {})
  sets.precast.WS['Armor Break'].MidAccMaxTP = set_combine(sets.precast.WS['Shockwave'].MidAccMaxTP, {})
  sets.precast.WS['Armor Break'].HighAcc = set_combine(sets.precast.WS['Shockwave'].HighAcc, {})
  sets.precast.WS['Armor Break'].HighAccMaxTP = set_combine(sets.precast.WS['Shockwave'].HighAccMaxTP, {})

  sets.precast.WS['Weapon Break'] = set_combine(sets.precast.WS['Shockwave'], {})
  sets.precast.WS['Weapon Break'].Safe = set_combine(sets.precast.WS['Shockwave'].Safe, {})
  sets.precast.WS['Weapon Break'].MaxTP = set_combine(sets.precast.WS['Shockwave'].MaxTP, {})
  sets.precast.WS['Weapon Break'].LowAcc = set_combine(sets.precast.WS['Shockwave'].LowAcc, {})
  sets.precast.WS['Weapon Break'].LowAccMaxTP = set_combine(sets.precast.WS['Shockwave'].LowAccMaxTP, {})
  sets.precast.WS['Weapon Break'].MidAcc = set_combine(sets.precast.WS['Shockwave'].MidAcc, {})
  sets.precast.WS['Weapon Break'].MidAccMaxTP = set_combine(sets.precast.WS['Shockwave'].MidAccMaxTP, {})
  sets.precast.WS['Weapon Break'].HighAcc = set_combine(sets.precast.WS['Shockwave'].HighAcc, {})
  sets.precast.WS['Weapon Break'].HighAccMaxTP = set_combine(sets.precast.WS['Shockwave'].HighAccMaxTP, {})

  sets.precast.WS['Full Break'] = set_combine(sets.precast.WS['Shockwave'], {})
  sets.precast.WS['Full Break'].Safe = set_combine(sets.precast.WS['Shockwave'].Safe, {})
  sets.precast.WS['Full Break'].MaxTP = set_combine(sets.precast.WS['Shockwave'].MaxTP, {})
  sets.precast.WS['Full Break'].LowAcc = set_combine(sets.precast.WS['Shockwave'].LowAcc, {})
  sets.precast.WS['Full Break'].LowAccMaxTP = set_combine(sets.precast.WS['Shockwave'].LowAccMaxTP, {})
  sets.precast.WS['Full Break'].MidAcc = set_combine(sets.precast.WS['Shockwave'].MidAcc, {})
  sets.precast.WS['Full Break'].MidAccMaxTP = set_combine(sets.precast.WS['Shockwave'].MidAccMaxTP, {})
  sets.precast.WS['Full Break'].HighAcc = set_combine(sets.precast.WS['Shockwave'].HighAcc, {})
  sets.precast.WS['Full Break'].HighAccMaxTP = set_combine(sets.precast.WS['Shockwave'].HighAccMaxTP, {})

  sets.precast.WS['Freezebite'] = set_combine(sets.HeavyDef, sets.TreasureHunter)

  sets.precast.WS['Savage Blade'] = {
    ammo="Knobkierrie",             -- __, __, 23, __,  6, __, ___, __/__ [___]
    head=gear.Nyame_B_head,         -- 26, 26, 65, 50, 11, __, ___,  7/ 7 [ 91]
    body=gear.Nyame_B_body,         -- 35, 37, 65, 40, 13, __, ___,  9/ 9 [136]
    hands=gear.Nyame_B_hands,       -- 17, 40, 65, 40, 11, __, ___,  7/ 7 [ 91]
    legs=gear.Nyame_B_legs,         -- 58, 32, 65, 40, 12, __, ___,  8/ 8 [114]
    feet=gear.Nyame_B_feet,         -- 23, 26, 65, 53, 11, __, ___,  7/ 7 [ 68]
    neck="Futhark Torque +2",       -- 15, 15, __, __, __, __, ___,  7/ 7 [ 60]
    ear1="Ishvara Earring",         -- __, __, __, __,  2, __, ___, __/__ [___]
    ear2="Moonshade Earring",       -- __, __, __,  4, __, __, 250, __/__ [___]
    ring1="Sroda Ring",             -- 15, __, __, __, __,  3, ___, __/__ [___]
    ring2="Epaminondas's Ring",     -- __, __, __, __,  5, __, ___, __/__ [___]
    back=gear.RUN_WS2_Cape,         -- __, __, 20, 20, 10, __, ___, 10/__ [___]
    waist="Sailfi Belt +1",         -- 15, __, 15, __, __, __, ___, __/__ [___]
    -- 204 STR, 176 MND, 383 Attack, 247 Accuracy, 81 WSD, 0 PDL, 250 TP Bonus, 55PDT/45MDT [560HP]

    -- back=gear.RUN_WS3_Cape,      -- 30, __, 20, 20, 10, __, ___, 10/__ [___]
    -- 234 STR, 176 MND, 383 Attack, 247 Accuracy, 76 WSD, 0 PDL, 250 TP Bonus, 55PDT/45MDT [560HP]
  }
  sets.precast.WS['Savage Blade'].Safe = {
    ammo="Knobkierrie",             -- __, __, 23, __,  6, __, ___, __/__ [___]
    head=gear.Nyame_B_head,         -- 26, 26, 65, 50, 11, __, ___,  7/ 7 [ 91]
    body=gear.Nyame_B_body,         -- 45, 37, 65, 40, 13, __, ___,  9/ 9 [136]
    hands={
      name=gear.Nyame_B_hands,
      priority=1
    },                              -- 17, 40, 65, 40, 11, __, ___,  7/ 7 [ 91]
    legs={
      name=gear.Nyame_B_legs,
      priority=1
    },                              -- 43, 32, 65, 40, 12, __, ___,  8/ 8 [114]
    feet=gear.Nyame_B_feet,         -- 23, 26, 65, 53, 11, __, ___,  7/ 7 [ 68]
    neck="Futhark Torque +2",       -- 15, 15, __, __, __, __, ___,  7/ 7 [ 60]
    ear1="Odnowa Earring +1",       --  3, __, __, __, __, __, ___,  3/ 5 [110]
    ear2="Moonshade Earring",       -- __, __, __,  4, __, __, 250, __/__ [___]
    ring1="Gelatinous Ring +1",     -- __, __, __, __, __, __, ___,  7/-1 [135]
    ring2="Moonlight Ring",         -- __, __,  8,  8, __, __, ___,  5/ 5 [110]
    back=gear.RUN_WS2_Cape,         -- __, __, 20, 20, 10, __, ___, 10/__ [___]
    waist="Sailfi Belt +1",         -- 15, __, 15, __, __, __, ___, __/__ [___]
    -- 187 STR, 176 MND, 391 Attack, 255 Accuracy, 74 WSD, 0 PDL, 250 TP Bonus, 70PDT/54MDT [915HP]

    -- back=gear.RUN_WS3_Cape,      -- 30, __, 20, 20, 10, __, ___, 10/__ [___]
    -- 217 STR, 176 MND, 391 Attack, 255 Accuracy, 74 WSD, 0 PDL, 250 TP Bonus, 70PDT/54MDT [915HP]
  }

  sets.precast.WS['Savage Blade'].MaxTP = set_combine(sets.precast.WS['Savage Blade'].MaxTP, {})
  sets.precast.WS['Savage Blade'].LowAcc = set_combine(sets.precast.WS['Savage Blade'].LowAcc, {})
  sets.precast.WS['Savage Blade'].LowAccMaxTP = set_combine(sets.precast.WS['Savage Blade'].LowAccMaxTP, {})
  sets.precast.WS['Savage Blade'].MidAcc = set_combine(sets.precast.WS['Savage Blade'].MidAcc, {})
  sets.precast.WS['Savage Blade'].MidAccMaxTP = set_combine(sets.precast.WS['Savage Blade'].MidAccMaxTP, {})
  sets.precast.WS['Savage Blade'].HighAcc = set_combine(sets.precast.WS['Savage Blade'].HighAcc, {})
  sets.precast.WS['Savage Blade'].HighAccMaxTP = set_combine(sets.precast.WS['Savage Blade'].HighAccMaxTP, {})


  ------------------------------------------------------------------------------------------------
  ---------------------------------------- Engaged Sets ------------------------------------------
  ------------------------------------------------------------------------------------------------

  sets.engaged = {
    sub="Utu Grip",
    ammo="Coiste Bodhar",
    head=gear.Adhemar_B_head,
    body="Adhemar Jacket +1",
    hands=gear.Adhemar_A_hands,
    legs=gear.Samnuha_legs,
    feet=gear.Herc_TA_feet,
    neck="Anu Torque",
    waist="Windbuffet Belt +1",
    ear1="Telos Earring",
    ear2="Sherida Earring",
    ring1="Epona's Ring",
    ring2="Niqmaddu Ring",
    back=gear.RUN_TP_Cape,
  }
  sets.engaged.LowAcc = set_combine(sets.engaged, {
    head="Dampening Tam",
    -- neck="Combatant's Torque",
    waist="Ioskeha Belt +1",
  })
  sets.engaged.MidAcc = set_combine(sets.engaged.LowAcc, {
    ammo="Yamarang",
    ear1="Cessance Earring",
    ear2="Telos Earring",
    ring1="Chirich Ring +1",
  })
  sets.engaged.HighAcc = set_combine(sets.engaged.MidAcc, {
    ammo="Cath Palug Stone",
    legs=gear.Carmine_D_legs,
    ear1="Odr Earring",
    ear2="Dignitary's Earring",
    -- head="Carmine Mask +1",
    -- body="Carm. Sc. Mail +1",
    -- hands="Runeist Mitons +3",
    -- waist="Olseni Belt",
  })
  sets.engaged.Aftermath = {
    head="Ayanmo Zucchetto +2",
    neck="Anu Torque",
    ear1="Sherida Earring",
    ear2="Dedition Earring",
    ring1="Chirich Ring +1",
    waist="Kentarch Belt +1",
    -- body="Ashera Harness",
    -- ring2="Chirich Ring +1",
  }


  ------------------------------------------------------------------------------------------------
  ----------------------------------------- Idle Sets --------------------------------------------
  ------------------------------------------------------------------------------------------------

  sets.latent_regain = {
    head="Turms Cap +1",
  }
  sets.latent_regen = {
    head="Turms Cap +1", --7
    body="Futhark Coat +3", --5
    hands="Regal Gauntlets", --10
    feet="Turms Leggings +1", --5
    neck="Bathy Choker +1", --3
    ear1="Infused Earring", --1
    ring1="Chirich Ring +1", --2
  }
  sets.latent_refresh = {
    ammo="Homiliary", --1
    head=gear.Herc_Refresh_head, --1
    body="Runeist Coat +3", --3
    hands="Regal Gauntlets", --1
    legs="Rawhide Trousers", --1
    feet=gear.Herc_Refresh_feet, --2
    -- ring1="Stikini Ring +1",
    -- ring2="Stikini Ring +1",
  }
  sets.latent_refresh_sub50 = set_combine(sets.latent_refresh, {
    waist="Fucho-no-Obi",
  })

  sets.idle = set_combine(sets.defense.MDT, {})

  sets.idle.Regain = set_combine(sets.idle, sets.latent_regain)
  sets.idle.Regen = set_combine(sets.idle, sets.latent_regen)
  sets.idle.Refresh = set_combine(sets.idle, sets.latent_refresh)
  sets.idle.RefreshSub50 = set_combine(sets.idle, sets.latent_refresh_sub50)
  sets.idle.Regain.Regen = set_combine(sets.idle, sets.latent_regain, sets.latent_regen)
  sets.idle.Regain.Refresh = set_combine(sets.idle, sets.latent_regain, sets.latent_refresh)
  sets.idle.Regain.RefreshSub50 = set_combine(sets.idle, sets.latent_regain, sets.latent_refresh_sub50)
  sets.idle.Regen.Refresh = set_combine(sets.idle, sets.latent_regen, sets.latent_refresh)
  sets.idle.Regen.RefreshSub50 = set_combine(sets.idle, sets.latent_regen, sets.latent_refresh_sub50)
  sets.idle.Regain.Regen.Refresh = set_combine(sets.idle, sets.latent_regain, sets.latent_regen, sets.latent_refresh)
  sets.idle.Regain.Regen.RefreshSub50 = set_combine(sets.idle, sets.latent_regain, sets.latent_regen, sets.latent_refresh_sub50)

  sets.idle.LightDef = set_combine(sets.idle, sets.LightDef)
  sets.idle.LightDef.Regain = set_combine(sets.idle.Regain, sets.LightDef)
  sets.idle.LightDef.Regen = set_combine(sets.idle.Regen, sets.LightDef)
  sets.idle.LightDef.Refresh = set_combine(sets.idle.Refresh, sets.LightDef)
  sets.idle.LightDef.RefreshSub50 = set_combine(sets.idle.RefreshSub50, sets.LightDef)
  sets.idle.LightDef.Regain.Regen = set_combine(sets.idle.Regain.Regen, sets.LightDef)
  sets.idle.LightDef.Regain.Refresh = set_combine(sets.idle.Regain.Refresh, sets.LightDef)
  sets.idle.LightDef.Regain.RefreshSub50 = set_combine(sets.idle.Regain.RefreshSub50, sets.LightDef)
  sets.idle.LightDef.Regen.Refresh = set_combine(sets.idle.Regen.Refresh, sets.LightDef)
  sets.idle.LightDef.Regen.RefreshSub50 = set_combine(sets.idle.Regen.RefreshSub50, sets.LightDef)
  sets.idle.LightDef.Regain.Regen.Refresh = set_combine(sets.idle.Regain.Regen.Refresh, sets.LightDef)
  sets.idle.LightDef.Regain.Regen.RefreshSub50 = set_combine(sets.idle.Regain.Regen.RefreshSub50, sets.LightDef)

  sets.idle.Weak = set_combine(sets.defense.MDT, {})


  ------------------------------------------------------------------------------------------------
  ---------------------------------------- Hybrid Sets -------------------------------------------
  ------------------------------------------------------------------------------------------------

  sets.engaged.LightDef = {
    sub="Utu Grip",             -- __/__, ___ [ 70] __, __ <__, __, __> 30
    ammo="Staunch Tathlum +1",  --  3/ 3, ___ [___] __, __ <__, __, __> __
    head=gear.Nyame_B_head,     --  7/ 7, 123 [ 91]  6, __ < 5, __, __> 40
    body=gear.Nyame_B_body,     --  9/ 9, 139 [136]  3, __ < 7, __, __> 40
    hands=gear.Adhemar_A_hands, -- __/__,  43 [ 22]  5,  7 <__,  4, __> 52
    legs=gear.Samnuha_legs,     -- __/__,  75 [ 41]  6,  7 < 3,  3, __> 15
    feet="Erilaz Greaves +2",   -- 10/10, 147 [ 38]  4, __ <__, __, __> 50
    neck="Anu Torque",          -- __/__, ___ [___] __,  7 <__, __, __> __
    waist="Ioskeha Belt +1",    -- __/__, ___ [___]  8, __ < 9, __, __> 17
    ear1="Telos Earring",       -- __/__, ___ [___] __,  5 < 1, __, __> 10
    ear2="Sherida Earring",     -- __/__, ___ [___] __,  5 < 5, __, __> __
    ring1="Moonlight Ring",     --  5/ 5, ___ [110] __,  5 <__, __, __>  8
    ring2="Moonlight Ring",     --  5/ 5, ___ [110] __,  5 <__, __, __>  8
    back=gear.RUN_TP_Cape,      -- 10/__, ___ [___] __, 10 <__, __, __> 30
    -- 49 PDT / 39 MDT, 527 MEVA [618 HP] 32 Haste, 51 STP <30 DA, 7 TA, 0 QA> 300 Acc
  }
  sets.engaged.LowAcc.LightDef = set_combine(sets.engaged.LightDef, {})
  sets.engaged.MidAcc.LightDef = set_combine(sets.engaged.LightDef, {})
  sets.engaged.HighAcc.LightDef = set_combine(sets.engaged.LightDef, {})

  -- TODO: Needs updating
  sets.engaged.Aftermath.LightDef = {
    ammo="Coiste Bodhar",
    head="Ayanmo Zucchetto +2",
    body=gear.Nyame_B_body,
    hands=gear.Adhemar_A_hands,
    legs="Meghanada Chausses +2",
    feet=gear.Nyame_B_feet,
    neck="Futhark Torque +2",
    ear1="Sherida Earring",
    ear2="Dedition Earring",
    ring1="Moonlight Ring",
    ring2="Defending Ring",
    back=gear.RUN_TP_Cape,
    waist="Sailfi Belt +1",
    -- body="Ashera Harness",
  }

  ------------------------------------------------------------------------------------------------
  ---------------------------------------- Special Sets ------------------------------------------
  ------------------------------------------------------------------------------------------------

  sets.Special = {}
  sets.Special.SleepyHead = { head="Frenzy Sallet", }
  sets.Special.Encumbrance = {
    -- Epeolatry                    --(25)/_, ___ [___] __ (__, ___) 23, __
    sub="Alber Strap",              --  2/__, ___ [___] __ (__, ___)  5, __
    ammo="Sapience Orb",            -- __/__, ___ [___] __ (__, ___)  2,  2
    head="Halitus Helm",            -- __/__,  43 [ 88]  2 (__, ___)  8, __
    body="Erilaz Surcoat +2",       -- __/__, 120 [133]  9 (__, ___) __, 10; Retain enmity; Convert dmg to MP
    hands="Kurys Gloves",           --  2/ 2,  57 [ 25]  2 (__, ___)  9, __
    legs="Erilaz Leg Guards +2",    -- 12/12, 147 [ 90]  9 (__, ___) 12, __
    feet="Erilaz Greaves +2",       -- 10/10, 147 [ 38]  8 (__,  30)  7, __
    neck="Unmoving Collar +1",      -- __/__, ___ [200] __ (__, ___) 10, __
    ear1="Odnowa Earring +1",       --  3/ 5, ___ [110] __ (__, ___) __, __
    ear2="Cryptic Earring",         -- __/__, ___ [ 40] __ (__, ___)  4, __
    ring1="Moonlight Ring",         --  5/ 5, ___ [110] __ (__, ___) __, __
    ring2="Defending Ring",         -- 10/10, ___ [___] __ (__, ___) __, __
    back="Moonlight Cape",          --  6/ 6, ___ [275] __ (__, ___) __, __
    waist="Engraved Belt",          -- __/__, ___ [___] __ (__,  20) __, __
    -- Runes                        -- __/__, ___ [___] __ (__, 253) __, __
    -- Bar-spell                    -- __/__, ___ [___] __ (__, 131) __, __
    -- Trait                        -- __/__, ___ [___] 22 (__, ___) __, __
    -- 50(+25)PDT / 50 MDT, 514 Meva [1109 HP] 52 M.Def.Bns. (0 Status Resist, 434 Ele Resist) 80 Enmity, 12 Fast Cast
  }

  sets.buff.Doom = {
    neck="Nicander's Necklace", --20
    ring1="Eshmun's Ring", --20
    waist="Gishdubar Sash", --10
  }

  sets.Kiting = {
    legs=gear.Carmine_D_legs,
  }
  sets.Kiting.Adoulin = {
    body="Councilor's Garb",
  }
  sets.DeathResist = {
    ring1="Eihwaz Ring", --10%
    ring2="Warden's Ring", --10%
  }
  sets.Embolden = set_combine(sets.midcast.EnhancingDuration, {
    back=gear.RUN_Adoulin_Cape
  })
  sets.CP = {
    back=gear.CP_Cape,
  }
  sets.Reive = {
    neck="Ygnas's Resolve +1"
  }

  -- Weapon Sets
  sets.WeaponSet = {}
  sets.WeaponSet["Naegling"] = {
    main="Naegling",
  }
  sets.WeaponSet["Epeolatry"] = {
    main="Epeolatry",
  }
  sets.WeaponSet["Lionheart"] = {
    main="Lionheart",
  }
  sets.WeaponSet["Lycurgos"] = {
    main="Lycurgos",
  }

end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

function job_precast(spell, action, spellMap, eventArgs)
  silibs.precast_hook(spell, action, spellMap, eventArgs)
  ----------- Non-silibs content goes below this line -----------

  if runes:contains(spell.english) then
    eventArgs.handled = true
  end

  -- Use defensive "safe" sets if any are defined. Falls back to normal sets if a "safe" set is not defined.
  if state.DefenseMode.value ~= 'None'
      or (state.HybridMode.value ~= 'Normal' and player.in_combat)
      or (state.IdleMode.value ~= 'Normal' and not player.in_combat) then
    if spell.action_type == 'Ability' and spell.type ~= 'WeaponSkill' then
      classes.JAMode = 'Safe'
    elseif spell.action_type == 'Magic' then
      state.CastingMode:set('Safe')
    end
  end

  -- Use Swipe if Lunge is on cooldown
  if spell.english == 'Lunge' then
    local abil_recasts = windower.ffxi.get_ability_recasts()
    if abil_recasts[spell.recast_id] > 0 then
      send_command('input /jobability "Swipe" <t>')
      eventArgs.cancel = true
      return
    end
  end

  -- Use Vallation if Valiance is on cooldown
  if spell.english == 'Valiance' then
    local abil_recasts = windower.ffxi.get_ability_recasts()
    if abil_recasts[spell.recast_id] > 0 then
      send_command('input /jobability "Vallation" <me>')
      eventArgs.cancel = true
      return
    -- Cancel Vallation if using Valiance
    elseif spell.english == 'Valiance' and buffactive['vallation'] then
      cast_delay(0.2)
      send_command('cancel Vallation') -- command requires 'cancel' add-on to work
    end
  end

  -- Cancel shadows if casting more shadows
  if spellMap == 'Utsusemi' then
    if buffactive['Copy Image (3)'] or buffactive['Copy Image (4+)'] then
      cancel_spell()
      add_to_chat(123, '**!! '..spell.english..' Canceled: [3+ IMAGES] !!**')
      eventArgs.handled = true
      return
    elseif buffactive['Copy Image'] or buffactive['Copy Image (2)'] then
      send_command('cancel 66; cancel 444; cancel Copy Image; cancel Copy Image (2)')
    end
  end

  -- Record which rune elements are active when Rayke or Gambit is used.
  if spell.english == 'Rayke' or spell.english == 'Gambit' then
    -- Examine all active buffs
    for k,buff_id in pairs(player.buffs) do
      -- Translate buff ID into English
      local buff_name = res.buffs:get(buff_id).en;
      -- If buff is a Rune, snapshot it as it was expended
      if runes:contains(buff_name) then
        table.insert(expended_runes, buff_name)
      end
    end
  end
end

function job_post_precast(spell, action, spellMap, eventArgs)
  -- Equip Reive set for ws if in a Reive
  if spell.type == "WeaponSkill" then
    if buffactive['Reive Mark'] then
      equip(sets.Reive)
    end
  end

  if state.DefenseMode.value ~= 'None' and state[state.DefenseMode.value .. 'DefenseMode'].value == 'Encumbrance' then
    equip(sets.Special.Encumbrance)
    if spell.english == 'Elemental Sforzo' then
      equip(sets.precast.JA['Elemental Sforzo'])
    end
  end

  -- If slot is locked, keep current equipment on
  if locked_neck then equip({ neck=player.equipment.neck }) end
  if locked_ear1 then equip({ ear1=player.equipment.ear1 }) end
  if locked_ear2 then equip({ ear2=player.equipment.ear2 }) end
  if locked_ring1 then equip({ ring1=player.equipment.ring1 }) end
  if locked_ring2 then equip({ ring2=player.equipment.ring2 }) end

  ----------- Non-silibs content goes above this line -----------
  silibs.post_precast_hook(spell, action, spellMap, eventArgs)
end

function job_midcast(spell, action, spellMap, eventArgs)
  silibs.midcast_hook(spell, action, spellMap, eventArgs)
  ----------- Non-silibs content goes below this line -----------
end

-- Run after the default midcast() is done.
-- eventArgs is the same one used in job_midcast, in case information needs to be persisted.
function job_post_midcast(spell, action, spellMap, eventArgs)
  if spell.english == 'Lunge' or spell.english == 'Swipe' then
    if (spell.element == world.day_element or spell.element == world.weather_element) then
      equip(sets.Obi)
    end
  end
  if state.DefenseMode.value == 'None' then
    if spell.skill == 'Enhancing Magic' and classes.NoSkillSpells:contains(spell.english) then
      equip(sets.midcast.EnhancingDuration)
      if spellMap == 'Refresh' then
        equip(sets.midcast.Refresh)
      end
    end
    if spell.english == 'Phalanx' and buffactive['Embolden'] then
      equip(sets.midcast.EnhancingDuration)
    end
  end

  if state.DefenseMode.value ~= 'None' and state[state.DefenseMode.value .. 'DefenseMode'].value == 'Encumbrance' then
    equip(sets.Special.Encumbrance)
  end
  
  -- If slot is locked, keep current equipment on
  if locked_neck then equip({ neck=player.equipment.neck }) end
  if locked_ear1 then equip({ ear1=player.equipment.ear1 }) end
  if locked_ear2 then equip({ ear2=player.equipment.ear2 }) end
  if locked_ring1 then equip({ ring1=player.equipment.ring1 }) end
  if locked_ring2 then equip({ ring2=player.equipment.ring2 }) end

  ----------- Non-silibs content goes above this line -----------
  silibs.post_midcast_hook(spell, action, spellMap, eventArgs)
end

function job_aftercast(spell, action, spellMap, eventArgs)
  silibs.aftercast_hook(spell, action, spellMap, eventArgs)
  ----------- Non-silibs content goes below this line -----------

  state.CastingMode:reset()

  local chat_mode = '/p'
  if windower.ffxi.get_party().party1_count == 1 then
    chat_mode = '/echo'
  end

  if spell.name == 'Rayke' then
    if spell.interrupted then
      expended_runes = {}
    else
      -- Record Rayke target
      rayke_target = spell.target

      -- Print chat message
      local element_potencies = get_element_potencies()
      local el_msg = ''
      for k,v in pairs(element_potencies) do
        el_msg = el_msg..'('..v.element
        if v.count == 1 then
          el_msg = el_msg..string.char(129,171)
        elseif v.count == 2 then
          el_msg = el_msg..string.char(129,171)..string.char(129,171)
        elseif v.count == 3 then
          el_msg = el_msg..string.char(129,171)..string.char(129,171)..string.char(129,171)
        end
        el_msg = el_msg..')'
      end

      send_command('@timers c "Rayke ['..spell.target.name..']" '..rayke_duration..' down spells/00136.png') -- Requires Timers plugin
      send_command('@input '..chat_mode..' [Rayke] Resist Down '..el_msg..' '..string.char(129, 168)..' <t>;')
      coroutine.schedule(display_rayke_worn, rayke_duration)
      expended_runes = {} -- Reset tracking of expended runes
    end
  elseif spell.name == 'Gambit' then
    if spell.interrupted then
      expended_runes = {}
    else
      -- Record Rayke target
      gambit_target = spell.target

      -- Print chat message
      local element_potencies = get_element_potencies()
      local el_msg = ''
      for k,v in pairs(element_potencies) do
        el_msg = el_msg..'('..v.element
        if v.count == 1 then
          el_msg = el_msg..string.char(129,171)
        elseif v.count == 2 then
          el_msg = el_msg..string.char(129,171)..string.char(129,171)
        elseif v.count == 3 then
          el_msg = el_msg..string.char(129,171)..string.char(129,171)..string.char(129,171)
        end
        el_msg = el_msg..')'
      end

      send_command('@timers c "Gambit ['..spell.target.name..']" '..gambit_duration..' down spells/00136.png') -- Requires Timers plugin
      send_command('@input '..chat_mode..' [Gambit] M.Def Down '..el_msg..' '..string.char(129,168)..' <t>;')
      coroutine.schedule(display_gambit_worn, gambit_duration)
      expended_runes = {} -- Reset tracking of expended runes
    end
  end
end

function job_post_aftercast(spell, action, spellMap, eventArgs)
  ----------- Non-silibs content goes above this line -----------
  silibs.post_aftercast_hook(spell, action, spellMap, eventArgs)
end


-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for non-casting events.
-------------------------------------------------------------------------------------------------------------------

-- Called when a player gains or loses a buff.
-- buff == buff gained or lost
-- gain == true if the buff was gained, false if it was lost.
-- Theory: debuffs must be lowercase and buffs must begin with uppercase
function job_buff_change(buff,gain)

  if buff == "terror" then
    if gain then
      equip(sets.defense.PDT)
    end
  end

  if buff == 'sleep' and gain and player.vitals.hp > 500 and player.status == 'Engaged' then
    equip(sets.Special.SleepyHead)
  end

  if buff == "doom" then
    if gain then
      send_command('@input /p Doomed.')
    elseif player.hpp > 0 then
      send_command('@input /p Doom Removed.')
    end
  end

  if buff == 'Embolden' then
    if gain then
      equip(sets.Embolden)
      disable('head','legs','back')
    else
      enable('head','legs','back')
    end
  end

  if buff:startswith('Aftermath') then
    state.Buff.Aftermath = gain
    customize_melee_set()
    handle_equipping_gear(player.status)
  end

  -- Update gear for these specific buffs
  if buff == "terror" or buff == "doom" or buff == "Embolden" or buff == "Battuta" or buff:startswith("Aftermath") then
    status_change(player.status)
  end

end

-- Handle notifications of general user state change.
function job_state_change(stateField, newValue, oldValue)
end

-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------

function job_handle_equipping_gear(playerStatus, eventArgs)
  check_gear()
  update_idle_groups()
end

-- Modify the default idle set after it was constructed.
function customize_idle_set(idleSet)
  if state.DefenseMode.value ~= 'None' and state[state.DefenseMode.value .. 'DefenseMode'].value == 'Encumbrance' then
    return set_combine(idleSet, sets.Special.Encumbrance)
  end

  if state.Knockback.value == true then
    idleSet = set_combine(idleSet, sets.defense.Knockback)
  end
  if state.DeathResist.value == true then
    idleSet = set_combine(idleSet, sets.DeathResist)
  end
  -- If not in DT mode put on move speed gear
  if state.IdleMode.current == 'Normal' and state.DefenseMode.value == 'None' then
    if classes.CustomIdleGroups:contains('Adoulin') then
      idleSet = set_combine(idleSet, sets.Kiting.Adoulin)
    else
      idleSet = set_combine(idleSet, sets.Kiting)
    end
  end
  if buffactive['terror'] then
    idleSet = set_combine(idleSet, sets.defense.PDT)
  end
  if state.CP.current == 'on' then
    idleSet = set_combine(idleSet, sets.CP)
  end

  -- If slot is locked to use no-swap gear, keep it equipped
  if locked_neck then idleSet = set_combine(idleSet, { neck=player.equipment.neck }) end
  if locked_ear1 then idleSet = set_combine(idleSet, { ear1=player.equipment.ear1 }) end
  if locked_ear2 then idleSet = set_combine(idleSet, { ear2=player.equipment.ear2 }) end
  if locked_ring1 then idleSet = set_combine(idleSet, { ring1=player.equipment.ring1 }) end
  if locked_ring2 then idleSet = set_combine(idleSet, { ring2=player.equipment.ring2 }) end

  if buffactive.Doom then
    idleSet = set_combine(idleSet, sets.buff.Doom)
  end
  
  return idleSet
end

-- Modify the default melee set after it was constructed.
function customize_melee_set(meleeSet)
  if buffactive['Aftermath: Lv.3'] and player.equipment.main == "Epeolatry"
      and state.DefenseMode.value == 'None' then
    if state.HybridMode.value == "LightDef" then
      meleeSet = set_combine(meleeSet, sets.engaged.Aftermath.LightDef)
    else
      meleeSet = set_combine(meleeSet, sets.engaged.Aftermath)
    end
  end
  if state.Knockback.value == true then
    meleeSet = set_combine(meleeSet, sets.defense.Knockback)
  end
  if state.DeathResist.value == true then
    meleeSet = set_combine(meleeSet, sets.DeathResist)
  end
  if buffactive['terror'] then
    meleeSet = set_combine(meleeSet, sets.defense.PDT)
  end
  if state.CP.current == 'on' then
    meleeSet = set_combine(meleeSet, sets.CP)
  end

  -- If slot is locked to use no-swap gear, keep it equipped
  if locked_neck then meleeSet = set_combine(meleeSet, { neck=player.equipment.neck }) end
  if locked_ear1 then meleeSet = set_combine(meleeSet, { ear1=player.equipment.ear1 }) end
  if locked_ear2 then meleeSet = set_combine(meleeSet, { ear2=player.equipment.ear2 }) end
  if locked_ring1 then meleeSet = set_combine(meleeSet, { ring1=player.equipment.ring1 }) end
  if locked_ring2 then meleeSet = set_combine(meleeSet, { ring2=player.equipment.ring2 }) end

  if buffactive['sleep'] and player.vitals.hp > 500 and player.status == 'Engaged' then
    meleeSet = set_combine(meleeSet, sets.Special.SleepyHead)
  end

  if buffactive.Doom then
    meleeSet = set_combine(meleeSet, sets.buff.Doom)
  end

  return meleeSet
end

function customize_defense_set(defenseSet)
  if state.DefenseMode.value ~= 'None' and state[state.DefenseMode.value .. 'DefenseMode'].value == 'Encumbrance' then
    return set_combine(defenseSet, sets.Special.Encumbrance)
  end

  if buffactive['Battuta'] then
    defenseSet = set_combine(defenseSet, sets.defense.Parry)
  end
  if state.Knockback.value == true then
    defenseSet = set_combine(defenseSet, sets.defense.Knockback)
  end
  if state.DeathResist.value == true then
    defenseSet = set_combine(defenseSet, sets.DeathResist)
  end
  if state.CP.current == 'on' then
    defenseSet = set_combine(defenseSet, sets.CP)
  end

  -- If slot is locked to use no-swap gear, keep it equipped
  if locked_neck then defenseSet = set_combine(defenseSet, { neck=player.equipment.neck }) end
  if locked_ear1 then defenseSet = set_combine(defenseSet, { ear1=player.equipment.ear1 }) end
  if locked_ear2 then defenseSet = set_combine(defenseSet, { ear2=player.equipment.ear2 }) end
  if locked_ring1 then defenseSet = set_combine(defenseSet, { ring1=player.equipment.ring1 }) end
  if locked_ring2 then defenseSet = set_combine(defenseSet, { ring2=player.equipment.ring2 }) end

  if buffactive['sleep'] and player.vitals.hp > 500 and player.status == 'Engaged' then
    defenseSet = set_combine(defenseSet, sets.Special.SleepyHead)
  end

  if buffactive.Doom then
    defenseSet = set_combine(defenseSet, sets.buff.Doom)
  end
  
  return defenseSet
end

function user_customize_idle_set(idleSet)
  -- Any non-silibs modifications should go in customize_idle_set function
  return silibs.customize_idle_set(idleSet)
end

function user_customize_melee_set(meleeSet)
  -- Any non-silibs modifications should go in customize_melee_set function
  return silibs.customize_melee_set(meleeSet)
end

function user_customize_defense_set(defenseSet)
  -- Any non-silibs modifications should go in customize_defense_set function
  return silibs.customize_defense_set(defenseSet)
end

-- Function to display the current relevant user state when doing an update.
-- Set eventArgs.handled to true if display was handled, and you don't want the default info shown.
function display_current_job_state(eventArgs)
  local r_msg = state.Runes.current
  local r_color = 1
  if state.Runes.current == 'Ignis' then r_color = 167
  elseif state.Runes.current == 'Gelus' then r_color = 210
  elseif state.Runes.current == 'Flabra' then r_color = 204
  elseif state.Runes.current == 'Tellus' then r_color = 050
  elseif state.Runes.current == 'Sulpor' then r_color = 215
  elseif state.Runes.current == 'Unda' then r_color = 207
  elseif state.Runes.current == 'Lux' then r_color = 001
  elseif state.Runes.current == 'Tenebrae' then r_color = 160 end

  local m_msg = state.OffenseMode.value
  if state.HybridMode.value ~= 'Normal' then
    m_msg = m_msg .. '/' ..state.HybridMode.value
  end

  local am_msg = '(' ..string.sub(state.AttackMode.value,1,1).. ')'

  local d_msg = 'None'
  if state.DefenseMode.value ~= 'None' then
    d_msg = state.DefenseMode.value .. state[state.DefenseMode.value .. 'DefenseMode'].value
  end

  local i_msg = state.IdleMode.value

  local toy_msg = state.ToyWeapons.current

  local msg = ''
  if state.Knockback.value == true then
    msg = msg .. ' Knockback Resist |'
  end
  if state.Kiting.value then
    msg = msg .. ' Kiting: On |'
  end
  if state.DeathResist.value then
    msg = msg .. ' Death Resist: On |'
  end
  if state.CP.current == 'on' then
    msg = msg .. ' CP Mode: On |'
  end

  add_to_chat(r_color, string.char(129,121).. '  ' ..string.upper(r_msg).. '  ' ..string.char(129,122)
      ..string.char(31,004).. ' Defense: ' ..string.char(31,001)..d_msg.. string.char(31,002).. ' |'
      ..string.char(31,207).. ' Idle: ' ..string.char(31,001)..i_msg.. string.char(31,002).. ' |'
      ..string.char(31,012).. ' Toy Weapon: ' ..string.char(31,001)..toy_msg.. string.char(31,002)..  ' |'
      ..string.char(31,002)..msg)

  eventArgs.handled = true
end


-------------------------------------------------------------------------------------------------------------------
-- General hooks for other events.
-------------------------------------------------------------------------------------------------------------------
function job_get_spell_map(spell, default_spell_map)
  if spell.skill == 'Blue Magic' then
    for category,spell_list in pairs(blue_magic_maps) do
      if spell_list:contains(spell.english) then
        return category
      end
    end
  end
end

-------------------------------------------------------------------------------------------------------------------
-- User code that supplements self-commands.
-------------------------------------------------------------------------------------------------------------------

function get_custom_wsmode(spell, action, spellMap)
  local wsmode = ''

  if state.DefenseMode.value ~= 'None' then
    wsmode = 'Safe'
  else
    if state.OffenseMode.value ~= 'Normal' then
      wsmode = state.OffenseMode.value
    end

    if player.tp > 2900 then
      wsmode = wsmode..'MaxTP'
    end
  end

  return wsmode
end

function cycle_weapons(cycle_dir)
  if cycle_dir == 'forward' then
    state.WeaponSet:cycle()
  elseif cycle_dir == 'back' then
    state.WeaponSet:cycleback()
  end

  add_to_chat(141, 'Weapon Set to '..string.char(31,1)..state.WeaponSet.current)
  equip(sets.WeaponSet[state.WeaponSet.current])
end

function cycle_toy_weapons(cycle_dir)
  --If current state is None, save current weapons to switch back later
  if state.ToyWeapons.current == 'None' then
    sets.ToyWeapon.None.main = player.equipment.main
    sets.ToyWeapon.None.sub = player.equipment.sub
  end

  if cycle_dir == 'forward' then
    state.ToyWeapons:cycle()
  elseif cycle_dir == 'back' then
    state.ToyWeapons:cycleback()
  else
    state.ToyWeapons:reset()
  end

  local mode_color = 001
  if state.ToyWeapons.current == 'None' then
    mode_color = 006
  end
  add_to_chat(012, 'Toy Weapon Mode: '..string.char(31,mode_color)..state.ToyWeapons.current)
  equip(sets.ToyWeapon[state.ToyWeapons.current])
end

function get_element_potencies()
  local element_potencies = {}
  for k,rune in pairs(expended_runes) do
    -- Get rune's corresponding element
    local el = runes.element_of[rune]
    -- Find element entry if already in the table
    local el_index = nil
    for k,v in pairs(element_potencies) do
      if v.element == el then
        el_index = k
      end
    end
    -- If element was not found, add new entry
    if el_index == nil then
      table.insert(element_potencies, { element=el, count=1 })
    else -- Otherwise, increase its count
      element_potencies[el_index].count = element_potencies[el_index].count + 1
    end
  end
  return element_potencies;
end

function display_rayke_worn()
  local chat_mode = '/p'
  if windower.ffxi.get_party().party1_count == 1 then
    chat_mode = '/echo'
  end

  -- Ensure execution only once by checking for saved target data
  if rayke_target ~= nil then
    send_command('@input '..chat_mode..' [Rayke] Just wore off!;')
    -- If timer still exists, clear it
    send_command('@timers d "Rayke ['..rayke_target.name..']"') -- Requires Timers plugin

    rayke_target = nil -- Reset target
  end
end

function display_gambit_worn()
  local chat_mode = '/p'
  if windower.ffxi.get_party().party1_count == 1 then
    chat_mode = '/echo'
  end

  -- Ensure execution only once by checking for saved target data
  if gambit_target ~= nil then
    send_command('@input '..chat_mode..' [Gambit] Just wore off!;')
    -- If timer still exists, clear it
    send_command('@timers d "Gambit ['..gambit_target.name..']"') -- Requires Timers plugin

    gambit_target = nil -- Reset target
  end
end

function display_rayke_gambit_worn()
  local chat_mode = '/p'
  if windower.ffxi.get_party().party1_count == 1 then
    chat_mode = '/echo'
  end

  send_command('@input '..chat_mode..' [Rayke & Gambit] Just wore off!;')
  -- If timer still exists, clear it
  send_command('@timers d "Rayke ['..rayke_target.name..']"') -- Requires Timers plugin
  -- If timer still exists, clear it
  send_command('@timers d "Gambit ['..gambit_target.name..']"') -- Requires Timers plugin

  rayke_target = nil -- Reset target
  gambit_target = nil -- Reset target
end

-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

function update_idle_groups()
  local isRegening = classes.CustomIdleGroups:contains('Regen')
  local isRefreshing = classes.CustomIdleGroups:contains('Refresh')

  classes.CustomIdleGroups:clear()
  if player.status == 'Idle' then
    if player.tp < 3000 then
      classes.CustomIdleGroups:append('Regain')
    end
    if isRegening==true and player.hpp < 100 then
      classes.CustomIdleGroups:append('Regen')
    elseif isRegening==false and player.hpp < 85 then
      classes.CustomIdleGroups:append('Regen')
    end
    if mp_jobs:contains(player.main_job) or mp_jobs:contains(player.sub_job) then
      if player.mpp < 50 then
        classes.CustomIdleGroups:append('RefreshSub50')
      elseif isRefreshing==true and player.mpp < 100 then
        classes.CustomIdleGroups:append('Refresh')
      elseif isRefreshing==false and player.mpp < 85 then
        classes.CustomIdleGroups:append('Refresh')
      end
    end
    if world.zone == 'Eastern Adoulin' or world.zone == 'Western Adoulin' then
      classes.CustomIdleGroups:append('Adoulin')
    end
  end
end

function job_self_command(cmdParams, eventArgs)
  silibs.self_command(cmdParams, eventArgs)
  ----------- Non-silibs content goes below this line -----------

  if cmdParams[1] == 'rune' then
    send_command('@input /ja '..state.Runes.value..' <me>')
  elseif cmdParams[1] == 'toyweapon' then
    if cmdParams[2] == 'cycle' then
      cycle_toy_weapons('forward')
    elseif cmdParams[2] == 'cycleback' then
      cycle_toy_weapons('back')
    elseif cmdParams[2] == 'reset' then
      cycle_toy_weapons('reset')
    end
  elseif cmdParams[1] == 'weaponset' then
    if cmdParams[2] == 'cycle' then
      cycle_weapons('forward')
    elseif cmdParams[2] == 'cycleback' then
      cycle_weapons('back')
    elseif cmdParams[2] == 'current' then
      cycle_weapons('current')
    end
  elseif cmdParams[1] == 'test' then
    test()
  end
end

function check_gear()
  if no_swap_necks:contains(player.equipment.neck) then
    locked_neck = true
  else
    locked_neck = false
  end
  if no_swap_earrings:contains(player.equipment.ear1) then
    locked_ear1 = true
  else
    locked_ear1 = false
  end
  if no_swap_earrings:contains(player.equipment.ear2) then
    locked_ear2 = true
  else
    locked_ear2 = false
  end
  if no_swap_rings:contains(player.equipment.ring1) then
    locked_ring1 = true
  else
    locked_ring1 = false
  end
  if no_swap_rings:contains(player.equipment.ring2) then
    locked_ring2 = true
  else
    locked_ring2 = false
  end
end

windower.register_event('zone change', function()
  if locked_neck then equip({ neck=empty }) end
  if locked_ear1 then equip({ ear1=empty }) end
  if locked_ear2 then equip({ ear2=empty }) end
  if locked_ring1 then equip({ ring1=empty }) end
  if locked_ring2 then equip({ ring2=empty }) end
end)

windower.raw_register_event('incoming chunk', function(id, data, modified, injected, blocked)
  -- Listen for kill message (when an enemy is defeated)
  if id == 0x029 then -- Combat messages
    local message_id = data:unpack("H",0x19)%2^15 -- Cut off the most significant bit
    if message_id == 6 then
      local defeated_mob_id = data:unpack("I",0x09)
      if (rayke_target ~= nil and defeated_mob_id == rayke_target.id) and (gambit_target ~= nil and defeated_mob_id == gambit_target.id) then
        -- Display message that Rayke and Gambit have worn off due to mob death (if applicable)
        display_rayke_gambit_worn()
      elseif rayke_target ~= nil and defeated_mob_id == rayke_target.id then
        -- Display message that Rayke has worn off (because Rayked mob was killed)
        display_rayke_worn()
      elseif gambit_target ~= nil and defeated_mob_id == gambit_target.id then
        -- Display message that Gambit has worn off (because Gambited mob was killed)
        display_gambit_worn()
      end
    end
  end
end)

-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
  -- Default macro set/book: (set, book)
  if player.sub_job == 'BLU' then
    set_macro_page(5, 5)
  elseif player.sub_job == 'DRK' or player.sub_job == 'BLM' then
    set_macro_page(2, 5)
  elseif player.sub_job == 'WAR' then
    set_macro_page(4, 5)
  else
    set_macro_page(5, 5)
  end
end

function test()
end