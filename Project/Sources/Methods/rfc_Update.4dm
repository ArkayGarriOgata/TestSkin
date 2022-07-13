//%attributes = {}
// Method: rfc_Update () -> 
// ----------------------------------------------------
// by: mel: 02/26/04, 10:52:37
// ----------------------------------------------------
//based on: FG_PrepServiceUpdate() -> 
//@author mlb - 8/29/02  07:20

C_TEXT:C284($1; $2)

Case of 
	: (Count parameters:C259=0)
		$ctrlNum:=Request:C163("Enter the file/outline number:"; "")
		If (ok=1)
			$pid:=New process:C317("rfc_Update"; <>lMinMemPart; "Update Request for Construction"; "Update"; $ctrlNum)
			If (False:C215)
				rfc_Update
			End if 
		End if 
		
	: (Count parameters:C259=1)
		$ctrlNum:=$1
		$pid:=New process:C317("rfc_Update"; <>lMinMemPart; "Update Request for Construction"; "Update"; $ctrlNum)
		
	Else 
		SET MENU BAR:C67(<>DefaultMenu)
		Case of 
			: ($1="Update")
				READ WRITE:C146([Finished_Goods_SizeAndStyles:132])
				
				QUERY:C277([Finished_Goods_SizeAndStyles:132]; [Finished_Goods_SizeAndStyles:132]FileOutlineNum:1=$2)
				If (Records in selection:C76([Finished_Goods_SizeAndStyles:132])>0)
					If (fLockNLoad(->[Finished_Goods_SizeAndStyles:132]))
						FORM SET INPUT:C55([Finished_Goods_SizeAndStyles:132]; "Input")
						//C_LONGINT(iJMLTabs)
						//iJMLTabs:=0
						
						FORM SET OUTPUT:C54([Finished_Goods_SizeAndStyles:132]; "List")
						
						$winRef:=Open form window:C675([Finished_Goods_SizeAndStyles:132]; "Input"; 8)
						MODIFY RECORD:C57([Finished_Goods_SizeAndStyles:132]; *)
						CLOSE WINDOW:C154($winRef)
						REDUCE SELECTION:C351([Finished_Goods_SizeAndStyles:132]; 0)
						
						READ ONLY:C145([Finished_Goods_SizeAndStyles:132])
						
					Else 
						BEEP:C151
						ALERT:C41($2+" was locked."; "Try Later")
					End if 
					
				Else 
					BEEP:C151
					ALERT:C41($2+" was not found."; "What?")
				End if 
		End case 
End case 