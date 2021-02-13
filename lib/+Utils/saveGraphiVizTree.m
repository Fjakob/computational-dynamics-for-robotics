function html = saveGraphiVizTree(file, cmds)
indent = '  ';

dir = [what('ext_lib').path, filesep, 'js/'];

cmds = [{'rankdir=BT;', 'node [shape=box];'}, cmds];
cmds = cellfun(@(x) [repmat('  ', [1 4]), '''', x, ''' +'], cmds, ...
    'UniformOutput', false);
html = [{
    '<!DOCTYPE html>';
    '<html>';
    [indent, '<head>'];
    [indent, indent, '<meta charset="utf-8">'];
    [indent, '</head>'];
    [indent, '<body>'];
    [indent, indent, '<script src="', dir, 'viz.js"></script>'];
    [indent, indent, '<script src="', dir, 'full.render.js"></script>'];
    [indent, indent, '<script>'];
    [indent, indent, indent, 'var viz = new Viz();'];
    [indent, indent, indent, 'viz.renderSVGElement(''digraph CDR { '' +']};
    cmds'
    {
    [indent, indent, indent, '''}'')'];
    [indent, indent, indent, '.then(function(element) {'];
    [indent, indent, indent, indent, 'document.body', ...
    '.appendChild(element);'];
    [indent, indent, indent, '});'];
    [indent, indent, '</script>'];
    [indent, '</body>'];
    '</html>'
    }];

html = sprintf('%s\n', html{:});

if ~isempty(file)
    f = fopen(file, 'w');
    fprintf(f, '%s', html);
    fclose(f);
end
end