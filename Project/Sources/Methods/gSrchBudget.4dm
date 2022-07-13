//%attributes = {"publishedWeb":true}
//gSrchBudget: Search Budget File 
//• 11/26/97a cs dded commodity key

sJFNumber:=[Job_Forms:42]JobFormID:5

If (Records in selection:C76([Job_Forms:42])>0)
	//RELATE MANY([Material_Job])
	QUERY:C277([Job_Forms_Materials:55]; [Job_Forms_Materials:55]JobForm:1=sJFNumber)
	
	If (Records in selection:C76([Job_Forms_Materials:55])>0)
		SELECTION TO ARRAY:C260([Job_Forms_Materials:55]; alRecNo; [Job_Forms_Materials:55]Sequence:3; aBudgetItem; [Job_Forms_Materials:55]Actual_Qty:14; aQtyAvl; [Job_Forms_Materials:55]Planned_Qty:6; aPOQty; [Job_Forms_Materials:55]Raw_Matl_Code:7; aPOPartNo; [Job_Forms_Materials:55]Actual_Price:15; aPOPrice; [Job_Forms_Materials:55]Commodity_Key:12; aCommCode)  //added commdoity key
		SORT ARRAY:C229(aBudgetItem; aQtyAvl; aPOQty; aPOPartNo; aPOPrice; alRecNo; aCommCode; >)  //• 11/26/97 cs 
		uChkQtyAvlIss
		OBJECT SET ENABLED:C1123(bSelect; False:C215)
	Else 
		ALERT:C41("Budget Items do not exist for this Job Form.")
		GOTO OBJECT:C206(sPONum)
	End if 
Else 
	
	If (<>fRestrictJO)
		BEEP:C151
		ALERT:C41("Job Form Number is Invalid.")
		GOTO OBJECT:C206(sPONum)
	Else 
		BEEP:C151
		ALERT:C41("Job Form Number not on file!"+<>sCR+<>sCR+"Please verify and manually enter sequence info.")
		sPONumber:=sPONum
		rPOPrice:=0
		rActPrice:=0
		SetObjectProperties(""; ->lSeqNumber; True:C214; ""; True:C214)  // Modified by: Mark Zinke (5/6/13)
		SetObjectProperties(""; ->sRMCode; True:C214; ""; True:C214)  // Modified by: Mark Zinke (5/6/13)
		SetObjectProperties(""; ->rQty; True:C214; ""; True:C214)  // Modified by: Mark Zinke (5/6/13)
		uClrBudgetArray
		GOTO OBJECT:C206(lSeqNumber)
	End if 
End if 