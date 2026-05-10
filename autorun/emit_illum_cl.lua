if SERVER then return end

local ROBOT_MODEL      = "models/doggyclayde/ponco/ponco.mdl"
local LIGHT_BRIGHTNESS = 1
local LIGHT_RADIUS     = 30
local HEAD_HEIGHT      = 45
local FORWARD_BIAS     = 18

local function IsPonco(ply)
    if not IsValid(ply) then return false end
    return string.lower(ply:GetModel() or "") == ROBOT_MODEL
end

local ActiveLights = {}

local function UpdateGlow(ply)
    if not IsValid(ply) or not IsPonco(ply) then
        ActiveLights[ply] = nil
        return
    end

    -- No glow when dead or ragdolled
    if not ply:Alive() or ply:IsRagdoll() then
        ActiveLights[ply] = nil
        return
    end

    local colVec = ply:GetNW2Vector("RobotColor", Vector(0, 1, 1))

    local dlight = ActiveLights[ply]
    if not dlight then
        dlight = DynamicLight(ply:EntIndex())
        ActiveLights[ply] = dlight
    end

    if dlight then
        local basePos       = ply:GetPos() + Vector(0, 0, HEAD_HEIGHT)
        local forwardOffset = ply:GetForward() * FORWARD_BIAS
        dlight.pos          = basePos + forwardOffset
        dlight.r            = colVec.x * 255
        dlight.g            = colVec.y * 255
        dlight.b            = colVec.z * 255
        dlight.brightness   = LIGHT_BRIGHTNESS
        dlight.Size         = LIGHT_RADIUS
        dlight.Decay        = 1000
        dlight.DieTime      = CurTime() + 0.1
        dlight.nomodel      = false
    end
end

hook.Add("Think", "Ponco_HeadGlow", function()
    for _, ply in ipairs(player.GetAll()) do
        UpdateGlow(ply)
    end
end)