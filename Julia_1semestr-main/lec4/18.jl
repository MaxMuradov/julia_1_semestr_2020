ENV["MPLBACKEND"]="tkagg"
using PyPlot
using HorizonSideRobots
pygui(true)
include("robot_operations.jl")

function main(r::Robot)
    # Пусть робот окажется в левом нижнем углу
    path = goToTheCornerRec(r, Sud, West)
    putmarker!(r)
    # Пусть робот окажется в левом верхнеи углу
    goToTheCornerRec(r, Nord, West)
    putmarker!(r)
    # Пусть робот окажется в правом верхнеи углу
    goToTheCornerRec(r, Nord, Ost)
    putmarker!(r)
    # Пусть робот окажется в правом нижнем углу
    goToTheCornerRec(r, Sud, Ost)
    putmarker!(r)

    goToTheCornerRec(r, Sud, West)

    for item in path[end:-1:1]
        followByCountRec(r, item[1], item[2])
    end
end

r=Robot(animate=true)
main(r)