//%attributes = {}

// Method: wms_DailyMaintenance ( )  -> 
// ----------------------------------------------------
// Author: Mel Bohince
// Created: 02/18/15, 09:52:12
// ----------------------------------------------------
// Description
// make sure the the audits, ams_export, and cases don't keep growing, run in batch mode
// these are from the Task's menu of wms.arkay.com/iui
// ----------------------------------------------------
// Modified by: Mel Bohince (9/29/16) give them more time with shipped stuff, 1 week for statuss 300, 2 weeks for deletion

C_LONGINT:C283($result; $conn_id; $stmt)
C_TEXT:C284($sql; $msg)
C_DATE:C307($today; $yesterday; $weekAgo)

WMS_API_LoginLookup  //make sure <>WMS variables are up to date. `v0.1.0-JJG (05/16/16) - added 
If (Not:C34(<>fWMS_Use4D))  //if using WMS-4D, it will handle cleanup on its end   //v0.1.0-JJG (05/16/16) - added check
	
	//$today:=Current date
	//$yesterday:=Add to date($today;0;0;-1)
	//$weekAgo:=Add to date($today;0;0;-7)
	//$twoWeekAgo:=Add to date($today;0;0;-14)  // Modified by: Mel Bohince (9/29/16) added
	//<>WMS_ERROR:=0
	//$msg:=""
	
	//$conn_id:=DB_ConnectionManager ("Open")
	//If ($conn_id>0)  //only continue if connection to wms works
	
	//$sql:="DELETE FROM `audits` WHERE `audit_date` < ?"
	//$stmt:=MySQL New SQL Statement ($conn_id;$sql)
	//MySQL Set Date In SQL ($stmt;1;$yesterday)
	//$result:=MySQL Execute ($conn_id;"";$stmt)
	//MySQL Delete SQL Statement ($stmt)
	//$msg:=$msg+String($result)+" audit records deleted\r"
	
	//$sql:="DELETE FROM `ams_exports` WHERE `transaction_state_indicator` <> 'S' AND `transaction_date` < ?"
	//$stmt:=MySQL New SQL Statement ($conn_id;$sql)
	//MySQL Set Date In SQL ($stmt;1;$yesterday)
	//$result:=MySQL Execute ($conn_id;"";$stmt)
	//MySQL Delete SQL Statement ($stmt)
	//$msg:=$msg+String($result)+" ams_exports records deleted\r"
	
	//$sql:="DELETE FROM `ams_export_archives` WHERE `transaction_date` < ?"
	//$stmt:=MySQL New SQL Statement ($conn_id;$sql)
	//MySQL Set Date In SQL ($stmt;1;$yesterday)
	//$result:=MySQL Execute ($conn_id;"";$stmt)
	//MySQL Delete SQL Statement ($stmt)
	//$msg:=$msg+String($result)+" ams_export_archives records deleted\r"
	
	//$sql:="DELETE FROM `cases` WHERE `qty_in_case` = 0"
	//$stmt:=MySQL New SQL Statement ($conn_id;$sql)
	//$result:=MySQL Execute ($conn_id;"";$stmt)
	//MySQL Delete SQL Statement ($stmt)
	//$msg:=$msg+String($result)+" cases records deleted with zero qty\r"
	
	//  // Modified by: Mel Bohince (9/29/16) give them more time with shipped stuff, 1 week for statuss 300, 2 weeks for deletion
	//$sql:="DELETE FROM `cases` WHERE (`case_status_code` = 300 OR `case_status_code` = 400) AND `update_datetime` < ?"
	//$stmt:=MySQL New SQL Statement ($conn_id;$sql)
	//MySQL Set Date In SQL ($stmt;1;$twoWeekAgo)
	//$result:=MySQL Execute ($conn_id;"";$stmt)
	//MySQL Delete SQL Statement ($stmt)
	//$msg:=$msg+String($result)+" cases records deleted that shipped or scrapped\r"
	
	//  // Modified by: Mel Bohince (9/29/16) give them more time with shipped stuff, 1 week for statuss 300, 2 weeks for deletion
	//$sql:="UPDATE `cases` SET `case_status_code` = 300 WHERE `case_status_code` <> 300 AND `bin_id` like '%FG_SHIPPED%' AND `update_datetime` < ?"
	//$stmt:=MySQL New SQL Statement ($conn_id;$sql)
	//MySQL Set Date In SQL ($stmt;1;$weekAgo)
	//$result:=MySQL Execute ($conn_id;"";$stmt)
	//MySQL Delete SQL Statement ($stmt)
	//$msg:=$msg+String($result)+" cases records updated that moved to FG_SHIPPED\r"
	
	
	//End if 
	//$conn_id:=DB_ConnectionManager ("Close")
	
	//If (Length($msg)>0)
	//$preheader:="Make sure the audits, ams_export, and cases don't keep growing, see batch wms_DailyMaintenance\nAlso see Task's menu of wms.arkay.com/iui"
	//distributionList:="mel.bohince@arkay.com,"
	//  //EMAIL_Sender ("WMS Maintenance";"";$msg;distributionList)
	//Email_html_body ("WMS Maintenance";$preheader;$msg;500;distributionList)
	//End if 
	
End if   //v0.1.0-JJG (05/16/16) - end of added check