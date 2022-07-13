//%attributes = {}
// _______
// Method: BOL_PrintDraft   ( ) ->
// By: Mel Bohince @ 10/30/19, 15:42:39
// Description
// print a  BOL w/o invoicing, releaving inventory, or setting the release;s  actual
// see original at BOL_PrintBillOfLading
// ----------------------------------------------------
// Modified by: Garri Ogata (6/9/21) added $bContinue

C_BOOLEAN:C305($bContinue)

//do the ARDEN_PROJECT flip-flop if necessary
If ([Customers_Bills_of_Lading:49]ShipTo:3="02177") | ([Customers_Bills_of_Lading:49]ShipTo:3="02678") | ([Customers_Bills_of_Lading:49]ShipTo:3="02742")
	[Customers_Bills_of_Lading:49]BillTo_BOL:25:="02742"
End if 


//now print the bol
util_PAGE_SETUP(->[Customers_Bills_of_Lading:49]; "LaserOutput_text_block")
PDF_setUp("bol-"+String:C10([Customers_Bills_of_Lading:49]ShippersNo:1)+".pdf"; False:C215)

C_TEXT:C284(sAddress)  //this is the shipped from text

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

C_BOOLEAN:C305(ARDEN_PROJECT)  //change the soldTo to a billTo and reduce by $15/M
ARDEN_PROJECT:=False:C215
iCCopt1:="BILL TO"

If ([Customers_Bills_of_Lading:49]ShipTo:3="02177") | ([Customers_Bills_of_Lading:49]ShipTo:3="02678") | ([Customers_Bills_of_Lading:49]ShipTo:3="02742") | ([Customers_Bills_of_Lading:49]CustID:2="00074")
	ARDEN_PROJECT:=True:C214
End if 

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
End if 

$backTag:="</page>"

C_LONGINT:C283($copy)
For ($copy; 1; numCopies)
	If ([Customers_Bills_of_Lading:49]Num_of_Pages:19=0)
		Print form:C5([Customers_Bills_of_Lading:49]; "LaserOutput_text_block"; Form header:K43:3)
		xText:="empty manifest"
		Print form:C5([Customers_Bills_of_Lading:49]; "LaserOutput_text_block"; Form detail:K43:1)
		iPage:=0
		Print form:C5([Customers_Bills_of_Lading:49]; "LaserOutput_text_block"; Form footer:K43:2)
		
	Else 
		$allText:=[Customers_Bills_of_Lading:49]PrintedText:28
		For ($i; 1; [Customers_Bills_of_Lading:49]Num_of_Pages:19)
			Print form:C5([Customers_Bills_of_Lading:49]; "LaserOutput_text_block"; Form header:K43:3)
			
			$frontTag:="<page id="+String:C10($i)+">"
			$start:=Position:C15($frontTag; $allText)+Length:C16($frontTag)+1
			$end:=Position:C15($backTag; $allText)-1
			
			xText:=Substring:C12($allText; $start; $end-$start)
			Print form:C5([Customers_Bills_of_Lading:49]; "LaserOutput_text_block"; Form detail:K43:1)
			
			iPage:=$i
			Print form:C5([Customers_Bills_of_Lading:49]; "LaserOutput_text_block"; Form footer:K43:2)
			
			$allText:=Substring:C12($allText; $end+7)
		End for   //page
	End if   //no pages
End for   //numCopies


If (ARDEN_PROJECT)  //need another copy with special wording
	iCCopt1:="SOLD TO"
	$allText:=[Customers_Bills_of_Lading:49]PrintedText:28
	For ($i; 1; [Customers_Bills_of_Lading:49]Num_of_Pages:19)
		Print form:C5([Customers_Bills_of_Lading:49]; "Arden_Packing_Slip"; Form header:K43:3)
		
		$frontTag:="<page id="+String:C10($i)+">"
		
		$start:=Position:C15($frontTag; $allText)+Length:C16($frontTag)+1
		$end:=Position:C15($backTag; $allText)-1
		
		xText:=Substring:C12($allText; $start; $end-$start)
		Print form:C5([Customers_Bills_of_Lading:49]; "Arden_Packing_Slip"; Form detail:K43:1)
		
		iPage:=$i
		Print form:C5([Customers_Bills_of_Lading:49]; "Arden_Packing_Slip"; Form footer:K43:2)
		
		$allText:=Substring:C12($allText; $end+7)
	End for   //page
	
End if   //arden

If ([Customers_Bills_of_Lading:49]International:10)
	$bContinue:=FG_ShipPrintInternationInvoice
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
	Print form:C5([Customers_Bills_of_Lading:49]; "SLI"; Form detail:K43:1)
End if 
PDF_setUp


If ([Customers_Bills_of_Lading:49]Num_of_Pages:19>0)
	[Customers_Bills_of_Lading:49]WasPrinted:8:=True:C214
	SAVE RECORD:C53([Customers_Bills_of_Lading:49])  // this will stage inventory but not execute the BOL at this point
End if 

BOL_setControls

