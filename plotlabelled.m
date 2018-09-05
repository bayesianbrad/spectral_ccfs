function plotlabelled(country,city,testcity, classes,method, cmap, lbl,ntrees,server)

% lbl - cell array of strings - strings correspond to the classes of
% materials
% cmap - depends on the number of classes. If binary cmap = [0,1;0,1;0,1] is
% optimal. If multiple-class then you need to have a 3 x 1 array for each
% class. I.e for four classes [0 0 1 1; 0 0 0 0; 0 1 0 0]. Each vertical
% entry must be unique, to ensure that the colour assigned to the class is
% unqiue. 

%     if strcmp(city,testcity)
%         disp('Cannot use same city and testcity');
%         return
%     end
    if ~exist('server','var')
        server = '';
    end
    if ~exist('lbl','var')
        lbl = {};
    end
    max_col = max(cmap);
    min_col = min(cmap);
    if max_col > 1 || min_col < 0
        disp('Warning : Matlab colour palette requires values between 0 and 1, exiting ');
        return
    end
        
    base = strcat(server,'predictions/',method,'/');
    full = strcat(base,country,'/',city,'/images/');
    if strcmp(testcity, 'on_Afrobarometer')
        img_mas  = strcat(full,'pred_with_',testcity,'_',num2str(ntrees),'_image_mask.mat');
    else
        img_mas = strcat(full,'pred_with_',testcity,'_image_mask.mat');
    end
    
    image_mask = load(img_mas);
    image_mask = image_mask.image_mask;

   
    image_mask1 = image_mask;
    image_mask2 = image_mask;
    image_mask3 = image_mask;
     for ii = 1:classes
        image_mask1(image_mask1 == ii -1) = cmap(1,ii);
        image_mask2(image_mask2 == ii -1) = cmap(2,ii);
        image_mask3(image_mask3 == ii -1) = cmap(3,ii);
     end
    rgb_image_mask= cat(3,image_mask1, image_mask2, image_mask3);
    fig = imshow(rgb_image_mask);
    % Creating the legend
    colormap(cmap');
    % Add relevant legend
    for ii = 1:size(cmap,1)
        p(ii) = patch(NaN, NaN, cmap(ii,:));
    end
    legend(p, lbl);
    fsave = strcat(full,city,'_colorsegmented.jpg');
    saveas(fig, fsave);

end


