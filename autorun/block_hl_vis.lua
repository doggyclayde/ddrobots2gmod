if not SERVER then return end

local ROBOT_MODEL = "models/doggyclayde/ponco/ponco.mdl"

local function IsRobotModel(ent)
    if not IsValid(ent) then return false end
    return string.lower(ent:GetModel() or "") == ROBOT_MODEL
end

local function ApplyRobotBlood(ent)
    if not IsRobotModel(ent) then return end

    -- Force mechanical/robot blood color (no red blood particles)
    if ent:GetBloodColor() ~= BLOOD_COLOR_MECH then
        ent:SetBloodColor(BLOOD_COLOR_MECH)
    end
end

hook.Add("PlayerSpawn", "RobotPlayer_SetBlood", function(ply)
    timer.Simple(0, function()
        if IsValid(ply) then
            ApplyRobotBlood(ply)
        end
    end)
end)

-- This has RagMod support
-- Hate to say it but this won't be included in the final update.
hook.Add("OnEntityCreated", "RobotRagdoll_SetBlood", function(ent)
    if not IsValid(ent) then return end

    timer.Simple(0.2, function()
        if not IsValid(ent) then return end

        local isRagmodRagdoll = false
        if ragmod and ragmod.IsRagmodRagdoll then
            local success, result = pcall(ragmod.IsRagmodRagdoll, ent)
            if success then
                isRagmodRagdoll = result or false
            end
        end

        if isRagmodRagdoll or ent:GetClass() == "prop_ragdoll" then
            ApplyRobotBlood(ent)
        end
    end)
end)

hook.Add("PlayerDeath", "RobotDeathRagdoll_SetBlood", function(victim, inflictor, attacker)
    if not IsValid(victim) or not IsRobotModel(victim) then return end

    -- Small delay because CreateRagdoll() happens after this hook
    timer.Simple(0.1, function()
        if not IsValid(victim) then return end

        local rag = victim:GetRagdollEntity()
        if IsValid(rag) then
            ApplyRobotBlood(rag)
        end
    end)
end)

-- Extra safety in case the ragdoll is created slightly later
hook.Add("CreateEntityRagdoll", "RobotCreateRagdoll_SetBlood", function(owner, rag)
    if IsValid(owner) and IsValid(rag) and IsRobotModel(owner) then
        timer.Simple(0.05, function()
            if IsValid(rag) then
                ApplyRobotBlood(rag)
            end
        end)
    end
end)

hook.Add("EntityTakeDamage", "Robot_KeepMetalBlood", function(ent)
    ApplyRobotBlood(ent)
end)