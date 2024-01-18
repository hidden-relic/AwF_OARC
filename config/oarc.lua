local chunk_size = 32
local sec = 60
local min = sec*60
local hr = min*60

local config = {
    logging = {
        decon_logfile = "log/decon.log",
        shoot_logfile = "log/shoot.log"
    },
    spawn_radius = chunk_size*3,
    spawn_trees = true,
    near_distance = {
        min = chunk_size*50,
        max = chunk_size*100
    },
    far_distance = {
        min = chunk_size*150,
        max = chunk_size*300
    },
    distance_from_another_player = chunk_size*50,
    zones = {
        safe_zone = {
            size = chunk_size*10,
        },
        green_zone = {
            size = chunk_size*15,
            rate = 2
        },
        yellow_zone = {
            size = chunk_size*25,
            rate = 3
        }
    },
    minimum_online_time = 15*min
}
config.resources = {
    water = {
        offset = {
            x = -8,
            y = -78
        },
        length = 16
    },
    ["crude-oil"] =
    {
        num_patches = 4,
        amount = 1080000,
        x_offset_start = -8,
        y_offset_start = 78,
        x_offset_next = 6,
        y_offset_next = 0
    },
    ore = {
        size = 21,
        random = {
            enabled = true,
            radius = 0.75*config.spawn_radius,
            angle_offset = 2.285,
            angle_final = 4.57
        },
        tiles = {
            ["iron-ore"] = {
                amount = 2500,
                -- area = {{}, {}} -- in case we don't want random, supply this
            },
            ["copper-ore"] = {
                amount = 2500,
                -- area = {{}, {}}
            },
            ["coal"] = {
                amount = 2500,
                -- area = {{}, {}}
            },
            ["stone"] = {
                amount = 2500,
                -- area = {{}, {}}
            },
        }
    }
}
return config