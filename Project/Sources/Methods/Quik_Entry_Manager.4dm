//%attributes = {}
//Method:  Quik_Entry_Manager
//Description:  This method will manage buttons

If (True:C214)  //Initialize
	
	C_LONGINT:C283($nBottom; $nLeft)
	C_LONGINT:C283($nMove; $nRight; $nTop)
	C_LONGINT:C283($nFormEvent)
	
	C_BOOLEAN:C305($bMustShowQuery)
	
	$nFormEvent:=Form event code:C388
	
	$bMustShowQuery:=False:C215
	
End if   //Done Initialize

If ((Quik_tEntry_QuickKey=CorektBlank) & ($nFormEvent=On Load:K2:1))  //New
	
	OBJECT SET VISIBLE:C603(Quik_nEntry_Export; False:C215)  //Export not needed
	
	OBJECT SET VISIBLE:C603(Quik_nEntry_Delete; False:C215)  //Delete not needed
	OBJECT GET COORDINATES:C663(Quik_nEntry_Delete; $nLeft; $nTop; $nRight; $nBottom)
	$nMove:=$nRight-$nLeft
	OBJECT MOVE:C664(CorenCancel; $nMove; 0)
	
End if   //Done new

If (BLOB size:C605(Quik_lEntry_Query)#0)  //Show query
	
	Quik_Query_Execute(->Quik_lEntry_Query; ->$bMustShowQuery)
	
	If ($bMustShowQuery)
		
		Quik_nEntry_ShowQuery:=1
		
		OBJECT SET VISIBLE:C603(*; "Quik_Entry_ShowQuery"; True:C214)
		OBJECT SET VISIBLE:C603(Quik_nEntry_ShowQuery; False:C215)
		
	End if 
	
End if   //Done show query

OBJECT SET ENABLED:C1123(Quik_nEntry_Save; Quik_Entry_VerifyB)
