function [status, cmdout] = crop(in_file, out_file, fmt)
%CROP Crop pdf and eps files without exiting MATLAB

% MATLAB wraper for pdfcrop and epstool
% CROP requires TexLive pdfcrop and epstool tools to be already installed

% AUTHOR: Carlos Loucera, University of  Cantabria, 2016

if nargin < 3
    fmt = 'pdf';
end
if nargin < 2
    out_file = in_file;
end

% check if file extension present

expr = sprintf('.*\\.%s', fmt);
if ~any(regexp(in_file, expr)); in_file = sprintf('%s.%s', in_file, fmt); end
if ~any(regexp(out_file, expr)); out_file = sprintf('%s.%s', out_file, fmt); end

switch fmt
    case 'eps'
        exe = 'epstool';
        args = ['--copy --bbox ', in_file, ' ', out_file];
    case 'pdf'
        exe = 'pdfcrop';
        args = [in_file, ' ', out_file];
end

cmd = [exe, ' ', args];
[status, cmdout] = system(cmd);
