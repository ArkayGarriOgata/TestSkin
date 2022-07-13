//%attributes = {}
// ----------------------------------------------------
// User name (OS): Mark Zinke
// Date and time: 12/18/13, 07:06:18
// ----------------------------------------------------
// Method: FG_ShippedWithoutStaging()
// Description:
// Queries the [Finished_Goods_Transactions] where the transaction
// type is "ship" or "FG:AV@" for Rama and the transaction date is the current date.
// This runs from the Batch called "Inventory Accuracy".
// ----------------------------------------------------
// Modified by: Mel Bohince (3/28/14) don't show spl billing items or print when body is blank, HTML the email
// Modified by: Mel Bohince (10/22/14) fix search, show more detail in email
// Modified by: Mel Bohince (12/19/14) reach in to wms and set case status to shipped
// Modified by: JJG (3/18/17) 
// --------------------------------------------------


C_LONGINT:C283($i; $case; $updateStmt; $row_set; $rowCount; $xlCase; $xlCaseCount; $xlShippedQty)  //v1.0.3-JJG (03/13/17) - added $xlCase et al
C_TEXT:C284($tSubject; $tBodyHeader; $tBody; $queryStmt; $ttUpdateSQL; $ttQuerySQL; $ttConvertedBinID; $ttCaseID; $ttUpdateDatetime)  //v1.0.3-JJG (03/13/17) - added $ttUpdateSQL,$ttQuerySQL et al
C_DATE:C307($targetDate; $dUpdate; $1)  //v1.0.3-JJG (03/13/17) - added $dUpdate
$targetDate:=4D_Current_date

C_BOOLEAN:C305($updateWMS)  // Modified by: Mel Bohince (12/19/14) reach in to wms and set case status to shipped

ARRAY TEXT:C222($atProdCode; 0)
READ ONLY:C145([Finished_Goods_Transactions:33])
READ ONLY:C145([Finished_Goods_Locations:35])

If (Count parameters:C259>0)
	$targetDate:=$1
Else 
	$targetDate:=Date:C102(Request:C163("What date?"; String:C10(Current date:C33); "Ok"; "Cancel"))
	distributionList:=Email_WhoAmI
End if 

$tSubject:="Inventory Adjustment Needed for "+String:C10($targetDate; Internal date short:K1:7)
$tBodyHeader:="The following products appear to have quantities shipped without staging to FG:R_Shipped, "
$tBodyHeader:=$tBodyHeader+"please check WMS and make sure their case status is 300."

$tBody:=""
$bSendEmail:=False:C215

$b:="<tr style=\"background-color:#ffffff\"><td style=\"text-align:right;padding:4px 6px;border:1px solid #d6dde6;font-weight:300;color:#666\">"
$t:="</td><td style=\"text-align:right;padding:4px 6px;border:1px solid #d6dde6;font-weight:300;color:#666\">"
$r:="</td></tr>"+<>CR
$tBody:=$tBody+$b+"ProductCode"+$t+"Jobit"+$t+"Qty"+$t+"SkidNumber"+$t+"ViaLocation"+$t+"Updated?"+$r
$b:="<tr style=\"background-color:#ffffff\"><td style=\"text-align:right;padding:4px 6px;border:1px solid #d6dde6;font-weight:400\">"
$t:="</td><td style=\"text-align:right;padding:4px 6px;border:1px solid #d6dde6;font-weight:400\">"


QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]XactionType:2="Ship"; *)
QUERY:C277([Finished_Goods_Transactions:33];  & ; [Finished_Goods_Transactions:33]XactionDate:3=$targetDate; *)
QUERY:C277([Finished_Goods_Transactions:33];  & ; [Finished_Goods_Transactions:33]viaLocation:11#"@Ship@"; *)
//QUERY([Finished_Goods_Transactions]; & ;[Finished_Goods_Transactions]viaLocation#"FG:AV@";*)
QUERY:C277([Finished_Goods_Transactions:33];  & ; [Finished_Goods_Transactions:33]viaLocation:11#"Spl@"; *)
QUERY:C277([Finished_Goods_Transactions:33];  & ; [Finished_Goods_Transactions:33]viaLocation:11#"")
If (Records in selection:C76([Finished_Goods_Transactions:33])>0)
	// Modified by: Mel Bohince (12/19/14) reach in to wms and set case status to shipped
	
	WMS_API_LoginLookup  //make sure <>WMS variables are up to date.   //v1.0.3-JJG (03/13/17) - added
	
	If (<>fWMS_Use4D)  //v1.0.3-JJG (03/13/17) - added if-else; original in else-statement
		$updateWMS:=WMS_API_4D_DoLogin
		$ttUpdateSQL:="UPDATE cases SET case_status_code = 300, update_datetime = ? WHERE case_id = ?"
	Else 
		//$conn_id:=DB_ConnectionManager ("Open")
		//If ($conn_id>0)
		//$updateWMS:=True
		//$sql:="UPDATE `cases` SET `case_status_code` = 300, `update_datetime` = now() WHERE `case_id` = ?"
		//$updateStmt:=MySQL New SQL Statement ($conn_id;$sql)
		//Else 
		$updateWMS:=False:C215
		//End if 
	End if 
	
	//ORDER BY([Finished_Goods_Transactions];[Finished_Goods_Transactions]XactionDate;>;[Finished_Goods_Transactions]ProductCode;>;[Finished_Goods_Transactions]Jobit;>)
	//SELECTION TO ARRAY([Finished_Goods_Transactions]ProductCode;$atProdCode;[Finished_Goods_Transactions]Jobit;$atJobit;[Finished_Goods_Transactions]Qty;$atQty;[Finished_Goods_Transactions]viaLocation;$atVia;[Finished_Goods_Transactions]XactionDate;$atDate;[Finished_Goods_Transactions]SkidTicketNo;$atSkid)
	$lastCPN:=""
	$lastJOBit:=""
	$overflowed:=False:C215
	ORDER BY:C49([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]ProductCode:1; >; [Finished_Goods_Transactions:33]Jobit:31; >; [Finished_Goods_Transactions:33]Skid_number:29; >)
	SELECTION TO ARRAY:C260([Finished_Goods_Transactions:33]ProductCode:1; $atProdCode; [Finished_Goods_Transactions:33]Jobit:31; $atJobit; [Finished_Goods_Transactions:33]Qty:6; $atQty; [Finished_Goods_Transactions:33]viaLocation:11; $atVia; [Finished_Goods_Transactions:33]Skid_number:29; $atSkid)
	For ($i; 1; Size of array:C274($atProdCode))
		//$tBody:=$tBody+String($atDate{$i};Internal date short)+"  "+$atJobit{$i}+"  "+txt_Pad ($atProdCode{$i};" ";1;20)+"  "+txt_Pad (String($atQty{$i});" ";-1;7)+"   "+txt_Pad ($atSkid{$i};" ";1;20)+"   "+$atVia{$i}+" upd="+String($updateWMS)+<>CR
		If (Length:C16($atSkid{$i})=20)
			$skid:=Substring:C12($atSkid{$i}; 1; 3)+"..."+Substring:C12($atSkid{$i}; 13)
		Else 
			$skid:=$atSkid{$i}
		End if 
		If (Length:C16($atVia{$i})=13)
			$bin:=Substring:C12($atVia{$i}; 5)
		Else 
			$bin:=$atVia{$i}
		End if 
		
		If ($lastCPN#$atProdCode{$i})
			$lastCPN:=$atProdCode{$i}
			$cpn:=$lastCPN
		Else 
			$cpn:="^"
		End if 
		
		If ($lastJOBit#$atJobit{$i})
			$lastJOBit:=$atJobit{$i}
			$jobit:=$lastJOBit
		Else 
			$jobit:="^"
		End if 
		If (Length:C16($tBody)<30000)
			$tBody:=$tBody+$b+$cpn+$t+$jobit+$t+String:C10($atQty{$i}; "###,##0")+$t+$skid+$t+$bin+$t+Substring:C12(String:C10($updateWMS); 1; 1)+$r
		Else   //buffer overflow
			If (Not:C34($overflowed))
				$tBody:=$tBody+$b+"...truncated..."+$t+$t+$t+$t+$t+$r
				$overflowed:=True:C214
			End if 
		End if 
		//v1.0.3-JJG (03/13/17) - added re-worked block 
		Case of 
			: (Not:C34($updateWMS))
				//do nothing
			: (Not:C34(<>fWMS_Use4D))  //original code here
				//reach into MysQL wms and change status on cases until the shipped quantity is reached, somewhat arbitrary
				//$shippedQty:=$atQty{$i}
				//$converted_bin_id:=wms_convert_bin_id ("wms";$atVia{$i})
				//$queryStmt:="SELECT case_id, qty_in_case FROM cases WHERE jobit = '"+Replace string($atJobit{$i};".";"")+"' AND bin_id = '"+$converted_bin_id+"'"
				//$row_set:=MySQL Select ($conn_id;$queryStmt)
				//ARRAY TEXT($case_ids;0)
				//ARRAY LONGINT($case_qtys;0)
				//MySQL Column To Array ($row_set;"case_id";0;$case_ids)
				//MySQL Column To Array ($row_set;"qty_in_case";0;$case_qtys)
				//MySQL Delete Row Set ($row_set)
				//$num_cases:=Size of array($case_ids)
				
				//$case:=1
				//While ($shippedQty>0) & ($case<=$num_cases)
				//MySQL Set String In SQL ($updateStmt;1;$case_ids{$case})
				//$result:=MySQL Execute ($conn_id;"";$updateStmt)
				//$shippedQty:=$shippedQty-$case_qtys{$case}
				//$case:=$case+1
				//End while 
				
			Else   //reach into 4D-version of WMS and change status on cases until the shipped quantity is reached, somewhat arbitrary
				ARRAY TEXT:C222($sttCaseIDs; 0)
				ARRAY LONGINT:C221($sxlCaseQty; 0)
				$xlShippedQty:=$atQty{$i}
				$ttConvertedBinID:=wms_convert_bin_id("wms"; $atVia{$i})
				$ttQuerySQL:="SELECT case_id, qty_in_case FROM cases WHERE jobit = '"+Replace string:C233($atJobit{$i}; "."; "")+"' AND bin_id = '"+$ttConvertedBinID+"'"
				SQL EXECUTE:C820($ttQuerySQL; $sttCaseIDs; $sxlCaseQty)
				If (OK=1)
					If (Not:C34(SQL End selection:C821))
						SQL LOAD RECORD:C822(SQL all records:K49:10)
					End if 
					SQL CANCEL LOAD:C824
				End if 
				$xlCaseCount:=Size of array:C274($sttCaseIDs)
				
				If ($xlCaseCount>0)
					$xlCase:=1
					While (($xlShippedQty>0) & ($xlCase<=$xlCaseCount))
						$ttCaseID:=$sttCaseIDs{$xlCase}
						$dUpdate:=4D_Current_date
						$ttUpdateDatetime:=String:C10(Year of:C25($dUpdate))+"-"+String:C10(Month of:C24($dUpdate))+"-"+String:C10(Day of:C23($dUpdate))+" "+String:C10(4d_Current_time; HH MM SS:K7:1)
						SQL SET PARAMETER:C823($ttUpdateDatetime; SQL param in:K49:1)
						SQL SET PARAMETER:C823($ttCaseID; SQL param in:K49:1)
						SQL EXECUTE:C820($ttUpdateSQL)
						If (OK=1)
							$xlShippedQty:=$xlShippedQty-$sxlCaseQty{$xlCase}
						End if 
						SQL CANCEL LOAD:C824
						$xlCase:=1+$xlCase
					End while 
				End if 
		End case   //v1.0.3-JJG (03/13/17) - end of re-worked block
		If (False:C215)  //v1.0.3-JJG (03/13/17) - reworked above
			//If ($updateWMS)  // Modified by: Mel Bohince (12/19/14) reach in to wms and set case status to shipped
			//  //reach into wms and change status on cases until the shipped quantity is reached, somewhat arbitrary
			//$shippedQty:=$atQty{$i}
			//$converted_bin_id:=wms_convert_bin_id ("wms";$atVia{$i})
			//$queryStmt:="SELECT case_id, qty_in_case FROM cases WHERE jobit = '"+Replace string($atJobit{$i};".";"")+"' AND bin_id = '"+$converted_bin_id+"'"
			//$row_set:=MySQL Select ($conn_id;$queryStmt)
			//ARRAY TEXT($case_ids;0)
			//ARRAY LONGINT($case_qtys;0)
			//MySQL Column To Array ($row_set;"case_id";0;$case_ids)
			//MySQL Column To Array ($row_set;"qty_in_case";0;$case_qtys)
			//MySQL Delete Row Set ($row_set)
			//$num_cases:=Size of array($case_ids)
			
			//$case:=1
			//While ($shippedQty>0) & ($case<=$num_cases)
			//MySQL Set String In SQL ($updateStmt;1;$case_ids{$case})
			//$result:=MySQL Execute ($conn_id;"";$updateStmt)
			//$shippedQty:=$shippedQty-$case_qtys{$case}
			//$case:=$case+1
			//End while 
			//End if 
		End if 
	End for 
	
	If ($updateWMS)  // Modified by: Mel Bohince (12/19/14) reach in to wms and set case status to shipped
		If (<>fWMS_Use4D)  //v1.0.3-JJG (03/13/17) - added if-statement, orginal in else
			WMS_API_4D_DoLogout
		Else 
			//MySQL Delete SQL Statement ($updateStmt)
			//$conn_id:=DB_ConnectionManager ("Close")
		End if 
	End if 
	
	If (Length:C16($tBody)>0)  // Modified by: Mel Bohince (3/28/14) don't show spl billing items or print when body is blank
		//EMAIL_Sender ($tSubject;$tBodyHeader;$tBody;distributionList)
		Email_html_table($tSubject; $tBodyHeader; $tBody; 750; distributionList)
	End if 
End if 


//If (Records in selection([Finished_Goods_Transactions])>0)
//  // Modified by: Mel Bohince (12/19/14) reach in to wms and set case status to shipped
//$conn_id:=DB_ConnectionManager ("Open")
//If ($conn_id>0)
//$updateWMS:=True
//$sql:="UPDATE `cases` SET `case_status_code` = 300, `update_datetime` = now() WHERE `case_id` = ?"
//$updateStmt:=MySQL New SQL Statement ($conn_id;$sql)
//Else 
//$updateWMS:=False
//End if 

//  //ORDER BY([Finished_Goods_Transactions];[Finished_Goods_Transactions]XactionDate;>;[Finished_Goods_Transactions]ProductCode;>;[Finished_Goods_Transactions]Jobit;>)
//  //SELECTION TO ARRAY([Finished_Goods_Transactions]ProductCode;$atProdCode;[Finished_Goods_Transactions]Jobit;$atJobit;[Finished_Goods_Transactions]Qty;$atQty;[Finished_Goods_Transactions]viaLocation;$atVia;[Finished_Goods_Transactions]XactionDate;$atDate;[Finished_Goods_Transactions]SkidTicketNo;$atSkid)
//$lastCPN:=""
//$lastJOBit:=""
//$overflowed:=False
//ORDER BY([Finished_Goods_Transactions];[Finished_Goods_Transactions]ProductCode;>;[Finished_Goods_Transactions]Jobit;>;[Finished_Goods_Transactions]SkidTicketNo;>)
//SELECTION TO ARRAY([Finished_Goods_Transactions]ProductCode;$atProdCode;[Finished_Goods_Transactions]Jobit;$atJobit;[Finished_Goods_Transactions]Qty;$atQty;[Finished_Goods_Transactions]viaLocation;$atVia;[Finished_Goods_Transactions]SkidTicketNo;$atSkid)
//For ($i;1;Size of array($atProdCode))
//  //$tBody:=$tBody+String($atDate{$i};Internal date short)+"  "+$atJobit{$i}+"  "+txt_Pad ($atProdCode{$i};" ";1;20)+"  "+txt_Pad (String($atQty{$i});" ";-1;7)+"   "+txt_Pad ($atSkid{$i};" ";1;20)+"   "+$atVia{$i}+" upd="+String($updateWMS)+<>CR
//If (Length($atSkid{$i})=20)
//$skid:=Substring($atSkid{$i};1;3)+"..."+Substring($atSkid{$i};13)
//Else 
//$skid:=$atSkid{$i}
//End if 
//If (Length($atVia{$i})=13)
//$bin:=Substring($atVia{$i};5)
//Else 
//$bin:=$atVia{$i}
//End if 

//If ($lastCPN#$atProdCode{$i})
//$lastCPN:=$atProdCode{$i}
//$cpn:=$lastCPN
//Else 
//$cpn:="^"
//End if 

//If ($lastJOBit#$atJobit{$i})
//$lastJOBit:=$atJobit{$i}
//$jobit:=$lastJOBit
//Else 
//$jobit:="^"
//End if 
//If (Length($tBody)<30000)
//$tBody:=$tBody+$b+$cpn+$t+$jobit+$t+String($atQty{$i};"###,##0")+$t+$skid+$t+$bin+$t+Substring(String($updateWMS);1;1)+$r
//Else   //buffer overflow
//If (Not($overflowed))
//$tBody:=$tBody+$b+"...truncated..."+$t+$t+$t+$t+$t+$r
//$overflowed:=True
//End if 
//End if 
//If ($updateWMS)  // Modified by: Mel Bohince (12/19/14) reach in to wms and set case status to shipped
//  //reach into wms and change status on cases until the shipped quantity is reached, somewhat arbitrary
//$shippedQty:=$atQty{$i}
//$converted_bin_id:=wms_convert_bin_id ("wms";$atVia{$i})
//$queryStmt:="SELECT case_id, qty_in_case FROM cases WHERE jobit = '"+Replace string($atJobit{$i};".";"")+"' AND bin_id = '"+$converted_bin_id+"'"
//$row_set:=MySQL Select ($conn_id;$queryStmt)
//ARRAY TEXT($case_ids;0)
//ARRAY LONGINT($case_qtys;0)
//MySQL Column To Array ($row_set;"case_id";0;$case_ids)
//MySQL Column To Array ($row_set;"qty_in_case";0;$case_qtys)
//MySQL Delete Row Set ($row_set)
//$num_cases:=Size of array($case_ids)

//$case:=1
//While ($shippedQty>0) & ($case<=$num_cases)
//MySQL Set String In SQL ($updateStmt;1;$case_ids{$case})
//$result:=MySQL Execute ($conn_id;"";$updateStmt)
//$shippedQty:=$shippedQty-$case_qtys{$case}
//$case:=$case+1
//End while 
//End if 
//End for 

//If ($updateWMS)  // Modified by: Mel Bohince (12/19/14) reach in to wms and set case status to shipped
//MySQL Delete SQL Statement ($updateStmt)
//$conn_id:=DB_ConnectionManager ("Close")
//End if 

//If (Length($tBody)>0)  // Modified by: Mel Bohince (3/28/14) don't show spl billing items or print when body is blank
//  //EMAIL_Sender ($tSubject;$tBodyHeader;$tBody;distributionList)
//Email_html_table ($tSubject;$tBodyHeader;$tBody;750;distributionList)
//End if 
//End if 