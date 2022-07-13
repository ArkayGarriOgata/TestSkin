//%attributes = {"publishedWeb":true}
//upr 1454 3/24/95
//(P) beforePOC: before phase processing for [PO_CHG_ORDERS]

RELATE MANY:C262([Purchase_Orders_Chg_Orders:13]POCO_Items:9)

ffPOCMaint:=True:C214

If ([Purchase_Orders_Chg_Orders:13]POCOKey:1="")
	sPOCAction:="NEW"
	[Purchase_Orders_Chg_Orders:13]PONo:3:=[Purchase_Orders:11]PONo:1
	uNewRecReject("You are not permitted to create a Change Order in this manner!")
	
Else 
	If (iMode=3)
		sPOCAction:="REVIEW"
	Else 
		sPOCAction:="MODIFY"
	End if 
	
	SetObjectProperties(""; ->[Purchase_Orders_Chg_Orders:13]ChgOrdDesc:7; True:C214; ""; True:C214)  // Modified by: Mark Zinke (5/6/13)
	OBJECT SET ENABLED:C1123(hdPOC; True:C214)
	
	If (Not:C34(User in group:C338(Current user:C182; "Purchasing")))
		uSetEntStatus(->[Purchase_Orders_Chg_Orders:13]; False:C215)
		OBJECT SET ENABLED:C1123(hdPOC; False:C215)
		ARRAY TEXT:C222(aToFind; 0)
		
	Else 
		ARRAY TEXT:C222(aToFind; 0)
		LIST TO ARRAY:C288("POchgOrdReasons"; aToFind)
		aToFind:=1
	End if 
	
End if 