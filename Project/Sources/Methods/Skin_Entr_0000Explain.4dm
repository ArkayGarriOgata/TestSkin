//%attributes = {}
/* Source button: opens finder and allows selection on one or more files
 This selection will only allow the user to select picture files

 Desitination Button: opens finder and allows the selection of a folder
 for the destination of the processed files (those selected from the "Source" button)
 There will be no default destination, the user sepecification is required

 The fields beside the Source and Destination buttons will display the path
 to the file(s) or folder selected

 the Hlist will display the selected files, allowing the user to double check their selection
 before processing

 The cancel button in the bottom right will erase the user's selection and close the form
 the check mark button in the bottom right will process the files in the Hlist but leave the form open

 On the event the check mark is clicked, the user will be prompted to whether the imported files are
 part of a current Skin Family, if so they will select it from the drop down, if not, they can choose to 
 enter a new family name manually


 POSSIBLE FAULTS
 - The user attempts to click the check mark before selected a source and/or desitnation
 -- The button is greyed out and not clickable until a source or destination is selected

 - The user selected a folder with no valid picture sources
 -- In this case the Hlist will be empty and if the check mark is clicked, the user will be alerted that
 -- there are no valid picture files in the given source

*/