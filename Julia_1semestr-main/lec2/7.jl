ENV["MPLBACKEND"]="tkagg"
using PyPlot
using HorizonSi

include("robot_operations.jl")
pygui(true) 

function main(r::Robot)
    putmarker!(r)

    goToSide_checkIfmarked(r, Nord)
    # пойдем налево, потом направо и начнем заполнять змейкой
    goToSide_checkIfmarked(r, West)

    direction = Ost
    while isborder(r, Sud) != true || isborder(r, Ost) != true
        goToSide_checkIfmarked(r, direction)
        marked = false
        if ismarker(r)
            marked = true
        end
        if isborder(r, Sud) != true
            moveStep(r, Sud, !marked, true)
        end
        direction = inverseSide(direction)
    end
end

function goToSide_checkIfmarked(r::Robot, side::HorizonSide)
    marked = false
    while isborder(r, side) != true
        if ismarker(r)
            marked = true
        end
        moveStep(r, side, !marked, true)
        marked = false
    end 
end

r=Robot(animate=true)
main(r)