function [state, optnew,optchanged] = gaoutputoptions(options,state,flag)
%GAOUTPUTOPTIONS Display non default options settings.
%   STATE = GAOUTPUTOPTIONS(OPTIONS,STATE,FLAG) is used as a output
%   function for displaying which options parameters are not default.
%
%   Example:
%    Create an options structure that uses GAOUTPUTOPTIONS
%    as the output function
%     options = gaoptimset('outputfcns', @gaoutputoptions)

%   Copyright 2003-2004 The MathWorks, Inc.
 
% use the code generation tool to get the text to display
optnew = options;
optchanged = false;
if(strcmp(flag,'init'))
    code = generateCode(options)
end