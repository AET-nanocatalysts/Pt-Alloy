%% Main_3_all_para_collect
% collect all parameters and compile them into one file
% calculate the generalized coordination number, 
% elemental generalized coordination number, strain
% and other properties inside 

clear; clc; close all;
%%
sLat_arr_all = importdata('Pt_alloy_sLat_arr_3.mat');

weight_arr = (1:12).^2;

LED_cell = cell(17,1);
for a1 = 1:17
    
    sLat_arr = sLat_arr_all(a1);
    disp(num2str(a1));
    
    NNinds = sLat_arr.NNinds;
    NNnum = sLat_arr.NNnum;
    pixelSize = sLat_arr.pixelSize;
    atoms = sLat_arr.xyzDFT(:,1:4);
    atoms(:,1:3) = atoms(:,1:3)./pixelSize;
    BOO = sLat_arr.BOO;
    atomsSurf = sLat_arr.atomsSurf;
    chemSRO = sLat_arr.chemSROP;
    dft_info = sLat_arr.xyzDFT;
    PtPt_bond = sLat_arr.PtPt_bond;

    led_arr = zeros(size(atoms,1),14);
    led_arr(:,1:4) = atoms;
    led_arr(:,5) = NNnum;
    led_arr(:,16) = PtPt_bond;
    for c1 = 1:size(led_arr,1)
        NNinds_temp = NNinds(c1,:);
        NNinds_temp(NNinds_temp==0) = [];
        led_arr(c1,6) = sum(NNnum(NNinds_temp))/12;
        led_arr(c1,7) = sum(NNnum(NNinds_temp)<10);
        led_arr(c1,8) = sum(atoms(NNinds_temp,4)==1);
        NN_Ni_CN = NNnum(NNinds_temp(atoms(NNinds_temp,4)==1));
        NN_Ni_CN_inds = weight_arr(NN_Ni_CN);
        
        led_arr(c1,9) = mean(NN_Ni_CN);
        led_arr(c1,10) = rms(NN_Ni_CN);
        led_arr(c1,11) = sum(NN_Ni_CN==12);
        led_arr(c1,14) = sum(NN_Ni_CN==12);   
    end
    sLat_arr.CN = [led_arr(:,5),led_arr(:,5)-led_arr(:,8),led_arr(:,8)];
    for c1 = 1:size(led_arr,1)
        NNinds_temp = NNinds(c1,:);
        NNinds_temp(NNinds_temp==0) = [];
        % element generalize CN
        NNinds_Ni = NNinds_temp(atoms(NNinds_temp,4)==1);
        NNinds_Pt = NNinds_temp(atoms(NNinds_temp,4)==2);
        CNN_Ni_Ni = 0;
        CNN_Ni_Pt = 0;
        CNN_Pt_Ni = 0;
        CNN_Pt_Pt = 0;
        for d4 = 1:numel(NNinds_Ni)
            NNinds_Ni_temp = NNinds(NNinds_Ni(d4),:);
            NNinds_Ni_temp(NNinds_Ni_temp==0) = [];
            CNN_Ni_Ni = CNN_Ni_Ni + sum(atoms(NNinds_Ni_temp,4)==1);
            CNN_Ni_Pt = CNN_Ni_Pt + sum(atoms(NNinds_Ni_temp,4)==2);
        end
        for d5 = 1:numel(NNinds_Pt)
            NNinds_Pt_temp = NNinds(NNinds_Pt(d5),:);
            NNinds_Pt_temp(NNinds_Pt_temp==0) = [];
            CNN_Pt_Ni = CNN_Pt_Ni + sum(atoms(NNinds_Pt_temp,4)==1);
            CNN_Pt_Pt = CNN_Pt_Pt + sum(atoms(NNinds_Pt_temp,4)==2);
        end
        led_arr(c1,21) = CNN_Ni_Ni/12;
        led_arr(c1,22) = CNN_Ni_Pt/12;
        led_arr(c1,23) = CNN_Pt_Ni/12;
        led_arr(c1,24) = CNN_Pt_Pt/12;
        led_arr(c1,25) = CNN_Ni_Ni/12 + CNN_Ni_Pt/12;
        led_arr(c1,26) = CNN_Pt_Ni/12 + CNN_Pt_Pt/12;
    end
    
    led_arr(isnan(led_arr)) = 0;
    led_arr(:,12) = dft_info(:,5);
    led_arr(:,13) = dft_info(:,10);
    led_arr(:,15) = BOO(:,3);
    led_arr(:,17) = atomsSurf(:,4);
    led_arr(:,18) = squeeze(chemSRO(1,1,:));
    led_arr(:,19) = squeeze(chemSRO(1,2,:));
    led_arr(:,20) = squeeze(chemSRO(2,2,:));
    
    LED_cell{a1} = led_arr;

end
save('LED_cell_Pt_alloy.mat', 'LED_cell')