rootdir = './trial/';

opts.parallel.flag = true;
opts.parallel.ncores = 12;

opts.perf.MaxPerf = true;          % True if Y is a performance measure to maximize, False if it is a cost measure to minimise.
opts.perf.AbsPerf = true;           % True if an absolute performance measure, False if a relative performance measure
opts.perf.epsilon = 0.8;           % Threshold of good performance
opts.perf.betaThreshold = 0.5;     % Beta-easy threshold
opts.auto.preproc = true;           % Automatic preprocessing on. Set to false if you don't want any preprocessing
opts.bound.flag = true;             % Bound the outliers. True if you want to bound the outliers, false if you don't
opts.norm.flag = true;              % Normalize/Standarize the data. True if you want to apply Box-Cox and Z transformations to stabilize the variance and scale N(0,1)

opts.selvars.smallscaleflag = false; % True if you want to do a small scale experiment with a percentage of the available instances
opts.selvars.smallscale = 0.30;     % Percentage of instances to be kept for a small scale experiment
% You can also provide a file with the indexes of the instances to be used.
% This should be a csvfile with a single column of integer numbers that
% should be lower than the number of instances
opts.selvars.fileidxflag = true;
opts.selvars.fileidx = 'Instance_Indices_With_Good_Threshold_0.8_28_Algorithms.csv';
opts.selvars.densityflag = false;
opts.selvars.mindistance = 0.3;
opts.selvars.type = 'Ftr&Good';

opts.sifted.flag = true;            % Automatic feature selectio on. Set to false if you don't want any feature selection.
opts.sifted.rho = 0.6;              % Minimum correlation value acceptable between performance and a feature. Between 0 and 1
opts.sifted.K = 10;                 % Number of final features. Ideally less than 10.
opts.sifted.NTREES = 50;            % Number of trees for the Random Forest (to determine highest separability in the 2-d projection)
opts.sifted.MaxIter = 10;
opts.sifted.Replicates = 10;

opts.pilot.analytic = false;        % Calculate the analytical or numerical solution
opts.pilot.ntries = 30;              % Number of attempts carried out by PBLDR

opts.cloister.pval = 0.05;
opts.cloister.cthres = 0.7;

opts.pythia.cvfolds = 5;
opts.pythia.ispolykrnl = false;
opts.pythia.useweights = false;
opts.pythia.uselibsvm = false;

opts.trace.usesim = true;           % Use the actual or simulated data to calculate the footprints
opts.trace.PI = 0.55;               % Purity threshold

opts.outputs.csv = true;            %
opts.outputs.web = false;            % NOTE: MAKE THIS FALSE IF YOU ARE USING THIS CODE LOCALY - This flag is only useful if the system is being used 'online' through matilda.unimelb.edu.au
opts.outputs.png = true;            %

% Saving all the information as a JSON file
fid = fopen([rootdir 'options.json'],'w+');
fprintf(fid,'%s',jsonencode(opts));
fclose(fid);

datafile = [rootdir 'metadata.csv'];
optsfile = [rootdir 'options.json'];
opts = jsondecode(fileread(optsfile));
optfields = fieldnames(opts);
for i = 1:length(optfields)
    disp(optfields{i});
    disp(opts.(optfields{i}));
end
useparallel = isfield(opts,'parallel') && isfield(opts.parallel,'flag') && opts.parallel.flag;
if useparallel
    disp('-------------------------------------------------------------------------');
    disp('-> Starting parallel processing pool.');
    delete(gcp('nocreate'));
    if  isfield(opts.parallel,'ncores') && isnumeric(opts.parallel.ncores)
        mypool = parpool('local',opts.parallel.ncores,'SpmdEnabled',false);
    else
        mypool = parpool('local','SpmdEnabled',false);
    end
    if ispc
        addAttachedFiles(mypool,{'svmpredict.mexw64','svmtrain.mexw64'});
    elseif isunix
        addAttachedFiles(mypool,{'svmpredict.mexa64','svmtrain.mexa64'});
    elseif ismac
        addAttachedFiles(mypool,{'libsvmpredict.mexmaci64','libsvmtrain.mexmaci64'});
    end
end

Xbar = readtable(datafile);
varlabels = Xbar.Properties.VariableNames;
isname = strcmpi(varlabels,'instances');
isfeat = strncmpi(varlabels,'feature_',8);
isalgo = strncmpi(varlabels,'algo_',5);
issource = strcmpi(varlabels,'source');
model.data.instlabels = Xbar{:,isname};

if isnumeric(model.data.instlabels)
    model.data.instlabels = num2cell(model.data.instlabels);
    model.data.instlabels = cellfun(@(x) num2str(x),model.data.instlabels,'UniformOutput',false);
end
if any(issource)
    model.data.S = categorical(Xbar{:,issource});
end
model.data.X = Xbar{:,isfeat};
model.data.Y = Xbar{:,isalgo};
model.data.featlabels = varlabels(isfeat);
if isfield(opts,'selvars') && isfield(opts.selvars,'feats')
    disp('-------------------------------------------------------------------------');
    msg = '-> Using the following features: ';
    isselfeat = false(1,length(model.data.featlabels));
    for i=1:length(opts.selvars.feats)
        isselfeat = isselfeat | strcmp(model.data.featlabels,opts.selvars.feats{i});
        msg = [msg opts.selvars.feats{i} ' ']; %#ok<AGROW>
    end
    disp(msg);
    model.data.X = model.data.X(:,isselfeat);
    model.data.featlabels = model.data.featlabels(isselfeat);
end

model.data.algolabels = varlabels(isalgo);
if isfield(opts,'selvars') && isfield(opts.selvars,'algos')
    disp('-------------------------------------------------------------------------');
    msg = '-> Using the following algorithms: ';
    isselalgo = false(1,length(model.data.algolabels));
    for i=1:length(opts.selvars.algos)
        isselalgo = isselalgo | strcmp(model.data.algolabels,opts.selvars.algos{i});
        msg = [msg opts.selvars.algos{i} ' ']; %#ok<AGROW>
    end
    disp(msg);
    model.data.Y = model.data.Y(:,isselalgo);
    model.data.algolabels = model.data.algolabels(isselalgo);
end
% nalgos = size(model.data.Y,2);
% -------------------------------------------------------------------------
% PROBABLY HERE SHOULD DO A SANITY CHECK, I.E., IS THERE TOO MANY NANS?
idx = all(isnan(model.data.X),2) | all(isnan(model.data.Y),2);
if any(idx)
    warning('-> There are instances with too many missing values. They are being removed to increase speed.');
    model.data.X = model.data.X(~idx,:);
    model.data.Y = model.data.Y(~idx,:);
    model.data.instlabels = model.data.instlabels(~idx);
    if isfield(model.data,'S')
        model.data.S = model.data.S(~idx);
    end
end
idx = mean(isnan(model.data.X),1)>=0.20; % These features are very weak.
if any(idx)
    warning('-> There are features with too many missing values. They are being removed to increase speed.');
    model.data.X = model.data.X(:,~idx);
    model.data.featlabels = model.data.featlabels(~idx);
end
ninst = size(model.data.X,1);
nuinst = size(unique(model.data.X,'rows'),1);
if nuinst/ninst<0.5
    warning('-> There are too many repeated instances. It is unlikely that this run will produce good results.');
end
% -------------------------------------------------------------------------
% Storing the raw data for further processing, e.g., graphs
model.data.Xraw = model.data.X;
model.data.Yraw = model.data.Y;
% -------------------------------------------------------------------------
% Removing the template data such that it can be used in the labels of
% graphs and figures.
model.data.featlabels = strrep(model.data.featlabels,'feature_','');
model.data.algolabels = strrep(model.data.algolabels,'algo_','');
% -------------------------------------------------------------------------
% Running PRELIM as to pre-process the data, including scaling and bounding
opts.prelim = opts.perf;
opts.prelim.bound = opts.bound.flag;
opts.prelim.norm = opts.norm.flag;
[model.data.X,model.data.Y,model.data.Ybest,...
    model.data.Ybin,model.data.P,model.data.numGoodAlgos,...
    model.data.beta,model.prelim] = PRELIM(model.data.X, model.data.Y, opts.prelim);

idx = all(~model.data.Ybin,1);
if any(idx)
    warning('-> There are algorithms with no ''good'' instances. They are being removed to increase speed.');
    model.data.Yraw = model.data.Yraw(:,~idx);
    model.data.Y = model.data.Y(:,~idx);
    model.data.Ybin = model.data.Ybin(:,~idx);
    model.data.algolabels = model.data.algolabels(~idx);
    nalgos = size(model.data.Y,2);
    if nalgos==0
        error('-> There are no ''good'' algorithms. Please verify the binary performance measure. STOPPING!')
    end
end

ninst = size(model.data.X,1);
%fractional = isfield(opts,'selvars') && ...
%             isfield(opts.selvars,'smallscaleflag') && ...
%             opts.selvars.smallscaleflag && ...
%             isfield(opts.selvars,'smallscale') && ...
%             isfloat(opts.selvars.smallscale);
fractional = 0;
fileindexed = isfield(opts,'selvars') && ...
              isfield(opts.selvars,'fileidxflag') && ...
              opts.selvars.fileidxflag && ...
              isfield(opts.selvars,'fileidx') && ...
              isfile(opts.selvars.fileidx);
bydensity = isfield(opts,'selvars') && ...
            isfield(opts.selvars,'densityflag') && ...
            opts.selvars.densityflag && ...
            isfield(opts.selvars,'mindistance') && ...
            isfloat(opts.selvars.mindistance) && ...
            isfield(opts.selvars,'type') && ...
            ischar(opts.selvars.type);
if fractional
    disp(['-> Creating a small scale experiment for validation. Percentage of subset: ' ...
        num2str(round(100.*opts.selvars.smallscale,2)) '%']);
    state = rng;
    rng('default');
    aux = cvpartition(ninst,'HoldOut',opts.selvars.smallscale);
    rng(state);
    subsetIndex = aux.test;
elseif fileindexed
    disp('-> Using a subset of the instances.');
    subsetIndex = false(size(model.data.X,1),1);
    aux = table2array(readtable(opts.selvars.fileidx));
    aux(aux>ninst) = [];
    subsetIndex(aux) = true;
elseif bydensity
    disp('-> Creating a small scale experiment for validation based on density.');
    subsetIndex = FILTER(model.data.X, model.data.Y, model.data.Ybin, ...
                         opts.selvars);
    subsetIndex = ~subsetIndex;
    disp(['-> Percentage of instances retained: ' ...
          num2str(round(100.*mean(subsetIndex),2)) '%']);
else
    disp('-> Using the complete set of the instances.');
    subsetIndex = true(ninst,1);
end

if fileindexed || fractional || bydensity
    if bydensity
        model.data_dense = model.data;
    end
    model.data.X = model.data.X(subsetIndex,:);
    model.data.Y = model.data.Y(subsetIndex,:);
    model.data.Xraw = model.data.Xraw(subsetIndex,:);
    model.data.Yraw = model.data.Yraw(subsetIndex,:);
    model.data.Ybin = model.data.Ybin(subsetIndex,:);
    model.data.beta = model.data.beta(subsetIndex);
    model.data.numGoodAlgos = model.data.numGoodAlgos(subsetIndex);
    model.data.Ybest = model.data.Ybest(subsetIndex); 
    model.data.P = model.data.P(subsetIndex);
    model.data.instlabels = model.data.instlabels(subsetIndex);
    if isfield(model.data,'S')
        model.data.S = model.data.S(subsetIndex);
    end
end
nfeats = size(model.data.X,2);
% -------------------------------------------------------------------------
% Automated feature selection.
% Keep track of the features that have been removed so we can use them
% later
model.featsel.idx = 1:nfeats;
if opts.sifted.flag
    disp('=========================================================================');
    disp('-> Calling SIFTED for auto-feature selection.');
    disp('=========================================================================');
    [model.data.X, model.sifted] = SIFTED(model.data.X, model.data.Y, model.data.Ybin, opts.sifted);
    model.data.featlabels = model.data.featlabels(model.sifted.selvars);
    model.featsel.idx = model.featsel.idx(model.sifted.selvars);

    if bydensity
        disp('-> Creating a small scale experiment for validation based on density.');
        % model.data.featlabels = model.data_dense.featlabels(model.sifted.selvars);
        subsetIndex = FILTER(model.data_dense.X(:,model.featsel.idx), ...
                             model.data_dense.Y, ...
                             model.data_dense.Ybin, ...
                             opts.selvars);
        subsetIndex = ~subsetIndex;
        model.data.X = model.data_dense.X(subsetIndex,model.featsel.idx);
        model.data.Y = model.data_dense.Y(subsetIndex,:);
        model.data.Xraw = model.data_dense.Xraw(subsetIndex,:);
        model.data.Yraw = model.data_dense.Yraw(subsetIndex,:);
        model.data.Ybin = model.data_dense.Ybin(subsetIndex,:);
        model.data.beta = model.data_dense.beta(subsetIndex);
        model.data.numGoodAlgos = model.data_dense.numGoodAlgos(subsetIndex);
        model.data.Ybest = model.data_dense.Ybest(subsetIndex);
        model.data.P = model.data_dense.P(subsetIndex);
        model.data.instlabels = model.data_dense.instlabels(subsetIndex);
        if isfield(model.data_dense,'S')
            model.data.S = model.data_dense.S(subsetIndex);
        end
        disp(['-> Percentage of instances retained: ' ...
              num2str(round(100.*mean(subsetIndex),2)) '%']);
    end
end

MA2D = model;
MA2D.pilot =  PILOT(model.data.X, model.data.Y, model.data.featlabels, opts.pilot);
MA3D = model;
MA3D.pilot = PILOT2(model.data.X, model.data.Y, model.data.featlabels, opts.pilot);

MA3D.cloist = CLOISTER(MA3D.data.X, MA3D.pilot.A, opts.cloister);

MA3D.pythia = PYTHIA(MA3D.pilot.Z, MA3D.data.Yraw, MA3D.data.Ybin, MA3D.data.Ybest, MA3D.data.algolabels, opts.pythia);

MA3D.trace = TRACE2(MA3D.pilot.Z, MA3D.data.Ybin, MA3D.data.P, MA3D.data.beta, MA3D.data.algolabels, opts.trace);


MA3D1A.pilot = PILOTNoB(MA3D.pilot.Z, MA3D.data.Y(:,(1:14)*4 -3), {'z_{1}','z_{2}','z_{3}'}, opts.pilot);
MA3D1B.pilot = PILOTNoB(MA3D.pilot.Z, MA3D.data.Y(:,(1:14)*4 -2),{'z_{1}','z_{2}','z_{3}'}, opts.pilot);
MA3D1C.pilot = PILOTNoB(MA3D.pilot.Z, MA3D.data.Y(:,(1:14)*4 -1),{'z_{1}','z_{2}','z_{3}'}, opts.pilot);
MA3D1D.pilot = PILOTNoB(MA3D.pilot.Z, MA3D.data.Y(:,(1:14)*4), {'z_{1}','z_{2}','z_{3}'}, opts.pilot);

MA3D1A.pilot.A(3,:) = cross(MA3D1A.pilot.A(1,:),MA3D1A.pilot.A(2,:));
MA3D1B.pilot.A(3,:) = cross(MA3D1B.pilot.A(1,:),MA3D1B.pilot.A(2,:));
MA3D1C.pilot.A(3,:) = cross(MA3D1C.pilot.A(1,:),MA3D1C.pilot.A(2,:));
MA3D1D.pilot.A(3,:) = cross(MA3D1D.pilot.A(1,:),MA3D1D.pilot.A(2,:));


MA2D.cloist = CLOISTER(MA2D.data.X, MA2D.pilot.A, opts.cloister);
MA2D.pythia = PYTHIA(MA2D.pilot.Z, MA2D.data.Yraw, MA2D.data.Ybin, MA2D.data.Ybest, MA2D.data.algolabels, opts.pythia);
MA2D.trace = TRACE(MA2D.pilot.Z, MA2D.data.Ybin, MA2D.data.P, MA2D.data.beta, MA2D.data.algolabels, opts.trace);
MA2D.trace2 = TRACE2(MA2D.pilot.Z, MA2D.data.Ybin, MA2D.data.P, MA2D.data.beta, MA2D.data.algolabels, opts.trace);

%latex(MA2D.trace2.summary)

IND = MA3D.trace.summary(:,1);
Density2D1 = MA2D.trace.summary(:,5);
Area2D1 = MA2D.trace.summary(:,3);
Purity2D1 = MA2D.trace.summary(:,6);

Density2D2 = MA2D.trace2.summary(:,5);
Area2D2 = MA2D.trace2.summary(:,3);
Purity2D2 = MA2D.trace2.summary(:,6);

Density3D = MA3D.trace.summary(:,5);
Volume = MA3D.trace.summary(:,3);
Purity3D = MA3D.trace.summary(:,6);

areaTable = table;

areaTable.Algorithm = IND;
areaTable.Density2D = Density2D1;
areaTable.Area2D = Area2D1;
areaTable.Purity2D = Purity2D1;

areaTable.Density2DNewTrace = Density2D2;
areaTable.Area2DNewTrace = Area2D2;
areaTable.Purity2DNewTrace = Purity2D2;

areaTable.Density3D = Density3D;
areaTable.Volume3D = Volume;
areaTable.Purity3D = Purity3D;

writetable(areaTable,"areaTable.csv")


