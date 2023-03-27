function [] = resire_PtNi_S(ind)

addpath('/u/home/s/shikamar/software/functions/')
pj_filename         = sprintf('proj_S%d.mat',ind);
angle_filename      = sprintf('angle_S%d.mat',ind);

results_filename    = 'output/RESIRE_experiment_result.mat';

RESIRE = RESIRE_Reconstructor();

RESIRE.filename_Projections    = pj_filename;
RESIRE.filename_Angles         = angle_filename ;
RESIRE.filename_Results        = results_filename;

RESIRE = RESIRE.set_parameters(...
    'oversamplingRatio' ,4    ,'numIterations'       ,200 ,... 
    'monitor_R'         ,true ,'monitorR_loopLength' ,20 ,... 
    'griddingMethod'    ,1    ,'vector3'             ,[1 0 0], ...
    'use_parallel'      ,1);

RESIRE = readFiles(RESIRE);
RESIRE = CheckPrepareData(RESIRE);
RESIRE = runGridding(RESIRE); 
RESIRE = reconstruct(RESIRE);

RESIRE = ClearCalcVariables(RESIRE);

recon = RESIRE.reconstruction;

save(sprintf('recon_S%d.mat',ind),'recon')
% SaveResults(RESIRE);
end