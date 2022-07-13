//%attributes = {"publishedWeb":true}
//Procedure: sPayUPO()  101295  MLB
//•092895  MLB  UPR 1729
C_LONGINT:C283($numOL; $recNo)
iQty:=0
iTotal:=0
sBreakText:=""
sCPN:=""
sCriterion1:=""
iRelNumber:=0

QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]PONumber:21=sPONum2)
$numOL:=Records in selection:C76([Customers_Order_Lines:41])
Case of 
	: ($numOL=1)
		//cool        
	: ($numOL>1)
		$recNo:=fPickList(->[Customers_Order_Lines:41]ProductCode:5; ->[Customers_Order_Lines:41]PONumber:21; ->[Customers_Order_Lines:41]OrderLine:3; sPONum2)
		If ($recNo>-1)
			GOTO RECORD:C242([Customers_Order_Lines:41]; $recNo)
		Else 
			BEEP:C151
			sPONum2:=""
		End if 
		
	Else 
		BEEP:C151
		ALERT:C41(" PO number "+sPONum2+" was not found.")
		sPONum2:=""
End case 

If (sPONum2#"")
	If (fLockNLoad(->[Customers_Order_Lines:41]))
		sPONum2:=[Customers_Order_Lines:41]PONumber:21
		sCPN:=[Customers_Order_Lines:41]ProductCode:5
		sCriterion1:=[Customers_Order_Lines:41]OrderLine:3+"@"+String:C10([Customers_Order_Lines:41]Price_Per_M:8; "###,##0.00")+"/M; "
		sCriterion1:=sCriterion1+String:C10([Customers_Order_Lines:41]PayUxfers:41; "###,###,##0")+" Pay-Xfers; "+String:C10([Customers_Order_Lines:41]Qty_Open:11; "###,###,##0")+" Open"
		QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]OrderLine:4=[Customers_Order_Lines:41]OrderLine:3; *)
		QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]Actual_Date:7#!00-00-00!)
		
		If (Records in selection:C76([Customers_ReleaseSchedules:46])>0)
			If (Records in selection:C76([Customers_ReleaseSchedules:46])>1)
				BEEP:C151
				ALERT:C41("More than one release found, suggesting the latest shipped.")
			End if 
			ORDER BY:C49([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]Actual_Date:7; <)
			If (fLockNLoad(->[Customers_ReleaseSchedules:46]))
				sBreakText:=[Customers_ReleaseSchedules:46]CustomerRefer:3
				iRelNumber:=[Customers_ReleaseSchedules:46]ReleaseNumber:1
			Else 
				BEEP:C151
				ALERT:C41("WARNING: Release record will not be updated unless entered below.")
			End if 
		End if 
		ARRAY TEXT:C222(asBin; 0)
		ARRAY TEXT:C222(aJobit; 0)
		ARRAY LONGINT:C221(aQty; 0)
		ARRAY LONGINT:C221(aRel; 0)
		ARRAY LONGINT:C221(aBinRecNum; 0)
		QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]ProductCode:1=[Customers_Order_Lines:41]ProductCode:5)
		SELECTION TO ARRAY:C260([Finished_Goods_Locations:35]; aBinRecNum; [Finished_Goods_Locations:35]Location:2; asBin; [Finished_Goods_Locations:35]QtyOH:9; aQty; [Finished_Goods_Locations:35]QtyOH:9; aQty2; [Finished_Goods_Locations:35]Jobit:33; aJobit)
		ARRAY LONGINT:C221(aRel; Size of array:C274(asBin))
		SORT ARRAY:C229(asBin; aQty; aRel; aBinRecNum; aJobit; >)
		asBin:=1
		aQty:=1
		aRel:=1
		aBinRecNum:=1
		aJobit:=1
		GOTO OBJECT:C206(iQty)
		
	Else   //locked
		BEEP:C151
		ALERT:C41("Cannot proceed will the orderline "+[Customers_Order_Lines:41]OrderLine:3+" is locked.")
		ARRAY TEXT:C222(asBin; 0)
		ARRAY TEXT:C222(aJobit; 0)
		ARRAY LONGINT:C221(aQty; 0)
		ARRAY LONGINT:C221(aRel; 0)
		ARRAY LONGINT:C221(aBinRecNum; 0)
		sPONum2:=""
		GOTO OBJECT:C206(sPOnum2)
	End if   //locked
	
Else   //no po
	ARRAY TEXT:C222(asBin; 0)
	ARRAY TEXT:C222(aJobit; 0)
	ARRAY LONGINT:C221(aQty; 0)
	ARRAY LONGINT:C221(aRel; 0)
	ARRAY LONGINT:C221(aBinRecNum; 0)
	GOTO OBJECT:C206(sPOnum2)
End if 

//