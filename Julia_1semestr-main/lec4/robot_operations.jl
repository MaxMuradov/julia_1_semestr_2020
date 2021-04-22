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

function followByCountRec(r::Robot, side::HorizonSide, count::Int)
    for i = 1:count
        if !isborder(r, side)
            move!(r, side)
        else
            moveIfPossible(r, side)
        end
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

#################

next(side::HorizonSide) = HorizonSide(mod(Int(side)+1,4))
left(side::HorizonSide) = HorizonSide(mod(Int(side)+1, 4))
right(side::HorizonSide) = HorizonSide(mod(Int(side)-1, 4))

function moveIfPossible(r::Robot, direct_side::HorizonSide, needSteps=false)
    orthogonal_side = next(direct_side)
    reverse_side = inverseSide(orthogonal_side)
    num_steps=0

    movedSteps = 0
    while isborder(r,direct_side) == true
        if isborder(r, orthogonal_side) == false
            move!(r, orthogonal_side)
            num_steps += 1
        else
            break
        end
    end

    if isborder(r,direct_side) == false
        move!(r,direct_side)
        movedSteps += 1
        while isborder(r,reverse_side) == true
            move!(r,direct_side)
            movedSteps += 1
        end
        result = true
    else
        result = false
    end
    for _ in 1:num_steps
        move!(r,reverse_side)
    end
    if !needSteps
        return result
    else
        return [result, movedSteps]
    end
end

#######################

function goToTheSide(r::Robot,side::HorizonSide)
    side_steps = 0
    while !isborder(r, side)
        move!(r, side)
        side_steps += 1
    end
    while true
        steps, ok = moveIfPossible(r,side, true)
        side_steps += steps
        ok == true || break
    end
    print("Готово\n")

    return side_steps
end

function goToTheCornerRec(r::Robot, side1::HorizonSide, side2::HorizonSide)
    x = goToTheSide(r, side1)
    y = goToTheSide(r, side2)

    pathBack = [[side1, x], [side2, y]]
    return pathBack
end

function markRow(r::Robot,side::HorizonSide)
    print("Маркирую строку\n")
    putmarker!(r)
    while !isborder(r, side)
        move!(r, side)
        putmarker!(r)
    end
    while moveIfPossible(r,side) == true 
        putmarker!(r)
    end
    print("Готово\n")
end

function markRow(r::Robot,side::HorizonSide, count)
    bias = 0
    print("Маркирую строку\n")
    putmarker!(r)
    while !isborder(r, side)
        move!(r, side)
        if bias < count
            putmarker!(r)
            bias += 1
        end
    end
    while moveIfPossible(r,side) == true 
        if bias < count
            putmarker!(r)
            bias += 1
        end
    end
    print("Готово\n")
end