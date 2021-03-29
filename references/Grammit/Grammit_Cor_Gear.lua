-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_job_setup()
    state.OffenseMode:options('Normal','Acc')
    state.RangedMode:options('Normal', 'Acc')
    state.WeaponskillMode:options('Match','Normal', 'Acc','Proc')
    state.CastingMode:options('Normal', 'Resistant')
    state.IdleMode:options('Normal', 'PDT', 'Refresh')
	state.HybridMode:options('Normal','DT')
	state.ExtraMeleeMode = M{['description']='Extra Melee Mode', 'None', 'DWMax'}
	state.Weapons:options('LeadenAcc','Savage','SavageKris','LeadenDaggers',"AE",'Ranged','DualWeapons','None')
	state.CompensatorMode:options('Never','Always','300','1000')

    gear.RAbullet = "Chrono Bullet"
    gear.WSbullet = "Chrono Bullet"
    gear.MAbullet = "Orichalc. Bullet" --For MAB WS, do not put single-use bullets here.
    gear.QDbullet = "Hauksbok Bullet"
    options.ammo_warning_limit = 10

	gear.tp_ranger_jse_back = { name="Camulus's Mantle", augments={'AGI+20','Rng.Acc.+20 Rng.Atk.+20','Rng.Acc.+10','"Store TP"+10',}}
	gear.snapshot_jse_back = { name="Camulus's Mantle", augments={'"Snapshot"+10',}}
	gear.tp_jse_back = { name="Camulus's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Dbl.Atk."+10','Damage taken-5%',}}
	gear.ranger_wsd_jse_back = {name="Camulus's Mantle",augments={'AGI+20','Rng.Acc.+20 Rng.Atk.+20','AGI+10','Weapon skill damage +10%',}}
	gear.magic_wsd_jse_back={ name="Camulus's Mantle", augments={'AGI+20','Mag. Acc+20 /Mag. Dmg.+20','Weapon skill damage +10%',}}
	gear.str_wsd_jse_back ={ name="Camulus's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}}

    -- Additional local binds
	send_command('bind ^` gs c cycle ElementalMode')
	send_command('bind !` gs c elemental quickdraw')
	
	send_command('bind ^backspace input /ja "Double-up" <me>')
	send_command('bind @backspace input /ja "Snake Eye" <me>')
	send_command('bind !backspace input /ja "Fold" <me>')
	send_command('bind ^@!backspace input /ja "Crooked Cards" <me>')
	
	send_command('bind ^\\\\ input /ja "Random Deal" <me>')
    send_command('bind !\\\\ input /ja "Bolter\'s Roll" <me>')
	send_command('bind ^@!\\\\ gs c toggle LuzafRing')
	send_command('bind @f7 gs c toggle RngHelper')

	send_command('bind !r gs c weapons DualSavageWeapons;gs c update')
	send_command('bind ^q gs c weapons DualAeolian;gs c update')
	send_command('bind @q gs c weapons DualKustawi;gs c update')
	send_command('bind !q gs c weapons DualLeadenRanged;gs c update')
	send_command('bind @pause roller roll')

    select_default_macro_book()
end

-- Define sets and vars used by this job file.
function init_gear_sets()
    --------------------------------------
    -- Start defining the sets
    --------------------------------------

    -- Precast Sets

    -- Precast sets to enhance JAs

	sets.precast.JA['Triple Shot'] = {body="Chasseur's Frac +1"}
    sets.precast.JA['Snake Eye'] = {legs="Lanun Trews +1"}
    sets.precast.JA['Wild Card'] = {feet="Lanun Bottes +3"}
    sets.precast.JA['Random Deal'] = {body="Lanun Frac +1"}
    sets.precast.FoldDoubleBust = {hands="Lanun Gants +1"}

    sets.precast.CorsairRoll = {main="Rostam",range="Compensator",
        head="Lanun Tricorne +1",neck="Regal Necklace",ear1="Etiolation Earring",ear2="Sanare Earring",
        body="Lanun Frac +1",hands="Chasseur's Gants +1",ring1="Defending Ring",ring2="Barataria Ring",
        back=gear.tp_jse_back,waist="Flume Belt +1",legs="Desultor Tassets",feet="Malignance Boots"}

    sets.precast.LuzafRing = {ring1="Luzaf's Ring"}
    
    sets.precast.CorsairRoll["Caster's Roll"] = set_combine(sets.precast.CorsairRoll, {legs="Chas. Culottes +1"})
    sets.precast.CorsairRoll["Courser's Roll"] = set_combine(sets.precast.CorsairRoll, {feet="Chass. Bottes +1"})
    sets.precast.CorsairRoll["Blitzer's Roll"] = set_combine(sets.precast.CorsairRoll, {head="Chass. Tricorne +1"})
    sets.precast.CorsairRoll["Tactician's Roll"] = set_combine(sets.precast.CorsairRoll, {body="Chasseur's Frac +1"})
    sets.precast.CorsairRoll["Allies' Roll"] = set_combine(sets.precast.CorsairRoll, {hands="Chasseur's Gants +1"})
    
    sets.precast.CorsairShot = {ammo=gear.QDbullet,
        head={ name="Herculean Helm", augments={'"Mag.Atk.Bns."+27','Pet: Attack+27 Pet: Rng.Atk.+27','Mag. Acc.+17 "Mag.Atk.Bns."+17',}},
		neck="Comm. Charm +1",ear1="Dedition Earring",ear2="Telos Earring",
        body="Lanun Frac +3",hands="Carmine Fin. Ga. +1",ring1="Fenrir Ring +1",ring2="Dingir Ring",
        back=magic_wsd_jse_back,waist="Eschan Stone",legs={ name="Herculean Trousers", augments={'Accuracy+22','"Mag.Atk.Bns."+22','Weapon skill damage +4%',}},
		feet="Lanun Bottes +3"}
		
	sets.precast.CorsairShot.Damage = {ammo=gear.QDbullet,
        head={ name="Herculean Helm", augments={'"Mag.Atk.Bns."+28','STR+9','Haste+2','Accuracy+7 Attack+7','Mag. Acc.+19 "Mag.Atk.Bns."+19',}},
		neck="Comm. Charm +1",ear1="Dedition Earring",ear2="Telos Earring",
        body="Lanun Frac +3",hands="Carmine Fin. Ga. +1",ring1="Fenrir Ring +1",ring2="Dingir Ring",
        back=magic_wsd_jse_back,waist="Eschan Stone",legs={ name="Herculean Trousers", augments={'Accuracy+22','"Mag.Atk.Bns."+22','Weapon skill damage +4%',}},
		feet="Lanun Bottes +3"}
	
    sets.precast.CorsairShot.Proc = {ammo=gear.RAbullet,
        head="Wh. Rarab Cap +1",neck="Loricate Torque +1",ear1="Genmei Earring",ear2="Sanare Earring",
        body="Emet Harness +1",hands="Malignance Gloves",ring1="Defending Ring",ring2="Dark Ring",
        back="Moonlight Cape",waist="Flume Belt +1",legs="Carmine Cuisses +1",feet="Chass. Bottes +1"}

    sets.precast.CorsairShot['Light Shot'] = {ammo=gear.QDbullet,
        head="Carmine Mask +1",neck="Comm. Charm +1",ear1="Digni. Earring",ear2="Telos Earring",
        body="Mummu Jacket +2",hands="Leyline Gloves",ring1="Metamor. Ring +1",ring2="Stikini Ring +1",
        back=gear.ranger_wsd_jse_back,waist="Eschan Stone",legs="Malignance Tights",feet="Mummu Gamash. +2"}

    sets.precast.CorsairShot['Dark Shot'] = set_combine(sets.precast.CorsairShot['Light Shot'], {feet="Chass. Bottes +1"})

    -- Waltz set (chr and vit)
    sets.precast.Waltz = {
        head="Carmine Mask +1",neck="Loricate Torque +1",ear1="Etiolation Earring",ear2="Sanare Earring",
        body=gear.herculean_waltz_body,hands=gear.herculean_waltz_hands,ring1="Defending Ring",ring2="Valseur's Ring",
        back="Moonlight Cape",waist="Flume Belt +1",legs="Dashing Subligar",feet=gear.herculean_waltz_feet}
		
	sets.Self_Waltz = {head="Mummu Bonnet +2",body="Passion Jacket",ring1="Asklepian Ring"}
        
    -- Don't need any special gear for Healing Waltz.
    sets.precast.Waltz['Healing Waltz'] = {}

    -- Fast cast sets for spells
    
    sets.precast.FC = {
        head="Carmine Mask +1",neck="Baetyl Pendant",ear1="Enchntr. Earring +1",ear2="Loquac. Earring",
        body="Dread Jupon",hands="Leyline Gloves",ring1="Kishar Ring",ring2="Lebeche Ring",
        back="Moonlight Cape",waist="Flume Belt +1",legs="Rawhide Trousers",feet="Carmine Greaves +1"}

    sets.precast.FC.Utsusemi = set_combine(sets.precast.FC, {neck="Magoraga Beads",body="Passion Jacket"})
	
	sets.precast.FC.Cure = set_combine(sets.precast.FC, {ear2="Mendi. Earring"})

    sets.precast.RA = {ammo=gear.RAbullet,
        head="Chass. Tricorne +1",neck="Comm. Charm +1",
        body="Laksa. Frac +3",hands="Carmine Fin. Ga. +1",
        back=gear.snapshot_jse_back,waist="Impulse Belt",legs="Laksa. Trews +1",feet="Meg. Jam. +2"}
		
	sets.precast.RA.Flurry = set_combine(sets.precast.RA, {})
	sets.precast.RA.Flurry2 = set_combine(sets.precast.RA, {})

       
    -- Weaponskill sets
    -- Default set for any weaponskill that isn't any more specifically defined
    sets.precast.WS = {
        head="Meghanada Visor +2",neck="Fotia Gorget",ear1="Moonshade Earring",ear2="Telos Earring",
        body="Meg. Cuirie +1",hands="Meg. Gloves +2",ring1="Meghanada Ring",ring2="Mummu Ring",
        back=gear.str_wsd_jse_back,waist="Fotia Belt",legs="Meg. Chausses +2",feet="Malignance Boots"}
		
    sets.precast.WS.Acc = {
        head="Carmine Mask +1",neck="Combatant's Torque",ear1="Digni. Earring",ear2="Telos Earring",
        body="Meg. Cuirie +1",hands="Meg. Gloves +2",ring1="Regal Ring",ring2="Ilabrat Ring",
        back=gear.str_wsd_jse_back,waist="Grunfeld Rope",legs="Carmine Cuisses +1",feet="Lanun Bottes +3"}		
		
    sets.precast.WS.Proc = {
        head="Carmine Mask +1",neck="Combatant's Torque",ear1="Digni. Earring",ear2="Mache Earring +1",
        body="Mummu Jacket +2",hands="Floral Gauntlets",ring1="Ramuh Ring +1",ring2="Ramuh Ring +1",
        back=gear.tp_jse_back,waist="Olseni Belt",legs="Carmine Cuisses +1",feet="Malignance Boots"}
		
    -- Specific weaponskill sets.  Uses the base set if an appropriate WSMod version isn't found.

    sets.precast.WS['Requiescat'] = set_combine(sets.precast.WS, {head="Carmine Mask +1",ring2="Rufescent Ring",legs="Carmine Cuisses +1",feet="Carmine Greaves +1"})

	sets.precast.WS['Savage Blade'] = {ammo=gear.WSbullet,
    head={ name="Herculean Helm", augments={'Attack+28','Weapon skill damage +5%','DEX+8',}},
    body="Laksa. Frac +3",
    hands="Meg. Gloves +2",
    legs={ name="Herculean Trousers", augments={'"Drain" and "Aspir" potency +1','Pet: VIT+3','Weapon skill damage +9%','Accuracy+13 Attack+13','Mag. Acc.+7 "Mag.Atk.Bns."+7',}},
    feet="Lanun Bottes +3",
    neck="Comm. Charm +1",
    waist="Sailfi Belt +1",
    left_ear="Ishvara Earring",
    right_ear="Moonshade Earring",
    left_ring="Karieyh Ring",
    right_ring="Rufescent Ring",
    back=gear.str_wsd_jse_back,
	}

    sets.precast.WS['Savage Blade'].Acc = {ammo=gear.WSbullet,
    head={ name="Herculean Helm", augments={'Attack+28','Weapon skill damage +5%','DEX+8',}},
    body="Laksa. Frac +3",
    hands="Meg. Gloves +2",
    legs={ name="Herculean Trousers", augments={'"Drain" and "Aspir" potency +1','Pet: VIT+3','Weapon skill damage +9%','Accuracy+13 Attack+13','Mag. Acc.+7 "Mag.Atk.Bns."+7',}},
    feet="Lanun Bottes +3",
    neck="Comm. Charm +1",
    waist="Sailfi Belt +1",
    left_ear="Ishvara Earring",
    right_ear="Moonshade Earring",
    left_ring="Karieyh Ring",
    right_ring="Rufescent Ring",
    back=gear.str_wsd_jse_back,
	}
	
    sets.precast.WS['Last Stand'] = {ammo=gear.WSbullet,
        head="Meghanada Visor +2",neck="Fotia Gorget",left_ear="Ishvara Earring",right_ear="Moonshade Earring",
        body="Laksa. Frac +3",hands="Meg. Gloves +2",ring1="Garuda Ring +1",ring2="Dingir Ring",
        back=gear.ranger_wsd_jse_back,waist="Fotia Belt",legs={ name="Herculean Trousers", augments={'"Drain" and "Aspir" potency +1','Pet: VIT+3','Weapon skill damage +9%','Accuracy+13 Attack+13','Mag. Acc.+7 "Mag.Atk.Bns."+7',}},
		feet="Lanun Bottes +3"}

    sets.precast.WS['Last Stand'].Acc = {ammo=gear.WSbullet,
        head="Meghanada Visor +2",
    body="Laksa. Frac +3",
    hands="Meg. Gloves +2",
    legs="Meg. Chausses +2",
    feet="Meg. Jam. +2",
    neck="Fotia Gorget",
    waist="Fotia Belt",
    left_ear={ name="Moonshade Earring", augments={'"Mag.Atk.Bns."+4','TP Bonus +250',}},
    right_ear="Telos Earring",
    left_ring="Garuda Ring +1",
    right_ring="Regal Ring",
    back=gear.ranger_wsd_jse_back,
	}
		
    --sets.precast.WS['Detonator'] = sets.precast.WS['Last Stand']
    --sets.precast.WS['Detonator'].Acc = sets.precast.WS['Last Stand'].Acc
    sets.precast.WS['Slug Shot'] = sets.precast.WS['Last Stand']
    sets.precast.WS['Slug Shot'].Acc = sets.precast.WS['Last Stand'].Acc
    sets.precast.WS['Numbing Shot'] = sets.precast.WS['Last Stand']
    sets.precast.WS['Numbing Shot'].Acc = sets.precast.WS['Last Stand'].Acc
    --sets.precast.WS['Sniper Shot'] = sets.precast.WS['Last Stand']
    --sets.precast.WS['Sniper Shot'].Acc = sets.precast.WS['Last Stand'].Acc
    --sets.precast.WS['Split Shot'] = sets.precast.WS['Last Stand']
    --sets.precast.WS['Split Shot'].Acc = sets.precast.WS['Last Stand'].Acc
	
    sets.precast.WS['Leaden Salute'] = {ammo=gear.MAbullet,
        head="Pixie Hairpin +1",
		body="Lanun Frac +3",
		hands="Carmine Fin. Ga. +1",
		legs={ name="Herculean Trousers", augments={'Accuracy+22','"Mag.Atk.Bns."+22','Weapon skill damage +4%',}},
		feet="Lanun Bottes +3",
		neck="Comm. Charm +1",
		waist="Hachirin-no-Obi",
		left_ear="Friomisi Earring",
		right_ear="Moonshade Earring",
		left_ring="Dingir Ring",
		right_ring="Archon Ring",
		back=gear.magic_wsd_jse_back,
		}

    sets.precast.WS['Aeolian Edge'] = {ammo=gear.QDbullet,head={ name="Herculean Helm", augments={'"Mag.Atk.Bns."+28','STR+9','Haste+2','Accuracy+7 Attack+7','Mag. Acc.+19 "Mag.Atk.Bns."+19',}},
    body="Lanun Frac +3",
    hands="Carmine Fin. Ga. +1",
    legs={ name="Herculean Trousers", augments={'Accuracy+22','"Mag.Atk.Bns."+22','Weapon skill damage +4%',}},
    feet="Lanun Bottes +3",
    neck="Comm. Charm +1",
    waist="Eschan Stone",
    left_ear="Friomisi Earring",
    right_ear="Moonshade Earring",
    left_ring="Fenrir Ring +1",
    right_ring="Dingir Ring",
    back=gear.magic_wsd_jse_back,
	}

    sets.precast.WS['Wildfire'] = {ammo=gear.MAbullet,
        head={ name="Herculean Helm", augments={'"Mag.Atk.Bns."+28','STR+9','Haste+2','Accuracy+7 Attack+7','Mag. Acc.+19 "Mag.Atk.Bns."+19',}},
		body="Lanun Frac +3",
		hands="Carmine Fin. Ga. +1",
		legs={ name="Herculean Trousers", augments={'Accuracy+22','"Mag.Atk.Bns."+22','Weapon skill damage +4%',}},
		feet="Lanun Bottes +3",
		neck="Comm. Charm +1",
		waist="Hachirin-no-Obi",
		left_ear="Friomisi Earring",
		right_ear="Moonshade Earring",
		left_ring="Fenrir Ring +1",
		right_ring="Dingir Ring",
		back=gear.magic_wsd_jse_back,}

    --sets.precast.WS['Wildfire'].Acc = {ammo=gear.MAbullet,
        --head=gear.herculean_nuke_head,neck="Sanctity Necklace",ear1="Crematio Earring",ear2="Friomisi Earring",
        --body="Laksa. Frac +3",hands="Carmine Fin. Ga. +1",ring1="Regal Ring",ring2="Dingir Ring",
        --back=gear.magic_wsd_jse_back,waist="Eschan Stone",legs="Laksa. Trews +3",feet="Lanun Bottes +3"}
		
    --sets.precast.WS['Hot Shot'] = sets.precast.WS['Wildfire']
    --sets.precast.WS['Hot Shot'].Acc = sets.precast.WS['Wildfire'].Acc
		
		--Because omen skillchains.
    sets.precast.WS['Burning Blade'] = {ammo=gear.QDbullet,
        head={ name="Herculean Helm", augments={'"Mag.Atk.Bns."+28','STR+9','Haste+2','Accuracy+7 Attack+7','Mag. Acc.+19 "Mag.Atk.Bns."+19',}},
		body="Lanun Frac +3",
		hands="Carmine Fin. Ga. +1",
		legs={ name="Herculean Trousers", augments={'Accuracy+22','"Mag.Atk.Bns."+22','Weapon skill damage +4%',}},
		feet="Lanun Bottes +3",
		neck="Comm. Charm +1",
		waist="Eschan Stone",
		left_ear="Friomisi Earring",
		right_ear="Moonshade Earring",
		left_ring="Garuda Ring +1",
		right_ring="Dingir Ring",
		back=gear.magic_wsd_jse_back,}

	-- Swap to these on Moonshade using WS if at 3000 TP
	sets.MaxTP = {}
	sets.AccMaxTP = {}
        
    -- Midcast Sets
    sets.midcast.FastRecast = {
        head="Carmine Mask +1",neck="Baetyl Pendant",ear1="Enchntr. Earring +1",ear2="Loquac. Earring",
        body="Dread Jupon",hands="Leyline Gloves",ring1="Kishar Ring",ring2="Lebeche Ring",
        back="Moonlight Cape",waist="Flume Belt +1",legs="Rawhide Trousers",feet="Carmine Greaves +1"}
        
    -- Specific spells

	sets.midcast.Cure = {
        head="Carmine Mask +1",neck="Phalaina Locket",ear1="Enchntr. Earring +1",ear2="Mendi. Earring",
        body="Dread Jupon",hands="Leyline Gloves",ring1="Janniston Ring",ring2="Lebeche Ring",
        back="Solemnity Cape",waist="Flume Belt +1",legs="Carmine Cuisses +1",feet="Carmine Greaves +1"}
	
	sets.Self_Healing = {neck="Phalaina Locket",hands="Buremte Gloves",ring2="Kunaji Ring",waist="Gishdubar Sash"}
	sets.Cure_Received = {neck="Phalaina Locket",hands="Buremte Gloves",ring2="Kunaji Ring",waist="Gishdubar Sash"}
	sets.Self_Refresh = {waist="Gishdubar Sash"}
	
    sets.midcast.Utsusemi = sets.midcast.FastRecast

    -- Ranged gear
    sets.midcast.RA = {ammo=gear.RAbullet,
        head="Malignance Chapeau",neck="Iskur Gorget",ear1="Enervating Earring",ear2="Telos Earring",
        body="Malignance Tabard",hands="Carmine Fin. Ga. +1",ring1="Garuda Ring +1",ring2="Dingir Ring",
        back=gear.tp_ranger_jse_back,waist="Eschan Stone",legs="Meg. Chausses +2",feet="Malignance Boots"}

    sets.midcast.RA.Acc = {ammo=gear.RAbullet,
        head="Malignance Chapeau",neck="Iskur Gorget",ear1="Enervating Earring",ear2="Telos Earring",
        body="Malignance Tabard",hands="Meg. Gloves +2",ring1="Garuda Ring +1",ring2="Dingir Ring",
        back=gear.tp_ranger_jse_back,waist="Eschan Stone",legs="Meg. Chausses +2",feet="Malignance Boots"}
		
	sets.buff['Triple Shot'] = {body="Chasseur's Frac +1"}
    
    -- Sets to return to when not performing an action.
	
	sets.DayIdle = {}
	sets.NightIdle = {}
	
	sets.buff.Doom = set_combine(sets.buff.Doom, {})
    
    -- Resting sets
    sets.resting = {}
    

    -- Idle sets
    sets.idle = {ammo=gear.RAbullet,
	head="Malignance Chapeau",
    body="Malignance Tabard",
    hands="Meg. Gloves +2",
    legs="Meg. Chausses +2",
    feet="Malignance Boots",
    neck="Sanctity Necklace",
    waist="Flume Belt +1",
    left_ear="Odnowa Earring +1",
    right_ear="Hearty Earring",
    left_ring="Defending Ring",
    right_ring="Meghanada Ring",
    back="Moonlight Cape",}
		
    sets.idle.PDT = {ammo=gear.RAbullet,
        head="Malignance Chapeau",neck="Loricate Torque +1",ear1="Etiolation Earring",ear2="Sanare Earring",
        body="Malignance Tabard",hands="Malignance Gloves",ring1="Defending Ring",ring2="Dark Ring",
        back="Moonlight Cape",waist="Carrier's Sash",legs="Malignance Tights",feet="Malignance Boots"}
		
    sets.idle.Refresh = {ammo=gear.RAbullet,
        head="Rawhide Mask",neck="Loricate Torque +1",ear1="Genmei Earring",ear2="Ethereal Earring",
        body="Mekosu. Harness",hands=gear.herculean_refresh_hands,ring1="Defending Ring",ring2="Dark Ring",
        back="Moonlight Cape",waist="Flume Belt +1",legs="Rawhide Trousers",feet="Malignance Boots"}
    
    -- Defense sets
    sets.defense.PDT = {ammo=gear.RAbullet,
        head="Malignance Chapeau",neck="Loricate Torque +1",ear1="Genmei Earring",ear2="Sanare Earring",
        body="Malignance Tabard",hands="Malignance Gloves",ring1="Defending Ring",ring2="Dark Ring",
        back="Shadow Mantle",waist="Flume Belt +1",legs="Malignance Tights",feet="Malignance Boots"}

    sets.defense.MDT = {ammo=gear.RAbullet,
        head="Malignance Chapeau",neck="Warder's Charm +1",ear1="Etiolation Earring",ear2="Sanare Earring",
        body="Malignance Tabard",hands="Malignance Gloves",ring1="Defending Ring",ring2="Shadow Ring",
        back="Moonlight Cape",waist="Carrier's Sash",legs="Malignance Tights",feet="Malignance Boots"}
		
    sets.defense.MEVA = {ammo=gear.RAbullet,
        head="Malignance Chapeau",neck="Warder's Charm +1",ear1="Etiolation Earring",ear2="Sanare Earring",
        body="Malignance Tabard",hands="Malignance Gloves",ring1="Defending Ring",ring2="Shadow Ring",
        back="Moonlight Cape",waist="Carrier's Sash",legs="Malignance Tights",feet="Malignance Boots"}

    sets.Kiting = {legs="Carmine Cuisses +1"}
	sets.TreasureHunter = set_combine(sets.TreasureHunter, {head="Volte Cap",
		legs={ name="Herculean Trousers", augments={'"Fast Cast"+1','Pet: Haste+3','"Treasure Hunter"+1','Accuracy+10 Attack+10','Mag. Acc.+11 "Mag.Atk.Bns."+11',}},
		feet={ name="Herculean Boots", augments={'Crit. hit damage +1%','Pet: INT+8','"Treasure Hunter"+2','Accuracy+2 Attack+2','Mag. Acc.+10 "Mag.Atk.Bns."+10',}},
		})
	sets.DWMax = {ear1="Dudgeon Earring",ear2="Heartseeker Earring",body="Adhemar Jacket +1",hands="Floral Gauntlets",waist="Reiki Yotai"}

	-- Weapons sets
	sets.weapons.Ranged = {main="Lanun Knife",sub="Nusku Shield",range="Fomalhaut"}
	sets.weapons.DualWeapons = {main="Lanun Knife",sub="Blurred Knife +1",range="Fomalhaut"}
	sets.weapons.DualSavageWeapons = {main="Naegling",sub="Blurred Knife +1",range="Ataktos"}
	sets.weapons.DualLeadenRanged = {main="Rostam",sub="Tauret",range="Fomalhaut"}
	sets.weapons.DualLeadenMelee = {main="Naegling",sub="Atoyac",range="Fomalhaut"}
	sets.weapons.DualAeolian = {main="Rostam",sub="Tauret",range="Ataktos"}
	sets.weapons.DualLeadenMeleeAcc = {main="Naegling",sub="Blurred Knife +1",range="Fomalhaut"}
	sets.weapons.DualRanged = {main="Rostam",sub="Kustawi +1",range="Fomalhaut"}
	sets.weapons.LeadenAcc={main="Naegling",sub="Tauret",range='Fomalhaut'}
	sets.weapons.Savage = {main="Naegling",sub="Blurred Knife +1",range='Anarchy +2'}
	sets.weapons.SavageKris = {main="Naegling",sub="Mercurial Kris",range='Anarchy +2'}
	sets.weapons.LeadenDaggers = {main="Tauret",sub="Blurred Knife +1",range='Fomalhaut'}
	sets.weapons.AE = {main="Tauret",sub="Blurred Knife +1",range='Anarchy +2'}
	sets.weapons.TPKnives = {main="Blurred Knife +1",sub="Mercurial Kris",range='Anarchy +2'}

	
    -- Engaged sets

    -- Variations for TP weapon and (optional) offense/defense modes.  Code will fall back on previous
    -- sets if more refined versions aren't defined.
    -- If you create a set with both offense and defense modes, the offense mode should be first.
    -- EG: sets.engaged.Dagger.Accuracy.Evasion
    
    -- Normal melee group
    sets.engaged = {
		ammo=gear.WSbullet,
    head="Dampening Tam",
    body="Adhemar Jacket +1",
    hands="Adhemar Wrist. +1",
    legs="Meg. Chausses +2",
    feet="Herculean Boots",
    neck="Iskur Gorget",
    waist="Sailfi Belt +1",
    ear1="Suppanomimi",
    ear2="Telos Earring",
    ring1="Chirich Ring +1",
    ring2="Epona's Ring",
    back=gear.tp_jse_back}
    
    sets.engaged.Acc = {
		head="Carmine Mask +1",neck="Combatant's Torque",ear1="Cessance Earring",ear2="Telos Earring",
		body="Meg. Cuirie +2",hands="Adhemar Wrist. +1",ring1="Epona's Ring",ring2="Ramuh Ring +1",
		back=gear.tp_jse_back,waist="Olseni Belt",legs="Carmine Cuisses +1",feet="Malignance Boots"}
		
    sets.engaged.DT = {
        head="Malignance Chapeau",neck="Loricate Torque +1",ear1="Cessance Earring",ear2="Brutal Earring",
        body="Malignance Tabard",hands="Adhemar Wrist. +1",ring1="Defending Ring",ring2="Petrov Ring",
        back="Vespid Mantle",waist="Sailfi Belt +1",legs="Meg. Chausses +2",feet="Malignance Boots"}
    
    sets.engaged.Acc.DT = {
        head="Malignance Chapeau",neck="Loricate Torque +1",ear1="Cessance Earring",ear2="Telos Earring",
        body="Malignance Tabard",hands="Malignance Gloves",ring1="Defending Ring",ring2="Ramuh Ring +1",
        back=gear.tp_jse_back,waist="Olseni Belt",legs="Malignance Tights",feet="Malignance Boots"}

    sets.engaged.DW = {gear.WSbullet,
    head="Dampening Tam",
    body="Adhemar Jacket +1",
    hands="Adhemar Wrist. +1",
    legs="Meg. Chausses +2",
    feet="Herculean Boots",
    neck="Iskur Gorget",
    waist="Sailfi Belt +1",
    ear1="Suppanomimi",
    ear2="Telos Earring",
    ring1="Chirich Ring +1",
    ring2="Epona's Ring",
    back=gear.tp_jse_back}
    
    sets.engaged.DW.Acc = {
		head="Malignance Chapeau",neck="Iskur Gorget",ear1="Suppanomimi",ear2="Telos Earring",
		body="Malignance Tabard",hands="Adhemar Wrist. +1",ring1="Chirich Ring +1",ring2="Epona's Ring",
		back=gear.tp_jse_back,waist="Sailfi Belt +1",legs="Carmine Cuisses +1",feet="Malignance Boots"}
		
    sets.engaged.DW.DT = {
        head="Malignance Chapeau",neck="Loricate Torque +1",ear1="Suppanomimi",ear2="Telos Earring",
        body="Malignance Tabard",hands="Malignance Gloves",ring1="Defending Ring",ring2="Petrov Ring",
        back=gear.tp_jse_back,waist="Sailfi Belt +1",legs="Malignance Tights",feet="Malignance Boots"}
    
    sets.engaged.DW.Acc.DT = {
        head="Malignance Chapeau",neck="Loricate Torque +1",ear1="Suppanomimi",ear2="Telos Earring",
        body="Malignance Tabard",hands="Malignance Gloves",ring1="Defending Ring",ring2="Ramuh Ring +1",
        back=gear.tp_jse_back,waist="Reiki Yotai",legs="Malignance Tights",feet="Malignance Boots"}
end

-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
    if player.sub_job == 'NIN' then
        set_macro_page(5, 1)
    elseif player.sub_job == 'DNC' then
		set_macro_page(5, 1)
    elseif player.sub_job == 'RNG' then
        set_macro_page(5, 1)
    elseif player.sub_job == 'DRG' then
        set_macro_page(5, 1)
    else
        set_macro_page(5, 1)
    end
end

function user_job_lockstyle()
	if player.equipment.main == nil or player.equipment.main == 'empty' then
		windower.chat.input('/lockstyleset 012')
	elseif res.items[item_name_to_id(player.equipment.main)].skill == 3 then --Sword in main hand.
		if player.equipment.sub == nil or player.equipment.sub == 'empty' then --Sword/Nothing.
				windower.chat.input('/lockstyleset 012')
		elseif res.items[item_name_to_id(player.equipment.sub)].shield_size then --Sword/Shield
				windower.chat.input('/lockstyleset 012')
		elseif res.items[item_name_to_id(player.equipment.sub)].skill == 3 then --Sword/Sword.
			windower.chat.input('/lockstyleset 012')
		elseif res.items[item_name_to_id(player.equipment.sub)].skill == 2 then --Sword/Dagger.
			windower.chat.input('/lockstyleset 012')
		else
			windower.chat.input('/lockstyleset 012') --Catchall just in case something's weird.
		end
	elseif res.items[item_name_to_id(player.equipment.main)].skill == 2 then --Dagger in main hand.
		if player.equipment.sub == nil or player.equipment.sub == 'empty' then --Dagger/Nothing.
			windower.chat.input('/lockstyleset 012')
		elseif res.items[item_name_to_id(player.equipment.sub)].shield_size then --Dagger/Shield
			windower.chat.input('/lockstyleset 012')
		elseif res.items[item_name_to_id(player.equipment.sub)].skill == 3 then --Dagger/Sword.
			windower.chat.input('/lockstyleset 012')
		elseif res.items[item_name_to_id(player.equipment.sub)].skill == 2 then --Dagger/Dagger.
			windower.chat.input('/lockstyleset 012')
		else
			windower.chat.input('/lockstyleset 012') --Catchall just in case something's weird.
		end
	end
end