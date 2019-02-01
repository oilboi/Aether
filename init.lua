local minbiomey = 250
local maxbiomey = 1000
minetest.register_on_generated(function(minp, maxp, blockseed)
  --120 bottom of clouds

  if minp.y >= minbiomey and maxp.y <= maxbiomey then

    --the () is the line in api doc
    --1 seed (2565) 2 octaves (2580) 3 persistance (2596) scale (2524)
    local perlin = PerlinNoise(blockseed, 3, 1, 100) --3,10,50 for crazy caves -- 3, 1, 100 for floating islands




		local height = snowrange_height
		local air = minetest.get_content_id("air")
		local dirt = minetest.get_content_id("default:dirt")
    local stone = minetest.get_content_id("aether:heavenly_stone")
		local water = minetest.get_content_id("default:water_source")
    local diamond = minetest.get_content_id("default:diamondblock")
    local grass = minetest.get_content_id("aether:celestial_grass")

		local min = minp
		local max = {x=maxp.x,y=maxp.y+1,z=maxp.z}
		local vm = minetest.get_voxel_manip()
		local emin, emax = vm:read_from_map(min,max)
		local area = VoxelArea:new{MinEdge=emin, MaxEdge=emax}
		local data = vm:get_data()
		local content_id = minetest.get_name_from_content_id

		for x=minp.x, maxp.x do
		for y=minp.y, maxp.y do
		for z=minp.z, maxp.z do
				local p_pos = area:index(x,y,z)
        local p_pos_above = area:index(x,y+1,z)
        local p_pos_below = area:index(x,y-1,z)
        if perlin:get3d({x=x,y=y,z=z}) > 0.8 then
          --print(tester)
				  data[p_pos] = stone --this makes the snow adapt to the environment
          data[p_pos_above] =grass -- diamond grass
      --  elseif p_pos_below and content_id(p_pos_below) == "aether:heavenly_stone" then
        --    data[p_pos] = grass
        end
		end
		end
		end


		vm:set_data(data)
		vm:write_to_map()

  end

end)
minetest.register_decoration({
	deco_type = "simple",
	place_on = "aether:heavenly_stone",
	--sidelen = 8,
	fill_ratio = 10,
	--biomes = {"grassland"},
	decoration = "default:dirt_with_grass",
  y_min = -31000,
  y_max = 31000,
  height = 1,
  --flags = "force_placement",
})
minetest.register_node("aether:heavenly_stone", {
	description = "Heavenly Stone",
	tiles = {"default_stone.png^[colorize:#00bfff:100"},
	groups = {cracky = 3, stone = 1},
	drop = "aether:heavenly_stone",
	legacy_mineral = true,
	sounds = default.node_sound_stone_defaults(),
})
minetest.register_node("aether:celestial_grass", {
	description = "Celestial Grass",
	tiles = {"default_grass.png^[colorize:#00bfff:100", "default_dirt.png^[colorize:#00bfff:100",
		{name = "default_dirt.png^default_grass_side.png^[colorize:#00bfff:100",
			tileable_vertical = false}},
	groups = {crumbly = 3, soil = 1, spreading_dirt_type = 1},
	drop = "aether:celestial_grass",
	sounds = default.node_sound_dirt_defaults({
		footstep = {name = "default_grass_footstep", gain = 0.25},
	}),
})
