function plotlabelled(country,city,testcity, classes,server)
<<<<<<< HEAD
%     if strcmp(city,testcity)
%         disp('Cannot use same city and testcity');
%         return
%     end
    if ~exist('server','var')
=======
    if strcmp(city,testcity)
        disp('Cannot use same city and testcity');
        return
    end
    if ~exists('server','var')
>>>>>>> 444654aafb9f6af71cfaf2c708b349a3520c148f
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

<<<<<<< HEAD
        color_arr1 = [0,1,0,0,0,0,0];
        color_arr2 = [0,1,0,0,0,0,0];
        color_arr3 = [0,0,0,0,0,0,0];
=======
        color_arr1 = [0,1,1,0,1,0,0];
        color_arr2 = [0,1,0,1,0,1,0];
        color_arr3 = [0,0,1,1,0,0,1];
>>>>>>> 444654aafb9f6af71cfaf2c708b349a3520c148f
         for ii = 1:classes
            image_mask1(image_mask1 == ii -1) = color_arr1(ii);
            image_mask2(image_mask2 == ii -1) = color_arr2(ii);
            image_mask3(image_mask3 == ii -1) = color_arr3(ii);
         end
        rgb_image_mask= cat(3,image_mask1, image_mask2, image_mask3);
        fig = imshow(rgb_image_mask);
        % Creating the legend
<<<<<<< HEAD
        lbl = {'Environment', 'Metal'};
        cmap = horzcat(color_arr1([1,2])',color_arr2([1,2])',color_arr3([1,2])');
=======
        lbl = {'Environment', 'Metal', 'Tiles', 'Shingles', 'Thatch','Plastic', 'Asbestos'};
        cmap = horzcat(color_arr1',color_arr2',color_arr3');
>>>>>>> 444654aafb9f6af71cfaf2c708b349a3520c148f
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
