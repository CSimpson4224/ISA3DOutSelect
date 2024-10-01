rootdir = './plots/';

scriptfcnThreeD;
f = figure();
f.Position(3:4) = [1500 1500];
T = tiledlayout(4,1,TileSpacing="tight",Padding="tight");
title(T,'3D Instance Space Projections')
countn =1;
for i = [2 3 6 11]
    t = tiledlayout(T,1,4,TileSpacing="tight",Padding="tight");
    t.Layout.TileSpan = [1 1];
    t.Layout.Tile = countn;
    nam = split(MA3D.data.algolabels{i*4 -3},"_");
    if nam{1} == "FAST"
        nam{1} = "FAST ABOD";
    end
    ylabel(t,nam{1});
    nexttile(t)
    if i==2
        title('Mean SD') 
    end
    nam = split(MA3D.data.algolabels{i},"_");
    ylabel(nam{1})
    drawGoodBadFootprint(MA3D.pilot.Z, ...
                     MA3D.trace.good{i*4 -3}, ...
                     MA3D.data.Ybin(:,i*4 -3), ...
                     strrep(MA3D.data.algolabels{i*4 -3},'_',' '));
    view(MA3D1A.pilot.A(3,:))
    grid on
    nexttile(t)
    if i==2
        title('Median IQR')
    end
    drawGoodBadFootprint(MA3D.pilot.Z, ...
                     MA3D.trace.good{i*4 -2}, ...
                     MA3D.data.Ybin(:,i*4 -2), ...
                     strrep(MA3D.data.algolabels{i*4 -2},'_',' '));
    view(MA3D1B.pilot.A(3,:))
    grid on
    nexttile(t)
    if i==2
        title('Median MAD') 
    end
    drawGoodBadFootprint(MA3D.pilot.Z, ...
                     MA3D.trace.good{i*4 -1}, ...
                     MA3D.data.Ybin(:,i*4 -1), ...
                     strrep(MA3D.data.algolabels{i*4 -1},'_',' '));
    view(MA3D1C.pilot.A(3,:))
    grid on
    nexttile(t)
    if i==2
        title('Min Max')
    end
    drawGoodBadFootprint(MA3D.pilot.Z, ...
                     MA3D.trace.good{i*4}, ...
                     MA3D.data.Ybin(:,i*4), ...
                     strrep(MA3D.data.algolabels{i*4 },'_',' '));
    view(MA3D1D.pilot.A(3,:))
    grid on
    countn = countn +1;
end
hold on
clear qw
qw{2} = line(nan,nan, 'LineStyle', 'none', ...
                               'Marker', '.', ...
                               'Color', [1.0 0.6471 0.0], ...
                               'MarkerFaceColor', [1.0 0.6471 0.0], ...
                               'MarkerSize', 10);
qw{1} = line(nan,nan, 'LineStyle', 'none', ...
                               'Marker', '.', ...
                               'Color',  [0.0 0.0 1.0], ...
                               'MarkerFaceColor',  [0.0 0.0 1.0], ...
                               'MarkerSize', 10);
qw{3} =   patch([0 0],[0 0], [0 0 1], 'EdgeColor','none', 'FaceAlpha', 0.4);
%qw{4} = patch([0 0],[0 0], [1 0 0], 'EdgeColor','none', 'FaceAlpha', 0.4);
hold off
lgd = legend([qw{:}],{'Good','Bad','Footprint'}, 'Orientation', 'Horizontal');
lgd.Layout.Tile = 'south';
print(gcf,'-dpng',[rootdir '3DfootprintLimited.png'],'-r500');

if ~exist("Xaux1")
    Xaux1 = (MA2D.data.X-min(MA2D.data.X,[],1))./range(MA2D.data.X,1);
    Xaux2 = (MA3D.data.X-min(MA3D.data.X,[],1))./range(MA3D.data.X,1);
end
scriptfcnThreeD;
f = figure();
f.Position(3:4) = [2500 700];
t = tiledlayout(2,5,TileSpacing="tight",Padding="tight");
%title(t,'3D Instance Space Features')
for i=1:nfeats
    %clf;
    nexttile
    drawScatter(MA3D.pilot.Z, Xaux2(:,i),...
                strrep(MA3D.data.featlabels{i},'_',' '));
    % line(model.cloist.Zedge(:,1), model.cloist.Zedge(:,2), 'LineStyle', '-', 'Color', 'r');
    
end
print(gcf,'-dpng',[rootdir 'distribution_feature_3D.png'],'-r500');


scriptfcn;
f = figure();
f.Position(3:4) = [2500 700];
t = tiledlayout(2,5,TileSpacing="tight",Padding="tight");
%title(t,'3D Instance Space Features')
for i=1:nfeats
    %clf;
    nexttile
    drawScatter(MA2D.pilot.Z, Xaux1(:,i),...
                strrep(MA3D.data.featlabels{i},'_',' '));
    % line(model.cloist.Zedge(:,1), model.cloist.Zedge(:,2), 'LineStyle', '-', 'Color', 'r');
    
end
print(gcf,'-dpng',[rootdir 'distribution_feature_2D.png'],'-r500');



f = figure();
f.Position(3:4) = [1100 2500];
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
    drawScatter(MA2D.pilot.Z, Xaux1(:,i),...
                strrep(MA2D.data.featlabels{i},'_',' '));
    % line(model.cloist.Zedge(:,1), model.cloist.Zedge(:,2), 'LineStyle', '-', 'Color', 'r');
    
end
scriptfcnThreeD;
t = tiledlayout(T,5,2,TileSpacing="tight",Padding="tight");
title(t,'3D Instance Space Features')
for i=1:nfeats
    t.Layout.TileSpan = [1 1];
    t.Layout.Tile = 2;
    nexttile(t)
    drawScatter(MA3D.pilot.Z, Xaux2(:,i),...
                strrep(MA3D.data.featlabels{i},'_',' '));
    % line(model.cloist.Zedge(:,1), model.cloist.Zedge(:,2), 'LineStyle', '-', 'Color', 'r');
    
end
cbar = colorbar();
cbar.Layout.Tile = 'east';
print(gcf,'-dpng',[rootdir 'distribution_feature_2D&3D.png'],'-r500');



scriptfcn;
f = figure();
f.Position(3:4) = [1500 1500];
T = tiledlayout(4,1,TileSpacing="tight",Padding="tight");
title(T,'2D Instance Space Projections')
countn =1;
for i = [2 3 6 11]
    t = tiledlayout(T,1,4,TileSpacing="tight",Padding="tight");
    t.Layout.TileSpan = [1 1];
    t.Layout.Tile = countn;
    nam = split(MA2D.data.algolabels{i*4 -3},"_");
    if nam{1} == "FAST"
        nam{1} = "FAST ABOD";
    end
    ylabel(t,nam{1});
    nexttile(t)
    if i==2
        title('Mean SD') 
    end
    nam = split(MA2D.data.algolabels{i},"_");
    drawGoodBadFootprint(MA2D.pilot.Z, ...
                     MA2D.trace.good{i*4 -3}, ... 
                     MA2D.trace2.good{i*4 -3}, ...
                     MA2D.data.Ybin(:,i*4 -3), ...
                     strrep(MA2D.data.algolabels{i*4 -3},'_',' '));
    grid on
    nexttile(t)
    if i==2
        title('Median IQR')
    end
    drawGoodBadFootprint(MA2D.pilot.Z, ...
                     MA2D.trace.good{i*4 -2}, ... 
                     MA2D.trace2.good{i*4 -2}, ...
                     MA2D.data.Ybin(:,i*4 -2), ...
                     strrep(MA2D.data.algolabels{i*4 -2},'_',' '));
    grid on
    nexttile(t)
    if i==2
        title('Median MAD') 
    end
    drawGoodBadFootprint(MA2D.pilot.Z, ...
                     MA2D.trace.good{i*4 -1}, ... 
                     MA2D.trace2.good{i*4 -1}, ...
                     MA2D.data.Ybin(:,i*4 -1), ...
                     strrep(MA2D.data.algolabels{i*4 -1},'_',' '));
    grid on
    nexttile(t)
    if i==2
        title('Min Max')
    end
    drawGoodBadFootprint(MA2D.pilot.Z, ...
                     MA2D.trace.good{i*4}, ... 
                     MA2D.trace2.good{i*4}, ...
                     MA2D.data.Ybin(:,i*4), ...
                     strrep(MA2D.data.algolabels{i*4 },'_',' '));
    grid on
    countn = countn +1;
end
%"good","bad","TRACE","TRACENEW",'subset' 
%{'Bad','Good','Trace','Trace New'},
hold on
clear qw
qw{2} = line(nan,nan, 'LineStyle', 'none', ...
                               'Marker', '.', ...
                               'Color', [1.0 0.6471 0.0], ...
                               'MarkerFaceColor', [1.0 0.6471 0.0], ...
                               'MarkerSize', 10);
qw{1} = line(nan,nan, 'LineStyle', 'none', ...
                               'Marker', '.', ...
                               'Color',  [0.0 0.0 1.0], ...
                               'MarkerFaceColor',  [0.0 0.0 1.0], ...
                               'MarkerSize', 10);
qw{3} =   patch([0 0],[0 0], [0 0 1], 'EdgeColor','none', 'FaceAlpha', 0.4);
qw{4} = patch([0 0],[0 0], [1 0 0], 'EdgeColor','none', 'FaceAlpha', 0.4);
hold off
lgd = legend([qw{:}],{'Good','Bad','Trace','Trace2'}, 'Orientation', 'Horizontal');
lgd.Layout.Tile = 'south';
print(gcf,'-dpng',[rootdir '2DfootprintLimitedTRACEBOTH.png'],'-r500');





