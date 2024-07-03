local function GuninHandDetection()
    local player = getPlayer()
    if player:getPrimaryHandItem() == nil then
        return
    end
	
    if player:HasTrait("gunshot_victim_minor") then
        if player:isDead() == false then
            if player:getPrimaryHandItem():getSubCategory() == "Firearm" then
                if player:getBetaEffect() == 0 then
                    -- Calculate Deltatime for Panic
                    local delta = getGameTime():getTimeDelta()

                    -- Set Panic
                    local panic = player:getStats():getPanic() + 10 * delta
                    player:getStats():setPanic(panic)
                end
            end
        end
    end

    if player:HasTrait("gunshot_victim_major") then
        if player:isDead() == false then
            if player:getPrimaryHandItem():getSubCategory() == "Firearm" then
                if player:getBetaDelta() <= 0.1 then
                    player:dropHandItems()
                    player:getStats():setPanic(100)
                    if player:isFemale() then
                        getSoundManager():PlaySound("female_heavybreathpanic", false, 5):setVolume(0.035)
                    else
                        getSoundManager():PlaySound("male_heavybreathpanic", false, 5):setVolume(0.035)
                    end
                    player:Say(getText(getText("UI_Gun_Refusal_")..ZombRand(1,10)))
                else
                    local delta = getGameTime():getTimeDelta()
                    -- Dispite the betablockers, it doesn't mean the character is immune to gun panic.
                    local stress = player:getStats():getStress() + 5 * delta
                    player:getStats():setStress(stress)
                end
            end
        end
    end
end
-- Executes when player starts the game with Gunshot Victim, either Minor or Major
local function GiveGunShotWounds(_player)
    -- Get the player and their Body Damage
    local player = _player
    local bodydamage = player:getBodyDamage()
    
    -- Does the player have the Minor Gunshot Victim trait?
    if player:HasTrait("gunshot_victim_minor") then
        -- Give the player some tweezers
        getPlayer():getInventory():AddItem("Base.Tweezers")

        -- Gives the player 2 gunshot wounds.
        for i = 0, 1 do
            local skip = false
            local bodyPart = ZombRand(0,16)
            local b = bodydamage:getBodyPart(BodyPartType.FromIndex(bodyPart))
            if b:HasInjury() == true then
                skip = true
            end
            if skip == false then
                b:setHaveBullet(true, 0)
                b:setBandaged(true, 20, true, "Base.AlcoholBandage")
            end
        end
    end

    -- Does the player have the Severe Gunshot Victim trait?
    if player:HasTrait("gunshot_victim_major") then
        -- Give the player some tweezers
        getPlayer():getInventory():AddItem("Base.Tweezers")
        
        -- Gives the player 5 gunshot wounds ( and trauma for rest of their lives )
        for i = 0, 4 do
            local skip = false
            local bodyPart = ZombRand(0,16)
            local b = bodydamage:getBodyPart(BodyPartType.FromIndex(bodyPart))
            if b:HasInjury() == true then
                skip = true
            end
            if skip == false then
                b:setHaveBullet(true, 0)
                b:setBandaged(true, 20, true, "Base.AlcoholBandage")
            end
        end
    end
end

local function Check_for_Level()
    local player = getPlayer()
    if player:HasTrait("gunshot_victim_major") then
        if player:getPerkLevel(Perks.Aiming) >= 5 and player:getPerkLevel(Perks.Reloading) >= 5 then
            player:getTraits():remove("gunshot_victim_major")
            player:getTraits():add("gunshot_victim_minor")
            player:Say(getText("UI_Maybe_I_Can_Do_This"))
        end
    end
    if player:HasTrait("gunshot_victim_minor") then
        if player:getPerkLevel(Perks.Aiming) >= 7 and player:getPerkLevel(Perks.Reloading) >= 7 then
            player:getTraits():remove("gunshot_victim_minor")
            player:Say(getText("UI_Got_Used_To"))
        end
    end
end

Events.OnTick.Add(GuninHandDetection)
Events.EveryOneMinute.Add(Check_for_Level)
--Events.OnEquipPrimary.Add(onGunEquip)
Events.OnNewGame.Add(GiveGunShotWounds)