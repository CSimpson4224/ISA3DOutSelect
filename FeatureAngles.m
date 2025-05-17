
angles = {};
for i =1:10
    temp =  PILOTNoB(MA3D.pilot.Z, MA3D.data.X(:,i), {'z_{1}','z_{2}','z_{3}'}, opts.pilot);
    angles{i} = cross(temp.A(1,:),temp.A(2,:));
end


f = figure();
f.Position = [0 0 1100 2500];
cbar = colorbar;
T = tiledlayout(1,2,TileSpacing="tight",Padding="tight");
%title(t,'3D Instance Space Features')
t = tiledlayout(T,5,2,TileSpacing="tight",Padding="tight");
title(t,'2D Instance Space Features')

scriptfcn;
for i= 1:nfeats
    %clf;
    
    t.Layout.TileSpan = [1 1];
    t.Layout.Tile = 1;
    nexttile(t)
    p = drawScatter(MA2D.pilot.Z, Xaux1(:,i),...
                strrep(MA2D.data.featlabels{i},'_',' '));
    % line(model.cloist.Zedge(:,1), model.cloist.Zedge(:,2), 'LineStyle', '-', 'Color', 'r');
    
end
scriptfcnThreeD;
t2 = tiledlayout(T,5,2,TileSpacing="tight",Padding="tight");
title(t2,'3D Instance Space Features')
for i=1:nfeats
    t2.Layout.TileSpan = [1 1];
    t2.Layout.Tile = 2;
    axs3D(i) = nexttile(t2);  % Capture the axes handle
    drawScatter(MA3D.pilot.Z, Xaux2(:,i),...
                strrep(MA3D.data.featlabels{i},'_',' '));
    view(angles{i});
    draw_embedded_compass(gca, [-0.9 -0.9 -0.9], 0.3, {'Z1','Z2','Z3'},8)
end
%nexttile(t,3)
cbar = colorbar;
cbar.Layout.Tile = 'east';
print(gcf,'-dpng',[rootdir 'distribution_feature_2D&3DRotated.png'],'-r250');




