local mq = require("mq")
local Logger = require("PortBot.lib.Logger")

Logger.prefix = "Manastone"
Logger.loglevel = "info"

STOP_MANA_PCT = 98
STOP_HP_PCT = 40
VERSION="1.0.0"

local function manastone()
    while true do
        local manaPct = mq.TLO.Me.PctMana()
        if (manaPct >= STOP_MANA_PCT) then
            Logger.Debug("Full Mana - %d", manaPct)
            return
        end

        local hpPct = mq.TLO.Me.PctHPs()
        local inCombat = mq.TLO.Me.CombatState() == "COMBAT"
        local stunned = mq.TLO.Me.Stunned()
        local standing = mq.TLO.Me.Standing()
        local casting = mq.TLO.Me.Casting()

        if (hpPct <= STOP_HP_PCT) then
            Logger.Info("Low HP - %d", hpPct)
            return
        end

        if (inCombat) then
            Logger.Debug("In combat")
            return
        end

        if (casting) then
            Logger.Info("Casting")
            return
        end

        if (stunned) then
            Logger.Info("Stunned")
            return
        end

        if (not standing) then
            mq.cmd("/stand")
        end

        mq.cmd("/useitem Manastone")
    end
end

local function inGame() return mq.TLO.MacroQuest.GameState() == "INGAME" end

local function start()
    Logger.Info("Starting Version: %s", VERSION)

    Logger.Info("Stop HitPoints Percentage=%d", STOP_HP_PCT)
    Logger.Info("Stop Mana Percentage=%d", STOP_MANA_PCT)

    while true do
        if inGame() then
            manastone()
        end

        mq.delay("500ms")
    end
end

start()
