//%attributes = {}
// ----------------------------------------------------
// User name (OS): mel
// Date and time: 05/08/07, 16:32:14
// ----------------------------------------------------
// Method: BOL_PrintBillOfLading
// Description
// output to laser, invoice, relieve inventory, update release and orders
// ----------------------------------------------------
// Modified by: Mel Bohince (5/25/16) yet another stupid request
// Modified by: Mel Bohince (11/12/19) merge some stuff from BOL_PrintDraft
// Modified by: Garri Ogata (5/25/21) only print new CA (Canada)
// Modified by: Garri Ogata (6/07/21) if custom prints do not print SLI
// Modified by: Garri Ogata (1/11/22) Assinged $nPixelsUsed:=Print Form commands and removed help tips in form LaserOutput_text_block

C_LONGINT:C283($nPixelsUsed)  //

error:=0
//ON ERR CALL("eServerErrorCall")  //use the same one that is active on the server
[Customers_Bills_of_Lading:49]CanBill:35:=True:C214  // Modified by: Mel Bohince (11/12/19) merge some stuff from BOL_PrintDraft
SAVE RECORD:C53([Customers_Bills_of_Lading:49])  //save any addition to the bol to this point before transaction begins 
//utl_Logfile ("debug.log";"  Save 1: BOL# "+String([Customers_Bills_of_Lading]ShippersNo))

If (error=0)
	START TRANSACTION:C239
	[Customers_Bills_of_Lading:49]WasBilled:29:=True:C214
	[Customers_Bills_of_Lading:49]WasPrinted:8:=True:C214
	//do the ARDEN_PROJECT flip-flop
	If ([Customers_Bills_of_Lading:49]ShipTo:3="02177") | ([Customers_Bills_of_Lading:49]ShipTo:3="02678") | ([Customers_Bills_of_Lading:49]ShipTo:3="02742")
		[Customers_Bills_of_Lading:49]BillTo_BOL:25:="02742"
	End if 
	
	SAVE RECORD:C53([Customers_Bills_of_Lading:49])  //run the trigger to execute the bol
	If (TriggerMessage_NoErrors)  //validate the transaction and print the bol
		utl_Logfile("debug.log"; "  Validate Transaction")
		VALIDATE TRANSACTION:C240
		
		//now print the bol
		util_PAGE_SETUP(->[Customers_Bills_of_Lading:49]; "LaserOutput_text_block")
		PDF_setUp("bol-"+String:C10([Customers_Bills_of_Lading:49]ShippersNo:1)+".pdf"; False:C215)
		
		C_LONGINT:C283($copy)
		
		C_TEXT:C284(sAddress)  // Modified by: Mel Bohince (11/12/19) merge some stuff from BOL_PrintDraft
		Case of   //ship-from
			: ([Customers_Bills_of_Lading:49]ShippedFrom:5="PLANT")
				sAddress:="350 East Park Drive\rRoanoke, VA  24019"
				
			: ([Customers_Bills_of_Lading:49]ShippedFrom:5="NY")
				sAddress:="22 Arkay Drive\rHauppauge, NY  11788"
				
			: ([Customers_Bills_of_Lading:49]ShippedFrom:5="O/S")  //O/S
				sAddress:=Request:C163("Please enter ship-from address:"; "Outside Service"; "Ok"; "Default")
				If (ok=0)  //default
					sAddress:="Outside Service"
				End if 
				
			Else   //normal warehouse
				sAddress:="872 Lee Highway\rRoanoke, VA  24019"  // Modified by: Mel Bohince (3/16/18) 
		End case 
		
		C_BOOLEAN:C305(RAMA_PROJECT; ARDEN_PROJECT)  //change the soldTo to a billTo and reduce by $15/M
		RAMA_PROJECT:=False:C215
		ARDEN_PROJECT:=False:C215
		iCCopt1:="BILL TO:"
		
		RAMA_PROJECT:=CUST_isRamaProject([Customers_Bills_of_Lading:49]BillTo:4; [Customers_Bills_of_Lading:49]ShipTo:3)
		//If ([Customers_Bills_of_Lading]BillTo="02568") & (([Customers_Bills_of_Lading]ShipTo="02563") | ([Customers_Bills_of_Lading]ShipTo="01666"))
		If (RAMA_PROJECT)
			utl_Logfile("debug.log"; "  Rama Pjt")
			
			iCCopt1:="SOLD TO"
		End if 
		
		If ([Customers_Bills_of_Lading:49]ShipTo:3="02177") | ([Customers_Bills_of_Lading:49]ShipTo:3="02678") | ([Customers_Bills_of_Lading:49]ShipTo:3="02742") | ([Customers_Bills_of_Lading:49]CustID:2="00074")
			ARDEN_PROJECT:=True:C214
			utl_Logfile("debug.log"; "  Arden Pjt")
			//iCCopt1:="SOLD  TO" // only on packing slip
		End if 
		
		$holdAddress:=tText12
		If (Length:C16([Customers_Bills_of_Lading:49]BillTo_BOL:25)=5)
			tText12:=fGetAddressText([Customers_Bills_of_Lading:49]BillTo_BOL:25; "*")
		End if 
		
		If (ELC_isEsteeLauderCompany([Customers_Bills_of_Lading:49]CustID:2))  // Modified by: Mel Bohince (5/25/16) yet another stupid request
			sCountry:=ADDR_getCountry([Customers_Bills_of_Lading:49]ShipTo:3)
			If ((sCountry="") | (sCountry="USA") | (sCountry="U.S.A.") | (sCountry="US"))
				If (Position:C15("Bill Freight To"; [Customers_Bills_of_Lading:49]Notes:7)=0)
					[Customers_Bills_of_Lading:49]Notes:7:="Bill Freight To: Estee Lauder c/o Technical Traffic 30 Hemlock Dr Congers NY 10920"
				End if 
			End if 
			
			iCCopt1:="BILL FINISHED GOODS TO:"  // Modified by: MelvinBohince (4/29/22) 
			
		End if 
		
		$backTag:="</page>"
		
		For ($copy; 1; numCopies)
			$allText:=[Customers_Bills_of_Lading:49]PrintedText:28
			For ($i; 1; [Customers_Bills_of_Lading:49]Num_of_Pages:19)
				$nPixelsUsed:=Print form:C5([Customers_Bills_of_Lading:49]; "LaserOutput_text_block"; Form header:K43:3)
				
				$frontTag:="<page id="+String:C10($i)+">"
				utl_Logfile("debug.log"; "  "+$frontTag)
				$start:=Position:C15($frontTag; $allText)+Length:C16($frontTag)+1
				$end:=Position:C15($backTag; $allText)-1
				
				xText:=Substring:C12($allText; $start; $end-$start)
				$nPixelsUsed:=Print form:C5([Customers_Bills_of_Lading:49]; "LaserOutput_text_block"; Form detail:K43:1)
				
				iPage:=$i
				$nPixelsUsed:=Print form:C5([Customers_Bills_of_Lading:49]; "LaserOutput_text_block"; Form footer:K43:2)
				
				$allText:=Substring:C12($allText; $end+7)
			End for   //page
		End for   //numCopies
		utl_Logfile("debug.log"; "  BOL Printed")
		
		If (ARDEN_PROJECT)
			utl_Logfile("debug.log"; "  Arden Pjt2")
			
			tText12:=$holdAddress
			iCCopt1:="SOLD TO"
			$allText:=[Customers_Bills_of_Lading:49]PrintedText:28
			For ($i; 1; [Customers_Bills_of_Lading:49]Num_of_Pages:19)
				$nPixelsUsed:=Print form:C5([Customers_Bills_of_Lading:49]; "Arden_Packing_Slip"; Form header:K43:3)
				
				$frontTag:="<page id="+String:C10($i)+">"
				
				$start:=Position:C15($frontTag; $allText)+Length:C16($frontTag)+1
				$end:=Position:C15($backTag; $allText)-1
				
				xText:=Substring:C12($allText; $start; $end-$start)
				$nPixelsUsed:=Print form:C5([Customers_Bills_of_Lading:49]; "Arden_Packing_Slip"; Form detail:K43:1)
				
				iPage:=$i
				$nPixelsUsed:=Print form:C5([Customers_Bills_of_Lading:49]; "Arden_Packing_Slip"; Form footer:K43:2)
				
				$allText:=Substring:C12($allText; $end+7)
			End for   //page
		End if   //arden
		
		Case of   //International
				
			: (Not:C34([Customers_Bills_of_Lading:49]International:10))  //Not International
				
			: (FG_ShipPrintInternationInvoice)  //Print Line Item Invoice(s)
				
			: (Ship_Invc_ForeignB([Customers_Bills_of_Lading:49]ShipTo:3))  //Printed Custom
				
			Else   //Standard Shippers Letter of Instruction
				
				// Modified by: Mel Bohince (11/12/19) merge some stuff from BOL_PrintDraft--SLI
				//set up wgt and mode for SLI
				sKilograms:=String:C10(Round:C94([Customers_Bills_of_Lading:49]Total_Wgt:18*0.453592; 0))
				bAir:=""
				bOcean:=""
				bRoad:=""
				Case of 
					: ([Customers_Bills_of_Lading:49]Mode:36="Ocean")
						bOcean:="X"
					: ([Customers_Bills_of_Lading:49]Mode:36="Air")
						bAir:="X"
					Else 
						bRoad:="X"
				End case 
				
				<>EMAIL_POP3_USERNAME:=Choose:C955(Current user:C182#"Designer"; Current user:C182; "Mel Bohince")
				<>EMAIL_FROM:=Replace string:C233(<>EMAIL_POP3_USERNAME; " "; ".")+"@arkay.com"
				
				PDF_setUp("bolSLI-"+String:C10([Customers_Bills_of_Lading:49]ShippersNo:1)+".pdf"; False:C215)
				$nPixelsUsed:=Print form:C5([Customers_Bills_of_Lading:49]; "SLI"; Form detail:K43:1)
				
		End case   //Done international 
		
		PDF_setUp
		tText12:=$holdAddress
		
	Else   //something happened in trigger hell
		utl_Logfile("debug.log"; "  Cancel Transaction")
		$msg:=TriggerMessage("get-message")
		CANCEL TRANSACTION:C241
		LOAD RECORD:C52([Customers_Bills_of_Lading:49])  //reload the servers version of the record
		
		uConfirm($msg; "Try Later"; "Help")
		
	End if 
	//$empty:=TriggerMessage ("tear-down")
End if 
LOAD RECORD:C52([Customers_Bills_of_Lading:49])  //reload the servers version of the record

BOL_setControls
