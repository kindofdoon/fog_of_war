# fog_of_war

Code for generating "fog of war" maps from real-world location data collected by Google via your mobile phone, in the style of classic real-time strategy video games, implemented in MATLAB.

DWD 17-1031

Instructions:

SETUP =================================

Go to: https://takeout.google.com/settings/takeout

Log in if needed

Click "Select none"

Check "Location History"

Verify that format is set to "JSON"

Scroll to bottom, click "Next"

Click "Create archive"

Wait, then click "Download"

Enter your password

Open the .zip file that was downloaded

Click "Extract all files"

Unzip to same directory as this function

Cut/paste ...\Takeout\Location History\Location History.json to same directory as this function

Delete "Takeout" folder

Run parse_google_location_data.m

MAIN BODY =================================

Open fog_of_war.m and adjust the user inputs for geographic region and shading settings, then save the function

Run fog_of_war.m

An image file of the shaded map will automatically be created in the working directory
