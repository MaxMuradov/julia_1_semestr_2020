"""
ДАНО: Робот - в произвольной клетке ограниченного прямоугольного поля, на котором могут находиться
также внутренние прямоугольные перегородки (все перегородки изолированы друг от друга
 прямоугольники могут вырождаться в отрезки)

РЕЗУЛЬТАТ: Робот - в исходном положении, и в 4-х приграничных клетках, две из которых имеют ту же широту,
 а две - ту же долготу, что и Робот, стоят маркеры.
"""

ENV["MPLBACKEND"]="tkagg"
using PyPlot
using HorizonSideRobots

include("robot_operations.jl")
pygui(true)

function mark_centers(r)
    num_steps = goToTheCornerReturnIndependent(r, Sud,West)
    steps_to_ost = sum(i[2] for i in num_steps[1])
    steps_to_nord = sum(i[2] for i in num_steps[2])

    #---------------------
    followByCount(r, Nord, steps_to_nord)
    putmarker!(r)
    steps_to_sud = moveSide(r,Nord)

    followByCount(r,Ost, steps_to_ost)
    putmarker!(r)
    steps_to_west = moveSide(r,Ost)

    followByCount(r,Sud, steps_to_sud)
    putmarker!(r)
    moveSide(r,Sud)

    followByCount(r,West, steps_to_west)
    putmarker!(r)
    moveSide(r,West)
    #-------------------
    print("Возвращаюсь обратно")
    for item in num_steps[1][end:-1:1]
        followByCount(r, item[1], item[2])
    end

    for item in num_steps[2][end:-1:1]
        followByCount(r, item[1], item[2])
    end
end

r=Robot(animate=true)
mark_centers(r)