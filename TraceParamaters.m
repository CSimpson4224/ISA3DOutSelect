rootdir = './plots/';
opts.trace.usesim = true;          
opts.trace.PI = 0.6;
opts.trace.prior = [0.6,0.4];
opts.trace.nn = 50;


Tdefault = TRACE22(MA2D.pilot.Z, MA2D.data.Ybin(:,9), MA2D.data.P, MA2D.data.beta, MA2D.data.algolabels(9), opts);


opts.trace.nn = 10;
nnlow = TRACE22(MA2D.pilot.Z, MA2D.data.Ybin(:,9), MA2D.data.P, MA2D.data.beta, MA2D.data.algolabels(9), opts);
opts.trace.nn = 200;
nnhigh = TRACE22(MA2D.pilot.Z, MA2D.data.Ybin(:,9), MA2D.data.P, MA2D.data.beta, MA2D.data.algolabels(9), opts);

scriptfcnOG;
f = figure();
f.Position(3:4) = [1500 500];
t = tiledlayout(1,3,TileSpacing="tight",Padding="tight");
title(t,'FAST ABOD Mean SD, Prior = [0.6,0.4] PI = 0.6')
nexttile(t)
title("k = 10") 
drawGoodBadFootprint(MA2D.pilot.Z, ...
    nnlow.good{1}, ...
    MA2D.data.Ybin(:,9), ...
    strrep(MA2D.data.algolabels(9),'_',' '));
grid on

nexttile(t)
title( "k = 50") 
drawGoodBadFootprint(MA2D.pilot.Z, ...
    Tdefault.good{1}, ...
    MA2D.data.Ybin(:,9), ...
    strrep(MA2D.data.algolabels(9),'_',' '));
grid on

nexttile(t)
title("k = 200") 
drawGoodBadFootprint(MA2D.pilot.Z, ...
    nnhigh.good{1}, ...
    MA2D.data.Ybin(:,9), ...
    strrep(MA2D.data.algolabels(9),'_',' '));
grid on
clear qw
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
%qw{4} = patch([0 0],[0 0], [1 0 0], 'EdgeColor','none', 'FaceAlpha', 0.4);
hold off
lgd = legend([qw{:}],{'Good','Bad','Footprint'}, 'Orientation', 'Horizontal');
lgd.Layout.Tile = 'south';
print(gcf,'-dpng',[rootdir 'paramaterNN.png'],'-r500');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

opts.trace.nn = 50;

opts.trace.prior = [0.5,0.5];
priorlow = TRACE22(MA2D.pilot.Z, MA2D.data.Ybin(:,9), MA2D.data.P, MA2D.data.beta, MA2D.data.algolabels(9), opts);
opts.trace.prior = [0.8,0.2];
priorhigh = TRACE22(MA2D.pilot.Z, MA2D.data.Ybin(:,9), MA2D.data.P, MA2D.data.beta, MA2D.data.algolabels(9), opts);

f = figure();
f.Position(3:4) = [1500 500];
t = tiledlayout(1,3,TileSpacing="tight",Padding="tight");
title(t,'FAST ABOD Mean SD, k = 50 PI = 0.6')
nexttile(t)
title("Prior = [0.5,0.5]") 
drawGoodBadFootprint(MA2D.pilot.Z, ...
    priorlow.good{1}, ...
    MA2D.data.Ybin(:,9), ...
    strrep(MA2D.data.algolabels(9),'_',' '));
grid on

nexttile(t)
title( "Prior = [0.6,0.4]") 
drawGoodBadFootprint(MA2D.pilot.Z, ...
    Tdefault.good{1}, ...
    MA2D.data.Ybin(:,9), ...
    strrep(MA2D.data.algolabels(9),'_',' '));
grid on

nexttile(t)
title("Prior = [0.8,0.2]") 
drawGoodBadFootprint(MA2D.pilot.Z, ...
    priorhigh.good{1}, ...
    MA2D.data.Ybin(:,9), ...
    strrep(MA2D.data.algolabels(9),'_',' '));
grid on
clear qw
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
%qw{4} = patch([0 0],[0 0], [1 0 0], 'EdgeColor','none', 'FaceAlpha', 0.4);
hold off
lgd = legend([qw{:}],{'Good','Bad','Footprint'}, 'Orientation', 'Horizontal');
lgd.Layout.Tile = 'south';
print(gcf,'-dpng',[rootdir 'paramaterPrior.png'],'-r500');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i = 13;
opts.trace.prior = [0.6,0.4];

opts.trace.PI = 0.6;
Tdefault = TRACE22(MA2D.pilot.Z, MA2D.data.Ybin(:,i), MA2D.data.P, MA2D.data.beta, MA2D.data.algolabels(9), opts);

%opts.trace.prior = [0.4,0.6];
opts.trace.PI = 0.4;
puritylow = TRACE22(MA2D.pilot.Z, MA2D.data.Ybin(:,i), MA2D.data.P, MA2D.data.beta, MA2D.data.algolabels(9), opts);
%opts.trace.prior = [0.8,0.2];
opts.trace.PI = 0.8;
purityhigh = TRACE22(MA2D.pilot.Z, MA2D.data.Ybin(:,i), MA2D.data.P, MA2D.data.beta, MA2D.data.algolabels(9), opts);
opts.trace.prior = [0.8,0.2];
opts.trace.PI = 0.8;
purityhigh2 = TRACE22(MA2D.pilot.Z, MA2D.data.Ybin(:,i), MA2D.data.P, MA2D.data.beta, MA2D.data.algolabels(9), opts);


f = figure();
f.Position(3:4) = [1100 1500];
t = tiledlayout(2,2,TileSpacing="tight",Padding="tight");
title(t,'iForest Mean SD, k = 50 Prior = [0.6,0.4]')
nexttile(t)
title("PI = 0.4") 
drawGoodBadFootprint(MA2D.pilot.Z, ...
    puritylow.good{1}, ...
    MA2D.data.Ybin(:,9), ...
    strrep(MA2D.data.algolabels(9),'_',' '));
grid on

nexttile(t)
title( "PI = 0.6") 
drawGoodBadFootprint(MA2D.pilot.Z, ...
    Tdefault.good{1}, ...
    MA2D.data.Ybin(:,9), ...
    strrep(MA2D.data.algolabels(9),'_',' '));
grid on

nexttile(t)
title("PI = 0.8") 
drawGoodBadFootprint(MA2D.pilot.Z, ...
    purityhigh.good{1}, ...
    MA2D.data.Ybin(:,9), ...
    strrep(MA2D.data.algolabels(9),'_',' '));
grid on

nexttile(t)
title("PI = 0.8, Prior = [0.8,0.2]") 
drawGoodBadFootprint(MA2D.pilot.Z, ...
    purityhigh2.good{1}, ...
    MA2D.data.Ybin(:,9), ...
    strrep(MA2D.data.algolabels(9),'_',' '));
grid on
clear qw
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
%qw{4} = patch([0 0],[0 0], [1 0 0], 'EdgeColor','none', 'FaceAlpha', 0.4);
hold off
lgd = legend([qw{:}],{'Good','Bad','Footprint'}, 'Orientation', 'Horizontal');
lgd.Layout.Tile = 'south';
print(gcf,'-dpng',[rootdir 'paramaterPI.png'],'-r500');