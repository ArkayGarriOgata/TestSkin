//%attributes = {}
// ///
// /// OBSOLETE, NEVER IMPLEMENTED
// ///

// Method: Invoice_sendToEsteeLauder -> 

// ----------------------------------------------------

// by: mel: 02/18/04, 16:51:16

// ----------------------------------------------------

// Description:

// get a group of invoices, make a flat file and ftp to Lauder

//The vendor number you should use is: 001012000

//FTP SERVER      ext1.estee.com

//Username        VeNd1012000

//Password        D!eN#101


// Updates:


// ----------------------------------------------------

MESSAGES OFF:C175

C_TEXT:C284(xTitle; xText; docName)
xTitle:=""
xText:=""
C_TEXT:C284($vendorNum)
$vendorNum:="001012000"
C_TEXT:C284($t; $cr)
$t:=","
$cr:=Char:C90(13)+Char:C90(10)
C_LONGINT:C283($timeStamp; $i; $numRecs)
$timeStamp:=TSTimeStamp
C_TIME:C306($docRef)
C_BOOLEAN:C305($break)
$break:=False:C215
$implementationDate:=!2019-01-02!

If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 ELC_query
	
	$numRecs:=ELC_query(->[Customers_Invoices:88]CustomerID:6)  //get elc's fr
	
	READ WRITE:C146([Customers_Invoices:88])
	QUERY SELECTION:C341([Customers_Invoices:88]; [Customers_Invoices:88]EDI_Prep:33=0; *)
	QUERY SELECTION:C341([Customers_Invoices:88];  & ; [Customers_Invoices:88]Invoice_Date:7>$implementationDate; *)  //!02/25/04!;*)
	
	QUERY SELECTION:C341([Customers_Invoices:88];  & ; [Customers_Invoices:88]ExtendedPrice:19>0; *)
	QUERY SELECTION:C341([Customers_Invoices:88];  & ; [Customers_Invoices:88]Status:22="Posted")
	$numRecs:=Records in selection:C76([Customers_Invoices:88])
	
Else 
	
	READ WRITE:C146([Customers_Invoices:88])
	$criteria:=ELC_getName
	QUERY:C277([Customers_Invoices:88]; [Customers:16]ParentCorp:19=$criteria; *)
	QUERY:C277([Customers_Invoices:88]; [Customers_Invoices:88]EDI_Prep:33=0; *)
	QUERY:C277([Customers_Invoices:88];  & ; [Customers_Invoices:88]Invoice_Date:7>$implementationDate; *)  //!02/25/04!;*)
	QUERY:C277([Customers_Invoices:88];  & ; [Customers_Invoices:88]ExtendedPrice:19>0; *)
	QUERY:C277([Customers_Invoices:88];  & ; [Customers_Invoices:88]Status:22="Posted")
	$numRecs:=Records in selection:C76([Customers_Invoices:88])
	
End if   // END 4D Professional Services : January 2019 ELC_query

If ($numRecs>0)
	
	
	docName:="ARKAY_INVOICES."+String:C10($timeStamp)
	$docRef:=util_putFileName(->docName)
	If ($docRef#?00:00:00?)
		If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 First record
			
			READ WRITE:C146([Customers_Invoices:88])
			FIRST RECORD:C50([Customers_Invoices:88])
			
		Else 
			
			READ WRITE:C146([Customers_Invoices:88])
			// see line 68
		End if   // END 4D Professional Services : January 2019 First record
		// 4D Professional Services : after Order by , query or any query type you don't need First record  
		
		uThermoInit($numRecs; "Exporting Records")
		For ($i; 1; $numRecs)
			If ($break)
				$i:=$i+$numRecs
			End if 
			
			If (Not:C34(Locked:C147([Customers_Invoices:88])))  //else get it tomorrow
				
				If (Length:C16(xText)>20000)
					SEND PACKET:C103($docRef; xText)
					xText:=""
				End if 
				
				xText:=xText+$vendorNum+$t+[Customers_Invoices:88]CustomersPO:11+$t+String:C10([Customers_Invoices:88]InvoiceNumber:1)+$t+String:C10(Month of:C24([Customers_Invoices:88]Invoice_Date:7); "00")+String:C10(Day of:C23([Customers_Invoices:88]Invoice_Date:7); "00")+String:C10(Year of:C25([Customers_Invoices:88]Invoice_Date:7); "0000")+$t+Replace string:C233([Customers_Invoices:88]ProductCode:14; "-"; "")+$t+String:C10([Customers_Invoices:88]Quantity:15)+$cr
				[Customers_Invoices:88]EDI_Prep:33:=$timeStamp
				SAVE RECORD:C53([Customers_Invoices:88])
			End if 
			
			NEXT RECORD:C51([Customers_Invoices:88])
			uThermoUpdate($i)
		End for 
		uThermoClose
		REDUCE SELECTION:C351([Customers_Invoices:88]; 0)
		SEND PACKET:C103($docRef; xText)
		CLOSE DOCUMENT:C267($docRef)
		
		//set up for ftp
		
		$err:=ftp_EsteeLauder(docName)
		If ($err=0)
			MOVE DOCUMENT:C540(docName; (docName+".ok"))
		End if 
		
	End if 
End if   //some records


