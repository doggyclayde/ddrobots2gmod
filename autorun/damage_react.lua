local ROBOT_MODEL = "models/doggyclayde/ponco/ponco.mdl"
local COLOR_NORMAL = Vector(0, 1, 1)
local COLOR_DAMAGE = Vector(0, 0.2, 1)

hook.Add("EntityTakeDamage", "Robot_Damage_Visuals", function(target, dmginfo)
    if target:IsPlayer() and string.lower(target:GetModel() or "") == ROBOT_MODEL then
        if (target:Health() - dmginfo:GetDamage() <= 0) then return end

        local faceID = target:FindBodygroupByName("face")
        if faceID == -1 then return end

        target:SetBodygroup(faceID, 1) -- f_cry
        target:SetNW2Vector("RobotColor", COLOR_DAMAGE)

        local tID = "ResetRobot_" .. target:EntIndex()
        if timer.Exists(tID) then timer.Remove(tID) end
        timer.Create(tID, 1.5, 1, function()
            if IsValid(target) and target:Alive() then
                target:SetBodygroup(faceID, 0)
                target:SetNW2Vector("RobotColor", COLOR_NORMAL)
            end
        end)
    end
end)
