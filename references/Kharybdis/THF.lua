-- Original: Motenten / Modified: Arislan
-- Haste/DW Detection Requires Gearinfo Addon

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
--              [ CTRL+` ]          Cycle Treasure Hunter Mode
--              [ WIN+C ]           Toggle Capacity Points Mode
--  Weapons:    [ CTRL+W ]          Toggles Weapon Lock
--
--  Abilities:  [ ALT+` ]           Flee
--              [ CTRL+Numpad/ ]    Berserk
--              [ CTRL+Numpad* ]    Warcry
--              [ CTRL+Numpad- ]    Aggressor
--              [ CTRL+Numpad0 ]    Sneak Attack
--              [ CTRL+Numpad. ]    Trick Attack
--
--  Spells:     [ WIN+, ]           Utsusemi: Ichi
--              [ WIN+. ]           Utsusemi: Ni
--
--  WS:         [ CTRL+Numpad7 ]    Exenterator
--              [ CTRL+Numpad8 ]    Mandalic Stab
--              [ CTRL+Numpad4 ]    Evisceration
--              [ CTRL+Numpad5 ]    Rudra's Storm
--              [ CTRL+Numpad1 ]    Aeolian Edge
--
--
--              (Global-Binds.lua contains additional non-job-related keybinds)


-------------------------------------------------------------------------------------------------------------------
--  Custom Commands (preface with /console to use these in macros)
-------------------------------------------------------------------------------------------------------------------

--  gs c cycle treasuremode (set on ctrl-= by default): Cycles through the available treasure hunter modes.
--
--  TH Modes:  None                 Will never equip TH gear
--             Tag                  Will equip TH gear sufficient for initial contact with a mob (either melee,
--
--             SATA - Will equip TH gear sufficient for initial contact with a mob, and when using SATA
--             Fulltime - Will keep TH gear equipped fulltime


-------------------------------------------------------------------------------------------------------------------
-- Setup functions for this job.  Generally should not be modified.
-------------------------------------------------------------------------------------------------------------------

-- Initialization function for this job file.
function get_sets()
    mote_include_version = 2

    -- Load and initialize the include file.
    include('Mote-Include.lua')
    coroutine.schedule(function()
        send_command('gs c weaponset current')
    end, 5)
end


-- Setup vars that are user-independent.  state.Buff vars initialized here will automatically be tracked.
function job_setup()
    state.Buff['Sneak Attack'] = buffactive['sneak attack'] or false
    state.Buff['Trick Attack'] = buffactive['trick attack'] or false
    state.Buff['Feint'] = buffactive['feint'] or false
	state.WeaponLock = M(false, 'Weapon Lock')

    include('Mote-TreasureHunter')

    -- For th_action_check():
    -- JA IDs for actions that always have TH: Provoke, Animated Flourish
    info.default_ja_ids = S{35, 204}
    -- Unblinkable JA IDs for actions that always have TH: Quick/Box/Stutter Step, Desperate/Violent Flourish
    info.default_u_ja_ids = S{201, 202, 203, 205, 207}

    state.Ambush = M(false, 'Ambush')
    state.CP = M(false, "Capacity Points Mode")
    state.WeaponSet = M{['description']='Weapon Set', 'Normal', 'WhiteDmg', 'Naegling', 'NaeglingAcc', 'H2H', 'Staff', 'SoloCleaving', 'Cleaving'}
    state.RangedWeaponSet = M{['description']='Ranged Weapon Set', 'None', 'Throwing', 'Archery'}

    lockstyleset = 18
    
    DefaultAmmo = {
        ['Ullr'] = "Beryllium Arrow",
    }
    AccAmmo = {
        ['Ullr'] = "Beryllium Arrow",
    }
    WSAmmo = {
        ['Ullr'] = "Beryllium Arrow",
    }
    MagicAmmo = {
        ['Ullr'] = "Beryllium Arrow",
    }
end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
    state.OffenseMode:options('Normal', 'LowAcc', 'MidAcc', 'HighAcc', 'STP')
    state.HybridMode:options('Normal', 'DT')
    state.RangedMode:options('Normal', 'Acc')
    state.WeaponskillMode:options('Normal', 'Acc', 'LowBuff')
    state.IdleMode:options('Normal', 'DT', 'Refresh')

    send_command('bind ^` gs c cycle treasuremode')
    send_command('bind !` input /ja "Flee" <me>')
    send_command('bind %numpad0 gs c toggle Ambush')
    send_command('bind @w gs c toggle WeaponLock')
    send_command('bind @c gs c toggle CP')

    send_command('bind ^insert gs c weaponset cycle')
    send_command('bind ^delete gs c weaponset cycleback')
    send_command('bind ^home gs c rangedweaponset cycle')
    send_command('bind ^end gs c rangedweaponset cycleback')
  
    send_command('bind ^numpad7 input /ws "Exenterator" <t>')
    send_command('bind ^numpad8 input /ws "Mandalic Stab" <t>')
    send_command('bind ^numpad4 input /ws "Evisceration" <t>')
    send_command('bind ^numpad5 input /ws "Rudra\'s Storm" <t>')
    send_command('bind ^numpad1 input /ws "Aeolian Edge" <t>')
    send_command('bind ^numpad2 input /ws "Wasp Sting" <t>')
    send_command('bind ^numpad3 input /ws "Gust Slash" <t>')

    send_command('bind ^numpad0 input /ja "Sneak Attack" <me>')
    send_command('bind ^numpad. input /ja "Trick Attack" <me>')

    select_default_macro_book()
    set_lockstyle()

    state.Auto_Kite = M(false, 'Auto_Kite')
    Haste = 0
    DW_needed = 0
    DW = false
    moving = false
    update_combat_form()
    determine_haste_group()
end


-- Called when this job file is unloaded (eg: job change)
function user_unload()
    send_command('unbind ^`')
    send_command('unbind !`')
    send_command('unbind ^,')
    send_command('unbind numpad0')
    send_command('unbind @c')
    send_command('unbind @r')
    
    send_command('unbind ^insert')
    send_command('unbind ^delete')
    send_command('unbind ^home')
    send_command('unbind ^end')

    send_command('unbind ^numlock')
    send_command('unbind ^numpad/')
    send_command('unbind ^numpad*')
    send_command('unbind ^numpad-')
    send_command('unbind ^numpad7')
    send_command('unbind ^numpad8')
    send_command('unbind ^numpad4')
    send_command('unbind ^numpad5')
    send_command('unbind ^numpad1')
    send_command('unbind ^numpad2')
    send_command('unbind ^numpad3')
    send_command('unbind ^numpad0')
    send_command('unbind ^numpad.')

    send_command('unbind #`')
    send_command('unbind #1')
    send_command('unbind #2')
    send_command('unbind #3')
    send_command('unbind #4')
    send_command('unbind #5')
    send_command('unbind #6')
    send_command('unbind #7')
    send_command('unbind #8')
    send_command('unbind #9')
    send_command('unbind #0')
end


-- Define sets and vars used by this job file.
function init_gear_sets()

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Precast Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.TreasureHunter = {
        head="Volte Cap", --2
		hands="Plun. Armlets +1", -- 3
        legs="Volte Hose", --4
        feet="Skulk. Poulaines +1", --3
        waist="Chaac Belt", --1
        }

    sets.buff['Sneak Attack'] = {}
    sets.buff['Trick Attack'] = {}

    -- Actions we want to use to tag TH.
    sets.precast.Step = sets.TreasureHunter
    sets.precast.Flourish1 = sets.TreasureHunter
    sets.precast.JA.Provoke = sets.TreasureHunter


    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Precast Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    -- Precast sets to enhance JAs
    sets.precast.JA['Accomplice'] = {head="Skulker's Bonnet +1"}
    sets.precast.JA['Aura Steal'] = {head="Plun. Bonnet +3"}
    sets.precast.JA['Collaborator'] = set_combine(sets.TreasureHunter, {head="Skulker's Bonnet +1"})
    sets.precast.JA['Flee'] = {feet="Pill. Poulaines +1"}
    sets.precast.JA['Hide'] = {body="Pillager's Vest +3"}
    sets.precast.JA['Conspirator'] = set_combine(sets.TreasureHunter, {body="Skulker's Vest +1"})

    sets.precast.JA['Steal'] = {
        ammo="Barathrum",
        head="Plun. Bonnet +3",
        hands="Pillager's Armlets +1",
        feet="Pill. Poulaines +1",
        }

    sets.precast.JA['Despoil'] = {ammo="Barathrum", legs="Skulk. Culottes +1", feet="Skulk. Poulaines +1"}
    sets.precast.JA['Perfect Dodge'] = {hands="Plun. Armlets +1"}
    sets.precast.JA['Feint'] = {legs="Plun. Culottes +1"}
    --sets.precast.JA['Sneak Attack'] = sets.buff['Sneak Attack']
    --sets.precast.JA['Trick Attack'] = sets.buff['Trick Attack']

    sets.precast.Waltz = {
		ammo="Yamarang",
		head={ name="Herculean Helm", augments={'Accuracy+23','"Waltz" potency +10%','AGI+1','Attack+13',}},
		body="Gleti's Cuirass",
		hands={ name="Herculean Gloves", augments={'"Waltz" potency +10%','DEX+4','Accuracy+9','Attack+6',}},
		legs="Dashing Subligar",
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck={ name="Unmoving Collar +1", augments={'Path: A',}},
		waist="Flume Belt",
		left_ear="Eabani Earring",
		right_ear="Genmei Earring",
		left_ring="Supershear Ring",
		right_ring="Moonbeam Ring",
		back="Moonbeam Cape",
}

    sets.precast.Waltz['Healing Waltz'] = {}

    sets.precast.FC = {
        ammo="Sapience Orb",
        head=gear.Herc_MAB_head, --7
        body=gear.Taeon_FC_body, --9
        hands="Leyline Gloves", --8
        legs="Rawhide Trousers", --5
        feet=gear.Herc_MAB_feet, --2
        neck="Voltsurge Torque", --5
        ear1="Loquacious Earring", --2
        ear2="Enchntr. Earring +1", --2
        ring2="Weather. Ring +1", --6(4)
        }

    sets.precast.FC.Utsusemi = set_combine(sets.precast.FC, {
        body="Passion Jacket",
        ring1="Lebeche Ring",
        })

    ------------------------------------------------------------------------------------------------
    ------------------------------------- Weapon Skill Sets ----------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.precast.WS = {
        ammo="Aurgelmir Orb",
        head="Nyame Helm",
        body="Nyame Mail",
        hands="Nyame Gauntlets",
        legs="Nyame Flanchard",
        feet="Nyame Sollerets",
        neck="Fotia Gorget",
        ear1="Ishvara Earring",
        ear2="Moonshade Earring",
        ring1="Regal Ring",
        ring2="Epaminondas's Ring",
        back={ name="Toutatis's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Weapon skill damage +10%',}},
        waist="Fotia Belt",
        } -- default set

    sets.precast.WS.Acc = set_combine(sets.precast.WS, {
        ammo="C. Palug Stone",
        ear2="Telos Earring",
        })

    sets.precast.WS.Critical = {
        ammo="Yetshila +1",
        head="Pill. Bonnet +2",
        body="Gleti's Cuirass",
        }

    sets.precast.WS['Exenterator'] = set_combine(sets.precast.WS, {
        head="Gleti's Mask",
        body="Gleti's Cuirass",
        legs="Malignance Tights",
        feet="Plun. Poulaines +3",
        ear1="Sherida Earring",
        ear2="Telos Earring",
        ring2="Ilabrat Ring",
        })

    sets.precast.WS['Exenterator'].Acc = set_combine(sets.precast.WS['Exenterator'], {
        head="Dampening Tam",
        })

    sets.precast.WS['Evisceration'] = set_combine(sets.precast.WS, {
        ammo="Yetshila +1",
        head="Adhemar Bonnet +1",
        body="Gleti's Cuirass",
        hands="Adhemar Wrist. +1",
        legs="Gleti's Breeches",
        feet="Lustra. Leggings +1",
        ear1="Sherida Earring",
        ear2="Odr Earring",
        ring1="Ilabrat Ring",
        ring2="Regal Ring",
        back={ name="Toutatis's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','Crit.hit rate+10','Phys. dmg. taken-10%',}},
        })

    sets.precast.WS['Evisceration'].Acc = set_combine(sets.precast.WS['Evisceration'], {
        ammo="C. Palug Stone",
        legs="Pill. Culottes +1",
        ring1="Regal Ring",
        })

    sets.precast.WS['Rudra\'s Storm'] = set_combine(sets.precast.WS, {
        ammo="Cath Palug Stone",
		body="Nyame Mail",  -- Replace with Relic +3
        neck="Asn. Gorget +1",
        ear1="Sherida Earring",
		ring2="Ilabrat Ring",
        waist="Kentarch Belt +1",
        })

    sets.precast.WS['Rudra\'s Storm'].Acc = set_combine(sets.precast.WS['Rudra\'s Storm'], {
        ammo="C. Palug Stone",
        ear2="Telos Earring",
        waist="Kentarch Belt +1",
        })

    sets.precast.WS['Mandalic Stab'] = sets.precast.WS["Rudra's Storm"]
    sets.precast.WS['Mandalic Stab'].Acc = sets.precast.WS["Rudra's Storm"].Acc

    sets.precast.WS['Aeolian Edge'] = set_combine(sets.precast.WS, {
        ammo="Per. Lucky Egg",
        head="Nyame Helm",
        body="Nyame Mail",
        hands="Nyame Gauntlets",
        legs="Nyame Flanchard",
        feet="Nyame Sollerets",
        neck="Baetyl Pendant",
        ear1="Hermetic Earring",
        ear2="Friomisi Earring",
        ring1="Dingir Ring",
        ring2="Epaminondas's Ring",
        back="Sacro Mantle",
        waist="Sacro Cord",
        })
		
    sets.precast.WS['Cyclone'] = set_combine(sets.precast.WS, {
        ammo="Per. Lucky Egg",
        head="Volte Cap",
        body="Nyame Mail",
        hands="Nyame Gauntlets",
        legs="Volte Hose",
        feet="Volte Boots",
        neck="Baetyl Pendant",
        ear1="Hermetic Earring",
        ear2="Friomisi Earring",
        ring1="Dingir Ring",
        ring2="Epaminondas's Ring",
        back="Sacro Mantle",
        waist="Chaac Belt",
        })		
		
    sets.precast.WS['Asuran Fists'] = set_combine(sets.precast.WS['Exenterator'], {
        hands="Nyame Gauntlets",
        feet="Plun. Poulaines +3",
        ring2="Epona's Ring"
        })	
		
    sets.precast.WS['Savage Blade'] = set_combine(sets.precast.WS, {
        neck="Rep. Plat. Medal",
		waist="Sailfi Belt +1",
        })		

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Midcast Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.midcast.FastRecast = sets.precast.FC

    sets.midcast.SpellInterrupt = {
        ammo="Staunch Tathlum +1", --11
        body=gear.Taeon_Phalanx_body, --10
        hands="Rawhide Gloves", --15
        legs=gear.Taeon_Phalanx_legs, --10
        feet=gear.Taeon_Phalanx_feet, --10
        neck="Loricate Torque +1", --5
        ear1="Enchntr Earring +1", --5
        ear2="Magnetic Earring", --8
        ring2="Evanescence Ring", --5
        }

    sets.midcast.Utsusemi = sets.midcast.SpellInterrupt


    ------------------------------------------------------------------------------------------------
    ----------------------------------------- Idle Sets --------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.resting = {}

    sets.idle = {
        ammo="Staunch Tathlum +1",
        head="Gleti's Mask",
        body="Gleti's Cuirass",
        hands="Gleti's Gauntlets",
        legs="Gleti's Breeches",
        feet="Gleti's Boots",
        neck="Bathy Choker +1",
        ear1="Eabani Earring",
        ear2="Genmei Earring",
        ring1={name="Chirich Ring +1", bag="wardrobe"},
        ring2={name="Chirich Ring +1", bag="wardrobe2"},
        back="Moonbeam Cape",
        waist="Carrier's Sash",
        }

    sets.idle.DT = set_combine(sets.idle, {
        ammo="Staunch Tathlum +1", --3/3
        head="Malignance Chapeau", --6/6
        body="Nyame Mail", --9/9
        hands="Nyame Gauntlets", --5/5
        legs="Malignance Tights", --7/7
        feet="Nyame Sollerets", --4/4
        neck="Warder's Charm +1",
        ear1="Eabani Earring",
        ear2="Ethereal Earring",
        ring1="Moonbeam Ring", --0/4
        ring2="Defending Ring", --10/10
        back="Moonbeam Cape", --6/6
        })

   sets.idle.Refresh = set_combine(sets.idle, {
        ring1={name="Stikini Ring +1", bag="wardrobe2"},
        ring2={name="Stikini Ring +1", bag="wardrobe4"},
        })


    sets.idle.Town = set_combine(sets.idle, {
        ammo="Coiste Bodhar",
		body="Councilor's Garb",
        neck="Asn. Gorget +1",
        ear1="Sherida Earring",
        ear2="Telos Earring",
        back="Toutatis's Cape",
        waist="Sailfi Belt +1",
        })

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Defense Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.defense.PDT = sets.idle.DT
    sets.defense.MDT = sets.idle.DT

    sets.Kiting = {feet="Pill. Poulaines +1"}


    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Engaged Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    -- Variations for TP weapon and (optional) offense/defense modes.  Code will fall back on previous
    -- sets if more refined versions aren't defined.
    -- If you create a set with both offense and defense modes, the offense mode should be first.
    -- EG: sets.engaged.Dagger.Accuracy.Evasion

    sets.engaged = {
        ammo="Coiste Bodhar",
        head="Adhemar Bonnet +1", 
        body="Pillager's Vest +3",
        hands="Adhemar Wrist. +1",
        legs="Samnuha Tights",
        feet="Plun. Poulaines +3",
        neck="Asn. Gorget +1",
        ear1="Sherida Earring",
        ear2="Brutal Earring",
        ring1="Hetairoi Ring",
        ring2="Epona's Ring",
        back={ name="Toutatis's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','Crit.hit rate+10','Phys. dmg. taken-10%',}},
        waist="Sailfi Belt +1",
        }

    sets.engaged.LowAcc = set_combine(sets.engaged, {
        ring1={name="Chirich Ring +1", bag="wardrobe"},
        ear2="Telos Earring",
        })

    sets.engaged.MidAcc = set_combine(sets.engaged.LowAcc, {
        ammo="Yamarang",
        head="Dampening Tam",
        body="Pillager's Vest +3",
        ear1="Cessance Earring",
        ring2="Ilabrat Ring",
        waist="Kentarch Belt +1",
        })

    sets.engaged.HighAcc = set_combine(sets.engaged.MidAcc, {
        ammo="C. Palug Stone",
        hands="Adhemar Wrist. +1",
        legs="Meg. Chausses +2",
        ear2="Mache Earring +1",
        ring1="Regal Ring",
        ring2={name="Chirich Ring +1", bag="wardrobe2"},
        waist="Kentarch Belt +1",
        })

    sets.engaged.STP = set_combine(sets.engaged, {
        head="Malignance Chapeau",
		body="Ashera Harness",
        neck="Anu Torque",
        ring1={name="Chirich Ring +1", bag="wardrobe"},
        ring2={name="Chirich Ring +1", bag="wardrobe2"},
        })

    -- * DNC Native DW Trait: 30% DW
    -- * DNC Job Points DW Gift: 5% DW

    -- No Magic Haste (74% DW to cap)
    sets.engaged.DW = {
        ammo="Coiste Bodhar",
        head="Adhemar Bonnet +1",
        body="Adhemar Jacket +1", -- 6
        hands="Adhemar Wrist. +1",
        legs="Samnuha Tights",
        feet="Plun. Poulaines +3", --9
        neck="Asn. Gorget +1",
        ear1="Eabani Earring", --4
        ear2="Suppanomimi", --5
        ring1="Hetairoi Ring",
        ring2="Epona's Ring",
        back={ name="Toutatis's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','Crit.hit rate+10','Phys. dmg. taken-10%',}}, --10
        waist="Reiki Yotai", --7
        } -- 41%

    sets.engaged.DW.LowAcc = set_combine(sets.engaged.DW, {
        ring1={name="Chirich Ring +1", bag="wardrobe"},
        })

    sets.engaged.DW.MidAcc = set_combine(sets.engaged.DW.LowAcc, {
        ammo="Yamarang",
        head="Dampening Tam",
        body="Ashera Harness",
        ring2="Ilabrat Ring",
        waist="Kentarch Belt +1",
        })

    sets.engaged.DW.HighAcc = set_combine(sets.engaged.DW.MidAcc, {
        ammo="C. Palug Stone",
        hands="Gazu Bracelet +1",
        legs="Nyame Flanchard",
        ear1="Cessance Earring",
        ear2="Telos Earring",
        ring1="Regal Ring",
        ring2={name="Chirich Ring +1", bag="wardrobe2"},
        waist="Kentarch Belt +1",
        })

    sets.engaged.DW.STP = set_combine(sets.engaged.DW, {
        head="Malignance Chapeau",
		body="Ashera Harness",
        neck="Anu Torque",
        ring1={name="Chirich Ring +1", bag="wardrobe"},
        ring2={name="Chirich Ring +1", bag="wardrobe2"},
        })

    -- 15% Magic Haste (67% DW to cap)
    sets.engaged.DW.LowHaste = {
        ammo="Coiste Bodhar",
        head="Adhemar Bonnet +1", 
        body="Adhemar Jacket +1", -- 6
        hands="Adhemar Wrist. +1",
        legs="Samnuha Tights",
        feet="Plun. Poulaines +3", --9
        neck="Asn. Gorget +1",
        ear1="Cessance Earring",
        ear2="Suppanomimi", --5
        ring1="Hetairoi Ring",
        ring2="Epona's Ring",
        back={ name="Toutatis's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','Crit.hit rate+10','Phys. dmg. taken-10%',}}, --10
        waist="Reiki Yotai", --7
        } -- 37%

    sets.engaged.DW.LowAcc.LowHaste = set_combine(sets.engaged.DW.LowHaste, {
        ring1={name="Chirich Ring +1", bag="wardrobe"},
        })

    sets.engaged.DW.MidAcc.LowHaste = set_combine(sets.engaged.DW.LowAcc.LowHaste, {
        ammo="Yamarang",
        head="Dampening Tam",
        body="Nyame Flanchard",
        ring2="Ilabrat Ring",
        waist="Kentarch Belt +1",
        })

    sets.engaged.DW.HighAcc.LowHaste = set_combine(sets.engaged.DW.MidAcc.LowHaste, {
        ammo="C. Palug Stone",
        hands="Gazu Bracelet +1",
        legs="Nyame Flanchard",
        ear2="Telos Earring",
        ring1="Regal Ring",
        ring2={name="Chirich Ring +1", bag="wardrobe2"},
        waist="Kentarch Belt +1",
        })

    sets.engaged.DW.STP.LowHaste = set_combine(sets.engaged.DW.LowHaste, {
        head="Malignance Chapeau",
        neck="Anu Torque",
        ring1={name="Chirich Ring +1", bag="wardrobe"},
        ring2={name="Chirich Ring +1", bag="wardrobe2"},
        })

    -- 30% Magic Haste (56% DW to cap)
    sets.engaged.DW.MidHaste = {
        ammo="Coiste Bodhar",
        head="Adhemar Bonnet +1",
        body="Pillager's Vest +3",
        hands="Adhemar Wrist. +1",
        legs="Samnuha Tights",
        feet="Plun. Poulaines +3",
        neck="Asn. Gorget +1",
        ear1="Eabani Earring", --4
        ear2="Suppanomimi", --5
        ring1="Hetairoi Ring",
        ring2="Epona's Ring",
        back={ name="Toutatis's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','Crit.hit rate+10','Phys. dmg. taken-10%',}}, --10
        waist="Reiki Yotai", --7
        } -- 26%

    sets.engaged.DW.LowAcc.MidHaste = set_combine(sets.engaged.DW.MidHaste, {
        ring1={name="Chirich Ring +1", bag="wardrobe"},
        })

    sets.engaged.DW.MidAcc.MidHaste = set_combine(sets.engaged.DW.LowAcc.MidHaste, {
        ammo="Yamarang",
        head="Dampening Tam",
        ear1="Cessance Earring",
        ring2="Ilabrat Ring",
        waist="Kentarch Belt +1",
        })

    sets.engaged.DW.HighAcc.MidHaste = set_combine(sets.engaged.DW.MidAcc.MidHaste, {
        ammo="C. Palug Stone",
        hands="Gazu Bracelet +1",
        legs="Nyame Flanchard",
        ear2="Telos Earring",
        ring1="Regal Ring",
        ring2={name="Chirich Ring +1", bag="wardrobe2"},
        waist="Kentarch Belt +1",
        })

    sets.engaged.DW.STP.MidHaste = set_combine(sets.engaged.DW.MidHaste, {
        head="Malignance Chapeau",
        body="Ashera Harness",
        neck="Anu Torque",
        ear1="Sherida Earring",
        ring1={name="Chirich Ring +1", bag="wardrobe"},
        ring2={name="Chirich Ring +1", bag="wardrobe2"},
        })

    -- 35% Magic Haste (51% DW to cap)
    sets.engaged.DW.HighHaste = {
        ammo="Coiste Bodhar",
        hands="Adhemar Wrist. +1",
        legs="Samnuha Tights",
        feet="Plun. Poulaines +3",
        neck="Asn. Gorget +1",
        ear1="Sherida Earring",
        ear2="Suppanomimi", --5
        ring1="Hetairoi Ring",
        ring2="Epona's Ring",
        back={ name="Toutatis's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','Crit.hit rate+10','Phys. dmg. taken-10%',}}, --10
        waist="Reiki Yotai", --7
        } -- 22%

    sets.engaged.DW.LowAcc.HighHaste = set_combine(sets.engaged.DW.HighHaste, {
        neck="Combatant's Torque",
        ring1={name="Chirich Ring +1", bag="wardrobe"},
        })

    sets.engaged.DW.MidAcc.HighHaste = set_combine(sets.engaged.DW.LowAcc.HighHaste, {
        ammo="Yamarang",
        head="Dampening Tam",
        ear1="Cessance Earring",
        ring2="Ilabrat Ring",
        waist="Kentarch Belt +1",
        })

    sets.engaged.DW.HighAcc.HighHaste = set_combine(sets.engaged.DW.MidAcc.HighHaste, {
        ammo="C. Palug Stone",
        hands="Gazu Bracelet +1",
        legs="Meg. Chausses +2",
        ear2="Telos Earring",
        ring1="Regal Ring",
        ring2={name="Chirich Ring +1", bag="wardrobe2"},
        waist="Kentarch Belt +1",
        })

    sets.engaged.DW.STP.HighHaste = set_combine(sets.engaged.DW.HighHaste, {
        head="Malignance Chapeau",
		body="Ashera Harness",
        neck="Anu Torque",
        ear1="Sherida Earring",
        ring1={name="Chirich Ring +1", bag="wardrobe"},
        ring2={name="Chirich Ring +1", bag="wardrobe2"},
        })

    -- 45% Magic Haste (36% DW to cap)
    sets.engaged.DW.MaxHaste = {
        ammo="Coiste Bodhar",
        head="Adhemar Bonnet +1", 
        body="Pillager's Vest +3",
        hands="Adhemar Wrist. +1",
        legs="Samnuha Tights",
        feet="Gleti's Breeches",
        neck="Asn. Gorget +1",
        ear1="Sherida Earring",
        ear2="Suppanomimi", --5
        ring1="Hetairoi Ring",
        ring2="Epona's Ring",
        back={ name="Toutatis's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','Crit.hit rate+10','Phys. dmg. taken-10%',}},
        waist="Sailfi Belt +1",
        } -- 5%

    sets.engaged.DW.LowAcc.MaxHaste = set_combine(sets.engaged.DW.MaxHaste, {
        ring1={name="Chirich Ring +1", bag="wardrobe"},
        waist="Kentarch Belt +1",
        })

    sets.engaged.DW.MidAcc.MaxHaste = set_combine(sets.engaged.DW.LowAcc.MaxHaste, {
        ammo="Yamarang",
        head="Dampening Tam",
        ear1="Cessance Earring",
        ring2="Ilabrat Ring",
        })

    sets.engaged.DW.HighAcc.MaxHaste = set_combine(sets.engaged.DW.MidAcc.MaxHaste, {
        ammo="C. Palug Stone",
        hands="Gazu Bracelet +1",
        legs="Meg. Chausses +2",
        ear2="Telos Earring",
        ring1="Regal Ring",
        ring2={name="Chirich Ring +1", bag="wardrobe2"},
        waist="Kentarch Belt +1",
        })

    sets.engaged.DW.STP.MaxHaste = set_combine(sets.engaged.DW.MaxHaste, {
        head="Malignance Chapeau",
        body="Gleti's Cuirass",
        neck="Anu Torque",
        ear1="Sherida Earring",
        ring1={name="Chirich Ring +1", bag="wardrobe"},
        ring2={name="Chirich Ring +1", bag="wardrobe2"},
        waist="Kentarch Belt +1",
        })

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Hybrid Sets -------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.engaged.Hybrid = {
        head="Malignance Chapeau", --6/6
        body="Ashera Harness", --9/9
        hands="Nyame Gauntlets", --5/5
        legs="Malignance Tights", --7/7
        feet="Nyame Sollerets", --4/4
        }

    sets.engaged.DT = set_combine(sets.engaged, sets.engaged.Hybrid)
    sets.engaged.LowAcc.DT = set_combine(sets.engaged.LowAcc, sets.engaged.Hybrid)
    sets.engaged.MidAcc.DT = set_combine(sets.engaged.MidAcc, sets.engaged.Hybrid)
    sets.engaged.HighAcc.DT = set_combine(sets.engaged.HighAcc, sets.engaged.Hybrid)
    sets.engaged.STP.DT = set_combine(sets.engaged.STP, sets.engaged.Hybrid)

    sets.engaged.DW.DT = set_combine(sets.engaged.DW, sets.engaged.Hybrid)
    sets.engaged.DW.LowAcc.DT = set_combine(sets.engaged.DW.LowAcc, sets.engaged.Hybrid)
    sets.engaged.DW.MidAcc.DT = set_combine(sets.engaged.DW.MidAcc, sets.engaged.Hybrid)
    sets.engaged.DW.HighAcc.DT = set_combine(sets.engaged.DW.HighAcc, sets.engaged.Hybrid)
    sets.engaged.DW.STP.DT = set_combine(sets.engaged.DW.STP, sets.engaged.Hybrid)

    sets.engaged.DW.DT.LowHaste = set_combine(sets.engaged.DW.LowHaste, sets.engaged.Hybrid)
    sets.engaged.DW.LowAcc.DT.LowHaste = set_combine(sets.engaged.DW.LowAcc.LowHaste, sets.engaged.Hybrid)
    sets.engaged.DW.MidAcc.DT.LowHaste = set_combine(sets.engaged.DW.MidAcc.LowHaste, sets.engaged.Hybrid)
    sets.engaged.DW.HighAcc.DT.LowHaste = set_combine(sets.engaged.DW.HighAcc.LowHaste, sets.engaged.Hybrid)
    sets.engaged.DW.STP.DT.LowHaste = set_combine(sets.engaged.DW.STP.LowHaste, sets.engaged.Hybrid)

    sets.engaged.DW.DT.MidHaste = set_combine(sets.engaged.DW.MidHaste, sets.engaged.Hybrid)
    sets.engaged.DW.LowAcc.DT.MidHaste = set_combine(sets.engaged.DW.LowAcc.MidHaste, sets.engaged.Hybrid)
    sets.engaged.DW.MidAcc.DT.MidHaste = set_combine(sets.engaged.DW.MidAcc.MidHaste, sets.engaged.Hybrid)
    sets.engaged.DW.HighAcc.DT.MidHaste = set_combine(sets.engaged.DW.HighAcc.MidHaste, sets.engaged.Hybrid)
    sets.engaged.DW.STP.DT.MidHaste = set_combine(sets.engaged.DW.STP.MidHaste, sets.engaged.Hybrid)

    sets.engaged.DW.DT.HighHaste = set_combine(sets.engaged.DW.HighHaste, sets.engaged.Hybrid)
    sets.engaged.DW.LowAcc.DT.HighHaste = set_combine(sets.engaged.DW.LowAcc.HighHaste, sets.engaged.Hybrid)
    sets.engaged.DW.MidAcc.DT.HighHaste = set_combine(sets.engaged.DW.MidAcc.HighHaste, sets.engaged.Hybrid)
    sets.engaged.DW.HighAcc.DT.HighHaste = set_combine(sets.engaged.DW.HighAcc.HighHaste, sets.engaged.Hybrid)
    sets.engaged.DW.STP.DT.HighHaste = set_combine(sets.engaged.DW.HighHaste.STP, sets.engaged.Hybrid)

    sets.engaged.DW.DT.MaxHaste = set_combine(sets.engaged.DW.MaxHaste, sets.engaged.Hybrid)
    sets.engaged.DW.LowAcc.DT.MaxHaste = set_combine(sets.engaged.DW.LowAcc.MaxHaste, sets.engaged.Hybrid)
    sets.engaged.DW.MidAcc.DT.MaxHaste = set_combine(sets.engaged.DW.MidAcc.MaxHaste, sets.engaged.Hybrid)
    sets.engaged.DW.HighAcc.DT.MaxHaste = set_combine(sets.engaged.DW.HighAcc.MaxHaste, sets.engaged.Hybrid)
    sets.engaged.DW.STP.DT.MaxHaste = set_combine(sets.engaged.DW.STP.MaxHaste, sets.engaged.Hybrid)


    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Special Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.buff['Ambush'] = {body="Plunderer's Vest +1"}

    sets.buff.Doom = {
        neck="Nicander's Necklace", --20
        ring1={name="Eshmun's Ring", bag="wardrobe2"}, --20
        ring2={name="Eshmun's Ring", bag="wardrobe2"}, --20
        waist="Gishdubar Sash", --10
        }

    --sets.Reive = {neck="Ygnas's Resolve +1"}
    sets.CP = {back="Mecisto. Mantle"}
	
	sets.Range = {range="Ullr", ammo="Beryllium Arrow"}

    sets.WeaponSet = {}
    sets.WeaponSet['Normal'] = {
      main="Aeneas",
      sub="Gleti's Knife",
    }
    sets.WeaponSet['WhiteDmg'] = {
      main="Gleti's Knife",
      sub={name="Ternion Dagger +1", priority=1},
    }
    sets.WeaponSet['LowAtt'] = {
      main="Aeneas",
      sub="Centovente",
    }
    sets.WeaponSet['Naegling'] = {
      main="Naegling",
      sub="Centovente",
    }
    sets.WeaponSet['NaeglingAcc'] = {
      main="Naegling",
      sub="Ternion Dagger +1",
    }
    sets.WeaponSet['H2H'] = {
      main="Karambit",
      sub="empty",
    }
    sets.WeaponSet['SoloCleaving'] = {
      main="Gandring",
      sub="Tauret",
    }
    sets.WeaponSet['Cleaving'] = {
      main="Tauret",
      sub="Twashtar",
    }
    sets.WeaponSet['Staff'] = {
      main="Gozuki Mezuki",
      sub="empty",
    }
  
    -- Ranged weapon sets
    sets.WeaponSet['Archery'] = {
      ranged="Ullr",
      ammo="Beryllium Arrow",
    }
    sets.WeaponSet['Throwing'] = {
      ranged="Grudge",
      ammo=empty,
    }
end


-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

-- Automatically use Presto for steps when it's available and we have less than 3 finishing moves
function job_pretarget(spell, action, spellMap, eventArgs)
    if spell.type == 'Step' then
        local allRecasts = windower.ffxi.get_ability_recasts()
        local prestoCooldown = allRecasts[236]
        local under3FMs = not buffactive['Finishing Move 3'] and not buffactive['Finishing Move 4'] and not buffactive['Finishing Move 5']

        if player.main_job_level >= 77 and prestoCooldown < 1 and under3FMs then
            cast_delay(1.1)
            send_command('input /ja "Presto" <me>')
        end
    end
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
    if spell.english=='Sneak Attack' or spell.english=='Trick Attack' then
        if state.TreasureMode.value == 'SATA' or state.TreasureMode.value == 'Fulltime' then
            equip(sets.TreasureHunter)
        end
    end
    if spell.type == "WeaponSkill" then
        if state.Buff['Sneak Attack'] == true or state.Buff['Trick Attack'] == true then
            equip(sets.precast.WS.Critical)
        end
    end
    if spell.type == 'WeaponSkill' then
        if spell.english == 'Aeolian Edge' then
            -- Matching double weather (w/o day conflict).
            if spell.element == world.weather_element and (get_weather_intensity() == 2 and spell.element ~= elements.weak_to[world.day_element]) then
                equip({waist="Hachirin-no-Obi"})
            end
        end
    end
    
    -- Keep ranged weapon/ammo equipped if in an RA mode.
    if state.RangedWeaponSet.current ~= 'None' then
        equip({range=player.equipment.range, ammo=player.equipment.ammo})
        silibs_equip_ammo(spell)
    end

    -- If slot is locked, keep current equipment on
    if locked_neck then equip({ neck=player.equipment.neck }) end
    if locked_ear1 then equip({ ear1=player.equipment.ear1 }) end
    if locked_ear2 then equip({ ear2=player.equipment.ear2 }) end
    if locked_ring1 then equip({ ring1=player.equipment.ring1 }) end
    if locked_ring2 then equip({ ring2=player.equipment.ring2 }) end
end

function job_post_midcast(spell, action, spellMap, eventArgs)
    -- Keep ranged weapon/ammo equipped if in an RA mode.
    if state.RangedWeaponSet.current ~= 'None' then
        equip({range=player.equipment.range, ammo=player.equipment.ammo})
        silibs_equip_ammo(spell)
    end
  
    -- If slot is locked, keep current equipment on
    if locked_neck then equip({ neck=player.equipment.neck }) end
    if locked_ear1 then equip({ ear1=player.equipment.ear1 }) end
    if locked_ear2 then equip({ ear2=player.equipment.ear2 }) end
    if locked_ring1 then equip({ ring1=player.equipment.ring1 }) end
    if locked_ring2 then equip({ ring2=player.equipment.ring2 }) end
end
  
-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
function job_aftercast(spell, action, spellMap, eventArgs)
    -- Weaponskills wipe SATA/Feint.  Turn those state vars off before default gearing is attempted.
    if spell.type == 'WeaponSkill' and not spell.interrupted then
        state.Buff['Sneak Attack'] = false
        state.Buff['Trick Attack'] = false
        state.Buff['Feint'] = false
    end
end

-- Called after the default aftercast handling is complete.
function job_post_aftercast(spell, action, spellMap, eventArgs)
    -- If Feint is active, put that gear set on on top of regular gear.
    -- This includes overlaying SATA gear.
    check_buff('Feint', eventArgs)
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for non-casting events.
-------------------------------------------------------------------------------------------------------------------

-- Called when a player gains or loses a buff.
-- buff == buff gained or lost
-- gain == true if the buff was gained, false if it was lost.
function job_buff_change(buff,gain)
    if buff == "doom" then
        if gain then
            send_command('@input /p Doomed.')
        elseif player.hpp > 0 then
            send_command('@input /p Doom Removed.')
        end
    end
    
    if not midaction() then
        handle_equipping_gear(player.status)
    end
end

-- Handle notifications of general user state change.
function job_state_change(stateField, newValue, oldValue)
    if state.WeaponLock.value == true then
        disable('main','sub','range','ammo')
    else
        disable('main','sub','range','ammo')
    end
end


-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------

-- Called by the 'update' self-command, for common needs.
-- Set eventArgs.handled to true if we don't want automatic equipping of gear.
function job_handle_equipping_gear(playerStatus, eventArgs)
    check_gear()
    update_combat_form()
    determine_haste_group()
    check_moving()

    -- Check for SATA when equipping gear.  If either is active, equip
    -- that gear specifically, and block equipping default gear.
    check_buff('Sneak Attack', eventArgs)
    check_buff('Trick Attack', eventArgs)
end

function job_update(cmdParams, eventArgs)
    handle_equipping_gear(player.status)
    th_update(cmdParams, eventArgs)
end

function update_combat_form()
    if DW == true then
        state.CombatForm:set('DW')
    elseif DW == false then
        state.CombatForm:reset()
    end
end

function get_custom_wsmode(spell, action, spellMap)
    local wsmode
    if state.OffenseMode.value == 'MidAcc' or state.OffenseMode.value == 'HighAcc' then
        wsmode = 'Acc'
    end

    if state.Buff['Sneak Attack'] then
        wsmode = 'SA'
    end
    if state.Buff['Trick Attack'] then
        wsmode = (wsmode or '') .. 'TA'
    end

    return wsmode
end

function customize_idle_set(idleSet)
    if state.CP.current == 'on' then
        idleSet = set_combine(idleSet, sets.CP)
     end
    if state.Auto_Kite.value == true then
       idleSet = set_combine(idleSet, sets.Kiting)
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
    if state.Ambush.value == true then
        meleeSet = set_combine(meleeSet, sets.buff['Ambush'])
    end
    if state.TreasureMode.value == 'Fulltime' then
        meleeSet = set_combine(meleeSet, sets.TreasureHunter)
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

    if buffactive.Doom then
        defenseSet = set_combine(defenseSet, sets.buff.Doom)
    end
      
    return defenseSet
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

    local ws_msg = state.WeaponskillMode.value

    local d_msg = 'None'
    if state.DefenseMode.value ~= 'None' then
        d_msg = state.DefenseMode.value .. state[state.DefenseMode.value .. 'DefenseMode'].value
    end

    local i_msg = state.IdleMode.value

    local msg = ''
    if state.TreasureMode.value ~= 'None' then
        msg = msg .. ' TH: ' ..state.TreasureMode.value.. ' |'
    end
    if state.Kiting.value then
        msg = msg .. ' Kiting: On |'
    end

    add_to_chat(002, '| ' ..string.char(31,210).. 'Melee' ..cf_msg.. ': ' ..string.char(31,001)..m_msg.. string.char(31,002)..  ' |'
        ..string.char(31,207).. ' WS: ' ..string.char(31,001)..ws_msg.. string.char(31,002)..  ' |'
        ..string.char(31,004).. ' Defense: ' ..string.char(31,001)..d_msg.. string.char(31,002)..  ' |'
        ..string.char(31,008).. ' Idle: ' ..string.char(31,001)..i_msg.. string.char(31,002)..  ' |'
        ..string.char(31,002)..msg)

    eventArgs.handled = true
end


-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

function determine_haste_group()
    classes.CustomMeleeGroups:clear()
    if DW == true then
        if DW_needed <= 6 then
            classes.CustomMeleeGroups:append('MaxHaste')
        elseif DW_needed > 6 and DW_needed <= 22 then
            classes.CustomMeleeGroups:append('HighHaste')
        elseif DW_needed > 22 and DW_needed <= 26 then
            classes.CustomMeleeGroups:append('MidHaste')
        elseif DW_needed > 26 and DW_needed <= 37 then
            classes.CustomMeleeGroups:append('LowHaste')
        elseif DW_needed > 37 then
            classes.CustomMeleeGroups:append('')
        end
    end
end

function job_self_command(cmdParams, eventArgs)
    if cmdParams[1] == 'weaponset' then
        if cmdParams[2] == 'cycle' then
            cycle_weapons('forward')
        elseif cmdParams[2] == 'cycleback' then
            cycle_weapons('back')
        elseif cmdParams[2] == 'current' then
            cycle_weapons('current')
        end
    elseif cmdParams[1] == 'rangedweaponset' then
        if cmdParams[2] == 'cycle' then
            cycle_ranged_weapons('forward')
        elseif cmdParams[2] == 'cycleback' then
            cycle_ranged_weapons('back')
        elseif cmdParams[2] == 'current' then
            cycle_ranged_weapons('current')
        end
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
        if type(cmdParams[4]) == 'string' then
            if cmdParams[4] == 'true' then
                moving = true
            elseif cmdParams[4] == 'false' then
                moving = false
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
        if state.TreasureMode.value == 'SATA' or state.TreasureMode.value == 'Fulltime' then
            equip(sets.TreasureHunter)
        end
        eventArgs.handled = true
    end
end

-- Check for various actions that we've specified in user code as being used with TH gear.
-- This will only ever be called if TreasureMode is not 'None'.
-- Category and Param are as specified in the action event packet.
function th_action_check(category, param)
    if category == 2 or -- any ranged attack
        --category == 4 or -- any magic action
        (category == 3 and param == 30) or -- Aeolian Edge
        (category == 6 and info.default_ja_ids:contains(param)) or -- Provoke, Animated Flourish
        (category == 14 and info.default_u_ja_ids:contains(param)) -- Quick/Box/Stutter Step, Desperate/Violent Flourish
        then return true
    end
end

function check_moving()
    if state.DefenseMode.value == 'None'  and state.Kiting.value == false then
        if state.Auto_Kite.value == false and moving then
            state.Auto_Kite:set(true)
        elseif state.Auto_Kite.value == true and moving == false then
            state.Auto_Kite:set(false)
        end
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
    if player.sub_job == 'DNC' then
        set_macro_page(1, 1)
    elseif player.sub_job == 'WAR' then
        set_macro_page(2, 1)
    elseif player.sub_job == 'NIN' then
        set_macro_page(3, 1)
    else
        set_macro_page(1, 1)
    end
end

function set_lockstyle()
    send_command('wait 2; input /lockstyleset ' .. lockstyleset)
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
  
function cycle_ranged_weapons(cycle_dir)
    if cycle_dir == 'forward' then
        state.RangedWeaponSet:cycle()
    elseif cycle_dir == 'back' then
        state.RangedWeaponSet:cycleback()
    end
  
    add_to_chat(141, 'RA Weapon Set to '..string.char(31,1)..state.RangedWeaponSet.current)
    equip(sets.WeaponSet[state.RangedWeaponSet.current])
end
  