function [coords] = location_name_to_lat_lon(loc_name)

    % Uses the Google Maps Geocoding API to translate an plain-English
    % location to latitude-longitude coordinates.
    
    % Documentation: https://developers.google.com/maps/documentation/geocoding/start
    
    % DWD 17-1031
    
    tic
    
    filename = 'temp.json';
    API_key = ''; % add your API_key if desired
    URL = ['https://maps.googleapis.com/maps/api/geocode/json?address=' loc_name '&key=' API_key];
    
    urlwrite(URL, [filename]);
    fileID = fopen(filename,'r');
    data = textscan(fileID,'%s','Delimiter','\n');
    data = data{1,1};
    
    lat = -1.111111; % set as defaults
    lon = -1.111111;
    
    for i = 1:size(data,1) % for each line
        if strcmp(data{i,1},'"location" : {') == 1
            lat_str = data{i+1};
            lat = str2num(lat_str(9:end-1));
            lon_str = data{i+2};
            lon =  str2num(lon_str(9:end-1));
        end
    end
    coords = [lat lon];
    
    fclose('all');
    delete(filename)

end