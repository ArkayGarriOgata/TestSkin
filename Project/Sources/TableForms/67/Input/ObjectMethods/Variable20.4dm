//If (app_LoadIncludedSelection ("init";->[Finished_Goods]ProductCode)>0)
//
//$winRef:=Open form window([Finished_Goods];"Input4")
//INPUT FORM([Finished_Goods];"Input4")
//iMode:=2
//MODIFY RECORD([Finished_Goods];*)
//CLOSE WINDOW($winRef)
//
//CUT NAMED SELECTION([Finished_Goods];"redrawThem")
//USE NAMED SELECTION("redrawThem")
//app_LoadIncludedSelection ("clear")
//End if 
//  `
app_OpenSelectedIncludeRecords(->[Finished_Goods:26]ProductCode:1)