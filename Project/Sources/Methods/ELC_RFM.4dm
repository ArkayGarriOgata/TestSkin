//%attributes = {}
// ----------------------------------------------------
// Method: ELC_RFM   ("waiting|received|required" ) -> current selection of release records
// By: Mel Bohince @ 02/18/16, 10:08:47
// Description
// little play action on the User Date 1 & 2 fields regarding Request For Mode RFM
// ----------------------------------------------------

C_TEXT:C284($1)
C_LONGINT:C283($2; $0)  //make read write
CUT NAMED SELECTION:C334([Customers_ReleaseSchedules:46]; "beforeQry")
If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 ELC_query
	
	If (Count parameters:C259=1)  //readonly mode
		$numELC:=ELC_query(->[Customers_ReleaseSchedules:46]CustID:12)
	Else   //readwrite
		$numELC:=ELC_query(->[Customers_ReleaseSchedules:46]CustID:12; $2)
	End if 
	
Else 
	
	If (Count parameters:C259=1)  //readonly mode
		READ ONLY:C145([Customers_ReleaseSchedules:46])
		
	Else 
		
		READ WRITE:C146([Customers_ReleaseSchedules:46])
		
	End if 
	$critiria:=ELC_getName
	QUERY:C277([Customers_ReleaseSchedules:46]; [Customers:16]ParentCorp:19=$critiria)
	$numELC:=Records in selection:C76([Customers_ReleaseSchedules:46])
	
End if   // END 4D Professional Services : January 2019 ELC_query


If ($numELC>0)
	CLEAR NAMED SELECTION:C333("beforeQry")
	
	Case of 
		: ($1="waiting")
			QUERY SELECTION:C341([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]user_date_1:48#!00-00-00!; *)
			QUERY SELECTION:C341([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]user_date_2:49=!00-00-00!; *)
			QUERY SELECTION:C341([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]Actual_Date:7=!00-00-00!)
			
			
		: ($1="received")
			QUERY SELECTION:C341([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]user_date_1:48#!00-00-00!; *)
			QUERY SELECTION:C341([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]user_date_2:49#!00-00-00!)
			
		: ($1="required")  //waiting plus needing
			If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
				
				QUERY:C277([Addresses:30]; [Addresses:30]RequestForModeEmailTo:17#"")
				SELECTION TO ARRAY:C260([Addresses:30]ID:1; $aAddressID)
				REDUCE SELECTION:C351([Addresses:30]; 0)
				If (Size of array:C274($aAddressID)>0)
					
					QUERY SELECTION:C341([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]Shipto:10=$aAddressID{1}; *)
					For ($address; 2; Size of array:C274($aAddressID))
						QUERY SELECTION:C341([Customers_ReleaseSchedules:46];  | ; [Customers_ReleaseSchedules:46]Shipto:10=$aAddressID{$address}; *)
					End for 
				End if 
				QUERY SELECTION:C341([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]user_date_1:48=!00-00-00!; *)
				QUERY SELECTION:C341([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]CustomerRefer:3#"<@"; *)
				QUERY SELECTION:C341([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]Actual_Date:7=!00-00-00!)
				
			Else 
				
				
				QUERY SELECTION BY FORMULA:C207([Customers_ReleaseSchedules:46]; \
					([Customers_ReleaseSchedules:46]Shipto:10=[Addresses:30]ID:1)\
					 & ([Addresses:30]RequestForModeEmailTo:17#"")\
					 & ([Customers_ReleaseSchedules:46]user_date_1:48=!00-00-00!)\
					 & ([Customers_ReleaseSchedules:46]CustomerRefer:3#"<@")\
					 & ([Customers_ReleaseSchedules:46]Actual_Date:7=!00-00-00!)\
					)
				
			End if   // END 4D Professional Services : January 2019 query selection
			
	End case 
	
	
	
Else   //restore and bail
	USE NAMED SELECTION:C332("beforeQry")
	BEEP:C151
	zwStatusMsg("RFM"; "No ELC Releases found.")
End if 

$0:=Records in selection:C76([Customers_ReleaseSchedules:46])
