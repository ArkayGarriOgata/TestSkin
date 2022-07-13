//FM: Input() -> 
//@author mlb - 10/25/02  17:01

Case of 
	: (Form event code:C388=On Load:K2:1)
		If (Is new record:C668([Job_Forms_Production_Histories:121]))
			If (Length:C16(sProcessSpecKey)>6)
				[Job_Forms_Production_Histories:121]ProcessSpecKey:1:=sProcessSpecKey
				If (Length:C16(<>jobform)=8)
					[Job_Forms_Production_Histories:121]jobform:6:=<>jobform
				End if 
				[Job_Forms_Production_Histories:121]Created:2:=TSTimeStamp
				[Job_Forms_Production_Histories:121]ModWho:3:=<>zResp
				[Job_Forms_Production_Histories:121]ModDate:4:=4D_Current_date
				[Job_Forms_Production_Histories:121]Department:7:=sCostCenter
				[Job_Forms_Production_Histories:121]CustomerName:8:=sCustomerName
				[Job_Forms_Production_Histories:121]CustomerLine:9:=sBrand
			Else 
				CANCEL:C270
			End if 
		End if 
		
		C_TEXT:C284(tText)
		tText:=TS2String([Job_Forms_Production_Histories:121]Created:2)
		
End case 