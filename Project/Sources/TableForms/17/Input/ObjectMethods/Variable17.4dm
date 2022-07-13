//DUPLICATE CARTON record
//•120695  MLB  UPR 234 chg method of primary keying CartonSpec records
// Modified by Mel Bohince on 1/4/07 at 16:51:24 : 10 character cartonspec
// Modified by: Garri Ogata (9/21/21) added EsCS_SetItemT ()

If (app_LoadIncludedSelection("init"; ->[Estimates_Carton_Specs:19]CartonSpecKey:7; "CSPEC")=1)
	C_TEXT:C284($Case)
	C_LONGINT:C283($nextItemNumber; $numCurrent)
	C_TEXT:C284($ID)  //•120695  MLB  UPR 234 chg method of primary keying CartonSpec records
	$ID:=[Estimates_Carton_Specs:19]CartonSpecKey:7
	$Case:=[Estimates_Carton_Specs:19]diffNum:11
	
	SET QUERY DESTINATION:C396(Into variable:K19:4; $numCurrent)
	QUERY:C277([Estimates_Carton_Specs:19]; [Estimates_Carton_Specs:19]Estimate_No:2=[Estimates:17]EstimateNo:1; *)  //find Estimate Qty worksheet
	QUERY:C277([Estimates_Carton_Specs:19];  & ; [Estimates_Carton_Specs:19]diffNum:11=$Case)
	SET QUERY DESTINATION:C396(Into current selection:K19:1)
	$nextItemNumber:=$numCurrent+1  //
	
	QUERY:C277([Estimates_Carton_Specs:19]; [Estimates_Carton_Specs:19]CartonSpecKey:7=$ID)  //find Estimate Qty worksheet
	DUPLICATE RECORD:C225([Estimates_Carton_Specs:19])
	[Estimates_Carton_Specs:19]pk_id:78:=Generate UUID:C1066
	[Estimates_Carton_Specs:19]CartonSpecKey:7:=fCSpecID  //•120695  MLB  UPR 234 chg method of primary keying CartonSpec records
	[Estimates_Carton_Specs:19]Item:1:=EsCS_SetItemT($nextItemNumber)
	//[Estimates_Carton_Specs]Item:=String($nextItemNumber;"00")
	// deleted 5/15/20: gns_ams_clear_sync_fields(->[Estimates_Carton_Specs]z_SYNC_ID;->[Estimates_Carton_Specs]z_SYNC_DATA)
	SAVE RECORD:C53([Estimates_Carton_Specs:19])
	
	gEstimateLDWkSh("Last")
	
	//set to calculate needed
	Estimate_ReCalcNeeded
	
Else 
	app_LoadIncludedSelection("clear"; ->[Estimates_Carton_Specs:19]CartonSpecKey:7; "CSPEC")
End if 
