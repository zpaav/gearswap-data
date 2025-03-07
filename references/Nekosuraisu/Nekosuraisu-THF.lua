-- Author: Silvermutt
-- Haste/DW Detection Requires Gearinfo Addon

-------------------------------------------------------------------------------------------------------------------
--  Keybinds
-------------------------------------------------------------------------------------------------------------------

--  Modes:      [ F9 ]              Cycle Offense Modes
--              [ CTRL+F9 ]         Cycle Hybrid Modes
--              [ WIN+F9 ]          Cycle Weapon Skill Modes
--              [ F10 ]             Emergency -PDT Mode
--              [ F11 ]             Emergency -MDT Mode
--              [ F12 ]             Update Current Gear / Report Current Status
--              [ CTRL+F12 ]        Cycle Idle Modes
--              [ ALT+F12 ]         Cancel Emergency -PDT/-MDT Mode
--              [ CTRL+` ]          Cycle Treasure Hunter Mode
--              [ WIN+C ]           Toggle Capacity Points Mode
--              [ CTRL+F8 ]         Toggle Attack Capped mode
--              [ WIN+W ]           Toggle Rearming Lock
--                                  (off = re-equip previous weapons if you go barehanded)
--                                  (on = prevent weapon auto-equipping)
--
--  Abilities:  [ ALT+` ]           Flee
--              [ CTRL+Numpad0 ]    Sneak Attack
--              [ CTRL+Numpad. ]    Trick Attack
-- 
--  Subjob:     == WAR ==
--              [ ALT+W ]           Defender
--              [ CTRL+Numpad/ ]    Berserk
--              [ CTRL+Numpad* ]    Warcry
--              [ CTRL+Numpad- ]    Aggressor
--              == SAM ==
--              [ ALT+W ]           Third Eye
--              [ CTRL+Numpad/ ]    Meditate
--              [ CTRL+Numpad* ]    Sekkanoki
--              [ CTRL+Numpad- ]    Hasso
--              == DNC ==
--              [ CTRL+- ]          Cycle Step Mode
--              [ CTRL+= ]          Cycleback Step Mode
--              [ Numpad0 ]         Execute Step
--              [ CTRL+Numlock ]    Reverse Flourish
--              == NIN ==
--              [ Numpad0 ]         Utsusemi: Ichi
--              [ Numpad. ]         Utsusemi: Ni
--              == RUN ==
--              [ CTRL+- ]          Cycle Rune Mode
--              [ CTRL+= ]          Cycleback Rune Mode
--              [ Numpad0 ]         Execute Rune
--              == DRG ==
--              [ ALT+W ]           Ancient Circle
--              [ CTRL+Numpad/ ]    Jump
--              [ CTRL+Numpad* ]    High Jump
--              [ CTRL+Numpad- ]    Super Jump
--
--  Other:      [ ALT+D ]           Cancel Invisible/Hide & Use Key on <t>
--              [ ALT+S ]           Turn 180 degrees in place
--              [ CTRL+Insert ]     Cycle Main/Sub Weapon
--              [ CTRL+Delete ]     Cycleback Main/Sub Weapon
--              [ ALT+Delete ]      Reset Main/Sub Weapon
--              [ CTRL+Home ]       Cycle Ranged Weapon
--              [ CTRL+End ]        Cycleback Ranged Weapon
--              [ ALT+End ]         Reset Ranged Weapon
--              [ CTRL+PageUp ]     Cycle Toy Weapon
--              [ CTRL+PageDown ]   Cycleback Toy Weapon
--              [ ALT+PageDown ]    Reset Toy Weapon
--              [ E ]               Ranged Attack Current Target
--
--
--              (Global-Binds.lua contains additional non-job-related keybinds)


-------------------------------------------------------------------------------------------------------------------
-- Setup functions for this job.  Generally should not be modified.
-------------------------------------------------------------------------------------------------------------------

-- Initialization function for this job file.
function get_sets()
  -- Load and initialize Mote library
  mote_include_version = 2
  include('Mote-Include.lua') -- Executes job_setup, user_setup, init_gear_sets
  coroutine.schedule(function()
    send_command('gs c weaponset current')
  end, 5)
end

-- Executes on first load and main job change
function job_setup()
  silibs.enable_cancel_outranged_ws()
  silibs.enable_weapon_rearm()
  silibs.enable_auto_lockstyle(9)
  silibs.enable_premade_commands()
  silibs.enable_th()

  Haste = 0 -- Do not modify
  DW_needed = 0 -- Do not modify
  DW = false -- Do not modify
  current_dp_type = nil -- Do not modify

  state.Buff['Sneak Attack'] = buffactive['sneak attack'] or false
  state.Buff['Trick Attack'] = buffactive['trick attack'] or false
  state.Buff['Feint'] = buffactive['feint'] or false
  
  state.MainStep = M{['description']='Main Step', 'Box Step', 'Quickstep', 'Feather Step', 'Stutter Step'}
  state.OffenseMode:options('Normal', 'LowAcc', 'MidAcc', 'HighAcc')
  state.RangedMode:options('Normal', 'Acc')
  state.HybridMode:options('LightDef', 'HeavyDef', 'Evasion', 'Normal')
  state.IdleMode:options('Normal', 'Regain', 'LightDef', 'Evasion')
  state.CP = M(false, 'Capacity Points Mode')
  state.AttCapped = M(true, "Attack Capped")
  state.Runes = M{['description']='Runes', 'Ignis', 'Gelus', 'Flabra', 'Tellus', 'Sulpor', 'Unda', 'Lux', 'Tenebrae'}
  state.ToyWeapons = M{['description']='Toy Weapons','None','Dagger',
      'Sword','Club','Staff','Polearm','GreatSword','Scythe'}
  
  -- Customizable Weapon Sets. Name must match set name (far below)
  state.WeaponSet = M{['description']='Weapon Set', 'WhiteGlass', 'Normal', 'Naegling', 'NaeglingAcc', 'H2H', 'Staff', 'Cleaving'}
  state.RangedWeaponSet = M{['description']='Ranged Weapon Set', 'None', 'Throwing', 'Archery'}

  -- Indicate if a marksmanship weapon is xbow or gun (archery and throwing not needed here)
  marksman_weapon_subtypes = {
    -- ['Gastraphetes'] = "xbow",
    -- ['Fomalhaut'] = "gun",
  }

  DefaultAmmo = {
    ['Ullr'] = "Eminent Arrow",
  }
  AccAmmo = {
    ['Ullr'] = "Eminent Arrow",
  }
  WSAmmo = {
    ['Ullr'] = "Eminent Arrow",
  }
  MagicAmmo = {
    ['Ullr'] = "Eminent Arrow",
  }

  -- Main job keybinds
  send_command('bind !s gs c faceaway')
  send_command('bind !d gs c usekey')
  send_command('bind @w gs c toggle RearmingLock')
  
  send_command('bind ^insert gs c weaponset cycle')
  send_command('bind ^delete gs c weaponset cycleback')
  send_command('bind !delete gs c weaponset reset')
  send_command('bind ^home gs c rangedweaponset cycle')
  send_command('bind ^end gs c rangedweaponset cycleback')
  send_command('bind !end gs c rangedweaponset reset')

  send_command('bind ^pageup gs c toyweapon cycle')
  send_command('bind ^pagedown gs c toyweapon cycleback')
  send_command('bind !pagedown gs c toyweapon reset')
  
  send_command('bind ^f8 gs c toggle AttCapped')
  send_command('bind ^` gs c cycle treasuremode')
  send_command('bind !` input /ja "Flee" <me>')
  send_command('bind @c gs c toggle CP')

  send_command('bind ^numpad0 input /ja "Sneak Attack" <me>')
  send_command('bind ^numpad. input /ja "Trick Attack" <me>')
  send_command('bind %e input /ra <t>')
end

-- Executes on first load, main job change, **and sub job change**
function user_setup()
  silibs.user_setup_hook()
  include('Global-Binds.lua') -- Additional local binds

  -- Subjob keybinds
  if player.sub_job == 'WAR' then
    send_command('bind !w input /ja "Defender" <me>')
    send_command('bind ^numpad/ input /ja "Berserk" <me>')
    send_command('bind ^numpad* input /ja "Warcry" <me>')
    send_command('bind ^numpad- input /ja "Aggressor" <me>')
  elseif player.sub_job == 'SAM' then
    send_command('bind !w input /ja "Third Eye" <me>')
    send_command('bind ^numpad/ input /ja "Meditate" <me>')
    send_command('bind ^numpad* input /ja "Sekkanoki" <me>')
    send_command('bind ^numpad- input /ja "Hasso" <me>')
  elseif player.sub_job == 'DNC' then
    send_command('bind ^- gs c cycleback mainstep')
    send_command('bind ^= gs c cycle mainstep')
    send_command('bind %numpad0 gs c step t')
    send_command('bind ^numlock input /ja "Reverse Flourish" <me>')
  elseif player.sub_job == 'NIN' then
    send_command('bind !numpad0 input /ma "Utsusemi: Ichi" <me>')
    send_command('bind !numpad. input /ma "Utsusemi: Ni" <me>')
  elseif player.sub_job == 'RUN' then
    send_command('bind %numpad0 input //gs c rune')
    send_command('bind ^- gs c cycleback Runes')
    send_command('bind ^= gs c cycle Runes')
  elseif player.sub_job == 'DRG' then
    send_command('bind !w input /ja "Ancient Circle" <me>')
    send_command('bind ^numpad/ input /ja "Jump" <t>')
    send_command('bind ^numpad* input /ja "High Jump" <t>')
    send_command('bind ^numpad- input /ja "Super Jump" <t>')
  end

  update_combat_form()
  determine_haste_group()

  select_default_macro_book()
end

-- Called when this job file is unloaded (eg: job change)
function job_file_unload()
  send_command('unbind !s')
  send_command('unbind !d')
  send_command('unbind @w')

  send_command('unbind ^insert')
  send_command('unbind ^delete')

  send_command('unbind ^pageup')
  send_command('unbind ^pagedown')
  send_command('unbind !pagedown')

  send_command('unbind ^`')
  send_command('unbind !`')
  send_command('unbind @c')

  send_command('unbind !w')
  send_command('unbind ^numlock')
  send_command('unbind ^numpad/')
  send_command('unbind ^numpad*')
  send_command('unbind ^numpad-')
  send_command('unbind ^numpad0')
  send_command('unbind ^numpad.')
  send_command('unbind %numpad0')

  send_command('unbind ^-')
  send_command('unbind ^=')
  send_command('unbind !numpad0')
  send_command('unbind !numpad.')
  send_command('unbind ^f8')
  send_command('unbind %e')
end


-- Define sets and vars used by this job file.
function init_gear_sets()

  ------------------------------------------------------------------------------------------------
  ---------------------------------------- Precast Sets ------------------------------------------
  ------------------------------------------------------------------------------------------------

  -- Set to use in normal TH situations
  sets.TreasureHunter = {
    -- ammo="Perfect Lucky Egg", --1
    -- hands="Plunderer's Armlets +3", --4
  }
  -- Set to use with TH enabled while performing ranged attacks
  sets.TreasureHunter.RA = {
    -- hands="Plunderer's Armlets +3", --4
    -- waist="Chaac Belt", --1
  }


  ------------------------------------------------------------------------------------------------
  ---------------------------------------- Precast Sets ------------------------------------------
  ------------------------------------------------------------------------------------------------

  -- Precast sets to enhance JAs
  sets.precast.JA['Collaborator'] = {
    -- head="Skulker's Bonnet +1",
  }
  sets.precast.JA['Accomplice'] = {
    -- head="Skulker's Bonnet +1",
  }
  sets.precast.JA['Flee'] = {
    -- feet="Pillager's Poulaines +3",
  }
  sets.precast.JA['Hide'] = {
    -- body="Pillager's Vest +3",
  }
  sets.precast.JA['Conspirator'] = {
    -- body="Skulker's Vest +1",
  }

  sets.precast.JA['Steal'] = {
    -- ammo="Barathrum", --3
    -- head="Asn. Bonnet +2",
    -- feet="Pillager's Poulaines +3",
  }

  sets.precast.JA['Despoil'] = {
    -- ammo="Barathrum",
    -- legs="Skulk. Culottes +1",
    -- feet="Skulk. Poulaines +1",
  }
  sets.precast.JA['Perfect Dodge'] = {
    -- hands="Plunderer's Armlets +3",
  }
  sets.precast.JA['Feint'] = {
    -- legs="Plunderer's Culottes +3",
  }

  sets.precast.Waltz = {
    -- ammo="Yamarang",
    -- body="Passion Jacket",
    -- legs="Dashing Subligar",
    -- waist="Gishdubar Sash",
  }

  sets.precast.Waltz['Healing Waltz'] = {}

  sets.precast.FC = {
    -- head="Herculean Helm", --7
    -- body=gear.Taeon_FC_body, --9
    -- hands=gear.Leyline_Gloves, --8
    -- legs=gear.Taeon_FC_legs, --5
    -- feet=gear.Taeon_FC_feet, --5
    -- neck="Orunmila's Torque", --5
    -- ear1="Loquac. Earring", --2
  }
  sets.precast.FC.Utsusemi = set_combine(sets.precast.FC, {
    -- ammo="Staunch Tathlum +1",
    -- body="Passion Jacket", --10
    -- neck="Magoraga Beads", --10
    -- ring1="Defending Ring",
  })

  sets.precast.FC.Trust = set_combine(sets.precast.FC, {
    -- ammo="Impatiens",
    -- ring1="Weatherspoon Ring", --5
    -- ring2="Prolix Ring",
  })


  ------------------------------------------------------------------------------------------------
  ------------------------------------- Weapon Skill Sets ----------------------------------------
  ------------------------------------------------------------------------------------------------

  -- Default WS set
  sets.precast.WS = {
    -- ammo="Coiste Bodhar",
    -- head=gear.Nyame_B_head,
    -- body=gear.Nyame_B_body,
    -- hands=gear.Nyame_B_hands,
    -- legs=gear.Nyame_B_legs,
    -- feet=gear.Nyame_B_feet,
    -- neck="Fotia Gorget",
    -- ear1="Ishvara Earring",
    -- ear2="Moonshade Earring",
    -- ring1="Regal Ring",
    -- ring2="Epaminondas's Ring",
    -- back=gear.THF_WS1_Cape,
    -- waist="Fotia Belt",
  }
  -- When Sneak Attack active, overlaid on top of normal set
  sets.precast.WS.SA = {
    -- ammo="Yetshila +1",
    -- head="Pillager's Bonnet +3",
  }
  sets.precast.WS.TA = {
    -- ammo="Yetshila +1",
    -- head="Pillager's Bonnet +3",
    -- hands="Pillager's Armlets +3",
  }

  -- 73-85% AGI
  sets.precast.WS['Exenterator'] = {
    -- ammo="Cath Palug Stone",
    -- head="Plunderer's Bonnet +3",
    -- body="Plunderer's Vest +3",
    -- hands="Meghanada Gloves +2",
    -- legs="Meghanada Chausses +2",
    -- feet="Plunderer's Poulaines +3",
    -- neck="Fotia Gorget",
    -- ear1="Sherida Earring",
    -- ear2="Telos Earring",
    -- ring1="Regal Ring",
    -- ring2="Ilabrat Ring",
    -- back=gear.THF_WS3_Cape,
    -- waist="Fotia Belt",
  }
  sets.precast.WS['Exenterator'].MaxTP = set_combine(sets.precast.WS['Exenterator'], {
  })
  sets.precast.WS['Exenterator'].AttCapped = {
    -- ammo="Cath Palug Stone",
    -- head="Plunderer's Bonnet +3",
    -- body="Gleti's Cuirass",
    -- hands="Malignance Gloves",
    -- legs="Malignance Tights",
    -- feet="Plunderer's Poulaines +3",
    -- neck="Fotia Gorget",
    -- ear1="Sherida Earring",
    -- ear2="Brutal Earring",
    -- ring1="Regal Ring",
    -- ring2="Ilabrat Ring",
    -- back=gear.THF_WS3_Cape,
    -- waist="Fotia Belt",
  }
  sets.precast.WS['Exenterator'].AttCappedMaxTP = set_combine(sets.precast.WS['Exenterator'].AttCapped, {
  })
  
  -- 50% DEX
  sets.precast.WS['Evisceration'] = {
    -- ammo="Yetshila +1",
    -- head=gear.Adhemar_B_head,
    -- body="Plunderer's Vest +3",
    -- hands=gear.Adhemar_B_hands,
    -- legs="Pillager's Culottes +3",
    -- feet=gear.Adhemar_B_feet,
    -- neck="Fotia Gorget",
    -- ear1="Moonshade Earring",
    -- ear2="Odr Earring",
    -- ring1="Ilabrat Ring",
    -- ring2="Regal Ring",
    -- back=gear.THF_WS4_Cape,
    -- waist="Fotia Belt",
  }
  sets.precast.WS['Evisceration'].MaxTP = set_combine(sets.precast.WS['Evisceration'], {
    -- ear1="Sherida Earring",
  })
  sets.precast.WS['Evisceration'].AttCapped = {
    -- ammo="Yetshila +1",
    -- head=gear.Adhemar_B_head,
    -- body="Gleti's Cuirass",
    -- hands=gear.Adhemar_B_hands,
    -- legs="Pillager's Culottes +3",
    -- feet=gear.Adhemar_B_feet,
    -- neck="Fotia Gorget",
    -- ear1="Moonshade Earring",
    -- ear2="Odr Earring",
    -- ring1="Ilabrat Ring",
    -- ring2="Regal Ring",
    -- back=gear.THF_WS4_Cape,
    -- waist="Fotia Belt",
  }
  sets.precast.WS['Evisceration'].AttCappedMaxTP = set_combine(sets.precast.WS['Evisceration'].AttCapped, {
    -- ear1="Sherida Earring",
  })

  -- 80% DEX
  sets.precast.WS["Rudra's Storm"] = {
    -- ammo="Aurgelmir Orb",               --  5, __,  7, __
    -- head="Plunderer's Bonnet +3",       -- 41, __, 62, __
    -- body="Plunderer's Vest +3",         -- 46, __, 65, __
    -- hands="Meghanada Gloves +2",        -- 50,  7, 43, __
    -- legs="Plunderer's Culottes +3"      -- 21,  6, 64, __
    -- feet="Plunderer's Poulaines +3",    -- 37, __, 61, __
    -- neck="Assassin's Gorget +2",        -- 15, __, __, __
    -- ear1="Odr Earring",                 -- 10, __, __, __
    -- ear2="Moonshade Earring",           -- __, __, __, __; TP Bonus+250
    -- ring1="Ilabrat Ring",               -- 10, __, 25, __
    -- ring2="Regal Ring",                 -- 10, __, 20, __
    -- back=gear.THF_WS1_Cape,             -- 30, 10, 20, __
    -- waist="Grunfeld Rope",              --  5, __, 20, __
    -- 280 DEX, 23 WSD, 387 Att, 0 PDL
  }
  sets.precast.WS["Rudra's Storm"].MaxTP = set_combine(sets.precast.WS["Rudra's Storm"], {
    -- ear2="Sherida Earring",
  })
  sets.precast.WS["Rudra's Storm"].AttCapped = {
    -- ammo="Cath Palug Stone",            -- 10, __, __, __
    -- head="Gleti's Mask",                -- 28, __, 60,  6
    -- body="Gleti's Cuirass",             -- 34, __, 64,  9
    -- hands="Meghanada Gloves +2",        -- 50,  7, 43, __
    -- legs=gear.Lustratio_B_legs,         -- 43, __, __, __
    -- feet=gear.Lustratio_D_feet,         -- 48, __, __, __
    -- neck="Assassin's Gorget +2",        -- 15, __, __, __
    -- ear1="Odr Earring",                 -- 10, __, __, __
    -- ear2="Moonshade Earring",           -- __, __, __, __; TP Bonus+250
    -- ring1="Epaminondas's Ring",         -- __,  5, __, __
    -- ring2="Regal Ring",                 -- 10, __, 20, __
    -- back=gear.THF_WS1_Cape,             -- 30, 10, 20, __
    -- waist="Kentarch Belt +1",           -- 10, __, __, __
    -- Lustratio set bonus                 -- __,  4, __, __
    -- 288 DEX, 26 WSD, 207 Att, 15 PDL
  }
  sets.precast.WS["Rudra's Storm"].AttCappedMaxTP = set_combine(sets.precast.WS["Rudra's Storm"].AttCapped, {
    -- ear2="Sherida Earring",
  })
  -- Is overlaid, don't set_combine
  sets.precast.WS["Rudra's Storm"].SA = {
    -- ammo="Yetshila +1",
    -- head="Pillager's Bonnet +3",
    -- feet=gear.Lustratio_D_feet,
  }
  sets.precast.WS["Rudra's Storm"].TA = {
    -- ammo="Yetshila +1",
    -- head="Pillager's Bonnet +3",
    -- hands="Pillager's Armlets +3",
    -- feet=gear.Lustratio_D_feet,
  }

  sets.precast.WS['Mandalic Stab'] = sets.precast.WS["Rudra's Storm"]
  sets.precast.WS['Mandalic Stab'].MaxTP = sets.precast.WS["Rudra's Storm"].MaxTP
  sets.precast.WS['Mandalic Stab'].AttCapped = sets.precast.WS["Rudra's Storm"].AttCapped
  sets.precast.WS['Mandalic Stab'].AttCappedMaxTP = sets.precast.WS["Rudra's Storm"].AttCappedMaxTP
  
  -- 40% DEX / 40% INT + MAB
  sets.precast.WS['Aeolian Edge'] = {
    -- ammo="Seething Bomblet +1", --7
    -- head=gear.Nyame_B_head, --30
    -- body=gear.Nyame_B_body, --30
    -- hands=gear.Nyame_B_hands, --30
    -- legs=gear.Nyame_B_legs, --30
    -- feet=gear.Herc_MAB_feet, --57
    -- neck="Baetyl Pendant", --13
    -- ear1="Friomisi Earring", --10
    -- ear2="Moonshade Earring",
    -- ring1="Epaminondas's Ring",
    -- ring2="Dingir Ring",
    -- back=gear.DNC_WS1_Cape,
    -- waist="Skrymir Cord +1",
  }
  sets.precast.WS['Aeolian Edge'].MaxTP = set_combine(sets.precast.WS['Aeolian Edge'], {
    -- ear2="Novio Earring", --7
  })
  sets.precast.WS['Aeolian Edge'].AttCapped = set_combine(sets.precast.WS['Aeolian Edge'], {
    -- ear2="Moonshade Earring",
  })
  sets.precast.WS['Aeolian Edge'].AttCappedMaxTP = set_combine(sets.precast.WS['Aeolian Edge'], {
    -- ear2="Novio Earring", --7
  })

  -- 50% STR / 50% MND
  sets.precast.WS['Savage Blade'] = {
    -- ammo="Seething Bomblet +1",   -- 15, __, 13, 13, __, __, ___
    -- head=gear.Nyame_B_head,       -- 26, 26, 60, 40, 10, __, ___
    -- body=gear.Nyame_B_body,       -- 35, 37, 60, 40, 12, __, ___
    -- hands=gear.Nyame_B_hands,     -- 17, 40, 60, 40, 10, __, ___
    -- legs=gear.Nyame_B_legs,       -- 43, 32, 60, 40, 11, __, ___
    -- feet=gear.Nyame_B_feet,       -- 23, 26, 60, 40, 10, __, ___
    -- neck="Fotia Gorget",          -- __, __, __, __, __, __, ___; fTP+0.1
    -- ear1="Ishvara Earring",       -- __, __, __, __,  2, __, ___
    -- ear2="Moonshade Earring",     -- __, __, __,  4, __, __, 250
    -- ring1="Sroda Ring",           -- 15, __, __, __, __,  3, ___
    -- ring2="Epaminondas's Ring",   -- __, __, __, __,  5, __, ___
    -- back=gear.THF_WS2_Cape,       -- 30, __, 20, 20, 10, __, ___
    -- waist="Sailfi Belt +1",       -- 15, __, 15, __, __, __, ___
    -- 219 STR, 161 MND, 348 Attack, 237 Accuracy, 70 WSD, 3 PDL, 250 TP Bonus
  } 
  sets.precast.WS['Savage Blade'].MaxTP = set_combine(sets.precast.WS['Savage Blade'], {
    -- ear2="Sherida Earring",       --  5, __, __, __, __, __, ___
  })
  sets.precast.WS['Savage Blade'].AttCapped = {
    -- ammo="Seething Bomblet +1",   -- 15, __, 13, 13, __, __, ___
    -- head=gear.Nyame_B_head,       -- 26, 26, 60, 40, 10, __, ___
    -- body=gear.Nyame_B_body,       -- 35, 37, 60, 40, 12, __, ___
    -- hands=gear.Nyame_B_hands,     -- 17, 40, 60, 40, 10, __, ___
    -- legs=gear.Nyame_B_legs,       -- 43, 32, 60, 40, 11, __, ___
    -- feet=gear.Nyame_B_feet,       -- 23, 26, 60, 40, 10, __, ___
    -- neck="Fotia Gorget",          -- __, __, __, __, __, __, ___; fTP+0.1
    -- ear1="Ishvara Earring",       -- __, __, __, __,  2, __, ___
    -- ear2="Moonshade Earring",     -- __, __, __,  4, __, __, 250
    -- ring1="Sroda Ring",           -- 15, __, __, __, __,  3, ___
    -- ring2="Epaminondas's Ring",   -- __, __, __, __,  5, __, ___
    -- back=gear.THF_WS2_Cape,       -- 30, __, 20, 20, 10, __, ___
    -- waist="Sailfi Belt +1",       -- 15, __, 15, __, __, __, ___
    -- 219 STR, 161 MND, 348 Attack, 237 Accuracy, 70 WSD, 3 PDL, 250 TP Bonus
  }
  sets.precast.WS['Savage Blade'].AttCappedMaxTP = set_combine(sets.precast.WS['Savage Blade'].AttCapped, {
    -- ear2="Sherida Earring",       --  5, __, __, __, __, __, ___
  })

  -- Asuran Fists: 15% STR / 15% VIT, 1.25 fTP, 8 hit, ftp replicating
  -- WSD > STR/VIT
  sets.precast.WS['Asuran Fists'] = {
    -- ammo="Seething Bomblet +1",
    -- head=gear.Nyame_B_head,
    -- body=gear.Nyame_B_body,
    -- hands=gear.Nyame_B_hands,
    -- legs=gear.Nyame_B_legs,
    -- feet=gear.Nyame_B_feet,
    -- neck="Fotia Gorget",
    -- ear1="Sherida Earring",
    -- ear2="Ishvara Earring",
    -- ring1="Regal Ring",
    -- ring2="Epaminondas's Ring",
    -- back=gear.THF_WS2_Cape,
    -- waist="Fotia Belt",
  }
  sets.precast.WS['Asuran Fists'].MaxTP = sets.precast.WS['Asuran Fists']
  sets.precast.WS['Asuran Fists'].AttCapped = set_combine(sets.precast.WS['Asuran Fists'], {
    -- ammo="Crepuscular Pebble",
  })
  sets.precast.WS['Asuran Fists'].AttCappedMaxTP = set_combine(sets.precast.WS['Asuran Fists'], {
    -- ammo="Crepuscular Pebble",
  })

  sets.precast.RA = {
    -- legs=gear.Adhemar_D_legs,       -- 10/13
    -- feet="Meg. Jam. +2",            -- 10/__
    -- ring1="Crepuscular Ring",       --  3/__
    -- waist="Yemaya Belt",            -- __/ 5
    -- 23 Snapshot / 18 Rapid Shot
  }


  ------------------------------------------------------------------------------------------------
  ---------------------------------------- Midcast Sets ------------------------------------------
  ------------------------------------------------------------------------------------------------

  sets.midcast.FastRecast = sets.precast.FC

  -- Initializes trusts at iLvl 119
  sets.midcast.Trust = {
    -- head=gear.Nyame_B_head,
    -- body=gear.Nyame_B_body,
    -- hands=gear.Nyame_B_hands,
    -- legs=gear.Nyame_B_legs,
    -- feet=gear.Nyame_B_feet,
  }

  sets.midcast.Utsusemi = {
    -- ammo="Impatiens", -- SIRD
    -- head=gear.Nyame_B_head, -- DT
    -- body=gear.Nyame_B_body, -- DT
    -- hands=gear.Nyame_B_hands, -- DT
    -- legs=gear.Nyame_B_legs, -- DT
    -- feet=gear.Nyame_B_feet, -- DT
    -- neck="Loricate Torque +1", -- SIRD + DT
    -- ring1="Defending Ring", -- DT
  }

  sets.midcast.RA = {
    -- head="Malignance Chapeau",
    -- body="Malignance Tabard",
    -- hands="Malignance Gloves",
    -- legs="Malignance Tights",
    -- feet="Malignance Boots",
    -- neck="Iskur Gorget",
    -- ear1="Telos Earring",
    -- ear2="Enervating Earring",
    -- ring1="Crepuscular Ring",
    -- ring2="Dingir Ring",
    -- back=gear.THF_TP_Cape,
    -- waist="Yemaya Belt",
  }


  ------------------------------------------------------------------------------------------------
  ---------------------------------------- Defense Sets ------------------------------------------
  ------------------------------------------------------------------------------------------------

  sets.LightDef = {
    -- ammo="Staunch Tathlum +1",  --  3/ 3, ___
    -- head="Malignance Chapeau",  --  6/ 6, 123
    -- body="Malignance Tabard",   --  9/ 9, 139 
    -- hands="Malignance Gloves",  --  5/ 5, 112
    -- legs="Malignance Tights",   --  7/ 7, 150
    -- feet="Malignance Boots",    --  4/ 4, 150
    -- back=gear.THF_TP_Cape,      -- 10/__, ___
    --44 PDT/34 MDT, 674 MEVA
  }

  sets.Evasion = {
    -- ammo="Yamarang",              -- __/__,  15,  15
    -- head="Malignance Chapeau",    --  6/ 6, 123,  91
    -- body="Malignance Tabard",     --  9/ 9, 139, 102
    -- hands="Malignance Gloves",    --  5/ 5, 112,  80
    -- legs="Malignance Tights",     --  7/ 7, 150,  85
    -- feet="Malignance Boots",      --  4/ 4, 150, 119
    -- neck="Assassin's Gorget +2",  -- __/__, ___,  25
    -- ear1="Eabani Earring",        -- __/__,   8,  15
    -- ear2="Infused Earring",       -- __/__, ___,  10
    -- ring1="Moonlight Ring",       --  5/ 5, ___, ___
    -- ring2="Moonlight Ring",       --  5/ 5, ___, ___
    -- waist="Kasiri Belt",          -- __/__, ___,  13
    -- Cape                             10/__, ___, ___
    -- 51 PDT / 41 MDT, 697 MEVA, 555 Evasion
  } 

  sets.HeavyDef = {
    -- ammo="Staunch Tathlum +1",  --  3/ 3, ___
    -- head="Malignance Chapeau",  --  6/ 6, 123
    -- body="Malignance Tabard",   --  9/ 9, 139 
    -- hands="Malignance Gloves",  --  5/ 5, 112
    -- legs="Malignance Tights",   --  7/ 7, 150
    -- feet="Malignance Boots",    --  4/ 4, 150
    -- ring2="Moonlight Ring",     --  5/ 5, ___
    -- Cape                        -- 10/__, ___
    --49 PDT/39 MDT, 674 MEVA
  }

  sets.defense.PDT = {
    -- ammo="Yamarang",            -- __/__,  15
    -- head="Malignance Chapeau",  --  6/ 6, 123
    -- body="Malignance Tabard",   --  9/ 9, 139
    -- hands="Malignance Gloves",  --  5/ 5, 112
    -- legs="Malignance Tights",   --  7/ 7, 150
    -- feet="Malignance Boots",    --  4/ 4, 150
    -- neck="Assassin's Gorget +2",-- __/__, ___
    -- ear1="Eabani Earring",      -- __/__,   8
    -- ear2="Odnowa Earring +1",   --  3/ 5, ___
    -- ring1="Moonlight Ring",     --  5/ 5, ___
    -- ring2="Moonlight Ring",     --  5/ 5, ___
    -- back=gear.THF_TP_Cape,      -- 10/__, ___
    -- waist="Engraved Belt",      -- __/__, ___
    --54 PDT/46 MDT, 697 MEVA
  }
  sets.defense.MDT = sets.defense.PDT


  ------------------------------------------------------------------------------------------------
  ----------------------------------------- Idle Sets --------------------------------------------
  ------------------------------------------------------------------------------------------------

  sets.latent_regain = {
    -- head="Turms Cap +1",
    -- body="Gleti's Cuirass",
    -- hands="Gleti's Gauntlets",
    -- legs="Gleti's Breeches",
    -- feet="Gleti's Boots",
  }
  sets.latent_regen = {
    -- head="Turms Cap +1",
    -- hands="Turms Mittens +1",
    -- feet="Turms Leggings +1",
    -- neck="Bathy Choker +1",
    -- ear1="Infused Earring",
    -- ring1="Chirich Ring +1",
  }
  sets.latent_refresh = {
    -- head=gear.Herc_Refresh_head,
    -- legs="Rawhide Trousers",
    -- feet=gear.Herc_Refresh_feet,
  }

  sets.resting = {}

  sets.idle = {
    -- ammo="Yamarang",            -- __/__,  15
    -- head="Turms Cap +1",        -- __/__, 109
    -- body="Gleti's Cuirass",     --  9/__, 102
    -- hands="Gleti's Gauntlets",  --  7/__, 75
    -- legs="Gleti's Breeches",    --  8/__, 112
    -- feet=gear.Nyame_B_feet,     --  7/ 7, 150
    -- neck="Loricate Torque +1",  --  6/ 6, ___
    -- ear1="Eabani Earring",      -- __/__,   8
    -- ear2="Odnowa Earring +1",   --  3/ 5, ___
    -- ring1="Moonlight Ring",     --  5/ 5, ___
    -- ring2="Defending Ring",     -- 10/10, ___
    -- back=gear.THF_TP_Cape,      -- 10/__, ___
    -- waist="Engraved Belt",      -- __/__, ___
  }

  sets.idle.Regain = set_combine(sets.idle, sets.latent_regain)
  sets.idle.Regen = set_combine(sets.idle, sets.latent_regen)
  sets.idle.Refresh = set_combine(sets.idle, sets.latent_refresh)
  sets.idle.Regain.Regen = set_combine(sets.idle, sets.latent_regain, sets.latent_regen)
  sets.idle.Regain.Refresh = set_combine(sets.idle, sets.latent_regain, sets.latent_refresh)
  sets.idle.Regen.Refresh = set_combine(sets.idle, sets.latent_regen, sets.latent_refresh)
  sets.idle.Regain.Regen.Refresh = set_combine(sets.idle, sets.latent_regain, sets.latent_regen, sets.latent_refresh)

  sets.idle.LightDef = set_combine(sets.idle, sets.LightDef)
  sets.idle.LightDef.Regain = set_combine(sets.idle.Regain, sets.LightDef)
  sets.idle.LightDef.Regen = set_combine(sets.idle.Regen, sets.LightDef)
  sets.idle.LightDef.Refresh = set_combine(sets.idle.Refresh, sets.LightDef)
  sets.idle.LightDef.Regain.Regen = set_combine(sets.idle.Regain.Regen, sets.LightDef)
  sets.idle.LightDef.Regain.Refresh = set_combine(sets.idle.Regain.Refresh, sets.LightDef)
  sets.idle.LightDef.Regen.Refresh = set_combine(sets.idle.Regen.Refresh, sets.LightDef)
  sets.idle.LightDef.Regain.Regen.Refresh = set_combine(sets.idle.Regain.Regen.Refresh, sets.LightDef)

  sets.idle.Evasion = set_combine(sets.idle, sets.Evasion)

  sets.idle.Weak = set_combine(sets.HeavyDef, {
    -- neck="Loricate Torque +1",  --  6/ 6, ___
    -- ring1="Gelatinous Ring +1", --  7/-1, ___
    -- ring2="Moonlight Ring",     --  5/ 5, ___
    -- back="Moonlight Cape",      --  6/ 6, ___
  })

  -- Gear to show off when in cities. Optional.
  sets.idle.Town = {
    -- ammo="Coiste Bodhar",
    -- head="Gleti's Mask",
    -- body=gear.Nyame_B_body,
    -- hands="Plunderer's Armlets +3",
    -- legs=gear.Samnuha_legs,
    -- feet="Gleti's Boots",
    -- neck="Assassin's Gorget +2",
    -- ear1="Telos Earring",
    -- ear2="Sherida Earring",
    -- ring1="Sroda Ring",
    -- ring2="Epaminondas's Ring",
    -- back="Moonlight Cape",
    -- waist="Reiki Yotai",
  }


  ------------------------------------------------------------------------------------------------
  ---------------------------------------- Engaged Sets ------------------------------------------
  ------------------------------------------------------------------------------------------------

  -- Variations for TP weapon and (optional) offense/defense modes.  Code will fall back on previous
  -- sets if more refined versions aren't defined.
  -- If you create a set with both offense and defense modes, the offense mode should be first.
  -- EG: sets.engaged.Dagger.Accuracy.Evasion

  sets.engaged = {
    -- ammo="Coiste Bodhar",
    -- head=gear.Adhemar_B_head,
    -- body="Pillager's Vest +3",
    -- hands=gear.Adhemar_B_hands,
    -- legs=gear.Samnuha_legs,
    -- feet="Plunderer's Poulaines +3",
    -- neck="Assassin's Gorget +2",
    -- ear1="Dedition Earring",
    -- ear2="Sherida Earring",
    -- ring1="Hetairoi Ring",
    -- ring2="Gere Ring",
    -- back=gear.THF_TP_Cape,
    -- waist="Windbuffet Belt +1",
  }
  sets.engaged.LowAcc = set_combine(sets.engaged, {
    -- ammo="Yamarang",
    -- ear1="Telos Earring",
  })
  sets.engaged.MidAcc = set_combine(sets.engaged.LowAcc, {
    -- legs="Malignance Tights",
  })
  sets.engaged.HighAcc = set_combine(sets.engaged.MidAcc, {
    -- hands="Pillager's Armlets +3",
    -- ring1="Regal Ring",
  })

  -- * THF Native DW Trait: 25% DW
  -- * THF Job Points DW Gift: 5% DW

  -- No Magic/Gear/JA Haste (74% DW to cap, 44% from gear)
  sets.engaged.DW = {
    -- ammo="Yamarang",
    -- head=gear.Adhemar_B_head,
    -- body=gear.Adhemar_A_body, -- 6
    -- hands="Pillager's Armlets +3", --5
    -- legs=gear.Samnuha_legs,
    -- feet=gear.Herc_DW_feet, --5
    -- neck="Assassin's Gorget +2",
    -- ear1="Suppanomimi", --5
    -- ear2="Eabani Earring", --4
    -- ring1="Hetairoi Ring",
    -- ring2="Gere Ring",
    -- back=gear.THF_DW_Cape, --10
    -- waist="Reiki Yotai", --7
  }--46
  sets.engaged.DW.LowAcc = set_combine(sets.engaged.DW, {
    -- ammo="Yamarang",
  })
  sets.engaged.DW.MidAcc = set_combine(sets.engaged.DW.LowAcc, {
    -- legs="Malignance Tights",
  })
  sets.engaged.DW.HighAcc = set_combine(sets.engaged.DW.MidAcc, {
    -- ear1="Telos Earring",
    -- ring1="Regal Ring",
  })

  -- Low Magic/Gear/JA Haste (67% DW to cap, 37% from gear)
  sets.engaged.DW.LowHaste = {
    -- ammo="Coiste Bodhar",
    -- head=gear.Adhemar_B_head,
    -- body=gear.Adhemar_A_body, --6
    -- hands="Pillager's Armlets +3", --5
    -- legs=gear.Samnuha_legs,
    -- feet="Plunderer's Poulaines +3",
    -- neck="Assassin's Gorget +2",
    -- ear1="Suppanomimi", --5
    -- ear2="Eabani Earring", --4
    -- ring1="Hetairoi Ring",
    -- ring2="Gere Ring",
    -- back=gear.THF_DW_Cape, --10
    -- waist="Reiki Yotai", --7
  }--37
  sets.engaged.DW.LowAcc.LowHaste = set_combine(sets.engaged.DW.LowHaste, {
    -- ammo="Yamarang",
  })
  sets.engaged.DW.MidAcc.LowHaste = set_combine(sets.engaged.DW.LowAcc.LowHaste, {
    -- legs="Malignance Tights",
  })
  sets.engaged.DW.HighAcc.LowHaste = set_combine(sets.engaged.DW.MidAcc.LowHaste, {
    -- ring1="Regal Ring",
  })

  -- Mid Magic/Gear/JA Haste (56% DW to cap, 26% from gear)
  sets.engaged.DW.MidHaste = {
    -- ammo="Coiste Bodhar",
    -- head=gear.Adhemar_B_head,
    -- body="Pillager's Vest +3",
    -- hands=gear.Adhemar_B_hands,
    -- legs=gear.Samnuha_legs,
    -- feet="Plunderer's Poulaines +3",
    -- neck="Assassin's Gorget +2",
    -- ear1="Suppanomimi", --5
    -- ear2="Eabani Earring", --4
    -- ring1="Hetairoi Ring",
    -- ring2="Gere Ring",
    -- back=gear.THF_DW_Cape, --10
    -- waist="Reiki Yotai", --7
  }--26
  sets.engaged.DW.LowAcc.MidHaste = set_combine(sets.engaged.DW.MidHaste, {
    -- ammo="Yamarang",
  })
  sets.engaged.DW.MidAcc.MidHaste = set_combine(sets.engaged.DW.LowAcc.MidHaste, {
    -- legs="Malignance Tights",
  })
  sets.engaged.DW.HighAcc.MidHaste = set_combine(sets.engaged.DW.MidAcc.MidHaste, {
    -- hands="Pillager's Armlets +3", --5
    -- ear1="Telos Earring",
    -- ring1="Regal Ring",
  })

  -- High Magic/Gear/JA Haste (43% DW to cap, 13% from gear)
  sets.engaged.DW.HighHaste = {
    -- ammo="Coiste Bodhar",
    -- head=gear.Adhemar_B_head,
    -- body="Pillager's Vest +3",
    -- hands=gear.Adhemar_B_hands,
    -- legs=gear.Samnuha_legs,
    -- feet="Plunderer's Poulaines +3",
    -- neck="Assassin's Gorget +2",
    -- ear1="Suppanomimi", --5
    -- ear2="Sherida Earring",
    -- ring1="Hetairoi Ring",
    -- ring2="Gere Ring",
    -- back=gear.THF_TP_Cape,
    -- waist="Reiki Yotai", --7
  }--12
  sets.engaged.DW.LowAcc.HighHaste = set_combine(sets.engaged.DW.HighHaste, {
    -- ammo="Yamarang",
  })
  sets.engaged.DW.MidAcc.HighHaste = set_combine(sets.engaged.DW.LowAcc.HighHaste, {
    -- legs="Malignance Tights",
  })
  sets.engaged.DW.HighAcc.HighHaste = set_combine(sets.engaged.DW.MidAcc.HighHaste, {
    -- hands="Pillager's Armlets +3", --5
    -- ear1="Telos Earring",
    -- ring1="Regal Ring",
  })

  -- High Magic/Gear/JA Haste (36% DW to cap, 6% from gear)
  sets.engaged.DW.SuperHaste = {
    -- ammo="Coiste Bodhar",
    -- head=gear.Adhemar_B_head,
    -- body="Pillager's Vest +3",
    -- hands=gear.Adhemar_B_hands,
    -- legs=gear.Samnuha_legs,
    -- feet="Plunderer's Poulaines +3",
    -- neck="Assassin's Gorget +2",
    -- ear1="Dedition Earring",
    -- ear2="Sherida Earring",
    -- ring1="Hetairoi Ring",
    -- ring2="Gere Ring",
    -- back=gear.THF_TP_Cape,
    -- waist="Reiki Yotai", --7
  }--7
  sets.engaged.DW.LowAcc.SuperHaste = set_combine(sets.engaged.DW.SuperHaste, {
    -- ammo="Yamarang",
    -- ear1="Telos Earring",
  })
  sets.engaged.DW.MidAcc.SuperHaste = set_combine(sets.engaged.DW.LowAcc.SuperHaste, {
    -- legs="Malignance Tights",
  })
  sets.engaged.DW.HighAcc.SuperHaste = set_combine(sets.engaged.DW.MidAcc.SuperHaste, {
    -- legs="Pillager's Culottes +3",
    -- ring1="Regal Ring",
  })

  -- Max Magic/Gear/JA Haste (0-30% DW to cap, 0% from gear)
  sets.engaged.DW.MaxHaste = {
    -- ammo="Coiste Bodhar",
    -- head=gear.Adhemar_B_head,
    -- body="Pillager's Vest +3",
    -- hands=gear.Adhemar_B_hands,
    -- legs=gear.Samnuha_legs,
    -- feet="Plunderer's Poulaines +3",
    -- neck="Assassin's Gorget +2",
    -- ear1="Dedition Earring",
    -- ear2="Sherida Earring",
    -- ring1="Hetairoi Ring",
    -- ring2="Gere Ring",
    -- back=gear.THF_TP_Cape,
    -- waist="Windbuffet Belt +1",
  }
  sets.engaged.DW.LowAcc.MaxHaste = set_combine(sets.engaged.DW.MaxHaste, {
    -- ammo="Yamarang",
    -- ear1="Telos Earring",
  })
  sets.engaged.DW.MidAcc.MaxHaste = set_combine(sets.engaged.DW.LowAcc.MaxHaste, {
    -- legs="Malignance Tights",
  })
  sets.engaged.DW.HighAcc.MaxHaste = set_combine(sets.engaged.DW.MidAcc.MaxHaste, {
    -- legs="Pillager's Culottes +3",
    -- ring1="Regal Ring",
  })


  ------------------------------------------------------------------------------------------------
  ---------------------------------------- Hybrid Sets -------------------------------------------
  ------------------------------------------------------------------------------------------------

  -- Heavy Def Hybrid
  -- No DW
  sets.engaged.LightDef = set_combine(sets.engaged, {
    -- ammo="Staunch Tathlum +1",  --  3/ 3, ___
    -- head="Malignance Chapeau",  --  6/ 6, 123
    -- hands="Malignance Gloves",  --  5/ 5, 112
    -- legs="Malignance Tights",   --  7/ 7, 150
    -- ring1="Moonlight Ring",     --  5/ 5, ___
    -- back=gear.THF_TP_Cape,      -- 10/__, ___
  })-- 36/26
  sets.engaged.LowAcc.LightDef = set_combine(sets.engaged.LowAcc, {
    -- ammo="Staunch Tathlum +1",  --  3/ 3, ___
    -- head="Malignance Chapeau",  --  6/ 6, 123
    -- hands="Malignance Gloves",  --  5/ 5, 112
    -- legs="Malignance Tights",   --  7/ 7, 150
    -- ring1="Moonlight Ring",     --  5/ 5, ___
    -- back=gear.THF_TP_Cape,      -- 10/__, ___
  })-- 36/26
  sets.engaged.MidAcc.LightDef = set_combine(sets.engaged.MidAcc, {
    -- ammo="Staunch Tathlum +1",  --  3/ 3, ___
    -- head="Malignance Chapeau",  --  6/ 6, 123
    -- hands="Malignance Gloves",  --  5/ 5, 112
    -- legs="Malignance Tights",   --  7/ 7, 150
    -- ring1="Moonlight Ring",     --  5/ 5, ___
    -- back=gear.THF_TP_Cape,      -- 10/__, ___
  })-- 36/26
  sets.engaged.HighAcc.LightDef = set_combine(sets.engaged.HighAcc, {
    -- ammo="Staunch Tathlum +1",  --  3/ 3, ___
    -- head="Malignance Chapeau",  --  6/ 6, 123
    -- legs="Malignance Tights",   --  7/ 7, 150
    -- ring2="Defending Ring",     -- 10/10, ___
    -- back=gear.THF_TP_Cape,      -- 10/__, ___
  })-- 36/26

  -- No Magic/Gear/JA Haste (74% DW to cap, 44% from gear)
  sets.engaged.DW.LightDef = set_combine(sets.engaged.DW, {
    -- ammo="Staunch Tathlum +1",  --  3/ 3, ___
    -- head="Malignance Chapeau",  --  6/ 6, 123
    -- legs="Malignance Tights",   --  7/ 7, 150
    -- ring1="Moonlight Ring",     --  5/ 5, ___
    -- ring2="Moonlight Ring",     --  5/ 5, ___
    -- back=gear.THF_DW_Cape,      -- 10/__, ___
  })-- 36/26
  sets.engaged.DW.LowAcc.LightDef = set_combine(sets.engaged.DW.LowAcc, {
    -- ammo="Staunch Tathlum +1",  --  3/ 3, ___
    -- head="Malignance Chapeau",  --  6/ 6, 123
    -- legs="Malignance Tights",   --  7/ 7, 150
    -- ring1="Moonlight Ring",     --  5/ 5, ___
    -- ring2="Moonlight Ring",     --  5/ 5, ___
    -- back=gear.THF_DW_Cape,      -- 10/__, ___
  })-- 36/26
  sets.engaged.DW.MidAcc.LightDef = set_combine(sets.engaged.DW.MidAcc, {
    -- ammo="Staunch Tathlum +1",  --  3/ 3, ___
    -- head="Malignance Chapeau",  --  6/ 6, 123
    -- legs="Malignance Tights",   --  7/ 7, 150
    -- ring1="Moonlight Ring",     --  5/ 5, ___
    -- ring2="Moonlight Ring",     --  5/ 5, ___
    -- back=gear.THF_DW_Cape,      -- 10/__, ___
  })-- 36/26
  sets.engaged.DW.HighAcc.LightDef = set_combine(sets.engaged.DW.HighAcc, {
    -- ammo="Staunch Tathlum +1",  --  3/ 3, ___
    -- head="Malignance Chapeau",  --  6/ 6, 123
    -- legs="Malignance Tights",   --  7/ 7, 150
    -- ring2="Defending Ring",     -- 10/10, ___
    -- back=gear.THF_DW_Cape,      -- 10/__, ___
  })-- 36/26

  -- Low Magic/Gear/JA Haste (67% DW to cap, 37% from gear)
  sets.engaged.DW.LightDef.LowHaste = set_combine(sets.engaged.DW.LowHaste, {
    -- ammo="Staunch Tathlum +1",  --  3/ 3, ___
    -- head="Malignance Chapeau",  --  6/ 6, 123
    -- legs="Malignance Tights",   --  7/ 7, 150
    -- ring1="Defending Ring",     -- 10/10, ___
    -- back=gear.THF_DW_Cape,      -- 10/__, ___
  })-- 36/26
  sets.engaged.DW.LowAcc.LightDef.LowHaste = set_combine(sets.engaged.DW.LowAcc.LowHaste, {
    -- ammo="Staunch Tathlum +1",  --  3/ 3, ___
    -- head="Malignance Chapeau",  --  6/ 6, 123
    -- legs="Malignance Tights",   --  7/ 7, 150
    -- ring1="Defending Ring",     -- 10/10, ___
    -- back=gear.THF_DW_Cape,      -- 10/__, ___
  })-- 36/26
  sets.engaged.DW.MidAcc.LightDef.LowHaste = set_combine(sets.engaged.DW.MidAcc.LowHaste, {
    -- ammo="Staunch Tathlum +1",  --  3/ 3, ___
    -- head="Malignance Chapeau",  --  6/ 6, 123
    -- legs="Malignance Tights",   --  7/ 7, 150
    -- ring1="Defending Ring",     -- 10/10, ___
    -- back=gear.THF_DW_Cape,      -- 10/__, ___
  })-- 36/26
  sets.engaged.DW.HighAcc.LightDef.LowHaste = set_combine(sets.engaged.DW.HighAcc.LowHaste, {
    -- ammo="Staunch Tathlum +1",  --  3/ 3, ___
    -- head="Malignance Chapeau",  --  6/ 6, 123
    -- legs="Malignance Tights",   --  7/ 7, 150
    -- ring2="Defending Ring",     -- 10/10, ___
    -- back=gear.THF_DW_Cape,      -- 10/__, ___
  })-- 36/26

  -- Mid Magic/Gear/JA Haste (56% DW to cap, 26% from gear)
  sets.engaged.DW.LightDef.MidHaste = set_combine(sets.engaged.DW.MidHaste, {
    -- ammo="Staunch Tathlum +1",  --  3/ 3, ___
    -- head="Malignance Chapeau",  --  6/ 6, 123
    -- hands="Malignance Gloves",  --  5/ 5, 112
    -- legs="Malignance Tights",   --  7/ 7, 150
    -- ring1="Moonlight Ring",     --  5/ 5, ___
    -- back=gear.THF_DW_Cape,      -- 10/__, ___
  })-- 36/26
  sets.engaged.DW.LowAcc.LightDef.MidHaste = set_combine(sets.engaged.DW.LowAcc.MidHaste, {
    -- ammo="Staunch Tathlum +1",  --  3/ 3, ___
    -- head="Malignance Chapeau",  --  6/ 6, 123
    -- hands="Malignance Gloves",  --  5/ 5, 112
    -- legs="Malignance Tights",   --  7/ 7, 150
    -- ring1="Moonlight Ring",     --  5/ 5, ___
    -- back=gear.THF_DW_Cape,      -- 10/__, ___
  })-- 36/26
  sets.engaged.DW.MidAcc.LightDef.MidHaste = set_combine(sets.engaged.DW.MidAcc.MidHaste, {
    -- ammo="Staunch Tathlum +1",  --  3/ 3, ___
    -- head="Malignance Chapeau",  --  6/ 6, 123
    -- hands="Malignance Gloves",  --  5/ 5, 112
    -- legs="Malignance Tights",   --  7/ 7, 150
    -- ring1="Moonlight Ring",     --  5/ 5, ___
    -- back=gear.THF_DW_Cape,      -- 10/__, ___
  })-- 36/26
  sets.engaged.DW.HighAcc.LightDef.MidHaste = set_combine(sets.engaged.DW.HighAcc.MidHaste, {
    -- ammo="Staunch Tathlum +1",  --  3/ 3, ___
    -- head="Malignance Chapeau",  --  6/ 6, 123
    -- legs="Malignance Tights",   --  7/ 7, 150
    -- ring2="Defending Ring",     -- 10/10, ___
    -- back=gear.THF_DW_Cape,      -- 10/__, ___
  })-- 36/26

  -- High Magic/Gear/JA Haste (43% DW to cap, 13% from gear)
  sets.engaged.DW.LightDef.HighHaste = set_combine(sets.engaged.DW.HighHaste, {
    -- ammo="Staunch Tathlum +1",  --  3/ 3, ___
    -- head="Malignance Chapeau",  --  6/ 6, 123
    -- hands="Malignance Gloves",  --  5/ 5, 112
    -- legs="Malignance Tights",   --  7/ 7, 150
    -- ring1="Moonlight Ring",     --  5/ 5, ___
    -- back=gear.THF_TP_Cape,      -- 10/__, ___
  })-- 36/26
  sets.engaged.DW.LowAcc.LightDef.HighHaste = set_combine(sets.engaged.DW.LowAcc.HighHaste, {
    -- ammo="Staunch Tathlum +1",  --  3/ 3, ___
    -- head="Malignance Chapeau",  --  6/ 6, 123
    -- hands="Malignance Gloves",  --  5/ 5, 112
    -- legs="Malignance Tights",   --  7/ 7, 150
    -- ring1="Moonlight Ring",     --  5/ 5, ___
    -- back=gear.THF_TP_Cape,      -- 10/__, ___
  })-- 36/26
  sets.engaged.DW.MidAcc.LightDef.HighHaste = set_combine(sets.engaged.DW.MidAcc.HighHaste, {
    -- ammo="Staunch Tathlum +1",  --  3/ 3, ___
    -- head="Malignance Chapeau",  --  6/ 6, 123
    -- hands="Malignance Gloves",  --  5/ 5, 112
    -- legs="Malignance Tights",   --  7/ 7, 150
    -- ring1="Moonlight Ring",     --  5/ 5, ___
    -- back=gear.THF_TP_Cape,      -- 10/__, ___
  })-- 36/26
  sets.engaged.DW.HighAcc.LightDef.HighHaste = set_combine(sets.engaged.DW.HighAcc.HighHaste, {
    -- ammo="Staunch Tathlum +1",  --  3/ 3, ___
    -- head="Malignance Chapeau",  --  6/ 6, 123
    -- legs="Malignance Tights",   --  7/ 7, 150
    -- ring2="Defending Ring",     -- 10/10, ___
    -- back=gear.THF_TP_Cape,      -- 10/__, ___
  })-- 36/26

  -- Max Magic/Gear/JA Haste (0-30% DW to cap, 0% from gear)
  sets.engaged.DW.LightDef.MaxHaste = set_combine(sets.engaged.DW.MaxHaste, {
    -- ammo="Staunch Tathlum +1",  --  3/ 3, ___
    -- head="Malignance Chapeau",  --  6/ 6, 123
    -- hands="Malignance Gloves",  --  5/ 5, 112
    -- legs="Malignance Tights",   --  7/ 7, 150
    -- ring1="Moonlight Ring",     --  5/ 5, ___
    -- back=gear.THF_TP_Cape,      -- 10/__, ___
  })-- 36/26
  sets.engaged.DW.LowAcc.LightDef.MaxHaste = set_combine(sets.engaged.DW.LowAcc.MaxHaste, {
    -- ammo="Staunch Tathlum +1",  --  3/ 3, ___
    -- head="Malignance Chapeau",  --  6/ 6, 123
    -- hands="Malignance Gloves",  --  5/ 5, 112
    -- legs="Malignance Tights",   --  7/ 7, 150
    -- ring1="Moonlight Ring",     --  5/ 5, ___
    -- back=gear.THF_TP_Cape,      -- 10/__, ___
  })-- 36/26
  sets.engaged.DW.MidAcc.LightDef.MaxHaste = set_combine(sets.engaged.DW.MidAcc.MaxHaste, {
    -- ammo="Staunch Tathlum +1",  --  3/ 3, ___
    -- head="Malignance Chapeau",  --  6/ 6, 123
    -- hands="Malignance Gloves",  --  5/ 5, 112
    -- legs="Malignance Tights",   --  7/ 7, 150
    -- ring1="Moonlight Ring",     --  5/ 5, ___
    -- back=gear.THF_TP_Cape,      -- 10/__, ___
  })-- 36/26
  sets.engaged.DW.HighAcc.LightDef.MaxHaste = set_combine(sets.engaged.DW.HighAcc.MaxHaste, {
    -- ammo="Staunch Tathlum +1",  --  3/ 3, ___
    -- head="Malignance Chapeau",  --  6/ 6, 123
    -- legs="Malignance Tights",   --  7/ 7, 150
    -- ring2="Defending Ring",     -- 10/10, ___
    -- back=gear.THF_TP_Cape,      -- 10/__, ___
  })-- 36/26


  -- Heavy Def Hybrid
  sets.engaged.HeavyDef = set_combine(sets.engaged, sets.HeavyDef)
  sets.engaged.LowAcc.HeavyDef = set_combine(sets.engaged.LowAcc, sets.HeavyDef)
  sets.engaged.MidAcc.HeavyDef = set_combine(sets.engaged.MidAcc, sets.HeavyDef)
  sets.engaged.HighAcc.HeavyDef = set_combine(sets.engaged.HighAcc, sets.HeavyDef)

  sets.engaged.DW.HeavyDef = set_combine(sets.engaged.DW, sets.HeavyDef)
  sets.engaged.DW.LowAcc.HeavyDef = set_combine(sets.engaged.DW.LowAcc, sets.HeavyDef)
  sets.engaged.DW.MidAcc.HeavyDef = set_combine(sets.engaged.DW.MidAcc, sets.HeavyDef)
  sets.engaged.DW.HighAcc.HeavyDef = set_combine(sets.engaged.DW.HighAcc, sets.HeavyDef)

  sets.engaged.DW.HeavyDef.LowHaste = set_combine(sets.engaged.DW.LowHaste, sets.HeavyDef)
  sets.engaged.DW.LowAcc.HeavyDef.LowHaste = set_combine(sets.engaged.DW.LowAcc.LowHaste, sets.HeavyDef)
  sets.engaged.DW.MidAcc.HeavyDef.LowHaste = set_combine(sets.engaged.DW.MidAcc.LowHaste, sets.HeavyDef)
  sets.engaged.DW.HighAcc.HeavyDef.LowHaste = set_combine(sets.engaged.DW.HighAcc.LowHaste, sets.HeavyDef)

  sets.engaged.DW.HeavyDef.MidHaste = set_combine(sets.engaged.DW.MidHaste, sets.HeavyDef)
  sets.engaged.DW.LowAcc.HeavyDef.MidHaste = set_combine(sets.engaged.DW.LowAcc.MidHaste, sets.HeavyDef)
  sets.engaged.DW.MidAcc.HeavyDef.MidHaste = set_combine(sets.engaged.DW.MidAcc.MidHaste, sets.HeavyDef)
  sets.engaged.DW.HighAcc.HeavyDef.MidHaste = set_combine(sets.engaged.DW.HighAcc.MidHaste, sets.HeavyDef)

  sets.engaged.DW.HeavyDef.HighHaste = set_combine(sets.engaged.DW.HighHaste, sets.HeavyDef)
  sets.engaged.DW.LowAcc.HeavyDef.HighHaste = set_combine(sets.engaged.DW.LowAcc.HighHaste, sets.HeavyDef)
  sets.engaged.DW.MidAcc.HeavyDef.HighHaste = set_combine(sets.engaged.DW.MidAcc.HighHaste, sets.HeavyDef)
  sets.engaged.DW.HighAcc.HeavyDef.HighHaste = set_combine(sets.engaged.DW.HighAcc.HighHaste, sets.HeavyDef)

  sets.engaged.DW.HeavyDef.MaxHaste = set_combine(sets.engaged.DW.MaxHaste, sets.HeavyDef)
  sets.engaged.DW.LowAcc.HeavyDef.MaxHaste = set_combine(sets.engaged.DW.LowAcc.MaxHaste, sets.HeavyDef)
  sets.engaged.DW.MidAcc.HeavyDef.MaxHaste = set_combine(sets.engaged.DW.MidAcc.MaxHaste, sets.HeavyDef)
  sets.engaged.DW.HighAcc.HeavyDef.MaxHaste = set_combine(sets.engaged.DW.HighAcc.MaxHaste, sets.HeavyDef)

  -- Evasion Hybrid
  sets.engaged.Evasion = set_combine(sets.Evasion, { back=gear.THF_TP_Cape })
  sets.engaged.LowAcc.Evasion = set_combine(sets.Evasion, { back=gear.THF_TP_Cape })
  sets.engaged.MidAcc.Evasion = set_combine(sets.Evasion, { back=gear.THF_TP_Cape })
  sets.engaged.HighAcc.Evasion = set_combine(sets.Evasion, { back=gear.THF_TP_Cape })

  sets.engaged.DW.Evasion = set_combine(sets.Evasion, { back=gear.THF_DW_Cape })
  sets.engaged.DW.LowAcc.Evasion = set_combine(sets.Evasion, { back=gear.THF_DW_Cape })
  sets.engaged.DW.MidAcc.Evasion = set_combine(sets.Evasion, { back=gear.THF_DW_Cape })
  sets.engaged.DW.HighAcc.Evasion = set_combine(sets.Evasion, { back=gear.THF_DW_Cape })

  sets.engaged.DW.MaxHaste.Evasion = set_combine(sets.Evasion, { back=gear.THF_TP_Cape })
  sets.engaged.DW.LowAcc.MaxHaste.Evasion = set_combine(sets.Evasion, { back=gear.THF_TP_Cape })
  sets.engaged.DW.MidAcc.MaxHaste.Evasion = set_combine(sets.Evasion, { back=gear.THF_TP_Cape })
  sets.engaged.DW.HighAcc.MaxHaste.Evasion = set_combine(sets.Evasion, { back=gear.THF_TP_Cape })


  ------------------------------------------------------------------------------------------------
  ---------------------------------------- Special Sets ------------------------------------------
  ------------------------------------------------------------------------------------------------

  sets.Special = {}
  sets.Special.ElementalObi = {
    -- waist="Hachirin-no-Obi",
  }
  sets.Special.SleepyHead = {
    -- head="Frenzy Sallet",
  }

  sets.buff.Doom = {
    -- neck="Nicander's Necklace", --20
    -- ring2="Eshmun's Ring", --20
    -- waist="Gishdubar Sash", --10
  }

  sets.Kiting = {
    -- feet="Pillager's Poulaines +3",
  }
  sets.Kiting.Adoulin = {
    -- body="Councilor's Garb",
  }
  sets.CP = {
    -- back=gear.CP_Cape,
  }
  sets.Reive = {
    -- neck="Ygnas's Resolve +1"
  }

  sets.WeaponSet = {}
  sets.WeaponSet['WhiteGlass'] = {
    -- main="Twashtar",
    -- sub={name="Centovente", priority=1},
  }
  sets.WeaponSet['Normal'] = {
    -- main="Twashtar",
    -- sub="Gleti's Knife",
  }
  sets.WeaponSet['LowAtt'] = {
    -- main="Vajra",
    -- sub="Centovente",
  }
  sets.WeaponSet['Naegling'] = {
    -- main="Naegling",
    -- sub="Centovente",
  }
  sets.WeaponSet['NaeglingAcc'] = {
    -- main="Naegling",
    -- sub="Ternion Dagger +1",
  }
  sets.WeaponSet['H2H'] = {
    -- main="Karambit",
    -- sub=empty,
  }
  sets.WeaponSet['SoloCleaving'] = {
  --   main=gear.Gandring_C,
  --   sub="Tauret",
  }
  sets.WeaponSet['Cleaving'] = {
    -- main="Tauret",
    -- sub="Twashtar",
  }
  sets.WeaponSet['Staff'] = {
    -- main="Gozuki Mezuki",
    -- sub="empty",
  }

  -- Ranged weapon sets
  sets.WeaponSet['Archery'] = {
    -- ranged="Ullr",
    -- ammo="Eminent Arrow",
  }
  sets.WeaponSet['Throwing'] = {
    -- ranged="Antitail +1",
    -- ammo=empty,
  }
end


-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

function job_precast(spell, action, spellMap, eventArgs)
  silibs.precast_hook(spell, action, spellMap, eventArgs)
  ----------- Non-silibs content goes below this line -----------
end

-- Run after the general precast() is done.
function job_post_precast(spell, action, spellMap, eventArgs)
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
  if spell.type == 'WeaponSkill' then
    if state.Buff['Sneak Attack'] then
    -- If set isn't found for specific ws, overlay the default set
      local set = (sets.precast.WS[spell.name] and sets.precast.WS[spell.name].SA) or sets.precast.WS.SA or {}
      equip(set)
    end
    if state.Buff['Trick Attack'] then
    -- If set isn't found for specific ws, overlay the default set
      local set = (sets.precast.WS[spell.name] and sets.precast.WS[spell.name].TA) or sets.precast.WS.TA or {}
      equip(set)
    end
    -- Handle belts for elemental WS
    if elemental_ws:contains(spell.english) then
      local base_day_weather_mult = silibs.get_day_weather_multiplier(spell.element, false, false)
      local obi_mult = silibs.get_day_weather_multiplier(spell.element, true, false)
      local orpheus_mult = silibs.get_orpheus_multiplier(spell.element, spell.target.distance)
      local has_obi = true -- Change if you do or don't have Hachirin-no-Obi
      local has_orpheus = false -- Change if you do or don't have Orpheus's Sash
  
      -- Determine which combination to use: orpheus, hachirin-no-obi, or neither
      if has_obi and (obi_mult >= orpheus_mult or not has_orpheus) and (obi_mult > base_day_weather_mult) then
        -- Obi is better than orpheus and better than nothing
        equip({waist="Hachirin-no-Obi"})
      elseif has_orpheus and (orpheus_mult > base_day_weather_mult) then
        -- Orpheus is better than obi and better than nothing
        equip({waist="Orpheus's Sash"})
      end
    end
    if buffactive['Reive Mark'] then
      equip(sets.Reive)
    end
  end

  -- Keep ranged weapon/ammo equipped if in an RA mode.
  if state.RangedWeaponSet.current ~= 'None' then
    equip({range=player.equipment.range, ammo=player.equipment.ammo})
    silibs.equip_ammo(spell)
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

function job_post_midcast(spell, action, spellMap, eventArgs)
  -- Keep ranged weapon/ammo equipped if in an RA mode.
  if state.RangedWeaponSet.current ~= 'None' then
    equip({range=player.equipment.range, ammo=player.equipment.ammo})
    silibs.equip_ammo(spell)
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

-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
function job_aftercast(spell, action, spellMap, eventArgs)
  silibs.aftercast_hook(spell, action, spellMap, eventArgs)
  ----------- Non-silibs content goes below this line -----------

  -- Weaponskills wipe SATA/Feint.  Turn those state vars off before default gearing is attempted.
  if spell.type == 'WeaponSkill' and not spell.interrupted then
    state.Buff['Sneak Attack'] = false
    state.Buff['Trick Attack'] = false
    state.Buff['Feint'] = false
  end
end

-- Called after the default aftercast handling is complete.
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

  -- Update gear for these specific buffs
  if buff == "Sneak Attack" or buff == "Trick Attack" or buff == "doom" then
    status_change(player.status)
  end

end

-- Handle notifications of general user state change.
function job_state_change(stateField, newValue, oldValue)
end


-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------

-- Called by the 'update' self-command, for common needs.
-- Set eventArgs.handled to true if we don't want automatic equipping of gear.
function job_handle_equipping_gear(playerStatus, eventArgs)
  check_gear()
  update_idle_groups()
  update_combat_form()
  determine_haste_group()

  -- Check for SATA when equipping gear.  If either is active, equip
  -- that gear specifically, and block equipping default gear.
  check_buff('Sneak Attack', eventArgs)
  check_buff('Trick Attack', eventArgs)
end

function job_update(cmdParams, eventArgs)
  handle_equipping_gear(player.status)
  update_dp_type() -- Requires DistancePlus addon
end

function update_combat_form()
  if DW == true then
    state.CombatForm:set('DW')
  elseif DW == false then
    state.CombatForm:reset()
  end
end

function get_custom_wsmode(spell, action, spellMap)
  local wsmode = ''

  -- Determine if attack capped
  if state.AttCapped.value then
    wsmode = 'AttCapped'
  end

  -- Calculate if need TP bonus
  local buffer = 100
  -- Start TP bonus at 0 and accumulate based on equipped gear
  local tp_bonus_from_weapons = 0
  for slot,gear in pairs(tp_bonus_weapons) do
    local equipped_item = player.equipment[slot]
    if equipped_item and gear[equipped_item] then
      tp_bonus_from_weapons = tp_bonus_from_weapons + gear[equipped_item]
    end
  end
  local buff_bonus = T{
    buffactive['Crystal Blessing'] and 250 or 0,
  }:sum()
  if player.tp > 3000-tp_bonus_from_weapons-buff_bonus-buffer then
    wsmode = wsmode..'MaxTP'
  end

  return wsmode
end

function customize_idle_set(idleSet)
  -- If not in DT mode put on move speed gear
  if state.IdleMode.current == 'Normal' and state.DefenseMode.value == 'None' then
    if classes.CustomIdleGroups:contains('Adoulin') then
      idleSet = set_combine(idleSet, sets.Kiting.Adoulin)
    else
      idleSet = set_combine(idleSet, sets.Kiting)
    end
  end
  if state.CP.current == 'on' then
    idleSet = set_combine(idleSet, sets.CP)
  end

  -- Keep ranged weapon/ammo equipped if in an RA mode.
  if state.RangedWeaponSet.current ~= 'None' then
    idleSet = set_combine(idleSet, {
      range=player.equipment.range,
      ammo=player.equipment.ammo
    })
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

function customize_melee_set(meleeSet)
  if state.CP.current == 'on' then
    meleeSet = set_combine(meleeSet, sets.CP)
  end
  
  -- Keep ranged weapon/ammo equipped if in an RA mode.
  if state.RangedWeaponSet.current ~= 'None' then
    meleeSet = set_combine(meleeSet, {
      range=player.equipment.range,
      ammo=player.equipment.ammo
    })
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
  if state.CP.current == 'on' then
    defenseSet = set_combine(defenseSet, sets.CP)
  end
  
  -- Keep ranged weapon/ammo equipped if in an RA mode.
  if state.RangedWeaponSet.current ~= 'None' then
    defenseSet = set_combine(defenseSet, {
      range=player.equipment.range,
      ammo=player.equipment.ammo
    })
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
-- Return true if display was handled, and you don't want the default info shown.
function display_current_job_state(eventArgs)
  local cf_msg = ''
  if state.CombatForm.has_value then
    cf_msg = ' (' ..state.CombatForm.value.. ')'
  end

  local m_msg = state.OffenseMode.value
  if state.HybridMode.value ~= 'Normal' then
    m_msg = m_msg .. '/' ..state.HybridMode.value
  end

  local ws_msg = (state.AttCapped.value and 'AttCapped') or state.WeaponskillMode.value

  local d_msg = 'None'
  if state.DefenseMode.value ~= 'None' then
    d_msg = state.DefenseMode.value .. state[state.DefenseMode.value .. 'DefenseMode'].value
  end

  local i_msg = state.IdleMode.value

  local toy_msg = state.ToyWeapons.current

  local msg = ''
  if state.TreasureMode.value ~= 'None' then
    msg = msg .. ' TH: ' ..state.TreasureMode.value.. ' |'
  end
  if state.Kiting.value then
    msg = msg .. ' Kiting: On |'
  end
  if player.sub_job == 'DNC' then
    local s_msg = state.MainStep.current
    msg = msg ..string.char(31,060).. ' Step: '  ..string.char(31,001)..s_msg.. string.char(31,002)..  ' |'
  end
  if state.CP.current == 'on' then
    msg = msg .. ' CP Mode: On |'
  end

  add_to_chat(002, '| ' ..string.char(31,210).. 'Melee' ..cf_msg.. ': ' ..string.char(31,001)..m_msg.. string.char(31,002)..  ' |'
      ..string.char(31,207).. ' WS: ' ..string.char(31,001)..ws_msg.. string.char(31,002)..  ' |'
      ..string.char(31,004).. ' Defense: ' ..string.char(31,001)..d_msg.. string.char(31,002)..  ' |'
      ..string.char(31,207).. ' Idle: ' ..string.char(31,001)..i_msg.. string.char(31,002)..  ' |'
      ..string.char(31,012).. ' Toy Weapon: ' ..string.char(31,001)..toy_msg.. string.char(31,002)..  ' |'
      ..string.char(31,002)..msg)

  eventArgs.handled = true
end

-- Requires DistancePlus addon
function update_dp_type()
  local weapon = nil
  local weapon_type = nil
  local weapon_subtype = nil

  -- Handle unequipped case
  if player.equipment.ranged ~= nil and player.equipment.ranged ~= 0 and player.equipment.ranged ~= 'empty' then
    weapon = res.items:with('name', player.equipment.ranged)
    weapon_type = res.skills[weapon.skill].en
    if weapon_type == 'Archery' then
      weapon_subtype = 'bow'
    elseif weapon_type == 'Marksmanship' then
      weapon_subtype = marksman_weapon_subtypes[weapon.en]
    elseif weapon_type == 'Throwing' then
      weapon_subtype = 'throwing'
    end
  end

  -- Update addon if weapon type changed
  if weapon_subtype ~= current_dp_type then
    current_dp_type = weapon_subtype
    if current_dp_type ~= nil then
      coroutine.schedule(function()
        if current_dp_type ~= nil then
          send_command('dp '..current_dp_type)
        end
      end,3)
    end
  end
end

function cycle_weapons(cycle_dir)
  if cycle_dir == 'forward' then
    state.WeaponSet:cycle()
  elseif cycle_dir == 'back' then
    state.WeaponSet:cycleback()
  else
    state.WeaponSet:reset()
  end

  add_to_chat(141, 'Weapon Set to '..string.char(31,1)..state.WeaponSet.current)
  equip(sets.WeaponSet[state.WeaponSet.current])
end

function cycle_ranged_weapons(cycle_dir)
  if cycle_dir == 'forward' then
    state.RangedWeaponSet:cycle()
  elseif cycle_dir == 'back' then
    state.RangedWeaponSet:cycleback()
  else
    state.RangedWeaponSet:reset()
  end

  add_to_chat(141, 'RA Weapon Set to '..string.char(31,1)..state.RangedWeaponSet.current)
  equip(sets.WeaponSet[state.RangedWeaponSet.current])
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
      if isRefreshing==true and player.mpp < 100 then
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

function determine_haste_group()
  classes.CustomMeleeGroups:clear()
  if DW == true then
    if DW_needed <= 0 then
      classes.CustomMeleeGroups:append('MaxHaste')
    elseif DW_needed > 0 and DW_needed <= 6 then
      classes.CustomMeleeGroups:append('SuperHaste')
    elseif DW_needed > 6 and DW_needed <= 13 then
      classes.CustomMeleeGroups:append('HighHaste')
    elseif DW_needed > 13 and DW_needed <= 26 then
      classes.CustomMeleeGroups:append('MidHaste')
    elseif DW_needed > 26 and DW_needed <= 37 then
      classes.CustomMeleeGroups:append('LowHaste')
    elseif DW_needed > 37 then
      classes.CustomMeleeGroups:append('')
    end
  end
end

function job_self_command(cmdParams, eventArgs)
  silibs.self_command(cmdParams, eventArgs)
  ----------- Non-silibs content goes below this line -----------

  if cmdParams[1] == 'step' then
    send_command('@input /ja "'..state.MainStep.Current..'" <t>')
  elseif cmdParams[1] == 'toyweapon' then
    if cmdParams[2] == 'cycle' then
      cycle_toy_weapons('forward')
    elseif cmdParams[2] == 'cycleback' then
      cycle_toy_weapons('back')
    elseif cmdParams[2] == 'reset' then
      cycle_toy_weapons('reset')
    elseif cmdParams[2] == 'current' then
      cycle_toy_weapons('current')
    end
  elseif cmdParams[1] == 'weaponset' then
    if cmdParams[2] == 'cycle' then
      cycle_weapons('forward')
    elseif cmdParams[2] == 'cycleback' then
      cycle_weapons('back')
    elseif cmdParams[2] == 'reset' then
      cycle_weapons('reset')
    elseif cmdParams[2] == 'current' then
      cycle_weapons('current')
    end
  elseif cmdParams[1] == 'rangedweaponset' then
    if cmdParams[2] == 'cycle' then
      cycle_ranged_weapons('forward')
    elseif cmdParams[2] == 'cycleback' then
      cycle_ranged_weapons('back')
    elseif cmdParams[2] == 'reset' then
      cycle_ranged_weapons('reset')
    elseif cmdParams[2] == 'current' then
      cycle_ranged_weapons('current')
    end
  elseif cmdParams[1] == 'rune' then
    send_command('@input /ja '..state.Runes.value..' <me>')
  elseif cmdParams[1] == 'test' then
    test()
  end

  gearinfo(cmdParams, eventArgs)
end

function gearinfo(cmdParams, eventArgs)
  if cmdParams[1] == 'gearinfo' then
    if type(tonumber(cmdParams[2])) == 'number' then
      if tonumber(cmdParams[2]) ~= DW_needed then
        DW_needed = tonumber(cmdParams[2])
        DW = true
      end
    elseif type(cmdParams[2]) == 'string' then
      if cmdParams[2] == 'false' then
        DW_needed = 0
        DW = false
      end
    end
    if type(tonumber(cmdParams[3])) == 'number' then
      if tonumber(cmdParams[3]) ~= Haste then
        Haste = tonumber(cmdParams[3])
      end
    end
    if not midaction() then
      job_update()
    end
  end
end

-- State buff checks that will equip buff gear and mark the event as handled.
function check_buff(buff_name, eventArgs)
  if state.Buff[buff_name] then
    equip(sets.buff[buff_name] or {})
    eventArgs.handled = true
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

-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
  -- Default macro set/book
  if player.sub_job == 'RUN' then
    set_macro_page(4, 8)
  else
    set_macro_page(5, 8)
  end
end

function test()
end