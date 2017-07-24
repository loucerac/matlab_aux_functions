function [h, status, cmd] = export_vector_pdf(file_name, h)
%EXPORT_VECTOR_PDF Create a fully vectorized PDF

% NOTE: requires a functional x64 Inkscape installation in order to build
%   a PDf with transparencies.

% INPUT:
% file_name: string: output base name
% h: figure handle: figure to be exported
%
% OUTPUT:
% h: figure handle
% status: int: OS CLI status code
% cmd: string: OS system CLI command output

% Carlos Loucera, University of Cantabria, 2017

% build file_names
svg_out = sprintf('%s.svg', file_name);
pdf_out = sprintf('%s.pdf', file_name);

try
    %TODO: read the path from an external configuration file
    % inkscape command line
    exe = '"C:\Program Files\Inkscape\inkscape.exe"';
    args = sprintf('%s --export-area-drawing --export-pdf=%s', svg_out, pdf_out);

    % save as .svg (fully vectorized, supports tranparency)
    saveas(h, svg_out)

    % execute inkscape
    cli_str = sprintf('%s %s', exe, args);
    system(cli_str);

    % delete temporary files
    delete(svg_out)
catch
    % Pure MATLAB (extremely big file size for 3D and image-like figures)
    % No transparency allowed
    set(h,'Units','Inches');
    pos = get(h,'Position');
    set(h,...
        'PaperPositionMode', 'Auto', 'PaperUnits', 'Inches',...
        'PaperSize',[pos(3), pos(4)])
    set(h, 'renderer', 'painter')
    print(h, pdf_out,'-dpdf','-r0')
end

% crop pdf
[status, cmd] = crop(pdf_out);
