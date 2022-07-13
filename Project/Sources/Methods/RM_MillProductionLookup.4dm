//%attributes = {"publishedWeb":true}
//PM: RM_MillProductionLookup(poitem) -> 
//@author mlb - 7/9/02  14:45

C_BOOLEAN:C305($0; $succeed)

$succeed:=True:C214

QUERY:C277([Purchase_Orders_Items:12]; [Purchase_Orders_Items:12]POItemKey:1=sCriterion2)
If (Records in selection:C76([Purchase_Orders_Items:12])=1)
	t3:=[Purchase_Orders_Items:12]UM_Arkay_Issue:28
	
	RELATE ONE:C42([Purchase_Orders_Items:12]PONo:2)
	RELATE ONE:C42([Purchase_Orders:11]VendorID:2)
	sCriterion1:=[Vendors:7]Name:2+"'s "+[Purchase_Orders_Items:12]Raw_Matl_Code:15
	sCriterion3:=[Vendors:7]Prefix:33
	
	qryRMgroup([Purchase_Orders_Items:12]Commodity_Key:26; !00-00-00!)
	If ([Raw_Materials_Groups:22]Commodity_Code:1=1)
		QUERY:C277([Raw_Materials_Locations:25]; [Raw_Materials_Locations:25]Raw_Matl_Code:1=[Purchase_Orders_Items:12]Raw_Matl_Code:15; *)
		QUERY:C277([Raw_Materials_Locations:25];  & ; [Raw_Materials_Locations:25]Location:2=sCriterion3; *)
		QUERY:C277([Raw_Materials_Locations:25];  & ; [Raw_Materials_Locations:25]POItemKey:19=sCriterion2)
		If (Records in selection:C76([Raw_Materials_Locations:25])>0)  //get loaded if exists
			If (fLockNLoad(->[Raw_Materials_Locations:25]))
				//locked and ready for update
				
			Else 
				BEEP:C151
				zwStatusMsg("PO ITEM"; "Location: "+sCriterion3+" is in use, try again later.")
				$succeed:=False:C215
			End if 
		End if 
		
	Else 
		BEEP:C151
		zwStatusMsg("PO ITEM"; "PO item "+sCriterion2+" is not for Board.")
		$succeed:=False:C215
	End if 
	
Else 
	BEEP:C151
	zwStatusMsg("PO ITEM"; "PO item "+sCriterion2+" not found.")
	$succeed:=False:C215
End if 

If (Not:C34($succeed))
	REDUCE SELECTION:C351([Purchase_Orders_Items:12]; 0)
	REDUCE SELECTION:C351([Purchase_Orders:11]; 0)
	REDUCE SELECTION:C351([Vendors:7]; 0)
	REDUCE SELECTION:C351([Raw_Materials_Groups:22]; 0)
	REDUCE SELECTION:C351([Raw_Materials_Locations:25]; 0)
	REDUCE SELECTION:C351([Raw_Materials_Transactions:23]; 0)
End if 

$0:=$succeed