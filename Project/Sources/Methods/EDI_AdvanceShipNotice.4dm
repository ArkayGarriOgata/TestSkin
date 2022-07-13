//%attributes = {}
// ----------------------------------------------------
// User name (OS): mel
// Date and time: 09/10/08, 09:56:56
// Modified by: mel (6/14/10) allow for custom search
// Modified by: Mel Bohince (12/12/12) allow for shipment by air after uti notification
// ----------------------------------------------------
// Method: EDI_AdvanceShipNotice
// Description
// send an asn to the edi outbox for any releases shipping today to a shipto that requests asn's ([Addresses]edi_Send_ASN)
// run without param if custom search is needed
// Modified by: Mel Bohince (10/1/14) so doesn't send without intervention
// Modified by: Mel Bohince (10/2/14) get fancy if not domestic
// Modified by: Mel Bohince (11/13/14) delay domestic asn's for a day.
// Modified by: Mel Bohince (12/5/14) everything to delay 1 day, add a week to airship
// Modified by: Mel Bohince (2/19/15) don't flip 32 to 0 on the weekend
// Modified by: Mel Bohince (11/9/17) stop setting to 32
// Modified by: Mel Bohince (11/12/19) 3 param means search by BOL#, also now return number sent
C_DATE:C307($1; $ship_date)
C_LONGINT:C283($hit; $shipto; $numberOfShipments; $shipment; $2; $3; $0)
C_TEXT:C284($segDelimitor; $test_indicator)
C_TEXT:C284($message)
C_LONGINT:C283($segment_counter; $message_counter)
ARRAY TEXT:C222($aSTourCode; 0)
ARRAY TEXT:C222($aSTtheirCode; 0)
ARRAY TEXT:C222($aSTtheirCtry; 0)  // Modified by: Mel Bohince (10/2/14) 
$numberOfShipments:=0
$segDelimitor:="'"  //+Char(13)

QUERY:C277([Addresses:30]; [Addresses:30]edi_Send_ASN:42=True:C214)
SELECTION TO ARRAY:C260([Addresses:30]ID:1; $aSTourCode; [Addresses:30]Lauder_ID:41; $aSTtheirCode; [Addresses:30]Country:9; $aSTtheirCtry)
For ($i; 1; Size of array:C274($aSTourCode))
	$aSTtheirCode{$i}:=Substring:C12($aSTtheirCode{$i}; 1; 4)
End for 

Case of 
	: (Count parameters:C259=1)  //assume running from batch
		READ WRITE:C146([edi_Outbox:155])  // Modified by: Mel Bohince (11/13/14) delay domestic asn's for a day.
		$weekday:=Day number:C114(Current date:C33)
		If ($weekday>1) & ($weekday<7)  // Modified by: Mel Bohince (2/19/15) don't do this o the weekend
			QUERY:C277([edi_Outbox:155]; [edi_Outbox:155]SentTimeStamp:4=32)
			If (Records in selection:C76([edi_Outbox:155])>0)
				APPLY TO SELECTION:C70([edi_Outbox:155]; [edi_Outbox:155]SentTimeStamp:4:=0)
			End if 
			REDUCE SELECTION:C351([edi_Outbox:155]; 0)
		End if 
		
		$ship_date:=$1
		QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]Shipto:10=$aSTourCode{1}; *)
		For ($shipto; 2; Size of array:C274($aSTourCode))
			QUERY:C277([Customers_ReleaseSchedules:46];  | ; [Customers_ReleaseSchedules:46]Shipto:10=$aSTourCode{$shipto}; *)
		End for 
		QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]Actual_Date:7=$ship_date; *)
		QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]Actual_Qty:8>0; *)
		QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]B_O_L_number:17>0)
		
	: (Count parameters:C259=2)  // from release input form
		ONE RECORD SELECT:C189([Customers_ReleaseSchedules:46])
		If (Records in selection:C76([Customers_ReleaseSchedules:46])=0)
			QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]ReleaseNumber:1=$2)
		End if 
		
	: (Count parameters:C259=3)  // from release input form
		$bol_number:=$3
		QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]Shipto:10=$aSTourCode{1}; *)
		For ($shipto; 2; Size of array:C274($aSTourCode))
			QUERY:C277([Customers_ReleaseSchedules:46];  | ; [Customers_ReleaseSchedules:46]Shipto:10=$aSTourCode{$shipto}; *)
		End for 
		QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]Actual_Qty:8>0; *)
		QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]B_O_L_number:17=$bol_number)
		
		
	Else 
		QUERY:C277([Customers_ReleaseSchedules:46])  //normally by actual ship date
		// Modified by: Mel Bohince (10/9/15) only make them for the appropriate addressess
		QUERY SELECTION:C341([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]Shipto:10=$aSTourCode{1}; *)
		For ($shipto; 2; Size of array:C274($aSTourCode))
			QUERY SELECTION:C341([Customers_ReleaseSchedules:46];  | ; [Customers_ReleaseSchedules:46]Shipto:10=$aSTourCode{$shipto}; *)
		End for 
		QUERY SELECTION:C341([Customers_ReleaseSchedules:46])
End case 

$numberOfShipments:=Records in selection:C76([Customers_ReleaseSchedules:46])
If ($numberOfShipments>0)
	$senders_id:="6315311578"
	$errText:=EDI_AccountInfo("init")
	$test_indicator:=EDI_AccountInfo("getACK"; $senders_id)
	$segDelimitor:=Char:C90(Num:C11(EDI_AccountInfo("getSegDelim"; $senders_id)))  //"'"  `+Char(13)
	$partner:=EDI_AccountInfo("getAcctName"; $senders_id)
	
	//since header section include the EL po then these need to be sent out 1:1 per release 
	ORDER BY:C49([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]B_O_L_number:17; >)
	
	For ($shipment; 1; $numberOfShipments)  //1)  `
		//no longer saving a document
		docName:="DESADV_"+fYYMMDD(Current date:C33)+"_"+Replace string:C233(String:C10(Current time:C178; HH MM SS:K7:1); ":"; "")+".edi"
		
		//start a new message
		$tActualICN:=String:C10(EDI_GetNextIDfromPreferences("ICN_"+$senders_id); "0000000")
		$lUniqueMessageID:=String:C10(EDI_GetNextIDfromPreferences("TXN_"+$senders_id))
		
		$message:=""  // like Msg_RespondSAP ("+";":";$segDelimitor;"ICN_NUMBER") then  `$message:=Replace string($message;"ORDRSP";"DESADV")
		//$message:="UNA:+.? "+$segDelimitor`know clue why I know about this tag
		$message:=$message+"UNB+UNOA:2+001635622:01:001635622+6315311578:12:6315311578+"
		$message:=$message+fYYMMDD(Current date:C33)+":"+Replace string:C233(String:C10(Current time:C178; <>HHMM); ":"; "")
		$message:=$message+"+"+$tActualICN+"++DESADV+A"+$test_indicator+$segDelimitor  //unique sequence number  +0+
		
		$message:=$message+"UNH+"+$lUniqueMessageID+"+DESADV:D:96A:UN:EDIFCT"+$segDelimitor
		$message_counter:=0
		$message_counter:=$message_counter+1  //there will be only one due to po ref in header
		$segment_counter:=0
		$message:=$message+"BGM+351+"+String:C10([Customers_ReleaseSchedules:46]ReleaseNumber:1)+"+9"+$segDelimitor
		
		If (Not:C34([Customers_ReleaseSchedules:46]Air_Shipment:51))  // Modified by: Mel Bohince (12/12/12)
			$lead_time:=ADDR_getLeadTime([Customers_ReleaseSchedules:46]Shipto:10)
		Else   // Modified by: Mel Bohince (11/24/15) back to 2 weeks not 3 for customs
			$lead_time:=14  // Modified by: Mel Bohince (12/12/12) hardcode per Lisa, ` Modified by: Mel Bohince (12/5/14) added another week for customs
		End if 
		// Modified by: Mel Bohince (10/2/14) 
		If ([Customers_ReleaseSchedules:46]user_date_3:55=!00-00-00!)  //original code
			$message:=$message+"DTM+17:"+fYYMMDD(([Customers_ReleaseSchedules:46]Actual_Date:7+$lead_time); 4)+":102"+$segDelimitor
		Else   //specified, like from UTI and entered by C/S; ` Modified by: Mel Bohince (12/5/14) no longer used but option remains
			$message:=$message+"DTM+17:"+fYYMMDD(([Customers_ReleaseSchedules:46]user_date_3:55); 4)+":102"+$segDelimitor
		End if 
		$dot:=Position:C15("."; [Customers_ReleaseSchedules:46]CustomerRefer:3)
		$po_num:=Substring:C12([Customers_ReleaseSchedules:46]CustomerRefer:3; 1; ($dot-1))
		$po_num:=Replace string:C233($po_num; "WR"; "WP")  //this is obsolete
		$lineNumber:=String:C10(Num:C11(Substring:C12([Customers_ReleaseSchedules:46]CustomerRefer:3; $dot+1)))
		$lineNumber:=Replace string:C233($lineNumber; ".001"; "")  //` Modified by: mel (1/12/10) strip off the trailing 001
		$message:=$message+"RFF+ON:"+$po_num+$segDelimitor  //PO #
		$message:=$message+"RFF+BM:"+String:C10([Customers_ReleaseSchedules:46]B_O_L_number:17)+$segDelimitor  //BOL #
		//Figure out shipto info, stub for now
		$shipToNumber:=""
		$shipToName:=""
		$shipToStreet:=""
		$shipToCity:=""
		$shipToCountry:=""
		$shipToPostalCode:=""
		$shipToName:=ADDR_getName([Customers_ReleaseSchedules:46]Shipto:10)
		$hit:=Find in array:C230($aSTourCode; [Customers_ReleaseSchedules:46]Shipto:10)
		If ($hit>-1)
			$shipToNumber:=$aSTtheirCode{$hit}
		Else 
			$shipToNumber:="rk"+[Customers_ReleaseSchedules:46]Shipto:10
		End if 
		
		//parse out the shipto
		READ ONLY:C145([Customers_Orders:40])
		QUERY:C277([Customers_Orders:40]; [Customers_Orders:40]OrderNumber:1=[Customers_ReleaseSchedules:46]OrderNumber:2)
		$edi_shipto:=[Customers_Orders:40]edi_ShipTo_text:61
		If (Length:C16($edi_shipto)>0)
			$hit:=Position:C15(":"; $edi_shipto)
			$shipToNumber:=Substring:C12($edi_shipto; 1; ($hit-1))
			$hit:=Position:C15("+"; $edi_shipto)
			$edi_shipto:=Substring:C12($edi_shipto; ($hit+1))
			$hit:=Position:C15(":"; $edi_shipto)
			$shipToName:=Substring:C12($edi_shipto; 1; ($hit-1))
		End if 
		$message:=$message+"NAD+DP+"+$shipToNumber+"++"+$shipToName+":"+$shipToStreet+":"+$shipToCity+"++"+$shipToCountry+"++"+$shipToPostalCode+$segDelimitor  //Ship to location
		$message:=$message+"UNS+D"+$segDelimitor
		
		$segment_counter:=7
		
		$message:=$message+"GIN+BJ+00208082920000000000"+$segDelimitor  //sscc# [n/a]
		
		$message:=$message+"LIN+1++"+Replace string:C233([Customers_ReleaseSchedules:46]ProductCode:11; "-"; "")+":IN+:"+$lineNumber+$segDelimitor  //Part No.
		$message:=$message+"QTY+12:"+String:C10([Customers_ReleaseSchedules:46]Actual_Qty:8)+":PCE"+$segDelimitor  //Quantity
		$segment_counter:=$segment_counter+3
		
		$message:=$message+"UNS+S"+$segDelimitor
		$segment_counter:=$segment_counter+2  //also including next
		
		$message:=$message+"UNT+"+String:C10($segment_counter)+"+"+$lUniqueMessageID+$segDelimitor  //need the number of segments in message
		$message:=$message+"UNZ+"+String:C10($message_counter)+"+"+$tActualICN+$segDelimitor  //need the number of messages in interchange
		
		C_BLOB:C604($blobOrdRspl)
		SET BLOB SIZE:C606($blobOrdRspl; 0)
		
		TEXT TO BLOB:C554($message; $blobOrdRspl; UTF8 text without length:K22:17; *)  // Modified by: Mel Bohince (1/9/18) was: Mac text without length
		CREATE RECORD:C68([edi_Outbox:155])
		[edi_Outbox:155]ID:1:=Sequence number:C244([edi_Outbox:155])
		[edi_Outbox:155]Path:2:=docName
		SET BLOB SIZE:C606([edi_Outbox:155]Content:3; 0)
		[edi_Outbox:155]Com_AccountName:7:=$senders_id
		// Modified by: Mel Bohince (10/2/14) send if domestic, hold unless EDA has been specified
		$hit:=Find in array:C230($aSTourCode; [Customers_ReleaseSchedules:46]Shipto:10)
		If ($hit>-1)  // Modified by: Mel Bohince (12/5/14) everything to be delayed 1 day
			[edi_Outbox:155]SentTimeStamp:4:=0  // Modified by: Mel Bohince (11/9/17) 
			
			//If ($aSTtheirCtry{$hit}="USA") | ($aSTtheirCtry{$hit}="Canada")  //original code
			//[edi_Outbox]SentTimeStamp:=32  //0` Modified by: Mel Bohince (11/13/14) delay domestic asn's for a day.
			//Else 
			//If ([Customers_ReleaseSchedules]EstimatedDateOfArrival#!00/00/0000!)
			//[edi_Outbox]SentTimeStamp:=32  //0` Modified by: Mel Bohince (12/5/14)
			//Else 
			//[edi_Outbox]SentTimeStamp:=32  //Day of(Current date)  // Modified by: Mel Bohince (10/1/14) so doesn't send without intervention` Modified by: Mel Bohince (12/5/14)
			//End if 
			//End if 
			
		Else   //should never happen
			[edi_Outbox:155]SentTimeStamp:4:=Day of:C23(Current date:C33)
		End if 
		
		[edi_Outbox:155]Subject:5:="DESADV_"+$tActualICN
		[edi_Outbox:155]PO_Number:8:=[Customers_ReleaseSchedules:46]CustomerRefer:3
		[edi_Outbox:155]OrderID:9:=[Customers_ReleaseSchedules:46]OrderLine:4+"/BOL:"+String:C10([Customers_ReleaseSchedules:46]B_O_L_number:17)
		[edi_Outbox:155]Content:3:=$blobOrdRspl
		//$more:=Size of array($aOrdRsp)-1
		[edi_Outbox:155]ContentText:10:=$message
		READ ONLY:C145([Customers_Order_Lines:41])
		QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]OrderLine:3=[Customers_ReleaseSchedules:46]OrderLine:4)
		[edi_Outbox:155]CrossReference:6:=[Customers_Order_Lines:41]edi_ICN:67
		
		zwStatusMsg("DESADV"; "PREPARED RELEASE "+String:C10([Customers_ReleaseSchedules:46]ReleaseNumber:1))
		If (Not:C34(<>modification4D_25_03_19))  // BEGIN 4D Professional Services : UNLOAD RECORD
			
			UNLOAD RECORD:C212([Customers_ReleaseSchedules:46])
			
		Else 
			
			// you have NEXT RECORD  on line 223
			
		End if   // END 4D Professional Services : January 2019 
		
		SAVE RECORD:C53([edi_Outbox:155])
		REDUCE SELECTION:C351([edi_Outbox:155]; 0)
		
		xTitle:=""
		xText:=""
		$message:=""
		
		DELAY PROCESS:C323(Current process:C322; 10)  //so doc names don't collide
		
		NEXT RECORD:C51([Customers_ReleaseSchedules:46])
	End for 
	zwStatusMsg("DESADV"; "DONE ")
	BEEP:C151
	
Else 
	BEEP:C151
	BEEP:C151
End if   //have shipments on that date

$0:=$numberOfShipments