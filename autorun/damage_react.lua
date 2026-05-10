if not SERVER then return end

local ROBOT_MODEL   = "models/doggyclayde/ponco/ponco.mdl"

local VEC_NORMAL    = Vector(0, 1, 1)   -- cyan: default state
local VEC_DAMAGE    = Vector(0, 0.2, 1) -- blue: hurt state
local VEC_DEAD      = Vector(1, 1, 1)   -- white: lets grey base texture show, no cyan tint

local FACE_DEFAULT  = 0
local FACE_CRY      = 1
local FACE_SHUTDOWN = 3

local HURT_DURATION = 1.5

local function IsPonco(ent)
    if not IsValid(ent) then return false end
    return string.lower(ent:GetModel() or "") == ROBOT_MODEL
end

local function SetRobotState(ent, faceID, baseColor, glowColor)
    if not IsValid(ent) then return end
    local bgID = ent:FindBodygroupByName("face")
    if bgID != -1 then
        ent:SetBodygroup(bgID, faceID)
    end
    ent:SetNW2Vector("RobotBaseColor", baseColor)
    ent:SetNW2Vector("RobotColor",     glowColor)
end

local function ResetToNormal(ent)
    if not IsValid(ent) then return end
    if not ent:IsPlayer() then return end
    if not ent:Alive() then return end
    SetRobotState(ent, FACE_DEFAULT, VEC_NORMAL, VEC_NORMAL)
end

local function SetDeadState(ent)
    SetRobotState(ent, FACE_SHUTDOWN, VEC_DEAD, VEC_DEAD)
end

-- Clean state on spawn
hook.Add("PlayerSpawn", "Ponco_ResetState", function(ply)
    timer.Simple(0, function()
        if not IsPonco(ply) then return end
        SetRobotState(ply, FACE_DEFAULT, VEC_NORMAL, VEC_NORMAL)
    end)
end)

-- Hurt reaction (non-lethal only)
hook.Add("EntityTakeDamage", "Ponco_HurtVisuals", function(target, dmginfo)
    if not target:IsPlayer() then return end
    if not IsPonco(target) then return end
    if not target:Alive() then return end
    if target:Health() - dmginfo:GetDamage() <= 0 then return end

    SetRobotState(target, FACE_CRY, VEC_DAMAGE, VEC_DAMAGE)

    local tID = "PoncoReset_" .. target:EntIndex()
    if timer.Exists(tID) then timer.Remove(tID) end
    timer.Create(tID, HURT_DURATION, 1, function()
        ResetToNormal(target)
    end)
end)

hook.Add("PlayerDeath", "Ponco_DeathVisuals", function(victim, inflictor, attacker)
    if not IsPonco(victim) then return end
    -- force material cache flush
    for _, ent in ipairs(ents.FindByClass("prop_ragdoll")) do
        if IsPonco(ent) then
            ent:SetMaterial("")  -- clears override, forces re-bind
        end
    end
    ...
end)
-- Death: cancel hurt timer, set dead state on player entity
hook.Add("PlayerDeath", "Ponco_DeathVisuals", function(victim, inflictor, attacker)
    if not IsPonco(victim) then return end

    local tID = "PoncoReset_" .. victim:EntIndex()
    if timer.Exists(tID) then timer.Remove(tID) end

    SetDeadState(victim)
end)

-- Apply dead face to ragdoll once it exists (works for both GMod default and RagMod)
hook.Add("OnEntityCreated", "Ponco_RagdollDeadState", function(ent)
    timer.Simple(0.2, function()
        if not IsValid(ent) then return end
        if not IsPonco(ent) then return end
        if not ent:IsRagdoll() and ent:GetClass() != "prop_ragdoll" then return end
        SetDeadState(ent)
    end)
end)
