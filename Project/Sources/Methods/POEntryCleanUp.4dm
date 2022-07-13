//%attributes = {"publishedWeb":true}
// ----------------------------------------------------
// Method: POEntryCleanUp
// ----------------------------------------------------

uClearSelection(->[Raw_Materials:21])
uClearSelection(->[Purchase_Orders_Job_forms:59])
uClearSelection(->[Purchase_Orders_Clauses:14])
//REDUCE SELECTION([Purchase_Orders_Items];0)

fPOMaint:=False:C215  //bAcceptRec

ARRAY TEXT:C222(abuy; 0)  //clear popups -disables them
ARRAY TEXT:C222(aterm; 0)
ARRAY TEXT:C222(ashipvia; 0)
ARRAY TEXT:C222(afob; 0)
ARRAY TEXT:C222(astat; 0)
ARRAY TEXT:C222(aDepartment; 0)
ARRAY TEXT:C222(aUom; 0)  //disbale popups
ARRAY TEXT:C222(aCommCode; 0)
ARRAY TEXT:C222(aExpCode; 0)
ARRAY TEXT:C222(aSubGroup; 0)  //• 7/15/97 cs missed disabling when in rev