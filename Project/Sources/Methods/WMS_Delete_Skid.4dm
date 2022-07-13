//%attributes = {}
// -------
// Method: WMS_Delete_Skid   ( skidnumber) -> num of case records deleted
// By: Mel Bohince @ 05/25/18, 07:38:53
// Description
// remove skid from wms
// ----------------------------------------------------
// Modified by: Mel Bohince (4/28/21) add timestamp

C_LONGINT:C283($numCases; $numSkids; $0)
C_TEXT:C284($skidnumber; $1)
$numCases:=0  //returning this at the end

If (Count parameters:C259=1)
	$skidnumber:=$1
Else 
	$skidnumber:="00208082920002788826"
End if 

If (Length:C16($skidnumber)=20)  //valid length of skid number
	
	READ WRITE:C146([WMS_SerializedShippingLabels:96])
	QUERY:C277([WMS_SerializedShippingLabels:96]; [WMS_SerializedShippingLabels:96]HumanReadable:5=$skidnumber)
	$numSkids:=Records in selection:C76([WMS_SerializedShippingLabels:96])
	
	If ($numSkids=1)
		
		WMS_API_LoginLookup  //make sure <>WMS variables are up to date.
		If (WMS_SQL_Login)
			
			//see if that skid exists in cases records
			$numCases:=0
			Begin SQL
				SELECT count(*) from cases where skid_number = :$skidnumber into :$numCases
			End SQL
			
			If ($numCases<201)  //not too much drama, 140 currently largest cases/skid in pkspecs
				Begin SQL
					delete from cases where skid_number = :$skidnumber
				End SQL
				
				//see if that skid is in skids table
				$numSkids:=0
				Begin SQL
					SELECT count(*) from skids where skidnumber = :$skidnumber into :$numSkids
				End SQL
				
				If ($numSkids=1)  //not real concerned about this one, just housekeeping
					Begin SQL
						delete from skids where skidnumber = :$skidnumber
					End SQL
				End if 
				
				//see if that skid exists in cases records
				$chkCases:=0
				Begin SQL
					SELECT count(*) from cases where skid_number = :$skidnumber into :$chkCases
				End SQL
				
				If ($chkCases=0)
					// Modified by: Mel Bohince (4/28/21) add timestamp
					[WMS_SerializedShippingLabels:96]Comment:17:="SKID DELETED FROM WMS on "+TS_ISO_String_TimeStamp+"\r"+[WMS_SerializedShippingLabels:96]Comment:17
					[WMS_SerializedShippingLabels:96]Quantity:4:=0
					SAVE RECORD:C53([WMS_SerializedShippingLabels:96])
					If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) CREATE EMPTY SET
						
						UNLOAD RECORD:C212([WMS_SerializedShippingLabels:96])
						REDUCE SELECTION:C351([WMS_SerializedShippingLabels:96]; 0)
						
						
					Else 
						
						REDUCE SELECTION:C351([WMS_SerializedShippingLabels:96]; 0)
						
					End if   // END 4D Professional Services : January 2019 
					utl_LogfileServer(<>zResp; $skidnumber+" deleted from wms, "+String:C10($numCases)+" case records found."; "wms_delete.log")
					
				Else 
					utl_LogfileServer(<>zResp; $skidnumber+" not completely deleted from wms, "+String:C10($chkCases)+" case records still exist."; "wms_delete.log")
				End if 
				
				
			Else 
				$numCases:=0
				utl_LogfileServer(<>zResp; $skidnumber+" not deleted from wms, "+String:C10($numCases)+" case records found >200."; "wms_delete.log")
			End if 
			
		Else 
			utl_LogfileServer(<>zResp; $skidnumber+" not deleted from wms, wms login failed."; "wms_delete.log")
		End if   //log in
		
	Else 
		utl_LogfileServer(<>zResp; $skidnumber+" not deleted from wms, unique SSCC not found in SSCC table."; "wms_delete.log")
	End if   //numSkid
	
Else 
	utl_LogfileServer(<>zResp; $skidnumber+" not deleted from wms, is not a valid skid number based on length."; "wms_delete.log")
End if   //len

$0:=$numCases