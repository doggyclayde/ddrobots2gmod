if SERVER then return end

local ROBOT_MODEL = "models/doggyclayde/ponco/sexbomb.mdl"

local LIGHT_COLOR      = Color(0, 255, 255)   
local LIGHT_BRIGHTNESS = 1                   
local LIGHT_RADIUS     = 30                  
local HEAD_HEIGHT      = 45                   

-- Forward bias (pushes light slightly toward the face to reduce back glow)
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

    -- Vector(0, 1, 1) is the math version of Color(0, 255, 255)
    ply:SetNWVector("RobotColor", Vector(0, 1, 1))
    ---------------------------

    local dlight = ActiveLights[ply]
    if not dlight then
        dlight = DynamicLight(ply:EntIndex())
        ActiveLights[ply] = dlight
    end

    if dlight then
        local basePos = ply:GetPos() + Vector(0, 0, HEAD_HEIGHT)
        local forwardOffset = ply:GetForward() * FORWARD_BIAS
        
        dlight.pos = basePos + forwardOffset

        dlight.r = LIGHT_COLOR.r
        dlight.g = LIGHT_COLOR.g
        dlight.b = LIGHT_COLOR.b
        dlight.brightness = LIGHT_BRIGHTNESS
        dlight.Size = LIGHT_RADIUS
        dlight.Decay = 0
        dlight.DieTime = CurTime() + 1
        dlight.nomodel = false
    end
end

hook.Add("Think", "Robot_HeadGlow_Client", function()
    for _, ply in ipairs(player.GetAll()) do
        if IsRobotModel(ply) then
            CreateOrUpdateGlow(ply)
        else
            -- Cleanup if they change models
            if ActiveLights[ply] then
                ply:SetNWVector("RobotColor", Vector(1, 1, 1)) -- Reset to white
                ActiveLights[ply] = nil
            end
        end
    end
end)

hook.Add("PlayerDisconnected", "Robot_Glow_Cleanup", function(ply)
    ActiveLights[ply] = nil
end)
