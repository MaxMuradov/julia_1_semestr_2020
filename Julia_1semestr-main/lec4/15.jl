ENV["MPLBACKEND"]="tkagg"
using PyPlot
using HorizonSideRobots

include("robot_operations.jl")
pygui(true)

function main(r::Robot)
    # Пусть робот окажется в левом верхнем углу
    westside = goToTheSide(r, West)
    nordside = goToTheSide(r, Nord)

    path = [[Ost, westside], [Sud, nordside]]
    # Двигаемся по часовой стрелке
    sides = (Ost, Sud, West, Nord)
    for side in sides
        while isborder(r, side) != true
            moveSide(r, side, true)
        end
    end

    goToTheSide(r, West)
    goToTheSide(r, Nord)
    for item in path[end:-1:1]
        followByCountRec(r, item[1], item[2])
    end
end

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

r=Robot(animate=true)

main(r)