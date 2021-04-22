ENV["MPLBACKEND"]="tkagg"
using PyPlot
using HorizonSideRobots

include("robot_operations.jl")
pygui(true)

# так-как горизонтальная перегородка бесконечная, то мы 
# не можем узнать ее размер, а значит будем искать проход
# с помощью повторяющегося цикла прохода
# туда-обратно

function main(r::Robot, step::Int)
    if isborder(r, Nord)
        putmarker!(r)
    else
        return
    end

    direction = Ost
    while true
        moveIfMarked(r, direction)
        for i ∈ 1:step
            print(i, "\n")
            if !isborder(r, Nord)
                return
            end
            print("ставлю маркер\n")
            putmarker!(r)
            moveStep(r, direction, false)
            print("иду в", direction, "\n")
        end
        direction = inverseSide(direction)
        moveStep(r, direction, false)
        print("inversed side", direction, "\n")
    end
end

function moveIfMarked(r::Robot, side::HorizonSide)
    while true
        if !ismarker(r)
            break
        end
        print("иду в", side, "\n")
        moveStep(r, side, false)
    end
end

r=Robot(5, 20, animate=true)
main(r, 6)