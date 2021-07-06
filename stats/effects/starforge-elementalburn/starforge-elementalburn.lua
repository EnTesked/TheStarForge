function init()
  self.movementMultiplier = config.getParameter("movementMultiplier", 0.85)
  self.elementType = "default"

  animator.setParticleEmitterOffsetRegion("drips", mcontroller.boundBox())
  animator.setParticleEmitterActive("drips", true)
  effect.addStatModifierGroup({
    {stat = "jumpModifier", amount = (self.movementMultiplier - 1)}
  })
  
  self.tickDamagePercentage = config.getParameter("tickDamagePercentage", 0.01)
  self.tickTime = config.getParameter("tickTime", 1)
  self.tickTimer = self.tickTime
end

function update(dt)
  mcontroller.controlModifiers({
	groundMovementModifier = self.movementMultiplier,
	speedModifier = self.movementMultiplier,
	airJumpModifier = self.movementMultiplier
  })
  
  self.tickTimer = self.tickTimer - dt  
  if self.tickTimer <= 0 then
    --Calculate tick damage
    local tickDamage = math.min(math.floor(status.resourceMax("health") * self.tickDamagePercentage) + 1, 20)
	
    self.tickTimer = self.tickTime
	status.applySelfDamageRequest({
        damageType = "IgnoresDef",
        damage = tickDamage,
        damageSourceKind = self.elementType,
        sourceEntityId = entity.id()
    })
  end

  self.fade = string.format("=%.1f", self.tickTimer * 0.4)
  effect.setParentDirectives(config.getParameter("directives", "") .. self.fade)
end