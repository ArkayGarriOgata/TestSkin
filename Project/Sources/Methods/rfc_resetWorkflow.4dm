//%attributes = {}
// Method: rfc_resetWorkflow () -> 
// ----------------------------------------------------
// by: mel: 03/22/05, 08:59:14
// ----------------------------------------------------
// Description:
// after a duplicate, clear some stuf

// ----------------------------------------------------
C_TEXT:C284($1)  // Modified by: Mel Bohince (6/18/15) option to skip clearing brian date
// Removed by: Mel Bohince (6/25/20) protect 3 more approval fields when para, specifically for Additional requests.

[Finished_Goods_SizeAndStyles:132]DateDone:6:=!00-00-00!
[Finished_Goods_SizeAndStyles:132]Started_TimeStamp:4:=0
[Finished_Goods_SizeAndStyles:132]Priority:47:=0
[Finished_Goods_SizeAndStyles:132]DateSubmitted:5:=!00-00-00!
[Finished_Goods_SizeAndStyles:132]DateWanted:42:=!00-00-00!
[Finished_Goods_SizeAndStyles:132]qty_samples:35:=0
[Finished_Goods_SizeAndStyles:132]qty_DieOnDisk:36:=0
[Finished_Goods_SizeAndStyles:132]qty_EngDrawing:37:=0
[Finished_Goods_SizeAndStyles:132]qty_ArtBoard:38:=0
[Finished_Goods_SizeAndStyles:132]qty_ConvertDisk:39:=0
[Finished_Goods_SizeAndStyles:132]qty_DieSamples:40:=0
[Finished_Goods_SizeAndStyles:132]EstimatingOnly:55:=False:C215
[Finished_Goods_SizeAndStyles:132]Samples:28:=False:C215
[Finished_Goods_SizeAndStyles:132]DieOnDisk:29:=False:C215
[Finished_Goods_SizeAndStyles:132]EngDrawing:30:=False:C215
[Finished_Goods_SizeAndStyles:132]ArtBoardOverlay:31:=False:C215
[Finished_Goods_SizeAndStyles:132]ConveryFromDisk:32:=False:C215
[Finished_Goods_SizeAndStyles:132]DieSamples:33:=False:C215
[Finished_Goods_SizeAndStyles:132]EmailFile:34:=False:C215
[Finished_Goods_SizeAndStyles:132]EmailAddress:41:=""
[Finished_Goods_SizeAndStyles:132]TasksCompleted:56:="________"  //controlled by checkboxes on the screen
If (Count parameters:C259=0)  // Modified by: Mel Bohince (6/18/15)
	[Finished_Goods_SizeAndStyles:132]Brian_Approval:60:=!00-00-00!  // Modified by: Mel Bohince (5/8/14) 
	//end if // Removed by: Mel Bohince (6/25/20) 
	[Finished_Goods_SizeAndStyles:132]DateGlueApproved:46:=!00-00-00!
	[Finished_Goods_SizeAndStyles:132]DateApproved:8:=!00-00-00!
	[Finished_Goods_SizeAndStyles:132]Approved:9:=False:C215
End if 
