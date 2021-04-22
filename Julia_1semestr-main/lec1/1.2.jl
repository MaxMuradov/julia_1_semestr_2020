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
    # Пусть робот окажется в левом верхнем углу
    stepsToWest = moveSide(r, West)
    stepsToNord = moveSide(r, Nord)

    # Двигаемся по часовой стрелке
    sides = (Ost, Sud, West, Nord, Ost)
    for side in sides
        while isborder(r, side) != true
            if ismarker(r)
                followByCount(r, Ost, stepsToWest)
                followByCount(r, Sud, stepsToNord)
                return true
            end
            moveSide(r, side, true)
        end
    end
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

function moveStep(r::Robot, side::HorizonSide, needMark::Bool)
    # Take step in one direction
    if needMark
        putmarker!(r)
    end
    move!(r, side)
end

function followByCount(r::Robot, side::HorizonSide, count::Int)
    for i = 0:count-1
        moveStep(r, side, false)
    end
end


r=Robot(animate=true)
main(r)
