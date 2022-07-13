// _______
// Method: [Job_Forms_Master_Schedule].ScreenShot2   ( ) ->
// By: Mel Bohince @ 04/14/21, 16:05:01
// Description
// 
// ----------------------------------------------------


Case of 
	: (Form event code:C388=On Printing Detail:K2:18)
		JML_setColors
		whereIsBag:=JTB_findLastCheckin([Job_Forms_Master_Schedule:67]JobForm:4)
		
End case 