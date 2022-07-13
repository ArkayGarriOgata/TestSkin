//%attributes = {}
// -------
// Method: EDI_Invoice810   ( ) ->
// By: Mel Bohince @ 08/10/17, 15:29:59
// Description
// based on EDI_Acknowledge997
// for invoicing P&G

// ----------------------------------------------------
// Modified by: Mel Bohince (8/28/17) make group and st trans number 6 digits, verbose invoice numbers on outbox record
// Modified by: Mel Bohince (11/5/17) remove "BOL" from CAD segment
// Modified by: Mel Bohince (1/9/18) "text to blob" was Mac text w/o lenght, truncated to 32k
// Modified by: Mel Bohince (4/6/20) Make Buyer BY the same NAD as the Billto, grab PO line number for IT1 segment
// Modified by: Mel Bohince (7/15/20) flag if the order is from before july
// Modified by: Mel Bohince (9/28/20) remove hardcoded acctid from the GS segment
// Modified by: Garri Ogata (4/5/21) Changed Remit to address
// Modified by: Garri Ogata (4/6/21) Changed count to add line for LOCKEDBOX being added in
// Modified by: Mel Bohince (6/28/21) flag if the order is from before july 2021

//build an invoice message, sample:  

//ISA*00*          *00*          *ZZ*VENDOR         *ZZ*PGEDITEST      *170720*1301*U*00401*000000060*0*T*>~
//GS*IN*VENDOR*PGEDITEST*20170720*1301*1*X*004010~
//ST*810*001
//BIG*20150101*12345**N6P5500001027***PR
//CUR*BY*USD
//N1*RE*Arkay Packing Corporation*92*20544146
//N3*100 Marcus Blvd Suite 2
//N4*Hauppauge*NY*11788*US
//N1*BY*THE PROCTER & GAMBLE COMPANY*92*1
//N3*1 PROCTER & GAMBLE PLAZA
//N4*CINCINNATI*OH*45202*US
//N1*ST*P & G Dist-West Branch
//N3*602 Fawcett Drive
//N4*West Branch*IA*52358*US
//N1*BT*THE PROCTER & GAMBLE COMPANY*92*1
//N3*1 PROCTER & GAMBLE PLAZA
//N4*CINCINNATI*OH*45202*US
//ITD************Payment Terms: 35 Days
//FOB*CC
//IT1**60*EA*10**A8*10*IN*45623156
//PAM****1*600
//PID*F****PRODUCT DESCRIPTION
//TDS*63812
//TXI*TX*30
//CAD*****UPS GROUND**BM*{BOL}1234
//SAC*C*D240***812**********FREIGHT
//CTT*1
//SE*1*123456
//GE*1*32!
//IEA*1*000000060!

//*997 Acknoledgement
//*   Public Interface


C_LONGINT:C283($0; $params; edi_num_trans; edi_num_segments; $dot; $num)
C_TEXT:C284($1; edi_ack_to; edi_msg; edi_closing; edi_segDelim; edi_eleDelim; $sp; edi_icn; edi_grpNum)
C_TEXT:C284($acctID; edi_mode; $currentSDate; $currentLDate; $currentTime; $remitTo; $buyer; $shipto; $billto; $invoiceDate; $invoiceNumber; $poNumber; $relNumber; $invoiceType; $unitPrice; $invoiceTotal; $poPrefix)

C_LONGINT:C283($0; $params)
$0:=0  // return success
$params:=Count parameters:C259

Case of 
	: ($params=0)
		uConfirm("EDI_Invoice810 usage error, parameters are required."; "OK"; "Help")
		$0:=-30000
		
	: ($1="New")  //*      New 810, get counters set up
		$currentSDate:=Substring:C12(fYYMMDD(Current date:C33; 4); 3)
		$currentLDate:=fYYMMDD(Current date:C33; 4)
		$currentTime:=Replace string:C233(String:C10(Current time:C178; HH MM:K7:2); ":"; "")
		$sp:=Char:C90(32)  //space character
		
		edi_ack_to:="PnG"  //txt_Trim ($2)
		
		$acctID:=EDI_AccountInfo("init")
		$acctID:=EDI_AccountInfo("getAcctID"; edi_ack_to)
		If (Position:C15("TEST"; $acctID)>0)
			edi_mode:="T"
		Else 
			edi_mode:="P"
		End if 
		
		If (Length:C16($acctID)<9)  //pad so ISA's length is preserved
			$acctID:=$acctID+(" "*(9-Length:C16($acctID)))
		End if 
		edi_ack_segDelim:=Char:C90(Num:C11(EDI_AccountInfo("getSegDelim"; $acctID)))  //"~"  //+char(13)
		edi_eleDelim:=Char:C90(Num:C11(EDI_AccountInfo("getEleDelim"; $acctID)))  //"*"
		
		edi_icn:=String:C10(EDI_GetNextIDfromPreferences(edi_ack_to+"_ICN"); "000000000")
		edi_grpNum:=String:C10(EDI_GetNextIDfromPreferences(edi_ack_to+"_GROUP"); "000000")
		//edi_msg:="ISA*00*          *00*          *01*001635622      *ZZ*PGEDITEST      *"+$currentSDate+"*"+$currentTime+"*U*00401*"+edi_icn+"*0*T*>"+edi_ack_segDelim  This contains weird white space characters!!
		edi_msg:="ISA*00*"+($sp*10)+"*00*"+($sp*10)+"*01*001635622"+($sp*6)+"*ZZ*"+$acctID+($sp*6)+"*"+$currentSDate+"*"+$currentTime+"*U*00401*"+edi_icn+"*0*"+edi_mode+"*>"+edi_ack_segDelim
		
		edi_msg:=edi_msg+"GS*IN*001635622*"+Replace string:C233($acctID; " "; "")+"*"+$currentLDate+"*"+$currentTime+"*"+edi_grpNum+"*X*004010"+edi_ack_segDelim
		
		edi_closing:="GE*###*"+edi_grpNum+edi_ack_segDelim
		edi_closing:=edi_closing+"IEA*1*"+edi_icn+edi_ack_segDelim
		
		edi_num_trans:=0
		edi_invoices_sent:=""
		
		$0:=0
		
	: ($1="add-invoice")
		edi_num_trans:=edi_num_trans+1
		$transNumber:=String:C10(EDI_GetNextIDfromPreferences(edi_ack_to+"_TRANS"); "000000")
		edi_num_segments:=0
		edi_msg:=edi_msg+"ST*810*"+$transNumber+edi_ack_segDelim
		edi_num_segments:=edi_num_segments+1
		
		$remitTo:=""  //this is our name acct and address
		$remitTo:=$remitTo+"N1*RE*Arkay Packing Corporation*92*20544146"+edi_ack_segDelim
		$remitTo:=$remitTo+"N2*LOCKBOX #8322"+edi_ack_segDelim  // Added by: Garri Ogata (4/5/21) 
		$remitTo:=$remitTo+"N3*PO BOX 788322"+edi_ack_segDelim
		$remitTo:=$remitTo+"N4*PHILADELPHIA*PA*19178-8322*US"+edi_ack_segDelim  //19182-7080
		
		// Modified by: Mel Bohince (7/15/20) flag if the order is from before july
		$oldContractFlag:=""
		C_OBJECT:C1216($orderline_es)
		$orderline_es:=ds:C1482.Customers_Order_Lines.query("OrderLine = :1"; [Customers_Invoices:88]OrderLine:4)
		If ($orderline_es.length>0)
			
			If ($orderline_es[0].DateOpened<!2020-07-01!)  // Modified by: Mel Bohince (6/28/21)
				$oldContractFlag:="[PreJuly20]"
			End if 
			
			If ($orderline_es[0].DateOpened<!2021-07-01!)  // Modified by: Mel Bohince (6/28/21) 
				$oldContractFlag:="[PreJuly]"
			End if 
			
		End if 
		
		// Modified by: Mel Bohince (4/6/20) use Billto address for buyer segments, note use of LauderID for P&G Legal entity number
		$buyer:="N1*BY*"+ADDR_getName([Customers_Invoices:88]BillTo:10)+"*92*"+[Addresses:30]Lauder_ID:41+edi_ack_segDelim  //loads the address record
		$buyer:=$buyer+"N3*"+[Addresses:30]Address1:3+edi_ack_segDelim
		If (Length:C16([Addresses:30]Address2:4)>0)
			$buyer:=$buyer+"N3*"+[Addresses:30]Address2:4+edi_ack_segDelim
			edi_num_segments:=edi_num_segments+1
		End if 
		$buyer:=$buyer+"N4*"+[Addresses:30]City:6+"*"+[Addresses:30]State:7+"*"+[Addresses:30]Zip:8+"*US"+edi_ack_segDelim
		
		
		$invoiceDate:=fYYMMDD([Customers_Invoices:88]Invoice_Date:7; 4)
		$invoiceNumber:=String:C10([Customers_Invoices:88]InvoiceNumber:1)
		edi_invoices_sent:=edi_invoices_sent+$invoiceNumber+" "
		$poNumber:=Replace string:C233([Customers_Invoices:88]CustomersPO:11; "/"; "")
		$poNumber:=Replace string:C233($poNumber; "-"; "")
		
		If (edi_mode="T")
			$poPrefix:=Substring:C12($poNumber; 1; 3)
			Case of 
				: ($poPrefix="N6P")
					$poNumber:=Replace string:C233($poNumber; "N6P"; "N6A")
					
				: ($poPrefix="G4P")
					$poNumber:=Replace string:C233($poNumber; "G4P"; "G4A")
					
			End case 
		End if   //in test mode
		
		$dot:=Position:C15("."; $poNumber)
		If ($dot>1)
			$relNumber:=Substring:C12($poNumber; ($dot+1))
			$poNumber:=Substring:C12($poNumber; 1; ($dot-1))
			$dot:=Position:C15("."; $relNumber)  // Modified by: Mel Bohince (4/6/20) get the middle segment which is said to be the line number to go into IT1
			$lineNumber:=Substring:C12($relNumber; 1; ($dot-1))
		Else 
			$relNumber:=""
			$lineNumber:=""
		End if 
		
		If ([Customers_Invoices:88]InvType:13="Debit")
			$invoiceType:="PR"
		Else 
			$invoiceType:="CR"  //??? or CN
		End if 
		edi_msg:=edi_msg+"BIG*"+$invoiceDate+"*"+$invoiceNumber+"**"+$poNumber+"*"+$relNumber+"**"+$invoiceType+edi_ack_segDelim
		edi_msg:=edi_msg+"CUR*BY*USD"+edi_ack_segDelim
		edi_num_segments:=edi_num_segments+2
		
		edi_msg:=edi_msg+$remitTo
		edi_msg:=edi_msg+$buyer
		//edi_num_segments:=edi_num_segments+6
		edi_num_segments:=edi_num_segments+7  // Modified by: Garri Ogata (4/6/21) added LOCKBOX
		
		$shipto:="N1*ST*"+ADDR_getName([Customers_Invoices:88]ShipTo:9)+edi_ack_segDelim  //loads the address record
		$shipto:=$shipto+"N3*"+[Addresses:30]Address1:3+edi_ack_segDelim
		If (Length:C16([Addresses:30]Address2:4)>0)
			$shipto:=$shipto+"N3*"+[Addresses:30]Address2:4+edi_ack_segDelim
			edi_num_segments:=edi_num_segments+1
		End if 
		$shipto:=$shipto+"N4*"+[Addresses:30]City:6+"*"+[Addresses:30]State:7+"*"+[Addresses:30]Zip:8+"*US"+edi_ack_segDelim
		edi_msg:=edi_msg+$shipto
		edi_num_segments:=edi_num_segments+3
		// Modified by: Mel Bohince (4/6/20) add legal entity # (lauder id field) to hte billto
		$billto:="N1*BT*"+ADDR_getName([Customers_Invoices:88]BillTo:10)+"*92*"+[Addresses:30]Lauder_ID:41+edi_ack_segDelim  //loads the address record
		$billto:=$billto+"N3*"+[Addresses:30]Address1:3+edi_ack_segDelim
		If (Length:C16([Addresses:30]Address2:4)>0)
			$billto:=$billto+"N3*"+[Addresses:30]Address2:4+edi_ack_segDelim
			edi_num_segments:=edi_num_segments+1
		End if 
		$billto:=$billto+"N4*"+[Addresses:30]City:6+"*"+[Addresses:30]State:7+"*"+[Addresses:30]Zip:8+"*US"+edi_ack_segDelim
		edi_msg:=edi_msg+$billto
		edi_num_segments:=edi_num_segments+3
		
		edi_msg:=edi_msg+"ITD************Payment Terms: "+[Customers_Invoices:88]Terms:18+edi_ack_segDelim
		READ ONLY:C145([Customers_Bills_of_Lading:49])
		QUERY:C277([Customers_Bills_of_Lading:49]; [Customers_Bills_of_Lading:49]ShippersNo:1=[Customers_Invoices:88]BillOfLadingNumber:3)
		edi_msg:=edi_msg+"FOB*"+[Customers_Bills_of_Lading:49]FOB:15+edi_ack_segDelim
		If ([Customers_Invoices:88]PricingUOM:17="M")
			$unitPrice:=String:C10(Abs:C99([Customers_Invoices:88]PricePerUnit:16)/1000)
		Else 
			$unitPrice:=String:C10(Abs:C99([Customers_Invoices:88]PricePerUnit:16))
		End if 
		edi_msg:=edi_msg+"IT1**"+String:C10([Customers_Invoices:88]Quantity:15)+"*EA*"+$unitPrice+"**A8*"+$lineNumber+"*IN*"+[Customers_Invoices:88]ProductCode:14+edi_ack_segDelim  // Modified by: Mel Bohince (4/6/20) replace literal 10 with $lineNumber
		edi_msg:=edi_msg+"PAM****1*"+String:C10(Abs:C99([Customers_Invoices:88]ExtendedPrice:19); "########0.00")+edi_ack_segDelim
		$num:=qryFinishedGood([Customers_Invoices:88]CustomerID:6; [Customers_Invoices:88]ProductCode:14)
		edi_msg:=edi_msg+"PID*F****"+[Finished_Goods:26]CartonDesc:3+edi_ack_segDelim
		$invoiceTotal:=Replace string:C233(String:C10([Customers_Invoices:88]ExtendedPrice:19; "########0.00"); "."; "")
		edi_msg:=edi_msg+"TDS*"+$invoiceTotal+edi_ack_segDelim
		//edi_msg:=edi_msg+"TXI*TX*0"+edi_ack_segDelim  // ???
		edi_msg:=edi_msg+"CAD*****"+[Customers_Bills_of_Lading:49]Carrier:9+"**BM*"+String:C10([Customers_Bills_of_Lading:49]ShippersNo:1)+$oldContractFlag+edi_ack_segDelim
		//edi_msg:=edi_msg+"SAC*C*D240***0**********FREIGHT"+edi_ack_segDelim  // ???
		
		edi_msg:=edi_msg+"CTT*1"+edi_ack_segDelim
		edi_num_segments:=edi_num_segments+8
		
		edi_num_segments:=edi_num_segments+1
		edi_msg:=edi_msg+"SE*"+String:C10(edi_num_segments)+"*"+$transNumber+edi_ack_segDelim
		
		$0:=Num:C11($transNumber)  // Modified by: Mel Bohince (10/16/17) so there xref between invoice and edi msg on 997 ackn
		
	: ($1="Send")  //*      Send
		utl_Trace
		edi_closing:=Replace string:C233(edi_closing; "###"; String:C10(edi_num_trans))
		edi_msg:=edi_msg+edi_closing
		
		CREATE RECORD:C68([edi_Outbox:155])
		[edi_Outbox:155]ID:1:=Sequence number:C244([edi_Outbox:155])
		[edi_Outbox:155]Path:2:="810_PG_"+edi_icn+".temp"
		[edi_Outbox:155]ContentText:10:=edi_msg
		SET BLOB SIZE:C606([edi_Outbox:155]Content:3; 0)
		TEXT TO BLOB:C554(edi_msg; [edi_Outbox:155]Content:3; UTF8 text without length:K22:17)  // Modified by: Mel Bohince (1/9/18) was Mac text w/o lenght, truncated to 32k
		[edi_Outbox:155]SentTimeStamp:4:=0
		[edi_Outbox:155]Subject:5:="810_PG_"+edi_icn  // Modified by: Mel Bohince (8/24/17) remove space as this becomes filename sor sending
		[edi_Outbox:155]CrossReference:6:=edi_grpNum
		[edi_Outbox:155]Com_AccountName:7:=$1
		[edi_Outbox:155]PO_Number:8:=String:C10(edi_num_trans)+" invoices: "+edi_invoices_sent
		SAVE RECORD:C53([edi_Outbox:155])
		REDUCE SELECTION:C351([edi_Outbox:155]; 0)
		$0:=0
		
	Else 
		uConfirm("Case of:'"+$1+"' not understood."; "OK"; "Help")
		$0:=-30001
End case 