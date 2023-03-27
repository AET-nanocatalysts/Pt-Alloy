%% Main_2_LED_plot
% calculate the rmse of the LED equation
% plot the volcano curve between LED and activities

clear; clc; close all;
%%
load('LED_cell_Pt_alloy.mat', 'LED_cell')
ind_cell = {1:2,3:9,10:13,14:17};
LED_surf = cell(4,1);
for a1 = 1:4
    surf_desc_a = [];
    for b1 = ind_cell{a1}
        surf_desc_a2 = LED_cell{b1};
        surf_desc_a = cat(1,surf_desc_a,surf_desc_a2(surf_desc_a2(:,5)<10 & surf_desc_a2(:,4)==2,:));
    end
    LED_surf{a1,1} = surf_desc_a;
end
PtNi_surf_desc = cell2mat(LED_surf([2,4]));
%%
NiPt_surf_desc_t = PtNi_surf_desc;
NiPt_surf_desc_t(NiPt_surf_desc_t(:,16)==0,:) = [];
%%
NiPt_surf_desc_sub = NiPt_surf_desc_t(:,5:end);
NiPt_surf_desc_sub(:,end+1) = NiPt_surf_desc_sub(:,1) - NiPt_surf_desc_sub(:,4);
NiPt_surf_desc_sub(NiPt_surf_desc_sub(:,13)==0,:) = [];
NiPt_surf_desc_sub(:,end+1) = (NiPt_surf_desc_sub(:,12)-2.75)./2.75;
NiPt_surf_desc_sub(:,end+1) = 1./((NiPt_surf_desc_sub(:,12)-2.75)./2.75);
%%
fun = @(x,xdata)(x(1) * xdata(:,1) .* exp(-x(4).*((xdata(:,2))-2.75)./2.75) + x(2) .* xdata(:,3) - x(3));

x0 = [1,1,1,-1];
lb = [0,0,-2,-100000];
ub = [10,5,50,100000];

ydata = NiPt_surf_desc_sub(:,8);
zdata = NiPt_surf_desc_sub(:,9);
xdata = [NiPt_surf_desc_sub(:,23), NiPt_surf_desc_sub(:,12), NiPt_surf_desc_sub(:,21)];

options = optimoptions(@lsqcurvefit,'StepTolerance',1e-16,'display','off');
[x, resnorm, resid] = lsqcurvefit(fun,x0,xdata,ydata,lb,ub,options);
fprintf('a1 = %.02f, a2 = %.02f, E1 = %.02f, E0 = %.02f, RMSE = %.03f\n', x(4), x(2)./x(1), x(1), x(3), rms(resid))

figure(111); clf; set(gcf,'position',[500,400,650,500]); hold on;
scatter((fun(x,xdata)+x(3))./x(1), zdata,'filled','markerfacecolor',[0,0.5,1],'sizedata',7,'markerfacealpha',0.3)
plot(((-1:0.001:0.132)+x(3))./x(1),exp((-1:0.001:0.132)./25.69257*1000),'r--','linewidth',2,'color',[1,0.3,0])
plot(((0.132:0.001:1)+x(3))./x(1),exp((0.26-0.97*(0.132:0.001:1))./25.69257*1000),'r--','linewidth',2,'color',[1,0.3,0])
box on; xlabel('new CN descriptor'); ylabel('j/j_{Pt(111)} predicted by DFT ML')
set(gca,'fontsize',14,'linewidth',2,'YScale','log'); %colorbar; %axis image

xlim([6.5,11]); ylim([10^(-8),170]);
