QUERY:C277([Estimates:17]; [Estimates:17]EstimateNo:1=atEstimateNum{abEstimateLB})  // Added by: Mark Zinke (3/18/13)
If (Records in selection:C76([Estimates:17])=1)  // Added by: Mark Zinke (3/18/13)
	CREATE SET:C116([Estimates:17]; "clickedIncludeRecord")  // Modified by: Mark Zinke (7/9/13) Was Add to Set.
End if 
If (app_LoadIncludedSelection("init"; ->[Estimates:17]EstimateNo:1)>0)
	<>EstNo:=[Estimates:17]EstimateNo:1
	app_LoadIncludedSelection("clear"; ->[Estimates:17]EstimateNo:1)
	
	Pjt_setReferId(pjtId)
	
	//REDUCE SELECTION([Estimates];0)  ` for status changes
	
	ViewSetter(1; ->[Customers_Orders:40])
End if 