clc;
close all;
clear all;

%%
Tb = readtable('conversion_gold_exp1.xlsx');  
d = table2array(Tb);
data = d(:,1:3);
F(:,1) = data(:,3);
% F(:,2) = data(:,3);
% F(:,3) = data(:,5);
% F(:,4) = data(:,6);
% F(:,5) = data(:,7);
% F(:,6) = data(:,8);
% F(:,7) = data(:,9);
% F(:,8) = data(:,10);

% %% Plot the solution points.
% figure(1)
% scatter3(F(:,1),F(:,2),F(:,3),20,'ro','filled');
% xlabel('F1')
% ylabel('F2')
% zlabel('F3')

%%
f1=max(F(:,1))-min(F(:,1));
% f2=max(F(:,2))-min(F(:,2));
% f3=max(F(:,3))-min(F(:,3));
% f4=max(F(:,4))-min(F(:,4));
% f5=max(F(:,5))-min(F(:,5));


sum = f1;
F_final = (f1/sum)*F(:,1);
%% Making DataStruct for SOM Training
test =[data(:,1:2) F_final];
test1=[data(:,1:2) F(:,1)];
% test2=[data(:,1:1) F(:,2)];
% test3=[data(:,1:2) F(:,3)];
% test4=[data(:,1:2) F(:,4)];
% test5=[data(:,1:2) F(:,5)];
% test6=[data(:,1:2) F(:,6)];
% test7=[data(:,1:2) F(:,7)];
% test8=[data(:,1:2) F(:,8)];
% test3=[data(:,1:3) F(:,3)];
test_F=[data(:,1:2) F(:,1)];

%%
sData_F = som_data_struct(test_F,'my-data','comp_names',{'X1','X2'...
'Y_value'});
sData_F = som_normalize(sData_F,'range');

sData = som_data_struct(test,'my-data','comp_names',{'X1','X2'...
'Y_value'});
sData = som_normalize(sData,'range');

sData1 = som_data_struct(test1,'my-data','comp_names',{'X1','X2'...
'Y_value'});
sData1 = som_normalize(sData1,'range');

% sData2 = som_data_struct(test2,'my-data','comp_names',{'x1','x2'...
% 'Y_value'});
% sData2 = som_normalize(sData2,'range');
% 
% sData3 = som_data_struct(test3,'my-data','comp_names',{'x1','x2','F3'});
% sData3 = som_normalize(sData3,'range');
% 
% sData4 = som_data_struct(test4,'my-data','comp_names',{'x1','x2','F4'});
% sData4 = som_normalize(sData4,'range');
% 
% sData5 = som_data_struct(test5,'my-data','comp_names',{'x1','x2','F5'});
% sData5 = som_normalize(sData5,'range');
% 
% sData5 = som_data_struct(test5,'my-data','comp_names',{'x1','x2','F5'});
% sData5 = som_normalize(sData5,'range');
% 
% sData6 = som_data_struct(test6,'my-data','comp_names',{'x1','x2','F6'});
% sData6 = som_normalize(sData6,'range');
% 
% sData7 = som_data_struct(test7,'my-data','comp_names',{'x1','x2','F7'});
% sData7 = som_normalize(sData7,'range');

% sData8 = som_data_struct(test8,'my-data','comp_names',{'x1','x2','F8'});
% sData8 = som_normalize(sData8,'range');


%% Initializing SOM Map Codebook Vectors (Linear Initialization)
[sMap_F]= som_lininit(sData_F,'lattice','hexa','msize',[5,5]);
[sMap,A,V]= modifiedsom_lininitgoldexp1(sData,'lattice','hexa','msize',[5,5]);
% sMap.codebook(:,4) = sMap.codebook(:,4)*0; % optional, it does not effect the results
[sMap1]= sMap;
% [sMap2]= sMap;
% [sMap3]= sMap;
% [sMap4]= sMap;
% [sMap5]= sMap;
% [sMap6]= sMap;
% [sMap7]= sMap;
% [sMap8]= sMap;

%% Training SOM
[sMap_F,sTrainF] = som_batchtrain(sMap_F,sData_F,'sample_order','ordered','trainlen',500);
[sMap1,sTrain1] = modifiedsom_batchtrain(sMap1,sData1,'sample_order','ordered','trainlen',500);
% [sMap2,sTrain2] = modifiedsom_batchtrain(sMap2,sData2,'sample_order','ordered','trainlen',500);
% [sMap3,sTrain3] = modifiedsom_batchtrain(sMap3,sData3,'sample_order','ordered','trainlen',500);
% [sMap4,sTrain4] = modifiedsom_batchtrain(sMap4,sData4,'sample_order','ordered','trainlen',500);
% [sMap5,sTrain5] = modifiedsom_batchtrain(sMap5,sData5,'sample_order','ordered','trainlen',500);
% [sMap6,sTrain6] = modifiedsom_batchtrain(sMap6,sData6,'sample_order','ordered','trainlen',500);
% [sMap7,sTrain7] = modifiedsom_batchtrain(sMap7,sData7,'sample_order','ordered','trainlen',500);
% [sMap8,sTrain8] = modifiedsom_batchtrain(sMap8,sData8,'sample_order','ordered','trainlen',500);

%% Denormalizing the data
sMap_F = som_denormalize(sMap_F,sData_F);
sData_F = som_denormalize(sData_F,'remove');
% sMap_F.codebook=round(sMap_F.codebook);

sMap1=som_denormalize(sMap1,sData1);
sData1=som_denormalize(sData1,'remove');
% Map1.codebook=round(sMap1.codebook);

% sMap2=som_denormalize(sMap2,sData2);
% sData2=som_denormalize(sData2,'remove');
% sMap2.codebook=round(sMap2.codebook);

% sMap3 = som_denormalize(sMap3,sData3);
% sData3 = som_denormalize(sData3,'remove');
% sMap3.codebook=round(sMap3.codebook);
% 
% sMap4 = som_denormalize(sMap4,sData4);
% sData4 = som_denormalize(sData4,'remove');
% %sMap4.codebook=round(sMap4.codebook);
% 
% sMap5 = som_denormalize(sMap5,sData5);
% sData5 = som_denormalize(sData5,'remove');
% %sMap5.codebook=round(sMap5.codebook);
% 
% sMap6 = som_denormalize(sMap6,sData6);
% sData6 = som_denormalize(sData6,'remove');
% %sMap6.codebook=round(sMap6.codebook);
% 
% sMap7 = som_denormalize(sMap7,sData7);
% sData7 = som_denormalize(sData7,'remove');
% %sMap5.codebook=round(sMap5.codebook);
% 
% sMap8 = som_denormalize(sMap8,sData8);
% sData8 = som_denormalize(sData8,'remove');
% % sMap5.codebook=round(sMap5.codebook);
%%
sMap_umatrix = sMap_F;
sMap_umatrix2 = sMap_F;

sMap_umatrix.codebook(:,1:2) = sMap1.codebook(:,1:2);
sMap_umatrix.codebook(:,3) = sMap1.codebook(:,3);
% sMap_umatrix.codebook(:,3) = sMap2.codebook(:,2);
[mqe,tge] = som_quality(sMap_umatrix,data);
Tb2 = readtable('gold_codebook_exp1.xlsx');  
d2 = table2array(Tb2);
data2 = d2(:,1:3);
sMap_umatrix2.codebook(:,1:3)=data2;
hx=zeros(sMap_umatrix.topol.msize(1)*sMap_umatrix.topol.msize(2),1);
hx1=zeros(sMap_umatrix2.topol.msize(1)*sMap_umatrix2.topol.msize(2),1);
hx(find(sMap_umatrix2.codebook(:,end)<45000))=1;
hx1(find(sMap_umatrix2.codebook(:,end)>-50000000))=1;
% Visualization of SOM results( U Matrix and Component Planes )
figure(2)
set(gcf,'color','w')
som_show(sMap_F);
%% 
% som_show_add('hit',som_hits(sMap_umatrix2,data))
figure(3)
set(gcf,'color','w')
som_show(sMap_umatrix,'comp','all');
som_show_add('hit',som_hits(sMap_umatrix,data),'Markersize',0.5,'markercolor','k','Subplot',1:3)
% som_show_add('hit',hx,'Markersize',0.2,'Markercolor','k','Edgecolor','k','Subplot',1:3)
% % som_show_add('hit',hx,'Markersize',1,'Markercolor','none','Edgecolor','r','Subplot',1:3)
% som_show_add('hit',hx1,'Markersize',1,'Markercolor','none','Edgecolor','k','Subplot',1:3)
% som_show_add('hit',som_hits(sMap_umatrix,data))
figure(4)
set(gcf,'color','w')
som_show(sMap_umatrix2);
% som_show_add('hit',som_hits(sMap_umatrix,data),'Markersize',0.5,'markercolor','k','Subplot',1:3)
% som_show_add('hit',hx,'Markersize',0.2,'Markercolor','r','Edgecolor','r','Subplot',2:4)
som_show_add('hit',hx1,'Markersize',1,'Markercolor','none','Edgecolor','k','Subplot',2:4)
% figure(5)
% som_grid(sMap_umatrix,'Coord',sMap_umatrix.codebook(:,[1,2,5]))
% hold on, scatter3(d(:,1),d(:,2),d(:,5),'+r')
% title('Trained map')