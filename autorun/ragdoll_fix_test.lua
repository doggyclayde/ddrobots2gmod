local ROBOT_MODEL = "models/doggyclayde/ponco/ponco.mdl"

hook.Add("Think", "Robot_Ragdoll_ConstantFix", function()
    for _, ent in ipairs(ents.GetAll()) do
        if IsValid(ent) and string.lower(ent:GetModel() or "") == ROBOT_MODEL then
            
            if ent:IsRagdoll() or ent:GetClass() == "prop_ragdoll" or ent:GetClass() == "ragmod_ragdoll" then
                
                ent:SetNW2Vector("RobotBaseColor", Vector(1, 1, 1))
                ent:SetNW2Vector("RobotColor", Vector(1, 1, 1))
                
                local faceID = ent:FindBodygroupByName("face")
                if faceID != -1 then
                    ent:SetBodygroup(faceID, 3)
                end
            end
        end
    end
end)
