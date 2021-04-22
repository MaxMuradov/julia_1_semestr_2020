function moveSide(r::Robot, side::HorizonSide, needMark=false)
    # Move untill you find pr
    steps = 0
    while isborder(r, side) != true
        moveStep(r, side, needMark)
        steps += 1
    end
    return steps
end

function followByCount(r::Robot, side::HorizonSide, count::Int)
    for i = 1:count
        moveStep(r, side, false)
    end
end

function moveStep(r::Robot, side::HorizonSide, needMark::Bool, check=false)
    # Take step in one direction
    move!(r, side)
    if needMark
        if check
            if ismarker(r)
                return 0
            end
        end
        putmarker!(r)
    end
end

function inverseSide(side::HorizonSide)
    # Return inverse side
    return HorizonSide(mod(Int(side)+2, 4))
end

function find_border!(r::Robot, direction_to_border::HorizonSide, direction_of_movement::HorizonSide)
    while isborder(r,direction_to_border)==false  
        if isborder(r,direction_of_movement)==false
            move!(r,direction_of_movement)
        else
            move!(r,direction_to_border)
            direction_of_movement=inverse(direction_of_movement)
        end
    end
    #УТВ: непосредственно справа от Робота - внутренняя пергородка
end

function measureBoard(r::Robot)
    stepsToY = moveSide(r, Nord)
    stepsToX = moveSide(r, West)

    width = moveSide(r, Ost)
    height = moveSide(r, Sud)

    moveSide(r, Nord)
    moveSide(r, West)

    followByCount(r, Sud, stepsToY)
    followByCount(r, Ost, stepsToX)

    return (width, height, stepsToX, stepsToY)
end

###########3

function goToTheCorner(r::Robot, side1::HorizonSide, side2::HorizonSide)
    pathBack = []
    while isborder(r, side1) != true || isborder(r, side2) != true
        stepsToX = moveSide(r, side1)
        stepsToY = moveSide(r, side2)
        push!(pathBack, [inverseSide(side1), stepsToX])
        push!(pathBack, [inverseSide(side2), stepsToY])
    end
    #putmarker!(r)
    #for item in pathBack[end:-1:1]
    #    followByCount(r, item[1], item[2])
    #end
    return pathBack
end

function goToTheCornerReturnIndependent(r::Robot, side1::HorizonSide, side2::HorizonSide)
    pathBackX = []
    pathBackY = []
    while isborder(r, side1) != true || isborder(r, side2) != true
        stepsToX = moveSide(r, side1)
        stepsToY = moveSide(r, side2)
        push!(pathBackX, [inverseSide(side1), stepsToX])
        push!(pathBackY, [inverseSide(side2), stepsToY])
    end
    #putmarker!(r)
    #for item in pathBack[end:-1:1]
    #    followByCount(r, item[1], item[2])
    #end
    return (pathBackX, pathBackY)
end

##############

function moveIfMarked(r::Robot, side::HorizonSide)
    while true
        if !ismarker(r)
            break
        end
        moveStep(r, side, false)
    end
end