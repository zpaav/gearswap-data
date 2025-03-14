-------------------------------------------------------------------------------------------------------------------
-- Setup functions for this job.  Generally should not be modified.
-------------------------------------------------------------------------------------------------------------------

--[[
        Custom commands:
        Shorthand versions for each strategem type that uses the version appropriate for
        the current Arts.
                                        Light Arts              Dark Arts
        gs c scholar light              Light Arts/Addendum
        gs c scholar dark                                       Dark Arts/Addendum
        gs c scholar cost               Penury                  Parsimony
        gs c scholar speed              Celerity                Alacrity
        gs c scholar aoe                Accession               Manifestation
        gs c scholar power              Rapture                 Ebullience
        gs c scholar duration           Perpetuance
        gs c scholar accuracy           Altruism                Focalization
        gs c scholar enmity             Tranquility             Equanimity
        gs c scholar skillchain                                 Immanence
        gs c scholar addendum           Addendum: White         Addendum: Black
--]]



include('organizer-lib')
-- Initialization function for this job file.
function get_sets()
    mote_include_version = 2

    -- Load and initialize the include file.
    include('Mote-Include.lua')
end

-- Setup vars that are user-independent.  state.Buff vars initialized here will automatically be tracked.
function job_setup()
    info.addendumNukes = S{"Stone IV", "Water IV", "Aero IV", "Fire IV", "Blizzard IV", "Thunder IV",
        "Stone V", "Water V", "Aero V", "Fire V", "Blizzard V", "Thunder V"}

    state.Buff['Sublimation: Activated'] = buffactive['Sublimation: Activated'] or false
    update_active_strategems()
end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
    state.OffenseMode:options('None', 'Normal')
    state.CastingMode:options('Normal', 'Resistant', 'WeatherObi')
    state.IdleMode:options('Normal', 'PDT', 'CP')
	state.PhysicalDefenseMode:options('PDT', 'CP')

    info.low_nukes = S{"Stone", "Water", "Aero", "Fire", "Blizzard", "Thunder"}
    info.mid_nukes = S{"Stone II", "Water II", "Aero II", "Fire II", "Blizzard II", "Thunder II",
                       "Stone III", "Water III", "Aero III", "Fire III", "Blizzard III", "Thunder III",
                       "Stone IV", "Water IV", "Aero IV", "Fire IV", "Blizzard IV", "Thunder IV",}
    info.high_nukes = S{"Stone V", "Water V", "Aero V", "Fire V", "Blizzard V", "Thunder V"}

    gear.macc_hagondes = {name="Hagondes Cuffs", augments={'Phys. dmg. taken -3%','Mag. Acc.+29'}}

    send_command('bind ^` input /ma Stun <t>')

    select_default_macro_book()
end

function user_unload()
    send_command('unbind ^`')
end


-- Define sets and vars used by this job file.
function init_gear_sets()
    --------------------------------------
    -- Start defining the sets
    --------------------------------------

    -- Precast Sets

    -- Precast sets to enhance JAs

    sets.precast.JA['Tabula Rasa'] = {legs="Pedagogy Pants +1"}


    -- Fast cast sets for spells

    sets.precast.FC = {
    main="Pedagogy Staff",
    sub="Clerisy Strap +1",
    ammo="Sapience Orb",
    head="Acad. Mortar. +3",
    body="Agwu's Robe",
    hands="Academic's bracers +2",
    legs="Agwu's Slops",
    neck="Sanctity Necklace",
    feet="Peda. Loafers +3",
    waist="Channeler's Stone",
    left_ear="Loquac. Earring",
    right_ear="Malignance Earring",
    left_ring="Prolix Ring",
    right_ring="Kishar Ring",
    back="Lugh's Cape",
	}

    sets.precast.FC['Enhancing Magic'] = {
    main="Pedagogy Staff",
    sub="Clerisy Strap +1",
    ammo="Sapience Orb",
    head="Acad. Mortar. +3",
    body="Agwu's Robe",
    hands="Agwu's Gages",
    legs="Agwu's Slops",
    feet="pedagogy loafers +3",
    neck="Sanctity Necklace",
    waist="Channeler's Stone",
    left_ear="Loquac. Earring",
    right_ear="Etiolation Earring",
    left_ring="Prolix Ring",
    right_ring="Kishar Ring",
    back="Lugh's Cape",
}

    sets.precast.FC['Elemental Magic'] = {
    main="Grioavolr",
    sub="Clerisy Strap +1",
    ammo="Sapience Orb",
    head="Mallquis Chapeau +1",
    body="Mallquis Saio +1",
    hands="Mallquis Cuffs +1",
    legs="Mallquis Trews +1",
    feet="Mallquis Clogs +1",
    neck="Sanctity Necklace",
    waist="Channeler's Stone",
    left_ear="Loquac. Earring",
    right_ear="Odnowa Earring +1",
    left_ring="Prolix Ring",
    right_ring="Kishar Ring",
    back="Swith Cape",
}

    sets.precast.FC.Cure = set_combine(sets.precast.FC['Elemental Magic'], {
    main="Pedagogy staff", --{	--name="Serenity", augments={'MP+10','Enha.mag. skill +3','"Cure" spellcasting time -3%',}},
    sub="Clerisy Strap +1",
    legs="Doyen pants",
    neck="Argute stole +1",
    waist="Witful Belt",
    left_ear="Loquac. Earring",
    right_ear="Gifted Earring",
    right_ring="Defending Ring",
})

    sets.precast.FC.Curaga = sets.precast.FC.Cure

    sets.precast.FC.Impact = set_combine(sets.precast.FC['Elemental Magic'], {head=empty,body="Twilight Cloak"})

	sets.precast.FC.Dispelga = set_combine(sets.precast.FC, {
	main="Daybreak",
	sub="Ammurapi Shield"})	


    -- Midcast Sets
	sets.midcast.Aquaveil = set_combine(sets.midcast['Enhancing Magic'], {hands="Regal cuffs"})
	
	
	
    sets.midcast.FastRecast = {ammo="",
        head="",ear2="Loquacious Earring",
        --body="Vanir Cotehardie",
		hands="",ring1="Prolix Ring",
        back="Swith cape",waist="",legs="",feet=""}

    sets.midcast.Cure = {    
    main="Pedagogy staff", --{	--name="Serenity", augments={'MP+10','Enha.mag. skill +3','"Cure" spellcasting time -3%',}},
    sub="Clerisy Strap +1",
    ammo="",
    head={ name="Vanya Hood", augments={'MND+10','Spell interruption rate down +15%','"Conserve MP"+6',}},
    body="Peda. gown +3",
    hands="Academic's bracers +2",
    legs="Arbatel pants +1",
    feet={ name="Merlinic Crackows", augments={'Magic burst dmg.+7%','INT+15','Mag. Acc.+14','"Mag.Atk.Bns."+15',}},
    neck="Argute stole +1",
    waist="Austerity Belt",
    left_ear="mendi. Earring",
    right_ear="Gifted Earring",
    left_ring="Lebeche Ring",
    right_ring="Menelaus's ring",
    back="Solemnity cape",	
}



    sets.midcast.CureWithLightWeather = set_combine(sets.midcast['Cure'], {waist="Austerity Belt"})

    sets.midcast.Curaga = sets.midcast.Cure

    sets.midcast.Regen = {
    main="Pedagogy staff",
    sub="Clerisy strap +1",
    ammo="",
    head="Arbatel Bonnet +1",
    body="Pedagogy gown +3",
    hands="Arbatel Bracers +1",
    legs="Telchine Braconi",
    feet="Telchine Pigaches",
	waist="Embla Sash",
    back={ name="Bookworm's Cape", augments={'INT+3','MND+4','"Regen" potency+10',}},
	}

    sets.midcast.Cursna = {
        neck="",
        hands="",ring1="",
        feet=""}

    sets.midcast['Enhancing Magic'] = {
	main="Pedagogy Staff",
	sub="Clerisy strap +1",
	waist="Embla sash",
    head="Arbatel Bonnet +1",
    body="Pedagogy gown +3",
    hands="Arbatel Bracers +1",
    legs="Telchine Braconi",
    feet="Telchine Pigaches",
	ring1="Stikini ring",
	ring2="Stikini ring +1",}

    sets.midcast.Stoneskin = set_combine(sets.midcast['Enhancing Magic'], {waist="Siegel Sash"})

    sets.midcast.Storm = set_combine(sets.midcast['Enhancing Magic'], {feet="pedagogy loafers +3"})

    sets.midcast.Protect = set_combine(sets.midcast['Enhancing Magic'], {ring1="Sheltered ring"})
    sets.midcast.Protectra = sets.midcast.Protect

    sets.midcast.Shell = sets.midcast.Protect
    sets.midcast.Shellra = sets.midcast.Shell


    -- Custom spell classes
    sets.midcast.MndEnfeebles = set_combine(sets.midcast['Elemental Magic'])

    sets.midcast.IntEnfeebles = set_combine(sets.midcast['Elemental Magic'])


	

    sets.midcast.Dispelga = set_combine(sets.midcast['Elemental Magic'], {
	main="Daybreak",
	sub="Ammurapi Shield"})

    sets.midcast.ElementalEnfeeble = sets.midcast.IntEnfeebles

    sets.midcast['Dark Magic'] = set_combine(sets.midcast['Enhancing Magic'], {head=""})

    sets.midcast.Kaustra = set_combine(sets.midcast['Enhancing Magic'])

    sets.midcast.Drain = set_combine(sets.midcast['Dark Magic'], {head="", neck="Erra Pendant"})

    sets.midcast.Aspir = sets.midcast.Drain

    sets.midcast.Stun = set_combine(sets.midcast['Enhancing Magic'])

    sets.midcast.Stun.Resistant = set_combine(sets.midcast.Stun)


    -- Elemental Magic sets are default for handling low-tier nukes. MBD2+ please
    sets.midcast['Elemental Magic'] = {    
    main={ name="Marin Staff +1", augments={'Path: A',}},
    sub="Enki Strap",
    ammo="Pemphredo Tathlum",
    head={ name="Peda. M.Board +3", augments={'Enh. "Altruism" and "Focalization"',}},
    body="Agwu's Robe",
    hands={ name="Amalric Gages +1", augments={'INT+12','Mag. Acc.+20','"Mag.Atk.Bns."+20',}},
    legs="Agwu's Slops",
    feet="Arbatel Loafers +1",
    neck={ name="Argute Stole +1", augments={'Path: A',}},
    waist="Skrymir cord",
    left_ear="Malignance Earring",
    right_ear="Regal Earring",
    left_ring="Locus Ring",
    right_ring="Mujin Band",
    back={ name="Lugh's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','Magic Damage +10','"Mag.Atk.Bns."+10',}},
}

    sets.midcast['Elemental Magic'].Resistant = {--main="Lehbrailg +2",sub="",
    ammo="",
    head="jhakri coronal +2",
    body="Jhakri Robe +2",
    hands="jhakri cuffs +2",
    legs="Mallquis Trews +1",
    feet="jhakri pigaches +2",
    neck="Sanctity Necklace",
    waist="",
    left_ear="Hecate's Earring",
    right_ear="Friomisi Earring",
    left_ring="Mujin Band",
    right_ring="Locus Ring",
    back="Seshaw Cape",
	}

    -- Custom refinements for certain nuke tiers
    sets.midcast['Elemental Magic'].WeatherObi = set_combine(sets.midcast['Elemental Magic'], {waist="Hachirin-no-obi"})

    --sets.midcast['Elemental Magic'].HighTierNuke.Resistant = set_combine(sets.midcast['Elemental Magic'].Resistant)

    sets.midcast.Impact = {
    sub="Enki Strap",
    ammo="Pemphredo Tathlum",
    body="Twilight Cloak",
    hands="Regal Cuffs",
    legs="Agwu's Slops",
    feet={ name="Peda. Loafers +3", augments={'Enhances "Stormsurge" effect',}},
    neck={ name="Argute Stole +1", augments={'Path: A',}},
    waist="Hachirin-no-Obi",
    left_ear="Malignance Earring",
    right_ear="Regal Earring",
    left_ring="Stikini Ring",
    right_ring="Stikini Ring +1",
    back={ name="Lugh's Cape", augments={'Mag. Acc+20 /Mag. Dmg.+20','"Fast Cast"+10',}},
	}

  sets.midcast['Ionohelix II'] = {
    main="Daybreak",
    sub="Ammurapi Shield",
    ammo="Pemphredo Tathlum",
    head={ name="Peda. M.Board +3", augments={'Enh. "Altruism" and "Focalization"',}},
    body="Agwu's Robe",
    hands={ name="Amalric Gages +1", augments={'INT+12','Mag. Acc.+20','"Mag.Atk.Bns."+20',}},
    legs={ name="Merlinic Shalwar", augments={'Mag. Acc.+23 "Mag.Atk.Bns."+23','Magic burst dmg.+8%','"Mag.Atk.Bns."+11',}},
    feet="Arbatel Loafers +1",
    neck={ name="Argute Stole +1", augments={'Path: A',}},
    waist="Skrymir Cord",
    left_ear="Malignance Earring",
    right_ear="Regal Earring",
    left_ring="Locus Ring",
    right_ring="Mujin Band",
    back={ name="Lugh's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','Magic Damage +10','"Mag.Atk.Bns."+10',}},
  }

  sets.midcast['Luminohelix II'] = sets.midcast['Ionohelix II']
  sets.midcast['Anemohelix II'] = sets.midcast['Ionohelix II']
  sets.midcast['Hydrohelix II'] = sets.midcast['Ionohelix II']
  sets.midcast['Pyrohelix II'] = sets.midcast['Ionohelix II']
  sets.midcast['Noctohelix II'] = sets.midcast['Ionohelix II']
  sets.midcast['Geohelix II'] = sets.midcast['Ionohelix II']
  sets.midcast['Cryohelix II'] = sets.midcast['Ionohelix II']

    -- Sets to return to when not performing an action.

    -- Resting sets
    sets.resting = {
	main="Chatoyant Staff",sub="",
        head="",neck="",
        body="",hands="",ring1="Sheltered Ring",ring2="",
        waist="Austerity Belt",legs="",feet=""}


    -- Idle sets (default idle set not needed since the other three are defined, but leaving for testing purposes)

--    sets.idle.Town = {--main="Bolelabunga",sub="Genbu's Shield",ammo="",
--        head="Arbatel bonnet +1",neck="",ear1="",ear2="Loquacious Earring",
--        body="Pedagogy Gown +2",hands="Arbatel Bracers +1 +1",ring1="Sheltered Ring",ring2="",
--        back="Umbra Cape",waist="Hierarch Belt",legs="Savant's Pants +2",feet=""}

    sets.idle.Field = {
    main="Malignance Pole",
    sub="Mensch Strap +1",
    ammo="Homiliary",
    head="Nyame Helm",
    body="Jhakri Robe +2",
    hands="Nyame Gauntlets",
    legs="Nyame Flanchard",
    feet="Mallquis Clogs +1",
    neck="Argute stole +1",
    waist="Austerity Belt",
    left_ear="Ethereal Earring",
    right_ear="Etiolation Earring",
    left_ring="Prolix Ring",
    right_ring="Stikini Ring +1",
    back="Moonbeam Cape",
	}

  sets.idle.PDT = sets.idle.Field
	
    sets.idle.Field.CP = set_combine(sets.idle.PDT, {back="Mecisto. mantle",})
 
 sets.idle.Field.PDT = {
    main="Malignance Pole",
    sub="Mensch Strap +1",
    ammo="Homiliary",
    head="Nyame Helm",
    body="Jhakri Robe +2",
    hands="Nyame Gauntlets",
    legs="Nyame Flanchard",
    feet="Mallquis Clogs +1",
    neck="Argute stole +1",
    waist="Austerity Belt",
    left_ear="Ethereal Earring",
    right_ear="Etiolation Earring",
    left_ring="Prolix Ring",
    right_ring="Stikini Ring +1",
    back="Moonbeam Cape",
}

    sets.idle.Field.Stun = {--main="Apamajas II",sub="",ammo="",
        head="",neck="",ear1="Psystorm Earring",ear2="Lifestorm Earring",
        --body="Vanir Cotehardie",
		hands="",ring1="Prolix Ring",ring2="",
        back="Swith cape",waist="",legs="",feet=""}

    sets.idle.Weak = sets.idle.PDT

    -- Defense sets

    sets.defense.PDT = sets.idle.Field
	
	sets.defense.CP = set_combine(sets.defense.PDT, {body="jhakri robe +2", right_ring="Stikini ring +1",})
	
    sets.defense.MDT = {
	--main=gear.Staff.PDT,sub="Achaq Grip",ammo="",
        head="",neck="Argute stole +1",ear1="",ear2="Loquacious Earring",
        --body="Vanir Cotehardie",
		hands="",ring1="Defending Ring",ring2="",
        back="",waist="Hierarch Belt",legs="",feet=""}

    sets.Kiting = {feet=""}

    sets.latent_refresh = {waist=""}

    -- Engaged sets

    -- Variations for TP weapon and (optional) offense/defense modes.  Code will fall back on previous
    -- sets if more refined versions aren't defined.
    -- If you create a set with both offense and defense modes, the offense mode should be first.
    -- EG: sets.engaged.Dagger.Accuracy.Evasion

    -- Normal melee group
    sets.engaged = {
        head="",
        --body="Vanir Cotehardie",
		hands="",ring1="Rajas Ring",
        waist="",legs="",feet=""}



    -- Buff sets: Gear that needs to be worn to actively enhance a current player buff.
    sets.buff['Ebullience'] = {head="Arbatel bonnet +1"}
    sets.buff['Rapture'] = {head="Arbatel bonnet +1"}
    sets.buff['Perpetuance'] = {hands="Arbatel Bracers +1"}
    sets.buff['Immanence'] = {hands="Arbatel Bracers +1"}
    sets.buff['Penury'] = {legs="Arbatel Pants +1"}
    sets.buff['Parsimony'] = {legs="Arbatel Pants +1"}
    sets.buff['Celerity'] = {feet="pedagogy loafers +3"}
    sets.buff['Alacrity'] = {feet="pedagogy loafers +3"}

    sets.buff['Klimaform'] = {feet="Arbatel Loafers +1"}

    sets.buff.FullSublimation = {body="Pedagogy Gown +3", waist="Embla sash"}
    sets.buff.PDTSublimation = {}

    --sets.buff['Sandstorm'] = {feet="Desert Boots"}
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

-- Run after the general midcast() is done.
function job_post_midcast(spell, action, spellMap, eventArgs)
    if spell.action_type == 'Magic' then
        apply_grimoire_bonuses(spell, action, spellMap, eventArgs)
    end
end
function job_post_midcast(spell, action, spellMap, eventArgs)
  if spell.element == world.weather_element or spell_element == world.day_element then
    if spell.skill == 'Elemental Magic' then -- Only use obi on elemental magic
      equip({waist="Hachirin-no-Obi"})
    end
  end
end
-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for non-casting events.
-------------------------------------------------------------------------------------------------------------------

-- Called when a player gains or loses a buff.
-- buff == buff gained or lost
-- gain == true if the buff was gained, false if it was lost.
function job_buff_change(buff, gain)
    if buff == "Sublimation: Activated" then
        handle_equipping_gear(player.status)
    end
end

-- Handle notifications of general user state change.
function job_state_change(stateField, newValue, oldValue)
    if stateField == 'Offense Mode' then
        if newValue == 'Normal' then
            disable('main','sub','range')
        else
            enable('main','sub','range')
        end
    end
end

-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------

-- Custom spell mapping.
function job_get_spell_map(spell, default_spell_map)
    if spell.action_type == 'Magic' then
        if default_spell_map == 'Cure' or default_spell_map == 'Curaga' then
            if world.weather_element == 'Light' then
                return 'CureWithLightWeather'
            end
        elseif spell.skill == 'Enfeebling Magic' then
            if spell.type == 'WhiteMagic' then
                return 'MndEnfeebles'
            else
                return 'IntEnfeebles'
            end
        elseif spell.skill == 'Elemental Magic' then
            if info.low_nukes:contains(spell.english) then
                return 'LowTierNuke'
            elseif info.mid_nukes:contains(spell.english) then
                return 'MidTierNuke'
            elseif info.high_nukes:contains(spell.english) then
                return 'HighTierNuke'
            end
        end
    end
end

function customize_idle_set(idleSet)
    if state.Buff['Sublimation: Activated'] then
        if state.IdleMode.value == 'Normal' then
            idleSet = set_combine(idleSet, sets.buff.FullSublimation)
        elseif state.IdleMode.value == 'PDT' then
            idleSet = set_combine(idleSet, sets.buff.PDTSublimation)
        end
    end

    if player.mpp < 51 then
        idleSet = set_combine(idleSet, sets.latent_refresh)
    end

    return idleSet
end

-- Called by the 'update' self-command.
function job_update(cmdParams, eventArgs)
    if cmdParams[1] == 'user' and not (buffactive['light arts']      or buffactive['dark arts'] or
                       buffactive['addendum: white'] or buffactive['addendum: black']) then
        if state.IdleMode.value == 'Stun' then
            send_command('@input /ja "Dark Arts" <me>')
        else
            send_command('@input /ja "Light Arts" <me>')
        end
    end

    update_active_strategems()
    update_sublimation()
end

-- Function to display the current relevant user state when doing an update.
-- Return true if display was handled, and you don't want the default info shown.
function display_current_job_state(eventArgs)
    display_current_caster_state()
    eventArgs.handled = true
end

-------------------------------------------------------------------------------------------------------------------
-- User code that supplements self-commands.
-------------------------------------------------------------------------------------------------------------------

-- Called for direct player commands.
function job_self_command(cmdParams, eventArgs)
    if cmdParams[1]:lower() == 'scholar' then
        handle_strategems(cmdParams)
        eventArgs.handled = true
    end
end

-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

-- Reset the state vars tracking strategems.
function update_active_strategems()
    state.Buff['Ebullience'] = buffactive['Ebullience'] or false
    state.Buff['Rapture'] = buffactive['Rapture'] or false
    state.Buff['Perpetuance'] = buffactive['Perpetuance'] or false
    state.Buff['Immanence'] = buffactive['Immanence'] or false
    state.Buff['Penury'] = buffactive['Penury'] or false
    state.Buff['Parsimony'] = buffactive['Parsimony'] or false
    state.Buff['Celerity'] = buffactive['Celerity'] or false
    state.Buff['Alacrity'] = buffactive['Alacrity'] or false

    state.Buff['Klimaform'] = buffactive['Klimaform'] or false
end

function update_sublimation()
    state.Buff['Sublimation: Activated'] = buffactive['Sublimation: Activated'] or false
end

-- Equip sets appropriate to the active buffs, relative to the spell being cast.
function apply_grimoire_bonuses(spell, action, spellMap)
    if state.Buff.Perpetuance and spell.type =='WhiteMagic' and spell.skill == 'Enhancing Magic' then
        equip(sets.buff['Perpetuance'])
    end
    if state.Buff.Rapture and (spellMap == 'Cure' or spellMap == 'Curaga') then
        equip(sets.buff['Rapture'])
    end
    if spell.skill == 'Elemental Magic' and spellMap ~= 'ElementalEnfeeble' then
        if state.Buff.Ebullience and spell.english ~= 'Impact' then
            equip(sets.buff['Ebullience'])
        end
        if state.Buff.Immanence then
            equip(sets.buff['Immanence'])
        end
        if state.Buff.Klimaform and spell.element == world.weather_element then
            equip(sets.buff['Klimaform'])
        end
    end

    if state.Buff.Penury then equip(sets.buff['Penury']) end
    if state.Buff.Parsimony then equip(sets.buff['Parsimony']) end
    if state.Buff.Celerity then equip(sets.buff['Celerity']) end
    if state.Buff.Alacrity then equip(sets.buff['Alacrity']) end
end


-- General handling of strategems in an Arts-agnostic way.
-- Format: gs c scholar <strategem>
function handle_strategems(cmdParams)
    -- cmdParams[1] == 'scholar'
    -- cmdParams[2] == strategem to use

    if not cmdParams[2] then
        add_to_chat(123,'Error: No strategem command given.')
        return
    end
    local strategem = cmdParams[2]:lower()

    if strategem == 'light' then
        if buffactive['light arts'] then
            send_command('input /ja "Addendum: White" <me>')
        elseif buffactive['addendum: white'] then
            add_to_chat(122,'Error: Addendum: White is already active.')
        else
            send_command('input /ja "Light Arts" <me>')
        end
    elseif strategem == 'dark' then
        if buffactive['dark arts'] then
            send_command('input /ja "Addendum: Black" <me>')
        elseif buffactive['addendum: black'] then
            add_to_chat(122,'Error: Addendum: Black is already active.')
        else
            send_command('input /ja "Dark Arts" <me>')
        end
    elseif buffactive['light arts'] or buffactive['addendum: white'] then
        if strategem == 'cost' then
            send_command('input /ja Penury <me>')
        elseif strategem == 'speed' then
            send_command('input /ja Celerity <me>')
        elseif strategem == 'aoe' then
            send_command('input /ja Accession <me>')
        elseif strategem == 'power' then
            send_command('input /ja Rapture <me>')
        elseif strategem == 'duration' then
            send_command('input /ja Perpetuance <me>')
        elseif strategem == 'accuracy' then
            send_command('input /ja Altruism <me>')
        elseif strategem == 'enmity' then
            send_command('input /ja Tranquility <me>')
        elseif strategem == 'skillchain' then
            add_to_chat(122,'Error: Light Arts does not have a skillchain strategem.')
        elseif strategem == 'addendum' then
            send_command('input /ja "Addendum: White" <me>')
        else
            add_to_chat(123,'Error: Unknown strategem ['..strategem..']')
        end
    elseif buffactive['dark arts']  or buffactive['addendum: black'] then
        if strategem == 'cost' then
            send_command('input /ja Parsimony <me>')
        elseif strategem == 'speed' then
            send_command('input /ja Alacrity <me>')
        elseif strategem == 'aoe' then
            send_command('input /ja Manifestation <me>')
        elseif strategem == 'power' then
            send_command('input /ja Ebullience <me>')
        elseif strategem == 'duration' then
            add_to_chat(122,'Error: Dark Arts does not have a duration strategem.')
        elseif strategem == 'accuracy' then
            send_command('input /ja Focalization <me>')
        elseif strategem == 'enmity' then
            send_command('input /ja Equanimity <me>')
        elseif strategem == 'skillchain' then
            send_command('input /ja Immanence <me>')
        elseif strategem == 'addendum' then
            send_command('input /ja "Addendum: Black" <me>')
        else
            add_to_chat(123,'Error: Unknown strategem ['..strategem..']')
        end
    else
        add_to_chat(123,'No arts has been activated yet.')
    end
end


-- Gets the current number of available strategems based on the recast remaining
-- and the level of the sch.
function get_current_strategem_count()
    -- returns recast in seconds.
    local allRecasts = windower.ffxi.get_ability_recasts()
    local stratsRecast = allRecasts[231]

    local maxStrategems = (player.main_job_level + 10) / 20

    local fullRechargeTime = 4*60

    local currentCharges = math.floor(maxStrategems - maxStrategems * stratsRecast / fullRechargeTime)

    return currentCharges
end


-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
    set_macro_page(1, 17)
end