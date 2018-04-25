--UI rapid builder
module(..., package.seeall);

function new()
  local this = {c={tags={}, allowed=true}}

  function this:setRoot(grp)
    if self.c.allowed then
        self.c.root = grp
        self.c.currObj = grp
    end
    return self
  end

  function this:setTag(tag)
    if self.c.allowed then
        self.c.tags[tag] = self.c.currObj
    end
    return self
  end

  function this:gotoObject(tag)
    if self.c.allowed then
        self.c.currObj = self.c.tags[tag]
    end
    return self
  end

  function this:gotoRoot()
     if self.c.allowed then
        self.c.currObj = self.c.root
    end
    return self
  end

  function this:removeChildren()
    if self.c.allowed then
    	while (self.c.currObj.numChildren>0) do
    		self.c.currObj[1]:removeSelf()
    	end
    end
	return self
  end

  function this:addGroup()
    if self.c.allowed then
        local grp = display.newGroup()
        self.c.currObj:insert(grp)
        self.c.currObj = grp
    end
    return self
  end

  function this:addImage(path)
    if self.c.allowed then
        local img = display.newImage(path)
        self.c.currObj:insert(img)
        self.c.currObj = img
    end
    return self
  end

  function this:addText(text, font, size, width, height, align)
    if self.c.allowed then
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
    end
	return self
  end

  function this:add(obj)
    if self.c.allowed then
    	self.c.currObj:insert(obj)
    	self.c.currObj = obj
    end
	return self
  end

  function this:iftrue(condition)
     self.c.allowed = condition
     return self
  end

  function this:endif()
      self.c.allowed = true
      return self
  end

  function this:addRect(width, height)
    if self.c.allowed then
    	local rect = display.newRect(0,0,width, height)
    	self.c.currObj:insert(rect)
    	self.c.currObj = rect
    end
	return self
  end

  function this:addCircle(radius)
    if self.c.allowed then
    	local circle = display.newCircle(0,0,radius)
    	self.c.currObj:insert(circle)
    	self.c.currObj = circle
    end
	return self
  end

  function this:addRoundedRect(width, height, radius)
    if self.c.allowed then
    	local rect = display.newRoundedRect(0,0,width, height, radius)
    	self.c.currObj:insert(rect)
    	self.c.currObj = rect
    end
	return self
  end

  function this:anchor(x, y)
    if self.c.allowed then
    	self.c.currObj.anchorX = x
    	self.c.currObj.anchorY = y
    end
	return self
  end

  function this:fitTextX(sizeX)
      if self.c.allowed then
          while self.c.currObj.contentWidth>sizeX do
              self.c.currObj.size = self.c.currObj.size-1
          end
      end
      return self
  end

  function this:fitXY(sizeX, sizeY)
    if self.c.allowed then
        local ratio = self.c.currObj.contentWidth/self.c.currObj.contentHeight
        local new_width = math.min(sizeX, sizeY*ratio)
        local new_scale = new_width/self.c.currObj.contentWidth
    	self.c.currObj.xScale = new_scale
    	self.c.currObj.yScale = new_scale
    end
	return self
  end

  function this:fitX(size)
    if self.c.allowed then
    	self.c.currObj.xScale = size/self.c.currObj.contentWidth
    	self.c.currObj.yScale = self.c.currObj.xScale
    end
	return self
  end

  function this:fitY(size)
    if self.c.allowed then
    	self.c.currObj.yScale = size/self.c.currObj.contentHeight
    	self.c.currObj.xScale = self.c.currObj.yScale
    end
	return self
  end

  function this:fillColor(r,g,b,a)
    if self.c.allowed then
    	self.c.currObj:setFillColor(r,g,b,a)
    end
	return self
  end

  function this:fillColorRGB(color, alpha)
    if self.c.allowed then
        local color_obj = self.c:getRGBcolor(color)
    	self.c.currObj:setFillColor(color_obj[1],color_obj[2],color_obj[3],alpha)
    end
	return self
  end

  function this:textColorRGB(color,alpha)
    if self.c.allowed then
        local color_obj = self.c:getRGBcolor(color)
    	self.c.currObj:setTextColor(color_obj[1],color_obj[2],color_obj[3],alpha)
    end
	return self
  end

  function this:textColor(r,g,b,a)
    if self.c.allowed then
    	self.c.currObj:setTextColor(r,g,b,a)
    end
	return self
  end

  function this:gotoParent()
    if self.c.allowed then
    	self.c.currObj = self.c.currObj.parent
    end
	return self
  end

  function this:fill(paint)
    if self.c.allowed then
	    self.c.currObj.fill = paint
    end
	return self
  end


  function this:position(x,y)
    if self.c.allowed then
        self.c.currObj.x = x
        self.c.currObj.y = y
    end
    return self
  end

  function this:alpha(value)
    if self.c.allowed then
       self.c.currObj.alpha = value
    end
	return self
  end

  function this:scale(scale)
    if self.c.allowed then
		self.c.currObj.xScale = scale
		self.c.currObj.yScale = scale
    end
    return self
  end

  function this:scaleX(scale)
    if self.c.allowed then
	    self.c.currObj.xScale = scale
    end
    return self
  end

  function this:scaleY(scale)
    if self.c.allowed then
        self.c.currObj.yScale = scale
    end
    return self
  end

  function this:getCurentObject()
	return self.c.currObj
  end

  function this:getObjectByTag(tag)
	return self.c.tags[tag]
end

function this.c:HEXtoDEC(hex)
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

  function this.c:getRGBcolor(color)
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

  return this
end
