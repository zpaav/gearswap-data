-- Original: Motenten/Arislan || Modified: Silvermutt

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
--              [ WIN+W ]           Toggle Weapon Lock
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
  packets = include('packets')
  mote_include_version = 2

  -- Load and initialize the include file.
  include('Mote-Include.lua') -- Executes job_setup, user_setup, init_gear_sets
end

-- Executes on first load and main job change
function job_setup()
  lockstyleset = 3
  rayke_duration = 34
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

  state.OffenseMode:options('STP', 'Normal', 'LowAcc', 'MidAcc', 'HighAcc')
  state.WeaponskillMode:options('Normal', 'MaxTp', 'LowAcc', 'LowAccMaxTp', 'MidAcc', 'MidAccMaxTp', 'HighAcc', 'HighAccMaxTp')
  state.HybridMode:options('Normal', 'DT')
  state.CastingMode:options('Normal', 'Resistant')
  state.IdleMode:options('Normal', 'DT')
  state.PhysicalDefenseMode:options('PDT', 'HP')
  state.MagicalDefenseMode:options('MDT')
  state.Knockback = M(false, 'Knockback')
  state.DeathResist = M(false, 'Death Resist Mode')
  -- state.WeaponSet = M{['description']='Weapon Set', 'Epeolatry', 'Lionheart', 'Aettir', 'Lycurgos'}
  state.AttackMode = M{['description']='Attack', 'Uncapped', 'Capped'}
  state.CP = M(false, "Capacity Points Mode")
  state.WeaponLock = M(false, 'Weapon Lock')
  state.ToyWeapons = M{['description']='Toy Weapons','None','Dagger',
      'Sword','Club','Staff','Polearm','GreatSword','Scythe'}
  state.Runes = M{['description']='Runes', 'Ignis', 'Gelus', 'Flabra', 'Tellus', 'Sulpor', 'Unda', 'Lux', 'Tenebrae'}
  
  send_command('bind !a gs c test')
  send_command('bind !s gs c faceaway')
  send_command('bind !d gs c usekey')
  send_command('bind @w gs c toggle WeaponLock')

  send_command('bind ^pageup gs c toyweapon cycle')
  send_command('bind ^pagedown gs c toyweapon cycleback')
  send_command('bind !pagedown gs c toyweapon reset')

  send_command('bind @d gs c toggle DeathResist')

  send_command('bind numpad0 input //gs c rune')
  send_command('bind !` input /ja "Vivacious Pulse" <me>')
  send_command('bind ^- gs c cycleback Runes')
  send_command('bind ^= gs c cycle Runes')
  send_command('bind ^f11 gs c cycle MagicalDefenseMode')
  send_command('bind @a gs c cycle AttackMode')
  send_command('bind @c gs c toggle CP')
  -- send_command('bind @e gs c cycleback WeaponSet')
  -- send_command('bind @r gs c cycle WeaponSet')
  send_command('bind @k gs c toggle Knockback')
  send_command('bind ^` input /ma "Temper" <me>')

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
  locked_style = false -- Do not modify
  include('Global-Binds.lua') -- Additional local binds

  if player.sub_job == 'BLU' then
    send_command('bind !q input /ma "Wild Carrot" <stpc>')
    send_command('bind !w input /ma "Cocoon" <me>')
    send_command('bind !e input /ma "Refueling" <me>')
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
  end

  select_default_macro_book()
  set_lockstyle()
end

function job_file_unload()
  send_command('unbind !s')
  send_command('unbind !d')

  send_command('unbind ^pageup')
  send_command('unbind ^pagedown')
  send_command('unbind !pagedown')

  send_command('unbind ^`')
  send_command('unbind !`')
  send_command('unbind ^f11')
  send_command('unbind ^-')
  send_command('unbind ^=')
  send_command('unbind @a')
  send_command('unbind @c')
  send_command('unbind @d')
  send_command('unbind @w')
  -- send_command('unbind @e')
  -- send_command('unbind @r')
  send_command('unbind !q')
  send_command('unbind !w')
  send_command('unbind !e')
  send_command('unbind !u')
  send_command('unbind !i')
  send_command('unbind !o')
  send_command('unbind !p')

  send_command('unbind !;')
  send_command('unbind !\'')
  
  send_command('unbind !,')
  send_command('unbind !.')
  send_command('unbind !/')

  send_command('unbind ^numlock')
  send_command('unbind ^numpad/')
  send_command('unbind ^numpad*')
  send_command('unbind ^numpad-')
  send_command('unbind ^numpad+')
  send_command('unbind ^numpadenter')
  send_command('unbind ^numpad9')
  send_command('unbind ^numpad8')
  send_command('unbind ^numpad7')
  send_command('unbind ^numpad6')
  send_command('unbind ^numpad5')
  send_command('unbind ^numpad4')
  send_command('unbind ^numpad3')
  send_command('unbind ^numpad2')
  send_command('unbind ^numpad1')
  send_command('unbind ^numpad0')
  send_command('unbind ^numpad.')
  send_command('unbind numpad0')
  send_command('unbind @numpad*')

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

  -- Enmity sets
  sets.Enmity = {
    ammo="Aqreqaq Bomblet", --2
    head="Halitus Helm", --8
    feet="Erilaz Greaves +1", --6
    body="Emet Harness +1", --10
    hands="Kurys Gloves", --9
    legs="Erilaz Leg Guards +1", --11
    neck="Futhark Torque +1", --7
    ear1="Cryptic Earring", --4
    ear2="Fiomisi Earring", --2
    ring1="Pernicious Ring", --5
    ring2="Supershear Ring", --5
    waist="Sulla Belt", --3
    back=gear.RUN_HPD_Cape, --10
    -- feet="Ahosi Leggings",--7
    -- neck="Moonlight Necklace", --15
    -- ear2="Trux Earring", --5
    -- waist="Kasiri Belt", --3
  } --75

  sets.Enmity.HP = {
    ammo="Aqreqaq Bomblet", --2
    head="Halitus Helm", --8
    body="Emet Harness +1", --10
    hands="Kurys Gloves", --9
    legs="Erilaz Leg Guards +1", --11
    -- feet="Ahosi Leggings",--7
    -- neck={name="Unmoving Collar +1", priority=1}, --10
    ear1="Odnowa Earring +1",
    -- ear2={name="Tuisto Earring", priority=4},
    -- ring1={name="Moonlight Ring", priority=2},
    ring2="Supershear Ring", --5
    back=gear.RUN_HPD_Cape, --10
    -- waist="Kasiri Belt", --3
  }

  sets.precast.JA['Vallation'] = {
    body="Runeist's Coat +3",
    legs="Futhark Trousers +2",
    back=gear.RUN_HPD_Cape,
  }
  sets.precast.JA['Valiance'] = sets.precast.JA['Vallation']
  sets.precast.JA['Battuta'] = {
    head="Futhark Bandeau +1"
  }
  sets.precast.JA['Liement'] = {
    body="Futhark Coat +1",
  }

  sets.MAB = {
    ammo="Seething Bomblet", --6
    head="Highwing Helm", --20
    body=gear.Samnuha_body, --25
    hands=gear.Leyline_Gloves, --30
    legs=gear.Herc_MAB_legs, --24
    feet=gear.Herc_WSD_feet, --10
    neck="Baetyl Pendant", --13
    ear1="Friomisi Earring", --10
    ear2="Novio Earring", --7
    ring1="Shiva Ring +1", --3
    waist="Eschan Stone", --7
    back="Argochampsa Mantle", --12
    -- ammo="Pemphredo Tathlum",
    -- head=gear.Herc_MAB_head,
    -- body="Carm. Sc. Mail +1",
    -- hands="Carmine Fin. Ga. +1",
    -- feet=gear.Herc_MAB_feet,
    -- ear1="Crematio Earring",
    -- ring1={name="Fenrir Ring +1", bag="wardrobe3"},
    -- ring2={name="Fenrir Ring +1", bag="wardrobe4"},
    -- back="Argocham. Mantle",
  }

  sets.Macc = {
    ammo="Hydrocera", --6
    head="Ayanmo Zucchetto +2", --44
    body="Ayanmo Corazza +2", --46
    hands="Volte Bracers", --37
    legs="Ayanmo Cosciales +1", --39
    feet="Ayanmo Gambieras +1", --36
    ear1="Dignitary's Earring", --10
  }

  sets.precast.JA['Lunge'] = sets.MAB

  sets.precast.JA['Swipe'] = sets.MAB
  sets.precast.JA['Gambit'] = {
    hands="Runeist Mitons +1"
  }
  sets.precast.JA['Rayke'] = {
    feet="Futhark Boots"
  }
  sets.precast.JA['Elemental Sforzo'] = {
    body="Futhark Coat +1",
  }
  sets.precast.JA['Swordplay'] = {
    hands="Futhark Mitons"
  }

  sets.precast.JA['Vivacious Pulse'] = {
    head="Erilaz Galea +1",
    neck="Incanter's Torque",
    -- legs="Rune. Trousers +3",
    -- neck="Incanter's Torque",
    -- ear1="Beatific Earring",
    -- ear2="Saxnot Earring",
    -- ring1={name="Stikini Ring +1", bag="wardrobe3"},
    -- ring2={name="Stikini Ring +1", bag="wardrobe4"},
    --back="Altruistic Cape",
    -- waist="Bishop's Sash",
  }


  -- Fast cast sets for spells
  sets.precast.FC = {
    ammo="Impatiens", --Quick Magic 2%
    head="Runeist Bandeau +1", --10
    body=gear.Taeon_FC_body, --9
    hands=gear.Leyline_Gloves, --8
    legs="Ayanmo Cosciales +1", --5
    feet=gear.Taeon_FC_feet, --5
    ear1="Loquac. Earring", --2
    ring1="Lebeche Ring", --Quick Magic 2%
    ring2="Prolix Ring", --2
    -- ammo="Sapience Orb", --2
    -- head="Rune. Bandeau +3", --14
    -- legs="Ayanmo Cosciales +2", --6
    -- feet="Carmine Greaves +1", --8
    -- neck="Orunmila's Torque", --5
    -- ear1="Tuisto Earring",
    -- ear2="Odnowa Earring +1",
    -- ring1="Moonlight Ring",
    -- ring2="Weather. Ring +1", --6(4)
    -- back=gear.RUN_FC_Cape, --10
    -- waist="Oneiros Belt",
  }

  sets.precast.FC.HP = set_combine(sets.precast.FC, {
    -- ammo="Aqreqaq Bomblet",
    -- head={name="Rune. Bandeau +3", priority=6},
    -- body={name="Runeist's Coat +3", priority=2},
    -- neck={name="Unmoving Collar +1", priority=1}, --10
    -- ear1={name="Tuisto Earring", priority=5},
    -- ear2={name="Odnowa Earring +1", priority=4},
    -- ring1={name="Moonlight Ring", priority=3},
    -- waist="Oneiros Belt",
  })

  sets.precast.FC['Enhancing Magic'] = set_combine(sets.precast.FC, {
    legs="Futhark Trousers +2",
  })

  sets.precast.FC.Cure = set_combine(sets.precast.FC, {
    ammo="Impatiens",
    -- ear2="Mendi. Earring"
  })

  sets.precast.FC.Utsusemi = set_combine(sets.precast.FC, {
    ammo="Impatiens",
    -- body="Passion Jacket",
    ring1="Lebeche Ring",
    waist="Audumbla Sash",
  })

  -- Initializes trusts at iLvl 119
  sets.midcast.Trust = sets.precast.FC


  ------------------------------------------------------------------------------------------------
  ------------------------------------- Weapon Skill Sets ----------------------------------------
  ------------------------------------------------------------------------------------------------

  sets.precast.WS = {
    ammo="Knobkierrie",
    head=gear.Herc_WSD_head,
    body="Meghanada Cuirie +2",
    hands="Meg. Gloves +2",
    legs="Meghanada Chausses +2",
    feet=gear.Herc_WSD_feet,
    neck="Fotia Gorget",
    waist="Fotia Belt",
    ear1="Sherida Earring",
    ear2="Moonshade Earring",
    ring1="Karieyh Ring",
    ring2="Ilabrat Ring",
    back=gear.RUN_WS2_Cape,
    -- ammo="Knobkierrie",
    -- head=gear.Herc_WSD_head,
    -- body=gear.Herc_WS_body,
    -- hands="Meg. Gloves +2",
    -- legs=gear.Herc_WS_legs,
    -- feet=gear.Herc_TA_feet,
    -- neck="Fotia Gorget",
    -- ear1="Sherida Earring",
    -- ear2="Moonshade Earring",
    -- ring1="Regal Ring",
    -- ring2="Niqmaddu Ring",
    -- back=gear.RUN_WS1_Cape,
    -- waist="Fotia Belt",
  }

  sets.precast.WS.Safe = {
  }

  -- 85% STR mod
  sets.precast.WS['Resolution'] = set_combine(sets.precast.WS, {
    ammo="Seething Bomblet",
    head=gear.Adhemar_B_head,
    hands=gear.Adhemar_B_hands,
    neck="Caro Necklace",
    ring1="Epona's Ring",
    -- ammo="Aurgelmir Orb +1",
    -- head="Lustratio Cap +1",
    -- body="Lustr. Harness +1",
    -- feet="Lustra. Leggings +1",
    -- neck="Futhark Torque +2",
    -- back=gear.RUN_WS1_Cape,
  })
  sets.precast.WS['Resolution'].Safe = set_combine(sets.precast.WS.Safe, {
    -- head=gear.Adhemar_D_head,
    -- body=gear.Adhemar_B_body,
    -- feet=gear.Herc_TA_feet,
  })
  sets.precast.WS['Resolution'].MaxTp = set_combine(sets.precast.WS['Resolution'], {
  })
  sets.precast.WS['Resolution'].LowAcc = set_combine(sets.precast.WS['Resolution'], {
    legs="Meg. Chausses +2",
    -- ammo="Voluspa Tathlum",
    -- head=gear.Adhemar_B_head,
    -- hands=gear.Adhemar_A_hands,
    -- feet=gear.Herc_STP_feet,
    -- ear2="Telos Earring",
  })
  sets.precast.WS['Resolution'].LowAccMaxTp = set_combine(sets.precast.WS['Resolution'].LowAcc, {
  })
  sets.precast.WS['Resolution'].MidAcc = set_combine(sets.precast.WS['Resolution'].LowAcc, {
  })
  sets.precast.WS['Resolution'].MidAccMaxTp = set_combine(sets.precast.WS['Resolution'].MidAcc, {
  })
  sets.precast.WS['Resolution'].HighAcc = set_combine(sets.precast.WS['Resolution'].MidAcc, {
  })
  sets.precast.WS['Resolution'].HighAccMaxTp = set_combine(sets.precast.WS['Resolution'].HighAcc, {
  })

  -- 80% DEX mod
  sets.precast.WS['Dimidiation'] = set_combine(sets.precast.WS, {
    legs=gear.Lustratio_B_legs,
    neck="Caro Necklace",
    ear1="Odr Earring",
    waist="Grunfeld Rope",
    -- ammo="Aurgelmir Orb +1",
    -- body=gear.Adhemar_B_body,
    -- feet="Lustra. Leggings +1",
    -- ring2="Epaminondas's Ring",
    -- back=gear.RUN_WS2_Cape,
  })
  sets.precast.WS['Dimidiation'].Safe = set_combine(sets.precast.WS.Safe, {
    legs=gear.Lustratio_B_legs,
    feet=gear.Herc_TA_feet,
  })
  sets.precast.WS['Dimidiation'].MaxTp = set_combine(sets.precast.WS['Dimidiation'], {
  })
  sets.precast.WS['Dimidiation'].LowAcc = set_combine(sets.precast.WS['Dimidiation'], {
    -- ammo="Voluspa Tathlum",
    -- body=gear.Adhemar_B_body,
    -- legs="Samnuha Tights",
    -- feet=gear.Herc_STP_feet,
    -- ear2="Mache Earring +1",
  })
  sets.precast.WS['Dimidiation'].LowAccMaxTp = set_combine(sets.precast.WS['Dimidiation'].LowAcc, {
  })
  sets.precast.WS['Dimidiation'].MidAcc = set_combine(sets.precast.WS['Dimidiation'].LowAcc, {
  })
  sets.precast.WS['Dimidiation'].MidAccMaxTp = set_combine(sets.precast.WS['Dimidiation'].MidAcc, {
  })
  sets.precast.WS['Dimidiation'].HighAcc = set_combine(sets.precast.WS['Dimidiation'].MidAcc, {
  })
  sets.precast.WS['Dimidiation'].HighAccMaxTp = set_combine(sets.precast.WS['Dimidiation'].HighAcc, {
  })

  sets.precast.WS['Herculean Slash'] = set_combine(sets.MAB, {
    ear2="Moonshade Earring",
    ring2="Karieyh Ring",
  })
  sets.precast.WS['Herculean Slash'].Safe = set_combine(sets.precast.WS.Safe, sets.Macc, {
  })
  sets.precast.WS['Herculean Slash'].MaxTp = set_combine(sets.precast.WS['Herculean Slash'], {
  })
  sets.precast.WS['Herculean Slash'].LowAcc = set_combine(sets.precast.WS['Herculean Slash'], {
  })
  sets.precast.WS['Herculean Slash'].LowAccMaxTp = set_combine(sets.precast.WS['Herculean Slash'].LowAcc, {
  })
  sets.precast.WS['Herculean Slash'].MidAcc = set_combine(sets.precast.WS['Herculean Slash'].LowAcc, {
  })
  sets.precast.WS['Herculean Slash'].MidAccMaxTp = set_combine(sets.precast.WS['Herculean Slash'].MidAcc, {
  })
  sets.precast.WS['Herculean Slash'].HighAcc = set_combine(sets.precast.WS['Herculean Slash'].MidAcc, {
  })
  sets.precast.WS['Herculean Slash'].HighAccMaxTp = set_combine(sets.precast.WS['Herculean Slash'].HighAcc, {
  })

  -- Magic accuracy required for Shockwave
  sets.precast.WS['Shockwave'] = set_combine(sets.Macc, {
    ear2="Moonshade Earring",
    ring2="Karieyh Ring",
  })
  sets.precast.WS['Shockwave'].Safe = set_combine(sets.precast.WS.Safe, sets.Macc, {
  })
  sets.precast.WS['Shockwave'].MaxTp = set_combine(sets.precast.WS['Shockwave'], {
  })
  sets.precast.WS['Shockwave'].LowAcc = set_combine(sets.precast.WS['Shockwave'], {
  })
  sets.precast.WS['Shockwave'].LowAccMaxTp = set_combine(sets.precast.WS['Shockwave'].LowAcc, {
  })
  sets.precast.WS['Shockwave'].MidAcc = set_combine(sets.precast.WS['Shockwave'].LowAcc, {
  })
  sets.precast.WS['Shockwave'].MidAccMaxTp = set_combine(sets.precast.WS['Shockwave'].MidAcc, {
  })
  sets.precast.WS['Shockwave'].HighAcc = set_combine(sets.precast.WS['Shockwave'].MidAcc, {
  })
  sets.precast.WS['Shockwave'].HighAccMaxTp = set_combine(sets.precast.WS['Shockwave'].HighAcc, {
  })

  sets.precast.WS['Fell Cleave'] = set_combine(sets.precast.WS, {
    -- feet="Lustra. Leggings +1",
    -- ear2="Ishvara Earring",
    -- back=gear.RUN_WS1_Cape,
    -- waist="Sailfi Belt +1",
  })
  sets.precast.WS['Fell Cleave'].Safe = set_combine(sets.precast.WS.Safe, {
    -- feet="Futhark Boots +3",
  })
  sets.precast.WS['Fell Cleave'].MaxTp = set_combine(sets.precast.WS['Fell Cleave'], {
  })
  sets.precast.WS['Fell Cleave'].LowAcc = set_combine(sets.precast.WS['Fell Cleave'], {
    -- ear2="Ishvara Earring",
    -- back=gear.RUN_WS1_Cape,
    -- waist="Sailfi Belt +1",
  })
  sets.precast.WS['Fell Cleave'].LowAccMaxTp = set_combine(sets.precast.WS['Fell Cleave'].LowAcc, {
  })
  sets.precast.WS['Fell Cleave'].MidAcc = set_combine(sets.precast.WS['Fell Cleave'].LowAcc, {
  })
  sets.precast.WS['Fell Cleave'].MidAccMaxTp = set_combine(sets.precast.WS['Fell Cleave'].MidAcc, {
  })
  sets.precast.WS['Fell Cleave'].HighAcc = set_combine(sets.precast.WS['Fell Cleave'].MidAcc, {
  })
  sets.precast.WS['Fell Cleave'].HighAccMaxTp = set_combine(sets.precast.WS['Fell Cleave'].HighAcc, {
  })

  sets.precast.WS['Steel Cyclone'] = sets.precast.WS['Fell Cleave']
  sets.precast.WS['Steel Cyclone'].Safe = sets.precast.WS['Fell Cleave'].Safe
  sets.precast.WS['Steel Cyclone'].MaxTp = sets.precast.WS['Fell Cleave'].MaxTp
  sets.precast.WS['Steel Cyclone'].LowAcc = sets.precast.WS['Fell Cleave'].LowAcc
  sets.precast.WS['Steel Cyclone'].LowAccMaxTp = sets.precast.WS['Fell Cleave'].LowAccMaxTp
  sets.precast.WS['Steel Cyclone'].MidAcc = sets.precast.WS['Fell Cleave'].MidAcc
  sets.precast.WS['Steel Cyclone'].MidAccMaxTp = sets.precast.WS['Fell Cleave'].MidAccMaxTp
  sets.precast.WS['Steel Cyclone'].HighAcc = sets.precast.WS['Fell Cleave'].HighAcc
  sets.precast.WS['Steel Cyclone'].HighAccMaxTp = sets.precast.WS['Fell Cleave'].HighAccMaxTp

  sets.precast.WS['Upheaval'] = sets.precast.WS['Resolution']
  sets.precast.WS['Upheaval'].Safe = sets.precast.WS['Resolution'].Safe
  sets.precast.WS['Upheaval'].MaxTp = sets.precast.WS['Resolution'].MaxTp
  sets.precast.WS['Upheaval'].LowAcc = sets.precast.WS['Resolution'].LowAcc
  sets.precast.WS['Upheaval'].LowAccMaxTp = sets.precast.WS['Resolution'].LowAccMaxTp
  sets.precast.WS['Upheaval'].MidAcc = sets.precast.WS['Resolution'].MidAcc
  sets.precast.WS['Upheaval'].MidAccMaxTp = sets.precast.WS['Resolution'].MidAccMaxTp
  sets.precast.WS['Upheaval'].HighAcc = sets.precast.WS['Resolution'].HighAcc
  sets.precast.WS['Upheaval'].HighAccMaxTp = sets.precast.WS['Resolution'].HighAccMaxTp

  sets.precast.WS['Shield Break'] = sets.precast.WS['Shockwave']
  sets.precast.WS['Shield Break'].Safe = sets.precast.WS['Shockwave'].Safe
  sets.precast.WS['Shield Break'].MaxTp = sets.precast.WS['Shockwave'].MaxTp
  sets.precast.WS['Shield Break'].LowAcc = sets.precast.WS['Shockwave'].LowAcc
  sets.precast.WS['Shield Break'].LowAccMaxTp = sets.precast.WS['Shockwave'].LowAccMaxTp
  sets.precast.WS['Shield Break'].MidAcc = sets.precast.WS['Shockwave'].MidAcc
  sets.precast.WS['Shield Break'].MidAccMaxTp = sets.precast.WS['Shockwave'].MidAccMaxTp
  sets.precast.WS['Shield Break'].HighAcc = sets.precast.WS['Shockwave'].HighAcc
  sets.precast.WS['Shield Break'].HighAccMaxTp = sets.precast.WS['Shockwave'].HighAccMaxTp

  sets.precast.WS['Armor Break'] = sets.precast.WS['Shockwave']
  sets.precast.WS['Armor Break'].Safe = sets.precast.WS['Shockwave'].Safe
  sets.precast.WS['Armor Break'].MaxTp = sets.precast.WS['Shockwave'].MaxTp
  sets.precast.WS['Armor Break'].LowAcc = sets.precast.WS['Shockwave'].LowAcc
  sets.precast.WS['Armor Break'].LowAccMaxTp = sets.precast.WS['Shockwave'].LowAccMaxTp
  sets.precast.WS['Armor Break'].MidAcc = sets.precast.WS['Shockwave'].MidAcc
  sets.precast.WS['Armor Break'].MidAccMaxTp = sets.precast.WS['Shockwave'].MidAccMaxTp
  sets.precast.WS['Armor Break'].HighAcc = sets.precast.WS['Shockwave'].HighAcc
  sets.precast.WS['Armor Break'].HighAccMaxTp = sets.precast.WS['Shockwave'].HighAccMaxTp

  sets.precast.WS['Weapon Break'] = sets.precast.WS['Shockwave']
  sets.precast.WS['Weapon Break'].Safe = sets.precast.WS['Shockwave'].Safe
  sets.precast.WS['Weapon Break'].MaxTp = sets.precast.WS['Shockwave'].MaxTp
  sets.precast.WS['Weapon Break'].LowAcc = sets.precast.WS['Shockwave'].LowAcc
  sets.precast.WS['Weapon Break'].LowAccMaxTp = sets.precast.WS['Shockwave'].LowAccMaxTp
  sets.precast.WS['Weapon Break'].MidAcc = sets.precast.WS['Shockwave'].MidAcc
  sets.precast.WS['Weapon Break'].MidAccMaxTp = sets.precast.WS['Shockwave'].MidAccMaxTp
  sets.precast.WS['Weapon Break'].HighAcc = sets.precast.WS['Shockwave'].HighAcc
  sets.precast.WS['Weapon Break'].HighAccMaxTp = sets.precast.WS['Shockwave'].HighAccMaxTp

  sets.precast.WS['Full Break'] = sets.precast.WS['Shockwave']
  sets.precast.WS['Full Break'].Safe = sets.precast.WS['Shockwave'].Safe
  sets.precast.WS['Full Break'].MaxTp = sets.precast.WS['Shockwave'].MaxTp
  sets.precast.WS['Full Break'].LowAcc = sets.precast.WS['Shockwave'].LowAcc
  sets.precast.WS['Full Break'].LowAccMaxTp = sets.precast.WS['Shockwave'].LowAccMaxTp
  sets.precast.WS['Full Break'].MidAcc = sets.precast.WS['Shockwave'].MidAcc
  sets.precast.WS['Full Break'].MidAccMaxTp = sets.precast.WS['Shockwave'].MidAccMaxTp
  sets.precast.WS['Full Break'].HighAcc = sets.precast.WS['Shockwave'].HighAcc
  sets.precast.WS['Full Break'].HighAccMaxTp = sets.precast.WS['Shockwave'].HighAccMaxTp


  ------------------------------------------------------------------------------------------------
  ---------------------------------------- Midcast Sets ------------------------------------------
  ------------------------------------------------------------------------------------------------

  sets.midcast.FastRecast = sets.precast.FC

  sets.midcast.SpellInterrupt = {
    ammo="Staunch Tathlum", --10
    -- body=gear.Taeon_Phalanx_body, --10
    -- hands=gear.Taeon_Phalanx_hands, --10
    -- legs=gear.Taeon_Phalanx_legs, --10
    -- feet=gear.Taeon_Phalanx_feet, --10
    -- neck="Moonlight Necklace", --15
    -- ear1="Halasz Earring", --5
    -- ring1="Evanescence Ring", --5
    -- back=gear.RUN_FC_Cape, --10
    waist="Audumbla Sash", --10
  } -- +10% from merit points

  sets.midcast.Cure = {
    ammo="Staunch Tathlum",
    legs="Ayanmo Cosciales +2",
    ring2="Defending Ring",
    waist="Gishdubar Sash", --(10)
    -- sub="Mensch Strap +1",
    -- ammo="Staunch Tathlum",
    -- head="Fu. Bandeau +3",
    -- body="Vrikodara Jupon", -- 13
    -- hands="Buremte Gloves", --(13)
    -- legs="Ayanmo Cosciales +2",
    -- feet="Skaoi Boots", --7
    -- neck="Phalaina Locket", -- 4(4)
    -- ear1="Roundel Earring", -- 5
    -- ear2="Mendi. Earring", -- 5
    -- ring1="Lebeche Ring", -- 3
    -- ring2="Defending Ring",
    -- back="Solemnity Cape", -- 7
    -- waist="Gishdubar Sash", --(10)
  }

  sets.midcast['Enhancing Magic'] = {
    head="Erilaz Galea +1",
    hands="Runeist Mitons +1",
    legs="Carmine Cuisses +1",
    waist="Olympus Sash",
    neck="Incanter's Torque",
    ear1="Andoaa Earring",
    ear2="Mimir Earring",
    -- main="Pukulatmuj +1",
    -- head="Erilaz Galea +1",
    -- body="Manasa Chasuble",
    -- hands="Runeist Mitons",
    -- legs="Carmine Cuisses +1",
    -- neck="Incanter's Torque",
    -- ear1="Mimir Earring",
    -- ear2="Andoaa Earring",
    -- ring1={name="Stikini Ring +1", bag="wardrobe3"},
    -- ring2={name="Stikini Ring +1", bag="wardrobe4"},
    -- back="Merciful Cape",
    -- waist="Olympus Sash",
  }

  sets.midcast.EnhancingDuration = {
    head="Erilaz Galea +1",
    -- hands="Regal Gauntlets",
    legs="Futhark Trousers +2",
  }

  sets.midcast['Phalanx'] = set_combine(sets.midcast.SpellInterrupt, {
    -- main="Deacon Sword", --4
    head="Futhark Bandeau +1", --4
    body=gear.Taeon_Phalanx_body, --3
    hands=gear.Taeon_Phalanx_hands, --3
    legs=gear.Taeon_Phalanx_legs, --3
    feet=gear.Taeon_Phalanx_feet, --3
  })

  sets.midcast['Aquaveil'] = set_combine(sets.midcast['Enhancing Magic'], sets.midcast.SpellInterrupt, {
    -- main="Nibiru Faussar", --1
  })

  sets.midcast['Regen'] = set_combine(sets.midcast.EnhancingDuration, {
    head="Runeist Bandeau +1",
    body="Meghanada Cuirie +2",
    hands="Meghanada Gloves +2",
    legs="Meghanada Chausses +2",
    -- neck="Sacro Gorget"
  })
  sets.midcast.Refresh = set_combine(sets.midcast.EnhancingDuration, {
    head="Erilaz Galea +1",
    waist="Gishdubar Sash",
  })
  sets.midcast.Stoneskin = set_combine(sets.midcast['Enhancing Magic'], {
    waist="Siegel Sash"
  })
  sets.midcast.Protect = set_combine(sets.midcast['Enhancing Magic'], {
    -- ring2="Sheltered Ring"
  })
  sets.midcast.Shell = sets.midcast.Protect

  sets.midcast['Divine Magic'] = {
    legs="Runeist Trousers",
    neck="Incanter's Torque",
    -- ammo="Yamarang",
    -- neck="Incanter's Torque",
    -- ring1={name="Stikini Ring +1", bag="wardrobe3"},
    -- ring2={name="Stikini Ring +1", bag="wardrobe4"},
    -- waist="Bishop's Sash",
  }

  sets.midcast.Flash = sets.Enmity
  sets.midcast.Foil = sets.Enmity
  sets.midcast.Stun = sets.Enmity
  sets.midcast.Utsusemi = sets.midcast.SpellInterrupt

  sets.midcast['Blue Magic'] = {}
  sets.midcast['Blue Magic'].Enmity = sets.Enmity
  sets.midcast['Blue Magic'].Cure = sets.midcast.Cure
  sets.midcast['Blue Magic'].Buff = sets.midcast['Enhancing Magic']


  ------------------------------------------------------------------------------------------------
  ----------------------------------------- Idle Sets --------------------------------------------
  ------------------------------------------------------------------------------------------------

  sets.latent_regain = {
    ring1="Karieyh Ring",
  }
  sets.latent_regen = {
    head="Meghanada Visor +2",
    body="Meghanada Cuirie +2",
    hands="Turms Mittens",
    legs="Meghanada Chausses +2",
    feet="Turms Leggings",
    neck="Bathy Choker +1",
    ear1="Infused Earring",
    ring1="Chirich Ring +1",
  }
  sets.latent_refresh = {
    ammo="Homiliary", --1
    body="Runeist's Coat +3", --3
    legs="Rawhide Trousers", --1
    -- head=gear.Herc_Idle_head,
    -- hands="Regal Gauntlets",
    -- ring1={name="Stikini Ring +1", bag="wardrobe3"},
    -- ring2={name="Stikini Ring +1", bag="wardrobe4"},
  }
  sets.latent_refresh_sub50 = set_combine(sets.latent_refresh, {
    waist="Fucho-no-Obi",
  })

  sets.idle = {
    ammo="Staunch Tathlum", --2/2
    head="Meghanada Visor +2", --5/0
    body="Futhark Coat +1", --7/7
    hands="Turms Mittens",
    legs="Erilaz Leg Guards +1", --7/0
    feet="Turms Leggings",
    neck="Futhark Torque +1", --4/4
    waist="Engraved Belt",
    ear1="Brutal Earring",
    ear2="Sherida Earring",
    ring1=gear.Dark_Ring, --5/4
    ring2="Defending Ring", --10/10
    back=gear.RUN_HPD_Cape, --10/0
  }

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

  sets.DT = {
    sub="Refined Grip +1", --3/3
    ammo="Staunch Tathlum", --2/2
    head="Meghanada Visor +2", --5/0
    body="Runeist's Coat +3",
    hands="Turms Mittens",
    legs="Erilaz Leg Guards +1", --7/0
    feet="Erilaz Greaves +1", --5/0
    neck="Futhark Torque +1", --4/4
    waist="Gishdubar Sash",
    ear1="Odnowa Earring +1", --3/5
    ear2="Ethereal Earring",
    ring1="Ayanmo Ring", --3/3
    ring2="Defending Ring", --10/10
    back=gear.RUN_HPD_Cape, --10/0
  } -- 52 / 27

  sets.idle.DT = set_combine(sets.idle, sets.DT)
  sets.idle.DT.Regain = set_combine(sets.idle.Regain, sets.DT)
  sets.idle.DT.Regen = set_combine(sets.idle.Regen, sets.DT)
  sets.idle.DT.Refresh = set_combine(sets.idle.Refresh, sets.DT)
  sets.idle.DT.RefreshSub50 = set_combine(sets.idle.RefreshSub50, sets.DT)
  sets.idle.DT.Regain.Regen = set_combine(sets.idle.Regain.Regen, sets.DT)
  sets.idle.DT.Regain.Refresh = set_combine(sets.idle.Regain.Refresh, sets.DT)
  sets.idle.DT.Regain.RefreshSub50 = set_combine(sets.idle.Regain.RefreshSub50, sets.DT)
  sets.idle.DT.Regen.Refresh = set_combine(sets.idle.Regen.Refresh, sets.DT)
  sets.idle.DT.Regen.RefreshSub50 = set_combine(sets.idle.Regen.RefreshSub50, sets.DT)
  sets.idle.DT.Regain.Regen.Refresh = set_combine(sets.idle.Regain.Regen.Refresh, sets.DT)
  sets.idle.DT.Regain.Regen.RefreshSub50 = set_combine(sets.idle.Regain.Regen.RefreshSub50, sets.DT)


  ------------------------------------------------------------------------------------------------
  ---------------------------------------- Defense Sets ------------------------------------------
  ------------------------------------------------------------------------------------------------

  sets.defense.Knockback = {
    -- back="Repulse Mantle"
  }

  -- Protect V = 0%, PDT cap is 50%
  sets.defense.PDT = {
    sub="Refined Grip +1", --3/3
    ammo="Staunch Tathlum", --2/2
    head="Meghanada Visor +2", --5/0
    body="Futhark Coat +1", --7/7
    hands="Turms Mittens",
    legs="Erilaz Leg Guards +1", --7/0
    feet="Turms Leggings",
    neck="Futhark Torque +1", --4/4
    waist="Engraved Belt",
    ear1="Odnowa Earring +1", --3/5
    ear2="Eabani Earring",
    ring1="Epona's Ring",
    ring2="Defending Ring", --10/10
    back=gear.RUN_HPD_Cape, --10/0
    -- ammo="Staunch Tathlum +1", --3/3
    -- head="Turms Cap +1",
    -- body="Runeist's Coat +3",
    -- hands="Turms Mittens +1",
    -- feet="Turms Leggings +1",
    -- neck="Futhark Torque +2", --7/7
    -- ear1="Genmei Earring", --2/0
    -- ear2="Odnowa Earring +1",
    -- ring1="Gelatinous Ring +1", --7/(-1)
    -- ring2="Defending Ring", --10/10
    -- back=gear.RUN_HPD_Cape, --10/0
    -- waist="Engraved Belt",
  } --51 PDT + 5 PDT2 / 32 MDT

  -- Shell V = 29%, MDT cap is 50%
  sets.defense.MDT = {
    sub="Refined Grip +1", --3/3
    ammo="Staunch Tathlum", --2/2
    head="Ayanmo Zucchetto +2", --3/3
    body="Runeist's Coat +3",
    hands="Turms Mittens",
    legs="Erilaz Leg Guards +1", --7/0
    feet="Erilaz Greaves +1", --5/0
    neck="Futhark Torque +1", --4/4
    waist="Engraved Belt",
    ear1="Odnowa Earring +1", --3/5
    ear2="Eabani Earring",
    ring1=gear.Dark_Ring, --5/4
    ring2="Defending Ring", --10/10
    back=gear.RUN_HPD_Cape, --10/0
  } --51 PDT + 5 PDT2 / 30 MDT

  sets.defense.HP = {
    ammo="Staunch Tathlum",
    head="Ayanmo Zucchetto +2",
    body="Runeist's Coat +3",
    hands="Turms Mittens",
    legs="Erilaz Leg Guards +1", --7/0
    feet="Turms Leggings",
    neck="Futhark Torque +1",
    waist="Sailfi Belt +1",
    ear1="Brutal Earring",
    ear2="Sherida Earring",
    ring1="Epona's Ring",
    ring2="Ayanmo Ring",
    back=gear.RUN_HPD_Cape,
  }

  sets.defense.Parry = {
    hands="Turms Mittens", --Parry: Recover HP+75
    legs="Erilaz Leg Guards +1", --Inquartata+2
    feet="Turms Leggings", --Inquartata+4
    -- hands="Turms Mittens",
    -- legs="Eri. Leg Guards +1",
    -- feet="Turms Leggings",
    -- back=gear.RUN_HPP_Cape,
  }

  sets.defense.DeathResist = set_combine(sets.DeathResist, {})


  ------------------------------------------------------------------------------------------------
  ---------------------------------------- Engaged Sets ------------------------------------------
  ------------------------------------------------------------------------------------------------

  sets.engaged = {
    sub="Utu Grip",
    ammo="Seething Bomblet",
    head=gear.Adhemar_B_head,
    body="Ayanmo Corazza +2",
    hands=gear.Adhemar_B_hands,
    legs="Meghanada Chausses +2",
    feet=gear.Herc_TA_feet,
    neck="Anu Torque",
    waist="Sailfi Belt +1",
    ear1="Telos Earring",
    ear2="Sherida Earring",
    ring1="Epona's Ring",
    ring2="Ilabrat Ring",
    back="Atheling Mantle",
  }

  sets.engaged.LowAcc = set_combine(sets.engaged, {
    -- head="Dampening Tam",
    -- hands=gear.Adhemar_A_hands,
    -- neck="Combatant's Torque",
    -- waist="Ioskeha Belt +1",
  })

  sets.engaged.MidAcc = set_combine(sets.engaged.LowAcc, {
    -- ammo="Yamarang",
    ear1="Cessance Earring",
    -- ear2="Telos Earring",
    -- ring1="Regal Ring",
    -- feet=gear.Herc_STP_feet,
  })

  sets.engaged.HighAcc = set_combine(sets.engaged.MidAcc, {
    neck="Lissome Necklace",
    legs="Carmine Cuisses +1",
    -- ammo="C. Palug Stone",
    -- head="Carmine Mask +1",
    -- body="Carm. Sc. Mail +1",
    -- hands="Runeist's Mitons +3",
    -- legs="Carmine Cuisses +1",
    -- ear1="Odr Earring",
    -- ear2="Mache Earring +1",
    -- waist="Olseni Belt",
  })

  sets.engaged.STP = set_combine(sets.engaged, {
    head="Ayanmo Zucchetto +2",
    -- body="Ashera Harness",
    -- feet="Carmine Greaves +1",
    -- ear2="Dedition Earring",
    -- ring1={name="Chirich Ring +1", bag="wardrobe3"},
    -- ring2={name="Chirich Ring +1", bag="wardrobe4"},
    -- waist="Kentarch Belt +1",
  })

  sets.engaged.Aftermath = {
    head="Ayanmo Zucchetto +2",
    -- body="Ashera Harness",
    -- neck="Anu Torque",
    -- ear1="Sherida Earring",
    -- ear2="Dedition Earring",
    -- ring1={name="Chirich Ring +1", bag="wardrobe3"},
    -- ring2={name="Chirich Ring +1", bag="wardrobe4"},
    -- waist="Kentarch Belt +1",
  }


  ------------------------------------------------------------------------------------------------
  ---------------------------------------- Hybrid Sets -------------------------------------------
  ------------------------------------------------------------------------------------------------

  -- Shell V gives -29% MDT, PDT and MDT cap at 50%
  sets.Hybrid = {
    sub="Refined Grip +1", --3/3
    ammo="Staunch Tathlum", --2/2
    head="Ayanmo Zucchetto +2", --3/3
    body="Meghanada Cuirie +2", --8/0
    legs="Carmine Cuisses +1", --6/0
    neck="Futhark Torque +1", --4/4
    ring2="Defending Ring", --10/10
    back=gear.RUN_HPD_Cape, --10/0
    -- head=gear.Adhemar_D_head, --4/0
    -- neck="Futhark Torque +2", --7/7
    -- ring1="Moonlight Ring", --5/5
    -- ring2="Defending Ring", --10/10
    -- back=gear.RUN_TP_Cape, --10/0
  } --40 PDT + 5 PDT2 / 22 MDT

  sets.engaged.DT = set_combine(sets.engaged, sets.Hybrid)
  sets.engaged.LowAcc.DT = set_combine(sets.engaged.LowAcc, sets.Hybrid)
  sets.engaged.MidAcc.DT = set_combine(sets.engaged.MidAcc, sets.Hybrid)
  sets.engaged.HighAcc.DT = set_combine(sets.engaged.HighAcc, sets.Hybrid)
  sets.engaged.STP.DT = set_combine(sets.engaged.STP, sets.Hybrid)

  sets.engaged.Aftermath.DT = {
    head="Ayanmo Zucchetto +2",
    feet="Carmine Greaves +1",
    ear1="Sherida Earring",
    ring2="Defending Ring",
    -- head="Ayanmo Zucchetto +2",
    -- feet="Carmine Greaves +1",
    -- ear1="Sherida Earring",
    -- ear2="Telos Earring",
    -- ring1="Moonlight Ring",
    -- ring2="Defending Ring",
    -- waist="Kentarch Belt +1",
  }

  sets.engaged.Aftermath.DT = {
    legs="Meghanada Chausses +2",
    ring2="Defending Ring",
    waist="Sailfi Belt +1",
    head="Ayanmo Zucchetto +2",
    -- head="Ayanmo Zucchetto +2",
    -- body="Ashera Harness",
    -- hands=gear.Adhemar_A_hands,
    -- legs="Meghanada Chausses +2",
    -- feet=gear.Herc_STP_feet,
    -- neck="Futhark Torque +2",
    -- ear1="Sherida Earring",
    -- ear2="Dedition Earring",
    -- ring1="Moonlight Ring",
    -- ring2="Defending Ring",
    -- back=gear.RUN_TP_Cape,
    -- waist="Sailfi Belt +1",
  }

  ------------------------------------------------------------------------------------------------
  ---------------------------------------- Special Sets ------------------------------------------
  ------------------------------------------------------------------------------------------------

  sets.buff.Doom = {
    neck="Nicander's Necklace", --20
    ring1="Eshmun's Ring", --20
      -- ring2={name="Eshmun's Ring", bag="wardrobe4"}, --20
    waist="Gishdubar Sash", --10
  }

  sets.Kiting = {
    legs="Carmine Cuisses +1",
  }
  sets.Kiting.Adoulin = {
    body="Councilor's Garb",
  }
  sets.DeathResist = {
    ring1="Warden's Ring",
  }
  sets.Embolden = set_combine(sets.midcast.EnhancingDuration, {
    back="Evasionist's Cape"
  })
  sets.Obi = {
    -- waist="Hachirin-no-Obi"
  }
  sets.CP = {
    back=gear.CP_Cape,
  }
  sets.Reive = {
    neck="Ygnas's Resolve +1"
  }

  sets.Epeolatry = {
    -- main="Epeolatry"
  }
  sets.Lionheart = {
    -- main="Lionheart"
  }
  sets.Aettir = {
    -- main="Aettir"
  }
  sets.Lycurgos = {
    -- main="Lycurgos"
  }

end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

function job_precast(spell, action, spellMap, eventArgs)
  -- equip(sets[state.WeaponSet.current])

  if buffactive['terror'] or buffactive['petrification'] or buffactive['stun'] or buffactive['sleep'] then
    add_to_chat(167, 'Stopped due to status.')
    eventArgs.cancel = true
    return
  end
  if state.DefenseMode.value == 'Physical' and state.PhysicalDefenseMode.current == 'HP' then
    currentSpell = spell.english
    eventArgs.handled = true
    if spell.action_type == 'Magic' then
      equip(sets.precast.FC.HP)
    elseif spell.action_type == 'Ability' then
      equip(sets.Enmity.HP)
      equip(sets.precast.JA[currentSpell])
    end
  else
    if spell.action_type == 'Ability' and spell.type ~= 'WeaponSkill' then
      equip(sets.Enmity)
      equip(sets.precast.JA[spell])
    end
  end
  if spell.english == 'Lunge' then
    local abil_recasts = windower.ffxi.get_ability_recasts()
    if abil_recasts[spell.recast_id] > 0 then
      send_command('input /jobability "Swipe" <t>')
--    add_to_chat(122, '***Lunge Aborted: Timer on Cooldown -- Downgrading to Swipe.***')
      eventArgs.cancel = true
      return
    end
  end
  if spell.english == 'Valiance' then
    local abil_recasts = windower.ffxi.get_ability_recasts()
    if abil_recasts[spell.recast_id] > 0 then
      send_command('input /jobability "Vallation" <me>')
      eventArgs.cancel = true
      return
    elseif spell.english == 'Valiance' and buffactive['vallation'] then
      cast_delay(0.2)
      send_command('cancel Vallation') -- command requires 'cancel' add-on to work
    end
  end
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
  if spell.type == "WeaponSkill" then
    if buffactive['Reive Mark'] then
      equip(sets.Reive)
    end
  end
end

function job_midcast(spell, action, spellMap, eventArgs)
  if state.DefenseMode.value == 'Physical' and state.PhysicalDefenseMode.current == 'HP' and spell.english ~= "Phalanx" then
    eventArgs.handled = true
    if spell.action_type == 'Magic' then
      if spell.english == 'Flash' or spell.english == 'Foil' or spell.english == 'Stun'
        or blue_magic_maps.Enmity:contains(spell.english) then
        equip(sets.Enmity.HP)
      elseif spell.skill == 'Enhancing Magic' then
        equip(sets.midcast.EnhancingDuration)
      end
    end
  end
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
end

function job_aftercast(spell, action, spellMap, eventArgs)
  -- equip(sets[state.WeaponSet.current])
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
  if state.WeaponLock.value == true then
    disable('main','sub')
  else
    enable('main','sub')
  end
  
  -- equip(sets[state.WeaponSet.current])

end

-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------

function job_handle_equipping_gear(playerStatus, eventArgs)
  update_weapons()
  check_gear()
  update_idle_groups()
end

function job_update(cmdParams, eventArgs)
  -- equip(sets[state.WeaponSet.current])
  handle_equipping_gear(player.status)
  update_weaponskill_binds()
end

-- Modify the default idle set after it was constructed.
function customize_idle_set(idleSet)
  if state.Knockback.value == true then
    idleSet = set_combine(idleSet, sets.defense.Knockback)
  end
  -- If not in DT mode put on move speed gear
  if state.IdleMode.current ~= 'DT' and state.DefenseMode.value == 'None' then
    if classes.CustomIdleGroups:contains('Adoulin') then
      idleSet = set_combine(idleSet, sets.Kiting.Adoulin)
    else
      idleSet = set_combine(idleSet, sets.Kiting)
    end
  end
  if state.CP.current == 'on' then
    idleSet = set_combine(idleSet, sets.CP)
  end
  if buffactive.Doom then
    idleSet = set_combine(idleSet, sets.buff.Doom)
  end

  return idleSet
end

-- Modify the default melee set after it was constructed.
function customize_melee_set(meleeSet)
  if buffactive['Aftermath: Lv.3'] and player.equipment.main == "Epeolatry"
      and state.DefenseMode.value == 'None' then
    if state.HybridMode.value == "DT" then
      meleeSet = set_combine(meleeSet, sets.engaged.Aftermath.DT)
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
  if state.CP.current == 'on' then
    meleeSet = set_combine(meleeSet, sets.CP)
  end
  if buffactive.Doom then
    meleeSet = set_combine(meleeSet, sets.buff.Doom)
  end

  return meleeSet
end

function customize_defense_set(defenseSet)
  if buffactive['Battuta'] then
    defenseSet = set_combine(defenseSet, sets.defense.Parry)
  end
  if state.Knockback.value == true then
    defenseSet = set_combine(defenseSet, sets.defense.Knockback)
  end
  if state.DeathResist.value == true then
    defenseSet = set_combine(defenseSet, sets.defense.DeathResist)
  end
  if state.CP.current == 'on' then
    defenseSet = set_combine(defenseSet, sets.CP)
  end
  if buffactive.Doom then
    defenseSet = set_combine(defenseSet, sets.buff.Doom)
  end

  return defenseSet
end

-- Function to display the current relevant user state when doing an update.
-- Set eventArgs.handled to true if display was handled, and you don't want the default info shown.
function display_current_job_state(eventArgs)
  local r_msg = state.Runes.current
  local r_color = ''
  if state.Runes.current == 'Ignis' then r_color = 167
  elseif state.Runes.current == 'Gelus' then r_color = 210
  elseif state.Runes.current == 'Flabra' then r_color = 204
  elseif state.Runes.current == 'Tellus' then r_color = 050
  elseif state.Runes.current == 'Sulpor' then r_color = 215
  elseif state.Runes.current == 'Unda' then r_color = 207
  elseif state.Runes.current == 'Lux' then r_color = 001
  elseif state.Runes.current == 'Tenebrae' then r_color = 160 end

  local cf_msg = ''
  if state.CombatForm.has_value then
    cf_msg = ' (' ..state.CombatForm.value.. ')'
  end

  local m_msg = state.OffenseMode.value
  if state.HybridMode.value ~= 'Normal' then
    m_msg = m_msg .. '/' ..state.HybridMode.value
  end

  local am_msg = '(' ..string.sub(state.AttackMode.value,1,1).. ')'

  local ws_msg = state.WeaponskillMode.value

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
      ..string.char(31,210).. ' Melee' ..cf_msg.. ': ' ..string.char(31,001)..m_msg.. string.char(31,002).. ' |'
      ..string.char(31,207).. ' WS' ..am_msg.. ': ' ..string.char(31,001)..ws_msg.. string.char(31,002)..  ' |'
      ..string.char(31,060)
      ..string.char(31,004).. ' Defense: ' ..string.char(31,001)..d_msg.. string.char(31,002).. ' |'
      ..string.char(31,008).. ' Idle: ' ..string.char(31,001)..i_msg.. string.char(31,002).. ' |'
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
  local wsmode
  if state.DefenseMode.value ~= 'None' or state.HybridMode.value == 'DT' then
    wsmode = 'Safe'
  elseif state.OffenseMode.value == 'LowAcc' then
    if player.tp == 3000 then
      wsmode = 'LowAccMaxTp'
    else
      wsmode = 'LowAcc'
    end
  elseif state.OffenseMode.value == 'MidAcc' then
    if player.tp == 3000 then
      wsmode = 'MidAccMaxTp'
    else
      wsmode = 'MidAcc'
    end
  elseif state.OffenseMode.value == 'HighAcc' then
    if player.tp == 3000 then
      wsmode = 'HighAccMaxTp'
    else
      wsmode = 'HighAcc'
    end
  elseif player.tp == 3000 then
    wsmode = 'MaxTp'
  end

  return wsmode
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

function test()
  send_command('input /lockstyleset '..lockstyleset)
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
  gearinfo(cmdParams, eventArgs)
  if cmdParams[1]:lower() == 'rune' then
    send_command('@input /ja '..state.Runes.value..' <me>')
  elseif cmdParams[1]:lower() == 'usekey' then
    send_command('cancel Invisible; cancel Hide; cancel Gestation')
    if player.target.type ~= 'NONE' then
      if player.target.name == 'Sturdy Pyxis' then
        send_command('@input /item "Forbidden Key" <t>')
      end
    end
  elseif cmdParams[1]:lower() == 'faceaway' then
    windower.ffxi.turn(player.facing - math.pi);
  elseif cmdParams[1]:lower() == 'toyweapon' then
    if cmdParams[2]:lower() == 'cycle' then
      cycle_toy_weapons('forward')
    elseif cmdParams[2]:lower() == 'cycleback' then
      cycle_toy_weapons('back')
    elseif cmdParams[2]:lower() == 'reset' then
      cycle_toy_weapons('reset')
    end
  elseif cmdParams[1]:lower() == 'test' then
    test()
  end
end

function gearinfo(cmdParams, eventArgs)
  if cmdParams[1] == 'gearinfo' then
    if not midaction() then
      job_update()
    end
  end
end

function check_gear()
  if no_swap_gear:contains(player.equipment.ring1) then
    disable("ring1")
  else
    enable("ring1")
  end
  if no_swap_gear:contains(player.equipment.ring2) then
    disable("ring2")
  else
    enable("ring2")
  end
end

windower.register_event('zone change',
  function()
    if no_swap_gear:contains(player.equipment.ring1) then
      enable("ring1")
      equip(sets.idle)
    end
    if no_swap_gear:contains(player.equipment.ring2) then
      enable("ring2")
      equip(sets.idle)
    end
  end
)

windower.raw_register_event('incoming chunk', function(id, data, modified, injected, blocked)
  -- Listen for kill message (when an enemy is defeated)
  if id == 0x029 then -- Combat messages
    local message_id = data:unpack("H",0x19)%2^15 -- Cut off the most significant bit
    if message_id == 6 then
      local defeated_mob_id = data:unpack("I",0x09)
      if rayke_target ~= nil and defeated_mob_id == rayke_target.id then
        -- Display message that Rayke has worn off (because Rayked mob was killed)
        display_rayke_worn()
      end
      if gambit_target ~= nil and defeated_mob_id == gambit_target.id then
        -- Display message that Gambit has worn off (because Gambited mob was killed)
        display_gambit_worn()
      end
    end
  end
end)

windower.raw_register_event('outgoing chunk', function(id, data, modified, injected, blocked)
  if id == 0x053 then -- Send lockstyle command to server
    local type = data:unpack("I",0x05)
    if type == 0 then -- This is lockstyle 'disable' command
      locked_style = false
    else -- Various diff ways to set lockstyle
      locked_style = true
    end
  end
end)

-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
  -- Default macro set/book: (set, book)
  if player.sub_job == 'BLU' then
    set_macro_page(1, 5)
  elseif player.sub_job == 'DRK' then
    set_macro_page(2, 5)
  elseif player.sub_job == 'WHM' then
    set_macro_page(3, 5)
  elseif player.sub_job == 'WAR' then
    set_macro_page(4, 5)
  else
    set_macro_page(5, 5)
  end
end

function set_lockstyle()
  -- Set lockstyle 2 seconds after changing job, trying immediately will error
  coroutine.schedule(function()
    if locked_style == false then
      send_command('input /lockstyleset '..lockstyleset)
    end
  end, 2)
  -- In case lockstyle was on cooldown for first command, try again (lockstyle has 10s cd)
  coroutine.schedule(function()
    if locked_style == false then
      send_command('input /lockstyleset '..lockstyleset)
    end
  end, 10)
end
