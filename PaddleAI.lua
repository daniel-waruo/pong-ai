-- This is the Artificial Intelligence Player 
PaddleAI = Class{}

function PaddleAI:init(ball, paddle)
    self.paddle = paddle
    self.ball = ball
end

function PaddleAI:moveUp()
    return -PADDLE_SPEED
end

function PaddleAI:moveDown()
    return PADDLE_SPEED
end

function PaddleAI:getBouncePoint()
    --[[
        function for finding the predicted bounce point using the 
        balls curent position
    ]]
    --- if the ball is not moving move to the center of the screen
    if self.ball.dx == 0 then
        --- place the ball at the middle of the screen
        return VIRTUAL_HEIGHT/2 
    end

    -- get gradient of ball trajectory from change in y and change in x 
    local gradient = self.ball.dy/self.ball.dx
    
    -- point where the the ball on the y place which the paddle lies
    local bouncePoint = gradient * (self.paddle.x - self.ball.x) + self.ball.y

    -- if the point iS NOT  greater than the virtual width and virtual height
    if  0 <= bouncePoint and bouncePoint <= VIRTUAL_HEIGHT then
        -- return the point where the ball will bounce
        return bouncePoint
    else 
        -- get the bounce point on the wall and negate the gradient to 
        -- to get a new trajectory which we will use to get the position of 
        -- where the ball will bounce on the paddle
        local wallY
        --- the y value of the wall coordinate based on the gradient
        --- if the gradient is a negative value then the ball will bounce 
        --- on the top of the screen 
        --- if the gradient is positive it will bounce on the bottom of the screen
        if gradient < 0 then
            wallY = 0        
        else  
            wallY = VIRTUAL_HEIGHT
        end
        -- get the X-value of the wall coordinate using the equation of 
        -- a straight line
        wallX = (wallY - bouncePoint)/gradient + self.paddle.x

        --- after getting where the ball will bounce 
        --- calculate the position on the y axis of the paddle where the ball will bounce
        bouncePoint = -gradient * (self.paddle.x - wallX) + wallY
        return bouncePoint    
    end
end

function PaddleAI:getPaddleDY()
    
    ---get the paddle middle point
    local middleY = self.paddle.y + self.paddle.height/2 
    -- move the paddle to meet with the predicted bounce point
    local bouncePoint = self:getBouncePoint()

    -- if the ball is stopped we also stop
    if gameState =='serve' then
        bouncePoint = VIRTUAL_HEIGHT/2 
    end

    local paddleOffset = self.paddle.height/2 - self.ball.height/2
    
    --- if middle of the paddle is below the expected bounce point
    if middleY > bouncePoint + paddleOffset  then
        ---move paddle up
        return self:moveUp()
        --- if it is below the bounce point
    elseif middleY < bouncePoint - paddleOffset then
        --- move paddle down
        return self:moveDown()
    else
        return 0
    end 
end