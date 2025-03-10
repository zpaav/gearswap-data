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
--              [ WIN+C ]           Toggle Capacity Points Mode
--
--  Abilities:  [ CTRL+- ]          Chain Affinity
--              [ CTRL+= ]          Burst Affinity
--              [ CTRL+[ ]          Efflux
--              [ ALT+[ ]           Diffusion
--              [ ALT+] ]           Unbridled Learning
--              [ CTRL+Numpad/ ]    Berserk
--              [ CTRL+Numpad* ]    Warcry
--              [ CTRL+Numpad- ]    Aggressor
--
--  Spells:     [ CTRL+` ]          Blank Gaze
--              [ ALT+Q ]            Nature's Meditation/Fantod
--              [ ALT+W ]           Cocoon/Reactor Cool
--              [ ALT+E ]           Erratic Flutter
--              [ ALT+R ]           Battery Charge/Refresh
--              [ ALT+T ]           Occultation
--              [ ALT+Y ]           Barrier Tusk/Phalanx
--              [ ALT+U ]           Diamondhide/Stoneskin
--              [ ALT+P ]           Mighty Guard/Carcharian Verve
--              [ WIN+, ]           Utsusemi: Ichi
--              [ WIN+. ]           Utsusemi: Ni
--
--  WS:         [ CTRL+Numpad7 ]    Savage Blade
--              [ CTRL+Numpad9 ]    Chant Du Cygne
--              [ CTRL+Numpad4 ]    Requiescat
--              [ CTRL+Numpad5 ]    Expiacion
--
--
--              (Global-Binds.lua contains additional non-job-related keybinds)


--------------------------------------------------------------------------------------------------------------------
-- Setup functions for this job.  Generally should not be modified.
-------------------------------------------------------------------------------------------------------------------

-- Initialization function for this job file.
function get_sets()
    mote_include_version = 2

    -- Load and initialize the include file.
    include('Mote-Include.lua')
    include('reorganizer-lib.lua')
    coroutine.schedule(function()
        send_command('lua l gearinfo')
        send_command('lua l reorganizer')
        send_command('lua l azureSets')
        send_command('gs reorg')
    end, 1)
end

-- Setup vars that are user-independent.  state.Buff vars initialized here will automatically be tracked.
function job_setup()
    state.Buff['Burst Affinity'] = buffactive['Burst Affinity'] or false
    state.Buff['Chain Affinity'] = buffactive['Chain Affinity'] or false
    state.Buff.Convergence = buffactive.Convergence or false
    state.Buff.Diffusion = buffactive.Diffusion or false
    state.Buff.Efflux = buffactive.Efflux or false

    state.Buff['Unbridled Learning'] = buffactive['Unbridled Learning'] or false
    blue_magic_maps = {}
    prevTagId = nil --Used for TH tagging

    -- Mappings for gear sets to use for various blue magic spells.
    -- While Str isn't listed for each, it's generally assumed as being at least
    -- moderately signficant, even for spells with other mods.

    -- Physical spells with no particular (or known) stat mods
    blue_magic_maps.Physical = S{'Bilgestorm'}

    -- Spells with heavy accuracy penalties, that need to prioritize accuracy first.
    blue_magic_maps.PhysicalAcc = S{'Heavy Strike'}

    -- Physical spells with Str stat mod
    blue_magic_maps.PhysicalStr = S{'Battle Dance','Bloodrake','Death Scissors','Dimensional Death',
        'Empty Thrash','Quadrastrike','Saurian Slide','Sinker Drill','Spinal Cleave','Sweeping Gouge',
        'Uppercut','Vertical Cleave'}

    -- Physical spells with Dex stat mod
    blue_magic_maps.PhysicalDex = S{'Amorphic Spikes','Asuran Claws','Barbed Crescent','Claw Cyclone',
        'Disseverment','Foot Kick','Frenetic Rip','Goblin Rush','Hysteric Barrage','Paralyzing Triad',
        'Seedspray','Sickle Slash','Smite of Rage','Terror Touch','Thrashing Assault','Vanity Dive'}

    -- Physical spells with Vit stat mod
    blue_magic_maps.PhysicalVit = S{'Body Slam','Cannonball','Delta Thrust','Glutinous Dart','Grand Slam',
        'Power Attack','Quad. Continuum','Sprout Smack','Sub-zero Smash'}

    -- Physical spells with Agi stat mod
    blue_magic_maps.PhysicalAgi = S{'Benthic Typhoon','Feather Storm','Helldive','Hydro Shot','Jet Stream',
        'Pinecone Bomb','Spiral Spin','Wild Oats'}

    -- Physical spells with Int stat mod
    blue_magic_maps.PhysicalInt = S{'Mandibular Bite','Queasyshroom'}

    -- Physical spells with Mnd stat mod
    blue_magic_maps.PhysicalMnd = S{'Ram Charge','Screwdriver','Tourbillion'}

    -- Physical spells with Chr stat mod
    blue_magic_maps.PhysicalChr = S{'Bludgeon'}

    -- Physical spells with HP stat mod
    blue_magic_maps.PhysicalHP = S{'Final Sting'}

    -- Magical spells with the typical Int mod
    blue_magic_maps.Magical = S{'Anvil Lightning','Blazing Bound','Bomb Toss','Cursed Sphere',
        'Droning Whirlwind','Embalming Earth','Entomb','Firespit','Foul Waters','Ice Break','Leafstorm',
        'Maelstrom','Molting Plumage','Nectarous Deluge','Regurgitation','Rending Deluge','Scouring Spate',
        'Silent Storm','Spectral Floe','Subduction','Tem. Upheaval','Water Bomb'}

    blue_magic_maps.MagicalDark = S{'Dark Orb','Death Ray','Eyes On Me','Evryone. Grudge','Palling Salvo',
        'Tenebral Crush'}

    blue_magic_maps.MagicalLight = S{'Blinding Fulgor','Diffusion Ray','Radiant Breath','Rail Cannon',
        'Retinal Glare'}

    -- Magical spells with a primary Mnd mod
    blue_magic_maps.MagicalMnd = S{'Acrid Stream','Magic Hammer','Mind Blast'}

    -- Magical spells with a primary Chr mod
    blue_magic_maps.MagicalChr = S{'Mysterious Light'}

    -- Magical spells with a Vit stat mod (on top of Int)
    blue_magic_maps.MagicalVit = S{'Thermal Pulse'}

    -- Magical spells with a Dex stat mod (on top of Int)
    blue_magic_maps.MagicalDex = S{'Charged Whisker','Gates of Hades'}

    -- Magical spells (generally debuffs) that we want to focus on magic accuracy over damage.
    -- Add Int for damage where available, though.
    blue_magic_maps.MagicAccuracy = S{'1000 Needles','Absolute Terror','Actinic Burst','Atra. Libations',
        'Auroral Drape','Awful Eye', 'Blank Gaze','Blastbomb','Blistering Roar','Blood Saber','Chaotic Eye',
        'Cimicine Discharge','Cold Wave','Corrosive Ooze','Demoralizing Roar','Digest','Dream Flower',
        'Enervation','Feather Tickle','Filamented Hold','Frightful Roar','Geist Wall','Hecatomb Wave',
        'Infrasonics','Jettatura','Light of Penance','Lowing','Mind Blast','Mortal Ray','MP Drainkiss',
        'Osmosis','Reaving Wind','Sandspin','Sandspray','Sheep Song','Soporific','Sound Blast',
        'Stinking Gas','Sub-zero Smash','Venom Shell','Voracious Trunk','Yawn','Cruel Joke'}

    -- Breath-based spells
    blue_magic_maps.Breath = S{'Bad Breath','Flying Hip Press','Frost Breath','Heat Breath','Hecatomb Wave',
        'Magnetite Cloud','Poison Breath','Self-Destruct','Thunder Breath','Vapor Spray','Wind Breath'}

    -- Stun spells
    blue_magic_maps.StunPhysical = S{'Frypan','Head Butt','Sudden Lunge','Tail slap','Whirl of Rage'}
    blue_magic_maps.StunMagical = S{'Blitzstrahl','Temporal Shift','Thunderbolt'}

    -- Healing spells
    blue_magic_maps.Healing = S{'Healing Breeze','Magic Fruit','Plenilune Embrace','Pollen','Restoral',
        'Wild Carrot'}

    -- Buffs that depend on blue magic skill
    blue_magic_maps.SkillBasedBuff = S{'Barrier Tusk','Diamondhide','Magic Barrier','Metallic Body',
        'Plasma Charge','Pyric Bulwark','Reactor Cool','Occultation'}

    -- Other general buffs
    blue_magic_maps.Buff = S{'Amplification','Animating Wail','Carcharian Verve','Cocoon',
        'Erratic Flutter','Exuviation','Fantod','Feather Barrier','Harden Shell','Memento Mori',
        'Nat. Meditation','Orcish Counterstance','Refueling','Regeneration','Saline Coat','Triumphant Roar',
        'Warm-Up','Winds of Promyvion','Zephyr Mantle'}

    blue_magic_maps.Refresh = S{'Battery Charge'}

    -- Spells that require Unbridled Learning to cast.
    unbridled_spells = S{'Absolute Terror','Bilgestorm','Blistering Roar','Bloodrake','Carcharian Verve','Cesspool',
        'Crashing Thunder','Cruel Joke','Droning Whirlwind','Gates of Hades','Harden Shell','Mighty Guard',
        'Polar Roar','Pyric Bulwark','Tearing Gust','Thunderbolt','Tourbillion','Uproot'}


    elemental_ws = S{'Flash Nova', 'Sanguine Blade'}

    --Organizer sets (used to make organizer fetch these items)
    sets.org.job = {}
	sets.org.job[1] = {main="Norgish Dagger",sub="Qutrub Knife"}

    -- JA IDs for actions that always have TH: Provoke, Animated Flourish
    info.default_ja_ids = S{35, 204}
    -- Unblinkable JA IDs for actions that always have TH: Quick/Box/Stutter Step, Desperate/Violent Flourish
    info.default_u_ja_ids = S{201, 202, 203, 205, 207}

    lockstyleset = 4
end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
    silibs.user_setup_hook()
    ----------- Non-silibs content goes below this line -----------
    -- state.OffenseMode:options('STP', 'Normal', 'DD', 'Burst', 'LowAcc', 'MidAcc', 'HighAcc')
    state.OffenseMode:options('Normal', 'DD')
    state.HybridMode:options('Normal', 'DT')
    state.RangedMode:options('Normal', 'Acc')
    state.WeaponskillMode:options('Normal', 'Acc')
    state.CastingMode:options('Normal', 'Resistant')
    state.PhysicalDefenseMode:options('PDT', 'MDT')
    state.IdleMode:options('Normal', 'Evasion', 'DT', 'Learning','CP')

    state.MagicBurst = M(false, 'Magic Burst')
    -- state.CP = M(false, "Capacity Points Mode")

    -- Additional local binds
    include('Global-Binds.lua') -- OK to remove this line
    include('Global-GEO-Binds.lua') -- OK to remove this line


    -- send_command('bind ^` gs c cycle treasuremode') -- Do NOT bind. Interferes with Mote-TreasureHunter
    send_command('bind !` gs c toggle MagicBurst')
    send_command('bind ^- input /ja "Chain Affinity" <me>')
    send_command('bind ^[ input /ja "Efflux" <me>')
    send_command('bind ^= input /ja "Burst Affinity" <me>')
    send_command('bind ![ input /ja "Diffusion" <me>')
    send_command('bind !] input /ja "Unbridled Learning" <me>')
    send_command('bind !e input /ma "Erratic Flutter" <me>')
    send_command('bind !t input /ma "Occultation" <me>')
    send_command('bind @w gs c WeaponLock') --Call function WeaponLock (do not call toggle)

    if player.sub_job == "RDM" then
        coroutine.schedule(function()
            send_command('aset set soloaoe')
        end, 2)
    end

    if player.sub_job == "DNC" or player.sub_job == "SMN" then
        coroutine.schedule(function()
            send_command('aset set tpdrain')
        end, 2)
    end

    if player.sub_job == "SCH" then
        coroutine.schedule(function()
            send_command('aset set healing')
        end, 2)
    end

    -- send_command('bind @c gs c toggle CP')

    if player.sub_job == 'WAR' then
        send_command('bind ^numpad/ input /ja "Berserk" <me>')
        send_command('bind ^numpad* input /ja "Warcry" <me>')
        send_command('bind ^numpad- input /ja "Aggressor" <me>')
    end

    send_command('bind ^numpad7 input /ws "Savage Blade" <t>')
    send_command('bind ^numpad9 input /ws "Chant du Cygne" <t>')
    send_command('bind ^numpad4 input /ws "Requiescat" <t>')
    send_command('bind ^numpad5 input /ws "Expiacion" <t>')
    send_command('bind ^numpad1 input /ws "Sanguine Blade" <t>')
    send_command('bind ^numpad2 input /ws "Black Halo" <t>')

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
    send_command('unbind ^-')
    send_command('unbind ^=')
    send_command('unbind ^[')
    send_command('unbind ![')
    send_command('unbind !]')
    send_command('unbind !q')
    send_command('unbind !w')
    send_command('bind !e input /ma Haste <stpc>')
    send_command('bind !t input /ma Blink <me>')
    send_command('bind !r input /ma Refresh <stpc>')
    send_command('bind !y input /ma Phalanx <me>')
    send_command('bind !u input /ma Stoneskin <me>')
    send_command('unbind !p')
    send_command('unbind ^,')
    send_command('unbind @M')

    -- send_command('unbind @c')
    send_command('unbind ^numlock')
    send_command('unbind ^numpad/')
    send_command('unbind ^numpad*')
    send_command('unbind ^numpad-')
    send_command('unbind ^numpad7')
    send_command('unbind ^numpad9')
    send_command('unbind ^numpad4')
    send_command('unbind ^numpad5')
    send_command('unbind ^numpad1')
    send_command('unbind ^numpad2')

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

    send_command('lua u azureSets')
    send_command('lua u gearinfo')
end

-- Define sets and vars used by this job file.
function init_gear_sets()

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Precast Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    -- Precast sets to enhance JAs

    -- Enmity set
    sets.Enmity = {
        -- ammo="Sapience Orb", --2
        -- head="Halitus Helm", --8
        -- body="Emet Harness +1", --10
        -- hands="Kurys Gloves", --9
        -- feet="Ahosi Leggings", --7
        neck="Unmoving Collar +1", --10
        ear1="Cryptic Earring", --4
        -- ear2="Trux Earring", --5
        -- ring1="Pernicious Ring", --5
        -- ring2="Eihwaz Ring", --5
        -- waist="Kasiri Belt", --3
        }

    sets.precast.JA['Provoke'] = sets.Enmity

    sets.buff['Burst Affinity'] = {
        legs="Assim. Shalwar +3",
        -- feet="Hashi. Basmak +1"
    }
    sets.buff['Diffusion'] = {
        -- feet="Luhlaza Charuqs +3"
    }
    sets.buff['Efflux'] = {
        -- legs="Hashishin Tayt +1"
    }

    sets.precast.JA['Azure Lore'] = {
        -- hands="Luh. Bazubands +1"
    }
    sets.precast.JA['Chain Affinity'] = {
        -- feet="Assim. Charuqs +1"
    }
    sets.precast.JA['Convergence'] = {
        -- head="Luh. Keffiyeh +3"
    }
    sets.precast.JA['Enchainment'] = {
        -- body="Luhlaza Jubbah +3"
    }

    sets.precast.FC = {
        -- Lots of BLU spells dmg based on tp. Do not swap weapons on FC
        -- main = "Colada", --4
        -- ammo="Sapience Orb", --2
        head="Carmine Mask +1", --14
        body="Taeon Tabard", --4
        hands={ name="Leyline Gloves", augments={'Accuracy+14','Mag. Acc.+13','"Mag.Atk.Bns."+13','"Fast Cast"+2',}}, --7
        legs="Aya. Cosciales +2", --6
        feet=gear.Telchine_ENH_feet, --5
        neck="Voltsurge torque", --4
        -- neck="Loricate Torque +1",
        ear1="Loquacious Earring", --2
        ear2="Enchntr. Earring +1", --2
        ring1="Kishar Ring", --4
        ring2="Weather. Ring", --5
        back=gear.BLU_FC_Cape, --10
        waist="Witful Belt", --3
    }--66 FC, Sub RDM +15 FC

    -- sets.precast.FC['Blue Magic'] = set_combine(sets.precast.FC, {body="Hashishin Mintan +1"})
    sets.precast.FC['Blue Magic'] = sets.precast.FC
    sets.precast.FC['Enhancing Magic'] = set_combine(sets.precast.FC, {waist="Siegel Sash"})
    sets.precast.FC.Cure = set_combine(sets.precast.FC, {ammo="Impatiens", ear1="Mendi. Earring"})

    sets.precast.FC.Utsusemi = set_combine(sets.precast.FC, {
        ammo="Impatiens",
        -- ring1="Lebeche Ring",
        waist="Rumination Sash",
        })


    ------------------------------------------------------------------------------------------------
    ------------------------------------- Weapon Skill Sets ----------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.precast.WS = {
        -- ammo="Aurgelmir Orb +1",
        -- head=gear.Herc_WSD_head,
        -- body="Assim. Jubbah +3",
        hands="Jhakri Cuffs +2",
        -- legs="Luhlaza Shalwar +3",
        -- feet=gear.Herc_WS_feet,
        neck="Fotia Gorget",
        ear1="Moonshade Earring",
        ear2="Ishvara Earring",
        ring1="Epaminondas's Ring",
        ring2="Beithir Ring",
        -- back=gear.BLU_WS2_Cape,
        waist="Fotia Belt",
        }

    sets.precast.WS.Acc = set_combine(sets.precast.WS, {
        ammo="Voluspa Tathlum",
        -- head="Dampening Tam",
        -- hands=gear.Herc_WS_hands,
        ear2="Telos Earring",
        })

    sets.precast.WS['Chant du Cygne'] = set_combine(sets.precast.WS, {
        -- head=gear.Adhemar_B_head,
        -- body="Abnoba Kaftan",
        -- hands=gear.Adhemar_B_hands,
        legs="Zoar Subligar +1",
        feet="Thereoid Greaves",
        neck="Mirage Stole +1",
        -- ear2="Brutal Earring",
        -- ring1="Begrudging Ring",
        ring2="Epona's Ring",
        -- back=gear.BLU_WS1_Cape,
        })

    sets.precast.WS['Chant du Cygne'].Acc = set_combine(sets.precast.WS['Chant du Cygne'], {
        ammo="Voluspa Tathlum",
        -- head="Dampening Tam",
        body=gear.Adhemar_B_body,
        -- hands=gear.Adhemar_A_hands,
        -- feet=gear.Herc_STP_feet,
        ear2="Mache Earring +1",
        })

    sets.precast.WS['Vorpal Blade'] = sets.precast.WS['Chant du Cygne']
    sets.precast.WS['Vorpal Blade'].Acc = sets.precast.WS['Chant du Cygne'].Acc

    sets.precast.WS['Savage Blade'] = set_combine(sets.precast.WS, {
        ammo="Coiste Bodhar", --Sub for Auggelmir Orb +1
        body="Nyame Mail",
        legs="Nyame Flanchard",
        hands="Nyame Gauntlets",
        head="Nyame Helm",
        feet="Nyame Sollerets",
        ear1 = "Ishvara Earring",
        ear2 = "Moonshade Earring",
        neck="Mirage Stole +1",
        ring1="Epaminondas's Ring",
        ring2="Beithir Ring",
        waist="Sailfi Belt +1",
        back=gear.BLU_WSD_Cape,
        })

    sets.precast.WS['Savage Blade'].Acc = set_combine(sets.precast.WS['Savage Blade'], {
        ammo="Voluspa Tathlum",
        -- feet=gear.Herc_STP_feet,
        -- ear2="Telos Earring",
        -- waist="Grunfeld Rope",
        })

    sets.precast.WS['Requiescat'] = {
        -- head="Luh. Keffiyeh +3",
        -- body="Luhlaza Jubbah +3",
        hands="Jhakri Cuffs +2",
        -- legs="Luhlaza Shalwar +3",
        -- feet="Luhlaza Charuqs +3",
        neck="Fotia Gorget",
        ear1="Moonshade Earring",
        -- ear2="Brutal Earring",
        -- ring1="Rufescent Ring",
        ring2="Epona's Ring",
        -- back=gear.BLU_WS1_Cape,
        waist="Fotia Belt",
        }

    sets.precast.WS['Requiescat'].Acc = set_combine(sets.precast.WS['Requiescat'], {
        ammo="Voluspa Tathlum",
        -- head="Dampening Tam",
        -- feet=gear.Herc_STP_feet,
        -- ear1="Cessance Earring",
        ear2="Telos Earring",
        })

    sets.precast.WS['Expiacion'] = sets.precast.WS['Savage Blade']

    sets.precast.WS['Expiacion'].Acc = set_combine(sets.precast.WS['Expiacion'], {
        body=gear.Adhemar_B_body,
        -- feet=gear.Herc_STP_feet,
        ear2="Telos Earring",
        })

    sets.precast.WS['Sanguine Blade'] = {
        ammo="Pemphredo Tathlum",
        head="Pixie Hairpin +1",
        -- body="Amalric Doublet +1",
        -- hands="Amalric Gages +1",
        -- legs="Luhlaza Shalwar +3",
        -- feet="Amalric Nails +1",
        -- neck="Baetyl Pendant",
        ear1="Moonshade Earring",
        ear2="Regal Earring",
        ring1="Epaminondas's Ring",
        -- ring2="Archon Ring",
        back=gear.BLU_FC_Cape,
        -- waist="Sacro Cord",
        }

    sets.precast.WS['True Strike'] = sets.precast.WS['Savage Blade']
    sets.precast.WS['True Strike'].Acc = sets.precast.WS['Savage Blade'].Acc
    sets.precast.WS['Judgment'] = sets.precast.WS['True Strike']
    sets.precast.WS['Judgment'].Acc = sets.precast.WS['True Strike'].Acc

    sets.precast.WS['Black Halo'] = set_combine(sets.precast.WS['Savage Blade'], {
        -- ear2="Regal Earring",
        ear2="Odnowa Earring +1",
        waist="Sailfi Belt +1",
        })

    sets.precast.WS['Black Halo'].Acc = set_combine(sets.precast.WS['Black Halo'], {
        -- feet=gear.Herc_STP_feet,
        ear2="Telos Earring",
        })

    sets.precast.WS['Realmrazer'] = sets.precast.WS['Requiescat']
    sets.precast.WS['Realmrazer'].Acc = sets.precast.WS['Requiescat'].Acc

    sets.precast.WS['Flash Nova'] = set_combine(sets.precast.WS['Sanguine Blade'], {
        -- head=gear.Herc_MAB_head,
        ring2="Weather. Ring",
        })

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Midcast Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.midcast.FastRecast = sets.precast.FC

    sets.midcast.SpellInterrupt = {
        -- ammo="Impatiens", --10
        ring1="Evanescence Ring", --5
        waist="Rumination Sash", --10
        }

    sets.midcast['Blue Magic'] = set_combine(sets.midcast.FastRecast, {
        -- ammo="Mavi Tathlum",
        -- head="Luh. Keffiyeh +3",
        -- body="Assim. Jubbah +3",
        -- hands="Rawhide Gloves",
        -- legs="Hashishin Tayt +1",
        -- feet="Luhlaza Charuqs +3",
        neck="Mirage Stole +1",
        -- ear1="Njordr Earring",
        ear1="Odnowa Earring +1",
        -- waist="Oneiros Belt",
        ring1="Gelatinous Ring +1",
        ring1={name="Stikini Ring +1", bag="wardrobe3"},
        ring2={name="Stikini Ring +1", bag="wardrobe4"},
        back="Cornflower Cape",
        })

    sets.midcast['Blue Magic'].Physical = {
        -- ammo="Aurgelmir Orb +1",
        -- head="Luh. Keffiyeh +3",
        -- body="Luhlaza Jubbah +3",
        hands="Jhakri Cuffs +2",
        -- legs="Luhlaza Shalwar +3",
        -- feet="Luhlaza Charuqs +3",
        -- neck="Caro Necklace",
        -- ring1="Shukuyu Ring",
        -- ring2="Ilabrat Ring",
        -- back=gear.BLU_WS2_Cape,
        waist="Sailfi Belt +1",
        }

    sets.midcast['Blue Magic'].PhysicalAcc = set_combine(sets.midcast['Blue Magic'].Physical, {
        ammo="Voluspa Tathlum",
        head="Carmine Mask +1",
        -- hands=gear.Adhemar_A_hands,
        legs="Carmine Cuisses +1",
        -- feet=gear.Herc_STP_feet,
        neck="Mirage Stole +1",
        ear2="Telos Earring",
        back="Cornflower Cape",
        waist="Grunfeld Rope",
        })

    sets.midcast['Blue Magic'].PhysicalStr = sets.midcast['Blue Magic'].Physical

    sets.midcast['Blue Magic'].PhysicalDex = set_combine(sets.midcast['Blue Magic'].Physical, {
        ear2="Mache Earring +1",
        ring2="Ilabrat Ring",
        -- back=gear.BLU_WS1_Cape,
        waist="Grunfeld Rope",
        })

    sets.midcast['Blue Magic'].PhysicalVit = sets.midcast['Blue Magic'].Physical

    sets.midcast['Blue Magic'].PhysicalAgi = set_combine(sets.midcast['Blue Magic'].Physical, {
        -- hands=gear.Adhemar_B_hands,
        -- ring2="Ilabrat Ring",
        })

    sets.midcast['Blue Magic'].PhysicalInt = set_combine(sets.midcast['Blue Magic'].Physical, {
        -- ear2="Regal Earring",
        -- ring1="Shiva Ring +1",
        ring2="Metamor. Ring +1",
        back=gear.BLU_MAB_Cape,
        waist="Acuity Belt +1",
        })

    sets.midcast['Blue Magic'].PhysicalMnd = set_combine(sets.midcast['Blue Magic'].Physical, {
        ear2="Regal Earring",
        ring1={name="Stikini Ring +1", bag="wardrobe3"},
        ring2={name="Stikini Ring +1", bag="wardrobe4"},
        })

    sets.midcast['Blue Magic'].PhysicalChr = set_combine(sets.midcast['Blue Magic'].Physical, {ear1="Regal Earring", ear2="Enchntr. Earring +1"})

    sets.midcast['Blue Magic'].Magical = {
        main="Bunzi's Rod",
        sub="Maxentius",
        ammo="Ghastly Tathlum +1",
        -- ammo="Pemphredo Tathlum",
        -- head=gear.Herc_MAB_head,
        head="Jhakri Coronal +2",
        -- body="Jhakri Robe +2",
        body="Nyame Mail",  --9DT
        hands="Jhakri Cuffs +2",
        -- legs="Jhakri Slops +2",
        legs="Nyame Flanchard",
        feet="Jhakri Pigaches +2",
        neck="Loricate torque +1", --6DT
        -- waist="Acuity belt +1",
        waist="Flume Belt +1", --4PDT
        ear1="Regal Earring",
        ear2="Friomisi Earring",
        ring1="Defending Ring", --10DT
        -- ring2="Gelatinous Ring +1", --7PDT
        -- body="Amalric Doublet +1",
        -- hands="Amalric Gages +1",
        -- legs="Amalric Slops +1",
        -- feet="Amalric Nails +1",
        -- neck="Baetyl Pendant",
        -- ear2="Regal Earring",
        -- ring1="Shiva Ring +1",
        ring2="Metamor. Ring +1",
        -- back=gear.BLU_MAB_Cape, --10PDT
        back="Cornflower Cape",
        -- waist="Orpheus's Sash",
        } --16DT, 21PDT

    sets.midcast['Blue Magic'].Magical.Resistant = set_combine(sets.midcast['Blue Magic'].Magical, {
        head="Assim. Keffiyeh +3",
        hands="Jhakri Cuffs +2",
        -- legs="Luhlaza Shalwar +3",
        neck="Mirage Stole +1",
        -- ear1="Digni. Earring",
        ring1={name="Stikini Ring +1", bag="wardrobe3"},
        ring2={name="Stikini Ring +1", bag="wardrobe4"},
        waist="Acuity Belt +1",
        })

    sets.midcast['Blue Magic'].MagicalDark = set_combine(sets.midcast['Blue Magic'].Magical, {
        head="Pixie Hairpin +1",
        -- ring2="Archon Ring",
        })

    sets.midcast['Blue Magic'].MagicalLight = set_combine(sets.midcast['Blue Magic'].Magical, {
        ring2="Weather. Ring"
        })

    sets.midcast['Blue Magic'].MagicalMnd = set_combine(sets.midcast['Blue Magic'].Magical, {
        ring1={name="Stikini Ring +1", bag="wardrobe3"},
        ring2={name="Stikini Ring +1", bag="wardrobe4"},
        })

    sets.midcast['Blue Magic'].MagicalDex = set_combine(sets.midcast['Blue Magic'].Magical, {
        -- ammo="Aurgelmir Orb +1",
        ear2="Mache Earring +1",
        ring2="Ilabrat Ring",
        })

    sets.midcast['Blue Magic'].MagicalVit = set_combine(sets.midcast['Blue Magic'].Magical, {
        -- ammo="Aurgelmir Orb +1",
        })

    sets.midcast['Blue Magic'].MagicalChr = set_combine(sets.midcast['Blue Magic'].Magical, {
        ammo="Voluspa Tathlum",
        ear1="Regal Earring",
        ear2="Enchntr. Earring +1"
        })

    sets.midcast['Blue Magic'].MagicAccuracy = {
        -- main="Sakpata's Sword", --Needs 25 for +10 macc
        main="Tizona",
        sub="Bunzi's Rod", --40 macc
        -- sub="Maxentius", --40 macc
        ammo="Pemphredo Tathlum",
        head="Assim. Keffiyeh +3",
        body="Malignance Tabard",
        hands="Malignance Gloves",
        legs="Assim. Shalwar +3",
        feet="Malignance Boots",
        neck="Mirage Stole +1",
        ear1="Digni. Earring",
        ear2="Regal Earring",
        ring1={name="Stikini Ring +1", bag="wardrobe3"},
        ring2={name="Stikini Ring +1", bag="wardrobe4"},
        back="Aurist's Cape +1",
        waist="Acuity Belt +1",
    }

    sets.midcast['Blue Magic'].Breath = set_combine(sets.midcast['Blue Magic'].Magical, {
        -- head="Luh. Keffiyeh +3"
    })

    sets.midcast['Blue Magic'].StunPhysical = set_combine(sets.midcast['Blue Magic'].MagicAccuracy, {
        ammo="Voluspa Tathlum",
        head="Malignance Chapeau",
        body="Malignance Tabard",
        hands="Malignance Gloves",
        legs="Malignance Tights",
        feet="Malignance Boots",
        neck="Mirage Stole +1",
        ear2="Mache Earring +1",
        back=gear.BLU_DA_Cape,
        waist="Eschan Stone",
        })

    sets.midcast['Blue Magic'].StunMagical = sets.midcast['Blue Magic'].MagicAccuracy

    sets.midcast['Blue Magic'].Healing = { --Focus cure potency
        main="Bunzi's Rod", --30CP
        sub="Sors Shield", --3CP
        ammo="Staunch Tathlum +1", --3DT, 11SIRD
        head="Nyame Helm", --7DT
        -- body="Vrikodara Jupon", -- 13
        body="Nyame Mail", --9DT
        hands=gear.Telchine_ENH_hands, -- 10CP
        legs="Carmine cuisses +1", --20SIRD
        -- feet="Medium's Sabots", -- 12
        feet="Nyame Sollerets", --7DT
        neck="Incanter's Torque",
        ear1="Mendicant's Earring", -- 5
        ear2="Halasz Earring", --4SIRD
        -- ring1="Lebeche Ring", -- 3
        -- ring1={name="Stikini Ring +1", bag="wardrobe3"},
        ring1="Defending Ring", --10DT
        ring2={name="Stikini Ring +1", bag="wardrobe4"},
        -- back="Oretan. Cape +1", --6
        waist="Flume Belt +1", --4PDT
        back=gear.BLU_FC_Cape, --10PDT
    } --36DT, 14PDT, 48 Cure Potency

    sets.midcast['Blue Magic'].HealingSelf = set_combine(sets.midcast['Blue Magic'].Healing, {
        -- hands="Buremte Gloves", -- (13)
        -- legs="Gyve Trousers", -- 10
        -- neck="Phalaina Locket", -- 4(4)
        -- ring2="Asklepian Ring", -- (3)
        -- back="Solemnity Cape", --7
        waist="Gishdubar Sash", -- (10)
        })

    sets.midcast['Blue Magic']['White Wind'] = set_combine(sets.midcast['Blue Magic'].Healing, {
        -- head=gear.Adhemar_D_head,
        neck="Sanctity Necklace",
        ear2="Etiolation Earring",
        -- ring2="Eihwaz Ring",
        -- back="Moonlight Cape",
        -- waist="Kasiri Belt",
        })

    sets.midcast['Blue Magic'].Buff = sets.midcast['Blue Magic']
    sets.midcast['Blue Magic'].Refresh = set_combine(sets.midcast['Blue Magic'], {
        -- head="Amalric Coif +1",
        waist="Gishdubar Sash",
        back="Grapevine Cape"
    })
    sets.midcast['Blue Magic'].SkillBasedBuff = sets.midcast['Blue Magic']

    sets.midcast['Blue Magic']['Occultation'] = set_combine(sets.midcast['Blue Magic'], {
        -- hands="Hashi. Bazu. +1",
        -- ear1="Njordr Earring",
        ear2="Enchntr. Earring +1",
        ring2="Weather. Ring",
        neck="Incanter's torque",
        -- ring2="Weather. Ring",
        }) -- 1 shadow per 50 skill

    sets.midcast['Blue Magic']['Carcharian Verve'] = set_combine(sets.midcast['Blue Magic'].Buff, {
        -- head="Amalric Coif +1",
        -- waist="Emphatikos Rope",
        })

    sets.midcast['Enhancing Magic'] = {
        main="Sakpata's Sword", --10DT
        ammo="Staunch Tathlum +1", --3DT
        head="Carmine Mask +1",
        body=gear.Telchine_ENH_body,
        hands=gear.Telchine_ENH_hands,
        legs="Carmine Cuisses +1",
        feet=gear.Telchine_ENH_feet,
        neck="Incanter's Torque",
        ear1="Mimir Earring",
        ear2="Andoaa Earring",
        ring1="Defending Ring", --10DT
        -- ring1={name="Stikini Ring +1", bag="wardrobe3"},
        ring2={name="Stikini Ring +1", bag="wardrobe4"},
        -- back=gear.BLU_FC_Cape, --10PDT
        back="Fi Follet Cape +1", --9Skill
        waist="Olympus Sash",
    } --23DT

    sets.midcast.EnhancingDuration = {
        main="Sakpata's Sword", --10DT
        sub=gear.Colada_ENH,
        head=gear.Telchine_ENH_head,
        body=gear.Telchine_ENH_body,
        hands=gear.Telchine_ENH_hands,
        legs=gear.Telchine_ENH_legs,
        feet=gear.Telchine_ENH_feet,
        ammo="Staunch Tathlum +1", --3DT
        neck="Loricate Torque +1", --6DT
        ear1="Odnowa Earring +1", --3DT
        ear2="Andoaa Earring",
        ring1="Defending Ring", --10DT
        ring2={name="Stikini Ring +1", bag="wardrobe4"},
        waist="Flume Belt +1", --4PDT
        back=gear.BLU_FC_Cape, --10PDT
        } --36DT, 14PDT
        

    sets.midcast.Refresh = set_combine(sets.midcast.EnhancingDuration, {
        -- head="Amalric Coif +1",
        waist="Gishdubar Sash",
        back="Grapevine Cape"
    })

    sets.midcast.Stoneskin = set_combine(sets.midcast.EnhancingDuration, {
        hands="Stone Mufflers", --30
        waist="Siegel Sash", --20
        ear1="Earthcry Earring", --10
        ear2="Andoaa Earring",
        legs="Shedir Seraweels", --35
        -- ring1={name="Stikini Ring +1", bag="wardrobe3"}, --Defending Ring
        ring2={name="Stikini Ring +1", bag="wardrobe4"},
    })

    sets.midcast.Phalanx = set_combine(sets.midcast.EnhancingDuration, {
        main="Sakpata's Sword", --5
        body=gear.Taeon_Phalanx_body, --3(10)
        hands=gear.Taeon_Phalanx_hands, --3(10)
        legs=gear.Taeon_Phalanx_legs, --3(10)
        feet=gear.Taeon_Phalanx_feet, --3(10)
        })--+17 Phalanx

    sets.midcast.Aquaveil = set_combine(sets.midcast.EnhancingDuration, {
        -- head="Amalric Coif +1", --2
        -- hands="Regal Cuffs", --2
        -- waist="Emphatikos Rope", --1
        legs="Shedir Seraweels", --1
    })

    sets.midcast.Protect = set_combine(sets.midcast.EnhancingDuration, {
        -- ring1="Sheltered Ring"
    })
    sets.midcast.Protectra = sets.midcast.Protect
    sets.midcast.Shell = sets.midcast.Protect
    sets.midcast.Shellra = sets.midcast.Protect

    sets.midcast['Enfeebling Magic'] = set_combine(sets.midcast['Blue Magic'].MagicAccuracy, {
        ear2="Vor Earring",
        })

    sets.midcast.Utsusemi = sets.midcast.SpellInterrupt

    ------------------------------------------------------------------------------------------------
    ----------------------------------------- Idle Sets --------------------------------------------
    ------------------------------------------------------------------------------------------------

    -- Resting sets
    sets.resting = {}


    -- Idle sets (default idle set not needed since the other three are defined, but leaving for testing purposes)

    sets.idle = {
        main="Sakpata's Sword", --10
        sub="Bolelabunga", --1RF
        ammo="Staunch Tathlum +1", --3
        head="Nyame Helm", --7
        body="Jhakri robe +2", --4RF
        hands="Nyame Gauntlets", --7
        legs="Nyame Flanchard", --8
        feet="Hippomenes Socks", 
        neck="loricate torque +1", --6
        waist="Flume Belt +1", --4PDT
        ear1="Odnowa Earring +1", --3DT, 2MDT
        ear2="Eabani Earring", --MEVA
        -- ring1="Defending Ring", --10
        -- ring2="Gelatinous Ring +1", --7PDT
        ring1={name="Stikini Ring +1", bag="wardrobe3"}, --1RF
        ring2={name="Stikini Ring +1", bag="wardrobe4"}, --1RF
        back=gear.BLU_FC_Cape, --10PDT
    } --41 DT, 14 PDT, 2MDT, 7RF

    sets.idle.Evasion = { --Focus on DT cap and evasion
        main="Tizona",
        -- main="Sakpata's Sword", --10
        sub="Bolelabunga", --1RF
        ammo="Staunch Tathlum +1", --3DT
        head="Nyame Helm", --7DT, 91EVA
        body="Nyame Mail", --9DT, 102EVA
        hands="Nyame Gauntlets", --7DT, 80EVA
        legs="Nyame Flanchard", --8DT, 85EVA
        feet="Nyame Sollerets", --7DT, 119EVA,
        neck="Bathy Choker +1", --30EVA (after aug)
        waist="Shetal Stone", --10EVA
        ear1="Infused Earring", --10EVA
        ear2="Eabani Earring", --10EVA
        -- ring1="Vengeful Ring", --9EVA
        -- ring2="Beeline Ring", --6EVA
        ring1={name="Stikini Ring +1", bag="wardrobe3"}, --1RF
        ring2={name="Stikini Ring +1", bag="wardrobe4"}, --1RF
        back=gear.BLU_FC_Cape, --10PDT
    } --60 DT, 14 PDT, 2MDT, 7RF


    sets.idle.DT = set_combine(sets.idle, {
        ammo="Staunch Tathlum +1", --3/3
        head="Malignance Chapeau", --6/6
        body="Malignance Tabard", --9/9
        hands="Malignance Gloves", --5/5
        legs="Malignance Tights", --7/7
        feet="Malignance Boots", --4/4
        -- neck="Warder's Charm +1",
        -- ring1="Purity Ring", --0/4
        ring2="Defending Ring", --10/10
        -- back="Moonlight Cape", --6/6
        })

    sets.idle.Weak = sets.idle.DT

    sets.idle.Learning = set_combine(sets.idle, sets.Learning)


    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Engaged Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    -- Engaged sets

    -- Variations for TP weapon and (optional) offense/defense modes.  Code will fall back on previous
    -- sets if more refined versions aren't defined.
    -- If you create a set with both offense and defense modes, the offense mode should be first.
    -- EG: sets.engaged.Dagger.Accuracy.Evasion

    sets.engaged = {
        main="Maxentius",
        ammo="Coiste Bodhar",
        head="Malignance Chapeau",
        body="Malignance Tabard",
        hands="Malignance Gloves",
        legs="Malignance Tights",
        feet="Malignance Boots",
        neck="Loricate Torque +1",
        ear1="Eabani earring",
        ear2="Suppanomimi",
        ring1="Chirich Ring +1",
        ring2="Defending Ring",
        back=gear.BLU_DA_Cape, --10PDT
        waist="Windbuffet Belt +1",
        }

    sets.engaged.DD = set_combine(sets.engaged, {
        main="Naegling",
    })
	
	-- sets.engaged = {
        -- ammo="Aurgelmir Orb +1",
        -- head=gear.Adhemar_B_head,
        -- body=gear.Adhemar_B_body,
        -- hands=gear.Adhemar_B_hands,
        -- legs="Samnuha Tights",
        -- feet=gear.Herc_TA_feet,
        -- neck="Ainia Collar",
        -- ear1="Cessance Earring",
        -- ear2="Brutal Earring",
        -- ring1="Hetairoi Ring",
        -- ring2="Epona's Ring",
        -- back=gear.BLU_DA_Cape,
        -- waist="Windbuffet Belt +1",
        -- }

    sets.engaged.LowAcc = set_combine(sets.engaged, {
        -- head="Dampening Tam",
        -- hands=gear.Adhemar_A_hands,
        -- neck="Combatant's Torque",
        ring1="Chirich Ring +1",
        })

    sets.engaged.MidAcc = set_combine(sets.engaged.LowAcc, {
        ammo="Voluspa Tathlum",
        ear2="Telos Earring",
        -- ring1="Regal Ring",
        ring2="Ilabrat Ring",
        -- waist="Kentarch Belt +1",
        })

    sets.engaged.HighAcc = set_combine(sets.engaged.MidAcc, {
        head="Carmine Mask +1",
        legs="Carmine Cuisses +1",
        -- feet=gear.Herc_STP_feet,
        neck="Mirage Stole +1",
        ear2="Mache Earring +1",
        ring1="Chirich Ring +1",
        waist="Olseni Belt",
        })

    sets.engaged.STP = set_combine(sets.engaged, {
        -- head=gear.Herc_STP_head,
        feet="Carmine Greaves +1",
        ring1="Chirich Ring +1",
        ring2="Chirich Ring +1",
        })

    -- Base Dual-Wield Values:
    -- * DW6: +37%
    -- * DW5: +35%
    -- * DW4: +30%
    -- * DW3: +25% (NIN Subjob)
    -- * DW2: +15% (DNC Subjob)
    -- * DW1: +10%

    sets.engaged.DW = {
        ammo="Coiste Bodhar",
        head="Malignance Chapeau", --6DT
        body=gear.Adhemar_B_body, --6DW
        hands="Malignance Gloves", --5DT
        legs="Carmine Cuisses +1", --6DW
        feet=gear.Taeon_DW_feet, --+4% DW +5 DW (Aug)
        neck="Loricate Torque +1", --6DT
        ear1="Eabani earring", --4DW
        ear2="Suppanomimi", --5DW
        ring1="Epona's Ring",
        ring2="Defending Ring", --10DT
        back=gear.BLU_DA_Cape, --10PDT
        waist="Reiki Yotai", --7DW
    } --37%DW, 27DT, 10PDT

    sets.engaged.DW.DD = set_combine(sets.engaged, {
            main="Naegling",
            sub="Thibron",
    })
    
    sets.engaged.DW.Burst = set_combine(sets.engaged, {
            -- main="Maxentius",
            -- sub="Kaja Rod",
            -- feet="Herculean boots",
    })

    sets.engaged.DW.LowAcc = set_combine(sets.engaged.DW, {
        -- head="Dampening Tam",
        -- hands=gear.Adhemar_A_hands,
        -- neck="Combatant's Torque",
        ring1={name="Chirich Ring +1",bag="wardrobe3"},
        })

    sets.engaged.DW.MidAcc = set_combine(sets.engaged.DW.LowAcc, {
        ammo="Voluspa Tathlum",
        ear2="Telos Earring",
        ring2="Ilabrat Ring",
        -- waist="Kentarch Belt +1",
        })

    sets.engaged.DW.HighAcc = set_combine(sets.engaged.DW.MidAcc, {
        head="Carmine Mask +1",
        -- feet=gear.Herc_STP_feet,
        neck="Mirage Stole +1",
        -- ear1="Cessance Earring",
        ear2="Mache Earring +1",
        ring1={name="Chirich Ring +1",bag="wardrobe3"},
        waist="Olseni Belt",
        })

    sets.engaged.DW.STP = set_combine(sets.engaged.DW, {
        -- head=gear.Herc_STP_head,
        ring1={name="Chirich Ring +1",bag="wardrobe3"},
        ring2={name="Chirich Ring +1",bag="wardrobe4"},
        })

    -- 15% Magic Haste (67% DW to cap)
    sets.engaged.DW.LowHaste = set_combine(sets.engaged.DW, {
        ammo="Coiste Bodhar",
        -- head=gear.Adhemar_B_head,
        head="Malignance Chapeau", --6DT
        body=gear.Adhemar_B_body, --6
        body="Malignance Tabard",
        -- hands=gear.Adhemar_B_hands,
        hands="Malignance Gloves", --5DT
        legs="Carmine Cuisses +1", --6
        feet=gear.Taeon_DW_feet, --9
        neck="Loricate Torque +1", --6DT
        ear1="Eabani Earring", --4
        ear2="Suppanomimi", --5
        ring1={name="Chirich Ring +1",bag="wardrobe3"},
        ring2="Defending Ring", --10DT
        back=gear.BLU_DA_Cape,
        waist="Reiki Yotai", --7
        }) -- 30%

    sets.engaged.DW.LowAcc.LowHaste = set_combine(sets.engaged.DW.LowHaste, {
        -- head="Dampening Tam",
        -- hands=gear.Adhemar_A_hands,
        -- neck="Combatant's Torque",
        ring1={name="Chirich Ring +1",bag="wardrobe3"},
        })

    sets.engaged.DW.MidAcc.LowHaste = set_combine(sets.engaged.DW.LowAcc.LowHaste, {
        ammo="Voluspa Tathlum",
        ear2="Telos Earring",
        ring2="Ilabrat Ring",
        -- waist="Kentarch Belt +1",
        })

    sets.engaged.DW.HighAcc.LowHaste = set_combine(sets.engaged.DW.MidAcc.LowHaste, {
        -- head="Carmine Mask +1",
        -- feet=gear.Herc_STP_feet,
        neck="Mirage Stole +1",
        -- ear1="Cessance Earring",
        ear2="Mache Earring +1",
        ring1={name="Chirich Ring +1",bag="wardrobe3"},
        waist="Olseni Belt",
        })

    sets.engaged.DW.STP.LowHaste = set_combine(sets.engaged.DW.LowHaste, {
        -- head=gear.Adhemar_B_head,
        neck="Lissome Necklace",
        ring1={name="Chirich Ring +1",bag="wardrobe3"},
        ring2={name="Chirich Ring +1",bag="wardrobe4"},
        })

    -- 30% Magic Haste (56% DW to cap)
    sets.engaged.DW.MidHaste = set_combine(sets.engaged.DW.LowHaste, {
        -- ammo="Aurgelmir Orb +1",
        -- head=gear.Adhemar_B_head,
        -- hands=gear.Adhemar_B_hands,
        -- legs="Samnuha Tights",
        -- neck="Ainia Collar",
        -- ear1="Cessance Earring",
        ammo="Coiste Bodhar",
        head="Malignance Chapeau", --6DT
        body=gear.Adhemar_B_body, --6DW
        hands="Malignance Gloves", --5DT
        legs="Malignance Tights", --7DT
        feet=gear.Taeon_DW_feet, --9
        neck="Loricate Torque +1", --6DT
        ear2="Suppanomimi", --5
        ring1="Epona's Ring",
        -- ring2="Defending Ring", --10DT
        ring2="Hetairoi Ring",
        back=gear.BLU_DA_Cape, --10PDT
        waist="Reiki Yotai", --7
        }) -- 27% (assumed 30% from traits), 24DT, 10PDT

    sets.engaged.DW.LowAcc.MidHaste = set_combine(sets.engaged.DW.MidHaste, {
        -- head="Dampening Tam",
        -- hands=gear.Adhemar_A_hands,
        -- neck="Combatant's Torque",
        ring1={name="Chirich Ring +1",bag="wardrobe3"},
        })

    sets.engaged.DW.MidAcc.MidHaste = set_combine(sets.engaged.DW.LowAcc.MidHaste, {
        ammo="Voluspa Tathlum",
        -- feet=gear.Herc_TA_feet,
        ear2="Telos Earring",
        ring2="Ilabrat Ring",
        -- waist="Kentarch Belt +1",
        })

    sets.engaged.DW.HighAcc.MidHaste = set_combine(sets.engaged.DW.MidAcc.MidHaste, {
        head="Carmine Mask +1",
        legs="Carmine Cuisses +1",
        -- feet=gear.Herc_STP_feet,
        neck="Mirage Stole +1",
        -- ear1="Cessance Earring",
        ear2="Mache Earring +1",
        ring1={name="Chirich Ring +1",bag="wardrobe3"},
        waist="Olseni Belt",
        })

    sets.engaged.DW.STP.MidHaste = set_combine(sets.engaged.DW.MidHaste, {
        -- head=gear.Herc_STP_head,
        ear1="Dedition Earring",
        ring1="Chirich Ring +1",
        ring2="Chirich Ring +1",
        })

    -- 35% Magic Haste (51% DW to cap)
    sets.engaged.DW.HighHaste = set_combine(sets.engaged.DW.MidHaste, {
        -- ammo="Aurgelmir Orb +1",
        -- head=gear.Adhemar_B_head,
        -- hands=gear.Adhemar_B_hands,
        -- legs="Samnuha Tights",
        -- feet=gear.Herc_TA_feet,
        -- neck="Ainia Collar",
        ammo="Coiste Bodhar",
        head="Malignance Chapeau",
        body=gear.Adhemar_B_body, --6
        hands="Malignance Gloves",
        legs="Malignance Tights",
        feet="Malignance Boots",
        neck="Loricate Torque +1",
        ear1="Eabani Earring", --4
        ear2="Suppanomimi", --5
        ring2="Hetairoi Ring",
        ring1="Epona's Ring",
        back=gear.BLU_DA_Cape,
        waist="Reiki Yotai", --7
        }) -- 22% (assumed 30% from traits)

    sets.engaged.DW.LowAcc.HighHaste = set_combine(sets.engaged.DW.HighHaste, {
        -- head="Dampening Tam",
        -- hands=gear.Adhemar_A_hands,
        -- neck="Combatant's Torque",
        ring1={name="Chirich Ring +1",bag="wardrobe3"},
        -- waist="Kentarch Belt +1",
        })

    sets.engaged.DW.MidAcc.HighHaste = set_combine(sets.engaged.DW.LowAcc.HighHaste, {
        ammo="Voluspa Tathlum",
        ear2="Telos Earring",
        ring2="Ilabrat Ring",
        })

    sets.engaged.DW.HighAcc.HighHaste = set_combine(sets.engaged.DW.MidAcc.HighHaste, {
        head="Carmine Mask +1",
        legs="Carmine Cuisses +1",
        -- feet=gear.Herc_STP_feet,
        neck="Mirage Stole +1",
        -- ear1="Cessance Earring",
        ear2="Mache Earring +1",
        ring1={name="Chirich Ring +1",bag="wardrobe3"},
        waist="Olseni Belt",
        })

    sets.engaged.DW.STP.HighHaste = set_combine(sets.engaged.DW.HighHaste, {
        -- head=gear.Herc_STP_head,
        neck="Lissome Necklace",
        ring1={name="Chirich Ring +1",bag="wardrobe3"},
        ring2={name="Chirich Ring +1",bag="wardrobe4"},
        })

    -- 45% Magic Haste (36% DW to cap)
    sets.engaged.DW.MaxHaste = set_combine(sets.engaged.DW.HighHaste, {
        -- ammo="Aurgelmir Orb +1",
        -- head=gear.Adhemar_B_head,
        -- hands=gear.Adhemar_B_hands,
        -- legs="Samnuha Tights",
        -- feet=gear.Herc_TA_feet,
        -- neck="Ainia Collar",
        -- ear1="Cessance Earring",

        ammo="Coiste Bodhar",
        head="Malignance Chapeau", --6DT
        body=gear.Adhemar_B_body, --6DW
        hands="Malignance Gloves", --5DT
        legs="Malignance Tights", --7DT
        feet="Malignance Boots", --4DT
        neck="Loricate Torque +1", --6DT
        ear1="Dedition Earring",
        ear2="Telos Earring",
        ring2="Hetairoi Ring",
        ring1="Epona's Ring",
        -- ring2={name="Chirich Ring +1",bag="wardrobe4"},
        -- ring2="Defending Ring", --10DT
        back=gear.BLU_DA_Cape, --10PDT
        waist="Windbuffet Belt +1",
        }) -- 6% (assume 30 from traits), 28DT, 10PDT

    sets.engaged.DW.LowAcc.MaxHaste = set_combine(sets.engaged.DW.MaxHaste, {
        -- head="Dampening Tam",
        -- hands=gear.Adhemar_A_hands,
        -- neck="Combatant's Torque",
        ring1={name="Chirich Ring +1",bag="wardrobe3"},
        })

    sets.engaged.DW.MidAcc.MaxHaste = set_combine(sets.engaged.DW.LowAcc.MaxHaste, {
        ammo="Voluspa Tathlum",
        ring2="Ilabrat Ring",
        ear1="Digni. Earring",
        -- waist="Kentarch Belt +1",
        })

    sets.engaged.DW.HighAcc.MaxHaste = set_combine(sets.engaged.DW.MidAcc.MaxHaste, {
        head="Carmine Mask +1",
        legs="Carmine Cuisses +1",
        -- feet=gear.Herc_STP_feet,
        neck="Mirage Stole +1",
        ear2="Mache Earring +1",
        ring1={name="Chirich Ring +1",bag="wardrobe3"},
        waist="Olseni Belt",
        })

    sets.engaged.DW.STP.MaxHaste = set_combine(sets.engaged.DW.MaxHaste, {
        -- head=gear.Herc_STP_head,
        neck="Lissome Necklace",
        ear1="Dedition Earring",
        ear2="Telos Earring",
        ring1={name="Chirich Ring +1",bag="wardrobe3"},
        ring2={name="Chirich Ring +1",bag="wardrobe4"},
        -- waist="Kentarch Belt +1",
        })

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Hybrid Sets -------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.engaged.Hybrid = {
        head="Malignance Chapeau", --6/6
        body="Malignance Tabard", --9/9
        hands="Malignance Gloves", --5/5
        legs="Malignance Tights", --7/7
        feet="Malignance Boots", --4/4
        ring2="Defending Ring", --10/10
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

    sets.magic_burst = set_combine(sets.midcast['Blue Magic'].Magical, {
        -- body="Samnuha Coat", --(8)
        -- hands="Amalric Gages +1", --(5)
        legs="Assim. Shalwar +3", --10
        feet="Jhakri Pigaches +2", --5
        -- ring1="Mujin Band", --(5)
        -- back="Seshaw Cape", --5
        })

    sets.Kiting = {legs="Carmine Cuisses +1"}
    sets.Learning = {hands="Assimilator's Bazubands +1"}
    sets.latent_refresh = {
        main="Bolelabunga", --1
        waist="Fucho-no-obi",
        body="Jhakri Robe +2", --4
    }

    sets.buff.Doom = {
        neck="Nicander's Necklace", --20
        -- ring1={name="Eshmun's Ring", bag="wardrobe3"}, --20
        ring2="Saida Ring", --20
        ring1="Saida Ring", --20
        -- ring2={name="Eshmun's Ring", bag="wardrobe4"}, --20
        waist="Gishdubar Sash", --10
        }

    sets.TreasureHunter = set_combine(sets.TreasureHunter, {
        feet = gear.Herc_TH_feet,
    })
    sets.midcast.Dia = sets.TreasureHunter
    sets.midcast.Diaga = sets.TreasureHunter
    sets.midcast.Bio = sets.TreasureHunter
    --sets.Reive = {neck="Ygnas's Resolve +1"}

end


-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------


-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
-- Set eventArgs.useMidcastGear to true if we want midcast gear equipped on precast.
function job_precast(spell, action, spellMap, eventArgs)
    silibs.precast_hook(spell, action, spellMap, eventArgs)
    ----------- Non-silibs content goes below this line -----------
    if unbridled_spells:contains(spell.english) and not state.Buff['Unbridled Learning'] then
        eventArgs.cancel = true
        windower.send_command('@input /ja "Unbridled Learning" <me>; wait 1.5; input /ma "'..spell.name..'" '..spell.target.name)
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
end

function job_post_precast(spell, action, spellMap, eventArgs)
    if spell.type == 'WeaponSkill' then
        if elemental_ws:contains(spell.name) then
            -- Matching double weather (w/o day conflict).
            if spell.element == world.weather_element and (get_weather_intensity() == 2 and spell.element ~= elements.weak_to[world.day_element]) then
                equip({waist="Hachirin-no-Obi"})
            -- Target distance under 1.7 yalms.
            elseif spell.target.distance < (1.7 + spell.target.model_size) then
                equip({waist="Orpheus's Sash"})
            -- Matching day and weather.
            elseif spell.element == world.day_element and spell.element == world.weather_element then
                equip({waist="Hachirin-no-Obi"})
            -- Target distance under 8 yalms.
            elseif spell.target.distance < (8 + spell.target.model_size) then
                equip({waist="Orpheus's Sash"})
            -- Match day or weather.
            elseif spell.element == world.day_element or spell.element == world.weather_element then
                equip({waist="Hachirin-no-Obi"})
            end
        end
    end
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
    -- Add enhancement gear for Chain Affinity, etc.
    if spell.skill == 'Blue Magic' then
        for buff,active in pairs(state.Buff) do
            if active and sets.buff[buff] then
                equip(sets.buff[buff])
            end
        end
        if spellMap == 'Magical' then
            if spell.element == world.weather_element and (get_weather_intensity() == 2 and spell.element ~= elements.weak_to[world.day_element]) then
                equip({waist="Hachirin-no-Obi"})
            end
        end
        if spellMap == 'Healing' and spell.target.type == 'SELF' then
            equip(sets.midcast['Blue Magic'].HealingSelf)
        end
    end

    --Add treasure hunter tag support during spell cast
    if spell.target.type == "MONSTER" and state.TreasureMode.value == "Tag" then
        if prevTagId ~= spell.target.id then
            prevTagId = spell.target.id
            equip(sets.TreasureHunter)
        end
    end

    if spell.skill == 'Enhancing Magic' and classes.NoSkillSpells:contains(spell.english) then
        equip(sets.midcast.EnhancingDuration)
        if spellMap == 'Refresh' then
            equip(sets.midcast.Refresh)
        end
    end

    ----------- Non-silibs content goes above this line -----------
    silibs.post_midcast_hook(spell, action, spellMap, eventArgs)
end

function job_aftercast(spell, action, spellMap, eventArgs)
    silibs.aftercast_hook(spell, action, spellMap, eventArgs)
    ----------- Non-silibs content goes below this line -----------
    if not spell.interrupted then
        if spell.english == "Dream Flower" then
            send_command('@timers c "Dream Flower ['..spell.target.name..']" 90 down spells/00098.png')
        elseif spell.english == "Soporific" then
            send_command('@timers c "Sleep ['..spell.target.name..']" 90 down spells/00259.png')
        elseif spell.english == "Sheep Song" then
            send_command('@timers c "Sheep Song ['..spell.target.name..']" 60 down spells/00098.png')
        elseif spell.english == "Yawn" then
            send_command('@timers c "Yawn ['..spell.target.name..']" 60 down spells/00098.png')
        elseif spell.english == "Entomb" then
            send_command('@timers c "Entomb ['..spell.target.name..']" 60 down spells/00547.png')
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
function job_buff_change(buff,gain)

--    if buffactive['Reive Mark'] then
--        if gain then
--            equip(sets.Reive)
--            disable('neck')
--        else
--            enable('neck')
--        end
--    end

    if buff == "doom" then
        if gain then
            equip(sets.buff.Doom)
            send_command('@input /p Doomed.')
            disable('ring1','ring2','waist')
        else
            enable('ring1','ring2','waist')
            handle_equipping_gear(player.status)
        end
    end

end


function job_state_change(stateField, newValue, oldValue)
    -- print(stateField.." is now ",newValue)
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
end

function job_update(cmdParams, eventArgs)
    handle_equipping_gear(player.status)
end

function update_combat_form()
    if DW == true then
        state.CombatForm:set('DW')
    elseif DW == false then
        state.CombatForm:reset()
    end
end

-- Custom spell mapping.
-- Return custom spellMap value that can override the default spell mapping.
-- Don't return anything to allow default spell mapping to be used.
function job_get_spell_map(spell, default_spell_map)
    if spell.skill == 'Blue Magic' then
        for category,spell_list in pairs(blue_magic_maps) do
            if spell_list:contains(spell.english) then
                return category
            end
        end
    end
end

function get_custom_wsmode(spell, action, spellMap)
    local wsmode
    if state.OffenseMode.value == 'MidAcc' or state.OffenseMode.value == 'HighAcc' then
        wsmode = 'Acc'
    end

    return wsmode
end

-- Modify the default idle set after it was constructed.
function customize_idle_set(idleSet)
    if player.mpp < 71 and state.DefenseMode.value == 'None' then
        idleSet = set_combine(idleSet, sets.latent_refresh)
    end
    if state.Auto_Kite.value == true then
       idleSet = set_combine(idleSet, sets.Kiting)
    end
    -- if state.TreasureMode.value == 'Fulltime' then
    --     idleSet = set_combine(idleSet, sets.TreasureHunter)
    --     state.CastingMode.value='TreasureHunter'
    -- else
    --     state.CastingMode.value='Normal'
    -- end

    if state.IdleMode.value == 'CP' then
        idleSet = set_combine(idleSet, sets.CP)
    end

    if isSpecialSetOn() then
        if sets.SpecialSets[getSpecialSet()] then
            idleSet = set_combine(idleSet, sets.SpecialSets[getSpecialSet()])
        else
            if getSpecialSet() then
                add_to_chat(123, "Error! Special set "..getSpecialSet().." does not exist!")
            else
                add_to_chat(123, "Error! Special set 'nil' does not exist!")
            end
        end
    end
    
    -- print("Idle sub equip:",sets.idle.sub.name)
    -- equip({sub=sets.idle.sub})

    return idleSet
end

function user_customize_idle_set(idleSet)
    -- Any non-silibs modifications should go in customize_idle_set function
    return silibs.customize_idle_set(idleSet)
end

-- Modify the default melee set after it was constructed.
function customize_melee_set(meleeSet)
    if state.TreasureMode.value == 'Fulltime' then
        meleeSet = set_combine(meleeSet, sets.TreasureHunter)
    end
    if state.IdleMode.value == 'CP' then
        meleeSet = set_combine(meleeSet, sets.CP)
    end  
    return meleeSet
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

    local ws_msg = state.WeaponskillMode.value

    local c_msg = state.CastingMode.value

    local d_msg = 'None'
    if state.DefenseMode.value ~= 'None' then
        d_msg = state.DefenseMode.value .. state[state.DefenseMode.value .. 'DefenseMode'].value
    end

    local i_msg = state.IdleMode.value

    local msg = ''
    if state.TreasureMode.value == 'Tag' then
        msg = msg .. ' TH: Tag |'
    end
    if state.MagicBurst.value then
        msg = ' Burst: On |'
    end
    if state.Kiting.value then
        msg = msg .. ' Kiting: On |'
    end

    local s_msg = getSpecialSet()

    add_to_chat(002, '| ' ..string.char(31,210).. 'Melee' ..cf_msg.. ': ' ..string.char(31,001)..m_msg.. string.char(31,002)..  ' |'
        ..string.char(31,207).. ' WS: ' ..string.char(31,001)..ws_msg.. string.char(31,002)..  ' |'
        ..string.char(31,060).. ' Magic: ' ..string.char(31,001)..c_msg.. string.char(31,002)..  ' |'
        ..string.char(31,004).. ' Defense: ' ..string.char(31,001)..d_msg.. string.char(31,002)..  ' |'
        ..string.char(31,008).. ' Idle: ' ..string.char(31,001)..i_msg.. string.char(31,002)..  ' |'
        ..string.char(31,008).. ' Special: ' ..string.char(31,001)..s_msg.. string.char(31,002)..  ' |'
        ..string.char(31,002)..msg)

    eventArgs.handled = true
end


-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

function determine_haste_group() --Trying to flatten gearswap set. Haste tiers often leave too squishy
    -- classes.CustomMeleeGroups:clear()
    -- if DW == true then
    --     if DW_needed <= 11 then
    --         classes.CustomMeleeGroups:append('MaxHaste')
    --     elseif DW_needed > 11 and DW_needed <= 21 then
    --         classes.CustomMeleeGroups:append('HighHaste')
    --     elseif DW_needed > 21 and DW_needed <= 27 then
    --         classes.CustomMeleeGroups:append('MidHaste')
    --     elseif DW_needed > 27 and DW_needed <= 37 then
    --         classes.CustomMeleeGroups:append('LowHaste')
    --     elseif DW_needed > 37 then
    --         classes.CustomMeleeGroups:append('')
    --     end
    -- end
end

function job_self_command(cmdParams, eventArgs)
    silibs.self_command(cmdParams, eventArgs)
    ----------- Non-silibs content goes below this line -----------
    if cmdParams[1] == 'WeaponLock' then
        handle_toggle(cmdParams)
        weapon_lock(state.WeaponLock.value)
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

function update_active_abilities()
    state.Buff['Burst Affinity'] = buffactive['Burst Affinity'] or false
    state.Buff['Efflux'] = buffactive['Efflux'] or false
    state.Buff['Diffusion'] = buffactive['Diffusion'] or false
end

-- State buff checks that will equip buff gear and mark the event as handled.
function apply_ability_bonuses(spell, action, spellMap)
    if state.Buff['Burst Affinity'] and (spellMap == 'Magical' or spellMap == 'MagicalLight' or spellMap == 'MagicalDark' or spellMap == 'Breath') then
        if state.MagicBurst.value then
            equip(sets.magic_burst)
        end
        equip(sets.buff['Burst Affinity'])
    end
    if state.Buff.Efflux and spellMap == 'Physical' then
        equip(sets.buff['Efflux'])
    end
    if state.Buff.Diffusion and (spellMap == 'Buffs' or spellMap == 'BlueSkill') then
        equip(sets.buff['Diffusion'])
    end

    if state.Buff['Burst Affinity'] then equip (sets.buff['Burst Affinity']) end
    if state.Buff['Efflux'] then equip (sets.buff['Efflux']) end
    if state.Buff['Diffusion'] then equip (sets.buff['Diffusion']) end
end

--- Obsolete once enabled slibs TH
-- Check for various actions that we've specified in user code as being used with TH gear.
-- This will only ever be called if TreasureMode is not 'None'.
-- Category and Param are as specified in the action event packet.
-- function th_action_check(category, param)
--     if category == 2 or -- any ranged attack
--         --category == 4 or -- any magic action
--         (category == 3 and param == 30) or -- Aeolian Edge
--         (category == 6 and info.default_ja_ids:contains(param)) or -- Provoke, Animated Flourish
--         (category == 14 and info.default_u_ja_ids:contains(param)) -- Quick/Box/Stutter Step, Desperate/Violent Flourish
--         then return true
--     end
-- end

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
    if char_check_gear() then
        char_check_gear()
    end 

    if state.IdleMode.value == 'Learning' then
        equip(sets.Learning)
        disable("hands")
     else
        enable('hands')
     end

end



-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
    -- Default macro set/book
    -- if player.sub_job == 'WAR' then
    --     set_macro_page(9, 7)
    -- elseif player.sub_job == 'RDM' then
    --     set_macro_page(7, 7)
    -- else
    --     set_macro_page(2, 7)
    -- end

    --Now using xivhotbar. Move to blank book to avoid double casting
    set_macro_page(1,7)
end

function set_lockstyle()
    send_command('wait 10; input /lockstyleset ' .. lockstyleset)
end
