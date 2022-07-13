//%attributes = {"publishedWeb":true}
//PM: JTB_WhatsHere(sLocation) -> 
//@author mlb - 3/25/02  10:04
If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 Next record
	
	ARRAY TEXT:C222(aKey; 0)
	ARRAY TEXT:C222(axRelTemp; 0)
	
	QUERY:C277([JPSI_Job_Physical_Support_Items:111]; [JPSI_Job_Physical_Support_Items:111]Location:5=sLocation)
	For ($i; 1; Records in selection:C76([JPSI_Job_Physical_Support_Items:111]))
		INSERT IN ARRAY:C227(aKey; 1)
		INSERT IN ARRAY:C227(axRelTemp; 1)
		aKey{1}:=[JPSI_Job_Physical_Support_Items:111]ID:1
		axRelTemp{1}:=Substring:C12([JPSI_Job_Physical_Support_Items:111]ItemType:2; 1; 80)
		NEXT RECORD:C51([JPSI_Job_Physical_Support_Items:111])
	End for 
	
	READ ONLY:C145([Customers_Projects:9])
	QUERY:C277([JTB_Job_Transfer_Bags:112]; [JTB_Job_Transfer_Bags:112]Location:4=sLocation)
	For ($i; 1; Records in selection:C76([JTB_Job_Transfer_Bags:112]))
		INSERT IN ARRAY:C227(aKey; 1)
		INSERT IN ARRAY:C227(axRelTemp; 1)
		aKey{1}:=[JTB_Job_Transfer_Bags:112]ID:1
		QUERY:C277([Customers_Projects:9]; [Customers_Projects:9]id:1=[JTB_Job_Transfer_Bags:112]PjtNumber:2)
		axRelTemp{1}:=Substring:C12([JTB_Job_Transfer_Bags:112]Jobform:3+" "+[Customers_Projects:9]Name:2; 1; 80)
		NEXT RECORD:C51([JTB_Job_Transfer_Bags:112])
	End for 
	
	SORT ARRAY:C229(aKey; axRelTemp; >)
	
Else 
	
	ARRAY TEXT:C222(aKey; 0)
	ARRAY TEXT:C222(axRelTemp; 0)
	
	QUERY:C277([JPSI_Job_Physical_Support_Items:111]; [JPSI_Job_Physical_Support_Items:111]Location:5=sLocation)
	
	ARRAY TEXT:C222($_ID; 0)
	ARRAY TEXT:C222($_ItemType; 0)
	
	SELECTION TO ARRAY:C260([JPSI_Job_Physical_Support_Items:111]ID:1; $_ID; [JPSI_Job_Physical_Support_Items:111]ItemType:2; $_ItemType)
	
	For ($i; 1; Size of array:C274($_ID); 1)
		
		INSERT IN ARRAY:C227(aKey; 1)
		INSERT IN ARRAY:C227(axRelTemp; 1)
		aKey{1}:=$_ID{$i}
		axRelTemp{1}:=Substring:C12($_ItemType{$i}; 1; 80)
		
	End for 
	
	ARRAY TEXT:C222($_PjtNumber; 0)
	ARRAY TEXT:C222($_Jobform; 0)
	
	READ ONLY:C145([Customers_Projects:9])
	QUERY:C277([JTB_Job_Transfer_Bags:112]; [JTB_Job_Transfer_Bags:112]Location:4=sLocation)
	
	SELECTION TO ARRAY:C260([JTB_Job_Transfer_Bags:112]PjtNumber:2; $_PjtNumber; [JTB_Job_Transfer_Bags:112]Jobform:3; $_Jobform)
	
	For ($i; 1; Size of array:C274($_PjtNumber); 1)
		
		INSERT IN ARRAY:C227(aKey; 1)
		INSERT IN ARRAY:C227(axRelTemp; 1)
		aKey{1}:=[JTB_Job_Transfer_Bags:112]ID:1
		QUERY:C277([Customers_Projects:9]; [Customers_Projects:9]id:1=$_PjtNumber{$i})
		axRelTemp{1}:=Substring:C12($_Jobform{$i}+" "+[Customers_Projects:9]Name:2; 1; 80)
		
	End for 
	
	SORT ARRAY:C229(aKey; axRelTemp; >)
	
End if   // END 4D Professional Services : January 2019 query selection
