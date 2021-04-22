ENV["MPLBACKEND"]="tkagg"
using PyPlot
using HorizonSideRobots
pygui(true)
#           up  down   right left
#sides = (Nord, Sud, Ost, West)
function inverseSide(side::HorizonSide)
    # Return inverse side
    return HorizonSide(mod(Int(side)+2, 4))
end

function main(r::Robot)
    # Пусть робот окажется в левом нижнем углу
    stepsToWest = moveSide(r, West)
    stepsToNord = moveSide(r, Sud)

    # Подсчитаем количество клеток по горизонтали
    counter = moveSide(r, Ost)
    moveSide(r, West)

    # Движение
    while true
        putmarker!(r)
        moveSideByCount(r, Ost, counter)
        moveSide(r, West)
        if isborder(r, Nord) == true
            break
        end

        moveStep(r, Nord, false)
        counter -= 1
    end
    # Возвращаемся обратно
    moveSide(r, West)
    moveSide(r, Sud)

    followByCount(r, Ost, stepsToWest)
    followByCount(r, Nord, stepsToNord)
end

function moveSide(r::Robot, side::HorizonSide, needMark=false)
    # Move untill you find pr
    steps = 0
    while isborder(r, side) != true
        moveStep(r, side, needMark)
        steps += 1
    end
    return steps
end

function moveSideByCount(r::Robot, side::HorizonSide, count)
    # Move by count
    for i in 1:count
        if isborder(r, side) != true
            moveStep(r, side, true)
        else
            break
        end
    end
end

function followByCount(r::Robot, side::HorizonSide, count::Int)
    for i = 0:count-1
        moveStep(r, side, false)
    end
end

function moveStep(r::Robot, side::HorizonSide, needMark::Bool)
    # Take step in one direction
    move!(r, side)
    if needMark
        putmarker!(r)
    end
end

r=Robot(animate=true)
main(r)