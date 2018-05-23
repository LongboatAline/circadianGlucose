function testOut = tests
    testOut = functiontests(localfunctions);
end

function testF1Default(testCase)
    const = models.constants;
    G = 10000;
    actSolution = models.funcs.f1(G, const);
    sigSlope = -const.Vg*const.a1; sigMax = const.Rm;
    sigShift = const.C1/const.a1;
    expSolution = models.funcs.sigmoid(G, sigMax, sigSlope, sigShift);
    verifyEqual(testCase,actSolution,expSolution)
end

function testF1Alternative(testCase)
    const = models.constants;
    const.Vg = 5; const.Rm = 100; C1 = -3000;
    G = -10000;
    actSolution = models.funcs.f1(G, const);
    sigSlope = -const.Vg*const.a1; sigMax = const.Rm;
    sigShift = const.C1/const.a1;
    expSolution = models.funcs.sigmoid(G, sigMax, sigSlope, sigShift);
    verifyEqual(testCase,actSolution,expSolution)
end

function testF2Default(testCase)
    const = models.constants;
    G = 10000;
    actSolution = models.funcs.f2(G, const);
    expSolution = const.Ub*(1-exp(-G/(const.C2*const.Vg)));
    verifyEqual(testCase,actSolution,expSolution)
end

function testF2Alternative(testCase)
    const = models.constants;
    const.Vg = 5; const.Ub = 100; C2 = -3000;
    G = -10000;
    actSolution = models.funcs.f2(G, const);
    expSolution = const.Ub*(1-exp(-G/(const.C2*const.Vg)));
    verifyEqual(testCase,actSolution,expSolution)
end

function testF3Default(testCase)
    const = models.constants;
    G = 10000;
    actSolution = models.funcs.f3(G, const);
    expSolution = G/(const.C3*const.Vg);
    verifyEqual(testCase,actSolution,expSolution)
end

function testF3Alternative(testCase)
    const = models.constants;
    const.Vg = 5; C3 = -3000;
    G = 10;
    actSolution = models.funcs.f3(G, const);
    expSolution = G/(const.C3*const.Vg);
    verifyEqual(testCase,actSolution,expSolution)
end

function testBaselineCritical(testCase)
    %Test baseline for critically damped case
    % Find first time e^(-x)+1 is within 0.1% of 1.
    % Need t_min s.t. 0.999<e^(-t)+1<1.001
    % => t_min = 6.908
    t = 0:0.001:100;
    G = exp(-t)+1;
    funcRes = utils.baseline_return(t, G, 50);
    actSolution = 6.908;
    verifyEqual(testCase,funcRes, actSolution, 'AbsTol', 0.01)
end

function testBaselineDamped(testCase)
    % Test baseline for (uncrticially) damped case
    % Find first time e^(-0.1t)cos(0.5t) is within 1% of 0.
    % Need t_min s.t. |e^(-0.1t)cos(0.5t)|<0.01
    % => t_min = \pi
    t = 0:0.01:100;
    G = exp(-0.1*t).*cos(0.5*t);
    funcRes = utils.baseline_return(t, G, 50);
    actSolution = pi;
    verifyEqual(testCase,funcRes, actSolution, 'AbsTol', 0.01)
end

function testBaselineLimit(testCase)
    % Test baseline for limit cycle
    % Find first time (e^(-0.1t)+1)cos(0.5t) is within 1% of 1.
    % t_min =\pi/2
    t = 0:0.01:100;
    G = (exp(-0.1*t)+1).*cos(t);
    funcRes = utils.baseline_return(t, G, 50);
    actSolution = pi/2;
    verifyEqual(testCase,funcRes, actSolution, 'AbsTol', 0.01)
end

function testAmplitudeBaselineCritical(testCase)
    % Test baseline for critically damped case
    % Find first time e^(-x)+1 is within 1% of 1.
    % Need t_min s.t. 0.99<e^(-t)+1<1.001
    % => t_min = 4.605
    t = 0:0.01:200;
    G = exp(-t)+1;
    funcRes = utils.baselineAmplitude(t, G, 100);
    actSolution = 6.9078;
    verifyEqual(testCase,funcRes, actSolution, 'AbsTol', 0.001)
end

function testAmplitudeBaselineLimit(testCase)
    % Test baseline for limit cycle
    % Find first time peak of (e^(-0.1t)+1)cos(0.5t) is within 0.1% of 1.
    % t_min =16*pi
    t = 0:0.01:200;
    G = (exp(-0.1*t)+1).*cos(t);
    funcRes = utils.baselineAmplitude(t, G, 100);
    actSolution = 22*pi;
    verifyEqual(testCase,funcRes, actSolution, 'AbsTol', 0.01)
end

function testAmplitudeBaselineDamped(testCase)
    % Test baseline for (uncrticially) damped case
    % Find first time peak of e^(-0.1t)cos(0.5t) is within 1% of 0.
    % Need t_min, s.t. G<0.001 of 0, after the final peak>0.001
    % i.e. first G<0.001, after final |e^(-0.1t)cos(0.5t)|>0.001, cos(0.5t)=1
    % => t_min = 49.87 (determined using plot)
    t = 0:0.01:200;
    G = exp(-0.1*t).*cos(0.5*t)+1;
    funcRes = utils.baselineAmplitude(t, G, 100);
    actSolution = 53.01;
    verifyEqual(testCase,funcRes, actSolution, 'AbsTol', 0.01)
end

function testExponFitDamped(testCase)
    % Test baseline for (uncrticially) damped case
    % Find first time peak of e^(-0.1t)cos(0.5t) is within 1% of 0.
    % Need t_min, s.t. G<0.001 of 0, after the final peak>0.001
    % i.e. first G<0.001, after final |e^(-0.1t)cos(0.5t)|>0.001, cos(0.5t)=1
    % => t_min = 49.87 (determined using plot)
    t = 0:0.01:200;
    G = exp(-0.1*t)*0.5.*cos(0.5*t)+1;
    fit = utils.expon_fit(t, G, 100);
    actSolution = -0.1;
    verifyEqual(testCase,fit.b, actSolution, 'AbsTol', 0.01)
end

function testExponFitCritial(testCase)
    % Test baseline for (uncrticially) damped case
    % Find first time peak of e^(-0.1t)cos(0.5t) is within 1% of 0.
    % Need t_min, s.t. G<0.001 of 0, after the final peak>0.001
    % i.e. first G<0.001, after final |e^(-0.1t)cos(0.5t)|>0.001, cos(0.5t)=1
    % => t_min = 49.87 (determined using plot)
    t = 0:0.01:200;
    G = exp(-0.1*t)+1;
    fit = utils.expon_fit(t, G, 100);
    actSolution = -0.1;
    verifyEqual(testCase,fit.b, actSolution, 'AbsTol', 0.01)
end

function testExponFitLimit(testCase)
    % Test baseline for (uncrticially) damped case
    % Find first time peak of e^(-0.1t)cos(0.5t) is within 1% of 0.
    % Need t_min, s.t. G<0.001 of 0, after the final peak>0.001
    % i.e. first G<0.001, after final |e^(-0.1t)cos(0.5t)|>0.001, cos(0.5t)=1
    % => t_min = 49.87 (determined using plot)
    t = 0:0.01:200;
    G = (20000*exp(-0.1*t)+1).*cos(0.5*t);
    fit = utils.expon_fit(t, G, 100);
    actSolution = -0.1;
    verifyEqual(testCase,fit.b, actSolution, 'AbsTol', 0.01)
end