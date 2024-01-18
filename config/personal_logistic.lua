--- PL Settings
-- @config Personal Logistic

return {
    start = 0,
    production_required = {
        ['belt'] = 100,
        ['power'] = 20,
        ['miner'] = 20,
        ['furnace'] = 20,
        ['machine'] = 20,
        ['pole'] = 20,
        ['bot'] = 20,
        ['inserter'] = 20,
        ['chest'] = 20,
        ['rail'] = 100,
        ['module'] = 20,
        ['defense'] = 20,
        ['rocket'] = 20,
        ['ammo'] = 20,
        ['armor'] = 3,
        ['armor_equipment'] = 4,
        ['weapon'] = 0
    },
    request = {
        -- belt
        ['transport-belt'] = {
            key = 1,
            upgrade_of = nil,
            type = 'belt',
            stack = 100,
            min = 500,
            max = 500
        },
        ['underground-belt'] = {
            key = 2,
            upgrade_of = nil,
            type = 'belt',
            stack = 50,
            min = 150,
            max = 150
        },
        ['splitter'] = {
            key = 3,
            upgrade_of = nil,
            type = 'belt',
            stack = 50,
            min = 100,
            max = 100
        },
        ['fast-transport-belt'] = {
            key = 11,
            upgrade_of = 'transport-belt',
            type = 'belt',
            stack = 100,
            min = 500,
            max = 500
        },
        ['fast-underground-belt'] = {
            key = 12,
            upgrade_of = 'underground-belt',
            type = 'belt',
            stack = 50,
            min = 150,
            max = 150
        },
        ['fast-splitter'] = {
            key = 13,
            upgrade_of = 'splitter',
            type = 'belt',
            stack = 50,
            min = 100,
            max = 100
        },
        ['express-transport-belt'] = {
            key = 21,
            upgrade_of = 'fast-transport-belt',
            type = 'belt',
            stack = 100,
            min = 500,
            max = 500
        },
        ['express-underground-belt'] = {
            key = 22,
            upgrade_of = 'fast-underground-belt',
            type = 'belt',
            stack = 50,
            min = 150,
            max = 150
        },
        ['express-splitter'] = {
            key = 23,
            upgrade_of = 'fast-splitter',
            type = 'belt',
            stack = 50,
            min = 100,
            max = 100
        },
        -- power
        ['solar-panel'] = {
            key = 4,
            upgrade_of = nil,
            type = 'power',
            stack = 50,
            min = 50,
            max = 50
        },
        ['accumulator'] = {
            key = 5,
            upgrade_of = nil,
            type = 'power',
            stack = 50,
            min = 50,
            max = 50
        },
        ['boiler'] = {
            key = 6,
            upgrade_of = nil,
            type = nil,
            stack = 50,
            min = 0,
            max = 0
        },
        ['steam-engine'] = {
            key = 7,
            upgrade_of = nil,
            type = nil,
            stack = 10,
            min = 0,
            max = 0
        },
        -- miner
        ['burner-mining-drill'] = {
            key = 8,
            upgrade_of = nil,
            type = 'miner',
            stack = 50,
            min = 0,
            max = 0
        },
        ['electric-mining-drill'] = {
            key = 9,
            upgrade_of = 'burner-mining-drill',
            type = 'miner',
            stack = 50,
            min = 250,
            max = 250
        },
        ['pumpjack'] = {
            key = 10,
            upgrade_of = nil,
            type = 'miner',
            stack = 20,
            min = 20,
            max = 20
        },
        -- furnace
        ['stone-furnace'] = {
            key = 18,
            upgrade_of = nil,
            type = 'furnace',
            stack = 50,
            min = 0,
            max = 50
        },
        ['steel-furnace'] = {
            key = 19,
            upgrade_of = 'stone-furnace',
            type = 'furnace',
            stack = 50,
            min = 0,
            max = 50
        },
        ['electric-furnace'] = {
            key = 20,
            upgrade_of = 'steel-furnace',
            type = 'furnace',
            stack = 50,
            min = 50,
            max = 50
        },
        -- machine
        ['assembling-machine-1'] = {
            key = 28,
            upgrade_of = nil,
            type = 'machine',
            stack = 50,
            min = 50,
            max = 50
        },
        ['assembling-machine-2'] = {
            key = 29,
            upgrade_of = 'assembling-machine-1',
            type = 'machine',
            stack = 50,
            min = 50,
            max = 50
        },
        ['assembling-machine-3'] = {
            key = 30,
            upgrade_of = 'assembling-machine-2',
            type = 'machine',
            stack = 50,
            min = 50,
            max = 50
        },
        ['oil-refinery'] = {
            key = 24,
            upgrade_of = nil,
            type = 'machine',
            stack = 10,
            min = 10,
            max = 10
        },
        ['chemical-plant'] = {
            key = 25,
            upgrade_of = nil,
            type = 'machine',
            stack = 10,
            min = 10,
            max = 10
        },
        ['centrifuge'] = {
            key = 26,
            upgrade_of = nil,
            type = nil,
            stack = 50,
            min = 0,
            max = 0
        },
        ['lab'] = {
            key = 27,
            upgrade_of = nil,
            type = nil,
            stack = 10,
            min = 0,
            max = 0
        },
        ['nuclear-reactor'] = {
            key = 14,
            upgrade_of = nil,
            type = nil,
            stack = 10,
            min = 0,
            max = 0
        },
        ['heat-pipe'] = {
            key = 15,
            upgrade_of = nil,
            type = nil,
            stack = 50,
            min = 0,
            max = 0
        },
        ['heat-exchanger'] = {
            key = 16,
            upgrade_of = nil,
            type = nil,
            stack = 50,
            min = 0,
            max = 0
        },
        ['steam-turbine'] = {
            key = 17,
            upgrade_of = nil,
            type = nil,
            stack = 10,
            min = 0,
            max = 0
        },
        ['rocket-silo'] = {
            key = 80,
            upgrade_of = nil,
            type = nil,
            stack = 1,
            min = 0,
            max = 0
        },
        -- pole
        ['small-electric-pole'] = {
            key = 31,
            upgrade_of = nil,
            type = 'pole',
            stack = 50,
            min = 100,
            max = 100
        },
        ['medium-electric-pole'] = {
            key = 32,
            upgrade_of = 'small-electric-pole',
            type = 'pole',
            stack = 50,
            min = 100,
            max = 100
        },
        ['big-electric-pole'] = {
            key = 33,
            upgrade_of = nil,
            type = 'pole',
            stack = 50,
            min = 100,
            max = 100
        },
        ['substation'] = {
            key = 34,
            upgrade_of = nil,
            type = 'pole',
            stack = 50,
            min = 50,
            max = 50
        },
        -- bot
        ['roboport'] = {
            key = 35,
            upgrade_of = nil,
            type = 'bot',
            stack = 10,
            min = 20,
            max = 20
        },
        ['construction-robot'] = {
            key = 36,
            upgrade_of = nil,
            type = 'bot',
            stack = 50,
            min = 50,
            max = 50
        },
        ['logistic-robot'] = {
            key = 37,
            upgrade_of = nil,
            type = 'bot',
            stack = 50,
            min = 0,
            max = 0
        },
        ['cliff-explosives'] = {
            key = 38,
            upgrade_of = nil,
            type = 'bot',
            stack = 20,
            min = 80,
            max = 80
        },
        ['repair-pack'] = {
            key = 39,
            upgrade_of = nil,
            type = 'bot',
            stack = 100,
            min = 100,
            max = 100
        },
        ['landfill'] = {
            key = 40,
            upgrade_of = nil,
            type = 'bot',
            stack = 100,
            min = 300,
            max = 300
        },
        -- ore
        ['wood'] = {
            key = 151,
            upgrade_of = nil,
            type = nil,
            stack = 100,
            min = 0,
            max = 0
        },
        ['coal'] = {
            key = 152,
            upgrade_of = nil,
            type = nil,
            stack = 50,
            min = 0,
            max = 0
        },
        ['stone'] = {
            key = 153,
            upgrade_of = nil,
            type = nil,
            stack = 50,
            min = 0,
            max = 0
        },
        ['iron-ore'] = {
            key = 154,
            upgrade_of = nil,
            type = nil,
            stack = 50,
            min = 0,
            max = 0
        },
        ['copper-ore'] = {
            key = 155,
            upgrade_of = nil,
            type = nil,
            stack = 50,
            min = 0,
            max = 0
        },
        ['uranium-ore'] = {
            key = 156,
            upgrade_of = nil,
            type = nil,
            stack = 50,
            min = 0,
            max = 0
        },
        ['raw-fish'] = {
            key = 157,
            upgrade_of = nil,
            type = nil,
            stack = 100,
            min = 0,
            max = 0
        },
        ['iron-stick'] = {
            key = 158,
            upgrade_of = nil,
            type = nil,
            stack = 100,
            min = 0,
            max = 0
        },
        ['iron-gear-wheel'] = {
            key = 159,
            upgrade_of = nil,
            type = nil,
            stack = 100,
            min = 0,
            max = 0
        },
        ['satellite'] = {
            key = 160,
            upgrade_of = nil,
            type = nil,
            stack = 1,
            min = 0,
            max = 0
        },
        -- inserter
        ['burner-inserter'] = {
            key = 41,
            upgrade_of = nil,
            type = 'inserter',
            stack = 50,
            min = 0,
            max = 50
        },
        ['inserter'] = {
            key = 42,
            upgrade_of = 'burner-inserter',
            type = 'inserter',
            stack = 50,
            min = 50,
            max = 50
        },
        ['long-handed-inserter'] = {
            key = 43,
            upgrade_of = nil,
            type = 'inserter',
            stack = 50,
            min = 50,
            max = 50
        },
        ['fast-inserter'] = {
            key = 44,
            upgrade_of = 'inserter',
            type = 'inserter',
            stack = 50,
            min = 50,
            max = 50
        },
        ['filter-inserter'] = {
            key = 45,
            upgrade_of = nil,
            type = 'inserter',
            stack = 50,
            min = 50,
            max = 50
        },
        ['stack-inserter'] = {
            key = 46,
            upgrade_of = 'fast-inserter',
            type = 'inserter',
            stack = 50,
            min = 50,
            max = 50
        },
        ['stack-filter-inserter'] = {
            key = 47,
            upgrade_of = nil,
            type = 'inserter',
            stack = 50,
            min = 50,
            max = 50
        },
        -- pipe
        ['pipe'] = {
            key = 48,
            upgrade_of = nil,
            type = nil,
            stack = 100,
            min = 100,
            max = 100
        },
        ['pipe-to-ground'] = {
            key = 49,
            upgrade_of = nil,
            type = nil,
            stack = 50,
            min = 100,
            max = 100
        },
        ['pump'] = {
            key = 50,
            upgrade_of = nil,
            type = nil,
            stack = 50,
            min = 50,
            max = 50
        },
        ['storage-tank'] = {
            key = 59,
            upgrade_of = nil,
            type = nil,
            stack = 50,
            min = 50,
            max = 50
        },
        -- chest
        ['wooden-chest'] = {
            key = 51,
            upgrade_of = nil,
            type = 'chest',
            stack = 50,
            min = 0,
            max = 50
        },
        ['iron-chest'] = {
            key = 52,
            upgrade_of = 'wooden-chest',
            type = 'chest',
            stack = 50,
            min = 0,
            max = 50
        },
        ['steel-chest'] = {
            key = 53,
            upgrade_of = 'iron-chest',
            type = 'chest',
            stack = 50,
            min = 50,
            max = 50
        },
        ['logistic-chest-passive-provider'] = {
            key = 54,
            upgrade_of = nil,
            type = 'chest',
            stack = 50,
            min = 50,
            max = 50
        },
        ['logistic-chest-storage'] = {
            key = 55,
            upgrade_of = nil,
            type = 'chest',
            stack = 50,
            min = 50,
            max = 50
        },
        ['logistic-chest-requester'] = {
            key = 56,
            upgrade_of = nil,
            type = 'chest',
            stack = 50,
            min = 50,
            max = 50
        },
        ['logistic-chest-buffer'] = {
            key = 57,
            upgrade_of = nil,
            type = 'chest',
            stack = 50,
            min = 50,
            max = 50
        },
        ['logistic-chest-active-provider'] = {
            key = 58,
            upgrade_of = nil,
            type = 'chest',
            stack = 50,
            min = 50,
            max = 50
        },
        -- rail
        ['rail'] = {
            key = 61,
            upgrade_of = nil,
            type = 'rail',
            stack = 100,
            min = 1000,
            max = 1000
        },
        ['train-stop'] = {
            key = 62,
            upgrade_of = nil,
            type = 'rail',
            stack = 10,
            min = 10,
            max = 10
        },
        ['rail-signal'] = {
            key = 63,
            upgrade_of = nil,
            type = 'rail',
            stack = 50,
            min = 100,
            max = 100
        },
        ['rail-chain-signal'] = {
            key = 64,
            upgrade_of = nil,
            type = 'rail',
            stack = 50,
            min = 100,
            max = 100
        },
        ['locomotive'] = {
            key = 65,
            upgrade_of = nil,
            type = 'rail',
            stack = 5,
            min = 5,
            max = 5
        },
        ['cargo-wagon'] = {
            key = 66,
            upgrade_of = nil,
            type = 'rail',
            stack = 5,
            min = 10,
            max = 10
        },
        ['fluid-wagon'] = {
            key = 67,
            upgrade_of = nil,
            type = 'rail',
            stack = 5,
            min = 5,
            max = 5
        },
        ['artillery-wagon'] = {
            key = 68,
            upgrade_of = nil,
            type = 'rail',
            stack = 5,
            min = 0,
            max = 0
        },
        -- circuit
        ['constant-combinator'] = {
            key = 71,
            upgrade_of = nil,
            type = nil,
            stack = 50,
            min = 50,
            max = 50
        },
        ['arithmetic-combinator'] = {
            key = 72,
            upgrade_of = nil,
            type = nil,
            stack = 50,
            min = 50,
            max = 50
        },
        ['decider-combinator'] = {
            key = 73,
            upgrade_of = nil,
            type = nil,
            stack = 50,
            min = 50,
            max = 50
        },
        ['small-lamp'] = {
            key = 74,
            upgrade_of = nil,
            type = nil,
            stack = 50,
            min = 100,
            max = 100
        },
        ['red-wire'] = {
            key = 75,
            upgrade_of = nil,
            type = nil,
            stack = 200,
            min = 200,
            max = 200
        },
        ['green-wire'] = {
            key = 76,
            upgrade_of = nil,
            type = nil,
            stack = 200,
            min = 200,
            max = 200
        },
        ['copper-cable'] = {
            key = 77,
            upgrade_of = nil,
            type = nil,
            stack = 200,
            min = 200,
            max = 200
        },
        ['power-switch'] = {
            key = 78,
            upgrade_of = nil,
            type = nil,
            stack = 50,
            min = 50,
            max = 50
        },
        ['programmable-speaker'] = {
            key = 79,
            upgrade_of = nil,
            type = nil,
            stack = 50,
            min = 0,
            max = 0
        },
        ['offshore-pump'] = {
            key = 60,
            upgrade_of = nil,
            type = nil,
            stack = 20,
            min = 20,
            max = 20
        },
        -- module
        ['beacon'] = {
            key = 81,
            upgrade_of = nil,
            type = 'module',
            stack = 10,
            min = 20,
            max = 20
        },
        ['speed-module'] = {
            key = 82,
            upgrade_of = nil,
            type = 'module',
            stack = 50,
            min = 150,
            max = 150
        },
        ['speed-module-2'] = {
            key = 83,
            upgrade_of = 'speed-module',
            type = 'module',
            stack = 50,
            min = 0,
            max = 0
        },
        ['speed-module-3'] = {
            key = 84,
            upgrade_of = 'speed-module-2',
            type = 'module',
            stack = 50,
            min = 150,
            max = 150
        },
        ['productivity-module'] = {
            key = 85,
            upgrade_of = nil,
            type = 'module',
            stack = 50,
            min = 0,
            max = 0
        },
        ['productivity-module-2'] = {
            key = 86,
            upgrade_of = 'productivity-module',
            type = 'module',
            stack = 50,
            min = 0,
            max = 0
        },
        ['productivity-module-3'] = {
            key = 87,
            upgrade_of = 'productivity-module-2',
            type = 'module',
            stack = 50,
            min = 0,
            max = 0
        },
        ['effectivity-module'] = {
            key = 88,
            upgrade_of = nil,
            type = 'module',
            stack = 50,
            min = 0,
            max = 0
        },
        ['effectivity-module-2'] = {
            key = 89,
            upgrade_of = 'effectivity-module',
            type = 'module',
            stack = 50,
            min = 0,
            max = 0
        },
        ['effectivity-module-3'] = {
            key = 90,
            upgrade_of = 'effectivity-module-2',
            type = 'module',
            stack = 50,
            min = 0,
            max = 0
        },
        -- defense
        ['stone-wall'] = {
            key = 91,
            upgrade_of = nil,
            type = 'defense',
            stack = 100,
            min = 0,
            max = 0
        },
        ['gate'] = {
            key = 92,
            upgrade_of = nil,
            type = 'defense',
            stack = 50,
            min = 0,
            max = 0
        },
        ['gun-turret'] = {
            key = 93,
            upgrade_of = nil,
            type = 'defense',
            stack = 50,
            min = 0,
            max = 0
        },
        ['laser-turret'] = {
            key = 94,
            upgrade_of = nil,
            type = 'defense',
            stack = 50,
            min = 100,
            max = 100
        },
        ['flamethrower-turret'] = {
            key = 95,
            upgrade_of = nil,
            type = 'defense',
            stack = 50,
            min = 0,
            max = 0
        },
        ['artillery-turret'] = {
            key = 96,
            upgrade_of = nil,
            type = 'defense',
            stack = 10,
            min = 0,
            max = 0
        },
        -- rocket
        ['rocket'] = {
            key = 101,
            upgrade_of = nil,
            type = 'rocket',
            stack = 200,
            min = 0,
            max = 0
        },
        ['explosive-rocket'] = {
            key = 102,
            upgrade_of = 'rocket',
            type = 'rocket',
            stack = 200,
            min = 1000,
            max = 1000
        },
        ['atomic-bomb'] = {
            key = 103,
            upgrade_of = 'explosive-rocket',
            type = 'rocket',
            stack = 10,
            min = 50,
            max = 50
        },
        ['rocket-launcher'] = {
            key = 104,
            upgrade_of = nil,
            type = 'weapon',
            stack = 5,
            min = 1,
            max = 1
        },
        ['flamethrower'] = {
            key = 105,
            upgrade_of = nil,
            type = 'weapon',
            stack = 5,
            min = 0,
            max = 0
        },
        ['pistol'] = {
            key = 106,
            upgrade_of = nil,
            type = 'weapon',
            stack = 5,
            min = 0,
            max = 0
        },
        ['submachine-gun'] = {
            key = 107,
            upgrade_of = nil,
            type = 'weapon',
            stack = 5,
            min = 0,
            max = 0
        },
        ['shotgun'] = {
            key = 108,
            upgrade_of = nil,
            type = 'weapon',
            stack = 5,
            min = 0,
            max = 0
        },
        ['combat-shotgun'] = {
            key = 109,
            upgrade_of = nil,
            type = 'weapon',
            stack = 5,
            min = 0,
            max = 0
        },
        ['land-mine'] = {
            key = 110,
            upgrade_of = nil,
            type = nil,
            stack = 100,
            min = 0,
            max = 0
        },
        -- ammo
        ['firearm-magazine'] = {
            key = 111,
            upgrade_of = nil,
            type = 'ammo',
            stack = 200,
            min = 0,
            max = 0
        },
        ['piercing-rounds-magazine'] = {
            key = 112,
            upgrade_of = 'firearm-magazine',
            type = 'ammo',
            stack = 200,
            min = 0,
            max = 0
        },
        ['uranium-rounds-magazine'] = {
            key = 113,
            upgrade_of = 'piercing-rounds-magazine',
            type = 'ammo',
            stack = 200,
            min = 0,
            max = 0
        },
        ['flamethrower-ammo'] = {
            key = 114,
            upgrade_of = nil,
            type = 'ammo',
            stack = 100,
            min = 0,
            max = 0
        },
        ['shotgun-shell'] = {
            key = 115,
            upgrade_of = nil,
            type = 'ammo',
            stack = 200,
            min = 0,
            max = 0
        },
        ['piercing-shotgun-shell'] = {
            key = 116,
            upgrade_of = nil,
            type = 'ammo',
            stack = 200,
            min = 0,
            max = 0
        },
        ['cannon-shell'] = {
            key = 117,
            upgrade_of = nil,
            type = 'ammo',
            stack = 200,
            min = 0,
            max = 0
        },
        ['explosive-cannon-shell'] = {
            key = 118,
            upgrade_of = nil,
            type = 'ammo',
            stack = 200,
            min = 0,
            max = 0
        },
        ['uranium-cannon-shell'] = {
            key = 119,
            upgrade_of = nil,
            type = 'ammo',
            stack = 200,
            min = 0,
            max = 0
        },
        ['explosive-uranium-cannon-shell'] = {
            key = 120,
            upgrade_of = nil,
            type = 'ammo',
            stack = 200,
            min = 0,
            max = 0
        },
        ['grenade'] = {
            key = 97,
            upgrade_of = nil,
            type = 'ammo',
            stack = 100,
            min = 0,
            max = 0
        },
        ['cluster-grenade'] = {
            key = 98,
            upgrade_of = nil,
            type = 'ammo',
            stack = 100,
            min = 0,
            max = 0
        },
        ['artillery-shell'] = {
            key = 121,
            upgrade_of = nil,
            type = nil,
            stack = 1,
            min = 0,
            max = 0
        },
        ['poison-capsule'] = {
            key = 122,
            upgrade_of = nil,
            type = nil,
            stack = 100,
            min = 0,
            max = 0
        },
        ['slowdown-capsule'] = {
            key = 123,
            upgrade_of = nil,
            type = nil,
            stack = 100,
            min = 0,
            max = 0
        },
        ['defender-capsule'] = {
            key = 124,
            upgrade_of = nil,
            type = nil,
            stack = 100,
            min = 0,
            max = 0
        },
        ['distractor-capsule'] = {
            key = 125,
            upgrade_of = nil,
            type = nil,
            stack = 100,
            min = 0,
            max = 0
        },
        ['destroyer-capsule'] = {
            key = 126,
            upgrade_of = nil,
            type = nil,
            stack = 100,
            min = 0,
            max = 0
        },
        ['car'] = {
            key = 127,
            upgrade_of = nil,
            type = nil,
            stack = 1,
            min = 0,
            max = 0
        },
        ['tank'] = {
            key = 128,
            upgrade_of = nil,
            type = nil,
            stack = 1,
            min = 0,
            max = 0
        },
        ['spidertron'] = {
            key = 129,
            upgrade_of = nil,
            type = nil,
            stack = 1,
            min = 0,
            max = 0
        },
        ['spidertron-remote'] = {
            key = 130,
            upgrade_of = nil,
            type = nil,
            stack = 1,
            min = 0,
            max = 0
        },
        ['radar'] = {
            key = 99,
            upgrade_of = nil,
            type = nil,
            stack = 50,
            min = 50,
            max = 50
        },
        -- armor
        ['light-armor'] = {
            key = 131,
            upgrade_of = nil,
            type = 'armor',
            stack = 1,
            min = 0,
            max = 1
        },
        ['heavy-armor'] = {
            key = 132,
            upgrade_of = 'light-armor',
            type = 'armor',
            stack = 1,
            min = 0,
            max = 1
        },
        ['modular-armor'] = {
            key = 133,
            upgrade_of = 'heavy-armor',
            type = 'armor',
            stack = 1,
            min = 0,
            max = 1
        },
        ['power-armor'] = {
            key = 134,
            upgrade_of = 'modular-armor',
            type = 'armor',
            stack = 1,
            min = 0,
            max = 1
        },
        ['power-armor-mk2'] = {
            key = 135,
            upgrade_of = 'power-armor',
            type = 'armor',
            stack = 1,
            min = 0,
            max = 1
        },
        -- armor equipment
        ['solar-panel-equipment'] = {
            key = 136,
            upgrade_of = nil,
            type = 'armor_equipment',
            stack = 20,
            min = 0,
            max = 0
        },
        ['fusion-reactor-equipment'] = {
            key = 137,
            upgrade_of = 'solar-panel-equipment',
            type = 'armor_equipment',
            stack = 20,
            min = 0,
            max = 0
        },
        ['belt-immunity-equipment'] = {
            key = 138,
            upgrade_of = nil,
            type = 'armor_equipment',
            stack = 20,
            min = 0,
            max = 0
        },
        ['night-vision-equipment'] = {
            key = 139,
            upgrade_of = nil,
            type = 'armor_equipment',
            stack = 20,
            min = 0,
            max = 0
        },
        ['personal-laser-defense-equipment'] = {
            key = 140,
            upgrade_of = nil,
            type = 'armor_equipment',
            stack = 20,
            min = 0,
            max = 0
        },
        ['personal-roboport-equipment'] = {
            key = 141,
            upgrade_of = nil,
            type = 'armor_equipment',
            stack = 20,
            min = 0,
            max = 0
        },
        ['personal-roboport-mk2-equipment'] = {
            key = 142,
            upgrade_of = 'personal-roboport-equipment',
            type = 'armor_equipment',
            stack = 20,
            min = 0,
            max = 0
        },
        ['energy-shield-equipment'] = {
            key = 143,
            upgrade_of = nil,
            type = 'armor_equipment',
            stack = 20,
            min = 0,
            max = 0
        },
        ['energy-shield-mk2-equipment'] = {
            key = 144,
            upgrade_of = 'energy-shield-equipment',
            type = 'armor_equipment',
            stack = 20,
            min = 0,
            max = 0
        },
        ['battery-equipment'] = {
            key = 145,
            upgrade_of = nil,
            type = 'armor_equipment',
            stack = 20,
            min = 0,
            max = 0
        },
        ['battery-mk2-equipment'] = {
            key = 146,
            upgrade_of = 'battery-equipment',
            type = 'armor_equipment',
            stack = 20,
            min = 0,
            max = 0
        },
        ['exoskeleton-equipment'] = {
            key = 147,
            upgrade_of = nil,
            type = 'armor_equipment',
            stack = 20,
            min = 0,
            max = 0
        },
        ['discharge-defense-equipment'] = {
            key = 148,
            upgrade_of = nil,
            type = 'armor_equipment',
            stack = 20,
            min = 0,
            max = 0
        },
        ['discharge-defense-remote'] = {
            key = 149,
            upgrade_of = nil,
            type = nil,
            stack = 1,
            min = 0,
            max = 0
        },
        ['artillery-targeting-remote'] = {
            key = 150,
            upgrade_of = nil,
            type = nil,
            stack = 1,
            min = 1,
            max = 1
        },
        -- path
        ['stone-brick'] = {
            key = 100,
            upgrade_of = nil,
            type = nil,
            stack = 100,
            min = 0,
            max = 0
        },
        ['concrete'] = {
            key = 69,
            upgrade_of = nil,
            type = nil,
            stack = 100,
            min = 0,
            max = 0
        },
        ['hazard-concrete'] = {
            key = 70,
            upgrade_of = nil,
            type = nil,
            stack = 100,
            min = 0,
            max = 0
        },
        ['refined-concrete'] = {
            key = 188,
            upgrade_of = nil,
            type = nil,
            stack = 100,
            min = 0,
            max = 0
        },
        ['refined-hazard-concrete'] = {
            key = 189,
            upgrade_of = nil,
            type = nil,
            stack = 100,
            min = 0,
            max = 0
        },
        ['crude-oil-barrel'] = {
            key = 161,
            upgrade_of = nil,
            type = nil,
            stack = 10,
            min = 0,
            max = 0
        },
        ['heavy-oil-barrel'] = {
            key = 162,
            upgrade_of = nil,
            type = nil,
            stack = 10,
            min = 0,
            max = 0
        },
        ['light-oil-barrel'] = {
            key = 163,
            upgrade_of = nil,
            type = nil,
            stack = 10,
            min = 0,
            max = 0
        },
        ['lubricant-barrel'] = {
            key = 164,
            upgrade_of = nil,
            type = nil,
            stack = 10,
            min = 0,
            max = 0
        },
        ['petroleum-gas-barrel'] = {
            key = 165,
            upgrade_of = nil,
            type = nil,
            stack = 10,
            min = 0,
            max = 0
        },
        ['sulfuric-acid-barrel'] = {
            key = 166,
            upgrade_of = nil,
            type = nil,
            stack = 10,
            min = 0,
            max = 0
        },
        ['water-barrel'] = {
            key = 167,
            upgrade_of = nil,
            type = nil,
            stack = 10,
            min = 0,
            max = 0
        },
        ['empty-barrel'] = {
            key = 168,
            upgrade_of = nil,
            type = nil,
            stack = 10,
            min = 0,
            max = 0
        },
        ['uranium-fuel-cell'] = {
            key = 169,
            upgrade_of = nil,
            type = nil,
            stack = 50,
            min = 0,
            max = 0
        },
        ['used-up-uranium-fuel-cell'] = {
            key = 170,
            upgrade_of = nil,
            type = nil,
            stack = 50,
            min = 0,
            max = 0
        },
        -- science and circuit
        ['automation-science-pack'] = {
            key = 171,
            upgrade_of = nil,
            type = nil,
            stack = 200,
            min = 0,
            max = 0
        },
        ['logistic-science-pack'] = {
            key = 172,
            upgrade_of = nil,
            type = nil,
            stack = 200,
            min = 0,
            max = 0
        },
        ['military-science-pack'] = {
            key = 173,
            upgrade_of = nil,
            type = nil,
            stack = 200,
            min = 0,
            max = 0
        },
        ['chemical-science-pack'] = {
            key = 174,
            upgrade_of = nil,
            type = nil,
            stack = 200,
            min = 0,
            max = 0
        },
        ['production-science-pack'] = {
            key = 175,
            upgrade_of = nil,
            type = nil,
            stack = 200,
            min = 0,
            max = 0
        },
        ['utility-science-pack'] = {
            key = 176,
            upgrade_of = nil,
            type = nil,
            stack = 200,
            min = 0,
            max = 0
        },
        ['space-science-pack'] = {
            key = 177,
            upgrade_of = nil,
            type = nil,
            stack = 2000,
            min = 0,
            max = 0
        },
        ['electronic-circuit'] = {
            key = 178,
            upgrade_of = nil,
            type = nil,
            stack = 200,
            min = 0,
            max = 0
        },
        ['advanced-circuit'] = {
            key = 179,
            upgrade_of = nil,
            type = nil,
            stack = 200,
            min = 0,
            max = 0
        },
        ['processing-unit'] = {
            key = 180,
            upgrade_of = nil,
            type = nil,
            stack = 100,
            min = 0,
            max = 0
        },
        -- intermediate
        ['iron-plate'] = {
            key = 181,
            upgrade_of = nil,
            type = nil,
            stack = 100,
            min = 0,
            max = 0
        },
        ['copper-plate'] = {
            key = 182,
            upgrade_of = nil,
            type = nil,
            stack = 100,
            min = 0,
            max = 0
        },
        ['steel-plate'] = {
            key = 183,
            upgrade_of = nil,
            type = nil,
            stack = 100,
            min = 0,
            max = 0
        },
        ['plastic-bar'] = {
            key = 184,
            upgrade_of = nil,
            type = nil,
            stack = 100,
            min = 0,
            max = 0
        },
        ['sulfur'] = {
            key = 185,
            upgrade_of = nil,
            type = nil,
            stack = 50,
            min = 0,
            max = 0
        },
        ['battery'] = {
            key = 186,
            upgrade_of = nil,
            type = nil,
            stack = 200,
            min = 0,
            max = 0
        },
        ['explosives'] = {
            key = 187,
            upgrade_of = nil,
            type = nil,
            stack = 50,
            min = 0,
            max = 0
        },
        ['engine-unit'] = {
            key = 191,
            upgrade_of = nil,
            type = nil,
            stack = 50,
            min = 0,
            max = 0
        },
        ['electric-engine-unit'] = {
            key = 192,
            upgrade_of = nil,
            type = nil,
            stack = 50,
            min = 0,
            max = 0
        },
        ['flying-robot-frame'] = {
            key = 193,
            upgrade_of = nil,
            type = nil,
            stack = 50,
            min = 0,
            max = 0
        },
        ['rocket-control-unit'] = {
            key = 194,
            upgrade_of = nil,
            type = nil,
            stack = 10,
            min = 0,
            max = 0
        },
        ['low-density-structure'] = {
            key = 195,
            upgrade_of = nil,
            type = nil,
            stack = 10,
            min = 0,
            max = 0
        },
        ['solid-fuel'] = {
            key = 196,
            upgrade_of = nil,
            type = nil,
            stack = 50,
            min = 0,
            max = 0
        },
        ['rocket-fuel'] = {
            key = 197,
            upgrade_of = nil,
            type = nil,
            stack = 10,
            min = 0,
            max = 0
        },
        ['nuclear-fuel'] = {
            key = 198,
            upgrade_of = nil,
            type = nil,
            stack = 1,
            min = 0,
            max = 0
        },
        ['uranium-235'] = {
            key = 199,
            upgrade_of = nil,
            type = nil,
            stack = 100,
            min = 0,
            max = 0
        },
        ['uranium-238'] = {
            key = 200,
            upgrade_of = nil,
            type = nil,
            stack = 100,
            min = 0,
            max = 0
        }
    }
}