clear;

load('./dataset/USPS.mat');

K = 10;

% configuration
seed.start = 1;
seed.end = 10;
interval = seed.end - seed.start + 1;

config.eign = 1;
config.clustering = 1;
config.nmi = 1;
config.cols = {'r','b','y','g','m','k','c','r','b','y'};

time_max = 0;
time_all_sum = 0;
time_construct_sum = 0;
time_kmeans_sum = 0;
time_eign_sum = 0; 

nmi_max = 0;
nmi_sum = 0;
ac_max = 0;
ac_sum = 0;

nmi_array = [];
ac_array = [];
time_array = [];

nmi_std = 0;
ac_std = 0;
time_std = 0;

for i = seed.start : seed.end    
    rand('seed',i);    
    fprintf('Seed No: %d\n',i);
    
%step 1: Construct the hypergraph  H matrix, using linear neighbour method
    opts.r = 3;
    opts.p = 1000;    
    opts.mode = 'kmeans';
    opts.kmMaxIter = 3;
    
    tic;
    H = pretreatmentLandmark(fea,opts);


%step 2: Construct Z matrix, which  W = ZZ^T
    [Z] =calAffinityMatrix(H);
    clear H;
    time_construct = toc;    
    fprintf('%f + ', time_construct);
    time_construct_sum = time_construct_sum + time_construct;
    
%step 3: Compute the eignvector of W
    eign_opts.mode = 1;
    eign_opts.l =100;
    eign_opts.samp_mode = 'k';
    tic;        
    [ U,S,~ ] = calEigenvector(Z,K,eign_opts);    
    time_eign = toc;        
    fprintf(' %f+ ', time_eign);
    time_eign_sum = time_eign_sum +time_eign;
    
%     clear Z;
    
%step 4: Perform kmeans
    tic;
    [label,~,~] = litekmeans(U,K,'MaxIter',100,'Replicates',10);
%    end_time = cputime - start_time;
    time_kmeans = toc;
    fprintf(' %f\n', time_kmeans);
    time_kmeans_sum = time_kmeans_sum + time_kmeans;

    label = bestMap(gnd,label);
    nmi_result = nmi(label,gnd);  
    ac_result = length(find(gnd == label))/length(gnd);
    
    clear U;
    
% Update record
    per_runtime = time_construct + time_eign + time_kmeans;
    fprintf('NMI: %f\n',nmi_result);
    fprintf('AC: %f\n',ac_result);
    fprintf('Runing Time: %f s\n\n\n', per_runtime);
 
    if (nmi_result > nmi_max)
        nmi_max = nmi_result;
    end    
    if (ac_result>ac_max)
        ac_max = ac_result;
    end    
    if (per_runtime >time_max)
        time_max = per_runtime;
    end
    nmi_array = [nmi_array, nmi_result];
    ac_array = [ac_array, ac_result];
    time_array = [time_array, per_runtime];
    
    nmi_sum = nmi_sum + nmi_result;
    ac_sum = ac_sum + ac_result;    
    time_all_sum = time_all_sum + per_runtime;
    clear ac_result nmi_result per_runtime time_construct time_kmeans time_eign;
end




nmi_avg = nmi_sum / interval;
ac_avg = ac_sum / interval;

time_eign_avg = time_eign_sum /interval;
time_kmeans_avg = time_kmeans_sum / interval;
time_construct_avg = time_construct_sum / interval;
time_avg = time_all_sum / interval;


ans_p_nmi = nmi_avg;
ans_p_ac = ac_avg;
ans_a_r = opts.r;
ans_a_l = opts.p;
nmi_std = std(nmi_array);
ac_std = std(ac_array);
time_std = std(time_array);


clear nmi_sum ac_sum time_eign_sum time_kmeans_sum time_construct_sum time_all_sum S;
clear ac_array ac_max_seed nmi_array nmi_max_seed time_array


disp('Algorithm Finished');



