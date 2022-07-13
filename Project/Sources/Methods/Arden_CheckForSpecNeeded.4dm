//%attributes = {}
// ----------------------------------------------------
// User name (OS): Mel Bohince
// Date and time: 09/08/10, 14:06:43
// ----------------------------------------------------
// Method: Arden_CheckForSpecNeeded
// Description
// can't ship to arden without sending sample and getting approval
// on the first 3 shipments when shipping to these billtos: 01190 & 02742

//The release Expedite field is prefixed with $, !, or %
//   $ = appvd std or more than 3 shipments, OK to ship
//   ! = stds need to be sent
//   % = std sent, waiting for approval
// ----------------------------------------------------

//find the items that are released to these to billto's and then count the shipments made
zwStatusMsg("Arden_CheckForSpec"; "Start")
READ ONLY:C145([Customers_ReleaseSchedules:46])
If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) CREATE EMPTY SET
	
	CREATE EMPTY SET:C140([Customers_ReleaseSchedules:46]; "PendingShipments")  //open releases that were candidates
	
	
Else 
	
	ARRAY LONGINT:C221($_PendingShipments; 0)
	
	
End if   // END 4D Professional Services : January 2019 
QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]Billto:22="01190"; *)
QUERY:C277([Customers_ReleaseSchedules:46];  | ; [Customers_ReleaseSchedules:46]Billto:22="02742"; *)
QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]Expedite:35#"%@"; *)  //sent, now waiting
QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]Expedite:35#"$@")  //already approved or has 3 shipments
ORDER BY:C49([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]ProductCode:11; >)

//update the FG record with the number of shipments
C_LONGINT:C283($i; $numRecs; $number_of_shipments)
$numRecs:=Records in selection:C76([Customers_ReleaseSchedules:46])
$i:=0
$number_of_shipments:=0
READ WRITE:C146([Finished_Goods:26])
uThermoInit($numRecs; "Counting EA Shipments...")
While (Not:C34(End selection:C36([Customers_ReleaseSchedules:46])))
	If ([Finished_Goods:26]ProductCode:1#[Customers_ReleaseSchedules:46]ProductCode:11)
		If ($number_of_shipments>0)  //save last fg if necessary
			If ($number_of_shipments>[Finished_Goods:26]NumberOfShipments:110)  //case a purge has taken some out
				[Finished_Goods:26]NumberOfShipments:110:=$number_of_shipments
				SAVE RECORD:C53([Finished_Goods:26])
			End if 
		End if 
		
		//work with next FG
		QUERY:C277([Finished_Goods:26]; [Finished_Goods:26]ProductCode:1=[Customers_ReleaseSchedules:46]ProductCode:11)
		$number_of_shipments:=0
	End if 
	
	If ([Customers_ReleaseSchedules:46]Actual_Date:7#!00-00-00!)
		$number_of_shipments:=$number_of_shipments+1  //tally shipments
	Else 
		If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) CREATE EMPTY SET
			
			ADD TO SET:C119([Customers_ReleaseSchedules:46]; "PendingShipments")  //will need to check this later
			
		Else 
			
			APPEND TO ARRAY:C911($_PendingShipments; Record number:C243([Customers_ReleaseSchedules:46]))
			
		End if   // END 4D Professional Services : January 2019 
		
	End if 
	
	NEXT RECORD:C51([Customers_ReleaseSchedules:46])
	uThermoUpdate($i)
	$i:=$i+1
End while 
If ($number_of_shipments>0)  //save last fg if necessary
	If ($number_of_shipments>[Finished_Goods:26]NumberOfShipments:110)  //case a purge has taken some out
		[Finished_Goods:26]NumberOfShipments:110:=$number_of_shipments
		SAVE RECORD:C53([Finished_Goods:26])
	End if 
End if 
uThermoClose

$numRecs:=Records in selection:C76([Customers_ReleaseSchedules:46])
$i:=0

//now tag the status of apprv to the release records
READ WRITE:C146([Customers_ReleaseSchedules:46])
If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) CREATE EMPTY SET
	
	USE SET:C118("PendingShipments")
	CLEAR SET:C117("PendingShipments")
	
	
Else 
	
	CREATE SELECTION FROM ARRAY:C640([Customers_ReleaseSchedules:46]; $_PendingShipments)
	
	
End if   // END 4D Professional Services : January 2019 
ORDER BY:C49([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]ProductCode:11; >)
READ ONLY:C145([Finished_Goods:26])
uThermoInit($numRecs; "Tagging Releases...")
While (Not:C34(End selection:C36([Customers_ReleaseSchedules:46])))
	If (Position:C15("$"; [Customers_ReleaseSchedules:46]Expedite:35)=0)  //shouldn't have any $ based on search
		If ([Finished_Goods:26]ProductCode:1#[Customers_ReleaseSchedules:46]ProductCode:11)
			QUERY:C277([Finished_Goods:26]; [Finished_Goods:26]ProductCode:1=[Customers_ReleaseSchedules:46]ProductCode:11)
		End if 
		[Customers_ReleaseSchedules:46]Expedite:35:=Replace string:C233([Customers_ReleaseSchedules:46]Expedite:35; "!"; "")
		
		If ([Finished_Goods:26]NumberOfShipments:110>=3)  //standard doesn't need to be sent
			[Customers_ReleaseSchedules:46]Expedite:35:="$"+[Customers_ReleaseSchedules:46]Expedite:35
			SAVE RECORD:C53([Customers_ReleaseSchedules:46])
		Else 
			If (Position:C15("%"; [Customers_ReleaseSchedules:46]Expedite:35)=0)  //else sent and waiting
				[Customers_ReleaseSchedules:46]Expedite:35:="!"+[Customers_ReleaseSchedules:46]Expedite:35
				SAVE RECORD:C53([Customers_ReleaseSchedules:46])
			End if 
		End if 
		
	End if   //already approved
	
	NEXT RECORD:C51([Customers_ReleaseSchedules:46])
	uThermoUpdate($i)
	$i:=$i+1
End while 
uThermoClose
If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
	
	QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]Expedite:35="!@"; *)
	QUERY:C277([Customers_ReleaseSchedules:46];  | ; [Customers_ReleaseSchedules:46]Expedite:35="$@"; *)
	QUERY:C277([Customers_ReleaseSchedules:46];  | ; [Customers_ReleaseSchedules:46]Expedite:35="%@")
	QUERY SELECTION:C341([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]Billto:22#"01190"; *)
	QUERY SELECTION:C341([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]Billto:22#"02742")
	
	
Else 
	
	QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]Expedite:35="!@"; *)
	QUERY:C277([Customers_ReleaseSchedules:46];  | ; [Customers_ReleaseSchedules:46]Expedite:35="$@"; *)
	QUERY:C277([Customers_ReleaseSchedules:46];  | ; [Customers_ReleaseSchedules:46]Expedite:35="%@"; *)
	QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]Billto:22#"01190"; *)
	QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]Billto:22#"02742")
	
	
End if   // END 4D Professional Services : January 2019 query selection
APPLY TO SELECTION:C70([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]Expedite:35:=Substring:C12([Customers_ReleaseSchedules:46]Expedite:35; 2))

REDUCE SELECTION:C351([Customers_ReleaseSchedules:46]; 0)
REDUCE SELECTION:C351([Finished_Goods:26]; 0)
zwStatusMsg("Arden_CheckForSpec"; "Fini")