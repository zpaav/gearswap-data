-- File Status: Good.

-- Author: Silvermutt
-- Required external libraries: SilverLibs
-- Required addons: Shortcuts
-- Recommended addons: WSBinder, Reorganizer
-- Misc Recommendations: Disable RollTracker

-------------------------------------------------------------------------------------------------------------------
-- Setup functions for this job.  Generally should not be modified.
-------------------------------------------------------------------------------------------------------------------

-- Initialization function for this job file.
function get_sets()
  -- Load and initialize Mote library
  mote_include_version = 2
  include('Mote-Include.lua') -- Executes job_setup, user_setup,
  coroutine.schedule(function()
    send_command('gs reorg')
  end, 1)
  coroutine.schedule(function()
    send_command('gs c weaponset current')
  end, 5)
end

-- Executes on first load and main job change
function job_setup()
  silibs.enable_cancel_on_blocking_status()
  silibs.enable_weapon_rearm()
  silibs.enable_auto_lockstyle(6)
  silibs.enable_premade_commands()
  silibs.enable_custom_roll_text()
  silibs.enable_equip_loop()

  state.OffenseMode:options('Safe', 'Normal')
  state.CastingMode:options('Normal', 'Resistant', 'Proc')
  state.IdleMode:options('Normal','HeavyDef')

  state.WeaponSet = M{['description']='Weapon Set', 'Casting', 'Idris', 'Maxentius', 'Staff'}
  state.CP = M(false, "Capacity Points Mode")
  state.RecoverMode = M('Always', '60%', '35%', 'Never')
  state.MagicBurst = M(true, 'Magic Burst')
  state.ElementalMode = M{['description'] = 'Elemental Mode', 'Light','Dark','Fire','Ice','Wind','Earth','Lightning','Water'}

  state.Buff.Entrust = buffactive.Entrust or false

  indi_timer = '' -- DO NOT MODIFY
  indi_duration = 319 -- Update with your actual indi duration
  indi_entrust_duration = 337 -- Update with your actual indi duration for entrusted spells

  -- Spells that don't scale with skill. Overrides Mote lib.
  classes.EnhancingDurSpells = S{'Adloquium', 'Haste', 'Haste II', 'Flurry', 'Flurry II', 'Protect', 'Protect II', 'Protect III',
      'Protect IV', 'Protect V', 'Protectra', 'Protectra II', 'Protectra III', 'Protectra IV', 'Protectra V', 'Shell', 'Shell II',
      'Shell III', 'Shell IV', 'Shell V', 'Shellra', 'Shellra II', 'Shellra III', 'Shellra IV', 'Shellra V', 'Blaze Spikes',
      'Ice Spikes', 'Shock Spikes', 'Enaero', 'Enaero II', 'Enblizzard', 'Enblizzard II', 'Enfire', 'Enfire II', 'Enstone',
      'Enstone II', 'Enthunder', 'Enthunder II', 'Enwater', 'Enwater II', 'Firestorm', 'Firestorm II', 'Hailstorm', 'Hailstorm II',
      'Rainstorm', 'Rainstorm II', 'Sandstorm', 'Sandstorm II', 'Thunderstorm', 'Thunderstorm II', 'Voidstorm', 'Voidstorm II',
      'Windstorm', 'Windstorm II'}

  send_command('bind !a gs c test')
  send_command('bind !s gs c faceaway')
  send_command('bind !d gs c interact')
  send_command('bind @w gs c toggle RearmingLock')
  send_command('bind ^u gs c toggle ShowLuopanUi')
  
  send_command('bind !q gs c elemental tier4')
  send_command('bind !w gs c elemental tier5')
  send_command('bind !e gs c elemental ara2')
  send_command('bind !r gs c elemental ara3')

  send_command('bind ^insert gs c weaponset cycle')
  send_command('bind ^delete gs c weaponset cycleback')

  send_command('bind @c gs c toggle CP')
  send_command('bind !` gs c toggle MagicBurst')
  send_command('bind @q gs c cycle RecoverMode')

  send_command('bind ^pageup gs c cycleback ElementalMode')
  send_command('bind ^pagedown gs c cycle ElementalMode')
  send_command('bind !pagedown gs c reset ElementalMode')
  
  send_command('bind !` input /ja "Full Circle" <me>')
  send_command('bind ^backspace input /ja "Entrust" <me>')
  send_command('bind !backspace input /ja "Life Cycle" <me>')
end

-- Executes on first load, main job change, **and sub job change**
function user_setup()
  silibs.user_setup_hook()
  include('Global-Binds.lua') -- Additional local binds

  if player.sub_job == 'WHM' or player.sub_job == 'RDM' then
    -- send_command('bind !e input /ma "Haste" <stpc>')
  end
  if player.sub_job == 'RDM' then
    send_command('bind !\' input /ma "Refresh" <stpc>')
  end
  if player.sub_job == 'SCH' then
    send_command('bind !c gs c elemental storm')
  end

  select_default_macro_book()
end

-- Called when this job file is unloaded (eg: job change)
function job_file_unload()
  send_command('unbind !a')
  send_command('unbind !s')
  send_command('unbind !d')
  send_command('unbind @w')
  send_command('unbind ^u')

  send_command('unbind !c')
  
  send_command('unbind !q')
  send_command('unbind !w')
  send_command('unbind !e')
  send_command('unbind !r')

  send_command('unbind ^insert')
  send_command('unbind ^delete')

  send_command('unbind @c')
  send_command('unbind !`')
  send_command('unbind @q')

  send_command('unbind !e')
  send_command('unbind !\'')

  send_command('unbind ^pageup')
  send_command('unbind ^pagedown')
  send_command('unbind !pagedown')

  send_command('unbind !`')
  send_command('unbind ^backspace')
  send_command('unbind !backspace')
end

-- Define sets and vars used by this job file.
function init_gear_sets()
  sets.org.job = {}

  sets.TreasureHunter = {
    range=empty,
    ammo="Perfect Lucky Egg", --1
    body=gear.Merl_TH_body, --2
    waist="Chaac Belt", --1
  }
  sets.TreasureHunter.RA = {
    body=gear.Merl_TH_body, --2
    waist="Chaac Belt", --1
  }

  --------------------------------------
  -- Precast sets
  --------------------------------------

  -- Fast cast sets for spells
  sets.precast.FC = {
    main="Idris",                   -- __ [__/__, ___] {25, __}
    sub="Genmei Shield",            -- __ [10/__, ___] {__, __}
    range="Dunna",                  --  3 [__/__, ___] { 5, __}
    ammo=empty,
    head=gear.Merl_FC_head,         -- 15 [__/__,  86] {__, __}
    body=gear.Merl_FC_body,         -- 14 [ 2/__,  91] {__, __}
    hands="Geomancy Mitaines +3",   -- __ [ 3/__,  57] {13, __}
    legs="Geomancy Pants +3",       -- 15 [__/__, 127] {__, __}
    feet=gear.Merl_FC_feet,         -- 12 [__/__, 118] {__, __}
    neck="Loricate Torque +1",      -- __ [ 6/ 6, ___] {__, __}
    ear1="Malignance Earring",      --  4 [__/__, ___] {__, __}
    ear2="Odnowa Earring +1",       -- __ [ 3/ 5, ___] {__, __}
    ring1="Defending Ring",         -- __ [10/10, ___] {__, __}
    ring2="Kishar Ring",            --  4 [__/__, ___] {__, __}
    back=gear.GEO_FC_Cape,          -- 10 [10/__, ___] {__, __}
    waist="Embla Sash",             --  5 [__/__, ___] {__, __}
    -- 82 FC [44 PDT / 21 MDT, 479 M.Eva] {43 Pet DT, 0 Pet Regen}

    -- ear2="Azimuth Earring +2",   -- __ [ 7/ 7, ___] {__, __}
    -- 82 FC [48 PDT / 23 MDT, 479 M.Eva] {43 Pet DT, 0 Pet Regen}
  }

  sets.precast.FC.RDM = set_combine(sets.precast.FC, {
    main="Idris",                   -- __ [__/__, ___] {25, __}
    sub="Genmei Shield",            -- __ [10/__, ___] {__, __}
    range="Dunna",                  --  3 [__/__, ___] { 5, __}
    ammo=empty,
    head=gear.Merl_FC_head,         -- 15 [__/__,  86] {__, __}
    body=gear.Merl_FC_body,         -- 14 [ 2/__,  91] {__, __}
    hands="Geomancy Mitaines +3",   -- __ [ 3/__,  57] {13, __}
    legs="Geomancy Pants +3",       -- 15 [__/__, 127] {__, __}
    feet="Azimuth Gaiters +2",      -- __ [10/10, 158] {__, __}
    neck="Bagua Charm +1",          -- __ [__/__, ___] {__, __}; Absorb Dmg+8
    ear1="Malignance Earring",      --  4 [__/__, ___] {__, __}
    ear2="Etiolation Earring",      --  1 [__/ 3, ___] {__, __}; Resist Silence+15
    ring1="Defending Ring",         -- __ [10/10, ___] {__, __}
    ring2="Gelatinous Ring +1",     -- __ [ 7/-1, ___] {__, __}
    back=gear.GEO_FC_Cape,          -- 10 [10/__, ___] {__, __}
    waist="Embla Sash",             --  5 [__/__, ___] {__, __}
    -- RDM FC traits                   15
    -- 82 FC [52 PDT/22 MDT, 519 Meva] {43 Pet DT, 0 Pet Regen}
    
    -- feet="Azimuth Gaiters +3",   -- __ [11/11, 168] {__, __}
    -- neck="Bagua Charm +2",       -- __ [__/__, ___] {__, __}; Absorb Dmg+10
    -- 82 FC [53 PDT/22 MDT, 529 Meva] {43 Pet DT, 0 Pet Regen}
  })

  -- TODO: Update
  sets.precast.FC.Impact = set_combine(sets.precast.FC, {
    -- head=empty,
    -- body="Crepuscular Cloak",
  })
  -- TODO: Update
  sets.precast.FC.Impact.RDM = set_combine(sets.precast.FC, {
    -- head=empty,
    -- body="Crepuscular Cloak",
  })

  sets.precast.FC.Dispelga = set_combine(sets.precast.FC, {
    main="Daybreak",
    sub="Genmei Shield",
  })


  -----------------------------------------------------------------------------------------------
  ---------------------------------------- Job Abilities ----------------------------------------
  -----------------------------------------------------------------------------------------------

  -- Precast sets to enhance JAs
  sets.precast.JA.Bolster = {
    body="Bagua Tunic +1",
  }
  sets.precast.JA['Life Cycle'] = {
    body="Geomancy Tunic +1",
    back=gear.GEO_Idle_Cape,
    -- body="Geomancy Tunic +3",
  }
  sets.precast.JA['Radial Arcana'] = {
    feet="Bagua Sandals +1",
  }
  sets.precast.JA['Mending Halation'] = {
    legs="Bagua Pants +3",
  }
  sets.precast.JA['Full Circle'] = {
    head="Azimuth Hood +2",
    hands="Bagua Mitaines +1",
    -- head="Azimuth Hood +3",
  }
  sets.precast.JA['Concentric Pulse'] = {
    head="Bagua Galero +1",
  }


  ----------------------------------------------------------------------------------------------
  ---------------------------------------- Weaponskills ----------------------------------------
  ----------------------------------------------------------------------------------------------

  -- Weaponskill sets
  -- Default set for any weaponskill that isn't any more specifically defined
  sets.precast.WS = {
    head=gear.Nyame_B_head,
    body=gear.Nyame_B_body,
    hands=gear.Nyame_B_hands,
    legs=gear.Nyame_B_legs,
    feet=gear.Nyame_B_feet,
  }
  
  -- Physical damage. 2 hit. Damage varies with TP.
  -- 70% MND / 30% STR; 3.0-9.75fTP
  -- TP Bonus > WSD > MND > STR
  sets.precast.WS['Black Halo'] = {
    -- Assume Idris                 -- ___, __, __, __, __/__ [25]
    -- Assume Genmei Shield         -- ___, __, __, __, 10/__ [__]
    -- Assume Dunna                 -- ___, __, __, __, __/__ [ 5]
    head=gear.Nyame_B_head,         -- ___, 26, 26, 11,  7/ 7 [__]
    body=gear.Nyame_B_body,         -- ___, 37, 45, 13,  9/ 9 [__]
    hands=gear.Nyame_B_hands,       -- ___, 40, 17, 11,  7/ 7 [__]
    legs=gear.Nyame_B_legs,         -- ___, 32, 58, 12,  8/ 8 [__]
    feet=gear.Nyame_B_feet,         -- ___, 26, 23, 11,  7/ 7 [__]
    -- neck="Fotia Gorget",         -- fTP Bonus
    ear1="Regal Earring",           -- ___, 10, __, __, __/__ [__]
    ear2="Moonshade Earring",       -- 250, __, __, __, __/__ [__]
    ring1="Metamorph Ring +1",      -- ___, 16, __, __, __/__ [__]
    -- ring2="Epaminondas's Ring",  -- ___, __, __,  5, __/__ [__]
    back=gear.GEO_Idle_Cape,        -- ___, __, __, __, __/__ [__]
    -- waist="Fotia Belt",          -- fTP Bonus
    -- 250 TP Bonus, 187 MND, 169 STR, 63 WSD, 48PDT/38MDT [30PetDT]
  }
  sets.precast.WS['Black Halo'].MaxTP = set_combine(sets.precast.WS['Black Halo'], {
    ear2="Ishvara Earring",         -- ___, __, __,  2, __/__ [__]
  })
  sets.precast.WS['Black Halo'].Safe = set_combine(sets.precast.WS['Black Halo'], {
    hands="Geomancy Mitaines +3",   -- ___, 43, 16, __,  3/__ [13]
    ring2="Defending Ring",         -- ___, __, __, __, 10/10 [__]
    -- 250 TP Bonus, 190 MND, 168 STR, 35 WSD, 54PDT/44MDT [43PetDT]
  })

  -- Physical damage. 1 hit. Damage varies with TP.
  -- 50% MND / 50% STR; 3.5-12fTP
  -- TP Bonus > WSD > MND = STR
  sets.precast.WS['Judgment'] = set_combine(sets.precast.WS['Black Halo'], {})
  sets.precast.WS['Judgment'].MaxTP = set_combine(sets.precast.WS['Black Halo'].MaxTP, {})
  sets.precast.WS['Judgment'].Safe = set_combine(sets.precast.WS['Black Halo'].Safe, {})

  -- Physical damage. 1 hit. Attack varies with TP.
  -- 50% MND / 50% INT; 1.5-4.75fTP
  -- WSD > MND > INT
  sets.precast.WS['Exudiation'] = set_combine(sets.precast.WS['Black Halo'], {
    ear2="Ishvara Earring",
  })
  sets.precast.WS['Exudiation'].MaxTP = set_combine(sets.precast.WS['Exudiation'], {})
  sets.precast.WS['Exudiation'].Safe = set_combine(sets.precast.WS['Black Halo'].Safe, {
    ear2="Ishvara Earring",
  })

  -- Physical. 6 Hits. 30% STR / 30% MND
  -- fTP Replicating WS. Can crit. Crit rate varies with TP. 1.125 fTP
  -- TP Bonus > Fotia > Crit Dmg > Crit Rate, MND = STR > WSD
  sets.precast.WS['Hexa Strike'] = {
    -- Assume Idris                 -- ___, __, __, __, __, __, __/__ [25]
    -- Assume Genmei Shield         -- ___, __, __, __, __, __, 10/__ [__]
    -- Assume Dunna                 -- ___, __, __, __, __, __, __/__ [ 5]
    head=gear.Nyame_B_head,         -- ___, __, __, 26, 26, 11,  7/ 7 [__]
    body=gear.Nyame_B_body,         -- ___, __, __, 37, 45, 13,  9/ 9 [__]
    hands=gear.Nyame_B_hands,       -- ___, __, __, 40, 17, 11,  7/ 7 [__]
    legs=gear.Nyame_B_legs,         -- ___, __, __, 32, 58, 12,  8/ 8 [__]
    feet=gear.Nyame_B_feet,         -- ___, __, __, 26, 23, 11,  7/ 7 [__]
    -- neck="Fotia Gorget",         -- fTP Bonus
    ear1="Regal Earring",           -- ___, __, __, 10, __, __, __/__ [__]
    ear2="Moonshade Earring",       -- 250, __, __, __, __, __, __/__ [__]
    ring1="Metamorph Ring +1",      -- ___, __, __, 16, __, __, __/__ [__]
    -- ring2="Epaminondas's Ring",  -- ___, __, __, __, __,  5, __/__ [__]
    back=gear.GEO_Idle_Cape,        -- ___, __, __, __, __, __, __/__ [__]
    -- waist="Fotia Belt",          -- fTP Bonus
    -- 250 TP Bonus, 0 Crit Dmg,  0 Crit Rate, 187 MND, 169 STR, 63 WSD, 48PDT/38MDT [30PetDT]
  }
  sets.precast.WS['Hexa Strike'].MaxTP = set_combine(sets.precast.WS['Hexa Strike'], {
    ear2="Malignance Earring",
  })
  sets.precast.WS['Hexa Strike'].Safe = set_combine(sets.precast.WS['Hexa Strike'], {
    hands="Geomancy Mitaines +3",   -- ___, 43, 16, __,  3/__ [13]
    ring2="Defending Ring",         -- ___, __, __, __, 10/10 [__]
    -- 250 TP Bonus, 0 Crit Dmg,  0 Crit Rate, 190 MND, 168 STR, 35 WSD, 54PDT/42MDT [43PetDT]
  })

  -- Magical (light). dStat=INT. 50% STR / 50% MND
  -- Light MAB > MAB > M.Dmg > MND > STR > WSD
  sets.precast.WS['Flash Nova'] = {
    -- Assume Idris                 -- __, 40,217, __, __, __, __/__ [25]
    -- Assume Genmei Shield         -- __, __, __, __, __, __, 10/__ [__]
    -- Assume Dunna                 -- __, __, __, __, __, __, __/__ [ 5]
    head=gear.Nyame_B_head,         -- __, 30, __, 26, 26, 11,  7/ 7 [__]
    body=gear.Nyame_B_body,         -- __, 30, __, 37, 45, 13,  9/ 9 [__]
    hands="Jhakri Cuffs +2",        -- __, 40, __, 35, 18,  7, __/__ [__]
    legs=gear.Nyame_B_legs,         -- __, 30, __, 32, 58, 12,  8/ 8 [__]
    feet=gear.Nyame_B_feet,         -- __, 30, __, 26, 23, 11,  7/ 7 [__]
    neck="Baetyl Pendant",          -- __, 13, __, __, __, __, __/__ [__]
    ear1="Regal Earring",           -- __,  7, __, 10, __, __, __/__ [__]
    ear2="Malignance Earring",      -- __,  8, __,  8, __, __, __/__ [__]
    -- ring1="Weatherspoon Ring",   -- 10, __, __, __, __, __, __/__ [__]
    -- ring2="Shiva Ring +1",       -- __,  3, __, __, __, __, __/__ [__]
    back=gear.GEO_Nuke_Cape,        -- __, 10, 20, __, __, __, 10/__ [__]
    -- waist="Skrymir Cord",        -- __,  5, 30, __, __, __, __/__ [__]
    -- 10 Light MAB, 246 MAB, 267 M.Dmg, 174 MND, 170 STR, 54 WSD, 51PDT/31MDT [30PetDT]

    -- head="Agwu's Cap",           -- __, 60, 35, 26, 26, __, __/__ [__]; R30
    -- body="Agwu's Robe",          -- __, 60, 30, 37, 33, __, __/__ [__]; R30
    -- hands="Agwu's Gages",        -- __, 60, 20, 45, 14, __, __/__ [__]; R30
    -- legs="Agwu's Slops",         -- __, 60, 20, 32, 43, __, 10/10 [__]; R30
    -- feet="Agwu's Pigaches",      -- __, 60, 20, 26, 21, __, __/__ [__]; R30
    -- waist="Skrymir Cord +1",     -- __,  7, 35, __, __, __, __/__ [__]
    -- 10 Light MAB, 388 MAB, 397 M.Dmg, 184 MND, 137 STR, 0 WSD, 30PDT/10MDT [30PetDT]
  }
  sets.precast.WS['Flash Nova'].MaxTP = set_combine(sets.precast.WS['Flash Nova'], {})
  sets.precast.WS['Flash Nova'].Safe = {
    -- Assume Idris                 -- 40,217, __, __, __, __/__ [25]
    -- Assume Genmei Shield         -- __, __, __, __, __, 10/__ [__]
    -- Assume Dunna                 -- __, __, __, __, __, __/__ [ 5]
    body="Shamash Robe",            -- 45, __, 40, 30, __, 10/10 [__]
    hands="Geomancy Mitaines +3",   -- __, __, 43, 16, __,  3/__ [13]
    feet=gear.Nyame_B_feet,         -- 30, __, 26, 23, 11,  7/ 7 [__]
    neck="Baetyl Pendant",          -- 13, __, __, __, __, __/__ [__]
    ear1="Regal Earring",           --  7, __, 10, __, __, __/__ [__]
    ear2="Malignance Earring",      --  8, __,  8, __, __, __/__ [__]
    ring2="Defending Ring",         -- __, __, __, __, __, 10/10 [__]
    back=gear.GEO_Nuke_Cape,        -- 10, 20, __, __, __, 10/__ [__]
    -- 153 MAB, 237 M.Dmg, 127 MND, 69 STR, 11 WSD, 50PDT/27MDT [43PetDT]

    -- head="Agwu's Cap",           -- 60, 35, 26, 26, __, __/__ [__]; R30
    -- legs="Agwu's Slops",         -- 60, 20, 32, 43, __, 10/10 [__]; R30
    -- feet="Agwu's Pigaches",      -- 60, 20, 26, 21, __, __/__ [__]; R30
    -- ring1="Weatherspoon Ring",   -- __, __, __, __, __, __/__ [__]; 10 Light MAB
    -- waist="Skrymir Cord +1",     --  7, 35, __, __, __, __/__ [__]
    -- 310 MAB, 347 M.Dmg, 185 MND, 136 STR, 0 WSD, 53PDT/30MDT [43PetDT]
  }

  -- Magical (light). dStat=INT. 40% STR / 40% MND
  -- Damage varies with TP. 2.125-6.125 fTP
  -- TP Bonus > Fotia > Light MAB > MAB > M.Dmg > MND > STR > WSD
  sets.precast.WS['Seraph Strike'] = set_combine(sets.precast.WS['Flash Nova'], {
    -- neck="Fotia Gorget",         -- __, __, __, __, __, __, __/__ [__]; FTP bonus
    ear2="Moonshade Earring",       -- __, __, __, __, __, __, __/__ [__]; TP bonus
    -- waist="Fotia Belt",          -- __, __, __, __, __, __, __/__ [__]; FTP bonus
  })
  sets.precast.WS['Seraph Strike'].MaxTP = set_combine(sets.precast.WS['Seraph Strike'].MaxTP, {
    ear2="Malignance Earring",      -- __,  8, __,  8, __, __, __/__ [__]
  })
  sets.precast.WS['Seraph Strike'].Safe = set_combine(sets.precast.WS['Flash Nova'].Safe, {
    -- neck="Fotia Gorget",         -- __, __, __, __, __, __, __/__ [__]; FTP bonus
    ear2="Moonshade Earring",       -- __, __, __, __, __, __, __/__ [__]; TP bonus
    -- waist="Fotia Belt",          -- __, __, __, __, __, __, __/__ [__]; FTP bonus
  })

  -- Cataclysm: 30% STR/30% INT, 2.75-5.0 fTP, 1 hit (aoe-magical)
  -- Dark MAB > MAB > M.Dmg > INT > STR > WSD
  sets.precast.WS['Cataclysm'] = {
    -- Assume Malignance Pole       -- __, __, __, 15
    -- Assume Tzacab Grip           -- __, __, __, __
    -- Assume Dunna                 -- __, __, __, __
    head="Pixie Hairpin +1",        -- 28, __, __, __
    body=gear.Nyame_B_body,         -- __, 30, __, 13
    hands="Jhakri Cuffs +2",        -- __, 40, __,  7
    legs=gear.Nyame_B_legs,         -- __, 30, __, 12
    feet=gear.Nyame_B_feet,         -- __, 30, __, 11
    -- neck="Fotia Gorget",         -- __, __, __, __; FTP bonus
    ear1="Regal Earring",           -- __,  7, __, __
    ear2="Moonshade Earring",       -- __, __, __, __; TP bonus
    ring1="Archon Ring",            --  5, __, __, __
    -- ring2="Epaminondas's Ring",  -- __, __, __,  5
    back=gear.GEO_Nuke_Cape,        -- __, 10, 20, __
    -- waist="Skrymir Cord",        -- __,  5, 30, __
    -- 33 Dark MAB, 155 MAB, 50 M.Dmg, 48 WSD

    -- body="Agwu's Robe",          -- __, 60, 30, __; R30
    -- hands="Agwu's Gages",        -- __, 60, 20, __; R30
    -- legs="Agwu's Slops",         -- __, 60, 20, __; R30
    -- feet="Agwu's Pigaches",      -- __, 60, 20, __; R30
    -- waist="Skrymir Cord +1",     -- __,  7, 35, __
    -- 33 Dark MAB, 237 MAB, 125 M.Dmg, 12 WSD
  }
  sets.precast.WS['Cataclysm'].MaxTP = set_combine(sets.precast.WS['Cataclysm'], {
    ear2="Malignance Earring",      -- __,  8, __, __
  })

  --------------------------------------
  -- Midcast sets
  --------------------------------------

  sets.midcast.FastRecast = set_combine(sets.precast.FC, {})

  -- Initializes trusts at iLvl 119
  sets.midcast.Trust = {
    head=gear.Nyame_B_head,
    body=gear.Nyame_B_body,
    hands=gear.Nyame_B_hands,
    legs=gear.Nyame_B_legs,
    feet=gear.Nyame_B_feet,
  }

  -- Master GEO with full merits = 850 geo skill base (cap at 900)
  -- Lv 99 GEO = 43 Conserve MP base (cap at 100)
  sets.midcast.Geomancy = {
    main="Idris",                   -- 10, __, __ [__/__, ___]
    sub="Genmei Shield",            -- __, __, __ [10/__, ___]
    range="Dunna",                  -- __, 18, __ [__/__, ___]
    ammo=empty,
    head="Azimuth Hood +2",         -- __, 20, __ [11/11, 126]; Set bonus
    body=gear.Nyame_B_body,         -- __, __, __ [ 9/ 9, 139]
    hands="Azimuth Gloves +2",      -- __, __, __ [11/11,  88]; Set bonus
    feet="Azimuth Gaiters +2",      -- __, __, __ [10/10, 158]; Set bonus
    neck="Bagua Charm +1",          --  6, __, __ [__/__, ___]; Luopan Duration +20%
    ear1="Eabani Earring",          -- __, __, __ [__/__,   8]
    ear2="Halasz Earring",          -- __, __, __ [__/__, ___]
    ring1="Stikini Ring +1",        -- __,  8, __ [__/__, ___]
    ring2="Mephitas's Ring +1",     -- __, __, 15 [__/__, ___]
    -- legs=gear.Vanya_C_legs,      -- __, __, 12 [__/__, 107]
    -- back=gear.GEO_Adoulin_Cape,  -- __, 14, __ [__/__, ___]
    -- waist="Sekhmet Corset",      -- __, __,  3 [__/__, ___]
    -- Base stats                   -- __,850, 43
    -- 10 Geomancy, 910 geo skill, 73 Conserve MP [51 PDT/41 MDT, 626 M.Eva]

    -- main="Idris",                -- 10, __, __ [__/__, ___]
    -- sub="Genmei Shield",         -- __, __, __ [10/__, ___]
    -- range="Dunna",               -- __, 18, __ [__/__, ___]
    -- ammo=empty,
    -- head="Azimuth Hood +3",      -- __, 25, __ [12/12, 136]; Set bonus
    -- body=gear.Merl_ConMP_body,   -- __, __,  6 [ 2/__,  91]
    -- hands="Azimuth Gloves +3",   -- __, __, __ [12/12,  98]; Set bonus
    -- legs=gear.Vanya_C_legs,      -- __, __, 12 [__/__, 107]
    -- feet="Azimuth Gaiters +3",   -- __, __, __ [11/11, 168]; Set bonus
    -- neck="Bagua Charm +2",       -- __, __, __ [__/__, ___]; Luopan Duration +25%
    -- ear1="Mendicant's Earring",  -- __, __,  2 [__/__, ___]
    -- ear2="Calamitous Earring",   -- __, __,  4 [__/__, ___]
    -- ring1="Stikini Ring +1",     -- __,  8, __ [__/__, ___]
    -- ring2="Mephitas's Ring +1",  -- __, __, 15 [__/__, ___]
    -- back="Solemnity Cape",       -- __, __,  5 [ 4/ 4, ___]
    -- waist="Shinjutsu-no-Obi +1", -- __, __, 15 [__/__, ___]
    -- Base stats                   -- __,850, 43
    -- 10 Geomancy, 901 geo skill, 102 Conserve MP [51 PDT/39 MDT, 600 M.Eva]
    
    -- main="Idris",                -- 10, __, __ [__/__, ___]
    -- sub="Genmei Shield",         -- __, __, __ [10/__, ___]
    -- range=empty,
    -- ammo="Pemphredo Tathlum",    -- __, __,  4 [__/__, ___]
    -- head="Azimuth Hood +3",      -- __, 25, __ [12/12, 136]; Set bonus
    -- body="Azimuth Coat +3",      -- __, __, __ [__/__, 141]; Set bonus
    -- hands="Azimuth Gloves +3",   -- __, __, __ [12/12,  98]; Set bonus
    -- legs=gear.Vanya_C_legs,      -- __, __, 12 [__/__, 107]
    -- feet="Azimuth Gaiters +3",   -- __, __, __ [11/11, 168]; Set bonus
    -- neck="Bagua Charm +2",       -- __, __, __ [__/__, ___]; Luopan Duration +25%
    -- ear1="Mendicant's Earring",  -- __, __,  2 [__/__, ___]
    -- ear2="Calamitous Earring",   -- __, __,  4 [__/__, ___]
    -- ring1="Stikini Ring +1",     -- __,  8, __ [__/__, ___]
    -- ring2="Mephitas's Ring +1",  -- __, __, 15 [__/__, ___]
    -- back="Solemnity Cape",       -- __, __,  5 [ 4/ 4, ___]
    -- waist="Shinjutsu-no-Obi +1", -- __, __, 15 [__/__, ___]
    -- Base stats                   -- __,850, 43
    -- Master level 9               -- __, 18, __
    -- 10 Geomancy, 901 geo skill, 100 Conserve MP [49 PDT/39 MDT, 650 M.Eva]
    
    -- main="Idris",                -- 10, __, __ [__/__, ___]
    -- sub="Genmei Shield",         -- __, __, __ [10/__, ___]
    -- range=empty,
    -- ammo="Pemphredo Tathlum",    -- __, __,  4 [__/__, ___]
    -- head="Azimuth Hood +3",      -- __, 25, __ [12/12, 136]; Set bonus
    -- body="Azimuth Coat +3",      -- __, __, __ [__/__, 141]; Set bonus
    -- hands="Azimuth Gloves +3",   -- __, __, __ [12/12,  98]; Set bonus
    -- legs=gear.Vanya_C_legs,      -- __, __, 12 [__/__, 107]
    -- feet="Azimuth Gaiters +3",   -- __, __, __ [11/11, 168]; Set bonus
    -- neck="Bagua Charm +2",       -- __, __, __ [__/__, ___]; Luopan Duration +25%
    -- ear1="Mendicant's Earring",  -- __, __,  2 [__/__, ___]
    -- ear2="Calamitous Earring",   -- __, __,  4 [__/__, ___]
    -- ring1="Defending Ring",      -- __, __, __ [10/10, ___]
    -- ring2="Mephitas's Ring +1",  -- __, __, 15 [__/__, ___]
    -- back="Solemnity Cape",       -- __, __,  5 [ 4/ 4, ___]
    -- waist="Shinjutsu-no-Obi +1", -- __, __, 15 [__/__, ___]
    -- Base stats                   -- __,850, 43
    -- Master level 13              -- __, 26, __
    -- 10 Geomancy, 901 geo skill, 100 Conserve MP [59 PDT/49 MDT, 650 M.Eva]
  }

  --Extra Indi duration as long as you can keep your 900 skill cap.
  sets.midcast.Geomancy.Indi = {
    main="Idris",                   -- 10, __, __, __, __ [__/__, ___] {25, __}
    sub="Genmei Shield",            -- __, __, __, __, __ [10/__, ___] {__, __}
    range="Dunna",                  -- __, 18, __, __, __ [__/__, ___] { 5, __}
    ammo=empty,
    body=gear.Nyame_B_body,         -- __, __, __, __, __ [ 9/ 9, 139] {__, __}
    hands="Azimuth Gloves +2",      -- __, __, __, __, __ [11/11,  88] {__, __}; Set bonus: save MP
    legs="Bagua Pants +3",          -- __, __, __, 21, __ [__/__, 127] {__, __}
    feet="Azimuth Gaiters +2",      -- __, __, __, 25, __ [10/10, 158] {__, __}; Set bonus: save MP
    neck="Incanter's Torque",       -- __, 10, __, __, __ [__/__, ___] {__, __}; Save MP
    ear1="Mendicant's Earring",     -- __, __,  2, __, __ [__/__, ___] {__, __}
    ring1="Stikini Ring +1",        -- __,  8, __, __, __ [__/__, ___] {__, __}
    ring2="Mephitas's Ring +1",     -- __, __, 15, __, __ [__/__, ___] {__, __}
    back=gear.GEO_Adoulin_Cape,     -- __, 14, __, __, 20 [__/__, ___] { 4, __}
    waist="Shinjutsu-no-Obi +1",    -- __, __, 15, __, __ [__/__, ___] {__, __}
    -- Base stats                   -- __,850, 43,220, __ [__/__, ___] {50, __}
    -- 10 Geomancy, 900 geo skill, 75 Conserve MP, 266 Indi Duration, 20 Indi Duration % [40 PDT/ 30 MDT, 512 M.Eva] {Pet: 84 DT, 0 Regen}
    
    -- main="Idris",                -- 10, __, __, __, __ [__/__, ___] {25, __}
    -- sub="Genmei Shield",         -- __, __, __, __, __ [10/__, ___] {__, __}
    -- range="Dunna",               -- __, 18, __, __, __ [__/__, ___] { 5, __}
    -- ammo=empty,
    -- head=gear.Vanya_C_head,      -- __, __, 12, __, __ [__/ 2,  75] {__, __}
    -- body=gear.Nyame_B_body,      -- __, __, __, __, __ [ 9/ 9, 139] {__, __}
    -- hands="Azimuth Gloves +3",   -- __, __, __, __, __ [12/12,  98] {__, __}; Set bonus: save MP
    -- legs="Bagua Pants +3",       -- __, __, __, 21, __ [__/__, 127] {__, __}
    -- feet="Azimuth Gaiters +3",   -- __, __, __, 30, __ [11/11, 168] {__, __}; Set bonus: save MP
    -- neck="Incanter's Torque",    -- __, 10, __, __, __ [__/__, ___] {__, __}; Save MP
    -- ear1="Mendicant's Earring",  -- __, __,  2, __, __ [__/__, ___] {__, __}
    -- ear2="Calamitous Earring",   -- __, __,  4, __, __ [__/__, ___] {__, __}
    -- ring1="Stikini Ring +1",     -- __,  8, __, __, __ [__/__, ___] {__, __}
    -- ring2="Mephitas's Ring +1",  -- __, __, 15, __, __ [__/__, ___] {__, __}
    -- back=gear.GEO_Adoulin_Cape,  -- __, 14, __, __, 20 [__/__, ___] { 4, __}
    -- waist="Shinjutsu-no-Obi +1", -- __, __, 15, __, __ [__/__, ___] {__, __}
    -- Base stats                   -- __,850, 43,220, __ [__/__, ___] {50, __}
    -- 10 Geomancy, 900 geo skill, 91 Conserve MP, 250 Indi Duration, 20 Indi Duration % [42 PDT/ 44 MDT, 480 M.Eva] {Pet: 84 DT, 0 Regen}
    
    -- main="Idris",                -- 10, __, __, __, __ [__/__, ___] {25, __}
    -- sub="Genmei Shield",         -- __, __, __, __, __ [10/__, ___] {__, __}
    -- range="Dunna",               -- __, 18, __, __, __ [__/__, ___] { 5, __}
    -- ammo=empty,
    -- head=gear.Vanya_C_head,      -- __, __, 12, __, __ [__/ 2,  75] {__, __}
    -- body=gear.Nyame_B_body,      -- __, __, __, __, __ [ 9/ 9, 139] {__, __}
    -- hands="Azimuth Gloves +3",   -- __, __, __, __, __ [12/12,  98] {__, __}; Set bonus: save MP
    -- legs="Bagua Pants +3",       -- __, __, __, 21, __ [__/__, 127] {__, __}
    -- feet="Azimuth Gaiters +3",   -- __, __, __, 30, __ [11/11, 168] {__, __}; Set bonus: save MP
    -- neck="Incanter's Torque",    -- __, 10, __, __, __ [__/__, ___] {__, __}; Save MP
    -- ear1="Mendicant's Earring",  -- __, __,  2, __, __ [__/__, ___] {__, __}
    -- ear2="Calamitous Earring",   -- __, __,  4, __, __ [__/__, ___] {__, __}
    -- ring1="Defending Ring",      -- __, __, __, __, __ [10/10, ___] {__, __}
    -- ring2="Mephitas's Ring +1",  -- __, __, 15, __, __ [__/__, ___] {__, __}
    -- back=gear.GEO_Adoulin_Cape,  -- __, 14, __, __, 20 [__/__, ___] { 4, __}
    -- waist="Shinjutsu-no-Obi +1", -- __, __, 15, __, __ [__/__, ___] {__, __}
    -- Base stats                   -- __,850, 43,220, __ [__/__, ___] {50, __}
    -- Master level 4               -- __,  8
    -- 10 Geomancy, 900 geo skill, 91 Conserve MP, 271 Indi Duration, 20 Indi Duration % [52 PDT/ 44 MDT, 607 M.Eva] {Pet: 84 DT, 0 Regen}
    
    -- main="Idris",                -- 10, __, __, __, __ [__/__, ___] {25, __}
    -- sub="Genmei Shield",         -- __, __, __, __, __ [10/__, ___] {__, __}
    -- range=empty
    -- ammo="Pemphredo Tathlum",    -- __, __,  4, __, __ [__/__, ___] {__, __}
    -- head=gear.Vanya_C_head,      -- __, __, 12, __, __ [__/ 2,  75] {__, __}
    -- body=gear.Nyame_B_body,      -- __, __, __, __, __ [ 9/ 9, 139] {__, __}
    -- hands="Azimuth Gloves +3",   -- __, __, __, __, __ [12/12,  98] {__, __}; Set bonus: save MP
    -- legs="Bagua Pants +3",       -- __, __, __, 21, __ [__/__, 127] {__, __}
    -- feet="Azimuth Gaiters +3",   -- __, __, __, 30, __ [11/11, 168] {__, __}; Set bonus: save MP
    -- neck="Reti Pendant",         -- __, __,  4, __, __ [__/__, ___] {__, __}; Save MP
    -- ear1="Mendicant's Earring",  -- __, __,  2, __, __ [__/__, ___] {__, __}
    -- ear2="Calamitous Earring",   -- __, __,  4, __, __ [__/__, ___] {__, __}
    -- ring1="Defending Ring",      -- __, __, __, __, __ [10/10, ___] {__, __}
    -- ring2="Mephitas's Ring +1",  -- __, __, 15, __, __ [__/__, ___] {__, __}
    -- back=gear.GEO_Adoulin_Cape,  -- __, 14, __, __, 20 [__/__, ___] { 4, __}
    -- waist="Shinjutsu-no-Obi +1", -- __, __, 15, __, __ [__/__, ___] {__, __}
    -- Base stats                   -- __,850, 43,220, __ [__/__, ___] {50, __}
    -- Master level 18              -- __, 36
    -- 10 Geomancy, 900 geo skill, 99 Conserve MP, 271 Indi Duration, 20 Indi Duration % [52 PDT/ 44 MDT, 607 M.Eva] {Pet: 79 DT, 0 Regen}
  }

  -- Geomancy has no effect on Entrust, skill and duration do.
  sets.buff.Entrust = set_combine(sets.midcast.Geomancy.Indi, {
    main=gear.Solstice_D,           -- __,  5,  6, 15, __ [__/__, ___] { 4, __} -- Need to add augs
    sub="Genmei Shield",            -- __, __, __, __, __ [10/__, ___] {__, __}
    range=empty,
    ammo="Pemphredo Tathlum",       -- __, __,  4, __, __ [__/__, ___] {__, __}
    head="Azimuth Hood +2",         -- __, 20, __, __, __ [11/11, 126] {__,  4}; Set bonus
    hands="Azimuth Gloves +2",      -- __, __, __, __, __ [11/11,  88] {__, __}; Set bonus: save MP
    legs="Bagua Pants +3",          -- __, __, __, 21, __ [__/__, 127] {__, __}
    feet="Azimuth Gaiters +2",      -- __, __, __, 25, __ [10/10, 158] {__, __}; Set bonus: save MP
    neck="Reti Pendant",            -- __, __,  4, __, __ [__/__, ___] {__, __}; Save MP
    ear1="Mendicant's Earring",     -- __, __,  2, __, __ [__/__, ___] {__, __}
    ring1="Defending Ring",         -- __, __, __, __, __ [10/10, ___] {__, __}
    ring2="Mephitas's Ring +1",     -- __, __, 15, __, __ [__/__, ___] {__, __}
    back=gear.GEO_Adoulin_Cape,     -- __, 14, __, __, 20 [__/__, ___] { 4, __}
    waist="Shinjutsu-no-Obi +1",    -- __, __, 15, __, __ [__/__, ___] {__, __}
    -- Base stats                   -- __,850, 43,220, __ [__/__, ___] {50, __}
    -- Ideal: 0 Geomancy, 889 geo skill, 89 Conserve MP, 281 Indi Duration, 20 Indi Duration % [52 PDT/ 42 MDT, 499 M.Eva] {Pet: 58 DT, 4 Regen}
    
    -- head="Azimuth Hood +3",      -- __, 25, __, __, __ [12/12, 136] {__,  5}; Set bonus: save MP
    -- body=gear.Merl_ConMP_body,   -- __, __,  6, __, __ [ 2/__,  91] {__, __}
    -- hands="Azimuth Gloves +3",   -- __, __, __, __, __ [12/12,  98] {__, __}; Set bonus: save MP
    -- feet="Azimuth Gaiters +3",   -- __, __, __, 30, __ [11/11, 168] {__, __}; Set bonus: save MP
    -- ear2="Calamitous Earring",   -- __, __,  4, __, __ [__/__, ___] {__, __}
    -- Base stats                   -- __,850, 43,220, __ [__/__, ___] {50, __}
    -- Master level 3               -- __,  6
    -- Ideal: 0 Geomancy, 900 geo skill, 99 Conserve MP, 286 Indi Duration, 20 Indi Duration % [57 PDT/ 45 MDT, 620 M.Eva] {Pet: 59 DT, 5 Regen}
  })

  -- Cap at 700 power; Power = floor(MND÷2) + floor(VIT÷4) + Healing Magic Skill
  sets.midcast.CureNormal = {
    main="Bunzi's Rod",             -- 30, 15, __, ___ [__/__, ___] __
    sub="Genbu's Shield",           --  5, __, __, ___ [10/__, ___] __
    range=empty,
    ammo="Esper Stone +1",          -- __, __, __, ___ [__/__, ___]  5
    head=gear.Vanya_B_head,         -- 10, 27, 18,  20 [__/ 5,  75] __
    body=gear.Vanya_B_body,         -- __, 36, 23,  20 [ 1/ 4,  80] __
    hands="Azimuth Gloves +2",      -- __, 42, 33, ___ [11/11,  88] 12
    legs=gear.Vanya_B_legs,         -- __, 34, 12,  20 [__/__, 107] __
    feet=gear.Vayna_B_feet,         --  5, 19, 10,  40 [__/__, 107] __
    neck="Incanter's Torque",       -- __, __, __,  10 [__/__, ___] __
    ear1="Meili Earring",           -- __, __, __,  10 [__/__, ___] __
    ear2="Mendicant's Earring",     --  5, __, __, ___ [__/__, ___] __
    ring1="Sirona's Ring",          -- __,  3,  3,  10 [__/__, ___] __
    ring2="Defending Ring",         -- __, __, __, ___ [10/10, ___] __
    -- Traits/Merits/Gifts             __,103, 95,  16
    -- RDM Subjob                      __, __, __, 139
    -- 55 CP, 279 MND, 194 VIT, 285 Healing Skill [32 PDT/30 MDT, 457 M.Eva] 17 -Enmity
    
    -- main=gear.Gada_MND,          -- 18, 21, __,  18 [__/__, ___] __
    -- hands="Azimuth Gloves +3",   -- __, 47, 38, ___ [12/12,  98] 13
    -- back=gear.GEO_Cure_Cape,     -- 10, 30, __, ___ [10/__, ___] __
    -- waist="Luminary Sash",       -- __, 10, __, ___ [__/__, ___] __
    -- 53 CP, 330 MND, 199 VIT, 303 Healing Skill [43 PDT/31 MDT, 467 M.Eva] 18 -Enmity
    -- 849 HP Cure IV
  }
  sets.midcast.CureWeather = set_combine(sets.midcast.CureNormal, {
    waist="Hachirin-no-obi",
    -- 53 CP, 320 MND, 199 VIT, 303 Healing Skill [43 PDT/31 MDT, 467 M.Eva] 18 -Enmity
    -- 902 HP to 1043 Cure IV depending on weather/day
  })

  -- TODO: update
  sets.midcast.Cursna = set_combine(sets.midcast.CureNormal, {})

  sets.midcast['Elemental Magic'] = {
    main="Bunzi's Rod",
    sub="Ammurapi Shield",
    range=empty,
    ammo="Pemphredo Tathlum", --4
    head="Azimuth Hood +2",
    body="Azimuth Coat +2",
    hands="Azimuth Gloves +2",
    legs=gear.Nyame_B_legs,
    feet="Azimuth Gaiters +2",
    neck="Baetyl Pendant", --13
    ear1="Malignance Earring", --8
    ear2="Regal Earring", --7
    ring1="Metamorph Ring +1",
    ring2="Stikini Ring +1",
    back=gear.GEO_Nuke_Cape,
    waist="Refoccilation Stone", --10
    
    -- main="Bunzi's Rod",
    -- sub="Ammurapi Shield",
    -- range=empty,
    -- ammo="Ghastly Tathlum +1",
    -- head="Azimuth Hood +2",
    -- body="Azimuth Coat +2",
    -- hands="Azimuth Gloves +2",
    -- legs="Agwu's Slops",
    -- feet="Azimuth Gaiters +2",
    -- neck="Sibyl Scarf",
    -- ear1="Malignance Earring",
    -- ear2="Azimuth Earring +2",        --Regal earring alt
    -- ring1="Metamorph Ring +1",
    -- ring2="Freke Ring",
    -- back=gear.GEO_Nuke_Cape,
    -- waist="Refoccilation Stone",
  }
  sets.midcast['Elemental Magic'].MB = set_combine(sets.midcast['Elemental Magic'], {
    -- head="Ea Hat +1",
    -- hands="Agwu's Gages",
  }) -- Not set up to be used
  sets.midcast['Elemental Magic'].Resistant = set_combine(sets.midcast['Elemental Magic'], {})
  sets.midcast['Elemental Magic'].Proc = set_combine(sets.midcast['Elemental Magic'], {})

  sets.midcast['Drain'] = set_combine(sets.midcast.IntEnfeebling, {
    main="Bunzi's Rod",
    sub="Ammurapi Shield",
    range=empty,
    ammo="Pemphredo Tathlum",
    head=gear.Nyame_B_head,
    body=gear.Nyame_B_body,
    hands="Azimuth Gloves +2",
    legs="Azimuth Tights +2",
    feet=gear.Nyame_B_feet,
    neck="Erra Pendant",
    ear1="Dignitary's Earring",
    ear2="Malignance Earring",
    ring1="Archon Ring",
    ring2="Evanescence Ring",
    back=gear.GEO_Nuke_Cape,
    waist="Fucho-no-Obi",

    -- main="Rubicundity",
    -- sub="Ammurapi Shield",
    -- range=empty,
    -- ammo="Pemphredo Tathlum",
    -- head="Bagua Galero +3",
    -- body="Geomancy Tunic +3",
    -- hands="Azimuth Gloves +2",
    -- legs="Azimuth Tights +2",
    -- feet="Agwu's Pigaches",
    -- neck="Erra Pendant",
    -- ear1="Hirudinea Earring",
    -- ear2="Malignance Earring",
    -- ring1="Archon Ring",
    -- ring2="Evanescence Ring",
    -- back=gear.GEO_Nuke_Cape,
    -- waist="Fucho-no-Obi",
  })

  sets.midcast.Aspir = set_combine(sets.midcast.Drain, {})
  sets.midcast['Aspir III'] = set_combine(sets.midcast.Drain, {})

  sets.midcast.Stun = {
    main="Contemplator +1",           -- 70, __, 12, __ [__/__, ___] {__/__, __}
    sub="Khonsu",                     -- 30, __, __, __ [ 6/ 6, ___] {__/__, __}
    range="Dunna",                    -- 10, __, __,  3 [__/__, ___] { 5/ 5, __}
    ammo=empty,                       -- __, __, __, __ [__/__, ___] {__/__, __}
    head=gear.Merl_FC_head,           -- 15, __, 29, 15 [__/__,  86] {__/__, __}
    body=gear.Merl_FC_body,           -- 22, __, 40, 14 [ 2/__,  91] {__/__, __}
    hands="Geomancy Mitaines +3",     -- 48, __, 29, __ [ 3/__,  57] {13/13, __}; Set bonus
    legs="Geomancy Pants +3",         -- 49, __, 44, 15 [__/__, 127] {__/__, __}; Set bonus
    feet=gear.Merl_FC_feet,           --  8, __, 26, 12 [__/__, 118] {__/__, __}
    neck="Bagua Charm +1",            -- 25, __, __, __ [__/__, ___] {__/__, __}
    ear1="Malignance Earring",        -- 10, __,  8,  4 [__/__, ___] {__/__, __}
    ear2="Regal Earring",             -- __, __, 10, __ [__/__, ___] {__/__, __}; Set bonus
    ring1="Metamorph Ring +1",        -- 15, __, 16, __ [__/__, ___] {__/__, __}
    ring2="Stikini Ring +1",          -- 11,  8, __, __ [__/__, ___] {__/__, __}
    back=gear.GEO_FC_Cape,            -- 20, __, 30, 10 [10/__, ___] {__/__, __}
    waist="Witful Belt",              -- __, __, __,  3 [__/__, ___] {__/__, __}
    -- AF set bonuses                 -- 15
    -- 348 M.Acc, 8 Dark Magic Skill, 244 INT, 76 FC [21 PDT/6 MDT, 479 M.Eva] {Pet: 18 PDT/18 MDT, 0 Regen}

    -- body="Zendik Robe",            -- 45, __, 38, 13 [__/__,  86] {__/__, __}
    -- neck="Bagua Charm +2",         -- 30, __, __, __ [__/__, ___] {__/__, __}
    -- ear2="Azimuth Earring +2",     -- 20, __, 15, __ [ 7/ 7, ___] {__/__, __}
    -- 396 M.Acc, 8 Dark Magic Skill, 247 INT, 75 FC [26 PDT/13 MDT, 474 M.Eva] {Pet: 18 PDT/18 MDT, 0 Regen}
  }
  sets.midcast.Stun.Resistant = set_combine(sets.midcast.Stun, {})

  sets.midcast.Impact = {
    main="Contemplator +1",           -- 70, __, 12 [__/__, ___] {__/__, __}; M.Acc skill+228
    sub="Khonsu",                     -- 30, __, __ [ 6/ 6, ___] {__/__, __}
    range="Dunna",                    -- 10, __, __ [__/__, ___] { 5/ 5, __}
    ammo=empty,                       -- __, __, __ [__/__, ___] {__/__, __}
    hands="Geomancy Mitaines +3",     -- 48, __, 29 [ 3/__,  57] {13/13, __}; Set bonus
    legs=gear.Nyame_B_legs,           -- 40, __, 44 [ 8/ 8, 150] {__/__, __}
    feet="Azimuth Gaiters +2",        -- 50, __, 29 [10/10, 158] {__/__, __}
    neck="Bagua Charm +1",            -- 25, __, __ [__/__, ___] {__/__, __}
    ear1="Regal Earring",             -- __, __, 10 [__/__, ___] {__/__, __}; Set bonus
    ear2="Malignance Earring",        -- 10, __,  8 [__/__, ___] {__/__, __}
    ring1="Metamorph Ring +1",        -- 15, __, 16 [__/__, ___] {__/__, __}
    ring2="Stikini Ring +1",          -- 11,  8, __ [__/__, ___] {__/__, __}
    back=gear.GEO_Nuke_Cape,          -- 20, __, 30 [10/__, ___] {__/__, __}
    waist="Acuity Belt +1",           -- 15, __, 23 [__/__, ___] {__/__, __}
    -- AF set bonuses                 -- 15
    -- 359 M.Acc, 8 Elemental Skill, 201 INT [37 PDT/24 MDT, 365 M.Eva] {Pet: 18 PDT/18 MDT, 0 Regen}

    -- main="Idris",                  -- 70, __, __ [__/__, ___] {25/25, __}; M.Acc skill+255, R15
    -- sub="Ammurapi Shield",         -- 38, __, 13 [__/__, ___] {__/__, __}
    -- head=empty,
    -- body="Crepuscular Cloak",      -- 85, __, 80 [__/__, 231] {__/__, __}
    -- legs="Agwu's Slops",           -- 55, __, 54 [10/10, 134] {__/__, __}
    -- feet="Azimuth Gaiters +3",     -- 63, __, 34 [11/11, 168] {__/__, __}
    -- neck="Bagua Charm +2",         -- 30, __, __ [__/__, ___] {__/__, __}
    -- ear2="Azimuth Earring +2",     -- 20, __, 15 [ 7/ 7, ___] {__/__, __}
    -- AF set bonuses                 -- 15
    -- 495 M.Acc, 8 Elemental Skill, 304 INT [41 PDT/28 MDT, 590 M.Eva] {Pet: 43 PDT/43 MDT, 0 Regen}
  }

  sets.midcast.Dispel = {
    main="Contemplator +1",           -- 70, 20, 12 [__/__, ___] {__/__, __}; M.Acc skill+228
    sub="Khonsu",                     -- 30, __, __ [ 6/ 6, ___] {__/__, __}
    range="Dunna",                    -- 10, __, __ [__/__, ___] { 5/ 5, __}
    ammo=empty,                       -- __, __, __ [__/__, ___] {__/__, __}
    head="Azimuth Hood +2",           -- 51, __, 34 [11/11, 126] {__/__,  4}
    body="Azimuth Coat +2",           -- 54, __, 45 [__/__, 131] {__/__, __}
    hands="Azimuth Gloves +2",        -- 52, 23, 31 [11/11,  88] {__/__, __}
    legs="Geomancy Pants +3",         -- 49, __, 44 [__/__, 127] {__/__, __}
    feet="Azimuth Gaiters +2",        -- 50, __, 29 [10/10, 158] {__/__, __}
    neck="Bagua Charm +1",            -- 25, __, __ [__/__, ___] {__/__, __}
    ear1="Regal Earring",             -- __, __, 10 [__/__, ___] {__/__, __}; Set bonus
    ear2="Malignance Earring",        -- 10, __,  8 [__/__, ___] {__/__, __}
    ring1="Metamorph Ring +1",        -- 15, __, 16 [__/__, ___] {__/__, __}
    ring2="Stikini Ring +1",          -- 11,  8, __ [__/__, ___] {__/__, __}
    back=gear.GEO_Nuke_Cape,          -- 20, __, 30 [10/__, ___] {__/__, __}
    waist="Obstinate Sash",           -- 15, 15, __ [__/__, ___] {__/__, __}
    -- AF set bonuses                 -- 15
    -- 477 M.Acc, 66 Enfeebling Skill, 259 INT [48 PDT/38 MDT, 630 M.Eva] {Pet: 5 PDT/5 MDT, 4 Regen}

    -- main="Idris",                  -- 70, __, __ [__/__, ___] {25/25, __}; M.Acc skill+255, R15
    -- sub="Ammurapi Shield",         -- 38, __, 13 [__/__, ___] {__/__, __}
    -- head="Azimuth Hood +3",        -- 61, __, 39 [12/12, 136] {__/__,  5}
    -- body="Azimuth Coat +3",        -- 64, __, 49 [__/__, 141] {__/__, __}
    -- hands="Azimuth Gloves +3",     -- 62, 28, 36 [12/12,  98] {__/__, __}
    -- feet="Azimuth Gaiters +3",     -- 63, __, 34 [11/11, 168] {__/__, __}
    -- neck="Bagua Charm +2",         -- 30, __, __ [__/__, ___] {__/__, __}
    -- ear2="Azimuth Earring +2",     -- 20, __, 15 [ 7/ 7, ___] {__/__, __}
    -- AF set bonuses                 -- 15
    -- 543 M.Acc, 51 Enfeebling Skill, 286 INT [52 PDT/42 MDT, 670 M.Eva] {Pet: 5 PDT/5 MDT, 5 Regen}
  }

  sets.midcast.Dispelga = set_combine(sets.midcast.Dispel, {
    main="Daybreak",                  -- 40, __, __ [__/__,  30] {__/__, __}; Needed to cast dispelga
    sub="Ammurapi Shield",            -- 38, __, 13 [__/__, ___] {__/__, __}
  })

  sets.midcast['Enfeebling Magic'] = {
    main="Contemplator +1",           -- 70, 20, 12, 22, __ [__/__, ___] {__/__, __}; M.Acc skill+228
    sub="Khonsu",                     -- 30, __, __, __, __ [ 6/ 6, ___] {__/__, __}
    range="Dunna",                    -- 10, __, __, __, __ [__/__, ___] { 5/ 5, __}
    ammo=empty,                       -- __, __, __, __, __ [__/__, ___] {__/__, __}
    head="Azimuth Hood +2",           -- 51, __, 34, 27, __ [11/11, 126] {__/__,  4}
    body="Azimuth Coat +2",           -- 54, __, 45, 38, __ [__/__, 131] {__/__, __}
    hands="Regal Cuffs",              -- 45, __, 40, 40, 20 [__/__,  53] {__/__, __}
    legs="Geomancy Pants +3",         -- 49, __, 44, 34, __ [__/__, 127] {__/__, __}
    feet="Azimuth Gaiters +2",        -- 50, __, 29, 27, __ [10/10, 158] {__/__, __}
    neck="Bagua Charm +1",            -- 25, __, __, __, __ [__/__, ___] {__/__, __}
    ear1="Regal Earring",             -- __, __, 10, 10, __ [__/__, ___] {__/__, __}; Set bonus
    ear2="Malignance Earring",        -- 10, __,  8,  8, __ [__/__, ___] {__/__, __}
    ring1="Metamorph Ring +1",        -- 15, __, 16, 16, __ [__/__, ___] {__/__, __}
    back="Aurist's Cape +1",          -- 33, __, 33, 33, __ [__/__, ___] {__/__, __}
    waist="Obstinate Sash",           -- 15, 15, __,  5,  5 [__/__, ___] {__/__, __}
    -- AF set bonuses                 -- 15
    -- 472 M.Acc, 35 Enfeebling Skill, 271 INT, 260 MND, 25% Enf Duration [27 PDT/27 MDT, 595 M.Eva] {Pet: 5 PDT/5 MDT, 4 Regen}

    -- main="Idris",                  -- 70, __, __, __, __ [__/__, ___] {25/25, __}; M.Acc skill+255, R15
    -- sub="Ammurapi Shield",         -- 38, __, 13, 13, 10 [__/__, ___] {__/__, __}
    -- range="Dunna",                 -- 10, __, __, __, __ [__/__, ___] { 5/ 5, __}
    -- ammo=empty,                    -- __, __, __, __, __ [__/__, ___] {__/__, __}
    -- head="Azimuth Hood +3",        -- 61, __, 39, 32, __ [12/12, 136] {__/__,  5}
    -- body="Azimuth Coat +3",        -- 64, __, 49, 43, __ [__/__, 141] {__/__, __}
    -- hands="Regal Cuffs",           -- 45, __, 40, 40, 20 [__/__,  53] {__/__, __}
    -- legs="Geomancy Pants +3",      -- 49, __, 44, 34, __ [__/__, 127] {__/__, __}
    -- feet="Azimuth Gaiters +3",     -- 63, __, 34, 32, __ [11/11, 168] {__/__, __}
    -- neck="Bagua Charm +2",         -- 30, __, __, __, __ [__/__, ___] {__/__, __}
    -- ear1="Regal Earring",          -- __, __, 10, 10, __ [__/__, ___] {__/__, __}; Set bonus
    -- ear2="Azimuth Earring +2",     -- 20, __, 15, 15, __ [ 7/ 7, ___] {__/__, __}
    -- ring1="Metamorph Ring +1",     -- 15, __, 16, 16, __ [__/__, ___] {__/__, __}
    -- ring2="Kishar Ring",           --  5, __, __, __, 10 [__/__, ___] {__/__, __}
    -- back="Aurist's Cape +1",       -- 33, __, 33, 33, __ [__/__, ___] {__/__, __}
    -- waist="Obstinate Sash",        -- 15, 15, __,  5,  5 [__/__, ___] {__/__, __}
    -- AF set bonuses                 -- 15
    -- 533 M.Acc, 15 Enfeebling Skill, 293 INT, 273 MND, 45% Enf Duration [30 PDT/30 MDT, 625 M.Eva] {Pet: 30 PDT/30 MDT, 5 Regen}
  }
  sets.midcast['Enfeebling Magic'].Resistant = set_combine(sets.midcast['Enfeebling Magic'], {
    -- main="Idris",                  -- 70, __, __, __, __ [__/__, ___] {25/25, __}; M.Acc skill+255, R15
    -- sub="Ammurapi Shield",         -- 38, __, 13, 13, 10 [__/__, ___] {__/__, __}
    -- range="Dunna",                 -- 10, __, __, __, __ [__/__, ___] { 5/ 5, __}
    -- ammo=empty,                    -- __, __, __, __, __ [__/__, ___] {__/__, __}
    -- head="Azimuth Hood +3",        -- 61, __, 39, 32, __ [12/12, 136] {__/__,  5}
    -- body="Azimuth Coat +3",        -- 64, __, 49, 43, __ [__/__, 141] {__/__, __}
    -- hands="Azimuth Gloves +3",     -- 62, 28, 36, 47, __ [12/12,  98] {__/__, __}
    -- legs="Geomancy Pants +3",      -- 49, __, 44, 34, __ [__/__, 127] {__/__, __}
    -- feet="Azimuth Gaiters +3",     -- 63, __, 34, 32, __ [11/11, 168] {__/__, __}
    -- neck="Bagua Charm +2",         -- 30, __, __, __, __ [__/__, ___] {__/__, __}
    -- ear1="Regal Earring",          -- __, __, 10, 10, __ [__/__, ___] {__/__, __}; Set bonus
    -- ear2="Azimuth Earring +2",     -- 20, __, 15, 15, __ [ 7/ 7, ___] {__/__, __}
    -- ring1="Metamorph Ring +1",     -- 15, __, 16, 16, __ [__/__, ___] {__/__, __}
    -- ring2="Stikini Ring +1",       -- 11,  8, __,  8, __ [__/__, ___] {__/__, __}
    -- back="Aurist's Cape +1",       -- 33, __, 33, 33, __ [__/__, ___] {__/__, __}
    -- waist="Obstinate Sash",        -- 15, 15, __,  5,  5 [__/__, ___] {__/__, __}
    -- AF set bonuses                 -- 15
    -- 556 M.Acc, 51 Enfeebling Skill, 289 INT, 288 MND, 15% Enf Duration [42 PDT/42 MDT, 625 M.Eva] {Pet: 30 PDT/30 MDT, 5 Regen}
  })

  sets.midcast.ElementalEnfeeble = set_combine(sets.midcast['Enfeebling Magic'], {
    main="Contemplator +1",           -- 70, 20, 12, 22, __ [__/__, ___] {__/__, __}; M.Acc skill+228
    sub="Khonsu",                     -- 30, __, __, __, __ [ 6/ 6, ___] {__/__, __}
    range="Dunna",                    -- 10, __, __, __, __ [__/__, ___] { 5/ 5, __}
    ammo=empty,                       -- __, __, __, __, __ [__/__, ___] {__/__, __}
    head="Azimuth Hood +2",           -- 51, __, 34, 27, __ [11/11, 126] {__/__,  4}
    body="Azimuth Coat +2",           -- 54, __, 45, 38, __ [__/__, 131] {__/__, __}
    hands="Regal Cuffs",              -- 45, __, 40, 40, 20 [__/__,  53] {__/__, __}
    legs="Geomancy Pants +3",         -- 49, __, 44, 34, __ [__/__, 127] {__/__, __}
    feet="Azimuth Gaiters +2",        -- 50, __, 29, 27, __ [10/10, 158] {__/__, __}
    neck="Bagua Charm +1",            -- 25, __, __, __, __ [__/__, ___] {__/__, __}
    ear1="Regal Earring",             -- __, __, 10, 10, __ [__/__, ___] {__/__, __}; Set bonus
    ear2="Malignance Earring",        -- 10, __,  8,  8, __ [__/__, ___] {__/__, __}
    ring1="Metamorph Ring +1",        -- 15, __, 16, 16, __ [__/__, ___] {__/__, __}
    back="Aurist's Cape +1",          -- 33, __, 33, 33, __ [__/__, ___] {__/__, __}
    waist="Obstinate Sash",           -- 15, 15, __,  5,  5 [__/__, ___] {__/__, __}
    -- AF set bonuses                 -- 15
    -- 472 M.Acc, 35 Enfeebling Skill, 271 INT, 260 MND, 25% Enf Duration [27 PDT/27 MDT, 595 M.Eva] {Pet: 5 PDT/5 MDT, 4 Regen}

    -- main="Idris",                  -- 70, __, __, __, __ [__/__, ___] {25/25, __}; M.Acc skill+255, R15
    -- sub="Ammurapi Shield",         -- 38, __, 13, 13, 10 [__/__, ___] {__/__, __}
    -- range="Dunna",                 -- 10, __, __, __, __ [__/__, ___] { 5/ 5, __}
    -- ammo=empty,                    -- __, __, __, __, __ [__/__, ___] {__/__, __}
    -- head="Azimuth Hood +3",        -- 61, __, 39, 32, __ [12/12, 136] {__/__,  5}
    -- body="Azimuth Coat +3",        -- 64, __, 49, 43, __ [__/__, 141] {__/__, __}
    -- hands="Regal Cuffs",           -- 45, __, 40, 40, 20 [__/__,  53] {__/__, __}
    -- legs="Geomancy Pants +3",      -- 49, __, 44, 34, __ [__/__, 127] {__/__, __}
    -- feet="Azimuth Gaiters +3",     -- 63, __, 34, 32, __ [11/11, 168] {__/__, __}
    -- neck="Bagua Charm +2",         -- 30, __, __, __, __ [__/__, ___] {__/__, __}
    -- ear1="Regal Earring",          -- __, __, 10, 10, __ [__/__, ___] {__/__, __}; Set bonus
    -- ear2="Azimuth Earring +2",     -- 20, __, 15, 15, __ [ 7/ 7, ___] {__/__, __}
    -- ring1="Metamorph Ring +1",     -- 15, __, 16, 16, __ [__/__, ___] {__/__, __}
    -- ring2="Kishar Ring",           --  5, __, __, __, 10 [__/__, ___] {__/__, __}
    -- back="Aurist's Cape +1",       -- 33, __, 33, 33, __ [__/__, ___] {__/__, __}
    -- waist="Obstinate Sash",        -- 15, 15, __,  5,  5 [__/__, ___] {__/__, __}
    -- AF set bonuses                 -- 15
    -- 533 M.Acc, 15 Enfeebling Skill, 293 INT, 273 MND, 45% Enf Duration [30 PDT/30 MDT, 625 M.Eva] {Pet: 30 PDT/30 MDT, 5 Regen}
  })
  sets.midcast.ElementalEnfeeble.Resistant = set_combine(sets.midcast['Enfeebling Magic'].Resistant, {
    main="Maxentius",                 -- 40, __, 15, 15, __ [__/__, ___] {__/__, __}
    sub="Ammurapi Shield",            -- 38, __, 13, 13, 10 [__/__, ___] {__/__, __}
    range=empty,
    ammo="Pemphredo Tathlum",         --  8, __,  4, __, __ [__/__, ___] {__/__, __}
    head="Azimuth Hood +2",           -- 51, __, 34, 27, __ [11/11, 126] {__/__,  4}
    body="Azimuth Coat +2",           -- 54, __, 45, 38, __ [__/__, 131] {__/__, __}
    hands="Azimuth Gloves +2",        -- 52, __, 31, 42, __ [11/11,  88] {__/__, __}
    legs="Geomancy Pants +3",         -- 49, __, 44, 34, __ [__/__, 127] {__/__, __}; Set bonus
    feet="Azimuth Gaiters +2",        -- 50, __, 29, 27, __ [10/10, 158] {__/__, __}
    neck="Bagua Charm +1",            -- 25, __, __, __, __ [__/__, ___] {__/__, __}
    ear1="Malignance Earring",        -- 10, __,  8,  8, __ [__/__, ___] {__/__, __}
    ear2="Regal Earring",             -- __, __, 10, 10, __ [__/__, ___] {__/__, __}; Set bonus
    ring1="Metamorph Ring +1",        -- 15, __, 16, 16, __ [__/__, ___] {__/__, __}
    ring2="Stikini Ring +1",          -- 11,  8, __,  8, __ [__/__, ___] {__/__, __}
    back="Aurist's Cape +1",          -- 33, __, 33, 33, __ [__/__, ___] {__/__, __}
    waist="Acuity Belt +1",           -- 15, __, 23, __, __ [__/__, ___] {__/__, __}
    -- AF set bonuses                 -- 15
    -- 466 M.Acc, 8 Enfeebling Skill, 305 INT, 271 MND, 10% Enf Duration [32 PDT/32 MDT, 630 M.Eva] {Pet: 0 PDT/0 MDT, 4 Regen}

    -- main="Idris",                  -- 70, __, __, __, __ [__/__, ___] {25/25, __}; M.Acc skill+255, R15
    -- sub="Ammurapi Shield",         -- 38, __, 13, 13, 10 [__/__, ___] {__/__, __}
    -- range=empty,
    -- ammo="Pemphredo Tathlum",      --  8, __,  4, __, __ [__/__, ___] {__/__, __}
    -- head="Azimuth Hood +3",        -- 61, __, 39, 32, __ [12/12, 136] {__/__,  5}
    -- body="Azimuth Coat +3",        -- 64, __, 49, 43, __ [__/__, 141] {__/__, __}
    -- hands="Azimuth Gloves +3",     -- 62, 28, 36, 47, __ [12/12,  98] {__/__, __}
    -- legs="Agwu's Slops",           -- 55, __, 54, 32, __ [10/10, 134] {__/__, __}; Elemental status +10
    -- feet="Azimuth Gaiters +3",     -- 63, __, 34, 32, __ [11/11, 168] {__/__, __}
    -- neck="Bagua Charm +2",         -- 30, __, __, __, __ [__/__, ___] {__/__, __}
    -- ear1="Malignance Earring",     -- 10, __,  8,  8, __ [__/__, ___] {__/__, __}
    -- ear2="Azimuth Earring +2",     -- 20, __, 15, 15, __ [ 7/ 7, ___] {__/__, __}
    -- ring1="Metamorph Ring +1",     -- 15, __, 16, 16, __ [__/__, ___] {__/__, __}
    -- ring2="Stikini Ring +1",       -- 11,  8, __,  8, __ [__/__, ___] {__/__, __}
    -- back="Aurist's Cape +1",       -- 33, __, 33, 33, __ [__/__, ___] {__/__, __}
    -- waist="Acuity Belt +1",        -- 15, __, 23, __, __ [__/__, ___] {__/__, __}
    -- 555 M.Acc, 36 Enfeebling Skill, 324 INT, 279 MND, 10% Enf Duration [52 PDT/52 MDT, 677 M.Eva] {Pet: 25 PDT/25 MDT, 5 Regen}
  })

  sets.midcast.IntEnfeebles = set_combine(sets.midcast['Enfeebling Magic'], {})
  sets.midcast.IntEnfeebles.Resistant = set_combine(sets.midcast['Enfeebling Magic'].Resistant, {
    -- main="Idris",                  -- 70, __, __, __, __ [__/__, ___] {25/25, __}; M.Acc skill+255, R15
    -- sub="Ammurapi Shield",         -- 38, __, 13, 13, 10 [__/__, ___] {__/__, __}
    -- range=empty,
    -- ammo="Pemphredo Tathlum",      --  8, __,  4, __, __ [__/__, ___] {__/__, __}
    -- head="Azimuth Hood +3",        -- 61, __, 39, 32, __ [12/12, 136] {__/__,  5}
    -- body="Azimuth Coat +3",        -- 64, __, 49, 43, __ [__/__, 141] {__/__, __}
    -- hands="Azimuth Gloves +3",     -- 62, 28, 36, 47, __ [12/12,  98] {__/__, __}
    -- legs="Agwu's Slops",           -- 55, __, 54, 32, __ [10/10, 134] {__/__, __}; Elemental status +10
    -- feet="Azimuth Gaiters +3",     -- 63, __, 34, 32, __ [11/11, 168] {__/__, __}
    -- neck="Bagua Charm +2",         -- 30, __, __, __, __ [__/__, ___] {__/__, __}
    -- ear1="Malignance Earring",     -- 10, __,  8,  8, __ [__/__, ___] {__/__, __}
    -- ear2="Azimuth Earring +2",     -- 20, __, 15, 15, __ [ 7/ 7, ___] {__/__, __}
    -- ring1="Metamorph Ring +1",     -- 15, __, 16, 16, __ [__/__, ___] {__/__, __}
    -- ring2="Stikini Ring +1",       -- 11,  8, __,  8, __ [__/__, ___] {__/__, __}
    -- back="Aurist's Cape +1",       -- 33, __, 33, 33, __ [__/__, ___] {__/__, __}
    -- waist="Acuity Belt +1",        -- 15, __, 23, __, __ [__/__, ___] {__/__, __}
    -- 555 M.Acc, 36 Enfeebling Skill, 324 INT, 279 MND, 10% Enf Duration [52 PDT/52 MDT, 677 M.Eva] {Pet: 25 PDT/25 MDT, 5 Regen}
  })

  sets.midcast.MndEnfeebles = set_combine(sets.midcast['Enfeebling Magic'], {})
  sets.midcast.MndEnfeebles.Resistant = set_combine(sets.midcast['Enfeebling Magic'].Resistant, {})

  sets.midcast.Dia = {
    main="Idris",                     -- __, __ [__/__, ___] {25/25, __}; M.Acc skill+255
    sub="Ammurapi Shield",            -- __, 10 [__/__, ___] {__/__, __}
    range=empty,
    ammo="Perfect Lucky Egg",         --  1, __ [__/__, ___] {__/__, __}
    head="Azimuth Hood +2",           -- __, __ [11/11, 126] {__/__,  4}
    body=gear.Merl_TH_body,           --  2, __ [ 2/__,  91] {__/__, __}
    hands="Regal Cuffs",              -- __, 20 [__/__,  53] {__/__, __}
    legs=gear.Nyame_B_legs,           -- __, __ [ 8/ 8, 150] {__/__, __}
    feet="Azimuth Gaiters +2",        -- __, __ [10/10, 158] {__/__, __}
    neck="Bagua Charm +1",            -- __, __ [__/__, ___] {__/__, __}
    ear1="Hearty Earring",            -- __, __ [__/__, ___] {__/__, __}; Status Resist +5
    ring1="Defending Ring",           -- __, __ [10/10, ___] {__/__, __}
    ring2="Kishar Ring",              -- __, 10 [__/__, ___] {__/__, __}
    back=gear.GEO_FC_Cape,            -- __, __ [10/__, ___] {__/__, __}
    waist="Obstinate Sash",           -- __,  5 [__/__, ___] {__/__, __}
    -- 4 TH, 40% Enf Duration [53 PDT/39 MDT, 578 M.Eva] {Pet: 25 PDT/25 MDT, 4 Regen}

    -- main="Idris",                  -- __, __ [__/__, ___] {25/25, __}; M.Acc skill+255
    -- sub="Ammurapi Shield",         -- __, 10 [__/__, ___] {__/__, __}
    -- range="Dunna",                 -- __, __ [__/__, ___] { 5/ 5, __}
    -- ammo=empty,
    -- head="Azimuth Hood +3",        -- __, __ [12/12, 136] {__/__,  5}
    -- body=gear.Merl_TH_body,        --  2, __ [ 2/__,  91] {__/__, __}
    -- hands="Regal Cuffs",           -- __, 20 [__/__,  53] {__/__, __}
    -- legs=gear.Merl_TH_legs,        --  2, __ [__/__, 118] {__/__, __}
    -- feet="Azimuth Gaiters +3",     -- __, __ [11/11, 168] {__/__, __}
    -- neck="Bagua Charm +2",         -- __, __ [__/__, ___] {__/__, __}
    -- ear1="Hearty Earring",         -- __, __ [__/__, ___] {__/__, __}; Status Resist +5
    -- ear2="Azimuth Earring +2",     -- __, __ [ 7/ 7, ___] {__/__, __}
    -- ring1="Defending Ring",        -- __, __ [10/10, ___] {__/__, __}
    -- ring2="Kishar Ring",           -- __, 10 [__/__, ___] {__/__, __}
    -- back=gear.GEO_FC_Cape,         -- __, __ [10/__, ___] {__/__, __}
    -- waist="Obstinate Sash",        -- __,  5 [__/__, ___] {__/__, __}
    -- 4 TH, 45% Enf Duration [52 PDT/40 MDT, 566 M.Eva] {Pet: 30 PDT/30 MDT, 5 Regen}
  }
  sets.midcast['Dia II'] = set_combine(sets.midcast.Dia, {})
  sets.midcast['Diaga'] = set_combine(sets.midcast.Dia, {})

  sets.midcast.Bio = set_combine(sets.midcast.Dia, {})
  sets.midcast['Bio II'] = set_combine(sets.midcast.Dia, {})

  sets.midcast['Enhancing Magic'] = {
    main=gear.Gada_ENH,               -- 18,  6, __ [__/__, ___] {__/__, __}
    sub="Ammurapi Shield",            -- __, 10, __ [__/__, ___] {__/__, __}
    range="Dunna",                    -- __, __,  3 [__/__, ___] { 5/ 5, __}
    ammo=empty,
    head="Azimuth Hood +2",           -- __, __, __ [11/11, 126] {__/__,  4}
    body=gear.Telchine_ENH_body,      -- 12, 10, __ [__/__,  80] {__/__, __}
    hands=gear.Telchine_ENH_hands,    -- __, 10, __ [__/__,  37] {__/__, __}
    legs=gear.Telchine_ENH_legs,      -- __, 10, __ [__/__, 107] {__/__, __}
    feet="Azimuth Gaiters +2",        -- __, __, __ [10/10, 158] {__/__, __}
    neck="Incanter's Torque",         -- 10, __, __ [__/__, ___] {__/__, __}
    ear1="Mimir Earring",             -- 10, __, __ [__/__, ___] {__/__, __}
    ear2="Hearty Earring",            -- __, __, __ [__/__, ___] {__/__, __}
    ring1="Stikini Ring +1",          --  8, __, __ [__/__, ___] {__/__, __}
    ring2="Defending Ring",           -- __, __, __ [10/10, ___] {__/__, __}
    back=gear.GEO_FC_Cape,            -- __, __, 10 [10/__, ___] {__/__, __}
    waist="Embla Sash",               -- __, 10,  5 [__/__, ___] {__/__, __}
    -- Subjob                           144
    -- 202 Enh Skill, 56 Enh Duration, 18 FC [41 PDT/31 MDT, 508 M.Eva] {Pet: 5 PDT/5 MDT, 4 Regen}
    
    -- main=gear.Gada_ENH,            -- 18,  6,  6 [__/__, ___] {__/__, __}
    -- head="Azimuth Hood +3",        -- __, __, __ [12/12, 136] {__/__,  5}
    -- body=gear.Telchine_ENH_body,   -- 12, 10, __ [__/__,  80] {__/__,  3}
    -- legs=gear.Telchine_ENH_legs,   -- __, 10, __ [__/__, 107] {__/__,  3}
    -- feet="Azimuth Gaiters +3",     -- __, __, __ [11/11, 168] {__/__, __}
    -- ear2="Azimuth Earring +2",     -- __, __, __ [ 7/ 7, ___] {__/__, __}
    -- Subjob                           144
    -- 202 Enh Skill, 56 Enh Duration, 24 FC [50 PDT/40 MDT, 528 M.Eva] {Pet: 5 PDT/5 MDT, 11 Regen}
  }

  sets.midcast.Stoneskin = {
    main="Idris",                     -- __ [__/__, ___] {25/25, __}
    sub="Genmei Shield",              -- __ [10/__, ___] {__/__, __}
    range=empty,
    ammo="Staunch Tathlum +1",        -- __ [ 3/ 3, ___] {__/__, __}; Status Resist +11
    head="Azimuth Hood +2",           -- __ [11/11, 126] {__/__,  4}
    body="Shamash Robe",              -- __ [10/__, 106] {__/__, __}
    hands="Geomancy Mitaines +3",     -- __ [ 3/__,  57] {13/13, __}
    feet="Azimuth Gaiters +2",        -- __ [10/10, 158] {__/__, __}
    neck="Nodens Gorget",             -- 30 [__/__, ___] {__/__, __}
    ear1="Earthcry Earring",          -- 10 [__/__, ___] {__/__, __}
    ear2="Hearty Earring",            -- __ [__/__, ___] {__/__, __}; Status Resist +5
    ring2="Defending Ring",           -- __ [10/10, ___] {__/__, __}
    -- 40 +Stoneskin [57 PDT/34 MDT, 447 M.Eva] {Pet: 38 PDT/38 MDT, 4 Regen}

    -- head="Azimuth Hood +3",        -- __ [12/12, 136] {__/__,  5}
    -- legs="Shedir Seraweels",       -- 35 [__/__, ___] {__/__, __}
    -- feet="Azimuth Gaiters +3",     -- __ [11/11, 168] {__/__, __}
    -- back="Shadow Mantle",          -- __ [__/__, ___] {__/__, __}; Annul dmg
    -- ring1="Shadow Ring",           -- __ [__/__, ___] {__/__, __}; Annul dmg
    -- waist="Siegel Sash",           -- 20 [__/__, ___] {__/__, __}
    -- 95 +Stoneskin [59 PDT/36 MDT, 467 M.Eva] {Pet: 38 PDT/38 MDT, 5 Regen}
  }

  -- Ref Potency > Enh Duration %, Ref Duration
  sets.midcast.Refresh = set_combine(sets.midcast.EnhancingDuration, {
    -- head="Amalric Coif +1",  --  2, __, __
    -- 2 Ref Potency, 72 Enh Duration%, 0 Ref Duration
  })

  sets.midcast.Refresh = {
    main=gear.Gada_ENH,               -- __, __,  6 [__/__, ___] {__/__, __}
    sub="Ammurapi Shield",            -- __, __, 10 [__/__, ___] {__/__, __}
    range=empty,
    ammo="Staunch Tathlum +1",        -- __, __, __ [ 3/ 3, ___] {__/__, __}
    head="Azimuth Hood +2",           -- __, __, __ [11/11, 126] {__/__,  4}
    body=gear.Telchine_ENH_body,      -- __, __, 10 [__/__,  80] {__/__, __}
    hands="Azimuth Gloves +2",        -- __, __, __ [11/11,  88] {__/__, __}
    legs=gear.Telchine_ENH_legs,      -- __, __, 10 [__/__, 107] {__/__, __}
    feet="Azimuth Gaiters +2",        -- __, __, __ [10/10, 158] {__/__, __}
    neck="Loricate Torque +1",        -- __, __, __ [ 6/ 6, ___] {__/__, __}
    ear1="Mimir Earring",             -- __, __, __ [__/__, ___] {__/__, __}
    ear2="Hearty Earring",            -- __, __, __ [__/__, ___] {__/__, __}
    ring1="Gelatinous Ring +1",       -- __, __, __ [ 7/-1, ___] {__/__, __}
    ring2="Defending Ring",           -- __, __, __ [10/10, ___] {__/__, __}
    back=gear.GEO_Idle_Cape,          -- __, __, __ [__/__,  30] {__/__, 15}
    waist="Embla Sash",               -- __, __, 10 [__/__, ___] {__/__, __}
    -- 0 Refresh Potency, 0 Refresh Duration, 46% Enh Duration [58 PDT/50 MDT, 589 M.Eva] {Pet: 0 PDT/0 MDT, 19 Regen}
    
    -- head="Amalric Coif +1",        --  2, __, __ [__/__,  86] {__/__, __}
    -- body=gear.Telchine_ENH_body,   -- __, __, 10 [__/__,  80] {__/__,  3}
    -- hands="Azimuth Gloves +3",     -- __, __, __ [12/12,  98] {__/__, __}
    -- legs=gear.Telchine_ENH_legs,   -- __, __, 10 [__/__, 107] {__/__,  3}
    -- feet="Inspirited Boots",       -- __, 15, __ [__/__, 118] {__/__, __}
    -- ear1="Genmei Earring",         -- __, __, __ [ 2/__, ___] {__/__, __}
    -- ear2="Azimuth Earring +2",     -- __, __, __ [ 7/ 7, ___] {__/__, __}
    -- 2 Refresh Potency, 15 Refresh Duration, 46% Enh Duration [47 PDT/37 MDT, 489 M.Eva] {Pet: 0 PDT/0 MDT, 21 Regen}
  }
  sets.midcast.RefreshSelf = set_combine(sets.midcast.Refresh, {
    back="Grapevine Cape",            -- __, 30, __ [__/__, ___] {__/__, __}
    waist="Gishdubar Sash",           -- __, 20, __ [__/__, ___] {__/__, __}
    -- 2 Refresh Potency, 65 Refresh Duration, 36% Enh Duration [47 PDT/37 MDT, 489 M.Eva] {Pet: 0 PDT/0 MDT, 6 Regen}
  })

  -- GEO cannot realistically get to 355 enh skill for +2 aquaveil, so don't try
  -- Focus on Aquaveil+ gear and defensive stats
  sets.midcast.Aquaveil = {
    main="Idris",                     -- __, __ [__/__, ___] {25/25, __}
    sub="Ammurapi Shield",            -- __, 10 [__/__, ___] {__/__, __}
    range="Dunna",                    -- __, __ [__/__, ___] { 5/ 5, __}
    ammo=empty,
    head="Azimuth Hood +2",           -- __, __ [11/11, 126] {__/__,  4}
    body=gear.Telchine_ENH_body,      -- __, 10 [__/__,  80] {__/__,  3}
    hands="Regal Cuffs",              --  2, __ [__/__,  53] {__/__, __}
    legs=gear.Nyame_B_legs,           -- __, __ [ 8/ 8, 150] {__/__, __}
    feet="Azimuth Gaiters +2",        -- __, __ [10/10, 158] {__/__, __}
    neck="Loricate Torque +1",        -- __, __ [ 6/ 6, ___] {__/__, __}
    ear2="Hearty Earring",            -- __, __ [__/__, ___] {__/__, __}
    ring1="Gelatinous Ring +1",       -- __, __ [ 7/-1, ___] {__/__, __}
    ring2="Defending Ring",           -- __, __ [10/10, ___] {__/__, __}
    back=gear.GEO_FC_Cape,            -- __, __ [10/__, ___] {__/__, __}
    waist="Embla Sash",               -- __, 10 [__/__, ___] {__/__, __}
    -- Base                               1
    -- 3 Aquaveil, 30% Enh Duration [62 PDT/44 MDT, 567 M.Eva] {Pet: 30 PDT/30 MDT, 7 Regen}

    -- main="Vadose Rod",             --  1, __ [__/__, ___] {__/__, __}
    -- head="Amalric Coif +1",        --  2, __ [__/__,  86] {__/__, __}
    -- legs="Shedir Seraweels",       --  1, __ [__/__, ___] {__/__, __}
    -- feet="Azimuth Gaiters +3",     -- __, __ [11/11, 168] {__/__, __}
    -- ear1="Genmei Earring",         -- __, __ [ 2/__, ___] {__/__, __}
    -- ear2="Azimuth Earring +2",     -- __, __ [ 7/ 7, ___] {__/__, __}
    -- waist="Emphatikos Rope",       --  1, __ [__/__, ___] {__/__, __}
    -- Base                               1
    -- 8 Aquaveil, 20% Enh Duration [53 PDT/33 MDT, 387 M.Eva] {Pet: 5 PDT/5 MDT, 3 Regen}
  }

  -- Protect+ gear, enh duration, conserve mp
  sets.midcast.Protect = {
    main=gear.Gada_ENH,               --  6, __ [__/__, ___] {__/__, __}
    sub="Ammurapi Shield",            -- 10, __ [__/__, ___] {__/__, __}
    range=empty,
    ammo="Pemphredo Tathlum",         -- __,  4 [__/__, ___] {__/__, __}
    head="Azimuth Hood +2",           -- __, __ [11/11, 126] {__/__,  4}
    body=gear.Telchine_ENH_body,      -- 10, __ [__/__,  80] {__/__, __}
    hands=gear.Telchine_ENH_hands,    -- 10, __ [__/__,  37] {__/__, __}
    legs=gear.Telchine_ENH_legs,      -- 10, __ [__/__, 107] {__/__, __}
    feet="Azimuth Gaiters +2",        -- __, __ [10/10, 158] {__/__, __}
    neck="Bagua Charm +1",            -- __, __ [__/__, ___] {__/__, __}; Luopan Duration +20%
    ring1="Mephitas's Ring +1",       -- __, 15 [__/__, ___] {__/__, __}
    ring2="Defending Ring",           -- __, __ [10/10, ___] {__/__, __}
    back=gear.GEO_FC_Cape,            -- __, __ [10/__, ___] {__/__, __}
    waist="Embla Sash",               -- 10, __ [__/__, ___] {__/__, __}
    -- Base                              __, 43
    -- 56 Enh Duration, 62 Conserve MP [41 PDT/31 MDT, 508 M.Eva] {Pet: 0 PDT/0 MDT, 4 Regen}

    -- head="Azimuth Hood +3",        -- __, __ [12/12, 136] {__/__,  5}
    -- body=gear.Telchine_ENH_body,   -- 10, __ [__/__,  80] {__/__,  3}
    -- legs=gear.Telchine_ENH_legs,   -- 10, __ [__/__, 107] {__/__,  3}
    -- feet="Azimuth Gaiters +3",     -- __, __ [11/11, 168] {__/__, __}
    -- neck="Bagua Charm +2",         -- __, __ [__/__, ___] {__/__, __}; Luopan Duration +25%
    -- ear1="Brachyura Earring",      -- __, __ [__/__, ___] {__/__, __}; Enhance Protect/Shell
    -- ear2="Azimuth Earring +2",     -- __, __ [ 7/ 7, ___] {__/__, __}
    -- Base                              __, 43
    -- 56 Enh Duration, 62 Conserve MP [50 PDT/40 MDT, 528 M.Eva] {Pet: 5 PDT/5 MDT, 11 Regen}
  }
  sets.midcast.Protectra = set_combine(sets.midcast.Protect, {})
  -- Shell+ gear, enh duration, conserve mp
  sets.midcast.Shell = set_combine(sets.midcast.Protect, {})
  sets.midcast.Shellra = set_combine(sets.midcast.Protect, {})


  --------------------------------------
  -- Idle/resting/etc sets
  --------------------------------------

  -- Overlaid when MP is needed
  sets.passive_refresh_sub50 = {
    waist="Fucho-no-obi",
  }

  -- When luopan is not existing
  sets.idle = {
    main="Daybreak",                --  1 [__/__,  30] {__/__, __}
    sub="Genmei Shield",            -- __ [10/__, ___] {__/__, __}
    range=empty,                    -- __ [__/__, ___] {__/__, __}
    ammo="Staunch Tathlum +1",      -- __ [ 3/ 3, ___] {__/__, __}; Status Resist+11
    head="Azimuth Hood +2",         -- __ [11/11, 126] {__/__,  4}
    body="Shamash Robe",            --  3 [10/__, 106] {__/__, __}; Resist Silence+90
    hands="Bagua Mitaines +1",      --  1 [__/__,  37] {__/__, __}
    legs="Assiduity Pants +1",      --  2 [__/__, 107] {__/__, __}
    feet="Volte Gaiters",           --  1 [__/__, 142] {__/__, __}; Refresh Merlinic good alt
    neck="Loricate Torque +1",      -- __ [ 6/ 6, ___] {__/__, __}
    ear1="Hearty Earring",          -- __ [__/__, ___] {__/__, __}; Resist All Status+5
    ear2="Etiolation Earring",      -- __ [__/ 3, ___] {__/__, __}; Resist Silence+15
    ring1="Stikini Ring +1",        --  1 [__/__, ___] {__/__, __}
    ring2="Stikini Ring +1",        --  1 [__/__, ___] {__/__, __}
    back=gear.GEO_Nuke_Cape,        -- __ [10/__, ___] {__/__, __}
    waist="Carrier's Sash",         -- __ [__/__, ___] {__/__, __}; Ele resist+15
    -- 10 Refresh [50 PDT/23 MDT, 548 M.Eva] {Pet: 0 PDT/0 MDT, 4 Regen}

    -- head="Azimuth Hood +3",      -- __ [12/12, 136] {__/__,  5}
    -- 11 Refresh [51 PDT/24 MDT, 578 M.Eva] {Pet: 0 PDT/0 MDT, 5 Regen}
    
    -- main="Bhima",                --  3 [__/__, ___] {__/__, __}
    -- sub="Genmei Shield",         -- __ [10/__, ___] {__/__, __}
    -- range=empty,                 -- __ [__/__, ___] {__/__, __}
    -- ammo="Staunch Tathlum +1",   -- __ [ 3/ 3, ___] {__/__, __}; Status Resist+11
    -- head="Azimuth Hood +3",      -- __ [12/12, 136] {__/__,  5}
    -- body="Shamash Robe",         --  3 [10/__, 106] {__/__, __}; Resist Silence+90
    -- hands="Bagua Mitaines +3",   --  2 [__/__,  57] {__/__, __}
    -- legs="Assiduity Pants +1",   --  2 [__/__, 107] {__/__, __}
    -- feet="Volte Gaiters",        --  1 [__/__, 142] {__/__, __}; Refresh Merlinic good alt
    -- neck="Loricate Torque +1",   -- __ [ 6/ 6, ___] {__/__, __}
    -- ear1="Hearty Earring",       -- __ [__/__, ___] {__/__, __}; Resist All Status+5
    -- ear2="Etiolation Earring",   -- __ [__/ 3, ___] {__/__, __}; Resist Silence+15
    -- ring1="Stikini Ring +1",     --  1 [__/__, ___] {__/__, __}
    -- ring2="Stikini Ring +1",     --  1 [__/__, ___] {__/__, __}
    -- back=gear.GEO_Nuke_Cape,     -- __ [10/__, ___] {__/__, __}
    -- waist="Carrier's Sash",      -- __ [__/__, ___] {__/__, __}; Ele resist+15
    -- 13 Refresh [51 PDT/24 MDT, 548 M.Eva] {Pet: 0 PDT/0 MDT, 5 Regen}
  }

  -- When you need to be safe (disables move speed gear)
  sets.idle.HeavyDef = set_combine(sets.idle, {})

  -- Pet -38% DT is needed in order to cap at -87.5% (has innate -50% DT)
  sets.idle.Pet = {
    main="Idris",                   -- __ [__/__, ___] {25/25, __}
    sub="Genmei Shield",            -- __ [10/__, ___] {__/__, __}
    range=empty,
    ammo="Staunch Tathlum +1",      -- __ [ 3/ 3, ___] {__/__, __}; Status Resist+11
    head="Azimuth Hood +2",         -- __ [11/11, 126] {__/__,  4}
    body="Shamash Robe",            --  3 [10/__, 106] {__/__, __}; Resist Silence+90
    hands="Geomancy Mitaines +3",   -- __ [ 3/__,  57] {13/13, __}
    legs="Assiduity Pants +1",      --  2 [__/__, 107] {__/__, __}
    feet="Bagua Sandals +1",        -- __ [__/__, 107] {__/__,  3}
    neck="Bagua Charm +1",          -- __ [__/__, ___] {__/__, __}; Absorb Dmg+8
    ear2="Hearty Earring",          -- __ [__/__, ___] {__/__, __}; Status Resist+5
    ring1="Stikini Ring +1",        --  1 [__/__, ___] {__/__, __}
    ring2="Defending Ring",         -- __ [10/10, ___] {__/__, __}
    back=gear.GEO_Idle_Cape,        -- __ [__/__,  30] {__/__, 15}
    waist="Isa Belt",               -- __ [__/__, ___] { 3/ 3,  1}; Prefer refresh if it existed
    -- 6 Refresh [47 PDT/24 MDT, 533 M.Eva] {Pet: 41 PDT/41 MDT, 23 Regen}

    -- head="Azimuth Hood +3",      -- __ [12/12, 136] {__/__,  5}
    -- feet="Bagua Sandals +3",     -- __ [__/__, 127] {__/__,  5}
    -- neck="Bagua Charm +2",       -- __ [__/__, ___] {__/__, __}; Absorb Dmg+10
    -- ear1="Genmei Earring",       -- __ [ 2/__, ___] {__/__, __}
    -- 6 Refresh [50 PDT/25 MDT, 563 M.Eva] {Pet: 41 PDT/41 MDT, 26 Regen}
  }

  sets.idle.HeavyDef.Pet = set_combine(sets.idle.Pet, {})

  -- Handle refresh
  sets.idle.Refresh = set_combine(sets.idle, {})
  sets.idle.RefreshSub50 = set_combine(sets.idle, sets.passive_refresh_sub50)
  sets.idle.Pet.Refresh = set_combine(sets.idle.Pet, {})
  sets.idle.Pet.RefreshSub50 = set_combine(sets.idle.Pet, sets.passive_refresh_sub50)

  sets.idle.HeavyDef.Refresh = set_combine(sets.idle.HeavyDef, {})
  sets.idle.HeavyDef.RefreshSub50 = set_combine(sets.idle.HeavyDef, {})
  sets.idle.HeavyDef.Pet.Refresh = set_combine(sets.idle.HeavyDef.Pet, {})
  sets.idle.HeavyDef.Pet.RefreshSub50 = set_combine(sets.idle.HeavyDef.Pet, {})

  sets.idle.Weak = set_combine(sets.idle.HeavyDef.Pet, {})
  
  sets.resting = set_combine(sets.idle.HeavyDef.Pet, {
    main="Chatoyant Staff",
    sub="Khonsu",
  })


  --------------------------------------
  -- Defense sets
  --------------------------------------

  sets.defense.PDT = set_combine(sets.idle.Pet, {})
  sets.defense.MDT = set_combine(sets.idle.Pet, {})


  --------------------------------------
  -- Engaged sets
  --------------------------------------

  -- Need 38 pet DT to cap
  -- Normal melee group, used when not weapon locked
  sets.engaged = {
    -- Assume White Tathlum         -- __,  2, __, __ [__/__, ___] {__/__, __}
    head=gear.Nyame_B_head,         -- 50, __,  5,  6 [ 7/ 7, 123] {__/__, __}
    body=gear.Nyame_B_body,         -- 40, __,  7,  3 [ 9/ 9, 139] {__/__, __}
    hands=gear.Nyame_B_hands,       -- 40, __,  5,  3 [ 7/ 7, 112] {__/__, __}
    legs=gear.Nyame_B_legs,         -- 40, __,  6,  5 [ 8/ 8, 150] {__/__, __}
    feet=gear.Nyame_B_feet,         -- 53, __,  5,  3 [ 7/ 7, 150] {__/__, __}
    neck="Bagua Charm +1",          -- __, __, __, __ [__/__, ___] {__/__, __}; Luopan absorb dmg
    ear2="Cessance Earring",        --  6,  3,  3, __ [__/__, ___] {__/__, __}
    ring2="Defending Ring",         -- __, __, __, __ [10/10, ___] {__/__, __}
    back=gear.GEO_Idle_Cape,        -- __, __, __, __ [__/__,  30] {__/__, 15}
    waist="Olseni Belt",            -- 20,  3, __, __ [__/__, ___] {__/__, __}
    -- 249 Acc, 8 Store TP, 31 DA, 20 Haste [48 PDT/48 MDT, 704 M.Eva] {Pet: 0 PDT/0 MDT, 15 Regen}

    -- Assume White Tathlum         -- __,  2, __, __ [__/__, ___] {__/__, __}
    -- head="Blistering Sallet +1", -- 53, __,  3,  8 [ 3/__,  53] {__/__, __}
    -- body=gear.Nyame_B_body,      -- 40, __,  7,  3 [ 9/ 9, 139] {__/__, __}
    -- hands="Gazu Bracelets +1",   -- 96, __, __,  5 [__/__,  43] {__/__, __}
    -- legs="Jhakri Slops +2",      -- 45,  9, __,  2 [__/__,  69] {__/__, __}
    -- feet=gear.Nyame_B_feet,      -- 53, __,  5,  3 [ 7/ 7, 150] {__/__, __}
    -- neck="Combatant's Torque",   -- __,  4, __, __ [__/__, ___] {__/__, __}; Skill+15
    -- ear1="Telos Earring",        -- 10,  5,  1, __ [__/__, ___] {__/__, __}
    -- ear2="Cessance Earring",     --  6,  3,  3, __ [__/__, ___] {__/__, __}
    -- ring1="Chirich Ring +1",     -- 10,  6, __, __ [__/__, ___] {__/__, __}
    -- ring2="Chirich Ring +1",     -- 10,  6, __, __ [__/__, ___] {__/__, __}
    -- back=gear.GEO_Idle_Cape,     -- __, __, __, __ [__/__,  30] {__/__, 15}
    -- waist="Goading Belt",        -- __,  5, __,  5 [__/__, ___] {__/__, __}
    -- 323 Acc, 40 Store TP, 19 DA, 26 Haste [19 PDT/16 MDT, 484 M.Eva] {Pet: 0 PDT/0 MDT, 15 Regen}
  }
  sets.engaged.Safe = {
    -- Assume Dunna                 -- __, __, __, __ [__/__, ___] { 5/ 5, __}
    head="Azimuth Hood +2",         -- 51, __, __,  6 [11/11, 126] {__/__,  4}
    body=gear.Nyame_B_body,         -- 40, __,  7,  3 [ 9/ 9, 139] {__/__, __}
    hands="Geomancy Mitaines +3",   -- __, __, __,  3 [ 3/__,  57] {13/13, __}
    legs=gear.Nyame_B_legs,         -- 40, __,  6,  5 [ 8/ 8, 150] {__/__, __}
    feet="Azimuth Gaiters +2",      -- 50, __, __,  3 [10/10, 158] {__/__, __}
    neck="Bagua Charm +1",          -- __, __, __, __ [__/__, ___] {__/__, __}; Luopan absorb dmg
    ear2="Cessance Earring",        --  6,  3,  3, __ [__/__, ___] {__/__, __}
    back=gear.GEO_Idle_Cape,        -- __, __, __, __ [__/__,  30] {__/__, 15}
    waist="Olseni Belt",            -- 20,  3, __, __ [__/__, ___] {__/__, __}
    -- 251 Acc, 20 Store TP, 16 DA, 20 Haste [50 PDT/47 MDT, 680 M.Eva] {Pet: 18 PDT/18 MDT, 20 Regen}
    
    -- Assume Dunna                 -- __, __, __, __ [__/__, ___] { 5/ 5, __}
    -- head="Azimuth Hood +3",      -- 61, __, __,  6 [12/12, 136] {__/__,  5}
    -- body=gear.Nyame_B_body,      -- 40, __,  7,  3 [ 9/ 9, 139] {__/__, __}
    -- hands="Geomancy Mitaines +3",-- __, __, __,  3 [ 3/__,  57] {13/13, __}
    -- legs=gear.Nyame_B_legs,      -- 40, __,  6,  5 [ 8/ 8, 150] {__/__, __}
    -- feet="Azimuth Gaiters +3",   -- 60, __, __,  3 [11/11, 168] {__/__, __}
    -- neck="Bagua Charm +1",       -- __, __, __, __ [__/__, ___] {__/__, __}; Luopan absorb dmg
    -- ear1="Telos Earring",        -- 10,  5,  1, __ [__/__, ___] {__/__, __}
    -- ear2="Azimuth Earring +2",   -- __, __, __, __ [ 7/ 7, ___] {__/__, __}
    -- ring1="Chirich Ring +1",     -- 10,  6, __, __ [__/__, ___] {__/__, __}
    -- ring2="Chirich Ring +1",     -- 10,  6, __, __ [__/__, ___] {__/__, __}
    -- back=gear.GEO_Idle_Cape,     -- __, __, __, __ [__/__,  30] {__/__, 15}
    -- waist="Olseni Belt",         -- 20,  3, __, __ [__/__, ___] {__/__, __}
    -- 251 Acc, 20 Store TP, 14 DA, 20 Haste [50 PDT/47 MDT, 680 M.Eva] {Pet: 18 PDT/18 MDT, 20 Regen}
  }

  sets.engaged.Staff = {
    -- Assume Mpaca's Staff         -- 50, __, __, __ [__/__, ___] {__/__, __}
    -- Assume Khonsu                -- 30, __, __,  4 [ 6/ 6, ___] {__/__, __}
    -- Assume White Tathlum         -- __,  2, __, __ [__/__, ___] {__/__, __}
    head=gear.Nyame_B_head,         -- 50, __,  5,  6 [ 7/ 7, 123] {__/__, __}
    body=gear.Nyame_B_body,         -- 40, __,  7,  3 [ 9/ 9, 139] {__/__, __}
    hands=gear.Nyame_B_hands,       -- 40, __,  5,  3 [ 7/ 7, 112] {__/__, __}
    legs=gear.Nyame_B_legs,         -- 40, __,  6,  5 [ 8/ 8, 150] {__/__, __}
    feet=gear.Nyame_B_feet,         -- 53, __,  5,  3 [ 7/ 7, 150] {__/__, __}
    neck="Bagua Charm +1",          -- __, __, __, __ [__/__, ___] {__/__, __}; Luopan absorb dmg
    ear2="Cessance Earring",        --  6,  3,  3, __ [__/__, ___] {__/__, __}
    ring2="Defending Ring",         -- __, __, __, __ [10/10, ___] {__/__, __}
    back=gear.GEO_Idle_Cape,        -- __, __, __, __ [__/__,  30] {__/__, 15}
    waist="Olseni Belt",            -- 20,  3, __, __ [__/__, ___] {__/__, __}
    -- 329 Acc, 8 Store TP, 31 DA, 24 Haste [54 PDT/54 MDT, 704 M.Eva] {Pet: 0 PDT/0 MDT, 15 Regen}

    -- Assume Mpaca's Staff         -- 50, __, __, __ [__/__, ___] {__/__, __}
    -- Assume Khonsu                -- 30, __, __,  4 [ 6/ 6, ___] {__/__, __}
    -- Assume White Tathlum         -- __,  2, __, __ [__/__, ___] {__/__, __}
    -- head="Blistering Sallet +1", -- 53, __,  3,  8 [ 3/__,  53] {__/__, __}
    -- body=gear.Nyame_B_body,      -- 40, __,  7,  3 [ 9/ 9, 139] {__/__, __}
    -- hands="Gazu Bracelets +1",   -- 96, __, __,  5 [__/__,  43] {__/__, __}
    -- legs="Jhakri Slops +2",      -- 45,  9, __,  2 [__/__,  69] {__/__, __}
    -- feet=gear.Nyame_B_feet,      -- 53, __,  5,  3 [ 7/ 7, 150] {__/__, __}
    -- neck="Combatant's Torque",   -- __,  4, __, __ [__/__, ___] {__/__, __}; Skill+15
    -- ear1="Telos Earring",        -- 10,  5,  1, __ [__/__, ___] {__/__, __}
    -- ear2="Cessance Earring",     --  6,  3,  3, __ [__/__, ___] {__/__, __}
    -- ring1="Chirich Ring +1",     -- 10,  6, __, __ [__/__, ___] {__/__, __}
    -- ring2="Chirich Ring +1",     -- 10,  6, __, __ [__/__, ___] {__/__, __}
    -- back=gear.GEO_Idle_Cape,     -- __, __, __, __ [__/__,  30] {__/__, 15}
    -- waist="Olseni Belt",         -- 20,  3, __, __ [__/__, ___] {__/__, __}
    -- 423 Acc, 38 Store TP, 19 DA, 25 Haste [25 PDT/22 MDT, 484 M.Eva] {Pet: 0 PDT/0 MDT, 15 Regen}
  }
  sets.engaged.Staff.Safe = {
    -- Assume Mpaca's Staff         -- 50, __, __, __ [__/__, ___] {__/__, __}
    -- Assume Khonsu                -- 30, __, __,  4 [ 6/ 6, ___] {__/__, __}
    -- Assume Dunna                 -- __, __, __, __ [__/__, ___] { 5/ 5, __}
    head=gear.Nyame_B_head,         -- 50, __,  5,  6 [ 7/ 7, 123] {__/__, __}
    body=gear.Nyame_B_body,         -- 40, __,  7,  3 [ 9/ 9, 139] {__/__, __}
    hands="Geomancy Mitaines +3",   -- __, __, __,  3 [ 3/__,  57] {13/13, __}
    legs=gear.Nyame_B_legs,         -- 40, __,  6,  5 [ 8/ 8, 150] {__/__, __}
    feet=gear.Nyame_B_feet,         -- 53, __,  5,  3 [ 7/ 7, 150] {__/__, __}
    neck="Bagua Charm +1",          -- __, __, __, __ [__/__, ___] {__/__, __}; Luopan absorb dmg
    ear2="Cessance Earring",        --  6,  3,  3, __ [__/__, ___] {__/__, __}
    ring1="Defending Ring",         -- __, __, __, __ [10/10, ___] {__/__, __}
    back=gear.GEO_Idle_Cape,        -- __, __, __, __ [__/__,  30] {__/__, 15}
    waist="Olseni Belt",            -- 20,  3, __, __ [__/__, ___] {__/__, __}
    -- 289 Acc, 6 Store TP, 26 DA, 24 Haste [50 PDT/47 MDT, 649 M.Eva] {Pet: 18 PDT/18 MDT, 15 Regen}

    -- Assume Mpaca's Staff         -- 50, __, __, __ [__/__, ___] {__/__, __}
    -- Assume Khonsu                -- 30, __, __,  4 [ 6/ 6, ___] {__/__, __}
    -- Assume Dunna                 -- __, __, __, __ [__/__, ___] { 5/ 5, __}
    -- head=gear.Nyame_B_head,      -- 50, __,  5,  6 [ 7/ 7, 123] {__/__, __}
    -- body=gear.Nyame_B_body,      -- 40, __,  7,  3 [ 9/ 9, 139] {__/__, __}
    -- hands="Geomancy Mitaines +3",-- __, __, __,  3 [ 3/__,  57] {13/13, __}
    -- legs=gear.Nyame_B_legs,      -- 40, __,  6,  5 [ 8/ 8, 150] {__/__, __}
    -- feet=gear.Nyame_B_feet,      -- 53, __,  5,  3 [ 7/ 7, 150] {__/__, __}
    -- neck="Bagua Charm +1",       -- __, __, __, __ [__/__, ___] {__/__, __}; Luopan absorb dmg
    -- ear1="Telos Earring",        -- 10,  5,  1, __ [__/__, ___] {__/__, __}
    -- ear2="Azimuth Earring +2",   -- __, __, __, __ [ 7/ 7, ___] {__/__, __}
    -- ring1="Chirich Ring +1",     -- 10,  6, __, __ [__/__, ___] {__/__, __}
    -- ring2="Chirich Ring +1",     -- 10,  6, __, __ [__/__, ___] {__/__, __}
    -- back=gear.GEO_Idle_Cape,     -- __, __, __, __ [__/__,  30] {__/__, 15}
    -- waist="Olseni Belt",         -- 20,  3, __, __ [__/__, ___] {__/__, __}
    -- 313 Acc, 20 Store TP, 24 DA, 24 Haste [47 PDT/44 MDT, 619 M.Eva] {Pet: 18 PDT/18 MDT, 15 Regen}
  }

  sets.engaged.Maxentius = {
    -- Assume Maxentius             -- 40, __, __, __ [__/__, ___] {__/__, __}
    -- Assume Genmei Shield         -- 15, __, __, __ [10/__, ___] {__/__, __}
    -- Assume White Tathlum         -- __,  2, __, __ [__/__, ___] {__/__, __}
    head=gear.Nyame_B_head,         -- 50, __,  5,  6 [ 7/ 7, 123] {__/__, __}
    body=gear.Nyame_B_body,         -- 40, __,  7,  3 [ 9/ 9, 139] {__/__, __}
    hands=gear.Nyame_B_hands,       -- 40, __,  5,  3 [ 7/ 7, 112] {__/__, __}
    legs=gear.Nyame_B_legs,         -- 40, __,  6,  5 [ 8/ 8, 150] {__/__, __}
    feet=gear.Nyame_B_feet,         -- 53, __,  5,  3 [ 7/ 7, 150] {__/__, __}
    neck="Bagua Charm +1",          -- __, __, __, __ [__/__, ___] {__/__, __}; Luopan absorb dmg
    ear2="Cessance Earring",        --  6,  3,  3, __ [__/__, ___] {__/__, __}
    back=gear.GEO_Idle_Cape,        -- __, __, __, __ [__/__,  30] {__/__, 15}
    waist="Olseni Belt",            -- 20,  3, __, __ [__/__, ___] {__/__, __}
    -- 304 Acc, 8 Store TP, 31 DA, 20 Haste [48 PDT/38 MDT, 704 M.Eva] {Pet: 0 PDT/0 MDT, 15 Regen}

    -- Assume Maxentius             -- 40, __, __, __ [__/__, ___] {__/__, __}
    -- Assume Genmei Shield         -- 15, __, __, __ [10/__, ___] {__/__, __}
    -- Assume White Tathlum         -- __,  2, __, __ [__/__, ___] {__/__, __}
    -- head="Blistering Sallet +1", -- 53, __,  3,  8 [ 3/__,  53] {__/__, __}
    -- body=gear.Nyame_B_body,      -- 40, __,  7,  3 [ 9/ 9, 139] {__/__, __}
    -- hands="Gazu Bracelets +1",   -- 96, __, __,  5 [__/__,  43] {__/__, __}
    -- legs="Jhakri Slops +2",      -- 45,  9, __,  2 [__/__,  69] {__/__, __}
    -- feet=gear.Nyame_B_feet,      -- 53, __,  5,  3 [ 7/ 7, 150] {__/__, __}
    -- neck="Combatant's Torque",   -- __,  4, __, __ [__/__, ___] {__/__, __}; Skill+15
    -- ear1="Telos Earring",        -- 10,  5,  1, __ [__/__, ___] {__/__, __}
    -- ear2="Cessance Earring",     --  6,  3,  3, __ [__/__, ___] {__/__, __}
    -- ring1="Chirich Ring +1",     -- 10,  6, __, __ [__/__, ___] {__/__, __}
    -- ring2="Chirich Ring +1",     -- 10,  6, __, __ [__/__, ___] {__/__, __}
    -- back=gear.GEO_Idle_Cape,     -- __, __, __, __ [__/__,  30] {__/__, 15}
    -- waist="Goading Belt",        -- __,  5, __,  5 [__/__, ___] {__/__, __}
    -- 378 Acc, 40 Store TP, 19 DA, 26 Haste [29 PDT/16 MDT, 484 M.Eva] {Pet: 0 PDT/0 MDT, 15 Regen}
  }
  sets.engaged.Maxentius.Safe = {
    -- Assume Maxentius             -- 40, __, __, __ [__/__, ___] {__/__, __}
    -- Assume Genmei Shield         -- 15, __, __, __ [10/__, ___] {__/__, __}
    -- Assume Dunna                 -- __, __, __, __ [__/__, ___] { 5/ 5, __}
    head=gear.Nyame_B_head,         -- 50, __,  5,  6 [ 7/ 7, 123] {__/__, __}
    body=gear.Nyame_B_body,         -- 40, __,  7,  3 [ 9/ 9, 139] {__/__, __}
    hands="Geomancy Mitaines +3",   -- __, __, __,  3 [ 3/__,  57] {13/13, __}
    legs=gear.Nyame_B_legs,         -- 40, __,  6,  5 [ 8/ 8, 150] {__/__, __}
    feet=gear.Nyame_B_feet,         -- 53, __,  5,  3 [ 7/ 7, 150] {__/__, __}
    neck="Bagua Charm +1",          -- __, __, __, __ [__/__, ___] {__/__, __}; Luopan absorb dmg
    ear2="Cessance Earring",        --  6,  3,  3, __ [__/__, ___] {__/__, __}
    ring1="Defending Ring",         -- __, __, __, __ [10/10, ___] {__/__, __}
    back=gear.GEO_Idle_Cape,        -- __, __, __, __ [__/__,  30] {__/__, 15}
    waist="Olseni Belt",            -- 20,  3, __, __ [__/__, ___] {__/__, __}
    -- 264 Acc, 6 Store TP, 26 DA, 20 Haste [54 PDT/41 MDT, 649 M.Eva] {Pet: 18 PDT/18 MDT, 15 Regen}

    -- Assume Maxentius             -- 40, __, __, __ [__/__, ___] {__/__, __}
    -- Assume Genmei Shield         -- 15, __, __, __ [10/__, ___] {__/__, __}
    -- Assume Dunna                 -- __, __, __, __ [__/__, ___] { 5/ 5, __}
    -- head="Azimuth Hood +3",      -- 61, __, __,  6 [12/12, 136] {__/__,  5}
    -- body=gear.Nyame_B_body,      -- 40, __,  7,  3 [ 9/ 9, 139] {__/__, __}
    -- hands="Geomancy Mitaines +3",-- __, __, __,  3 [ 3/__,  57] {13/13, __}
    -- legs=gear.Nyame_B_legs,      -- 40, __,  6,  5 [ 8/ 8, 150] {__/__, __}
    -- feet="Azimuth Gaiters +3",   -- 60, __, __,  3 [11/11, 168] {__/__, __}
    -- neck="Bagua Charm +1",       -- __, __, __, __ [__/__, ___] {__/__, __}; Luopan absorb dmg
    -- ear1="Telos Earring",        -- 10,  5,  1, __ [__/__, ___] {__/__, __}
    -- ear2="Cessance Earring",     --  6,  3,  3, __ [__/__, ___] {__/__, __}
    -- ring1="Chirich Ring +1",     -- 10,  6, __, __ [__/__, ___] {__/__, __}
    -- ring2="Chirich Ring +1",     -- 10,  6, __, __ [__/__, ___] {__/__, __}
    -- back=gear.GEO_Idle_Cape,     -- __, __, __, __ [__/__,  30] {__/__, 15}
    -- waist="Goading Belt",        -- __,  5, __,  5 [__/__, ___] {__/__, __}
    -- 292 Acc, 25 Store TP, 17 DA, 25 Haste [53 PDT/40 MDT, 680 M.Eva] {Pet: 18 PDT/18 MDT, 20 Regen}
  }

  sets.engaged.Idris = {
    -- Assume Idris                 -- 30, __, __, __ [__/__, ___] {25/25, __}
    -- Assume Genmei Shield         -- 15, __, __, __ [10/__, ___] {__/__, __}
    -- Assume White Tathlum         -- __,  2, __, __ [__/__, ___] {__/__, __}
    head=gear.Nyame_B_head,         -- 50, __,  5,  6 [ 7/ 7, 123] {__/__, __}
    body=gear.Nyame_B_body,         -- 40, __,  7,  3 [ 9/ 9, 139] {__/__, __}
    hands=gear.Nyame_B_hands,       -- 40, __,  5,  3 [ 7/ 7, 112] {__/__, __}
    legs=gear.Nyame_B_legs,         -- 40, __,  6,  5 [ 8/ 8, 150] {__/__, __}
    feet=gear.Nyame_B_feet,         -- 53, __,  5,  3 [ 7/ 7, 150] {__/__, __}
    neck="Bagua Charm +1",          -- __, __, __, __ [__/__, ___] {__/__, __}; Luopan absorb dmg
    ear2="Cessance Earring",        --  6,  3,  3, __ [__/__, ___] {__/__, __}
    back=gear.GEO_Idle_Cape,        -- __, __, __, __ [__/__,  30] {__/__, 15}
    waist="Olseni Belt",            -- 20,  3, __, __ [__/__, ___] {__/__, __}
    -- 294 Acc, 8 Store TP, 31 DA, 20 Haste [48 PDT/38 MDT, 704 M.Eva] {Pet: 25 PDT/25 MDT, 15 Regen}

    -- Assume Idris                 -- 30, __, __, __ [__/__, ___] {25/25, __}
    -- Assume Genmei Shield         -- 15, __, __, __ [10/__, ___] {__/__, __}
    -- Assume White Tathlum         -- __,  2, __, __ [__/__, ___] {__/__, __}
    -- head="Blistering Sallet +1", -- 53, __,  3,  8 [ 3/__,  53] {__/__, __}
    -- body=gear.Nyame_B_body,      -- 40, __,  7,  3 [ 9/ 9, 139] {__/__, __}
    -- hands="Gazu Bracelets +1",   -- 96, __, __,  5 [__/__,  43] {__/__, __}
    -- legs="Jhakri Slops +2",      -- 45,  9, __,  2 [__/__,  69] {__/__, __}
    -- feet=gear.Nyame_B_feet,      -- 53, __,  5,  3 [ 7/ 7, 150] {__/__, __}
    -- neck="Combatant's Torque",   -- __,  4, __, __ [__/__, ___] {__/__, __}; Skill+15
    -- ear1="Telos Earring",        -- 10,  5,  1, __ [__/__, ___] {__/__, __}
    -- ear2="Cessance Earring",     --  6,  3,  3, __ [__/__, ___] {__/__, __}
    -- ring1="Chirich Ring +1",     -- 10,  6, __, __ [__/__, ___] {__/__, __}
    -- ring2="Chirich Ring +1",     -- 10,  6, __, __ [__/__, ___] {__/__, __}
    -- back=gear.GEO_Idle_Cape,     -- __, __, __, __ [__/__,  30] {__/__, 15}
    -- waist="Goading Belt",        -- __,  5, __,  5 [__/__, ___] {__/__, __}
    -- 368 Acc, 40 Store TP, 19 DA, 26 Haste [29 PDT/16 MDT, 484 M.Eva] {Pet: 25 PDT/25 MDT, 15 Regen}
  }
  sets.engaged.Idris.Safe = {
    -- Assume Idris                 -- 30, __, __, __ [__/__, ___] {25/25, __}
    -- Assume Genmei Shield         -- 15, __, __, __ [10/__, ___] {__/__, __}
    -- Assume White Tathlum         -- __,  2, __, __ [__/__, ___] {__/__, __}
    head=gear.Nyame_B_head,         -- 50, __,  5,  6 [ 7/ 7, 123] {__/__, __}
    body=gear.Nyame_B_body,         -- 40, __,  7,  3 [ 9/ 9, 139] {__/__, __}
    hands="Geomancy Mitaines +3",   -- __, __, __,  3 [ 3/__,  57] {13/13, __}
    legs=gear.Nyame_B_legs,         -- 40, __,  6,  5 [ 8/ 8, 150] {__/__, __}
    feet=gear.Nyame_B_feet,         -- 53, __,  5,  3 [ 7/ 7, 150] {__/__, __}
    neck="Bagua Charm +1",          -- __, __, __, __ [__/__, ___] {__/__, __}; Luopan absorb dmg
    ear2="Cessance Earring",        --  6,  3,  3, __ [__/__, ___] {__/__, __}
    back=gear.GEO_Idle_Cape,        -- __, __, __, __ [__/__,  30] {__/__, 15}
    waist="Olseni Belt",            -- 20,  3, __, __ [__/__, ___] {__/__, __}
    -- 254 Acc, 8 Store TP, 26 DA, 20 Haste [44 PDT/31 MDT, 649 M.Eva] {Pet: 38 PDT/38 MDT, 15 Regen}

    -- Assume Idris                 -- 30, __, __, __ [__/__, ___] {25/25, __}
    -- Assume Genmei Shield         -- 15, __, __, __ [10/__, ___] {__/__, __}
    -- Assume White Tathlum         -- __,  2, __, __ [__/__, ___] {__/__, __}
    -- head="Azimuth Hood +3",      -- 61, __, __,  6 [12/12, 136] {__/__,  5}
    -- body=gear.Nyame_B_body,      -- 40, __,  7,  3 [ 9/ 9, 139] {__/__, __}
    -- hands="Geomancy Mitaines +3",-- __, __, __,  3 [ 3/__,  57] {13/13, __}
    -- legs=gear.Nyame_B_legs,      -- 40, __,  6,  5 [ 8/ 8, 150] {__/__, __}
    -- feet="Azimuth Gaiters +3",   -- 60, __, __,  3 [11/11, 168] {__/__, __}
    -- neck="Bagua Charm +1",       -- __, __, __, __ [__/__, ___] {__/__, __}; Luopan absorb dmg
    -- ear1="Telos Earring",        -- 10,  5,  1, __ [__/__, ___] {__/__, __}
    -- ear2="Cessance Earring",     --  6,  3,  3, __ [__/__, ___] {__/__, __}
    -- ring1="Chirich Ring +1",     -- 10,  6, __, __ [__/__, ___] {__/__, __}
    -- ring2="Chirich Ring +1",     -- 10,  6, __, __ [__/__, ___] {__/__, __}
    -- back=gear.GEO_Idle_Cape,     -- __, __, __, __ [__/__,  30] {__/__, 15}
    -- waist="Goading Belt",        -- __,  5, __,  5 [__/__, ___] {__/__, __}
    -- 282 Acc, 27 Store TP, 17 DA, 25 Haste [53 PDT/40 MDT, 680 M.Eva] {Pet: 38 PDT/38 MDT, 20 Regen}
  }


  --------------------------------------
  -- Custom buff sets
  --------------------------------------

  -- Gear that converts elemental damage done to recover MP.
  sets.RecoverMP = {
    body="Seidr Cotehardie",
  }

  sets.buff.Sublimation = {
    waist="Embla Sash"
  }


  ------------------------------------------------------------------------------------------------
  ---------------------------------------- Special Sets ------------------------------------------
  ------------------------------------------------------------------------------------------------

  sets.Special = {}
  sets.Special.ElementalObi = {waist="Hachirin-no-Obi",}

  sets.buff.Doom = {
    -- neck="Nicander's Necklace", --20
    ring2="Eshmun's Ring", --20
    waist="Gishdubar Sash", --10
  }

  sets.Kiting = {
    ring1="Shneddick Ring",
  }
  sets.Kiting.Adoulin = {
    body="Councilor's Garb",
  }
  sets.CP = {
    back=gear.CP_Cape,
  }

  sets.WeaponSet = {}
  sets.WeaponSet['Staff'] = {
    main="Mpaca's Staff",
    sub="Khonsu",
    range=empty,
    ammo="White Tathlum",
  }
  sets.WeaponSet['Staff'].Safe = {
    main="Mpaca's Staff",
    sub="Khonsu",
    range="Dunna",
    ammo=empty,
  }
  sets.WeaponSet['Maxentius'] = {
    main="Maxentius",
    sub="Genmei Shield",
    range=empty,
    ammo="White Tathlum",
  }
  sets.WeaponSet['Maxentius'].Safe = {
    main="Maxentius",
    sub="Genmei Shield",
    range="Dunna",
    ammo=empty,
  }
  sets.WeaponSet['Idris'] = {
    main="Idris",
    sub="Genmei Shield",
    range=empty,
    ammo="White Tathlum",
  }
  sets.WeaponSet['Idris'].Safe = {
    main="Idris",
    sub="Genmei Shield",
    range=empty,
    ammo="White Tathlum",
  }
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

function filtered_action(spell)
end

function job_pretarget(spell, action, spellMap, eventArgs)
  if spell.type == 'Geomancy' then
    if spell.english:startswith('Indi') then
      if state.Buff.Entrust then
        if spell.target.type == 'SELF' then
          add_to_chat(167, 'Entrust active - You can\'t entrust yourself.')
          eventArgs.cancel = true
        end
      elseif spell.target.type ~= 'SELF' then
        if spell.target.raw == '<t>' then
          change_target('<me>')
        end
      end
    elseif spell.english:startswith('Geo') then
      if set.contains(spell.targets, 'Enemy') then
        if ((spell.target.type == 'PLAYER' and not spell.target.charmed) or (spell.target.type == 'NPC' and spell.target.in_party)) then
          eventArgs.cancel = true
        end
      elseif not ((spell.target.type == 'PLAYER' and not spell.target.charmed and spell.target.in_party) or (spell.target.type == 'NPC' and spell.target.in_party) or (spell.target.raw == '<stpt>' or spell.target.raw == '<stal>' or spell.target.raw == '<st>')) then
        change_target('<me>')
      end
    end
  end
end

function job_precast(spell, action, spellMap, eventArgs)
  silibs.precast_hook(spell, action, spellMap, eventArgs)
  ----------- Non-silibs content goes below this line -----------

  if spell.english:startswith('Geo-') and pet.isvalid then
    eventArgs.cancel = true
    windower.chat.input('/ja "Full Circle" <me>')
    windower.chat.input:schedule(1.3,'/ma "'..spell.english..'" '..spell.target.raw..'')
  end

  if spell.action_type ~= 'Magic' and buffactive.Bolster and (spell.english == 'Blaze of Glory' or spell.english == 'Ecliptic Attrition') then
    eventArgs.cancel = true
    add_to_chat(123,'Abort: Bolster maxes the strength of bubbles.')
  end
end

function job_post_precast(spell, action, spellMap, eventArgs)
  -- Handle belts for elemental WS
  if spell.type == 'WeaponSkill' then
    -- Use safe set depending on OffenseMode setting
    if state.OffenseMode.value == 'Safe' and sets.precast.WS[spell.name] and sets.precast.WS[spell.name].Safe then
      equip(sets.precast.WS[spell.name].Safe)
    end
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
  end

  -- If slot is locked, keep current equipment on
  if locked_neck then equip({ neck=player.equipment.neck }) end
  if locked_ear1 then equip({ ear1=player.equipment.ear1 }) end
  if locked_ear2 then equip({ ear2=player.equipment.ear2 }) end
  if locked_ring1 then equip({ ring1=player.equipment.ring1 }) end
  if locked_ring2 then equip({ ring2=player.equipment.ring2 }) end

  -- Always put this last in job_post_precast
  if in_battle_mode() then
    equip(select_weapons())
  end

  ----------- Non-silibs content goes above this line -----------
  silibs.post_precast_hook(spell, action, spellMap, eventArgs)
end

function job_midcast(spell, action, spellMap, eventArgs)
  silibs.midcast_hook(spell, action, spellMap, eventArgs)
  ----------- Non-silibs content goes below this line -----------
end

function job_post_midcast(spell, action, spellMap, eventArgs)
  if spell.skill == 'Elemental Magic' and default_spell_map ~= 'ElementalEnfeeble' and spell.english ~= 'Impact' then
    if state.MagicBurst.value and sets.midcast['Elemental Magic'].MB then
      equip(sets.midcast['Elemental Magic'].MB)
    end

    if sets.RecoverMP and state.RecoverMode.value ~= 'Never' and
        (state.RecoverMode.value == 'Always' or tonumber(state.RecoverMode.value:sub(1, -2)) > player.mpp) then
      equip(sets.RecoverMP)
    end
    
    -- Handle belts for elemental damage
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

  elseif spell.skill == 'Geomancy' and state.Buff.Entrust and spell.english:startswith('Indi-') and sets.buff.Entrust then
    equip(sets.buff.Entrust)
  elseif spell.skill == 'Enhancing Magic' then
    -- If self targeted refresh
    if spellMap == 'Refresh' and spell.targets.Self and sets.midcast.RefreshSelf then
      equip(sets.midcast.RefreshSelf)
    end
  end

  -- If slot is locked, keep current equipment on
  if locked_neck then equip({ neck=player.equipment.neck }) end
  if locked_ear1 then equip({ ear1=player.equipment.ear1 }) end
  if locked_ear2 then equip({ ear2=player.equipment.ear2 }) end
  if locked_ring1 then equip({ ring1=player.equipment.ring1 }) end
  if locked_ring2 then equip({ ring2=player.equipment.ring2 }) end

  -- Always put this last in job_post_midcast
  if in_battle_mode() and not spell.type == 'Geomancy' then
    equip(select_weapons())
  end

  ----------- Non-silibs content goes above this line -----------
  silibs.post_midcast_hook(spell, action, spellMap, eventArgs)
end

function job_aftercast(spell, action, spellMap, eventArgs)
  silibs.aftercast_hook(spell, action, spellMap, eventArgs)
  ----------- Non-silibs content goes below this line -----------
  if not spell.interrupted then
    if spell.english:startswith('Indi-') then
      send_command('@timers d "'..spell.target.name..': '..indi_timer..'"')
      indi_timer = spell.english
      if spell.target.type == 'SELF' then -- If not entrusted
        send_command('@timers c "'..spell.target.name..': '..indi_timer..'" '..indi_duration..' down spells/00136.png')
      else -- If entrusted
        send_command('@timers c "'..spell.target.name..': '..indi_timer..'" '..indi_entrust_duration..' down spells/00136.png')
      end
    elseif spell.english:startswith('Geo-') or spell.english == "Mending Halation" or spell.english == "Radial Arcana" then
      eventArgs.handled = true
    elseif spell.english == 'Sleep' or spell.english == 'Sleepga' then
      send_command('@timers c "'..spell.english..' ['..spell.target.name..']" 60 down spells/00220.png')
    elseif spell.english == 'Sleep II' or spell.english == 'Sleepga II' then
      send_command('@timers c "'..spell.english..' ['..spell.target.name..']" 90 down spells/00220.png')
    end
  end

  if in_battle_mode() then
    equip(select_weapons())
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
function job_buff_change(buff, gain)
end

-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------

function job_get_spell_map(spell, default_spell_map)
  if spell.action_type == 'Magic' then
    if default_spell_map == 'Cure' or default_spell_map == 'Curaga' then
      if (world.weather_element == 'Light' and not (get_weather_intensity() < 2 and world.weather_element == 'Dark'))
          or (world.day_element == 'Light' and not world.weather_element == 'Dark') then
        return 'CureWeather'
      else
        return 'CureNormal'
      end
    elseif spell.skill == "Enfeebling Magic" then
      if spell.english:startswith('Dia') then
        return "Dia"
      elseif spell.type == "WhiteMagic" or spell.english:startswith('Frazzle') or spell.english:startswith('Distract') then
        return 'MndEnfeebles'
      else
        return 'IntEnfeebles'
      end
    elseif spell.skill == 'Geomancy' then
      if spell.english:startswith('Indi') then
        return 'Indi'
      end
    end
  end
end

function customize_idle_set(idleSet)
  -- If not in DT mode put on move speed gear
  if state.IdleMode.current == 'Normal' and state.DefenseMode.value == 'None' and not classes.CustomIdleGroups:contains('Pet') then
    if classes.CustomIdleGroups:contains('Adoulin') then
      idleSet = set_combine(idleSet, sets.Kiting.Adoulin)
    else
      idleSet = set_combine(idleSet, sets.Kiting)
    end
  end

  if state.CP.current == 'on' then
    idleSet = set_combine(idleSet, sets.CP)
  end

  if buffactive['Sublimation: Activated'] then
    if sets.buff.Sublimation then
      idleSet = set_combine(idleSet, sets.buff.Sublimation)
    end
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

  if in_battle_mode() then
    idleSet = set_combine(idleSet, select_weapons())
  end

  return idleSet
end

function customize_melee_set(meleeSet)
  if state.CP.current == 'on' then
    meleeSet = set_combine(meleeSet, sets.CP)
  end

  -- If slot is locked to use no-swap gear, keep it equipped
  if locked_neck then meleeSet = set_combine(meleeSet, { neck=player.equipment.neck }) end
  if locked_ear1 then meleeSet = set_combine(meleeSet, { ear1=player.equipment.ear1 }) end
  if locked_ear2 then meleeSet = set_combine(meleeSet, { ear2=player.equipment.ear2 }) end
  if locked_ring1 then meleeSet = set_combine(meleeSet, { ring1=player.equipment.ring1 }) end
  if locked_ring2 then meleeSet = set_combine(meleeSet, { ring2=player.equipment.ring2 }) end

  if buffactive.Doom then
    meleeSet = set_combine(meleeSet, sets.buff.Doom)
  end

  if in_battle_mode() then
    meleeSet = set_combine(meleeSet, select_weapons())
  end

  return meleeSet
end

function customize_defense_set(defenseSet)
  if state.CP.current == 'on' then
    defenseSet = set_combine(defenseSet, sets.CP)
  end

  -- If slot is locked to use no-swap gear, keep it equipped
  if locked_neck then defenseSet = set_combine(defenseSet, { neck=player.equipment.neck }) end
  if locked_ear1 then defenseSet = set_combine(defenseSet, { ear1=player.equipment.ear1 }) end
  if locked_ear2 then defenseSet = set_combine(defenseSet, { ear2=player.equipment.ear2 }) end
  if locked_ring1 then defenseSet = set_combine(defenseSet, { ring1=player.equipment.ring1 }) end
  if locked_ring2 then defenseSet = set_combine(defenseSet, { ring2=player.equipment.ring2 }) end

  if buffactive.Doom then
    defenseSet = set_combine(defenseSet, sets.buff.Doom)
  end

  if in_battle_mode() then
    defenseSet = set_combine(defenseSet, select_weapons())
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

  local c_msg = state.CastingMode.value

  local d_msg = 'None'
  if state.DefenseMode.value ~= 'None' then
    d_msg = state.DefenseMode.value .. state[state.DefenseMode.value .. 'DefenseMode'].value
  end

  local i_msg = state.IdleMode.value
  if classes.CustomIdleGroups:contains('Pet') then
    i_msg = i_msg .. '/Pet'
  end

  local msg = ''
  if state.Kiting.value then
    msg = msg .. ' Kiting |'
  end

  add_to_chat(060, 'Magic: ' ..string.char(31,001)..c_msg.. string.char(31,002)..  ' |'
      ..string.char(31,004).. ' Defense: ' ..string.char(31,001)..d_msg.. string.char(31,002)..  ' |'
      ..string.char(31,008).. ' Idle: ' ..string.char(31,001)..i_msg.. string.char(31,002)..  ' |'
      ..string.char(31,002)..msg)

  eventArgs.handled = true
end

-- Called by the 'update' self-command, for common needs.
-- Set eventArgs.handled to true if we don't want automatic equipping of gear.
function job_handle_equipping_gear(playerStatus, eventArgs)
  check_gear()
  update_idle_groups()
end

-- Called by the 'update' self-command.
function update_idle_groups(cmdParams, eventArgs)
  local isRegening = classes.CustomIdleGroups:contains('Regen')
  local isRefreshing = classes.CustomIdleGroups:contains('Refresh')

  classes.CustomIdleGroups:clear()
  if player.status == 'Idle' then
    if pet.isvalid and pet.distance:sqrt() < 50 then
      classes.CustomIdleGroups:append('Pet')
    end
    
    if mp_jobs:contains(player.main_job) or mp_jobs:contains(player.sub_job) then
      if player.mpp < 50 then
        classes.CustomIdleGroups:append('RefreshSub50')
      elseif (isRefreshing==true and player.mpp < 100) or (isRefreshing==false and player.mpp < 85) then
        classes.CustomIdleGroups:append('Refresh')
      end
    end

    if world.zone == 'Eastern Adoulin' or world.zone == 'Western Adoulin' then
      classes.CustomIdleGroups:append('Adoulin')
    end
  end
end

-- Function that watches pet gain and loss.
function job_pet_change(pet, gain)
end

function job_self_command(cmdParams, eventArgs)
  silibs.self_command(cmdParams, eventArgs)
  ----------- Non-silibs content goes below this line -----------

  if cmdParams[1] == 'elemental' then
    handle_elemental(cmdParams)
    eventArgs.handled = true
  elseif cmdParams[1] == 'weaponset' then
    if cmdParams[2] == 'cycle' then
      cycle_weapons('forward')
    elseif cmdParams[2] == 'cycleback' then
      cycle_weapons('back')
    elseif cmdParams[2] == 'current' then
      cycle_weapons('current')
    elseif cmdParams[2] == 'reset' then
      cycle_weapons('reset')
    end
  elseif cmdParams[1] == 'test' then
    test()
  end

  if not midaction() then
    handle_equipping_gear(player.status)
  end
end

function get_custom_wsmode(spell, action, spellMap)
  local wsmode = ''

  if player.tp > 2900 then
    wsmode = wsmode..'MaxTP'
  end

  return wsmode
end

-- Handling Elemental spells within Gearswap.
-- Format: gs c elemental <nuke, helix, skillchain1, skillchain2, weather>
function handle_elemental(cmdParams)
  -- cmdParams[1] == 'elemental'
  -- cmdParams[2] == ability to use

  if not cmdParams[2] then
    add_to_chat(123,'Error: No elemental command given.')
    return
  end
  local command = cmdParams[2]:lower()

  if command == 'storm' then
    windower.chat.input('/ma "'..elements.storm_of[state.ElementalMode.value]..'"')
    return
  end

  local target = '<t>'
  if cmdParams[3] then
    if tonumber(cmdParams[3]) then
      target = cmdParams[3]
    else
      target = table.concat(cmdParams, ' ', 3)
      target = get_closest_mob_id_by_name(target) or '<t>'
    end
  end
  if command:contains('tier') then
    local spell_recasts = windower.ffxi.get_spell_recasts()
    local tierlist = {['tier1']='',['tier2']=' II',['tier3']=' III',['tier4']=' IV',['tier5']=' V',['tier6']=' VI'}

    windower.chat.input('/ma "'..elements.nuke_of[state.ElementalMode.value]..tierlist[command]..'" '..target..'')
  elseif command:contains('ara') then
    local spell_recasts = windower.ffxi.get_spell_recasts()
    local tierkey = {'ara3','ara2','ara'}
    local tierlist = {['ara3']='ra III',['ara2']='ra II',['ara']='ra'}
    if command == 'ara' then
      for i in ipairs(tierkey) do
        if actual_cost(get_spell_table_by_name(elements.nukera_of[state.ElementalMode.value]..''..tierlist[tierkey[i]]..'')) < player.mp then
          windower.chat.input('/ma "'..elements.nukera_of[state.ElementalMode.value]..''..tierlist[tierkey[i]]..'" '..target..'')
          return
        end
      end
    else
      windower.chat.input('/ma "'..elements.nukera_of[state.ElementalMode.value]..tierlist[command]..'" '..target..'')
    end
  else
    add_to_chat(123,'Unrecognized elemental command.')
  end
end

-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
  -- Default macro set/book: (set, book)
  if player.sub_job == 'SCH' then
    set_macro_page(3, 7)
  else
    set_macro_page(2, 7)
  end
end

function seconds_to_clock(seconds)
  local seconds = tonumber(seconds)

  if seconds <= 0 then
    return "00:00:00";
  else
    hours = string.format("%01.f", math.floor(seconds/3600));
    mins = string.format("%02.f", math.floor(seconds/60 - (hours*60)));
    secs = string.format("%02.f", math.floor(seconds - hours*3600 - mins *60));
    return hours..":"..mins..":"..secs
  end
end

function cycle_weapons(cycle_dir)
  if cycle_dir == 'forward' then
    state.WeaponSet:cycle()
  elseif cycle_dir == 'back' then
    state.WeaponSet:cycleback()
  elseif cycle_dir == 'reset' then
    state.WeaponSet:reset()
  end

  add_to_chat(141, 'Weapon Set to '..string.char(31,1)..state.WeaponSet.current)
  equip(sets.WeaponSet[state.WeaponSet.current])
end

function in_battle_mode()
  return state.WeaponSet.current ~= 'Casting'
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

function item_name_to_id(name)
  return (player.inventory[name] or player.wardrobe[name] or player.wardrobe2[name] or player.wardrobe3[name] or player.wardrobe4[name] or {id=nil}).id
end

function get_item_table(item)
  if item then
    local item_type = type(item)

    if item_type == 'string' then
      return res.items[item_name_to_id(item)] or nil
    elseif item_type == 'table' then
      return res.items[item_name_to_id(item.name)] or nil
    end
  else
    return nil
  end
end

function item_available(item)
  if player.inventory[item] or player.wardrobe[item] or player.wardrobe2[item] or player.wardrobe3[item] or player.wardrobe4[item] then
    return true
  else
    return false
  end
end

function select_weapons()
  if sets.WeaponSet[state.WeaponSet.current] then
    if state.OffenseMode.current == 'Safe' and sets.WeaponSet[state.WeaponSet.current].Safe then
      return sets.WeaponSet[state.WeaponSet.current].Safe
    else
      return sets.WeaponSet[state.WeaponSet.current]
    end
  else
    return {}
  end
end

function test()
end
