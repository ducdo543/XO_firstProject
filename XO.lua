XO = Class{}

function XO:init(X_play)
    self.x_play = X_play
    self.x = 0
    self.y = 0
end

function XO:update(dt)
    self.x = (math.floor((X - 112) / (288/(a-1)) + 1)) * (288/(a-1)) - (144/(a-1)) + 112
    self.y = (math.floor(Y / (288/(a-1)) + 1)) * (288/(a-1)) - (144/(a-1))
    
end

function XO:render()
    love.graphics.setFont(love.graphics.newFont(192/(a-1)))
    if self.x_play == true then
        love.graphics.print("X", self.x - 64/(a-1), self.y - 96/(a-1))
    else
        love.graphics.print("O", self.x - 64/(a-1), self.y - 96/(a-1))
    end
end

function XO:render_fill()
    love.graphics.setColor(0,1,0)
    love.graphics.rectangle("fill", self.x-144/(a-1), self.y - 144/(a-1), 288/(a-1), 288/(a-1))
end