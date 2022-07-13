//%attributes = {}

// Method: wmss_ScanObject ( )  -> 
// ----------------------------------------------------
// Author: Mel Bohince
// Created: 02/23/15, 15:45:01
// ----------------------------------------------------
// Description
// 
//
// ----------------------------------------------------
// Modified by: Mel Bohince (6/5/15) set sToSkid 
// Modified by: Mel Bohince (12/10/15) protect against moving a bin, test for supercase



C_BOOLEAN:C305($0; $continue)
$0:=False:C215
$continue:=True:C214

Case of 
	: (Substring:C12(rft_Response; 1; 2)="BN")  // Modified by: Mel Bohince (12/10/15) 
		$continue:=False:C215
		
	: (Length:C16(rft_Response)=20)  //skid, can only go to a bin
		rft_object:="skid"
		sToSkid:=rft_Response  // Modified by: Mel Bohince (6/5/15) set sToSkid 
		tText:=" WHERE `skid_number` = '"+sToSkid+"'"
		rft_caseId:=""
		
	: (Length:C16(rft_Response)=22)  //case, can go to bin or skid
		rft_object:="case"
		rft_caseId:=rft_Response
		tText:=" WHERE `case_id` = '"+rft_caseId+"'"
End case 

If ($continue)
	//$conn_id:=DB_ConnectionManager ("Open")
	If ($conn_id>0)
		
		$sql:="SELECT `case_id`, `skid_number`, `case_status_code`, `bin_id`, `jobit`  FROM `cases`"+tText
		//$row_set:=MySQL Select ($conn_id;$sql)
		//$row_count:=MySQL Get Row Count ($row_set)
		If ($row_count>0)  //display what is going to move
			ARRAY BOOLEAN:C223(ListBox1; 0)
			ARRAY TEXT:C222(rft_Case; 0)
			ARRAY TEXT:C222(rft_Skid; 0)
			ARRAY TEXT:C222(rft_Bin; 0)
			ARRAY TEXT:C222(rft_jobit; 0)
			ARRAY LONGINT:C221($acase_state; 0)
			ARRAY TEXT:C222(rft_Status; 0)
			
			//MySQL Column To Array ($row_set;"";1;rft_Case)
			//MySQL Column To Array ($row_set;"";2;rft_Skid)
			//MySQL Column To Array ($row_set;"";3;$acase_state)
			//MySQL Column To Array ($row_set;"";4;rft_Bin)
			//MySQL Column To Array ($row_set;"";5;rft_jobit)
			
			ARRAY BOOLEAN:C223(ListBox1; $row_count)
			ARRAY TEXT:C222(rft_Status; $row_count)
			iQty:=0
			For ($i; 1; $row_count)
				Case of 
					: ($acase_state{$i}=1)
						rft_Status{$i}:=" CERTIFICATION "
						
					: ($acase_state{$i}=10)
						rft_Status{$i}:=" EXAMINING "
						
					: ($acase_state{$i}=110)
						rft_Status{$i}:=" BOL PENDING "
						
					: ($acase_state{$i}=130)
						rft_Status{$i}:=" RE-CERT "
						
					: ($acase_state{$i}=200)
						rft_Status{$i}:=" B&H "
						
					: ($acase_state{$i}=250)
						rft_Status{$i}:=" EXCESS "
						
					: ($acase_state{$i}=300)
						rft_Status{$i}:=" SHIPPED "
						
					: ($acase_state{$i}=350)
						rft_Status{$i}:=" RE-CERT "
						
					: ($acase_state{$i}=400)
						rft_Status{$i}:=" SCRAPPED "
						
					: ($acase_state{$i}=500)
						rft_Status{$i}:=" UNKNOWN "
						
					Else 
						rft_Status{$i}:=" FG "
				End case 
				
				iQty:=iQty+Num:C11(WMS_CaseId(rft_Case{$i}; "qty"))
				
			End for 
			
			sJobit:=rft_jobit{1}
			//sJobitDelimited:=JMI_makeJobIt (sJobit)  // Modified by: Mel Bohince (12/10/15) add verify
			If (rft_Case{1}=rft_Skid{1})  //this is a skid so prevent move it on to another skid
				rft_object:="supercase"
			End if 
			
			//$numJMI:=qryJMI (sJobitDelimited)  //verify, maybe a supercase id
			//If ($numJMI=0)  //must be a super case, case=skid
			//QUERY([WMS_SerializedShippingLabels];[WMS_SerializedShippingLabels]HumanReadable=rft_Skid{1})
			//If (Records in selection([WMS_SerializedShippingLabels])=1)
			//sJobitDelimited:=[WMS_SerializedShippingLabels]Jobit
			//sJobit:=Replace string(sJobitDelimited;".";"")
			//Else 
			//sJobitDelimited:=""
			//sJobit:=""
			//end if
			//end if
			
			sFrom:=rft_bin{1}
			sToSkid:=rft_Skid{1}  // Modified by: Mel Bohince (6/5/15) set sToSkid , may be null
			numberOfCases:=Size of array:C274(rft_Case)
			rft_state:="destination"
			rft_log:=rft_object+" from bin "+sFrom
			If (rft_object="case")
				rft_log:=rft_log+" on skid "+sToSkid  // Modified by: Mel Bohince (6/5/15) set sToSkid 
			End if 
			rft_prompt:="Move the "+rft_object+" to:"
			rft_error_log:=""
			SetObjectProperties(""; ->rft_error_log; False:C215)
			$0:=True:C214
			
		Else   //no cases found
			wmss_initMove
			rft_error_log:="No cases found."
			SetObjectProperties(""; ->rft_error_log; True:C214; ""; False:C215)
		End if   //nothing found
		
		//MySQL Delete Row Set ($row_set)
		//$conn_id:=DB_ConnectionManager ("Close")
		
	Else 
		wmss_initMove
		rft_error_log:="Could not connect to WMS."
		SetObjectProperties(""; ->rft_error_log; True:C214; ""; False:C215)
	End if   //conn id
	
Else   // Modified by: Mel Bohince (12/10/15) 
	wmss_initMove
	rft_error_log:="Can't move a BIN."
	SetObjectProperties(""; ->rft_error_log; True:C214; ""; False:C215)
End if 