matproxy.Add({
    name = "EntityNWVector",
    init = function(self, mat, values)
        self.ResultTo = values.resultVar or values.resultvar
        self.Prefix   = values.prefix
    end,
    bind = function(self, mat, ent)
        if not IsValid(ent) then return end

        -- Any ragdoll: white so the grey base texture shows, no cyan tint, no glow.
        -- Checks multiple ways because RagMod's prop_ragdoll doesn't always pass IsRagdoll() at bind time.
        local class = ent:GetClass()
        if ent:IsRagdoll() or class == "prop_ragdoll" or class:find("ragdoll") then
            mat:SetVector(self.ResultTo, Vector(1, 1, 1))
            return
        end

        local col = ent:GetNW2Vector(self.Prefix, Vector(0, 1, 1))
        mat:SetVector(self.ResultTo, col)
    end
})