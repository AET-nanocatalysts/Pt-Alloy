%% Main_1_calculate_BOO_Ptbond
% calculate the BOO and Pt bond length for each NPs

clear; clc; close all;
%%
Pt_alloy_sLat_arr = importdata('Pt_alloy_sLat_arr.mat');
%% calculate BOO for each NPs
Pt_alloy_sLat_arr_1 = Pt_alloy_sLat_arr;

for a1 = 1:17
    
    sLat_arr = Pt_alloy_sLat_arr(a1);
    atoms_model = sLat_arr.atoms;
    pixel_size = sLat_arr.pixelSize;
    bondTh = sLat_arr.NNradiusSearch;
    
    Q4_full = obtain_Q_l_2ndNN_inds_PBC(atoms_model(:,1:3)'*pixel_size,bondTh*pixel_size,4,[], 0);
    Q6_full = obtain_Q_l_2ndNN_inds_PBC(atoms_model(:,1:3)'*pixel_size,bondTh*pixel_size,6,[], 0);
    srop = sqrt(Q4_full.^2 + Q6_full.^2)./sqrt(0.190941^2 + 0.574524^2);
    srop = 1-abs(1-srop);
    Pt_alloy_sLat_arr_1(a1).BOO = [Q4_full',Q6_full',srop'];
    
end
%% calculate Pt bond length for each NPs
Pt_alloy_sLat_arr_2 = Pt_alloy_sLat_arr_1;

for a2 = 1:17

    sLat_arr = Pt_alloy_sLat_arr_1(a2);
    NNinds = sLat_arr.NNinds;
    atoms = sLat_arr.atoms;
    pixel_size = sLat_arr.pixelSize;
    Pt_bond_length = zeros(size(atoms,1),1);

    for c2 = 1:size(Pt_bond_length,1)
        NNinds_temp = NNinds(c2,:);
        NNinds_temp(NNinds_temp==0) = [];
        center_pos = atoms(c2,1:3);
        Pt_xyz_pos = atoms(NNinds_temp(atoms(NNinds_temp,4)==2),1:3);
        Pt_bond_length(c2) = mean(pdist2(Pt_xyz_pos,center_pos)).*pixel_size;
    end

    Pt_alloy_sLat_arr_2(a2).PtPt_bond = Pt_bond_length;

end
%%
save('Pt_alloy_sLat_arr_2.mat','Pt_alloy_sLat_arr_2');