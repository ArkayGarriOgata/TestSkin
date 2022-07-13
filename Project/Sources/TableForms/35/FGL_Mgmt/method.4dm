// _______
// Method: [Finished_Goods_Locations].FGL_Mgmt   ( ) ->
// By: Mel Bohince @ 09/23/20, 14:23:38
// Description
// 
// ----------------------------------------------------

// _______
// Method: app_form_Mgmt   ( ) ->
// By: Mel Bohince @ 04/23/20, 09:40:50
// Description
// 
// ----------------------------------------------------

Case of 
	: (Form event code:C388=On Load:K2:1)
		C_TEXT:C284(editorGroup; noticeText)
		editorGroup:=Form:C1466.editorGroup
		
		OBJECT SET VISIBLE:C603(*; "memberBtn@"; False:C215)  //cancel and save btns
		OBJECT SET ENTERABLE:C238(*; "memberEdit@"; False:C215)
		
	: (Form event code:C388=On Data Change:K2:15)
		If (Not:C34(OB Is empty:C1297(Form:C1466.editEntity)))
			OBJECT SET VISIBLE:C603(*; "memberBtn@"; Form:C1466.editEntity.touched())
			OBJECT SET ENABLED:C1123(*; "memberBtn@"; Form:C1466.editEntity.touched())
			
		Else   //null
			OBJECT SET VISIBLE:C603(*; "memberBtn@"; False:C215)
			OBJECT SET ENTERABLE:C238(*; "memberEdit@"; False:C215)
		End if   //null
		
End case 

