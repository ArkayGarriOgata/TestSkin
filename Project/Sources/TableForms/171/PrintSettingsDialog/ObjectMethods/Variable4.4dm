$units:=Num:C11(sCriterion4)

If ($units<51)  // Modified by: Mel Bohince (4/11/18) someone made over a thousand once
	
	If ($units>0)
		If (receiptQty>$units)
			iQty:=Int:C8(receiptQty/$units)
		Else 
			iQty:=0
		End if 
		
	Else 
		iQty:=0
	End if 
	
Else 
	uConfirm("You can only make 50 labels at a time."; "Try Again"; "Opps")
	sCriterion4:="0"
	GOTO OBJECT:C206(sCriterion4)
End if 
