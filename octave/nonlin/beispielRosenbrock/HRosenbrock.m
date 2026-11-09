function H = HRosenbrock (x)

    global dfcounter
    
    H = [-400.0*(x(2)-3*x(1)*x(1)) + 2.0,-400.*x(1); ...
         -400.*x(1),200.0];

    dfcounter = dfcounter + 1;

