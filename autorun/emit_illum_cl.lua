if SERVER then return end

local ROBOT_MODEL = "models/doggyclayde/ponco/ponco.mdl"

-- settings (unstable or broken btw. I can't with this...)
local LIGHT_BRIGHTNESS = 1                   
local LIGHT_RADIUS     = 30                  
local HEAD_HEIGHT      = 45                   
local FORWARD_BIAS     = 18                  

local function IsRobotModel(ply)
    if not IsValid(ply) then return false end
    return string.lower(ply:GetModel() or "") == ROBOT_MODEL
end

local ActiveLights = {}

local function CreateOrUpdateGlow(ply)
    if not IsValid(ply) or not IsRobotModel(ply) then
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
        local basePos = ply:GetPos() + Vector(0, 0, HEAD_HEIGHT)
        local forwardOffset = ply:GetForward() * FORWARD_BIAS
        dlight.pos = basePos + forwardOffset

        dlight.r = colVec.x * 255
        dlight.g = colVec.y * 255
        dlight.b = colVec.z * 255

        dlight.brightness = LIGHT_BRIGHTNESS
        dlight.Size = LIGHT_RADIUS
        dlight.Decay = 1000
        dlight.DieTime = CurTime() + 0.1
        dlight.nomodel = false
    end
end

hook.Add("Think", "Robot_HeadGlow_Client", function()
    for _, ply in ipairs(player.GetAll()) do
        if IsRobotModel(ply) then
            CreateOrUpdateGlow(ply)
        else
            ActiveLights[ply] = nil
        end
    end
end)
