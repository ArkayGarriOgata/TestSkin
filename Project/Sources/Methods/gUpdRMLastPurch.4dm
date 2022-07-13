//%attributes = {"publishedWeb":true}
//(P) gUpdRMLastPurch: update Raw Material Last Purchase Price
//• 4/9/98 cs nan checking/removal
//•070199  mlb  fix the unit cost

FIRST RECORD:C50([Purchase_Orders_Items:12])

READ WRITE:C146([Raw_Materials:21])

While (Not:C34(End selection:C36([Purchase_Orders_Items:12])))
	QUERY:C277([Raw_Materials:21]; [Raw_Materials:21]Raw_Matl_Code:1=[Purchase_Orders_Items:12]Raw_Matl_Code:15)
	If (fLockNLoad(->[Raw_Materials:21]))
		[Raw_Materials:21]LastPurCost:43:=uNANCheck(POIpriceToCost)  //•070199  mlb  fix the unit cost
		[Raw_Materials:21]LastPurDate:44:=[Purchase_Orders:11]PODate:4
		SAVE RECORD:C53([Raw_Materials:21])
	End if 
	NEXT RECORD:C51([Purchase_Orders_Items:12])
End while 

UNLOAD RECORD:C212([Raw_Materials:21])