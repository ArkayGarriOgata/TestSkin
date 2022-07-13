//%attributes = {"publishedWeb":true}
//(P) gRMadj: allows returning Raw Materials between Locations
//• 3/27/97 cs fix reason for transactio to 'Phys Inv' if aunched from 
//  physical inventory pallette

C_BOOLEAN:C305(fPiActive)

fPiActive:=<>fPiActive  //set local to interprocess
<>fPiActive:=False:C215  //reset interprocess
Open window:C153(2; 40; 312; 210; 0; nGetPrcsName; "wCloseCancel")
SET MENU BAR:C67(4)
READ WRITE:C146([Raw_Materials_Locations:25])
DIALOG:C40([zz_control:1]; "RMadjust")
UNLOAD RECORD:C212([Raw_Materials_Locations:25])
CLOSE WINDOW:C154
uWinListCleanup