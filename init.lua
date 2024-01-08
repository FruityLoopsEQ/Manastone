local mq = require("mq")
local Logger = require("Manastone.lib.Logger")
local manastone = require("Manastone.lib.Manastone")

Logger.prefix = "Manastone"
Logger.loglevel = "info"

VERSION = "1.0.0"

local function inGame() return mq.TLO.MacroQuest.GameState() == "INGAME" end

local function start()
    Logger.Info("Starting Version: %s", VERSION)

    local stopManaPct = 98
    local stopHitpointsPct = 40

    Logger.Info("Stop Mana Percentage=%d", stopManaPct)
    Logger.Info("Stop HitPoints Percentage=%d", stopHitpointsPct)

    mq.bind("/manastone", function(manaPct, hpPct)
        manaPct = tonumber(manaPct)
        hpPct = tonumber(hpPct)

        if manaPct then
            stopManaPct = manaPct
            Logger.Info("Stop Mana Percentage=%d", stopManaPct)
        end

        if hpPct then
            stopHitpointsPct = hpPct
            Logger.Info("Stop HitPoints Percentage=%d", stopHitpointsPct)
        end
    end)

    while true do
        if inGame() then
            manastone(stopManaPct, stopHitpointsPct)
        end

        mq.delay("500ms")
    end
end

start()
