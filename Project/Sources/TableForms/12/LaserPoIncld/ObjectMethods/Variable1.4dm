//(s) xText - Laser PO
//print Job Form(s) if they exist
//• 5/1/98 cs Flag canceld items on printout
//• mlb - 8/14/02  09:28 add Expediting Note
C_LONGINT:C283($Count)

If (Form event code:C388=On Printing Detail:K2:18)
	
	If ([Purchase_Orders_Items:12]Canceled:44)  //• 5/1/98 cs Flag canceld items on printout
		xText:="THIS ITEM HAS BEEN CANCELLED"
	Else 
		
		RELATE MANY:C262([Purchase_Orders_Items:12]POItemKey:1)
		$Count:=Records in selection:C76([Purchase_Orders_Job_forms:59])
		xText:=""
		xText:=("Job Form(s):   "*Num:C11($Count>0))
		If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 Next record
			
			For ($i; 1; $Count)
				xText:=xText+[Purchase_Orders_Job_forms:59]JobFormID:2+"  "
				NEXT RECORD:C51([Purchase_Orders_Job_forms:59])
			End for 
			
		Else 
			
			ARRAY TEXT:C222($_JobFormID; 0)
			SELECTION TO ARRAY:C260([Purchase_Orders_Job_forms:59]JobFormID:2; $_JobFormID)
			
			For ($i; 1; $Count; 1)
				
				xText:=xText+$_JobFormID{$i}+"  "
				
			End for 
			
		End if   // END 4D Professional Services : January 2019 First record
		
		xText:=xText+[Purchase_Orders_Items:12]ExpeditingNote:23  //• mlb - 8/14/02  09:28
		xText:=Replace string:C233(xText; "NEW Raw Material -- Purchasing - Please check data."; "")
	End if 
End if 
//