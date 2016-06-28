---- testcase ----
local CircleMenu = require('CircleMenu')

local path = 'res/%s.png' -- set your test image file path here
local item = {'test','test','test','test','test','test'} -- add six same images 
local function imagize(name)
    return string.format(path, name)
end

local nodes = {}
for i,component in ipairs(item) do
  local path = imagize(component)
	local node = ccui.ImageView:create(path)
	node:setTag(i)
      node:setName(component)
	nodes[#nodes+1] = node
end

local menu = CircleMenu.new({from=-45, to=135}, 120)
menu:loadTextures(imagize('menuNormal'), imagize('menuPressed'), '')
menu:setInitialContainNodes(nodes)
menu:doLayout()
menu:setPosition(320, 740)

---- try to add menu to some target ----
-- target:addChild(menu)
