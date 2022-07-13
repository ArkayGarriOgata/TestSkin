//%attributes = {}
//©2016 Footprints Inc. All Rights Reserved.
//Method: wms_api_4D_SendJobits_DoSend - Created v0.1.0-JJG (05/05/16)
// Modified by: Mel Bohince (12/7/17) ' kills the sql command
If (<>fDebug)
	DODEBUG(Current method name:C684)
End if 


C_TEXT:C284($1; $ttJobit; $ttSQL; $ttFGKey; $ttCustID; $ttCartDesc)
C_DATE:C307($2; $dGlueDate)
C_LONGINT:C283($xlCaseCount; $xlNumFG; $xlCasesPerSkid; $xlDefaultCount; $xlAltBarcode)
$ttJobit:=$1
$dGlueDate:=$2

$ttFGKey:=[Job_Forms_Items:44]CustId:15+":"+[Job_Forms_Items:44]ProductCode:3
$xlNumFG:=qryFinishedGood("#KEY"; ([Job_Forms_Items:44]CustId:15+":"+[Job_Forms_Items:44]ProductCode:3))
$xlDefaultCount:=PK_getCaseCount([Finished_Goods:26]OutLine_Num:4)
$ttCustID:=[Job_Forms_Items:44]CustId:15  //[Finished_Goods]OutLine_Num  // Modified by: Mel Bohince (1/17/17)
$ttCartDesc:=Replace string:C233([Finished_Goods:26]CartonDesc:3; "'"; "")  // Modified by: Mel Bohince (12/7/17) ' kills the sql command
$ttCartDesc:=Substring:C12($ttCartDesc; 1; 249)
$xlCasesPerSkid:=PK_getCasesPerSkid([Finished_Goods:26]OutLine_Num:4)
If ($xlCasesPerSkid=0)
	$xlCasesPerSkid:=99
End if 
$xlAltBarcode:=Num:C11(Position:C15([Job_Forms_Items:44]CustId:15; <>WMS_ALT_LABELS)#0)

$ttSQL:="INSERT INTO jobits "
$ttSQL:=$ttSQL+" (jobit,fg_key,default_qty_in_case,case_per_skid,cust_id,description,glue_date,alternate_barcode) "
$ttSQL:=$ttSQL+" VALUES ( '"+$ttJobit+"', '"+$ttFGKey+"', "+String:C10($xlDefaultCount)+", "+String:C10($xlCasesPerSkid)+", '"+$ttCustID+"', '"+$ttCartDesc+"', '"+FormatSQLDate($dGlueDate)+"', "+String:C10($xlAltBarcode)+")"

//for testing

//SET TEXT TO PASTEBOARD($ttSQL)
//ALERT($ttSQL)


SQL EXECUTE:C820($ttSQL)
SQL CANCEL LOAD:C824

If (OK=1)
	[Job_Forms_Items:44]ModDate:29:=Current date:C33  //*** temp ***
	SAVE RECORD:C53([Job_Forms_Items:44])
End if 