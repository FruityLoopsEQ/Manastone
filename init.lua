local mq = require("mq")

local Logger = {}

Logger.loglevels = {
    ["debug"] = { level = 1, abbreviation = "DEBUG", },
    ["info"]  = { level = 2, abbreviation = "INFO" }
}

function Logger.Output(paramLogLevel, message)
    if Logger.loglevels[Logger.loglevel:lower()].level <= Logger.loglevels[paramLogLevel].level then
        print(string.format("%s[%s] :: %s", Logger.prefix, Logger.loglevels[paramLogLevel].abbreviation, message))
    end
end

function Logger.Debug(message)
    Logger.Output("debug", message)
end

function Logger.Info(message)
    Logger.Output("info", message)
end

Logger.prefix = "Manastone"
Logger.loglevel = "info"

STOP_MANA_PCT = 98
STOP_HP_PCT = 40

local function manastone()
    while true do
        local manaPct = mq.TLO.Me.PctMana()
        if (manaPct >= STOP_MANA_PCT) then
            Logger.Debug(string.format("Full Mana - %d", manaPct) .. "%")
            return
        end

        local hpPct = mq.TLO.Me.PctHPs()
        local inCombat = mq.TLO.Me.CombatState() == "COMBAT"
        local moving = mq.TLO.Me.Moving()
        local stunned = mq.TLO.Me.Stunned()
        local standing = mq.TLO.Me.Standing()
        local casting = mq.TLO.Me.Casting()

        if (hpPct <= STOP_HP_PCT) then
            Logger.Info(string.format("Low HP - %d", hpPct) .. "%")
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

        if (moving) then
            Logger.Info("Moving")
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
    Logger.Info("Start")

    Logger.Info(string.format("Stop HitPoints Percentage=%s", STOP_HP_PCT))
    Logger.Info(string.format("Stop Mana Percentage=%s", STOP_MANA_PCT))

    while true do
        if inGame() then
            manastone()
        end

        mq.delay("500ms")
    end
end

start()
