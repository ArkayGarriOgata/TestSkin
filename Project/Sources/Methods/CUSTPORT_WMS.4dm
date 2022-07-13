//%attributes = {}
// ----------------------------------------------------
// User name (OS): Mel Bohince
// Date and time: 12/09/10, 09:22:50
// ----------------------------------------------------
// Method: CUSTPORT_WMS
// Description
// track inventory at an external warehouse that has a web interface
//status codes:
//0 intial creation in web db [transit]
//1 set by web app when pallet is received [received]
//2 receipt is being processed [putaway]
//3 receipt has been acknowledged [stocked]
//4 set by web app when pallet is issued (shipped to customer) [issued]
//5 issue is being processed [delivering]
//6 issue has been acknowledged, purged a month later [shipped]
//see also wms_api_Get_Process

// Parameters
//$1 = action requested
// ----------------------------------------------------

C_LONGINT:C283($i; $affected_rows; $row_set; $row_count; $numElements; $last_delimiter; $stmt; $conn_id_rk; $conn_id_web; $result; $rows_to_insert; $0)  //
C_TEXT:C284($1; $action; $last_month; $timestamp; $now; $sql; $email_text; $bol_timestamp)
C_TEXT:C284($t; $r)
C_TEXT:C284($WHS_ID; $ACCESS_CODE)

$t:="', '"
$r:="'),"+Char:C90(13)

READ ONLY:C145([Finished_Goods_Locations:35])
READ ONLY:C145([Customers_Bills_of_Lading:49])

$WHS_ID:="ext"  //later may be a parameter for multiple warehouses
$ACCESS_CODE:="00120"  //set for ELC access on customer portal
$ROANOKE_WAREHOUSE:="R"  //from the initial move from bin to dock
$TRANSMIT_DATA:="T"  //in state of data transmittal
$EXTERNAL_WAREHOUSE:="D"  //distribution warehouse, such as itg or uti or sdv
If (Count parameters:C259=0)
	$action:=Request:C163("Which action?(move | relieve"; "relieve")
Else 
	$action:=$1
	OK:=1
End if 

Case of 
	: (OK=0)  //cancelled testing dialog
	: ($action="move")  //take internal records and move to web db
		C_TEXT:C284(xTitle; xText; docName)
		$email_text:=""
		$timestamp:=fYYMMDD(Current date:C33; 0; "")+"_"+Replace string:C233(String:C10(Current time:C178; HH MM SS:K7:1); ":"; "")
		C_TIME:C306($docRef)
		docName:="CUSTPORT_Warehouse"+$timestamp+".sql"
		$docRef:=util_putFileName(->docName)
		If ($docRef#?00:00:00?)
			
			//$conn_id_rk:=DB_ConnectionManager ("Open")
			If ($conn_id_rk>0)
				//look for and tag inventory that is to be moved to external warehouse
				//do this first in case more arrive midst processing, switching the warehouse designation from R to T during processing
				//then from T to D once records have been sent. 
				$now:=TS_ISO_String_TimeStamp  //transaction datetime for this event
				
				//before warehouse=R, time=whenever()
				//after warehouse=T, time=now()
				//final warehouse=D, time=then()
				$sql:="UPDATE `cases` SET warehouse = '"+$TRANSMIT_DATA+"', update_datetime = '"+$now+"'"
				$sql:=$sql+" WHERE bin_id in (SELECT bin_id FROM bins WHERE description = 'External Warehouse') AND warehouse = '"+$ROANOKE_WAREHOUSE+"' "
				$sql:=$sql+" and skid_number is not null"
				//$stmt:=MySQL New SQL Statement ($conn_id_rk;$sql)
				//$result:=MySQL Execute ($conn_id_rk;"";$stmt)
				
				//consolidate by pallet and create corrisponding records in web db for the batch tagged above
				$sql:="SELECT substr(j.fg_key,7) AS Item, c.jobit as Lot, c.glue_date as DOM, c.skid_number AS Pallet_ID, SUM(c.qty_in_case) AS Pallet_Qty, count(c.case_id) AS Num_Cases, c.bin_id as Bin "
				$sql:=$sql+" FROM  `cases` `c` JOIN `jobits` `j` ON  `c`.`jobit` = `j`.`jobit` "
				$sql:=$sql+" WHERE c.warehouse = '"+$TRANSMIT_DATA+"' GROUP BY c.skid_number, c.jobit"
				
				//$row_set:=MySQL Select ($conn_id_rk;$sql)
				//$rows_to_insert:=MySQL Get Row Count ($row_set)
				$0:=$rows_to_insert
				If ($rows_to_insert>0)
					ARRAY TEXT:C222($aPostDate; 0)
					ARRAY TEXT:C222($aItem; 0)
					ARRAY TEXT:C222($aJobit; 0)
					ARRAY DATE:C224($aGlueDate; 0)
					ARRAY TEXT:C222($aPalletId; 0)
					ARRAY LONGINT:C221($aPalletQty; 0)
					ARRAY LONGINT:C221($aNumCases; 0)
					ARRAY TEXT:C222($aBin; 0)
					
					//MySQL Column To Array ($row_set;"";1;$aItem)
					//MySQL Column To Array ($row_set;"";2;$aJobit)
					//MySQL Column To Array ($row_set;"";3;$aGlueDate)
					//MySQL Column To Array ($row_set;"";4;$aPalletId)
					//MySQL Column To Array ($row_set;"";5;$aPalletQty)
					//MySQL Column To Array ($row_set;"";6;$aNumCases)
					//MySQL Column To Array ($row_set;"";7;$aBin)
					
					//MySQL Delete Row Set ($row_set)
					
					$quantity_to_insert:=0
					$numElements:=Size of array:C274($aItem)  // set the date
					ARRAY TEXT:C222($aPostDate; $numElements)
					ARRAY TEXT:C222($aWhseId; $numElements)
					ARRAY TEXT:C222($aStatus; $numElements)
					ARRAY TEXT:C222($aAccessCode; $numElements)
					For ($i; 1; $numElements)
						$quantity_to_insert:=$quantity_to_insert+$aPalletQty{$i}
						$aAccessCode{$i}:=$ACCESS_CODE
						$aWhseId{$i}:=$WHS_ID
						$aPostDate{$i}:=$now
						$aStatus{$i}:="transit"
						If ($aPalletId{$i}="NULL")
							If ($aNumCases{$i}>1)
								$aPalletId{$i}:="loose_cases"
							Else 
								$aPalletId{$i}:="loose_case"
							End if 
						End if 
					End for 
					
					//send them to the web database
					//$conn_id_web:=CUSTPORT_ConnectionManager ("Open")
					If ($conn_id_web>0)
						xText:="INSERT INTO `warehouses` "
						xText:=xText+"(`access_filter`,`status`,`whse_id`, `product_code`, `jobit`, `date_glued`, `pallet_id`, `pallet_qty`, `num_cases`, `date_sent`, `bin_id`)"  //date_received, date_issued, release_number
						xText:=xText+" VALUES "+Char:C90(13)
						For ($i; 1; $numElements)
							If (Length:C16(xText)>25000)
								SEND PACKET:C103($docRef; xText)
								xText:=""
							End if 
							
							xText:=xText+"('"+$aAccessCode{$i}+$t+$aStatus{$i}+$t+$aWhseId{$i}+$t+$aItem{$i}+$t+$aJobit{$i}+$t+fYYMMDD($aGlueDate{$i}; 10; "-")+$t+$aPalletId{$i}+$t+String:C10($aPalletQty{$i})+$t+String:C10($aNumCases{$i})+$t+$aPostDate{$i}+$t+$aBin{$i}+$r
							$email_text:=$email_text+"cpn: "+$aItem{$i}+"  jobit: "+$aJobit{$i}+"  pallet: "+$aPalletId{$i}+"  from: "+$aBin{$i}+"  with: "+String:C10($aNumCases{$i})+" cases, totalling: "+String:C10($aPalletQty{$i})+" cartons"+Char:C90(13)
							
						End for 
						$last_delimiter:=Length:C16(xText)-1
						xText[[$last_delimiter]]:=";"
						SEND PACKET:C103($docRef; xText)
						CLOSE DOCUMENT:C267($docRef)
						
						DOCUMENT TO BLOB:C525(docName; $sql_blob)
						//$affected_rows:=MySQL Execute Blob ($conn_id_web;$sql_blob)
						SET BLOB SIZE:C606($sql_blob; 0)
						
						//perform rough check to see if two phase commit is called for, if this finds errors then before marking the wms records as processed will need to backcheck
						//consolidate by pallet and create corrisponding records in web db
						ARRAY TEXT:C222($aPalletId_inserted; 0)
						ARRAY LONGINT:C221($aPalletQty_inserted; 0)
						$sql:="SELECT pallet_id, pallet_qty FROM warehouses WHERE date_sent = '"+$now+"'"
						//$row_set:=MySQL Select ($conn_id_web;$sql)
						//$rows_inserted:=MySQL Get Row Count ($row_set)
						//MySQL Column To Array ($row_set;"";1;$aPalletId_inserted)
						//MySQL Column To Array ($row_set;"";2;$aPalletQty_inserted)
						//MySQL Delete Row Set ($row_set)
						$quantity_inserted:=0
						For ($i; 1; $rows_inserted)
							$quantity_inserted:=$quantity_inserted+$aPalletQty_inserted{$i}
						End for 
						
						//$conn_id_web:=CUSTPORT_ConnectionManager ("Close")
						
						Case of 
							: ($rows_to_insert#$rows_inserted)
								utl_Logfile("cust_portal.log"; "### ERROR: "+String:C10($rows_inserted)+" records inserted, should have been "+String:C10($rows_to_insert))
								$email_text:=$email_text+"### ERROR: "+String:C10($rows_inserted)+" records inserted, should have been "+String:C10($rows_to_insert)
							: ($quantity_to_insert#$quantity_inserted)
								utl_Logfile("cust_portal.log"; "### ERROR: "+String:C10($quantity_inserted)+" cartons inserted, should have been "+String:C10($quantity_to_insert))
								$email_text:=$email_text+"### ERROR: "+String:C10($quantity_inserted)+" cartons inserted, should have been "+String:C10($quantity_to_insert)
							Else 
								utl_Logfile("cust_portal.log"; "RESULT: "+String:C10($quantity_inserted)+" cartons inserted, in "+String:C10($rows_inserted)+" rows")
								//change the temporary marker on 'warehouse' so they wont get hit next time
								//final warehouse=D, time=then()
								$sql:="UPDATE `cases` SET warehouse = '"+$EXTERNAL_WAREHOUSE+"' WHERE warehouse = '"+$TRANSMIT_DATA+"'"
								//$stmt:=MySQL New SQL Statement ($conn_id_rk;$sql)
								//$result:=MySQL Execute ($conn_id_rk;"";$stmt)
								$email_text:=$email_text+"RESULT: "+String:C10($quantity_inserted)+" cartons inserted, in "+String:C10($rows_inserted)+" rows"
						End case 
						
						//$conn_id_rk:=DB_ConnectionManager ("Close")
						
						//send packing slip
						If (Length:C16($email_text)>0)
							$distribList:=Batch_GetDistributionList("FiFo Shipping Test")  //"mel.bohince@arkay.com"  `
							EMAIL_Sender("Pallets Moved to External Warehouse"; ""; $email_text; $distribList)
						End if 
						
					End if   //connect to portal
					
				Else   //nothing to move
					//utl_Logfile ("cust_portal.log";"### WARNING: Nothing to send")  `log a warning
				End if   //row count>0
				
			End if   //connect to wms
			
		Else 
			utl_Logfile("cust_portal.log"; "### WARNING: CUSTPORT_Warehouse.sql couldn't be created.")  //log a warning`
		End if 
		
	: ($action="received") & (False:C215)  //decided not to bother with this step
		//web app sets the date_received to current date and the status = 'received' when the pallets are scanned into the warehouse
		//update the status flag to show being processed
		//$conn_id_web:=CUSTPORT_ConnectionManager ("Open")
		//If ($conn_id_web>0)
		//$sql:="UPDATE `warehouses` SET status = 'putaway' WHERE status = 'received'"  `tag them as being gathered
		//$stmt:=MySQL New SQL Statement ($conn_id_web;$sql)
		//$result:=MySQL Execute ($conn_id_web;"";$stmt)
		//
		//  `set the ams bin correctly
		//$sql:="SELECT product_code, sum(pallet_qty) FROM warehouses WHERE status = 'putaway' group by product_code"
		//$row_set:=MySQL Select ($conn_id_web;$sql)
		//$row_count:=MySQL Get Row Count ($row_set)
		//$0:=$row_count
		//If ($row_count>0)
		//ARRAY TEXT($aProduct_code;0)
		//ARRAY LONGINT($aPallet_qty;0)
		//MySQL Column To Array ($row_set;"";1;$aProduct_code)
		//MySQL Column To Array ($row_set;"";2;$aPallet_qty)
		//MySQL Delete Row Set ($row_set)
		//
		//For ($i;1;Size of array($aProduct_code))
		//QUERY([Finished_Goods_Locations];[Finished_Goods_Locations]ProductCode=$aProduct_code{$i};*)
		//QUERY([Finished_Goods_Locations]; & ;[Finished_Goods_Locations]Location="FG:R_EXTERNAL_WHSE")  `sending bin
		//
		//Case of 
		//: (Records in selection([Finished_Goods_Locations])=1)
		//If ([Finished_Goods_Locations]QtyOH<=$aPallet_qty{$i})  `convert the bin to distribution warehouse
		//[Finished_Goods_Locations]Location:="FG:D_EXTERNAL_WHSE"
		//Else   `reduce the "sending" bin then create a distribution bin
		//[Finished_Goods_Locations]QtyOH:=[Finished_Goods_Locations]QtyOH-$aPallet_qty{$i}
		//SAVE RECORD([Finished_Goods_Locations])
		//End if 
		//: (Records in selection([Finished_Goods_Locations])>1)
		//
		//End case 
		//
		//End for 
		//
		//  `update the status flag
		//$sql:="UPDATE `warehouses` SET status = 'stocked' WHERE status = 'putaway'"  `tag them as posted
		//$stmt:=MySQL New SQL Statement ($conn_id_web;$sql)
		//$result:=MySQL Execute ($conn_id_web;"";$stmt)
		//End if 
		//$conn_id_web:=CUSTPORT_ConnectionManager ("Close")
		//End if   `connected to custport
		
		//If (Size of array($aPalletId)>0)
		//$conn_id:=DB_ConnectionManager ("Open")
		//If ($conn_id>0)
		//  `set the warehouse column for each pallet
		//
		//$conn_id:=DB_ConnectionManager ("Close")
		//End if 
		//End if 
		
	: ($action="relieve")
		//web app sets the date_issued to current date and the status = 'issued' when the pallets are scanned for shipment to customer
		//update the status flag to show being processed
		//$conn_id_web:=CUSTPORT_ConnectionManager ("Open")
		
		//delete any that where issued a month ago
		$last_month:=TS2iso(TSTimeStamp(Add to date:C393(4D_Current_date; 0; -1; 0)))
		$sql:="DELETE FROM warehouses WHERE status = 'shipped' AND date_issued < '"+$last_month+"'"  //tag them as being gathered
		//$stmt:=MySQL New SQL Statement ($conn_id_web;$sql)
		//$result:=MySQL Execute ($conn_id_web;"";$stmt)
		
		$sql:="UPDATE warehouses SET status = 'delivering' WHERE status = 'issued'"  //tag them as being gathered
		//$stmt:=MySQL New SQL Statement ($conn_id_web;$sql)
		//$result:=MySQL Execute ($conn_id_web;"";$stmt)
		
		$sql:="SELECT pallet_id, product_code, jobit, pallet_qty, bin_id FROM warehouses WHERE status = 'delivering'"
		ARRAY TEXT:C222($aPalletId; 0)
		ARRAY TEXT:C222($aItem; 0)
		ARRAY TEXT:C222($aJobit; 0)
		ARRAY LONGINT:C221($aPalletQty; 0)
		ARRAY TEXT:C222($aBin; 0)
		
		//$row_set:=MySQL Select ($conn_id_web;$sql)
		//$rows_to_insert:=MySQL Get Row Count ($row_set)
		
		//MySQL Column To Array ($row_set;"";1;$aPalletId)
		//MySQL Column To Array ($row_set;"";2;$aItem)
		//MySQL Column To Array ($row_set;"";3;$aJobit)
		//MySQL Column To Array ($row_set;"";4;$aPalletQty)
		//MySQL Column To Array ($row_set;"";5;$aBin)
		//MySQL Delete Row Set ($row_set)
		
		If (Size of array:C274($aPalletId)>0)
			$email_text:=""
			//$conn_id_rk:=DB_ConnectionManager ("Open")
			If ($conn_id_rk>0)
				//set the case_status_code column for each pallet as shipped
				For ($i; 1; Size of array:C274($aPalletId))
					//test the qty
					ARRAY LONGINT:C221($aWMSQty; 0)
					$sql:="SELECT SUM(qty_in_case) FROM cases WHERE skid_number = '"+$aPalletId{$i}+"'"
					//$row_set:=MySQL Select ($conn_id_rk;$sql)
					//MySQL Column To Array ($row_set;"";1;$aWMSQty)
					//MySQL Delete Row Set ($row_set)
					If ($aWMSQty{1}#$aPalletQty{$i})
						utl_Logfile("cust_portal.log"; "### WARNING: Qty problem on skid_number "+$aPalletId{$i}+" wms = "+String:C10($aWMSQty{1})+" acp = "+String:C10($aPalletQty{$i}))  //log a warning`
						$email_text:=$email_text+"WARNING: Qty problem on skid_number "+$aPalletId{$i}+" wms = "+String:C10($aWMSQty{1})+" acp = "+String:C10($aPalletQty{$i})+Char:C90(13)
					End if 
					
					$sql:="UPDATE cases SET case_status_code = 300, bin_id = 'BNDFG_SHIPPED' WHERE skid_number = '"+$aPalletId{$i}+"'"
					//$stmt:=MySQL New SQL Statement ($conn_id_rk;$sql)
					//$result:=MySQL Execute ($conn_id_rk;"";$stmt)
					$email_text:=$email_text+"SHIP "+String:C10($aPalletQty{$i}; "###,###,##0")+" units of "+$aItem{$i}+" from location "+$aBin{$i}+" jobit = "+JMI_makeJobIt($aJobit{$i})+Char:C90(13)
				End for 
				//$conn_id_rk:=DB_ConnectionManager ("Close")
				
				//update the status flag
				$sql:="UPDATE `warehouses` SET status = 'shipped' WHERE status = 'delivering'"  //tag them as posted, keep them around for a month
				//$stmt:=MySQL New SQL Statement ($conn_id_web;$sql)
				//$result:=MySQL Execute ($conn_id_web;"";$stmt)
				//$conn_id_web:=CUSTPORT_ConnectionManager ("Close")
			End if 
			
			//send signal to ams to bill(ship) these pallets by creating a BOL
			If (Length:C16($email_text)>0)
				$distribList:="mel.bohince@arkay.com"  //Batch_GetDistributionList ("FiFo Shipping Test")
				EMAIL_Sender("Shipments from External Warehouse"; ""; $email_text; $distribList)
			End if 
		End if 
		
	: ($action="png_inventory")  //take internal records and move to web db
		//SELECT substr(j.fg_key,7) AS Item, c.jobit as Lot, c.glue_date as DOM, c.skid_number AS Pallet_ID, SUM(c.qty_in_case) AS Pallet_Qty, count(c.case_id) AS Num_Cases,
		// c.bin_id as Bin  FROM  `cases` `c` JOIN `jobits` `j` ON  `c`.`jobit` = `j`.`jobit`  where c.bin_id = 'BNRFG' or c.bin_id like 'BNR-%' and c.jobit in 
		//(select jobit from jobits where cust_id = '00199') GROUP BY c.skid_number, c.jobit;
		//%%%%%%%%%%%%%%%%%%%
		$ACCESS_CODE:="00199"
		$WHS_ID:="ARKAY"
		C_TEXT:C284(xTitle; xText; docName)
		$email_text:=""
		$timestamp:=fYYMMDD(Current date:C33; 0; "")+"_"+Replace string:C233(String:C10(Current time:C178; HH MM SS:K7:1); ":"; "")
		C_TIME:C306($docRef)
		docName:="CUSTPORT_Warehouse"+$timestamp+".sql"
		$docRef:=util_putFileName(->docName)
		If ($docRef#?00:00:00?)
			//$conn_id_rk:=DB_ConnectionManager ("Open")
			If ($conn_id_rk>0)
				//look for and tag inventory that is to be moved to external warehouse
				//do this first in case more arrive midst processing, switching the warehouse designation from R to T during processing
				//then from T to D once records have been sent. 
				$now:=TS_ISO_String_TimeStamp  //transaction datetime for this event
				
				//before warehouse=R, time=whenever()
				//after warehouse=T, time=now()
				//final warehouse=D, time=then()
				//$sql:="UPDATE `cases` SET warehouse = '"+$TRANSMIT_DATA+"', update_datetime = '"+$now+"'"
				//$sql:=$sql+" WHERE bin_id in (SELECT bin_id FROM bins WHERE description = 'External Warehouse') AND warehouse = '"+$ROANOKE_WAREHOUSE+"' "
				//$sql:=$sql+" and skid_number is not null"
				//$stmt:=MySQL New SQL Statement ($conn_id_rk;$sql)
				//$result:=MySQL Execute ($conn_id_rk;"";$stmt)
				
				//consolidate by pallet and create corrisponding records in web db for the batch tagged above
				$sql:="SELECT substr(j.fg_key,7) AS Item, c.jobit as Lot, c.glue_date as DOM, c.skid_number AS Pallet_ID, SUM(c.qty_in_case) AS Pallet_Qty, count(c.case_id) AS Num_Cases, c.bin_id as Bin "
				$sql:=$sql+" FROM  `cases` `c` JOIN `jobits` `j` ON  `c`.`jobit` = `j`.`jobit` "
				$sql:=$sql+" WHERE (c.bin_id = 'BNRFG' or c.bin_id like 'BNR-%') and"
				$sql:=$sql+" c.jobit in (select jobit from jobits where cust_id = '00199')"
				$sql:=$sql+" GROUP BY c.skid_number, c.jobit"
				
				$sql:="SELECT substr(j.fg_key,7) AS Item, c.jobit as Lot, c.glue_date as DOM, c.skid_number AS Pallet_ID, c.qty_in_case AS Pallet_Qty, count(c.case_id) AS Num_Cases, c.bin_id as Bin "
				$sql:=$sql+" FROM  `cases` `c` JOIN `jobits` `j` ON  `c`.`jobit` = `j`.`jobit` "
				$sql:=$sql+" WHERE c.skid_number like '000%' and"
				$sql:=$sql+" bin_id not like '%shipped'"
				$sql:=$sql+" GROUP BY c.skid_number, c.jobit"
				
				//$sql:="select c.skid_number, c.jobit, c.qty_in_case, j.fg_key, c.bin_id from cases c join jobits j on c.jobit = j.jobit where c.skid_number like '000%' and bin_id not like '%shipped'"
				//$row_set:=MySQL Select ($conn_id_rk;$sql)
				//$rows_to_insert:=MySQL Get Row Count ($row_set)
				$0:=$rows_to_insert
				If ($rows_to_insert>0)
					ARRAY TEXT:C222($aPostDate; 0)
					ARRAY TEXT:C222($aItem; 0)
					ARRAY TEXT:C222($aJobit; 0)
					ARRAY DATE:C224($aGlueDate; 0)
					ARRAY TEXT:C222($aPalletId; 0)
					ARRAY LONGINT:C221($aPalletQty; 0)
					ARRAY LONGINT:C221($aNumCases; 0)
					ARRAY TEXT:C222($aBin; 0)
					
					//MySQL Column To Array ($row_set;"";1;$aItem)
					//MySQL Column To Array ($row_set;"";2;$aJobit)
					//MySQL Column To Array ($row_set;"";3;$aGlueDate)
					//MySQL Column To Array ($row_set;"";4;$aPalletId)
					//MySQL Column To Array ($row_set;"";5;$aPalletQty)
					//MySQL Column To Array ($row_set;"";6;$aNumCases)
					//MySQL Column To Array ($row_set;"";7;$aBin)
					
					//MySQL Delete Row Set ($row_set)
					
					$quantity_to_insert:=0
					$numElements:=Size of array:C274($aItem)  // set the date
					//ARRAY TEXT($aPostDate;$numElements)
					ARRAY TEXT:C222($aWhseId; $numElements)
					ARRAY TEXT:C222($aStatus; $numElements)
					ARRAY TEXT:C222($aAccessCode; $numElements)
					For ($i; 1; $numElements)
						$quantity_to_insert:=$quantity_to_insert+$aPalletQty{$i}
						$aAccessCode{$i}:=$ACCESS_CODE
						$aWhseId{$i}:=$WHS_ID
						//$aPostDate{$i}:=$now
						
						$aStatus{$i}:="die-cut"
						If ($aPalletId{$i}="NULL")
							If ($aNumCases{$i}>1)
								$aPalletId{$i}:="loose_cases"
							Else 
								$aPalletId{$i}:="loose_case"
							End if 
						End if 
					End for 
					
					//send them to the web database
					//$conn_id_web:=CUSTPORT_ConnectionManager ("Open")
					If ($conn_id_web>0)
						xText:="DELETE FROM `warehouses` WHERE `access_filter` = '00199';"+Char:C90(13)
						xText:=xText+"INSERT INTO `warehouses` "
						xText:=xText+"(`access_filter`,`status`,`whse_id`, `product_code`, `jobit`, `date_glued`, `pallet_id`, `pallet_qty`, `num_cases`, `bin_id`)"  //`date_sent`, date_received, date_issued, release_number
						xText:=xText+" VALUES "+Char:C90(13)
						For ($i; 1; $numElements)
							If (Length:C16(xText)>25000)
								SEND PACKET:C103($docRef; xText)
								xText:=""
							End if 
							
							xText:=xText+"('"+$aAccessCode{$i}+$t+$aStatus{$i}+$t+$aWhseId{$i}+$t+$aItem{$i}+$t+$aJobit{$i}+$t+fYYMMDD($aGlueDate{$i}; 10; "-")+$t+$aPalletId{$i}+$t+String:C10($aPalletQty{$i})+$t+String:C10($aNumCases{$i})+$t+$aBin{$i}+$r  //+$t+$aPostDate{$i}
							//$email_text:=$email_text+"cpn: "+$aItem{$i}+"  jobit: "+$aJobit{$i}+"  pallet: "+$aPalletId{$i}+"  from: "+$aBin{$i}+"  with: "+String($aNumCases{$i})+" cases, totalling: "+String($aPalletQty{$i})+" cartons"+Char(13)
							
						End for 
						$last_delimiter:=Length:C16(xText)-1
						xText[[$last_delimiter]]:=";"
						SEND PACKET:C103($docRef; xText)
						CLOSE DOCUMENT:C267($docRef)
						
						DOCUMENT TO BLOB:C525(docName; $sql_blob)
						//$affected_rows:=MySQL Execute Blob ($conn_id_web;$sql_blob)
						SET BLOB SIZE:C606($sql_blob; 0)
						If ($affected_rows>0)
							$email_text:=$email_text+String:C10($affected_rows)+" rows affected. "
						Else 
							$email_text:=$email_text+"Failed to send P&G inventory.  "
						End if 
						//perform rough check to see if two phase commit is called for, if this finds errors then before marking the wms records as processed will need to backcheck
						//consolidate by pallet and create corrisponding records in web db
						ARRAY TEXT:C222($aPalletId_inserted; 0)
						ARRAY LONGINT:C221($aPalletQty_inserted; 0)
						$sql:="SELECT pallet_id, pallet_qty FROM warehouses WHERE access_filter = '00199'"  //date_sent = '"+$now+"'"
						//$row_set:=MySQL Select ($conn_id_web;$sql)
						//$rows_inserted:=MySQL Get Row Count ($row_set)
						//MySQL Column To Array ($row_set;"";1;$aPalletId_inserted)
						//MySQL Column To Array ($row_set;"";2;$aPalletQty_inserted)
						//MySQL Delete Row Set ($row_set)
						$quantity_inserted:=0
						For ($i; 1; $rows_inserted)
							$quantity_inserted:=$quantity_inserted+$aPalletQty_inserted{$i}
						End for 
						
						//$conn_id_web:=CUSTPORT_ConnectionManager ("Close")
						
						Case of 
							: ($rows_to_insert#$rows_inserted)
								utl_Logfile("cust_portal.log"; "### ERROR: "+String:C10($rows_inserted)+" records inserted, should have been "+String:C10($rows_to_insert))
								$email_text:=$email_text+"### ERROR: "+String:C10($rows_inserted)+" records inserted, should have been "+String:C10($rows_to_insert)
							: ($quantity_to_insert#$quantity_inserted)
								utl_Logfile("cust_portal.log"; "### ERROR: "+String:C10($quantity_inserted)+" cartons inserted, should have been "+String:C10($quantity_to_insert))
								$email_text:=$email_text+"### ERROR: "+String:C10($quantity_inserted)+" cartons inserted, should have been "+String:C10($quantity_to_insert)
							Else 
								utl_Logfile("cust_portal.log"; "RESULT: "+String:C10($quantity_inserted)+" cartons inserted, in "+String:C10($rows_inserted)+" rows")
								//change the temporary marker on 'warehouse' so they wont get hit next time
								//final warehouse=D, time=then()
								$sql:="UPDATE `cases` SET warehouse = '"+$EXTERNAL_WAREHOUSE+"' WHERE warehouse = '"+$TRANSMIT_DATA+"'"
								//$stmt:=MySQL New SQL Statement ($conn_id_rk;$sql)
								//$result:=MySQL Execute ($conn_id_rk;"";$stmt)
								$email_text:=$email_text+"RESULT: "+String:C10($quantity_inserted)+" cartons inserted, in "+String:C10($rows_inserted)+" rows"
						End case 
						
						//$conn_id_rk:=DB_ConnectionManager ("Close")
						
						//send packing slip
						If (Length:C16($email_text)>0)
							$distribList:="mel.bohince@arkay.com"  //Batch_GetDistributionList ("FiFo Shipping Test")  //"mel.bohince@arkay.com"  `
							EMAIL_Sender("Pallets Moved to External Warehouse"; ""; $email_text; $distribList)
						End if 
					End if   //connect to portal
				Else   //nothing to move
					//utl_Logfile ("cust_portal.log";"### WARNING: Nothing to send")  `log a warning
				End if   //row count>0
			End if   //connect to wms
		Else 
			utl_Logfile("cust_portal.log"; "### WARNING: CUSTPORT_Warehouse.sql couldn't be created.")  //log a warning`
		End if 
		
		//%%%%%%%%%%%%%%%%%%%
	: ($action="png_inventory_ams")
		C_TEXT:C284(xTitle; xText; docName)
		$timestamp:=fYYMMDD(Current date:C33; 0; "")+"_"+Replace string:C233(String:C10(Current time:C178; HH MM SS:K7:1); ":"; "")
		C_TIME:C306($docRef)
		docName:="CUSTPORT_Warehouse"+$timestamp+".sql"
		$docRef:=util_putFileName(->docName)
		If ($docRef#?00:00:00?)
			QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]CustID:16="00199"; *)
			QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]Location:2#"FG:SHIPPED")
			$rows_to_insert:=Records in selection:C76([Finished_Goods_Locations:35])
			If ($rows_to_insert>0)
				ARRAY TEXT:C222(<>aSleeves; 0)  // see Rama_Find_CPNs
				Begin SQL
					select distinct(ProductCode) from Finished_Goods_Locations where ProductCode in (SELECT ProductCode from Finished_Goods where lower(style) like '%sleeve%' and custid = '00199') and location like 'FG:AV%' order by productcode into <<[<>aSleeves]>>
				End SQL
				
				ARRAY TEXT:C222($aPostDate; 0)
				ARRAY TEXT:C222($aSentDate; 0)
				ARRAY TEXT:C222($aReceivedDate; 0)
				ARRAY TEXT:C222($aItem; 0)
				ARRAY TEXT:C222($aJobit; 0)
				ARRAY DATE:C224($aGlueDate; 0)
				ARRAY TEXT:C222($aPalletId; 0)
				ARRAY LONGINT:C221($aPalletQty; 0)
				ARRAY LONGINT:C221($aNumCases; 0)
				ARRAY TEXT:C222($aBin; 0)
				ARRAY TEXT:C222($aWhseId; 0)
				ARRAY TEXT:C222($aStatus; 0)
				ARRAY TEXT:C222($aAccessCode; 0)
				
				$now:=TS_ISO_String_TimeStamp
				$null_date:=""
				
				SELECTION TO ARRAY:C260([Finished_Goods_Locations:35]ProductCode:1; $aItem; [Finished_Goods_Locations:35]Jobit:33; $aJobit; [Finished_Goods_Locations:35]OrigDate:27; $aGlueDate; [Finished_Goods_Locations:35]skid_number:43; $aPalletId; [Finished_Goods_Locations:35]QtyOH:9; $aPalletQty; [Finished_Goods_Locations:35]Cases:24; $aNumCases; [Finished_Goods_Locations:35]Location:2; $aBin; [Finished_Goods_Locations:35]CustID:16; $aAccessCode; [Finished_Goods_Locations:35]Warehouse:36; $aWhseId; [Finished_Goods_Locations:35]wms_bin_id:44; $aStatus)
				ARRAY TEXT:C222($aPostDate; $rows_to_insert)
				ARRAY TEXT:C222($aSentDate; $rows_to_insert)
				ARRAY TEXT:C222($aReceivedDate; $rows_to_insert)
				$quantity_to_insert:=0
				uThermoInit($rows_to_insert; "Building Export...")
				For ($i; 1; $rows_to_insert)
					$quantity_to_insert:=$quantity_to_insert+$aPalletQty{$i}
					$aPostDate{$i}:=$now
					$prefix:=Substring:C12($aBin{$i}; 1; 6)
					$shipped_on:=!00-00-00!
					$pound:=Position:C15("#"; $aBin{$i})  //looking if BOL# is referenced
					If ($pound>0)
						$bol:=Num:C11(Substring:C12($aBin{$i}; ($pound+1)))
						QUERY:C277([Customers_Bills_of_Lading:49]; [Customers_Bills_of_Lading:49]ShippersNo:1=$bol)
						If (Records in selection:C76([Customers_Bills_of_Lading:49])>0)
							$bol_timestamp:=TS2iso(TSTimeStamp([Customers_Bills_of_Lading:49]ShipDate:20; ?17:00:00?))
						End if 
					End if 
					
					Case of 
						: ($prefix="FG:AV-")
							$aWhseId{$i}:="In-transit"
							$aSentDate{$i}:=$bol_timestamp
							$aReceivedDate{$i}:=$null_date
							
						: ($prefix="FG:AV=")
							$aWhseId{$i}:="Rama"
							$aSentDate{$i}:=$bol_timestamp
							$aReceivedDate{$i}:=$bol_timestamp
							
						Else 
							$aSentDate{$i}:=$null_date
							$aReceivedDate{$i}:=$null_date
					End case 
					
					$prefix:=Substring:C12($aPalletId{$i}; 1; 3)
					Case of 
						: ($prefix="000")
							$aStatus{$i}:="WIP"
							
						: ($prefix="001")
							$aStatus{$i}:="F/G"
							
						Else 
							$aStatus{$i}:="F/G"
					End case 
					
					$hit:=Find in array:C230(<>aSleeves; $aItem{$i})
					If ($hit>-1)
						$aStatus{$i}:=$aStatus{$i}+"-Sleeve"
					End if 
					$aGlueDate{$i}:=JMI_getGlueDate($aJobit{$i}; "deep")
					uThermoUpdate($i)
				End for 
				uThermoClose
				
				ARRAY TEXT:C222(<>aSleeves; 0)
				
				//send them to the web database
				//$conn_id_web:=CUSTPORT_ConnectionManager ("Open")
				If ($conn_id_web>0)
					xText:="DELETE FROM `warehouses` WHERE `access_filter` = '00199';"+Char:C90(13)
					xText:=xText+"INSERT INTO `warehouses` "
					xText:=xText+"(`access_filter`,`status`,`whse_id`, `product_code`, `jobit`, `date_glued`, `pallet_id`, `pallet_qty`, `num_cases`, `bin_id`, `date_sent`, `date_received`)"  //`date_sent`, `date_received`, `date_issued`, `release_number`
					xText:=xText+" VALUES "+Char:C90(13)
					For ($i; 1; $rows_to_insert)
						If (Length:C16(xText)>25000)
							SEND PACKET:C103($docRef; xText)
							xText:=""
						End if 
						
						xText:=xText+"('"+$aAccessCode{$i}+$t+$aStatus{$i}+$t+$aWhseId{$i}+$t+$aItem{$i}+$t+$aJobit{$i}+$t+fYYMMDD($aGlueDate{$i}; 10; "-")+$t+$aPalletId{$i}+$t+String:C10($aPalletQty{$i})+$t+String:C10($aNumCases{$i})+$t+$aBin{$i}+$t+$aSentDate{$i}+$t+$aReceivedDate{$i}+$r  //+$t+$aPostDate{$i}
						//$email_text:=$email_text+"cpn: "+$aItem{$i}+"  jobit: "+$aJobit{$i}+"  pallet: "+$aPalletId{$i}+"  from: "+$aBin{$i}+"  with: "+String($aNumCases{$i})+" cases, totalling: "+String($aPalletQty{$i})+" cartons"+Char(13)
					End for 
					$last_delimiter:=Length:C16(xText)-1
					xText[[$last_delimiter]]:=";"
					SEND PACKET:C103($docRef; xText)
					CLOSE DOCUMENT:C267($docRef)
					
					DOCUMENT TO BLOB:C525(docName; $sql_blob)
					//$affected_rows:=MySQL Execute Blob ($conn_id_web;$sql_blob)
					SET BLOB SIZE:C606($sql_blob; 0)
					If ($affected_rows>0)
						$email_text:=$email_text+String:C10($affected_rows)+" rows affected. "
					Else 
						$email_text:=$email_text+"Failed to send P&G inventory.  "
					End if 
					//perform rough check to see if two phase commit is called for, if this finds errors then before marking the wms records as processed will need to backcheck
					//consolidate by pallet and create corrisponding records in web db
					ARRAY TEXT:C222($aPalletId_inserted; 0)
					ARRAY LONGINT:C221($aPalletQty_inserted; 0)
					$sql:="SELECT pallet_id, pallet_qty FROM warehouses WHERE access_filter = '00199'"  //date_sent = '"+$now+"'"
					//$row_set:=MySQL Select ($conn_id_web;$sql)
					//$rows_inserted:=MySQL Get Row Count ($row_set)
					//MySQL Column To Array ($row_set;"";1;$aPalletId_inserted)
					//MySQL Column To Array ($row_set;"";2;$aPalletQty_inserted)
					//MySQL Delete Row Set ($row_set)
					$quantity_inserted:=0
					For ($i; 1; $rows_inserted)
						$quantity_inserted:=$quantity_inserted+$aPalletQty_inserted{$i}
					End for 
					
					//$conn_id_web:=CUSTPORT_ConnectionManager ("Close")
					
					Case of 
						: ($rows_to_insert#$rows_inserted)
							utl_Logfile("cust_portal.log"; "### ERROR: "+String:C10($rows_inserted)+" records inserted, should have been "+String:C10($rows_to_insert))
							$email_text:=$email_text+"### ERROR: "+String:C10($rows_inserted)+" records inserted, should have been "+String:C10($rows_to_insert)
						: ($quantity_to_insert#$quantity_inserted)
							utl_Logfile("cust_portal.log"; "### ERROR: "+String:C10($quantity_inserted)+" cartons inserted, should have been "+String:C10($quantity_to_insert))
							$email_text:=$email_text+"### ERROR: "+String:C10($quantity_inserted)+" cartons inserted, should have been "+String:C10($quantity_to_insert)
						Else 
							utl_Logfile("cust_portal.log"; "RESULT: "+String:C10($quantity_inserted)+" cartons inserted, in "+String:C10($rows_inserted)+" rows")
							$email_text:=$email_text+"RESULT: "+String:C10($quantity_inserted)+" cartons inserted, in "+String:C10($rows_inserted)+" rows"
					End case 
					
					//$conn_id_rk:=DB_ConnectionManager ("Close")
					
					//send packing slip
					If (Length:C16($email_text)>0)
						$distribList:="mel.bohince@arkay.com"  //Batch_GetDistributionList ("FiFo Shipping Test")  //"mel.bohince@arkay.com"  `
						EMAIL_Sender("Inventory Posted on CustPort"; ""; $email_text; $distribList)
					End if 
				End if   //connect to portal
			End if   //doc created
		End if   //nothing to send
		
	Else 
		ALERT:C41($action+" is not an option for CUSTPORT_WMS.")
End case 
BEEP:C151