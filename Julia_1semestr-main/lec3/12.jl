ENV["MPLBACKEND"]="tkagg"
using PyPlot
using HorizonSideRobots

include("robot_operations.jl")
pygui(true)

module Chess
    using HorizonSideRobots
    import Main.inverseSide, Main.isborder, Main.goToTheCorner, Main.followByCount

    export mark_chess

    pathBack = []

    X=0
    Y=0

    BOARD_SIZE = 0

    function init(r::Robot)
        global pathBack
        pathBack = goToTheCorner(r, West, Sud)
    end

    function mark_chess(r::Robot,n::Int)
        global BOARD_SIZE
        BOARD_SIZE = n
        side=Ost

        init(r)
        mark_row(r,side)
        while isborder(r,Nord)==false
            move_decart!(r,Nord)
            side = inverseSide(side)
            mark_row(r,side)
        end

        goToTheCorner(r, West, Sud)
        for item in pathBack[end:-1:1]
            followByCount(r, item[1], item[2])
        end
    end

    function mark_row(r::Robot, side::HorizonSide)       
        putmarker_chess!(r)
        while isborder(r,side)==false
            move_decart!(r,side)
            putmarker_chess!(r)
        end
    end

    function putmarker_chess!(r)
        if (mod(X, 2*BOARD_SIZE) in 0:BOARD_SIZE-1) && (mod(Y, 2*BOARD_SIZE) in 0:BOARD_SIZE-1) 
            putmarker!(r)
        end
    end

    function move_decart!(r,side)
        global X, Y
        # Id prefer to use switch-case, bruh
        if side==Nord
            Y+=1
        elseif side==Sud
            Y-=1
        elseif side==Ost
            X+=1
        else
            X-=1
        end
        move!(r,side)
    end

end

r=Robot(animate=true)
using .Chess
mark_chess(r, 2)