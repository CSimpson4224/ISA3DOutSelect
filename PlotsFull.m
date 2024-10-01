rootdir = './plots/';

scriptfcnThreeD;
f = figure();
f.Position(3:4) = [900 2000];
T = tiledlayout(7,1,TileSpacing="tight",Padding="tight");
title(T,'3D Instance Space Projections')
countn =1;
for i = 1:7
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
print(gcf,'-dpng',[rootdir '3DfootprintPT1.png'],'-r500');


f = figure();
f.Position(3:4) = [900 2000];
T = tiledlayout(7,1,TileSpacing="tight",Padding="tight");
title(T,'3D Instance Space Projections')
countn =1;
for i = 8:14
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
print(gcf,'-dpng',[rootdir '3DfootprintPT2.png'],'-r500');



scriptfcn;
f = figure();
f.Position(3:4) = [900 2000];
T = tiledlayout(7,1,TileSpacing="tight",Padding="tight");
title(T,'2D Instance Space Projections')
countn =1;
for i = 1:7
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
print(gcf,'-dpng',[rootdir '2DfootprintTRACEBOTHPT1.png'],'-r500');


scriptfcn;
f = figure();
f.Position(3:4) = [900 2000];
T = tiledlayout(7,1,TileSpacing="tight",Padding="tight");
title(T,'2D Instance Space Projections')
countn =1;
for i = 8:14
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
hold on
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
print(gcf,'-dpng',[rootdir '2DfootprintTRACEBOTHPT2.png'],'-r500');