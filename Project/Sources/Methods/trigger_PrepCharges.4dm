//%attributes = {}
// ----------------------------------------------------
// User name: Mel Bohince
// Created: 02/01/07, 13:39:16
// ----------------------------------------------------
// Method: trigger_PrepCharges()  --> 
// ----------------------------------------------------

Case of 
	: (Trigger event:C369=On Saving New Record Event:K3:1)
		[Prep_Charges:103]Custid:9:=Substring:C12([Finished_Goods_Specifications:98]FG_Key:1; 1; 5)
		
End case 