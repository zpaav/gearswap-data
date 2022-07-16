----------------------------------------------------------------------
-----------------------      Toy Weapons      ------------------------
----------------------------------------------------------------------

sets.ToyWeapon = {} --DO NOT MODIFY
sets.ToyWeapon.None = {main=nil, sub=nil} --DO NOT MODIFY
sets.ToyWeapon.Katana = {main="Trainee Burin",sub="Qutrub Knife"}
sets.ToyWeapon.GreatKatana = {main="Mutsunokami",sub="Tzacab Grip"}
-- sets.ToyWeapon.GreatKatana = {main="Lotus Katana",sub="Tzacab Grip"}
sets.ToyWeapon.Dagger = {main="Qutrub Knife",sub="Wind Knife"}
sets.ToyWeapon.Sword = {main="Nihility",sub="Qutrub Knife"}
sets.ToyWeapon.Club = {main="Lady Bell",sub="Qutrub Knife"}
sets.ToyWeapon.Staff = {main="Savage. Pole",sub="Tzacab Grip"}
sets.ToyWeapon.Polearm = {main="Pitchfork +1",sub="Tzacab Grip"}
sets.ToyWeapon.GreatSword = {main="Lament",sub="Tzacab Grip"}
sets.ToyWeapon.Scythe = {main="Lost Sickle",sub="Tzacab Grip"}


----------------------------------------------------------------------
-----------------------   Oseem-Aug Weapons   ------------------------
----------------------------------------------------------------------

-- Aganoshe

-- Colada

-- Condemners

-- Digirbalag

-- Gada
gear.Gada_ENH = {} -- 6 Enh Duration, 6 FC
gear.Gada_MND_MAcc = {} -- 10 MND, 25 MAcc
gear.Gada_INT_MAcc = {} -- 10 INT, 25 MAcc

-- Grioavolr
gear.Grioavolr_MND = {} -- MND, Enfeeb skill, M.Acc
gear.Grioavolr_MP = {} -- 100 MP
gear.Grioavolr_MB = {} --MB Dmg, MAB, M.Acc, INT
gear.Grioavolr_FC = {} --7 FC

-- Holliday

-- Kanaria

-- Obschine

-- Reienkyo

-- Skinflayer

-- Teller

-- Umaru

-- Zulfiqar


----------------------------------------------------------------------
-----------------------    Oseem-Aug Armor    ------------------------
----------------------------------------------------------------------

-- Chironic
gear.Chironic_QA_hands = {} -- 3 QA > 10 DEX > 30 ACC > 32 ATT
gear.Chironic_QA_feet = {} -- 3 QA > 10 DEX > 30 ACC > 32 ATT

gear.Chironic_Refresh_head = {} -- 2 Refresh
gear.Chironic_Refresh_hands = {} -- 2 Refresh
gear.Chironic_Refresh_feet = {} -- 2 Refresh

gear.Chironic_AE_hands = { }-- 10 WSD > 40 MAB > 15 INT > 15 DEX
gear.Chironic_AE_feet = {} -- 10 WSD > 40 MAB > 15 INT > 15 DEX

gear.Chironic_SIRD_hands = { name="Chironic Gloves", augments={'Attack+6','Spell interruption rate down -11%','Mag. Acc.+1',}}

gear.Chironic_MAcc_legs = {} -- 40 M.Acc Aug

-- Herculean

-- Merlinic
gear.Merl_FC_body = { name="Merlinic Jubbah", augments={'Mag. Acc.+2 "Mag.Atk.Bns."+2','VIT+5','"Fast Cast"+8',}}
gear.Merl_FC_feet = { name="Merlinic Crackows", augments={'Accuracy+6','INT+10','"Fast Cast"+6','Mag. Acc.+3 "Mag.Atk.Bns."+3',}}

gear.Merl_MB_body = { name="Merlinic Jubbah", augments={'INT+3','Magic burst dmg.+11%','Accuracy+18 Attack+18',}} --10 MB Dmg, 40 MAB, 40 M.Acc, 10 INT
gear.Merl_MB_hands = { name="Merlinic Dastanas", augments={'Accuracy+10 Attack+10','DEX+8','Magic burst dmg.+9%','Mag. Acc.+9 "Mag.Atk.Bns."+9',}}
gear.Merl_MB_feet = { name="Merlinic Crackows", augments={'Magic burst dmg.+8%','Phys. dmg. taken -2%','INT+3 MND+3 CHR+3','Accuracy+7 Attack+7','Mag. Acc.+1 "Mag.Atk.Bns."+1',}}--Max: 10 MB Dmg, 40 MAB, 40 M.Acc, 10 INT

-- Odyssean

-- Valorous


----------------------------------------------------------------------
-----------------------     Skirmish Gear     ------------------------
----------------------------------------------------------------------

-- Cizin

-- Gendewitha
gear.Gende_SongFC_head = {} -- 5 Song Spellcasting Time-, 3 Song Recast Delay-, 4 PDT
gear.Gende_SongFC_hands = { name="Gende. Gages +1", augments={'Phys. dmg. taken -3%','Magic dmg. taken -2%','Song spellcasting time -4%',}} -- 5 Song Spellcasting Time-, 3 Song Recast Delay-, 4 PDT
gear.Gende_SongFC_legs = {} -- 5 Song Spellcasting Time-, 3 Song Recast Delay-, 4 PDT
gear.Gende_SongFC_feet = {} -- 5 Song Spellcasting Time-, 3 Song Recast Delay-, 4 PDT

-- Hagondes

-- Iuitl

-- Otronif

-- Beatific


----------------------------------------------------------------------
----------------------- Alluvion Skirmish Gear -----------------------
----------------------------------------------------------------------

-- Acro

-- Helios

-- Taeon
gear.Taeon_FC_body = {} -- 5 FC, 3 Phalanx
gear.Taeon_FC_hands = {} -- 5 FC, 3 Phalanx
gear.Taeon_FC_legs = {} -- 5 FC, 3 Phalanx
gear.Taeon_FC_feet = {} -- 5 FC, 3 Phalanx

gear.Taeon_Phalanx_body = gear.Taeon_FC_body
gear.Taeon_Phalanx_hands = gear.Taeon_FC_hands
gear.Taeon_Phalanx_legs = gear.Taeon_FC_legs
gear.Taeon_Phalanx_feet = gear.Taeon_FC_feet

gear.Taeon_DW_feet = {} -- 5 DW, 20 M.Eva

-- Telchine
-- TODO: Add fast cast and meva to all enh telchine except hands
gear.Telchine_ENH_head = { name="Telchine Cap", augments={'"Regen"+2','Enh. Mag. eff. dur. +9',}} -- Max 25 meva, 10 enh duration
gear.Telchine_ENH_body = { name="Telchine Chas.", augments={'Enh. Mag. eff. dur. +10',}} -- Max 25 meva, 10 enh duration
gear.Telchine_ENH_hands = { name="Telchine Gloves", augments={'Mag. Evasion+24','"Cure" potency +7%','Enh. Mag. eff. dur. +10',}} -- Max 25 meva, 8 CP, 10 enh duration
gear.Telchine_ENH_legs = { name="Telchine Braconi", augments={'Mag. Evasion+21','"Regen"+2','Enh. Mag. eff. dur. +10',}} -- Max 25 meva, 10 enh duration
gear.Telchine_ENH_feet = { name="Telchine Pigaches", augments={'Enh. Mag. eff. dur. +9',}} -- Max 25 meva, 10 enh duration

gear.Telchine_Regen_body = { name="Telchine Chas.", augments={'"Regen" potency+3',}}
gear.Telchine_Regen_hands = { name="Telchine Gloves", augments={'"Regen" potency+3',}}
gear.Telchine_Regen_legs = { name="Telchine Braconi", augments={'"Regen" potency+3',}}
gear.Telchine_Regen_feet = { name="Telchine Pigaches", augments={'"Regen" potency+3',}}

-- Yorium


----------------------------------------------------------------------
-----------------------     Sinister Reign     -----------------------
----------------------------------------------------------------------


----------------------------------------------------------------------
-----------------------      Adoulin Capes     -----------------------
----------------------------------------------------------------------

gear.SCH_Adoulin_Regen_Cape = { name="Bookworm's Cape", augments={'INT+1','MND+1','Helix eff. dur. +17','"Regen" potency+10',}}
gear.SCH_Adoulin_Helix_Cape = { name="Bookworm's Cape", augments={'INT+1','MND+1','Helix eff. dur. +20',}}
-- gear.BLU_Adoulin_Cape = {} -- Blue magic skill +10


----------------------------------------------------------------------
-----------------------    Ambuscade Capes    ------------------------
----------------------------------------------------------------------

gear.BLU_FC_Cape = { name="Rosmerta's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','MND+10','"Fast Cast"+10','Phys. dmg. taken-10%',}}
-- gear.BLU_WSD_Cape = { name="Rosmerta's Cape", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%','Phys. dmg. taken-10%',}}
-- gear.BLU_Crit_Cape = { name="Rosmerta's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','Crit.hit rate+10','Phys. dmg. taken-10%',}}
-- gear.BLU_STP_Cape = { name="Rosmerta's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Phys. dmg. taken-10%',}}
-- gear.BLU_DW_Cape = { name="Rosmerta's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Dual Wield"+10','Phys. dmg. taken-10%',}}
-- gear.BLU_MAB_Cape ={ name="Rosmerta's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+10','"Mag.Atk.Bns."+10','Phys. dmg. taken-10%',}}

gear.SCH_FC_Cape = { name="Lugh's Cape", augments={'MND+20','MND+10','"Fast Cast"+10','Phys. dmg. taken-10%',}}
gear.SCH_MAB_Cape = { name="Lugh's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','"Mag.Atk.Bns."+10','Mag. Evasion+15',}}
gear.SCH_INT_MAcc_Cape = gear.SCH_MAB_Cape
gear.SCH_CP_Cape = { name="Lugh's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+10','"Cure" potency +10%','Mag. Evasion+15',}} -- Change M.Eva for PDT
gear.SCH_MP_Cape = { name="Lugh's Cape", augments={'MP+60','Eva.+20 /Mag. Eva.+20','MP+20','"Regen"+5',}}
gear.SCH_Regen_Cape = gear.SCH_MP_Cape
gear.SCH_MND_MAcc_Cape = gear.SCH_CP_Cape
gear.SCH_Helix_Cape = gear.SCH_MAB_Cape
-- gear.SCH_Helix_Cape = { name="Lugh's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','Magic Damage +10','"Mag.Atk.Bns."+10',}}

gear.WHM_FC_Cape = { name="Alaunus's Cape", augments={'INT+20','Eva.+20 /Mag. Eva.+20','INT+10','"Fast Cast"+10','Phys. dmg. taken-10%',}}
-- gear.WHM_FC_Cape = { name="Alaunus's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','"Fast Cast"+10','Phys. dmg. taken-10%',}}
gear.WHM_INT_MAcc_Cape = gear.WHM_FC_Cape
gear.WHM_CP_Cape = { name="Alaunus's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+10','"Cure" potency +10%','Phys. dmg. taken-10%',}}
gear.WHM_MND_MAcc_Cape = gear.WHM_CP_Cape


----------------------------------------------------------------------
-----------------------     Miscellaneous     ------------------------
----------------------------------------------------------------------

gear.CP_Cape = { name="Mecisto. Mantle", augments={'Cap. Point+41%','Mag. Acc.+5','DEF+4',}}
gear.Fanatic_Gloves = { name="Fanatic Gloves", augments={'MP+50','Healing magic skill +8','"Conserve MP"+5','"Fast Cast"+5',}}
gear.Leyline_Gloves = { name="Leyline Gloves", augments={'Accuracy+7','Mag. Acc.+2',}}
gear.Samnuha_legs = { name="Samnuha Tights", augments={'STR+8','DEX+9','"Dbl.Atk."+3','"Triple Atk."+2',}}
