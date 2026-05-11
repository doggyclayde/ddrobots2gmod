if SERVER then return end

local ROBOT_MODEL   = "models/doggyclayde/ponco/ponco.mdl"
local TOTAL_FRAMES  = 12
local FRAMERATE     = 12
local INTERVAL      = 1 / FRAMERATE

local function IsPonco(ent)
    if not IsValid(ent) then return false end
    return string.lower(ent:GetModel() or "") == ROBOT_MODEL
end

local function PlayShutdownAnim(rag)
    if not IsValid(rag) then return end

    local frame  = 0
    local matName = "models/doggyclayde/ponco/shutdown"
    local tID    = "PoncoShutdown_" .. rag:EntIndex()

    timer.Create(tID, INTERVAL, TOTAL_FRAMES, function()
        if not IsValid(rag) then
            timer.Remove(tID)
            return
        end

        local mat = Material(matName)
        mat:SetInt("$frame", frame)
        frame = frame + 1

        if frame >= TOTAL_FRAMES then
            rag:SetNW2Vector("RobotColor", Vector(0, 0, 0))
        end
    end)
end

hook.Add("OnEntityCreated", "Ponco_ShutdownAnim", function(ent)
    timer.Simple(0.25, function()
        if not IsValid(ent) then return end
        if not IsPonco(ent) then return end
        if not ent:IsRagdoll() and ent:GetClass() != "prop_ragdoll" then return end
        PlayShutdownAnim(ent)
    end)
end)