//%attributes = {}
// ----------------------------------------------------
// User name (OS): Mel Bohince
// Date and time: 10/22/10, 12:04:12
// ----------------------------------------------------
// Method: ELC_EMEA_Extract
// Description
// get data for their spreadsheet
// ----------------------------------------------------

C_DATE:C307(dDate; $1)
ARRAY TEXT:C222($aShipTos; 0)
ARRAY TEXT:C222($aNonNorthAmerica; 0)
ARRAY TEXT:C222($aOrderLines; 0)

If (Count parameters:C259=1)
	dDate:=$1
	OK:=1
Else 
	dDate:=Date:C102(Request:C163("Starting on what date?"; "07/01/2010"; "Run..."; "Cancel"))
End if 

If (OK=1)
	
	If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 ELC_query
		
		$numRels:=ELC_query(->[Customers_ReleaseSchedules:46]CustID:12)  //get elc's release
		
		
	Else 
		
		READ ONLY:C145([Customers_ReleaseSchedules:46])
		$critiria:=ELC_getName
		QUERY:C277([Customers_ReleaseSchedules:46]; [Customers:16]ParentCorp:19=$critiria)
		$numRels:=Records in selection:C76([Customers_ReleaseSchedules:46])
		
	End if   // END 4D Professional Services : January 2019 ELC_query
	If ($numRels>0)
		QUERY SELECTION:C341([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]Actual_Date:7>=dDate)  //get the dates of interest candidates
		$numRels:=Records in selection:C76([Customers_ReleaseSchedules:46])
		If ($numRels>0)  //get what shipped non North America
			If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
				
				DISTINCT VALUES:C339([Customers_ReleaseSchedules:46]Shipto:10; $aShipTos)  //where did they ship?
				QUERY WITH ARRAY:C644([Addresses:30]ID:1; $aShipTos)  //get the addresses so country can be determined
				QUERY SELECTION:C341([Addresses:30]; [Addresses:30]Country:9#"USA"; *)  //exclude us and ca
				QUERY SELECTION:C341([Addresses:30];  & ; [Addresses:30]Country:9#"Canada")
				DISTINCT VALUES:C339([Addresses:30]ID:1; $aNonNorthAmerica)  //here are the non northamerica shiptos
				QUERY WITH ARRAY:C644([Customers_ReleaseSchedules:46]Shipto:10; $aNonNorthAmerica)  //get the releases that went to those places
				QUERY SELECTION:C341([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]Actual_Date:7>=dDate)  //get the date range of interest
				DISTINCT VALUES:C339([Customers_ReleaseSchedules:46]OrderLine:4; $aOrderLines)  //find there orders
				QUERY WITH ARRAY:C644([Customers_Order_Lines:41]OrderLine:3; $aOrderLines)
				
			Else 
				
				QUERY SELECTION BY FORMULA:C207([Customers_ReleaseSchedules:46]; \
					([Addresses:30]Country:9#"USA")\
					 & ([Addresses:30]Country:9#"Canada")\
					 & ([Customers_ReleaseSchedules:46]Actual_Date:7>=dDate)\
					)
				RELATE ONE SELECTION:C349([Customers_ReleaseSchedules:46]; [Customers_Order_Lines:41])
				
			End if   // END 4D Professional Services : January 2019 query selection
			
			BEEP:C151
			
			zwStatusMsg("OPEN QR RPT"; "Select a Quick Report template that you saved for the [Customers_Order_Lines] table. ")
			QR REPORT:C197([Customers_Order_Lines:41]; "")  //looking for ELC_EMEA_Extract.4qr report specification
			BEEP:C151
			BEEP:C151
			
		Else 
			ALERT:C41("No ELC Releases shipped on or after "+String:C10(dDate))
		End if 
		
	Else 
		ALERT:C41("No ELC Releases found.")
	End if 
End if 