function [h, status, cmd] = export_vector_pdf(file_name, h)
%EXPORT_VECTOR_PDF

% build file_names
svg_out = sprintf('%s.svg', file_name);
pdf_out = sprintf('%s.pdf', file_name);
    
try
    % inkscape command line
    exe = '"C:\Program Files\Inkscape\inkscape.exe"';
    args = sprintf('%s --export-area-drawing --export-pdf=%s', svg_out, pdf_out);
    
    % save as .svg (fully vectorized, supports tranparency)
    saveas(gcf,svg_out)
    
    % execute inkscape
    system([exe ' ' args]);
    
    % delete temporary files
    delete([file_name '.svg'])
catch
    % Pure MATLAB (extremely big file size)
    set(h,'Units','Inches');
    pos = get(h,'Position');
    set(h,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
    set(h, 'renderer', 'painter')
    print(h,pdf_out,'-dpdf','-r0')
end

% crop pdf
[status, cmd] = crop(pdf_out);
