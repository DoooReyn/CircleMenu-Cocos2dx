---------------------------------------------
-- Author: DoooReyn
-- Date: 2016-06-28
-- Comment: 圆形菜单 Circle Menu
-- GitHub: https://github.com/DoooReyn
---------------------------------------------

local CircleMenu = class('CircleMenu', ccui.Button)
local isShowContainNodes = false
local ContainNodes = nil

-- radian:弧度， radius:半径
function CircleMenu:ctor (radian, radius, nodes)
    isShowContainNodes = false
    -- In fact, it is much better to take 'self._containNodes' 
    -- as a local variable.
    ContainNodes = {} 
    self:initInitialButton()
    self:setInitialRadius(radius)
    self:setInitialRadian(radian)
    self:setInitialContainNodes(nodes)
end

function CircleMenu:setInitialRadius(radius)
    -- 128 is a custom number as default, you can set any number.
    radius = radius or 128 
    self._radius = radius
end

function CircleMenu:setInitialContainNodes(nodes)
    if not nodes or type(nodes) ~= 'table' then
        return
    end
    for i=1, #nodes do
        self:addSubItem(nodes[i])
    end
end

function CircleMenu:setInitialRadian(radian)
    local from, to = radian.from, radian.to
    if not from or not to then
        randian = {from=0, to=180}
    end
    -- 'from < to' is required, so if 'from > to', then we 
    -- need to swap them.
    if from > to then
         radian.from, radian.to = to, from
    end
    self._radian = radian
end

function CircleMenu:addSubItem(node)
    ContainNodes[#ContainNodes+1] = node
    node:setAnchorPoint(cc.p(0.5, 0.5))
    self:addChild(node)
end

-- This function should be called by youself after adding items done.
function CircleMenu:doLayout()
    local radius     = self._radius
    local from, to   = self._radian.from, self._radian.to
    local radianSpan = math.min(to - from, 360)
    local nodeCount  = #ContainNodes
    local divident   = (radianSpan == 360 or nodeCount == 1) and nodeCount or (nodeCount - 1)
    local nodePiece  = radianSpan / divident
    local menuSize   = self:getContentSize() 
    local menuScale  = self:getScale()
    local centerP    = cc.p(menuSize.width * 0.5 * menuScale , menuSize.height * 0.5 * menuScale)
    local piRadian   = math.pi / 180

    local function calNodePositionOnRound(i)
        local nodeRadian= nodePiece * (i - 1) + from
        local nodeAngle = nodeRadian * piRadian
        local px, py = math.cos(nodeAngle),  math.sin(nodeAngle)
        local rx, ry = centerP.x + radius * px, centerP.y + radius * py
        return cc.p(rx, ry)
    end

    local function doLayoutOnRound()
        for i=1, nodeCount do
            local node  = ContainNodes[i]
            local nodeP = calNodePositionOnRound(i)
            node:setPosition(nodeP)
        end
    end

    doLayoutOnRound()

    self:eventButtonAnimation(isShowContainNodes)
end

function CircleMenu:initInitialButton()
    local function btnTouchEvent(sender,touchType)
        sender:touchDownEffect(touchType)
        if touchType == ccui.TouchEventType.ended then
            isShowContainNodes = not isShowContainNodes
            self:eventButtonAnimation(isShowContainNodes)
        end
    end
    self:addTouchEventListener(btnTouchEvent)
end

function CircleMenu:eventButtonAnimation(show)
    if show then
        self:animateShow()
    else
        self:animateHide()
    end
end

function CircleMenu:animateShow()
    print('====> show')
    -- 注释 : 可以在这里自定义菜单弹出动画
    -- comment : Add custom animation to pop up the menu here
    for i,v in ipairs(ContainNodes) do
        v:setVisible(true)
    end
end

function CircleMenu:animateHide()
    print('====> hide')
    -- 注释 : 可以在这里自定义菜单收起动画
    -- comment: Add custom animation to pack up the menu here
    for i,v in ipairs(ContainNodes) do
        v:setVisible(false)
    end
end

return CircleMenu
