
// ----------------------------------------------------
// User name (OS): Mel Bohince
// Date and time: 10/24/18, 17:22:42
// ----------------------------------------------------
// Method: [WMS_SerializedShippingLabels].List.RevlonArden
// Description
// find likely sscc that may need reprinted for Revlon problem of no case-id
//
// Parameters
// ----------------------------------------------------


uConfirm("Find Candidate Revlon/Arden SSCC's?"; "Find"; "Cancel")
If (ok=1)
	ARRAY TEXT:C222($aSkidNumbers; 0)
	
	local_db:=False:C215  // will log out each time
	WMS_API_LoginLookup  //make sure <>WMS variables are up to date.
	If (WMS_SQL_Login)  //WMS_API_4D_DoLogin 
		Begin SQL
			SELECT c.skid_number
			FROM cases c, jobits j 
			WHERE c.case_id = c.skid_number and c.jobit = j.jobit and (j.fg_key like '00074:%' OR j.fg_key like '02085:%')
			INTO :$aSkidNumbers
		End SQL
	End if 
	//c.bin_id, c.qty_in_case, c.jobit, j.fg_key
	//and (c.bin_id like '%LOST%' OR c.bin_id like '%-%'  or  c.bin_id like '%SHIP%' )  
	//
	SQL LOGOUT:C872
	
	
	READ WRITE:C146([WMS_SerializedShippingLabels:96])
	QUERY WITH ARRAY:C644([WMS_SerializedShippingLabels:96]HumanReadable:5; $aSkidNumbers)
	
	SET WINDOW TITLE:C213(String:C10(Records in selection:C76([WMS_SerializedShippingLabels:96]))+" Modifying Revlon/Arden records")
Else 
	tText:="Could not log into WMS, \rclose window and try again."
End if 
