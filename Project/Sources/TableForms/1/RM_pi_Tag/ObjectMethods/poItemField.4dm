// _______
// Method: [zz_control].RM_pi_Tag.poItemField   ( ) ->
// By: MelvinBohince 
// ----------------------------------------------------
// SetObjectProperties, Modified by: Mark Zinke (5/14/13)
// Modified by: MelvinBohince (1/11/22) validate inventoried item

sCriterion1:=""  //vend + rm code
//sCriterion3:=""  `location
sCriterion4:=""  //uom
sCriterion5:=""  //tag
rReal1:=0  //         qty
tText:=""

QUERY:C277([Purchase_Orders_Items:12]; [Purchase_Orders_Items:12]POItemKey:1=sCriterion2)
Case of 
	: (Records in selection:C76([Purchase_Orders_Items:12])=1)  //normal condition
		
		If (Form:C1466.validCommodityKeys_c.indexOf([Purchase_Orders_Items:12]Commodity_Key:26)>-1)  // Modified by: MelvinBohince (1/11/22) validate inventoried item
			
			QUERY:C277([Raw_Materials:21]; [Raw_Materials:21]Raw_Matl_Code:1=[Purchase_Orders_Items:12]Raw_Matl_Code:15)
			QUERY:C277([Vendors:7]; [Vendors:7]ID:1=[Purchase_Orders_Items:12]VendorID:39)
			QUERY:C277([Raw_Materials_Locations:25]; [Raw_Materials_Locations:25]POItemKey:19=sCriterion2)
			If (Records in selection:C76([Raw_Materials_Locations:25])>0)
				If (fLockNLoad(->[Raw_Materials_Locations:25]))
					sCriterion1:=[Vendors:7]Name:2+"'s "+[Purchase_Orders_Items:12]Raw_Matl_Code:15
					//sCriterion3:=[RM_BINS]Location
					sCriterion4:=[Purchase_Orders_Items:12]UM_Arkay_Issue:28
					rReal1:=[Raw_Materials_Locations:25]PiFreezeQty:23
					If (rReal1=0)
						rReal1:=[Raw_Materials_Locations:25]QtyOH:9
					End if 
					tText:=[Raw_Materials_Locations:25]CompanyID:27
				Else 
					BEEP:C151
					ALERT:C41("The "+sCriterion2+" bin record is locked."; "Try later")
					sCriterion2:=""
				End if 
			End if 
			
		Else 
			uConfirm("PO "+sCriterion2+" is not for an inventoried item."; "Try again"; "Help")
			sCriterion2:=""
			
		End if   //inventoried item
		
	: (Substring:C12(sCriterion2; 1; 1)="A")  //semifinished stock, 1st time through
		QUERY:C277([Raw_Materials_Locations:25]; [Raw_Materials_Locations:25]POItemKey:19=sCriterion2)
		If (Records in selection:C76([Raw_Materials_Locations:25])>0)
			If (fLockNLoad(->[Raw_Materials_Locations:25]))
				sCriterion1:=[Raw_Materials_Locations:25]Raw_Matl_Code:1
				//sCriterion3:=[RM_BINS]Location
				
				rReal1:=[Raw_Materials_Locations:25]PiFreezeQty:23
				If (rReal1=0)
					rReal1:=[Raw_Materials_Locations:25]QtyOH:9
				End if 
				tText:=[Raw_Materials_Locations:25]CompanyID:27
				
				If (PI_POfromRM([Raw_Materials_Locations:25]Raw_Matl_Code:1; sCriterion2; [Raw_Materials_Locations:25]ActCost:18))
					sCriterion4:=[Raw_Materials:21]IssueUOM:10
				End if 
				
			Else 
				BEEP:C151
				ALERT:C41("The "+sCriterion2+" bin record is locked."; "Try later")
				sCriterion2:=""
			End if 
			
		Else   //no bin
			sCriterion1:=Request:C163("What is the RM code assigned to this SemiFinished?")
			If (ok=1) & (Length:C16(sCriterion1)>0)
				If (PI_POfromRM(sCriterion1; sCriterion2; 0))
					sCriterion4:=[Raw_Materials:21]IssueUOM:10
				Else 
					sCriterion2:=""
				End if 
			Else 
				sCriterion2:=""
			End if 
		End if 
		
	Else   //maybe  a purged po
		BEEP:C151
		sCriterion2:=""
		sCriterion1:=Request:C163("What is the RM code assigned to this unknown PO?")
		If (ok=1) & (Length:C16(sCriterion1)>0)
			If (PI_POfromRM(sCriterion1; sCriterion2; 0))
				sCriterion4:=[Raw_Materials:21]IssueUOM:10
			Else 
				sCriterion2:=""
			End if 
		Else 
			sCriterion2:=""
		End if 
End case 

If (Length:C16(sCriterion2)>=9)
	SetObjectProperties(""; ->sCriterion2; True:C214; ""; True:C214)
	SetObjectProperties(""; ->rReal1; True:C214; ""; True:C214)
	SetObjectProperties(""; ->sCriterion5; True:C214; ""; True:C214)
	SetObjectProperties(""; ->tText; True:C214; ""; True:C214)
	SetObjectProperties(""; ->sCriterion3; True:C214; ""; True:C214)
	SetObjectProperties(""; ->sCriterion4; True:C214; ""; True:C214)
	GOTO OBJECT:C206(sCriterion5)
Else   //reset to onload state
	SetObjectProperties(""; ->sCriterion2; True:C214; ""; False:C215)
	SetObjectProperties(""; ->rReal1; True:C214; ""; False:C215)
	SetObjectProperties(""; ->sCriterion5; True:C214; ""; False:C215)
	SetObjectProperties(""; ->tText; True:C214; ""; False:C215)
	SetObjectProperties(""; ->sCriterion3; True:C214; ""; False:C215)
	SetObjectProperties(""; ->sCriterion4; True:C214; ""; False:C215)
	GOTO OBJECT:C206(sCriterion2)
End if 