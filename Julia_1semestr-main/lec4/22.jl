ENV["MPLBACKEND"]="tkagg"
using PyPlot
using HorizonSideRobots
pygui(true)
include("robot_operations.jl")

function main(r)
    path = goToTheCornerRec(r, Sud, West)
    width, height, _1, _2 = measureBoard(r)

    side = Nord
    move!(r, Ost)
    d = 1
    obstacles = 0
    while width > 0
        d += 1
        width -= 1
        c = height
        while c>0 
            if isborder(r, side)
                count,b = moveAround(r, side)
                c = c - count - 1
                if (b == 1) && (count*b != 0)
                    obstacles += 1
                end
            else
                move!(r, side)
                c -= 1
            end
        end
        goToTheCornerRec(r, Sud, West)
        if width != 0
            moveByCoord(r, Ost, d)
        end
    end
    print(obstacles)
end

function moveAround(r, side)
    print("Начинаю обход\n")
    horisontal = 0
    vertical = 0

    sides = Dict(
        Nord=>West,
        Sud=>West,
        Ost=>Sud,
        West=>Sud
    )

    while isborder(r, side)
        move!(r, sides[side])
        vertical += 1
    end

    move!(r, side)
    while isborder(r, inverseSide(sides[side]))
        move!(r, side)
        horisontal += 1
    end

    move!(r, inverseSide(sides[side]))
    c = vertical
    while c > 1
        move!(r, inverseSide(sides[side]))
        c -= 1
    end
    print("Готово\n")
    return (horisontal, vertical)
end

function moveByCoord(r, side, coord)
    while(coord > 0)
        coord = coord - 1
        move!(r, side)
    end
end

r=Robot(animate=true,8, 8)
main(r)