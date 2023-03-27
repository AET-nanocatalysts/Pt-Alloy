%% Main_2_calculate_chemSROP
% calculate the chemical short-range order for each NPs

clear; clc; close all;
%%
Pt_alloy_sLat_arr_2 = importdata('Pt_alloy_sLat_arr_2.mat');

Pt_alloy_sLat_arr_3 = Pt_alloy_sLat_arr_2;
for a3 = 1:17
    
    sLat_arr = Pt_alloy_sLat_arr_2(a3);
    
    atom_model = sLat_arr.atoms;
    abc = sLat_arr.atomsLat(:,6:8);
    pixelsize = sLat_arr.pixelSize;
    NNbond = sLat_arr.NNradiusSearch;
    Q_bondTh = NNbond*pixelsize;
    
    neigh_cell = cell(size(abc,1),1);
    
    for N = 1:size(abc,1)
        temp_abc = abc(N,:);
        temp_dist = pdist2(abc,temp_abc);
        temp_neigh =  find( abs(temp_dist-sqrt(2)) < 1e-3 );
        neigh_cell{N} = temp_neigh;
    end
    
    atom_types = atom_model(:,4);
    atom_model = atom_model(:,1:3)*pixelsize;
    
    concentration = zeros(2,1);
    for type_ind = 1:2
        concentration(type_ind) = sum(atom_types == type_ind) / numel(atom_types);
    end
    
    local_alpha_arr = zeros(2,2,length(atom_types));
    
    for N = 1:length(atom_types)
        
        temp_model = atom_model(N,:);
        temp_dist = pdist2(temp_model, atom_model);
        atom_ind_radius = temp_dist<Q_bondTh;
        
        for i = 1:2
            indi = find(atom_types(:)==i & atom_ind_radius(:));
            ind = [];
            for k = 1:numel(indi)
                ind = [ind; neigh_cell{indi(k)}];
            end
            temp_neigh_types_all = atom_types(ind);
            for j = 1:2
                local_alpha_arr(i,j,N) = ( sum(temp_neigh_types_all==j) / length(ind) - concentration(j) ) /...
                    ( (i==j) - concentration(j) );
            end
        end
    end
    local_alpha_arr(isnan(local_alpha_arr))=0;
    final_local_alpha_arr = ( local_alpha_arr + permute(local_alpha_arr, [2, 1, 3]) ) / 2;
    
    
    Pt_alloy_sLat_arr_3(a3).chemSROP = final_local_alpha_arr;
    
end
%%
save('Pt_alloy_sLat_arr_3.mat','Pt_alloy_sLat_arr_3');