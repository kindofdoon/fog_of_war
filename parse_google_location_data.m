function parse_google_location_data

    % Reads a JSON location history file from Google, and
    % parses it into a latitude/longitude matrix.
    
    % DWD 17-1031

    %% Instructions
    
    % Go to: https://takeout.google.com/settings/takeout
    % Log in if needed
    % Click "Select none"
    % Check "Location History"
    % Verify that format is set to "JSON"
    % Scroll to bottom, click "Next"
    % Click "Create archive"
    % Wait, then click "Download"
    % Enter your password
    % Open the .zip file that was downloaded
    % Click "Extract all files"
    % Unzip to same directory as this function
    % Cut/paste ...\Takeout\Location History\Location History.json to same directory as this function
    % Delete "Takeout" folder
    
    %% User inputs
    filename = 'Location History.json';
    
    %% Parse the data
    fileID = fopen(filename,'r');
    data = textscan(fileID,'%s','Delimiter','\n');
    data = data{1,1};
    
    loc = zeros(size(data,1),2);
    lat_ind = 1;
    lon_ind = 1;
    tic
    
    for i = 1:size(data,1)
        line = data{i,1};
        if isempty(findstr(line,'E7'))==0 % found location data
            if isempty(findstr(line,'lat'))==0 % if latitude data
                loc(lat_ind,1) = str2double(line(16:end-1));
                lat_ind = lat_ind+1;
            else % longitude data
                loc(lon_ind,2) = str2double(line(16:end-1));
                lon_ind = lon_ind+1;
            end
        end
    end
    
    % Crop space that was allocated but not used
    loc(loc==0) = [];
    loc = reshape(loc,[size(loc,2)/2,2]);
    loc = loc./10^7; % convert from integer format to double
    
    runtime = toc;
    disp(['Parsed ' num2str(size(data,1)) ' lines in ' num2str(runtime) ' seconds, ' num2str(round(size(data,1)/runtime)) ' lines/second.'])
    save_name = [filename(1:end-5) '.mat'];
    save(save_name,'loc')
    disp(['Matrix of lat/lon points saved to file ' save_name])

end