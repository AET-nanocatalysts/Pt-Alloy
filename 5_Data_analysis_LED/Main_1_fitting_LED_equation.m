%% Main_1_fitting_LED_equation
% fitting different parameters into the equation
% to achieve the best combination with smallest rmse

clear; clc; close all;
%%
load('LED_cell_Pt_alloy.mat', 'LED_cell')
ind_cell = {1:2,3:9,10:13,14:17};
LED_surf = cell(4,1);
LED_surf_np = cell(17,1);
for a1 = 1:4
    surf_desc_a = [];
    for b1 = ind_cell{a1}
        surf_desc_a2 = LED_cell{b1};
        surf_desc_a = cat(1,surf_desc_a,surf_desc_a2(surf_desc_a2(:,5)<10 & surf_desc_a2(:,4)==2,:));
        LED_surf_np{b1} = surf_desc_a2(surf_desc_a2(:,5)<10 & surf_desc_a2(:,4)==2,:);
    end
    LED_surf{a1,1} = surf_desc_a;
end
NiPt_surf_desc = cell2mat(LED_surf([2,4]));
%%
warning off
string_cell = cell(29,1);
string_cell{5}  = 'CN num';
string_cell{6}  = 'gen-CN num';
string_cell{7}  = 'surface CN';
string_cell{8}  = 'CN-Ni';
string_cell{9}  = 'mean CN of NN Ni';
string_cell{10} = 'rms CN of NN Ni';
string_cell{11} = 'sub surface Ni num';
string_cell{12} = 'Ediff';
string_cell{13} = 'Activity';
string_cell{14} = 'surface Ni num';
string_cell{15} = 'BOO';
string_cell{16} = 'Pt bond length';
string_cell{17} = 'surface curv';
string_cell{18} = 'chemSROP11';
string_cell{19} = 'chemSROP12';
string_cell{20} = 'chemSROP22';
string_cell{21} = 'gCN-Ni-Ni';
string_cell{22} = 'gCN-Ni-Pt';
string_cell{23} = 'gCN-Pt-Ni';
string_cell{24} = 'gCN-Pt-Pt';
string_cell{25} = 'gCN-Ni-X';
string_cell{26} = 'gCN-Pt-X';
string_cell{27} = 'CN-Pt';
string_cell{28} = 'strain';
string_cell{29} = 'inverse strain';
string_cell(1:4) = [];
%%
NiPt_surf_desc_t = NiPt_surf_desc;
NiPt_surf_desc_t(NiPt_surf_desc_t(:,16)==0,:) = [];
%%
NiPt_surf_desc_sub = NiPt_surf_desc_t(:,5:end);
NiPt_surf_desc_sub(:,end+1) = NiPt_surf_desc_sub(:,1) - NiPt_surf_desc_sub(:,4);
NiPt_surf_desc_sub(NiPt_surf_desc_sub(:,13)==0,:) = [];
NiPt_surf_desc_sub(:,end+1) = (NiPt_surf_desc_sub(:,12)-2.75)./2.75;
NiPt_surf_desc_sub(:,end+1) = 1./((NiPt_surf_desc_sub(:,12)-2.75)./2.75);
%%
target_id = [1:7,10:25];
%%
fileprefix = 'output/LED_para_%s.txt';
options = optimoptions(@lsqcurvefit,'StepTolerance',1e-16,'display','off');

x0 = [1,1,1,-1];
lb = [0,0,-200,-1000];
ub = [10,5,500,1000];
%%
randlist = randperm(size(NiPt_surf_desc_sub,1));
cut070 = round(0.7*size(NiPt_surf_desc_sub,1));
randlist1 = randlist(1:cut070); N1 = numel(randlist1);
randlist2 = randlist(cut070+1:end); N2 = numel(randlist2);
%% three parameters A*exp(-a*B)+C
comb_num = nchoosek(target_id,3);
perm3 = [1,2,3;1,3,2;2,3,1];
filename = sprintf(fileprefix,'AexpNB_C');
fileID = fopen(filename,'w');
for comb_ind = 1:size(comb_num,1)
    for yy_ind = 1:size(perm3,1)
        yy_ind_tmp = perm3(yy_ind,:);
        i = comb_num(comb_ind,yy_ind_tmp(1));
        j = comb_num(comb_ind,yy_ind_tmp(2));
        k = comb_num(comb_ind,yy_ind_tmp(3));
        X = [NiPt_surf_desc_sub(:,i), NiPt_surf_desc_sub(:,j), NiPt_surf_desc_sub(:,k)];
        Y = NiPt_surf_desc_sub(:,8);
        X1 = X(randlist1,:);
        Y1 = Y(randlist1,:);
        X2 = X(randlist2,:);
        Y2 = Y(randlist2,:);

        fun = @(x,xdata)(x(1) .* xdata(:,1) .* exp(-x(4).*xdata(:,2)) + x(2) .* xdata(:,3) + x(3));
        try
            [x1, resnorm1, resid1] = lsqcurvefit(fun,x0,X1,Y1,lb,ub,options);
            [x2, resnorm2, resid2] = lsqcurvefit(fun,x0,X2,Y2,lb,ub,options);
            fprintf(fileID,['%15s, %15s, %15s,' ...
                ' % .04f, % .04f, % .04f, % .04f, % .04f,' ...
                ' % .04f, % .04f, % .04f, % .04f, % .04f\n'],...
                string_cell{i},string_cell{j}, ...
                string_cell{k}, ...
                rms(resid1),rms(resid2), ...
                x1(1),x1(2),x1(3),x1(4), ...
                x2(1),x2(2),x2(3),x2(4));
        catch
        end
    end
end
fclose(fileID);