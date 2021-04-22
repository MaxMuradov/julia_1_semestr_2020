ENV["MPLBACKEND"]="tkagg"
using PyPlot
using HorizonSideRobots
pygui(true)
include("robot_operations.jl")
#           up  down   right left
#sides = (Nord, Sud, Ost, West)

function main(r::Robot)
    # Пусть робот окажется в нижнем верхнем углу
    westside = goToTheSide(r, West)
    nordside = goToTheSide(r, Sud)

    count = goToTheSide(r, Ost)
    goToTheSide(r, West)

    path = [[Ost, westside], [Nord, nordside]]

    # Двигаемся по направлению вниз-вправо-вверх-вправо-...
    markRow(r, Ost, count)
    count -= 1
    while !isborder(r, Nord)
        move!(r,Nord)
        goToTheSide(r, West)
        markRow(r, Ost, count)
        count -= 1
    end

    # Возвращаемся обратно
    goToTheSide(r, West)
    goToTheSide(r, Sud)

    for item in path[end:-1:1]
        followByCountRec(r, item[1], item[2])
    end
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

r=Robot(4, 4, animate=true)
main(r)