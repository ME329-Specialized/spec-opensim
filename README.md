# spec-opensim
Repo for organization of files relating to OpenSim simulation and modeling

**Trial runs summary/notes/comments google sheet:**
  https://docs.google.com/spreadsheets/d/1E5ZpY3X6rg-SnpGjvgGRdW8wEWR2rKgzLcXOoUtjTak/edit#gid=0
  
**CMC documentation notes google sheet:**
  https://docs.google.com/spreadsheets/d/1tlRTsjhUrV5lOEmkD4-OEeC3qJ00lyB67oOdPV3RoXY/edit#gid=0


**To run a CMC setup, open OpenSim .oism file in OpenSim:***
  >Tools (top bar) > Computed Muscle Control ... > Load...
      Open file named cyclingleg_Setup_CMC##
          All other setup files will automaticaly update BUT you will want to update the Output Directory to reflect a location on your computer
      Note: All .oism, .xml, .sto, .mot, .trc, etc. files can also be opened in a text editor in order to understand their purposes.
          See documentations google doc for more information.


**Folder Organization**
--CEC folder contains early files with incorrect OpenSim models (trial runs 1-6)
  -->CMC folder contains setup files (Actuators, Tracking Tasks (TT), GRFs, etc.)
    -->Results CMC folder (and subfolders) is where results are directed to be written

--MTP_r1 folder contains trial runs 7
  *.oism file was edited for adjusted preset of joint angle locking
    -->CMC folder contains setup files (Actuators, Tracking Tasks (TT), GRFs, etc.)
      -->Results CMC folder (and subfolders) is where results are directed to be written

--MTP_r1 folder contains trial runs 8
  *.oism file was edited for adjusted preset of joint angle locking
    -->CMC folder contains setup files (Actuators, Tracking Tasks (TT), GRFs, etc.)
      -->Results CMC folder (and subfolders) is where results are directed to be written
  
  
