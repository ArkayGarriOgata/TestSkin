
Case of 
	: (Form event code:C388=On Load:K2:1)
		rb1:=1
		rb2:=0
		$hit:=Find in array:C230(aAvailablePrinters; currentPrinter)
		If ($hit>-1)
			aAvailablePrinters:=$hit
		Else 
			If (Size of array:C274(aAvailablePrinters)>0)
				AvailablePrinters:=1
			End if 
		End if 
		
		If (sMode="create")
			
			OBJECT SET ENABLED:C1123(sCriterion3; True:C214)
			iQty:=0
			OBJECT SET ENABLED:C1123(iQty; True:C214)
			sCriterion4:="1"
			OBJECT SET ENABLED:C1123(sCriterion4; True:C214)
			OBJECT SET ENABLED:C1123(receiptQty; True:C214)
			sCriterion5:="2"
			
		Else   //just print
			sCriterion3:="selected"
			OBJECT SET ENABLED:C1123(sCriterion3; False:C215)
			iQty:=[Raw_Material_Labels:171]Qty:8
			OBJECT SET ENABLED:C1123(iQty; False:C215)
			sCriterion4:=String:C10(Records in set:C195("UserSet"))
			OBJECT SET ENABLED:C1123(sCriterion4; False:C215)
			OBJECT SET ENABLED:C1123(receiptQty; False:C215)
			sCriterion5:="2"
		End if 
		
		
End case 
