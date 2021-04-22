ENV["MPLBACKEND"]="tkagg"
using PyPlot
using HorizonSideRobots

include("robot_operations.jl")
pygui(true)

function get_mean_temperature(r::Robot)
    sum_temperatures, num_markers = get_sum_temperatures(r)
    return sum_temperatures/num_markers
end

function get_sum_temperatures(r::Robot)
    side=Ost
    sum_temperatures, num_markers = get_sum_temperatures(r,side)
    while isborder(r,Nord)==false
        move!(r,Nord)
        side=inverseSide(side)
        part_sum, part_num = get_sum_temperatures(r,side)
        sum_temperatures+=part_sum
        num_markers+=part_num
    end
    return sum_temperatures, num_markers
end 

function get_sum_temperatures(r::Robot,side::HorizonSide)
    if ismarker(r)==false
        sum_temperatures=0
        num_markers=0
    else
        sum_temperatures=temperature(r)
        num_markers=0    
    end

    while isborder(r,side)==false
        move!(r,side)
        if ismarker(r)==true
            sum_temperatures += temperature(r)
            num_markers += 1
        end
    end
    return sum_temperatures, num_markers 
end

r=Robot(animate=true)
mean = get_mean_temperature(r)
print(mean)