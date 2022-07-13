//%attributes = {"publishedWeb":true}
//PM: FG_PrepServiceAdditionalRequest() -> 
//@author mlb - 8/29/02  07:20

C_TEXT:C284($1; $2)

Case of 
	: (Count parameters:C259=0)
		$ctrlNum:=Request:C163("Enter the control number:"; "")
		If (OK=1)
			$pid:=New process:C317("FG_PrepServiceAdditionalRequest"; <>lMinMemPart; "Update FG_Specification"; "Update"; $ctrlNum)
			If (False:C215)
				FG_PrepServiceAdditionalRequest
			End if 
			
		End if 
		
	: (Count parameters:C259=1)
		$ctrlNum:=$1
		$pid:=New process:C317("FG_PrepServiceAdditionalRequest"; <>lMinMemPart; "Update FG_Specification"; "Update"; $ctrlNum)
		
	Else 
		SET MENU BAR:C67(<>DefaultMenu)
		Case of 
			: ($1="Update")
				READ WRITE:C146([Finished_Goods_Specifications:98])
				READ WRITE:C146([Finished_Goods:26])
				QUERY:C277([Finished_Goods_Specifications:98]; [Finished_Goods_Specifications:98]ControlNumber:2=$2)
				If (Records in selection:C76([Finished_Goods_Specifications:98])>0)
					If ([Finished_Goods_Specifications:98]DatePrepDone:6#!00-00-00!)  //got to finish first
						If (Not:C34([Finished_Goods_Specifications:98]AdditionalReqs:69))  //only one at a time
							If (fLockNLoad(->[Finished_Goods_Specifications:98]))
								lastTab:=Num:C11([Finished_Goods_Specifications:98]ServiceRequested:54)+1
								[Finished_Goods_Specifications:98]ServiceRequested:54:=String:C10(lastTab)
								[Finished_Goods_Specifications:98]AdditionalReqs:69:=True:C214
								[Finished_Goods_Specifications:98]CommentsFromPlanner:19:="ADDITIONAL REQUESTS:"+String:C10(4D_Current_date)+Char:C90(13)+[Finished_Goods_Specifications:98]CommentsFromPlanner:19
								SAVE RECORD:C53([Finished_Goods_Specifications:98])
								FG_PrepAddCharges([Finished_Goods_Specifications:98]ControlNumber:2)
								FORM SET INPUT:C55([Finished_Goods_Specifications:98]; "Input")
								C_LONGINT:C283(iJMLTabs)
								iJMLTabs:=0
								
								FORM SET OUTPUT:C54([Finished_Goods_Specifications:98]; "List")
								
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
							ALERT:C41($2+" has pending Additional Requests."; "Tell Imaging What else you need")
						End if 
						
					Else 
						BEEP:C151
						ALERT:C41($2+" has not been marked as PrepDone."; "Tell Imaging What you need")
					End if 
					
				Else 
					BEEP:C151
					ALERT:C41($2+" was not found."; "What?")
				End if 
		End case 
End case 