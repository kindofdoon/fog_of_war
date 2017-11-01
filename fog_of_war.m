function fog_of_war

    % Pulls a map image from Google Static Maps, then overlays an opacity
    % image to un-shade regions that have been visited.
    
    % Must run parse_google_location_data.m first to generate the data file
    % required for this function.
    
    % DWD 17-1031

    %% User inputs
    location_data_filename = 'Location History.mat';
    
    % Define geographic region of interest
    center = 'Somerville_MA'; % define as [lat, long] or 'underscore_separated_plain_english_name'
    zoom = 15; % 1: world, 5: continent, 10: city, 15:streets, 20: buildings
    
    % Display parameters
    maptype = 'hybrid'; % satellite, hybrid, roadmap, or terrain
    circ_diam = 4; % larger = larger view distance
    scale = 1; % 1: 640x640 image, 2: 1280x1280 image; no other values supported currently
    
              % Opacity map parameters
              % standard deviation, opacity;...
    layers = [...
                6, 0.25;...
                2.5, 1;...
             ];

    %% Prepare data
    load(location_data_filename,'loc') % load location data
    if ischar(center)
        save_name = center;
        [center] = location_name_to_lat_lon(center); % translate
    else % user input lat/long instead of place name
        save_name = [num2str(center(1)) '_' num2str(center(2))];
    end
    save_name = [save_name '_' maptype '_' num2str(zoom) '.png'];
    [lon, lat, IM_map] = plot_google_map('maptype', maptype, 'zoom', zoom, 'center', center, 'scale', scale);
    
    % Crop locations outside domain of interest
    a = 1;
    loc_ = zeros(size(loc));
    for i = 1:size(loc,1)
        if loc(i,1)<max(lat) && loc(i,1)>min(lat) && loc(i,2)<max(lon) && loc(i,2)>min(lon) % if within range
            loc_(a,:) = loc(i,:);
            a = a+1;
        end
    end
    loc = loc_;
    clear loc_
    loc = loc(1:a-1,:);
    
    %% Generate the fog image
    ax_lim = [min(lon) max(lon) min(lat) max(lat)];
    IM_fog = circle_scatter_image(loc, circ_diam, ax_lim);
    IM_fog = double(IM_fog);
    if scale == 2
        IM_fog = imresize(IM_fog,2);
    end
         
    % Build up the opacity mask
    IM_opa = zeros([size(IM_map,1),size(IM_map,2)]) + 0.15; % opacity map
    for i = 1:size(layers,1)
        IM_blu = imgaussfilt(IM_fog,layers(i,1)); % blurred
        IM_blu = rgb2gray(IM_blu);
        IM_blu = IM_blu./max(max(IM_blu)); % normalize to [0 1]
        
        IM_opa = IM_opa + IM_blu .* layers(i,2);
    end
    IM_opa(IM_opa > 1) = 1;
    
    
    %% Prepare and output the final image
    IM_res = zeros(size(IM_map));
    IM_blk = zeros(size(IM_opa));
    
    for cc = 1:3 % for each color channels
        IM_res(:,:,cc) = IM_blk + IM_map(:,:,cc) .* IM_opa;
    end
    
    figure(1)
    clf
    image(IM_res)
    axis tight
    axis equal
    imwrite(IM_res,save_name)

end


















































