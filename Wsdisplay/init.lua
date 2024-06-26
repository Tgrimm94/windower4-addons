
-- Import Windower libraries
require('tables')
require('strings')
res = require('resources')

-- Table of skillchain properties
local skillchains = {
    ["Light"] = {"Fusion", "Transfixion"},
    ["Darkness"] = {"Gravitation", "Distortion"},
    ["Fusion"] = {"Liquefaction", "Compression"},
    ["Gravitation"] = {"Fragmentation", "Distortion"},
    -- Add more skillchains as needed
}

-- Table of weapon skills and their properties
local weapon_skills = {
    ["Fast Blade"] = {property = "Light", weapons = {"Sword"}},
    ["Burning Blade"] = {property = "Fusion", weapons = {"Sword"}},
    ["Red Lotus Blade"] = {property = "Liquefaction", weapons = {"Sword"}},
    -- Add more weapon skills as needed
}

-- Function to get the best weapon skill for a skillchain
function get_best_weapon_skill(previous_skill, current_weapon)
    local ws_info = weapon_skills[previous_skill]
    if ws_info and skillchains[ws_info.property] then
        for _, ws in pairs(skillchains[ws_info.property]) do
            for skill_name, skill_info in pairs(weapon_skills) do
                if skill_info.property == ws and table.contains(skill_info.weapons, current_weapon) then
                    return skill_name
                end
            end
        end
    end
    return nil
end

-- Function to check if a value is in a table
function table.contains(table, element)
    for _, value in pairs(table) do
        if value == element then
            return true
        end
    end
    return false
end

-- Function to get the player's current weapon type
function get_current_weapon_type()
    local player = windower.ffxi.get_player()
    local main_weapon = player.equipment.main
    local weapon_info = res.items[main_weapon]
    if weapon_info then
        return weapon_info.skill
    end
    return nil
end

-- Event handler for when a trust uses a weapon skill
windower.register_event('action', function(action)
    if action.category == 3 then -- Category 3 is weapon skills
        local actor = action.actor_id
        local target = action.targets[1]
        local ws_id = action.param

        if actor == windower.ffxi.get_player().id then
            -- If the action is from the player, do nothing
            return
        end

        local ws_name = res.weapon_skills[ws_id].name
        local current_weapon = get_current_weapon_type()
        local best_ws = get_best_weapon_skill(ws_name, current_weapon)

        if best_ws then
            -- Display the best weapon skill above the player's head
            windower.add_to_chat(207, 'Best WS to use: ' .. best_ws)
            windower.text.create('WSdisplay_text')
            windower.text.set_text('WSdisplay_text', 'Best WS: ' .. best_ws)
            windower.text.set_location('WSdisplay_text', 400, 300)
            windower.text.set_bg_color('WSdisplay_text', 200, 0, 0, 0)
            windower.text.set_color('WSdisplay_text', 255, 255, 255, 255)
            windower.text.set_font('WSdisplay_text', 'Arial', 12)
            windower.text.set_visibility('WSdisplay_text', true)
        end
    end
end)
