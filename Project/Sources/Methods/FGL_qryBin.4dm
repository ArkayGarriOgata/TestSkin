//%attributes = {}
// ----------------------------------------------------
// User name (OS): mel
// Date and time: 08/31/07, 14:27:36
// ----------------------------------------------------
// Method: FGL_qryBin(jobit;location)->number of records found
// Description
// find a bin for a jobit in a given  location
//
// Parameters
// ----------------------------------------------------
// mlb 05/21/12 add option for pallet id
// mlb 06/04/12 don't track case ids
// mlb 06/08/12 realize that the TO bin condition has outcome of 0 is ok, but the 
// FROM bin condition had to come from a specific bin record. <>Last_skid_referenced is
// used to cache the last skidid processed to help in this affair since the wms transaction 
// does not carry this info
// Modified by: Mel Bohince (11/27/18) from_skid_id added to the ams_exports record, obsoletes 6/8/12 update
// note: while the 4th parameter is not used anymore, it does overload the function to handle the special condition


C_TEXT:C284($1; $2; $3; $4)
C_LONGINT:C283($0)

//reguardless, separation by jobit & location is required
If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
	QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]Jobit:33=$1; *)
	QUERY:C277([Finished_Goods_Locations:35];  & ; [Finished_Goods_Locations:35]Location:2=$2)
	
	
	Case of 
		: (Records in selection:C76([Finished_Goods_Locations:35])=0)  //pointless to search further
			//break
			
		: (Count parameters:C259=3)  // the TO condition -- allow for 0 rec's found, one will be created if needed
			//$3 may be a 20 char pallet id or the generic "CASE" either way if not found, deal with it later
			QUERY SELECTION:C341([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]skid_number:43=$3)
			
			// note: while the 4th parameter is not used anymore, it does overload the function to handle the special condition during FG move
		: (Count parameters:C259=4)  // the FROM condition -- at least one needs to be found, had to come from somewhere
			//first pass, go for the easy stuff
			
			If (Records in selection:C76([Finished_Goods_Locations:35])>1)  //try to narrow it down
				CREATE SET:C116([Finished_Goods_Locations:35]; "candidates")  // case second pass needs to try again
				// Modified by: Mel Bohince (11/27/18) from_skid_id added to the ams_exports record
				//is this a case or a skid being moved?
				Case of 
					: (Length:C16(sCriter10)=20)  //skid number
						QUERY SELECTION:C341([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]skid_number:43=sCriter10)
						
						If (Records in selection:C76([Finished_Goods_Locations:35])#1)
							utl_Logfile("wms_api.log"; "UNIQUE 'from' n/f via skid for "+$1+" "+$2+" "+$3+" "+$4)
						End if 
						
					: (Length:C16(wms_case_id)=22)  //for cases, reach back into wms for the skid it was on
						If (Length:C16(wms_from_skid_id)=20)
							QUERY SELECTION:C341([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]skid_number:43=wms_from_skid_id)
						End if 
						
						If (Records in selection:C76([Finished_Goods_Locations:35])#1)
							utl_Logfile("wms_api.log"; "UNIQUE 'from' n/f via case for "+$1+" "+$2+" "+$3+" "+$4)
						End if 
						
					Else   //oh well, this is going to get arbitrary.
						USE SET:C118("candidates")
						utl_Logfile("wms_api.log"; "MULTI FROM s found for "+$1+" "+$2+" "+$3+" "+$4)
				End case 
				
				CLEAR SET:C117("candidates")
			End if 
			
	End case 
	
Else 
	If (Count parameters:C259=3)  // the TO condition -- allow for 0 rec's found, one will be created if needed
		//$3 may be a 20 char pallet id or the generic "CASE" either way if not found, deal with it later
		QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]skid_number:43=$3; *)
	End if 
	QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]Jobit:33=$1; *)
	QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]Location:2=$2)
	
	
	Case of 
		: (Records in selection:C76([Finished_Goods_Locations:35])=0)  //pointless to search further
			//break
			
			// note: while the 4th parameter is not used anymore, it does overload the function to handle the special condition during FG move
		: (Count parameters:C259=4)  // the FROM condition -- at least one needs to be found, had to come from somewhere
			//first pass, go for the easy stuff
			
			If (Records in selection:C76([Finished_Goods_Locations:35])>1)  //try to narrow it down
				CREATE SET:C116([Finished_Goods_Locations:35]; "candidates")  // case second pass needs to try again
				// Modified by: Mel Bohince (11/27/18) from_skid_id added to the ams_exports record
				//is this a case or a skid being moved?
				Case of 
					: (Length:C16(sCriter10)=20)  //skid number
						QUERY SELECTION:C341([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]skid_number:43=sCriter10)
						
						If (Records in selection:C76([Finished_Goods_Locations:35])#1)
							utl_Logfile("wms_api.log"; "UNIQUE 'from' n/f via skid for "+$1+" "+$2+" "+$3+" "+$4)
						End if 
						
					: (Length:C16(wms_case_id)=22)  //for cases, reach back into wms for the skid it was on
						If (Length:C16(wms_from_skid_id)=20)
							QUERY SELECTION:C341([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]skid_number:43=wms_from_skid_id)
						End if 
						
						If (Records in selection:C76([Finished_Goods_Locations:35])#1)
							utl_Logfile("wms_api.log"; "UNIQUE 'from' n/f via case for "+$1+" "+$2+" "+$3+" "+$4)
						End if 
						
					Else   //oh well, this is going to get arbitrary.
						USE SET:C118("candidates")
						utl_Logfile("wms_api.log"; "MULTI FROM s found for "+$1+" "+$2+" "+$3+" "+$4)
				End case 
				
				CLEAR SET:C117("candidates")
			End if 
			
	End case 
	
End if   // END 4D Professional Services : January 2019 query selection

$0:=Records in selection:C76([Finished_Goods_Locations:35])