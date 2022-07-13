// _______
// Method: [Raw_Materials_Locations].Reconciliation   ( ) ->
// By: Mel Bohince @ 04/15/19, 15:55:16
// Description
// 
// ----------------------------------------------------
// Modified by: Mel Bohince (11/15/21) 
// Modified by: MelvinBohince (4/5/22) disable Review RM btn until there is a selection

C_POINTER:C301($ptr_radio_btn_all; $ptr_radio_btn_problems; $ptr_radio_btn_orphans)


Case of 
	: (Form event code:C388=On Load:K2:1)
		$ptr_radio_btn_problems:=OBJECT Get pointer:C1124(Object named:K67:5; "Qty_Mismatches")
		$ptr_radio_btn_all:=OBJECT Get pointer:C1124(Object named:K67:5; "Qty_All")
		$ptr_radio_btn_orphans:=OBJECT Get pointer:C1124(Object named:K67:5; "Orphans")
		
		If (Records in selection:C76([Raw_Material_Labels:171])=0)  //when problems, we start with none
			$ptr_radio_btn_problems->:=1
			$ptr_radio_btn_all->:=0
			$ptr_radio_btn_orphans->:=0
			
		Else   //all the positive [Raw_Material_Labels] are showing
			$ptr_radio_btn_problems->:=0
			$ptr_radio_btn_all->:=1
			$ptr_radio_btn_orphans->:=0
		End if 
		
		OBJECT SET ENABLED:C1123(*; "reviewRawMaterial"; False:C215)  // must select a po on the left list // Modified by: MelvinBohince (4/5/22) 
		
End case 
