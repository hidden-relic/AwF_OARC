--- This is the main config file for the role system; file includes defines for roles and role flags and default values
-- @config Roles

local Roles = require 'expcore.roles' --- @dep expcore.roles
local PlayerData = require 'expcore.player_data' --- @dep expcore.player_data
local Statistics = PlayerData.Statistics

--- Role flags that will run when a player changes roles
Roles.define_flag_trigger('is_admin',function(player,state)
    player.admin = state
end)
Roles.define_flag_trigger('is_spectator',function(player,state)
    player.spectator = state
end)
Roles.define_flag_trigger('is_jail',function(player,state)
    if player.character then
        player.character.active = not state
    end
end)

--- Admin Roles
Roles.new_role('System','SYS')
:set_permission_group('Default', true)
:set_flag('is_admin')
:set_flag('is_spectator')
:set_flag('report-immune')
:set_flag('instant-respawn')
:set_allow_all()

Roles.new_role('Senior Administrator','SAdmin')
:set_permission_group('Admin')
:set_custom_color{r=233,g=63,b=233}
:set_flag('is_admin')
:set_flag('is_spectator')
:set_flag('report-immune')
:set_flag('instant-respawn')
:set_parent('Administrator')
:allow{
    'command/interface',
    'command/debug',
    'command/toggle-cheat-mode',
    'toggle_map_editor',
    'command/research-all',
}

Roles.new_role('Administrator','Admin')
:set_permission_group('Admin')
:set_custom_color{r=233,g=63,b=233}
:set_flag('is_admin')
:set_flag('is_spectator')
:set_flag('report-immune')
:set_flag('instant-respawn')
:set_parent('Moderator')
:allow{
    'gui/warp-list/bypass-proximity',
    'gui/warp-list/bypass-cooldown',
    'command/connect-all',
	'command/collectdata',
}

Roles.new_role('Moderator','Mod')
:set_permission_group('Admin')
:set_custom_color{r=0,g=170,b=0}
:set_flag('is_admin')
:set_flag('is_spectator')
:set_flag('report-immune')
:set_flag('instant-respawn')
:set_parent('Trainee')
:allow{
    'command/assign-role',
    'command/unassign-role',
    'command/repair',
    'command/kill/always',
    'command/clear-tag/always',
    'command/go-to-spawn/always',
    'command/clear-reports',
    'command/clear-warnings',
    'command/clear-inventory',
    'command/bonus',
    'command/bonus/2',
    'command/home',
    'command/home-set',
    'command/home-get',
    'command/return',
    'command/connect-player',
    'gui/rocket-info/toggle-active',
    'gui/rocket-info/remote_launch',
    'command/toggle-friendly-fire',
    'command/toggle-always-day',
    'fast-tree-decon'
}

Roles.new_role('Trainee','TrMod')
:set_permission_group('Admin')
:set_custom_color{r=0,g=170,b=0}
:set_flag('is_admin')
:set_flag('is_spectator')
:set_flag('report-immune')
:set_parent('Veteran')
:allow{
    'command/admin-chat',
    'command/admin-marker',
    'command/teleport',
    'command/bring',
    'command/give-warning',
    'command/get-warnings',
    'command/get-reports',
    'command/protect-entity',
    'command/protect-area',
    'command/jail',
    'command/unjail',
    'command/kick',
    'command/ban',
    'command/join-message',
    'command/join-message-clear',
    'command/spectate',
    'command/follow',
    'command/search',
    'command/search-amount',
    'command/search-recent',
    'command/search-online',
    'command/personal-battery-recharge',
    'command/waterfill',
    'command/pollution-off',
    'command/pollution-clear',
    'command/bot-queue-get',
    'command/bot-queue-set',
    'command/game-speed',
    'command/kill-biters',
    'command/remove-biters'
}

--- Trusted Roles
Roles.new_role('Board Member','Board')
:set_permission_group('Trusted')
:set_custom_color{r=247,g=246,b=54}
:set_flag('is_spectator')
:set_flag('report-immune')
:set_flag('instant-respawn')
:set_parent('Sponsor')
:allow{
    'command/goto',
    'command/repair',
    'command/spectate',
    'command/follow',
    'command/personal-battery-recharge',
    'command/waterfill'
}

Roles.new_role('Senior Backer','Backer')
:set_permission_group('Trusted')
:set_custom_color{r=238,g=172,b=44}
:set_flag('is_spectator')
:set_flag('report-immune')
:set_flag('instant-respawn')
:set_parent('Sponsor')
:allow{
}

Roles.new_role('Sponsor','Spon')
:set_permission_group('Trusted')
:set_custom_color{r=238,g=172,b=44}
:set_flag('is_spectator')
:set_flag('report-immune')
:set_flag('instant-respawn')
:set_parent('Supporter')
:allow{
    'gui/rocket-info/toggle-active',
    'gui/rocket-info/remote_launch',
    'command/bonus',
    'command/bonus/2',
    'command/home',
    'command/home-set',
    'command/home-get',
    'command/return',
    'fast-tree-decon'
}

Roles.new_role('Supporter','Sup')
:set_permission_group('Trusted')
:set_custom_color{r=230,g=99,b=34}
:set_flag('is_spectator')
:set_parent('Veteran')
:allow{
    'command/tag-color',
    'command/jail',
    'command/unjail',
    'command/join-message',
    'command/join-message-clear'
}

Roles.new_role('Partner','Part')
:set_permission_group('Trusted')
:set_custom_color{r=140,g=120,b=200}
:set_flag('is_spectator')
:set_parent('Veteran')
:allow{
    'command/jail',
    'command/unjail'
}

local hours10, hours250 = 10*216000, 250*60
Roles.new_role('Veteran','Vet')
:set_permission_group('Trusted')
:set_custom_color{r=140,g=120,b=200}
:set_parent('Member')
:allow{
    'command/chat-bot',
    'command/last-location'
}

--- Standard User Roles
Roles.new_role('Member','Mem')
:set_permission_group('Standard')
:set_custom_color{r=24,g=172,b=188}
:set_flag('deconlog-bypass')
:set_parent('Regular')
:allow{
    'gui/task-list/add',
    'gui/task-list/edit',
    'gui/warp-list/add',
    'gui/warp-list/edit',
    'command/save-quickbar',
    'gui/vlayer-edit',
    'command/personal-logistic',
    'command/auto-research',
    'command/manual-train',
    'command/lawnmower'
}

local mins60 = 60*60*60
Roles.new_role('Regular','Reg')
:set_permission_group('Standard')
:set_custom_color{r=79,g=155,b=163}
:set_parent('Guest')
:allow{
    'command/kill',
    'command/rainbow',
    'command/go-to-spawn',
    'command/me',
    'standard-decon',
    'bypass-entity-protection',
	'bypass-nukeprotect'
}
:set_auto_assign_condition(function(player)
    if player.online_time >= mins60 then -- auto assign after $hours3, which is currently 3h (from ticks)
        return true
    end
end)

--- Guest/Default role
local default = Roles.new_role('Guest','')
:set_permission_group('Guest')
:set_custom_color{r=185,g=187,b=160}
:allow{
    'command/tag',
    'command/tag-clear',
    'command/search-help',
    'command/list-roles',
    'command/find-on-map',
    'command/report',
    'command/ratio',
    'command/server-ups',
    'command/save-data',
    'command/preference',
    'command/set-preference',
    'command/connect',
    'command/linkme',
    'gui/player-list',
    'gui/rocket-info',
    'gui/science-info',
    'gui/task-list',
    'gui/warp-list',
    'gui/readme',
    'gui/vlayer',
    'gui/research'
}

--- Jail role
Roles.new_role('Jail')
:set_permission_group('Restricted')
:set_custom_color{r=50,g=50,b=50}
:set_block_auto_assign(true)
:set_flag('defer_role_changes')
:disallow(default.allowed)

--- System defaults which are required to be set
Roles.set_root('System')
Roles.set_default('Guest')

Roles.define_role_order{
    'System', -- Best to keep root at top
    'Senior Administrator',
    'Administrator',
    'Moderator',
    'Trainee',
    'Board Member',
    'Senior Backer',
    'Sponsor',
    'Supporter',
    'Partner',
    'Veteran',
    'Member',
    'Regular',
    'Jail',
    'Guest' -- Default must be last if you want to apply restrictions to other roles
}

Roles.override_player_roles{
    ["Windsinger"]={"Senior Administrator","Moderator", "Member"},
    ["BulletToothJake"]={"Senior Administrator", "Moderator", "Member"},
    ["DistroByte"]={"Senior Administrator", "Moderator", "Member"},
    ["oof2win2"]={"Senior Administrator", "Administrator","Moderator", "Member"},
    ["Shalrath"]={"Senior Administrator", "Administrator","Moderator","Member"},
    ["hidden_relic"]={"Senior Administrator", "Administrator","Moderator","Member"},
    -- add more role overrides below
    -- Use Discord bot roles override, this shouldn't be used much
}
