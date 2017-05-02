Instruction for running UHBMIGUI_NEUROLEG for Neuroleg data analysis.
1. Create 2 folders for storing raw data and processed data. e.g. "Raw Data", "Process Data"
2. Copy raw data files (.mat files) and captrack files (.bvct) to the Raw Data.
3. Run the UHBMIGUI_NEUROLEG matlab script to open the GUI.
4. At the GUI interface. Select Setting Menu -> Set Data Folder...
5. A small GUI will appear. Select "Raw Data" folder path for Raw Mat text box and "Process Data" folder path for Process Mat.
6. Save the setting. This setting will save "Raw Data" and "Process Data" folders as your default when the main GUI is run next times.
7. Go back to the main GUI (UHBMIGUI_NEUROLEG). Go to Function List and run Makeelecfile function to create .elc file for electrode positions.
8. Run MakeEEGfile. This function will combine EEG file and .elc file and create new file in the "Process Data" folder.
9. Data processing functions in Function List tree will run and update files in the "Process Data" Folder.

External:
1. uhlib. Copy uhlib folder and place at the same level with UHBMIGUI_NEUROLEG
2. EEGLAB. Add eeglab to matlab path.