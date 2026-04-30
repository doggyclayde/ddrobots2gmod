matproxy.Add({
    name = "EntityNWVector",
    init = function(self, mat, values)
        self.ResultTo = values.resultvar
        self.Prefix = values.prefix
    end,
    bind = function(self, mat, ent)
        if not IsValid(ent) then return end
        
        if ent:IsRagdoll() or ent:GetClass():find("ragdoll") then
            mat:SetVector(self.ResultTo, Vector(1, 1, 1)) 
            return 
        end

        local col = ent:GetNW2Vector(self.Prefix, Vector(0, 1, 1))
        mat:SetVector(self.ResultTo, col)
    end
})
