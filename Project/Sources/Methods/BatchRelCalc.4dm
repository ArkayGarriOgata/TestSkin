//%attributes = {"publishedWeb":true}
//Procedure: BatchRelCalc()  121197  MLB UPR 1906
//roll up the open releases into ◊aRel_Open array
//•111798  mlb  search selection!

ARRAY TEXT:C222(<>aRelKey; 0)
ARRAY LONGINT:C221(<>aRel_Open; 0)
ARRAY LONGINT:C221($aRelQty; 0)
ARRAY TEXT:C222($aCPN; 0)
ARRAY TEXT:C222($aRelCust; 0)
C_LONGINT:C283($i; $relCursor)

READ ONLY:C145([Customers_ReleaseSchedules:46])
If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
	
	Case of 
		: (Count parameters:C259=3)
			READ ONLY:C145([Customers:16])
			QUERY:C277([Customers:16]; [Customers:16]Name:2=$2)
			uRelateSelect(->[Customers_ReleaseSchedules:46]CustID:12; ->[Customers:16]ID:1; 1)  //*    Production related to customers•••  
			QUERY SELECTION:C341([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]OpenQty:16>0; *)  //get all open release   `•111798  mlb     
			QUERY SELECTION:C341([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]Sched_Date:5<=$3)  //get all open release   `•111798  mlb    
			
		: (Count parameters:C259=2)
			READ ONLY:C145([Customers:16])
			QUERY:C277([Customers:16]; [Customers:16]Name:2=$2)
			uRelateSelect(->[Customers_ReleaseSchedules:46]CustID:12; ->[Customers:16]ID:1; 1)  //*    Production related to customers•••  
			QUERY SELECTION:C341([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]OpenQty:16>0)  //get all open release   `•111798  mlb  
		Else 
			QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]OpenQty:16>0)  //get all open release
	End case 
	
Else 
	
	Case of 
		: (Count parameters:C259=3)
			READ ONLY:C145([Customers:16])
			zwStatusMsg("Relating"; " Searching "+Table name:C256(->[Customers_ReleaseSchedules:46])+" file. Please Wait...")
			
			QUERY:C277([Customers_ReleaseSchedules:46]; [Customers:16]Name:2=$2; *)
			QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]OpenQty:16>0; *)  //get all open release   `•111798  mlb     
			QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]Sched_Date:5<=$3)  //get all open release   `•111798  mlb    
			
			zwStatusMsg(""; "")
		: (Count parameters:C259=2)
			READ ONLY:C145([Customers:16])
			zwStatusMsg("Relating"; " Searching "+Table name:C256(->[Customers_ReleaseSchedules:46])+" file. Please Wait...")
			
			QUERY:C277([Customers_ReleaseSchedules:46]; [Customers:16]Name:2=$2; *)
			QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]OpenQty:16>0)  //get all open release   `•111798  mlb  
			
			zwStatusMsg(""; "")
		Else 
			QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]OpenQty:16>0)  //get all open release
	End case 
	
End if   // END 4D Professional Services : January 2019 query selection

If (Records in selection:C76([Customers_ReleaseSchedules:46])>0)
	ORDER BY:C49([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]CustID:12; >; [Customers_ReleaseSchedules:46]ProductCode:11; >)
	SELECTION TO ARRAY:C260([Customers_ReleaseSchedules:46]CustID:12; $aRelCust; [Customers_ReleaseSchedules:46]ProductCode:11; $aCPN; [Customers_ReleaseSchedules:46]OpenQty:16; $aRelQty)
	REDUCE SELECTION:C351([Customers_ReleaseSchedules:46]; 0)
	zCursorMgr("beachBallOff")
	zCursorMgr("watch")
	ARRAY TEXT:C222(<>aRelKey; Size of array:C274($aRelCust))
	ARRAY LONGINT:C221(<>aRel_Open; Size of array:C274($aRelCust))
	$relCursor:=0  //track the use of above arrays
	//*Tally the orderline opens 
	For ($i; 1; Size of array:C274($aRelCust))
		
		//*     Set up a bucket  
		If (<>aRelKey{$relCursor}#($aRelCust{$i}+":"+$aCPN{$i}))
			$relCursor:=$relCursor+1
			<>aRelKey{$relCursor}:=$aRelCust{$i}+":"+$aCPN{$i}
		End if 
		//If ((◊aRelKey{$relCursor}="00121:11PQ-00-0110") | 
		//«(◊aRelKey{$relCursor}="00121:0442-01-8110"))
		//TRACE
		//End if 
		//*Tally the qty
		<>aRel_Open{$relCursor}:=<>aRel_Open{$relCursor}+$aRelQty{$i}
	End for 
	
	ARRAY LONGINT:C221($aRelQty; 0)
	ARRAY TEXT:C222($aRelCust; 0)
	ARRAY TEXT:C222(<>aRelKey; $relCursor)
	ARRAY LONGINT:C221(<>aRel_Open; $relCursor)
	SORT ARRAY:C229(<>aRelKey; <>aRel_Open; >)
End if 