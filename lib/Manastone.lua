local mq = require("mq")
local Logger = require("Manastone.lib.Logger")

local function inCombat()
  local combat = mq.TLO.Me.CombatState() == "COMBAT"

  if combat then
    Logger.Debug("Combat")
  end

  return combat
end

local function isStunned()
  local stunned = mq.TLO.Me.Stunned()

  if stunned then
    Logger.Debug("Stunned")
  end

  return stunned
end

local function isStanding()
  local standing = mq.TLO.Me.Standing()

  if not standing then
    Logger.Debug("Not standing")
  end

  return standing
end

local function isCasting()
  local casting = mq.TLO.Me.Casting()

  if casting then
    Logger.Debug("Casting")
  end

  return casting
end

local function isFullMana(stopManaPct)
  local manaPct = mq.TLO.Me.PctMana()

  local fullMana = manaPct >= stopManaPct

  if fullMana then
    Logger.Debug("Full Mana - %d", manaPct)
  end

  return fullMana
end

local function isLowHitPoints(stopHitpointsPct)
  local hpPct = mq.TLO.Me.PctHPs()

  local lowHitpoints = hpPct <= stopHitpointsPct

  if lowHitpoints then
    Logger.Info("Low HP - %d", hpPct)
  end

  return lowHitpoints
end

local function manastone(stopManaPct, stopHitpointsPct)
  local shouldStop = function()
    return isFullMana(stopManaPct) or
        isLowHitPoints(stopHitpointsPct) or
        inCombat() or
        isCasting() or
        isStunned()
  end

  while not shouldStop() do
    if (not isStanding()) then
      mq.cmd("/stand")
    end

    mq.cmd("/useitem Manastone")
  end
end

return manastone
