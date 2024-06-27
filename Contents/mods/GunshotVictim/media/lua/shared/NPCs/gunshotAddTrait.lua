require('NPCs/MainCreationMethods');

function GunshotVictimInit()
    TraitFactory.addTrait("gunshot_victim_minor",getText("UI_GunshotVictimMinor"),-8,getText("UI_Gunshot_Victim_Minor_Desc_Point1")..getText("\n")..getText("UI_Gunshot_Victim_Minor_Desc_Point2")..getText("\n")..getText("UI_Gunshot_Victim_Minor_Desc_Point3")..getText("\n")..getText("UI_Gunshot_Victim_Tweezer_Start"),false, false)
    TraitFactory.addTrait("gunshot_victim_major",getText("UI_GunshotVictimMajor"),-16,getText("UI_Gunshot_Victim_Major_Desc_Point1")..getText("\n")..getText("UI_Gunshot_Victim_Major_Desc_Point2")..getText("\n")..getText("UI_Gunshot_Victim_Major_Desc_Point3")..getText("\n")..getText("UI_Gunshot_Victim_Tweezer_Start"),false,false)
    TraitFactory.setMutualExclusive("gunshot_victim_minor","gunshot_victim_major")
end

Events.OnGameBoot.Add(GunshotVictimInit)