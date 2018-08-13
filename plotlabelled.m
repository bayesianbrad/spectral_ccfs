function plotlabelled(country,city,testcity, classes,server)
    if strcmp(city,testcity)
        disp('Cannot use same city and testcity');
        return
    end
    if ~exists('server','var')
        server = '';
    end
    
    base = strcat(server,'predictions/');
    full = strcat(base,country,'/',city,'/images/');
    img_mas = strcat(full,'pred_with_',testcity,'_image_mask.mat');
    image_mask = load(img_mas);
    image_mask = image_mask.image_mask;

    if classes==2
        cmap = [0,1];
        fig = imshow(image_mask);
%         lbl = {'Environment', 'Informal'};
%         % Add relevant legend
% %         lgd = legend(lbl,'location','southoutside');
         fsave = strcat(full,testcity,'_binarysegmented.jpg');
        saveas(fig, fsave);
    elseif classes==7
        image_mask1 = image_mask;
        image_mask2 = image_mask;
        image_mask3 = image_mask;

        color_arr1 = [0,1,1,0,1,0,0];
        color_arr2 = [0,1,0,1,0,1,0];
        color_arr3 = [0,0,1,1,0,0,1];
         for ii = 1:classes
            image_mask1(image_mask1 == ii -1) = color_arr1(ii);
            image_mask2(image_mask2 == ii -1) = color_arr2(ii);
            image_mask3(image_mask3 == ii -1) = color_arr3(ii);
         end
        rgb_image_mask= cat(3,image_mask1, image_mask2, image_mask3);
        fig = imshow(rgb_image_mask);
        % Creating the legend
        lbl = {'Environment', 'Metal', 'Tiles', 'Shingles', 'Thatch','Plastic', 'Asbestos'};
        cmap = horzcat(color_arr1',color_arr2',color_arr3');
        colormap(cmap);
        % Add relevant legend
        for ii = 1:size(cmap,1)
            p(ii) = patch(NaN, NaN, cmap(ii,:));
        end
        legend(p, lbl);
        fsave = strcat(full,city,'_colorsegmented.jpg');
        saveas(fig, fsave);
         
    end
    
end
