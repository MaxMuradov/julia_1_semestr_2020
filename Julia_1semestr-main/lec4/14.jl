ENV["MPLBACKEND"]="tkagg"
using PyPlot
using HorizonSideRobots
pygui(true)
include("robot_operations.jl")
#           up  down   right left

function main(r::Robot)
    sides = (Nord, West, Sud, Ost)
    """Main function"""
    for side in sides
        print("\nGoing ", side)
        num_steps = cross(r,side)
        print("\nReturnin back ", inverseSide(side))
        movements(r, inverseSide(side), num_steps)
    end
end

function cross(r::Robot,side::HorizonSide)
    num_steps=0 
    while moveIfPossible(r, side) == true
        putmarker!(r)
        num_steps += 1
    end 
    return num_steps
end

function movements(r::Robot, side::HorizonSide, num_steps::Int)
    for _ in 1:num_steps
        moveIfPossible(r,side) 
    end
end

r=Robot(animate=true)
print("Робот создан")
main(r)