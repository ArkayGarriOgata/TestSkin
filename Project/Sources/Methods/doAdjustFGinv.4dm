//%attributes = {"publishedWeb":true}
//Procedure: doAdjustFGinv()  120996  mBohince
//permit quantity adjustments to FG bins
//(P) gRMadj: allows returning Raw Materials between Locations
//• 3/27/97 cs fix reason for transactio to 'Phys Inv' if aunched from 
//  physical inventory pallette
//• 11/13/97 cs changed window opning routine & size, cleaned up window list

C_BOOLEAN:C305(fPiActive)

fPiActive:=<>fPiActive  //set local to interprocess
<>fPiActive:=False:C215  //reset interprocess

NewWindow(375; 230; 2; 4; nGetPrcsName; "wCloseCancel")  // Modified by: Mark Zinke (10/22/13) Changed window size and type

SET MENU BAR:C67(4)
READ WRITE:C146([Finished_Goods_Locations:35])
READ ONLY:C145([Finished_Goods:26])
READ WRITE:C146([Job_Forms_Items:44])
READ WRITE:C146([Finished_Goods_Transactions:33])

DIALOG:C40([zz_control:1]; "FGAdjust")

UNLOAD RECORD:C212([Finished_Goods_Locations:35])
UNLOAD RECORD:C212([Job_Forms_Items:44])
UNLOAD RECORD:C212([Finished_Goods_Transactions:33])
CLOSE WINDOW:C154
uWinListCleanup