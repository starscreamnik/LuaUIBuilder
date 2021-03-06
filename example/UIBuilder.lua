UIBuilder = {}
UIBuilder.__index = UIBuilder

function UIBuilder:new(grp)
    local self = {
        c = {
            tags = {}
        }
    }
    setmetatable(self, UIBuilder)
    self:setRoot(grp)

    return self
end

function UIBuilder:setRoot(grp)
    if not grp or not grp.removeSelf then
        error("Invalid root container", 2)
    end
    self.c.root = grp
    self.c.currObj = grp
    return self
end

function UIBuilder:setTag(tag)
    if not self.c.root then
        error("Chain has no root object", 2)
    end
    if type(tag)~="string" then
        error("Invalid object tag", 2)
    end
    self.c.tags[tag] = self.c.currObj
    return self
end

function UIBuilder:inject(view, params)
    if not self.c.root then
        error("Chain has no root object", 2)
    end
    if not view.new then
        error("Invalid View", 2)
    end
    view.new(self, params)
    return self
end

function UIBuilder:gotoObject(tag)
    if type(tag)~="string" then
        error("Invalid tag", 2)
    end
    if not self.c.tags[tag] then
        error("Object doesn't exist", 2)
    end
    self.c.currObj = self.c.tags[tag]
    return self
end

function UIBuilder:jumpTo(obj)
    if not obj or not obj.removeSelf then
        error("Invalid object", 2)
    end
    self.c.currObj = obj
    return self
end

function UIBuilder:gotoRoot()
    if not self.c.root then
        error("Chain has no root object", 2)
    end
    self.c.currObj = self.c.root
    return self
end

function UIBuilder:removeChildren()
    if not self.c.root then
        error("Chain has no root object", 2)
    end
    if not self.c.currObj.numChildren then
        error("Invalid object. Only Display Groups can contain children", 2)
    end
    while (self.c.currObj.numChildren > 0) do
        self.c.currObj[1]:removeSelf()
    end
    return self
end

function UIBuilder:addGroup()
    if not self.c.root then
        error("Chain has no root object", 2)
    end
    local grp = display.newGroup()
    self.c.currObj:insert(grp)
    self.c.currObj = grp
    return self
end

function UIBuilder:addImage(path, dir)
    if not self.c.root then
        error("Chain has no root object", 2)
    end
    local img = display.newImage(path, dir)
    if not img then
        error("Image not found", 2)
    end
    self.c.currObj:insert(img)
    self.c.currObj = img
    return self
end

function UIBuilder:addText(text, font, size, width, height, align)
    if not self.c.root then
        error("Chain has no root object", 2)
    end
    if not text or (type(text)~="string" and type(text)~="number") then
        error("Invalid text", 2)
    end
    local txt = display.newText({
        text = text,
        x = 0,
        y = 0,
        width = width,
        height = height,
        font = font,
        fontSize = size,
        align = align
    })
    self.c.currObj:insert(txt)
    self.c.currObj = txt
    return self
end

function UIBuilder:add(obj)
    if not self.c.root then
        error("Chain has no root object", 2)
    end
    if not obj or not obj.removeSelf then
        error("Invalid object", 2)
    end
    
    self.c.currObj:insert(obj)
    self.c.currObj = obj
    return self
end

function UIBuilder:addRect(width, height)
    if not self.c.root then
        error("Chain has no root object", 2)
    end
    if not width or not height then
        error("Invalid width or height", 2)
    end
    local rect = display.newRect(0,0,width, height)
    self.c.currObj:insert(rect)
    self.c.currObj = rect
    return self
end

function UIBuilder:onTap(action)
    if not self.c.root then
        error("Chain has no root object", 2)
    end
    if not action or type(action)~="function" then
        error("Invalid action", 2)
    end
    self.c.currObj:addEventListener("tap", action)
    return self
end

function UIBuilder:strokeWidth(value)
    if not self.c.root then
        error("Chain has no root object", 2)
    end
    self.c.currObj.strokeWidth = value
    return self
end

function UIBuilder:strokeColor(r, g, b, a)
    if not self.c.root then
        error("Chain has no root object", 2)
    end
    self.c.currObj:setStrokeColor( r, g ,b, a )
    return self
end

function UIBuilder:isVisible(flag)
    if not self.c.root then
        error("Chain has no root object", 2)
    end
    self.c.currObj.isVisible = flag
    return self
end

function UIBuilder:strokeColorRGB(color, alpha)
    if not self.c.root then
        error("Chain has no root object", 2)
    end
    local color_obj = self:getRGBcolor(color)
    color_obj[4] = alpha
    self.c.currObj:setStrokeColor(unpack(color_obj))
    return self
end

function UIBuilder:addCircle(radius)
    if not self.c.root then
        error("Chain has no root object", 2)
    end
    local circle = display.newCircle(0,0,radius)
    self.c.currObj:insert(circle)
    self.c.currObj = circle
    return self
end

function UIBuilder:addLine(points)
    if not self.c.root then
        error("Chain has no root object", 2)
    end
    local line = display.newLine(unpack(points))
    self.c.currObj:insert(line)
    self.c.currObj = line
    return self
end

function UIBuilder:addRoundedRect(width, height, radius)
    if not self.c.root then
        error("Chain has no root object", 2)
    end
    local rect = display.newRoundedRect(0,0,width, height, radius)
    self.c.currObj:insert(rect)
    self.c.currObj = rect
    return self
end

function UIBuilder:anchor(x, y)
    if not self.c.root then
        error("Chain has no root object", 2)
    end
    self.c.currObj.anchorX = x
    self.c.currObj.anchorY = y
    return self
end

function UIBuilder:fitTextX(sizeX)
    if not self.c.root then
        error("Chain has no root object", 2)
    end
    while self.c.currObj.contentWidth>sizeX do
        self.c.currObj.size = self.c.currObj.size-1
    end
    return self
end

function UIBuilder:fitXY(sizeX, sizeY)
    if not self.c.root then
        error("Chain has no root object", 2)
    end
    local ratio = self.c.currObj.contentWidth/self.c.currObj.contentHeight
    local new_width = math.min(sizeX, sizeY*ratio)
    local new_scale = new_width/self.c.currObj.contentWidth
    self.c.currObj.xScale = new_scale
    self.c.currObj.yScale = new_scale
    return self
end

function UIBuilder:fitX(size)
    if not self.c.root then
        error("Chain has no root object", 2)
    end
    self.c.currObj.xScale = size/self.c.currObj.contentWidth
    self.c.currObj.yScale = self.c.currObj.xScale
    return self
end

function UIBuilder:fitY(size)
    if not self.c.root then
        error("Chain has no root object", 2)
    end
    self.c.currObj.yScale = size/self.c.currObj.contentHeight
    self.c.currObj.xScale = self.c.currObj.yScale
    return self
end

function UIBuilder:rotation(angle)
    if not self.c.root then
        error("Chain has no root object", 2)
    end
    self.c.currObj.rotation = angle
    return self
end

function UIBuilder:fillColor(r,g,b,a)
    if not self.c.root then
        error("Chain has no root object", 2)
    end
    self.c.currObj:setFillColor(r,g,b,a)
    return self
end

function UIBuilder:fillColorRGB(color, alpha)
    if not self.c.root then
        error("Chain has no root object", 2)
    end
    local color_obj = self:getRGBcolor(color)
    color_obj[4] = alpha
    self.c.currObj:setFillColor(unpack(color_obj))
    return self
end

function UIBuilder:textColorRGB(color,alpha)
    if not self.c.root then
        error("Chain has no root object", 2)
    end
    local color_obj = self:getRGBcolor(color)
    color_obj[4] = alpha
    self.c.currObj:setTextColor(unpack(color_obj))
    return self
end

function UIBuilder:text(text)
    if not self.c.root then
        error("Chain has no root object", 2)
    end
    if not text or (type(text)~="string" and type(text)~="number") then
        error("Invalid text", 2)
    end
    self.c.currObj.text = text
    return self
end

function UIBuilder:textColor(r,g,b,a)
    if not self.c.root then
        error("Chain has no root object", 2)
    end
    self.c.currObj:setTextColor(r,g,b,a)
    return self
end

function UIBuilder:gotoParent()
    if not self.c.root then
        error("Chain has no root object", 2)
    end
    if self.c.currObj==self.c.root then
        error("Pointer can't go behind root object", 2)
    end
    self.c.currObj = self.c.currObj.parent
    return self
end

function UIBuilder:fill(paint)
    if not self.c.root then
        error("Chain has no root object", 2)
    end
    self.c.currObj.fill = paint
    return self
end

function UIBuilder:stroke(paint)
    if not self.c.root then 
        error("Chain has no root object", 2)
    end
    self.c.currObj.stroke = paint
    return self
end

function UIBuilder:position(x,y)
    if not self.c.root then
        error("Chain has no root object", 2)
    end
    self.c.currObj.x = x
    self.c.currObj.y = y
    return self
end

function UIBuilder:alpha(value)
    if not self.c.root then
        error("Chain has no root object", 2)
    end
    self.c.currObj.alpha = value
    return self
end

function UIBuilder:scale(scale)
    if not self.c.root then
        error("Chain has no root object", 2)
    end
    self.c.currObj.xScale = scale
    self.c.currObj.yScale = scale
    return self
end

function UIBuilder:scaleX(scale)
    if not self.c.root then
        error("Chain has no root object", 2)
    end
    self.c.currObj.xScale = scale
    return self
end

function UIBuilder:scaleY(scale)
    if not self.c.root then
        error("Chain has no root object", 2)
    end
    self.c.currObj.yScale = scale
    return self
end

function UIBuilder:textSize(value)
    if not self.c.root then
        error("Chain has no root object", 2)
    end
    self.c.currObj.size = value
    return self
end

function UIBuilder:setObject(obj)
    if not self.c.root then
        error("Chain has no root object", 2)
    end
    self.c.currObj = obj
    return self
end

function UIBuilder:trimText(width)
    if not self.c.root then
        error("Chain has no root object", 2)
    end
    if self.c.currObj.contentWidth>width then
        local text = self.c.currObj.text
        local trigs = 0
        while self.c.currObj.contentWidth>width and trigs<20000 do
            trigs=trigs+1
            text = string.sub(text, 1, -2)
            self.c.currObj.text = text.."..."
        end
    end
    return self
end

function UIBuilder:getCurrentObject()
    return self.c.currObj
end

function UIBuilder:getObjectByTag(tag)
    return self.c.tags[tag]
end

function UIBuilder:HEXtoDEC(hex)
    hex = string.upper( hex )
    local dec = 0
    for i=1,#hex do
        local byte = string.byte( hex, #hex-i+1 )
        if byte>=string.byte( "A", 1 ) then
            byte = byte - string.byte( "A", 1 ) + 10
        else
            byte = byte - string.byte( "0", 1 )
        end
        dec = dec+byte*math.pow(16, i-1)
    end
    return dec
end

function UIBuilder:getRGBcolor(color)
    color = color or ""
    local offset = 0
    if string.sub(color, 1, 2)=="0x" then
        offset = 2
    elseif string.sub(color, 1, 1)=="#" then
        offset = 1
    else
        return {0,0,0}
    end
    if #color-offset~=6 then
        return {0,0,0}
    end
    local hex_r = string.sub(color, offset+1, offset+2)
    local hex_g = string.sub(color, offset+3, offset+4)
    local hex_b  = string.sub(color, offset+5, offset+6)
    local r = self:HEXtoDEC(hex_r)/255
    local g = self:HEXtoDEC(hex_g)/255
    local b = self:HEXtoDEC(hex_b)/255
    return {r,g,b}
end

return UIBuilder