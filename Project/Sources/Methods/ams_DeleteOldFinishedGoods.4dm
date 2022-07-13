//%attributes = {"publishedWeb":true}
//PM: ams_DeleteOldFinishedGoods() -> 
//@author mlb - 7/2/02  16:19

C_DATE:C307($cutOff; $1)

$cutOff:=$1

distributionList:="mel.bohince@arkay.com"
Batch_ForecastAnalysis(distributionList)

READ WRITE:C146([Finished_Goods:26])


QUERY:C277([Finished_Goods:26]; [Finished_Goods:26]InventoryNow:73=0; *)
QUERY:C277([Finished_Goods:26];  & ; [Finished_Goods:26]FRCST_NumberOfReleases:69=0; *)
QUERY:C277([Finished_Goods:26];  & [Finished_Goods:26]ModDate:24<$cutOff; *)
QUERY:C277([Finished_Goods:26];  & ; [Finished_Goods:26]ControlNumber:61="")
util_DeleteSelection(->[Finished_Goods:26])

QUERY:C277([Finished_Goods:26]; [Finished_Goods:26]InventoryNow:73=0; *)
QUERY:C277([Finished_Goods:26];  & ; [Finished_Goods:26]FRCST_NumberOfReleases:69=0; *)
QUERY:C277([Finished_Goods:26];  & ; [Finished_Goods:26]Status:14="Obsolete")
util_DeleteSelection(->[Finished_Goods:26])

QUERY:C277([Finished_Goods:26]; [Finished_Goods:26]InventoryNow:73=0; *)
QUERY:C277([Finished_Goods:26];  & ; [Finished_Goods:26]FRCST_NumberOfReleases:69=0; *)
QUERY:C277([Finished_Goods:26];  & ; [Finished_Goods:26]Status:14="Superceded@")
util_DeleteSelection(->[Finished_Goods:26])
If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4 
	
	QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]XactionDate:3>(Current date:C33-90); *)
	QUERY:C277([Finished_Goods_Transactions:33];  & ; [Finished_Goods_Transactions:33]XactionType:2="Ship")
	CREATE SET:C116([Finished_Goods_Transactions:33]; "keepers")
	ams_DeleteWithoutHeaderRecord(->[Finished_Goods_Transactions:33]ProductCode:1; ->[Finished_Goods:26]ProductCode:1; "keepers")
	CLEAR SET:C117("keepers")
	//ams_DeleteWithoutHeaderRecord (->[Finished_Goods_Inv_Summaries]FGkey;->[Finished_Goods]FG_KEY)
	
	//$cutOff:=Add to date($cutOff;1;0;0)
	QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]XactionDate:3<$cutOff)
	CREATE SET:C116([Finished_Goods_Transactions:33]; "oldxfers")
	ALL RECORDS:C47([Finished_Goods_Locations:35])
	DISTINCT VALUES:C339([Finished_Goods_Locations:35]Jobit:33; $aLiveJobits)
	QUERY WITH ARRAY:C644([Finished_Goods_Transactions:33]Jobit:31; $aLiveJobits)
	CREATE SET:C116([Finished_Goods_Transactions:33]; "xferswithinventory")
	DIFFERENCE:C122("oldxfers"; "xferswithinventory"; "oldxfers")
	USE SET:C118("oldxfers")
	util_DeleteSelection(->[Finished_Goods_Transactions:33])
	CLEAR SET:C117("oldxfers")
	CLEAR SET:C117("xferswithinventory")
	
Else 
	//change 33 et the big probleme on 34 
	SET QUERY DESTINATION:C396(Into set:K19:2; "keepers")
	QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]XactionDate:3>(Current date:C33-90); *)
	QUERY:C277([Finished_Goods_Transactions:33];  & ; [Finished_Goods_Transactions:33]XactionType:2="Ship")
	SET QUERY DESTINATION:C396(Into current selection:K19:1)
	
	If (<>fContinue)
		
		ARRAY TEXT:C222($_ProductCode; 0)
		READ ONLY:C145([Finished_Goods:26])
		ALL RECORDS:C47([Finished_Goods:26])
		READ WRITE:C146([Finished_Goods_Transactions:33])
		If (Not:C34(<>modification4D_10_05_19))  // BEGIN 4D Professional Services : Query With array
			
			DISTINCT VALUES:C339([Finished_Goods:26]ProductCode:1; $_ProductCode)
			
			SET QUERY DESTINATION:C396(Into set:K19:2; "keepThese")
			QUERY WITH ARRAY:C644([Finished_Goods_Transactions:33]ProductCode:1; $_ProductCode)
			SET QUERY DESTINATION:C396(Into current selection:K19:1)
			
		Else 
			
			RELATE MANY SELECTION:C340([Finished_Goods_Transactions:33]ProductCode:1)
			CREATE SET:C116([Finished_Goods_Transactions:33]; "keepThese")
			
		End if   // END 4D Professional Services : January 2019 
		
		ALL RECORDS:C47([Finished_Goods_Transactions:33])
		CREATE SET:C116([Finished_Goods_Transactions:33]; "allRecords")
		DIFFERENCE:C122("allRecords"; "keepThese"; "keepThese")
		DIFFERENCE:C122("keepThese"; "keepers"; "keepThese")
		USE SET:C118("keepThese")
		CLEAR SET:C117("allRecords")
		CLEAR SET:C117("keepThese")
		util_DeleteSelection(->[Finished_Goods_Transactions:33])
		
	End if 
	
	CLEAR SET:C117("keepers")
	
	SET QUERY DESTINATION:C396(Into set:K19:2; "oldxfers")
	QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]XactionDate:3<$cutOff)
	SET QUERY DESTINATION:C396(Into current selection:K19:1)
	
	ALL RECORDS:C47([Finished_Goods_Locations:35])
	DISTINCT VALUES:C339([Finished_Goods_Locations:35]Jobit:33; $aLiveJobits)
	
	SET QUERY DESTINATION:C396(Into set:K19:2; "xferswithinventory")
	QUERY WITH ARRAY:C644([Finished_Goods_Transactions:33]Jobit:31; $aLiveJobits)
	SET QUERY DESTINATION:C396(Into current selection:K19:1)
	
	DIFFERENCE:C122("oldxfers"; "xferswithinventory"; "oldxfers")
	USE SET:C118("oldxfers")
	util_DeleteSelection(->[Finished_Goods_Transactions:33])
	CLEAR SET:C117("oldxfers")
	CLEAR SET:C117("xferswithinventory")
	
	
End if   // END 4D Professional Services : January 2019 


$cutOff:=Add to date:C393($cutOff; 1; 0; 0)
QUERY:C277([Finished_Goods_Inv_Summaries:64]; [Finished_Goods_Inv_Summaries:64]DateFrozen:8<$cutOff)
util_DeleteSelection(->[Finished_Goods_Inv_Summaries:64])