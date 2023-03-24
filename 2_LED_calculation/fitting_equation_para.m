clear;clc;
%%
load('final_LED_cell_230312.mat', 'LED_cell')
ind_cell = {1:2,3:9,10:13,14:17};
LED_surf = cell(4,1);
LED_surf_np = cell(17,1);
for a1 = 1:4
    surf_desc_a = [];
    for b1 = ind_cell{a1}
        surf_desc_a2 = LED_cell{b1};
        surf_desc_a = cat(1,surf_desc_a,surf_desc_a2(surf_desc_a2(:,5)<10 & surf_desc_a2(:,4)==2,:));
%         surf_desc_a = cat(1,surf_desc_a,surf_desc_a2(surf_desc_a2(:,4)==2,:));
%         disp(num2str(sum(surf_desc_a2(:,5)<10 & surf_desc_a2(:,4)==2)))
        LED_surf_np{b1} = surf_desc_a2(surf_desc_a2(:,5)<10 & surf_desc_a2(:,4)==2,:);
    end
    LED_surf{a1,1} = surf_desc_a;
end
NiPt_surf_desc = cell2mat(LED_surf([2,4]));
% NiPt_surf_desc = cell2mat(LED_surf);
%%
warning off
disp(' ')
disp('Pearson correlation coefficient')
string_cell = cell(24,1);
string_cell{5}  = 'CN num';
string_cell{6}  = 'gen-CN num';
string_cell{7}  = 'surface CN';
string_cell{8}  = 'CN-Ni';
string_cell{9}  = 'mean CN of NN Ni';
string_cell{10} = 'rms CN of NN Ni';
string_cell{11} = 'sub surface Ni num';
string_cell{14} = 'Ediff';
string_cell{15} = 'Activity';
string_cell{16} = 'CN 2';
string_cell{17} = 'surface Ni num';
string_cell{21} = 'BOO';
string_cell{22} = 'Pt bond length';
string_cell{23} = 'surface curv';
string_cell{36} = 'chemSROP11';
string_cell{37} = 'chemSROP12';
string_cell{38} = 'chemSROP22';
string_cell{41} = 'gCN-Ni-Ni';
string_cell{42} = 'gCN-Ni-Pt';
string_cell{43} = 'gCN-Pt-Ni';
string_cell{44} = 'gCN-Pt-Pt';
string_cell{45} = 'gCN-Ni-X';
string_cell{46} = 'gCN-Pt-X';

for i = 5:46
    if ~isempty(string_cell{i})
    A = corrcoef(NiPt_surf_desc(:,i),NiPt_surf_desc(:,15));
    fprintf('%25s: % .04f\n',string_cell{i}, A(1,2));
    end
end
%%
string_cell_sub = {}; ind = 1;
NiPt_surf_desc_t = NiPt_surf_desc;
NiPt_surf_desc_t(NiPt_surf_desc_t(:,22)==0,:) = [];
NiPt_surf_desc_arr = [];
for i = 5:46
    if ~isempty(string_cell{i})
        NiPt_surf_desc_arr = [NiPt_surf_desc_arr,NiPt_surf_desc_t(:,ind)];
        string_cell_sub{ind} = string_cell{i}; ind = ind+1;
        fun = @(x,xdata)(x(1)*xdata(:,1) - x(2));
        x0 = [1,1];
        lb = [0,-2];
        ub = [5,50];
        ydata = NiPt_surf_desc_t(:,14);
        % zdata = NiPt_surf_desc(:,15);
        xdata = NiPt_surf_desc_t(:,i);
        opt = optimset('Display','off');
        [x, resnorm, resid] = lsqcurvefit(fun,x0,xdata,ydata,lb,ub,opt);
        % disp(num2str(x))
        % disp(num2str(rms(resid)))
        X = NiPt_surf_desc_t(:,i);
        Y = NiPt_surf_desc_t(:,14);
        mdl = fitlm(X,Y);
        fprintf('%25s: % .04f,  % .04f\n',string_cell{i}, mdl.RMSE, rms(resid));
%         if rms(resid)<0.15 && rms(resid)>0.01
%             fprintf('%25s: % .04f\n',string_cell{i}, rms(resid));
%         end
%         pause()
    end
end
string_cell_sub{end+1} = 'CN-Pt';
string_cell_sub{end+1} = 'exp neg strain';
string_cell_sub{end+1} = 'strain';
string_cell_sub{end+1} = 'inverse strain';
%%
NiPt_surf_desc_sub = NiPt_surf_desc_t(:,[5:11,14:15,17,21:23,36:38,41:46]);
NiPt_surf_desc_sub(:,end+1) = NiPt_surf_desc_sub(:,1) - NiPt_surf_desc_sub(:,4);
NiPt_surf_desc_sub(NiPt_surf_desc_sub(:,13)==0,:) = [];
% NiPt_surf_desc_sub(:,end+1) = exp(-NiPt_surf_desc_sub(:,12));
% NiPt_surf_desc_sub(:,end+1) = 1./NiPt_surf_desc_sub(:,12);
% NiPt_surf_desc_sub(:,end+1) = exp(-(NiPt_surf_desc_sub(:,12)-2.75)./2.75);%1./NiPt_surf_desc_sub(:,12);
NiPt_surf_desc_sub(:,end+1) = exp(-2*(NiPt_surf_desc_sub(:,12)-2.75)./2.75);%1./NiPt_surf_desc_sub(:,12);
NiPt_surf_desc_sub(:,end+1) = (NiPt_surf_desc_sub(:,12)-2.75)./2.75;
NiPt_surf_desc_sub(:,end+1) = 1./((NiPt_surf_desc_sub(:,12)-2.75)./2.75);
NiPt_surf_desc_sub(:,end+1:end+2) = NiPt_surf_desc_t(:,47:48);
% NiPt_surf_desc_sub(:,10) = [];
%%
string_cell_sub2 = string_cell_sub;
string_cell_sub2(10) = [];
target_id = [1:7,11:26];
%%
fileprefix = 'new4_led_para_%s.txt';
options = optimoptions(@lsqcurvefit,'StepTolerance',1e-16,'display','off');

x0 = [1,1,1,-1,0,-1];
lb = [0,0,-200,-1000,-1000,-1000];
ub = [10,5,500,1000,1000,1000];
%%
randlist = randperm(size(NiPt_surf_desc_sub,1));
cut070 = round(0.7*size(NiPt_surf_desc_sub,1));
randlist1 = randlist(1:cut070); N1 = numel(randlist1);
randlist2 = randlist(cut070+1:end); N2 = numel(randlist2);
%% two parameters A+B
comb_num = nchoosek(target_id,2);
filename = sprintf(fileprefix,'A_B');
fileID = fopen(filename,'w');
for comb_ind = 1:size(comb_num,1)
    i = comb_num(comb_ind,1);
    j = comb_num(comb_ind,2);
    X = [NiPt_surf_desc_sub(:,i), NiPt_surf_desc_sub(:,j)];
    Y = NiPt_surf_desc_sub(:,8);
    X1 = X(randlist1,:);
    Y1 = Y(randlist1,:);
    X2 = X(randlist2,:);
    Y2 = Y(randlist2,:);

    fun = @(x,xdata)(x(1) .* xdata(:,1) + x(2) .* xdata(:,2) + x(3));
    [x1, resnorm1, resid1] = lsqcurvefit(fun,x0,X1,Y1,lb,ub,options);
    [x2, resnorm2, resid2] = lsqcurvefit(fun,x0,X2,Y2,lb,ub,options);
    fprintf(fileID,['%15s, %15s,' ...
        ' % .04f, % .04f, % .04f, % .04f,' ...
        ' % .04f, % .04f, % .04f, % .04f\n'],...
        string_cell_sub2{i},string_cell_sub2{j}, ...
        rms(resid1),rms(resid2), ...
        x1(1),x1(2),x1(3), ...
        x2(1),x2(2),x2(3));

%     mdl = fitlm(X,Y);
%     fprintf(fileID,'%15s, %15s: % .04f\n',string_cell_sub2{i},string_cell_sub2{j}, mdl.RMSE);
%     if resnorm1<0.15 && resnorm1>0
%         fprintf('%15s, %15s: % .04f\n',string_cell_sub2{i},string_cell_sub2{j}, resnorm1);
%         %             pause;
%     end
end
fclose(fileID);
%% three parameters A*B+C
comb_num = nchoosek(target_id,3);
perm3 = [1,2,3;1,3,2;2,3,1];
filename = sprintf(fileprefix,'AB_C');
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

        fun = @(x,xdata)(x(1) .* xdata(:,1) .* xdata(:,2) + x(2) .* xdata(:,3) + x(3));
        [x1, resnorm1, resid1] = lsqcurvefit(fun,x0,X1,Y1,lb,ub,options);
        [x2, resnorm2, resid2] = lsqcurvefit(fun,x0,X2,Y2,lb,ub,options);
        fprintf(fileID,['%15s, %15s, %15s,' ...
            ' % .04f, % .04f, % .04f, % .04f,' ...
            ' % .04f, % .04f, % .04f, % .04f\n'],...
            string_cell_sub2{i},string_cell_sub2{j}, ...
            string_cell_sub2{k}, ...
            rms(resid1),rms(resid2), ...
            x1(1),x1(2),x1(3), ...
            x2(1),x2(2),x2(3));

%         mdl = fitlm(X,Y);
%         fprintf(fileID,'%15s, %15s, %15s: % .04f\n',string_cell_sub2{i},string_cell_sub2{j}, string_cell_sub2{k}, mdl.RMSE);
        if rms(resid1)<0.125 && rms(resid1)>0
            fprintf('%15s, %15s, %15s: % .04f\n',string_cell_sub2{i},string_cell_sub2{j}, string_cell_sub2{k}, rms(resid1));
            %             pause;
        end
    end
end
fclose(fileID);
%% three parameters A+B+C
comb_num = nchoosek(target_id,3);
% perm3 = [1,2,3;1,3,2;2,3,1];
perm3 = [1,2,3];
filename = sprintf(fileprefix,'A_B_C');
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

        fun = @(x,xdata)(x(1) .* xdata(:,1) + x(2) * xdata(:,2) + x(3) .* xdata(:,3) + x(4));
        [x1, resnorm1, resid1] = lsqcurvefit(fun,x0,X1,Y1,lb,ub,options);
        [x2, resnorm2, resid2] = lsqcurvefit(fun,x0,X2,Y2,lb,ub,options);
        fprintf(fileID,['%15s, %15s, %15s,' ...
            ' % .04f, % .04f, % .04f, % .04f,' ...
            ' % .04f, % .04f, % .04f, % .04f,' ...
            ' % .04f, % .04f\n'],...
            string_cell_sub2{i},string_cell_sub2{j}, ...
            string_cell_sub2{k}, ...
            rms(resid1),rms(resid2), ...
            x1(1),x1(2),x1(3),x1(4), ...
            x2(1),x2(2),x2(3),x2(4));

%         mdl = fitlm(X,Y);
%         fprintf(fileID,'%15s, %15s, %15s: % .04f\n',string_cell_sub2{i},string_cell_sub2{j}, string_cell_sub2{k}, mdl.RMSE);
%         if mdl.RMSE<0.125 && mdl.RMSE>0
%             fprintf('%15s, %15s, %15s: % .04f\n',string_cell_sub2{i},string_cell_sub2{j}, string_cell_sub2{k}, mdl.RMSE);
%             %             pause;
%         end
    end
end
fclose(fileID);
%% four parameters A*B+C+D
comb_num = nchoosek(target_id,4);
perm4 = [1,2,3,4;1,3,2,4;1,4,2,3;2,3,1,4;2,4,1,3;3,4,1,2];
filename = sprintf(fileprefix,'AB_C_D');
fileID = fopen(filename,'w');
for comb_ind = 1:size(comb_num,1)
    for yy_ind = 1:size(perm4,1)
        yy_ind_tmp = perm4(yy_ind,:);
        i = comb_num(comb_ind,yy_ind_tmp(1));
        j = comb_num(comb_ind,yy_ind_tmp(2));
        k = comb_num(comb_ind,yy_ind_tmp(3));
        l = comb_num(comb_ind,yy_ind_tmp(4));
        X = [NiPt_surf_desc_sub(:,i), NiPt_surf_desc_sub(:,j), NiPt_surf_desc_sub(:,k), NiPt_surf_desc_sub(:,l)];
        Y = NiPt_surf_desc_sub(:,8);
        X1 = X(randlist1,:);
        Y1 = Y(randlist1,:);
        X2 = X(randlist2,:);
        Y2 = Y(randlist2,:);

        fun = @(x,xdata)(x(1) .* xdata(:,1) .* xdata(:,2) + x(2) * xdata(:,3) + x(3) .* xdata(:,4) + x(4));
        [x1, resnorm1, resid1] = lsqcurvefit(fun,x0,X1,Y1,lb,ub,options);
        [x2, resnorm2, resid2] = lsqcurvefit(fun,x0,X2,Y2,lb,ub,options);
        fprintf(fileID,['%15s, %15s, %15s, %15s,' ...
            ' % .04f, % .04f, % .04f, % .04f,' ...
            ' % .04f, % .04f, % .04f, % .04f,' ...
            ' % .04f, % .04f\n'],...
            string_cell_sub2{i},string_cell_sub2{j}, ...
            string_cell_sub2{k},string_cell_sub2{l}, ...
            rms(resid1),rms(resid2), ...
            x1(1),x1(2),x1(3),x1(4), ...
            x2(1),x2(2),x2(3),x2(4));

%         mdl = fitlm(X,Y);
%         fprintf(fileID,'%15s, %15s, %15s, %15s: % .04f\n',string_cell_sub2{i},string_cell_sub2{j}, string_cell_sub2{k},string_cell_sub2{l}, mdl.RMSE);
%         if mdl.RMSE<0.115 && mdl.RMSE>0
%             fprintf('%15s, %15s, %15s, %15s: % .04f\n',string_cell_sub2{i},string_cell_sub2{j}, string_cell_sub2{k},string_cell_sub2{l}, mdl.RMSE);
% %             pause;
%         end
    end
end
fclose(fileID);
%% four parameters A*B+C*D
comb_num = nchoosek(target_id,4);
% perm4 = perms(1:4,'unique');
perm4 = [1,2,3,4;1,3,2,4;1,4,2,3];
filename = sprintf(fileprefix,'AB_CD');
fileID = fopen(filename,'w');
for comb_ind = 1:size(comb_num,1)
    for yy_ind = 1:size(perm4,1)
        yy_ind_tmp = perm4(yy_ind,:);
        i = comb_num(comb_ind,yy_ind_tmp(1));
        j = comb_num(comb_ind,yy_ind_tmp(2));
        k = comb_num(comb_ind,yy_ind_tmp(3));
        l = comb_num(comb_ind,yy_ind_tmp(4));
        X = [NiPt_surf_desc_sub(:,i), NiPt_surf_desc_sub(:,j), NiPt_surf_desc_sub(:,k), NiPt_surf_desc_sub(:,l)];
        Y = NiPt_surf_desc_sub(:,8);
        X1 = X(randlist1,:);
        Y1 = Y(randlist1,:);
        X2 = X(randlist2,:);
        Y2 = Y(randlist2,:);

        fun = @(x,xdata)(x(1) .* xdata(:,1) .* xdata(:,2) + x(2) .* xdata(:,3) .* xdata(:,4) + x(3));
        [x1, resnorm1, resid1] = lsqcurvefit(fun,x0,X1,Y1,lb,ub,options);
        [x2, resnorm2, resid2] = lsqcurvefit(fun,x0,X2,Y2,lb,ub,options);
        fprintf(fileID,['%15s, %15s, %15s, %15s,' ...
            ' % .04f, % .04f, % .04f, % .04f,' ...
            ' % .04f, % .04f, % .04f, % .04f\n'],...
            string_cell_sub2{i},string_cell_sub2{j}, ...
            string_cell_sub2{k},string_cell_sub2{l}, ...
            rms(resid1),rms(resid2), ...
            x1(1),x1(2),x1(3), ...
            x2(1),x2(2),x2(3));

%         mdl = fitlm(X,Y);
%         fprintf(fileID,'%15s, %15s, %15s, %15s: % .04f\n',string_cell_sub2{i},string_cell_sub2{j}, string_cell_sub2{k},string_cell_sub2{l}, mdl.RMSE);
%         if mdl.RMSE<0.115 && mdl.RMSE>0
%             fprintf('%15s, %15s, %15s, %15s: % .04f\n',string_cell_sub2{i},string_cell_sub2{j}, string_cell_sub2{k},string_cell_sub2{l}, mdl.RMSE);
% %             pause;
%         end
    end
end
fclose(fileID);
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
                string_cell_sub2{i},string_cell_sub2{j}, ...
                string_cell_sub2{k}, ...
                rms(resid1),rms(resid2), ...
                x1(1),x1(2),x1(3),x1(4), ...
                x2(1),x2(2),x2(3),x2(4));
        catch
        end
%         mdl = fitlm(X,Y);
%         fprintf(fileID,'%15s, %15s, %15s: % .04f\n',string_cell_sub2{i},string_cell_sub2{j}, string_cell_sub2{k}, mdl.RMSE);
%         if mdl.RMSE<0.125 && mdl.RMSE>0
%             fprintf('%15s, %15s, %15s: % .04f\n',string_cell_sub2{i},string_cell_sub2{j}, string_cell_sub2{k}, mdl.RMSE);
%             %             pause;
%         end
    end
end
fclose(fileID);
%% three parameters A+B+C
comb_num = nchoosek(target_id,3);
perm3 = [1,2,3;1,3,2;2,3,1];
% perm3 = [1,2,3];
filename = sprintf(fileprefix,'A_expNB_C');
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
        
        try
            fun = @(x,xdata)(x(1) .* xdata(:,1) + x(2) .* exp(-x(4).*xdata(:,2)) + x(3) .* xdata(:,3) + x(5));
            [x1, resnorm1, resid1] = lsqcurvefit(fun,x0,X1,Y1,lb,ub,options);
            [x2, resnorm2, resid2] = lsqcurvefit(fun,x0,X2,Y2,lb,ub,options);
            fprintf(fileID,['%15s, %15s, %15s,' ...
                ' % .04f, % .04f, % .04f, % .04f,' ...
                ' % .04f, % .04f, % .04f, % .04f,' ...
                ' % .04f, % .04f, % .04f, % .04f\n'],...
                string_cell_sub2{i},string_cell_sub2{j}, ...
                string_cell_sub2{k}, ...
                rms(resid1),rms(resid2), ...
                x1(1),x1(2),x1(3),x1(4),x1(5), ...
                x2(1),x2(2),x2(3),x2(4),x2(5));
        catch
        end
%         mdl = fitlm(X,Y);
%         fprintf(fileID,'%15s, %15s, %15s: % .04f\n',string_cell_sub2{i},string_cell_sub2{j}, string_cell_sub2{k}, mdl.RMSE);
%         if mdl.RMSE<0.125 && mdl.RMSE>0
%             fprintf('%15s, %15s, %15s: % .04f\n',string_cell_sub2{i},string_cell_sub2{j}, string_cell_sub2{k}, mdl.RMSE);
%             %             pause;
%         end
    end
end
fclose(fileID);