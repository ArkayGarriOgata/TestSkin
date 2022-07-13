//%attributes = {"publishedWeb":true}
//PM: FG_PrepServiceUpdate() -> 
//@author mlb - 8/29/02  07:20

C_TEXT:C284($1; $2)

Case of 
	: (Count parameters:C259=0)
		$ctrlNum:=Request:C163("Enter the control number:"; "")
		If (OK=1)
			$pid:=New process:C317("FG_PrepServiceUpdate"; <>lMinMemPart; "Update FG_Specification"; "Update"; $ctrlNum)
			If (False:C215)
				FG_PrepServiceUpdate
			End if 
		End if 
		
	: (Count parameters:C259=1)
		$ctrlNum:=$1
		$pid:=New process:C317("FG_PrepServiceUpdate"; <>lMinMemPart; "Update FG_Specification"; "Update"; $ctrlNum)
		
	Else 
		SET MENU BAR:C67(<>DefaultMenu)
		Case of 
			: ($1="Update")
				READ WRITE:C146([Finished_Goods_Specifications:98])
				READ WRITE:C146([Finished_Goods:26])
				QUERY:C277([Finished_Goods_Specifications:98]; [Finished_Goods_Specifications:98]ControlNumber:2=$2)
				If (Records in selection:C76([Finished_Goods_Specifications:98])>0)
					If (fLockNLoad(->[Finished_Goods_Specifications:98]))
						FORM SET INPUT:C55([Finished_Goods_Specifications:98]; "Input")
						C_LONGINT:C283(iJMLTabs)
						iJMLTabs:=0
						
						FORM SET OUTPUT:C54([Finished_Goods_Specifications:98]; "List")
						winTitle:="Updating FG_Specification"
						$winRef:=Open form window:C675([Finished_Goods_Specifications:98]; "Input"; 8)
						MODIFY RECORD:C57([Finished_Goods_Specifications:98]; *)
						CLOSE WINDOW:C154($winRef)
						REDUCE SELECTION:C351([Finished_Goods_Specifications:98]; 0)
						REDUCE SELECTION:C351([Finished_Goods:26]; 0)
						READ ONLY:C145([Finished_Goods_Specifications:98])
						READ ONLY:C145([Finished_Goods:26])
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