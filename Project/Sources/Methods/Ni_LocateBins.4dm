//%attributes = {"publishedWeb":true}
//(p) JCO_LocateBins (JobCloseOut)
//locate RM Bins and populate process arrays
//$1 - string - (optional) anything - flag clear arrays/sets
//• 10/30/97 cs created

C_LONGINT:C283($Count)
C_TEXT:C284($1)

If (Count parameters:C259=0)
	If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
		
		uRelateSelect(->[Raw_Materials_Locations:25]POItemKey:19; ->[Job_Forms_Issue_Tickets:90]PoItemKey:1; 0)  //get alll bins based on current selection if issue ticekets
		
		
	Else 
		
		ARRAY TEXT:C222($_PoItemKey; 0)
		
		DISTINCT VALUES:C339([Job_Forms_Issue_Tickets:90]PoItemKey:1; $_PoItemKey)
		QUERY WITH ARRAY:C644([Raw_Materials_Locations:25]POItemKey:19; $_PoItemKey)
		
		
	End if   // END 4D Professional Services : January 2019 query selection
	$Count:=Records in selection:C76([Raw_Materials_Locations:25])
	ARRAY TEXT:C222(aRMBin; $Count)
	ARRAY TEXT:C222(aRMPoiKey; $Count)
	ARRAY TEXT:C222(aRMCompID; $Count)
	ARRAY REAL:C219(aRMQty; $Count)
	ARRAY REAL:C219(aRMAvail; $Count)
	ARRAY REAL:C219(aRMCommit; $Count)
	SELECTION TO ARRAY:C260([Raw_Materials_Locations:25]Location:2; aRmBin; [Raw_Materials_Locations:25]POItemKey:19; aRmPoiKey; [Raw_Materials_Locations:25]QtyOH:9; aRmQty; [Raw_Materials_Locations:25]QtyAvailable:13; aRmAvail; [Raw_Materials_Locations:25]QtyCommitted:11; aRmCommit; [Raw_Materials_Locations:25]CompanyID:27; aRMCompId)
	CREATE SET:C116([Raw_Materials_Locations:25]; "◊BinsToPost")  //hold current order for later array to selection
Else 
	$Count:=0
	ARRAY TEXT:C222(aRMBin; $Count)
	ARRAY TEXT:C222(aRMPoiKey; $Count)
	ARRAY TEXT:C222(aRMCompID; $Count)
	ARRAY REAL:C219(aRMQty; $Count)
	ARRAY REAL:C219(aRMAvail; $Count)
	ARRAY REAL:C219(aRMCommit; $Count)
	CLEAR SET:C117("◊BinsToPost")
End if 