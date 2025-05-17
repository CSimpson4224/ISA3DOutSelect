function draw_embedded_compass(ax, origin, length, labels, fz)
    if nargin < 4, labels = {'X','Y','Z'}; end
    hold(ax, 'on')
    quiver3(ax, origin(1), origin(2), origin(3), length, 0, 0, 0, 'r', 'LineWidth',1.5)
    quiver3(ax, origin(1), origin(2), origin(3), 0, length, 0, 0, 'g', 'LineWidth',1.5)
    quiver3(ax, origin(1), origin(2), origin(3), 0, 0, length, 0, 'b', 'LineWidth',1.5)

    text(ax, origin(1)+length*1.1, origin(2), origin(3), labels{1}, 'Color','r','FontSize',fz)
    text(ax, origin(1), origin(2)+length*1.1, origin(3), labels{2}, 'Color',[0 0.5 0],'FontSize',fz)
    text(ax, origin(1), origin(2), origin(3)+length*1.1, labels{3}, 'Color','b','FontSize',fz)
end