READ ONLY:C145([Raw_Materials_Transactions:23])
QUERY:C277([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]JobForm:12=sJobform; *)
QUERY:C277([Raw_Materials_Transactions:23];  & ; [Raw_Materials_Transactions:23]Xfer_Type:2="issue")
sCriterion2:=""
sCriterion3:=""
rReal1:=0
ARRAY TEXT:C222(aPOIpoiKey; 0)
ARRAY REAL:C219(asQty; 0)
ARRAY TEXT:C222(aComm; 0)
ARRAY TEXT:C222(aRMcode; 0)
ARRAY TEXT:C222(aText; 0)
aText{0}:=""

If (Records in selection:C76([Raw_Materials_Transactions:23])>0)
	READ ONLY:C145([Job_Forms:42])
	SET QUERY LIMIT:C395(1)
	QUERY:C277([Job_Forms:42]; [Job_Forms:42]JobFormID:5=sJobform)
	SET QUERY LIMIT:C395(0)
	READ ONLY:C145([Jobs:15])
	RELATE ONE:C42([Job_Forms:42]JobNo:2)
	tText:=[Jobs:15]Line:3
	
	SELECTION TO ARRAY:C260([Raw_Materials_Transactions:23]POItemKey:4; aPOIpoiKey; [Raw_Materials_Transactions:23]Qty:6; asQty; [Raw_Materials_Transactions:23]Commodity_Key:22; aComm; [Raw_Materials_Transactions:23]Raw_Matl_Code:1; aRMcode)
	SORT ARRAY:C229(aComm; aRMcode; aPOIpoiKey; asQty; >)
	ARRAY TEXT:C222(aText; Size of array:C274(aComm))
	For ($i; 1; Size of array:C274(aComm))
		aText{$i}:=aPOIpoiKey{$i}+"-"+aComm{$i}+":"+aRMcode{$i}
	End for 
	aPOIpoiKey:=0
	asQty:=0
	aText:=0
	aComm:=0
	aRMcode:=0
	aText{0}:="Now select a PO-->"
	GOTO OBJECT:C206(aText{0})
	
Else 
	BEEP:C151
	ALERT:C41("There have been no R/M issues to job "+sJobform; "Try Again")
	sJobform:=""
	tText:="Enter a Jobform with issues"
	GOTO OBJECT:C206(sCriterion1)
End if 