ENV["MPLBACKEND"]="tkagg"
using PyPlot
using HorizonSideRobots
pygui(true) 

#           up  down   right left
#sides = (Nord, Sud, Ost, West)

function main(r::Robot)
    path = goToTheCorner(Sud, West)

    findBorder(r)
    markBorder(r)

    goToTheCorner(Sud, West)
    for item in path[end:-1:1]
        print(item)
        followByCountRec(r, item[1], item[2])
    end
end

function findBorder(r)
    while(!isborder(r, Nord))
        if(!isborder(r, Ost))
            move!(r, Ost)
        else
            moveSide(r, West)
            move!(r, Nord)
        end
    end
end

function markBorder(r)
    comp = Dict(
        Nord => Ost,
        West => Nord,
        Sud => West,
        Ost => Sud
    )
    for side ∈ [Nord, West, Sud, Ost]
        while isborder(r, side)
            putmarker!(r)
            move!(r, comp[side])
        end
        putmarker!(r)
        move!(r, side)
    end
end

function goToTheCorner(side1::HorizonSide, side2::HorizonSide)
    pathBack = []
    while isborder(r, side1) != true || isborder(r, side2) != true
        stepsToX = moveSide(r, side1)
        stepsToY = moveSide(r, side2)
        push!(pathBack, [inverseSide(side1), stepsToX])
        push!(pathBack, [inverseSide(side2), stepsToY])
    end

    return pathBack
end

function moveSide(r::Robot, side::HorizonSide)
    # Move untill you find pr
    steps = 0
    while isborder(r, side) != true
        move!(r, side)
        steps += 1
    end
    return steps
end

function followByCount(r::Robot, side::HorizonSide, count::Int)
    for i = 1:count
        moveStep(r, side, false)
    end
end


r=Robot(animate=true)
main(r)