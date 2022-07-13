// _______
// Method: [Finished_Goods_Locations].aMsWMS_Comparison   ( ) ->
// By: Mel Bohince @ 11/10/20, 10:41:51
// Description
// 
// ----------------------------------------------------

app_form_Mgmt

Case of 
	: (Form event code:C388=On Load:K2:1)
		
		Form:C1466.message:="under contruction"
		
		
	: (Form event code:C388=On Close Box:K2:21)
		HIDE PROCESS:C324(Current process:C322)
		
End case 