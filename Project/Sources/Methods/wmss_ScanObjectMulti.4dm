//%attributes = {}
//©2016 Footprints Inc. All Rights Reserved.
//Method: wmss_ScanObjectMulti - Created v0.1.0-JJG (05/06/16)
If (<>fDebug)
	DODEBUG(Current method name:C684)
End if 

C_BOOLEAN:C305($0; $fSuccess)
$fSuccess:=False:C215
rft_error_log:=""

If (<>fWMS_Use4D)
	$fSuccess:=wmss_ScanObjectMulti_4D
	
Else 
	$fSuccess:=wmss_ScanObjectMulti_MySQL
	
End if 

If (Length:C16(rft_error_log)=0)
	//object added to manifest
Else 
	SetObjectProperties(""; ->rft_error_log; True:C214; ""; False:C215)
End if 

rft_Response:=""
$0:=$fSuccess


If (False:C215)  //v0.1.0-JJG (05/06/16) - moved to wmss_ScanObjectMulti_MySQL
	//$continue:=True
	//$SQLwhere:="WHERE 6 = 9"  //I don't care, if all the hypies, cut their hair
	
	//Case of 
	//: (Position(rft_Response;rft_log)>0)
	//$continue:=False
	//rft_error_log:="Duplicate scan"
	
	//: (Length(rft_Response)<3)
	//$continue:=False
	//rft_error_log:="Scan a label"
	
	//: (Substring(rft_Response;1;2)="BN")  //cant move a bin 
	//$continue:=False
	//rft_error_log:="Can't move a BIN"
	
	//: (Length(rft_Response)=20) & (rft_destination="skid")  //cant combine skids
	//$continue:=False
	//rft_error_log:="Can't combine SKIDS"
	
	//: (Length(rft_Response)=20) & (rft_destination="bin")  //skid, can only go to a bin
	//rft_object:="skid"
	//$SQLwhere:=" WHERE `skid_number` = '"+rft_Response+"'"
	//rft_caseId:=""
	//rft_log:=rft_log+rft_object+" "+rft_Response+"\r"
	
	//: (Length(rft_Response)=22)  //case, can go to bin or skid
	//rft_object:="case"
	//$SQLwhere:=" WHERE `case_id` = '"+rft_Response+"'"
	//rft_log:=rft_log+rft_object+" "+rft_Response+"\r"
	
	//Else 
	//$continue:=False
	//rft_error_log:="Scan a label"
	//End case 
	
	//If ($continue)
	//$conn_id:=DB_ConnectionManager ("Open")
	//If ($conn_id>0)
	
	//$sql:="SELECT `case_id`, `skid_number`, `case_status_code`, `bin_id`, `jobit`  FROM `cases`"+$SQLwhere
	//$row_set:=MySQL Select ($conn_id;$sql)
	//$row_count:=MySQL Get Row Count ($row_set)
	//If ($row_count>0)  //display what is going to move
	//ARRAY TEXT($rft_Case;0)
	//ARRAY TEXT($rft_Skid;0)
	//ARRAY TEXT($rft_Bin;0)
	//ARRAY TEXT($rft_jobit;0)
	//ARRAY LONGINT($acase_state;0)
	//ARRAY TEXT($rft_Status;0)
	
	//MySQL Column To Array ($row_set;"";1;$rft_Case)
	//MySQL Column To Array ($row_set;"";2;$rft_Skid)
	//MySQL Column To Array ($row_set;"";3;$acase_state)
	//MySQL Column To Array ($row_set;"";4;$rft_Bin)
	//MySQL Column To Array ($row_set;"";5;$rft_jobit)
	
	
	//ARRAY TEXT($rft_Status;$row_count)
	
	//If (rft_object="skid")
	//APPEND TO ARRAY(ListBox1;False)
	//APPEND TO ARRAY(rft_Skid;$rft_Skid{1})
	//APPEND TO ARRAY(rft_Bin;$rft_Bin{1})
	//APPEND TO ARRAY(rft_jobit;$rft_jobit{1})
	//APPEND TO ARRAY(rft_Status;wmss_CaseState ($acase_state{1}))
	//$skidQty:=0
	//For ($i;1;$row_count)
	//$skidQty:=$skidQty+Num(WMS_CaseId ($rft_Case{$i};"qty"))
	//End for 
	//iQty:=iQty+$skidQty
	//$strQty:=txt_Pad (String($skidQty);" ";3;14)
	
	//APPEND TO ARRAY(rft_Case;$strQty+String($row_count)+" cases")
	
	//Else   //scanned a case
	//If (rft_destination="skid")
	//If (sJobit#"MIXED")
	//If ($rft_jobit{1}#sJobit)
	//rft_error_log:="MIXED LOT "+$rft_jobit{1}+" not "+sJobit
	//$continue:=False
	//Else 
	//$continue:=True
	//End if   //mixed lot
	
	//Else   //allowed mixed for that label
	//$continue:=True
	//End if   //mixed skid
	
	//Else   //bin
	//$continue:=True
	//End if   // dest is skid
	
	//If ($continue)
	//For ($i;1;$row_count)
	//$rft_Status{$i}:=wmss_CaseState ($acase_state{$i})
	
	//iQty:=iQty+Num(WMS_CaseId ($rft_Case{$i};"qty"))
	
	//APPEND TO ARRAY(ListBox1;False)
	//APPEND TO ARRAY(rft_Case;$rft_Case{$i})
	//APPEND TO ARRAY(rft_Skid;$rft_Skid{$i})
	//APPEND TO ARRAY(rft_Bin;$rft_Bin{$i})
	//APPEND TO ARRAY(rft_jobit;$rft_jobit{$i})
	//APPEND TO ARRAY(rft_Status;$rft_Status{$i})
	//End for 
	//End if   //continuew
	
	//End if   //case or skid
	
	//  //this should be stopped at line# 
	//  //If ($rft_Case{1}=$rft_Skid{1})  //this is a skid so prevent move it on to another skid
	//  //rft_object:="supercase"
	
	//  //If (rft_destination="skid")
	//  //rft_error_log:="Supercase can't go on skid"
	//  //End if 
	//  //End if 
	
	//rft_error_log:=""
	//SetObjectProperties ("";->rft_error_log;False)
	//$0:=True
	
	//Else   //no cases found
	//rft_error_log:="No cases found."
	//End if   //nothing found
	
	//MySQL Delete Row Set ($row_set)
	//$conn_id:=DB_ConnectionManager ("Close")
	
	//Else 
	//rft_error_log:="Could not connect to WMS."
	//End if   //conn id
	
	//End if   //input was cool
	
	//If (Length(rft_error_log)=0)
	
	//Else 
	//SetObjectProperties ("";->rft_error_log;True;"";False)
	//End if 
	
	//rft_Response:=""
End if 