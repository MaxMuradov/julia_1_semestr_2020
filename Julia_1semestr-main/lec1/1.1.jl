ENV["MPLBACKEND"]="tkagg"
using PyPlot
using HorizonSideRobots
pygui(true)
#           up  down   right left
sides = (Nord, Sud, Ost, West)
function inverse(side::HorizonSide)
    """Inverse the side"""
    return HorizonSide(mod(Int(side)+2, 4)) 
end

function main(r::Robot)
    """Main function"""
    for side in sides
        putmarkers!(r,side)
        followMarkers(r,inverse(side))
    end
    putmarker!(r)
end

function putmarkers!(r::Robot,side::HorizonSide)
    """As long as robot is able to move put marker"""
    while isborder(r,side)==false 
        move!(r,side)
        putmarker!(r)
    end
end

function followMarkers(r::Robot,side::HorizonSide)
    """Move in the direction as long as robot is on marker"""
    while ismarker(r)==true 
        move!(r,side) 
    end
end

r=Robot(animate=true)
print("Робот создан")
main(r)
