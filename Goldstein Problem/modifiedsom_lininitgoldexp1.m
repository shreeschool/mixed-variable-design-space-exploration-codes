function [sMap,A,V] = modifiedsom_lininitgoldexp1(D, varargin)

% data
if isstruct(D), 
  data_name = D.name; 
  comp_names = D.comp_names; 
  comp_norm = D.comp_norm; 
  D = D.data;
  struct_mode = 1; 
else 
  data_name = inputname(1); 
  struct_mode = 0;
end
[dlen dim] = size(D);

% varargin
sMap = [];
sTopol = som_topol_struct; 
sTopol.msize = 0; 
munits = NaN;
i=1; 
while i<=length(varargin), 
  argok = 1; 
  if ischar(varargin{i}), 
    switch varargin{i}, 
     case 'munits',     i=i+1; munits = varargin{i}; sTopol.msize = 0;
     case 'msize',      i=i+1; sTopol.msize = varargin{i};
                               munits = prod(sTopol.msize); 
     case 'lattice',    i=i+1; sTopol.lattice = varargin{i}; 
     case 'shape',      i=i+1; sTopol.shape = varargin{i}; 
     case {'som_topol','sTopol','topol'}, i=i+1; sTopol = varargin{i}; 
     case {'som_map','sMap','map'}, i=i+1; sMap = varargin{i}; sTopol = sMap.topol;
     case {'hexa','rect'}, sTopol.lattice = varargin{i}; 
     case {'sheet','cyl','toroid'}, sTopol.shape = varargin{i};
     otherwise argok=0; 
    end
  elseif isstruct(varargin{i}) && isfield(varargin{i},'type'), 
    switch varargin{i}.type, 
     case 'som_topol',
      sTopol = varargin{i}; 
     case 'som_map', 
      sMap = varargin{i};
      sTopol = sMap.topol;
     otherwise argok=0; 
    end
  else
    argok = 0; 
  end
  if ~argok, 
    disp(['(som_topol_struct) Ignoring invalid argument #' num2str(i)]); 
  end
  i = i+1; 
end

if length(sTopol.msize)==1, sTopol.msize = [sTopol.msize 1]; end

if ~isempty(sMap), 
  [munits dim2] = size(sMap.codebook);
  if dim2 ~= dim, error('Map and data must have the same dimension.'); end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% create map

% map struct
if ~isempty(sMap), 
  sMap = som_set(sMap,'topol',sTopol);
else  
  if ~prod(sTopol.msize), 
    if isnan(munits), 
      sTopol = som_topol_struct('data',D,sTopol);
    else
      sTopol = som_topol_struct('data',D,'munits',munits,sTopol);
    end
  end  
  sMap = som_map_struct(dim, sTopol); 
end

if struct_mode, 
  sMap = som_set(sMap,'comp_names',comp_names,'comp_norm',comp_norm);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% initialization

% train struct
sTrain = som_train_struct('algorithm','lininit');
sTrain = som_set(sTrain,'data_name',data_name);

msize = sMap.topol.msize;
mdim = length(msize);
munits = prod(msize);

[dlen dim] = size(D);
if dlen<2,  
  %if dlen==1, sMap.codebook = (sMap.codebook - 0.5)*diag(D); end
  error(['Linear map initialization requires at least two NaN-free' ...
	 ' samples.']);
  return;
end

% compute principle components
if dim > 1 && sum(msize > 1) > 1,
  % calculate mdim largest eigenvalues and their corresponding
  % eigenvectors
    
  % autocorrelation matrix
  A = zeros(dim);
  me = zeros(1,dim);
  for i=1:dim, 
    me(i) = mean(D(isfinite(D(:,i)),i)); 
    D(:,i) = D(:,i) - me(i); 
  end  
  for i=1:dim, 
    for j=i:dim, 
      c = D(:,i).*D(:,j); c = c(isfinite(c));
      A(i,j) = sum(c)/length(c); A(j,i) = A(i,j); 
    end
  end
  
  % take mdim first eigenvectors with the greatest eigenvalues
  [V,S]   = eig(A);
  eigval  = diag(S);
  [y,ind] = sort(eigval); 
  eigval  = eigval(flipud(ind));
  V       = V(:,flipud(ind)); 
  V       = V(:,1:mdim);
  eigval  = eigval(1:mdim);   

  % normalize eigenvectors to unit length and multiply them by 
  % corresponding (square-root-of-)eigenvalues
  for i=1:mdim, V(:,i) = (V(:,i) / norm(V(:,i))) * sqrt(eigval(i)); end
 
else

  me = zeros(1,dim);
  V = zeros(1,dim);
  for i=1:dim, 
    inds = find(~isnan(D(:,i)));
    me(i) = mean(D(inds,i),1);
    V(i) = std(D(inds,i),1);
  end
% V=[0.00958879526207109*1.5,-0.00779737780783019*1.5; 0.283326404536801*1.5,0.00452006301382064*1.5;0.0220310651058111*1.5,0.00391007744947073*1.5;0.00636808617766561*1.5,0.000210918684697848*1.5;0.00103872349520461*1.5,0.00197980261238697*1.5;-0.00146121361005919*1.5,0.00404520796248628*1.5;9.91511068568749e-06*1.5,0.00202985111857113*1.5;0.0263684269875564,0.211130665887653;-0.0322687576714129,0.202123002403337;-0.00385496618483132,0.000483625896731174;-0.00141420598093253,0.00163409724429723;0.0894181866108887,-0.00369374293358828]; 
%V=[0.0166395562317037*0.15,-0.00771007923316588*0.15;0.280651711726357*0.15,0.00826675133257890*0.15;0.0319150531883902,0.00384727642131993;0.00898849514958102,0.000144763628686623;0.00190728175701611,0.00188702591599177;-0.00139080676310913,0.00393450099980165;0.000818120692562701,0.00192216304947351;0.0159715180326363,0.212241860741840;-0.0267539488621604,0.200865005046224;0.113180172508095,-0.00292864907503868]
end

V=[0.6*-0.171814064082838	0.6*-0.237399033593973;
0.5*-0.254638463408684	0.5*0.161021070893949;
-0.186614317813562	-0.00114495661555094];
% initialize codebook vectors
if dim>1, 
  sMap.codebook = me(ones(munits,1),:); 
  Coords = som_unit_coords(msize,'hexa','sheet');
  cox = Coords(:,1); Coords(:,1) = Coords(:,2); Coords(:,2) = cox;
  for i=1:mdim,
    ma = max(Coords(:,i)); mi = min(Coords(:,i)); 
    if ma>mi, Coords(:,i) = (Coords(:,i)-mi)/(ma-mi)*2.4; else Coords(:,i) = 0.5; end
  end
  Coords = (Coords-1.2)*2;
  for n = 1:munits,   
    for d = 1:mdim,    
      sMap.codebook(n,:) = sMap.codebook(n,:)+Coords(n,d)*V(:, d)';
    end
  end
else  
  sMap.codebook = [0:(munits-1)]'/(munits-1)*(max(D)-min(D))+min(D);
end

% training struct
sTrain = som_set(sTrain,'time',datestr(now,0));
sMap.trainhist = sTrain;

return;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%