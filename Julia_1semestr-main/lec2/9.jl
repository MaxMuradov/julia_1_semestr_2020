ENV["MPLBACKEND"]="tkagg"
using PyPlot
using HorizonSideRobots

include("robot_operations.jl")
pygui(true)

# т.к. поле неограниченное, то пусть робот проходит спиралью по полю, пока не найдет маркер

function main(r::Robot)
    dir_x = Sud
    dir_y = Ost
    counter = 1

    while true #!ismarker(r)
        for i ∈ 1:counter
            if ismarker(r)
                return
            end
            moveStep(r, dir_x, false)
        end

        for i ∈ 1:counter
            if ismarker(r)
                return
            end
            moveStep(r, dir_y, false)
        end

        dir_x = inverseSide(dir_x)
        dir_y = inverseSide(dir_y)
        counter += 1
    end
end

r=Robot(animate=true)
main(r)