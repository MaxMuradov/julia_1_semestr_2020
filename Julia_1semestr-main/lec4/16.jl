ENV["MPLBACKEND"]="tkagg"
using PyPlot
using HorizonSideRobots
pygui(true)
include("robot_operations.jl")
#           up  down   right left
#sides = (Nord, Sud, Ost, West)

function main(r::Robot)
    # Пусть робот окажется в левом нижнем углу
    pathBack = goToTheCorner(r, West, Sud)

    side=Ost
    markRow(r,side)
    while !isborder(r, Nord)
        move!(r,Nord)
        side=inverseSide(side)
        markRow(r,side)
    end

    for item in pathBack[end:-1:1]
        followByCount(r, item[1], item[2])
    end
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


r=Robot(animate=true)
main(r)