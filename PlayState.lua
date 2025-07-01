PlayState = Class{}


function PlayState:init()
    self.positions = {}
    self.X_play = true
    self.win_state = ""
    self.win_array = {}
    self.track_late_xo = {}
    self.reset = false
end

function PlayState:update(dt)
    if self.win_state ~= "win" then
        if love.mouse.wasPressed(1) then
            X = love.mouse.buttonsPressed[1]["x"]
            Y = love.mouse.buttonsPressed[1]["y"]
            local duplicate = false
            if (X > (512-288)/2 and X < (512+288)/2) and (Y > 0 and Y < 288) then
                local xo = XO(self.X_play)
                xo:update(dt)
                for i, pos in ipairs(self.positions) do
                    if xo.x == pos.x and xo.y == pos.y then
                        duplicate = true
                        break
                    end
                end
                if duplicate == false then
                    table.insert(self.positions, xo)
                    self.track_late_xo = {}
                    table.insert(self.track_late_xo, xo)
                end

                if duplicate == false then
                    if self.X_play == true then
                        self.X_play = false
                    else 
                        self.X_play = true
                    end
                end
            end
            love.mouse.buttonsPressed[1] = nil
            self:check_win(4)
        end
        return
    end

    if love.mouse.wasPressed(1) then --422, 144-12, 60, 32)
        X = love.mouse.buttonsPressed[1]["x"]
        Y = love.mouse.buttonsPressed[1]["y"]
        if (X > 422 and X < 422 + 60) and (Y > 144-12 and Y < 144-12+32) then
            self.reset = true
        end
    end

end

function PlayState:check_win(n) -- n is number of boxes to win
    local count = 0
    local win_detected = false
    for i,pos in ipairs(self.positions) do
        if win_detected then break end
        self.win_array = {}
        self.win_array[0] = pos
        count = 1
        
        -- northeast case
        for j,sub_pos in ipairs(self.positions) do 
                
            if i ~= j and sub_pos.x_play == pos.x_play then
                for k = 0,(n-2) do
                    if (sub_pos.x - pos.x) == (k+1) * 288/(a-1) and (sub_pos.y - pos.y) == - (k+1) * 288/(a-1) then  
                        self.win_array[k+1] = sub_pos
                        count = count + 1
                    end
                end
            end
        end
        if count == n then
            self.win_state = "win"
            win_detected = true
            break
        else
            self.win_array = {}
            self.win_array[0] = pos
            count = 1
        end

        -- east case
        for j,sub_pos in ipairs(self.positions) do 
                
            if i ~= j and sub_pos.x_play == pos.x_play then
                for k = 0,(n-2) do
                    if (sub_pos.x - pos.x) == (k+1) * 288/(a-1) and (sub_pos.y - pos.y) == 0 then 
                        self.win_array[k+1] = sub_pos
                        count = count + 1
                    end
                end
            end
        end
        if count == n then
            self.win_state = "win"
            win_detected = true
            break
        else
            self.win_array = {}
            self.win_array[0] = pos
            count = 1
        end

        -- southeast
        for j,sub_pos in ipairs(self.positions) do 
                
            if i ~= j and sub_pos.x_play == pos.x_play then
                for k = 0,(n-2) do
                    if (sub_pos.x - pos.x) == (k+1) * 288/(a-1) and (sub_pos.y - pos.y) == (k+1) * 288/(a-1) then 
                        self.win_array[k+1] = sub_pos
                        count = count + 1
                    end
                end
            end
        end
        if count == n then
            self.win_state = "win"
            win_detected = true
            break
        else
            self.win_array = {}
            self.win_array[0] = pos
            count = 1
        end

        -- south
        for j,sub_pos in ipairs(self.positions) do 
                
            if i ~= j and sub_pos.x_play == pos.x_play then
                for k = 0,(n-2) do
                    if (sub_pos.x - pos.x) == 0 and (sub_pos.y - pos.y) == (k+1) * 288/(a-1) then 
                        self.win_array[k+1] = sub_pos
                        count = count + 1
                    end
                end
            end
        end
        if count == n then
            self.win_state = "win"
            win_detected = true
            break
        else
            self.win_array = {}
            self.win_array[0] = pos
            count = 1
        end
    end
end

function PlayState:render()
    -- fill color for late_xo
    if self.track_late_xo[1] then
        self.track_late_xo[1]:render_fill()
    end

    -- fill color for win array
    if self.win_state == "win" then
        love.graphics.setColor(1, 215/255, 0)
        for _,pos in pairs(self.win_array) do
            love.graphics.rectangle("fill", pos.x-144/(a-1), pos.y - 144/(a-1), 288/(a-1), 288/(a-1))
        end
    end

    -- draw x/o
    if self.positions then
        love.graphics.setColor(0,0,0)
        for i,pos in ipairs(self.positions) do
            pos:render()
        end
    end

    if self.reset == true then
        love.graphics.clear(1,1,1)
    end

end