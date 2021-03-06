function [msg,nextIterate,direction,FunEval] = nextfeasible(ObjFunc,nonlcon,Xin,sites,Iterate,A,LB,UB ...
    ,FunEval,maxFun,Completepoll,TolBind,IndEqcstr,NotVectorized,Cache,cachetol,cachelimit,conFcnArg,varargin)
%NEXTFEASIBLE Finds next feasible iterate in a POLL step.
% 	This function is private to POLL and SEARCH functions.
% 	
% 	OBJFUNC: The objective function on which POLL step is implemented.
% 	
% 	SITES: A set of design points generated by POLL technique. We would like
% 	to test the function at these sites hoping that one of them have less 
% 	function value than the current iterate. 
% 	
% 	ITERATE: Incumbent point around which polling will be done. Iterate Stores 
% 	the current point 'x' and function value 'f' at this point.
% 	
% 	A,LB,UB: Defines the feasible region in case of linear/bound
% 	constraints as LB<=A*X<=UB.
% 	
% 	FUNEVAL: Counter for number of function evaluations. FunEval is always less than 
% 	'MAXFUN', which is maximum number of function evaluation.
% 	
% 	MAXFUN: Limit on number of function evaluation 
% 	
% 	COMPLETEPOLL: If 'off' indicates that POLL can be called off as soon 
% 	as a better point is found i.e. no sufficient decrease condition is imposed; 
% 	If 'on' then ALL the points are evaluated and point with least function value 
% 	is returned. Default is 'off'. If function is expensive, make this 'off'
% 	
% 	TOLBIND: Tolerance used for determining a feasible point
% 	
% 	IndEqcstr: Logical indices of inequality constraints. A(IndIneqcstr), LB(IndIneqcstr)
% 	UB(IndIneqcstr) represents inequality constraints.
% 	
% 	NotVectorized: A flag indicating ObjFunc is not evaluated as vectorized
% 	
% 	CACHE: A flag for using CACHE. If 'off', no cache is used.
% 	
% 	CACHETOL: Tolerance used in cache in order to determine whether two points 
% 	are same or not
% 	
% 	CACHELIMIT: Limit the cache size to 'cachelimit'. 
% 	
% 	MSG: A binary flag indicating, whether a better iterate is found or not 
% 	
% 	NEXTITERATE: Successful iterate after polling is done. If POLL is NOT
% 	successful, NEXTITERATE is same as ITERATE.
% 	
% 	DIRECTION: Successful POLL direction. This information can be used 
% 	by POLL techniques in ordering the search direction (last successful
% 	direction can be polled first)
% 	
% 	Example:
% 	If there are 4 points in 2 dimension space then 
%    X is     [2  1  9 -2
%              0  1 -4  5]

%   Copyright 2003-2007 The MathWorks, Inc.


direction= 0;
msg = 0;
nextIterate = Iterate;
if (isempty(sites))    %No design sites to evaluate
    return
end
feasible =true;
constr = ~isempty(A);
nonlinconstr = ~isempty(nonlcon);
%maxeval will make sure that we respect this limit on function evaluation.
maxeval = min(length(sites),maxFun-FunEval);
if NotVectorized
    for k = 1:maxeval
        %Initialize the default function value to Inf.
        sites(k).f = inf;
        if constr
            feasible  = isfeasible(sites(k).x,A,LB,UB,TolBind,IndEqcstr);
        end
        %Calculate nonlinear constraints if linear constraints and bounds
        %are satisfied
        if feasible && nonlinconstr
            [cineq,ceq] = feval(nonlcon,reshapeinput(Xin,sites(k).x),conFcnArg{:});
            cineq = max(cineq); ceq = max(abs(ceq));
            feasible = cineq <= TolBind & ceq < TolBind;
        end
        if feasible % All the constraints are satisfied
            [sites(k).f,count] = funevaluate(ObjFunc,Xin,sites(k).x,Cache,cachetol,cachelimit,varargin{:});
            FunEval = FunEval+count;
            if(nextIterate.f > sites(k).f)
                nextIterate.x = sites(k).x;
                nextIterate.f = sites(k).f;
                % Update the constraint function value
                if nonlinconstr
                    nextIterate.cineq = cineq;
                    nextIterate.ceq = ceq;
                end
                direction =k;
                msg =1;
                if strcmpi(Completepoll,'off')
                    return;
                end
            end  % end comparison nextIterate and sites(k)
        end    % end isfeasible
    end      % end FOR loop
elseif strcmpi(Completepoll,'on')  % vectorized is 'on', Completepoll MUST be 'on' too
    Xfeas = [sites(:).x];
    feasible = true(size(Xfeas,2),1);
    % we must check all the points for feasibility before evaluating them
    if constr
        [Xfeas,feasible] = allfeasible([sites(1:maxeval).x],A,LB,UB,TolBind,IndEqcstr);
    end
    % calculate nonlinear constraints only if linear constraints and bounds
    % are satisfied
    if nonlinconstr && any(feasible)
        for k = 1:length(feasible)
            if feasible(k) % Linear constraints are satisfied
                [cineq,ceq] = feval(nonlcon,reshapeinput(Xin,sites(k).x),conFcnArg{:});
                cineq = max(cineq); ceq = max(abs(ceq));
                feasible(k) = cineq <= TolBind & ceq < TolBind;
                % Update the maximum constraint violation value
                if cineq < cineqval
                   cineqval = cineq;
                end
            end
        end
        Xfeas = [sites(feasible).x];
    end
    [f,count] = funevaluate(ObjFunc,Xin,Xfeas,Cache,cachetol,cachelimit,varargin{:});
    maxeval = size(Xfeas,2);
    FunEval = FunEval+count;
    for i =1:maxeval
        sites(i).x = Xfeas(:,i);
        sites(i).f = f(i);
        if (nextIterate.f > sites(i).f)
            nextIterate.x  = sites(i).x;
            nextIterate.f  = sites(i).f;
            % Update the constraint function value
            direction = i;
            msg =1;
        end
    end
    % offset direction to match the right order
        direction = direction + (length(feasible) - nnz(feasible));
end




