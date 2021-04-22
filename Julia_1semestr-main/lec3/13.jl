ENV["MPLBACKEND"]="tkagg"
using PyPlot
using HorizonSideRobots

include("robot_operations.jl")
pygui(true)

function mark_kross_x(r::Robot)
    for side in ((Nord,Ost),(Sud,Ost),(Sud,West),(Nord,West))
        putmarkers!(r,side)
        move_by_markers!(r,inverse(side))
    end
    putmarker!(r)
end

function putmarkers!(r::Robot,side::NTuple{2,HorizonSide})
    while isborderTulpe(r,side)==false
        moveTulpe(r,side)
        putmarker!(r)
    end
end

function isborderTulpe(r::Robot,side::NTuple{2,HorizonSide})
    return (isborder(r,side[1]) || isborder(r,side[2]))
end

function moveTulpe(r::Robot, side::NTuple{2,HorizonSide})
    for s in side
        move!(r,s)
    end
end

function move_by_markers!(r::Robot,side::NTuple{2,HorizonSide})
    while ismarker(r) 
        moveTulpe(r,side)
    end
end

function inverse(side::NTuple{2,HorizonSide})
    return (inverseSide(side[1]), inverseSide(side[2]))
end

r=Robot(animate=true)
mark_kross_x(r)