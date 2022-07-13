//%attributes = {}
//  // Method: av_accounts_receivable_v2
//  // ----------------------------------------------------
//  // User name (OS): Mel Bohince
//  // Date and time: 07/29/13, 16:45:34
//  // ----------------------------------------------------
//  // Description
//  // AccountVantage update to 4d v12 so external sql database call is possible
//  //  based on av_accounts_receivable
//  // ----------------------------------------------------
//  // User name (OS): mel
//  // Date and time: 06/25/09, 14:09:25
//  // Modified by: Mel Bohince (8/2/13) can be more than one DocRef record found per invoice number
//  // ----------------------------------------------------
//  // Method: av_accounts_receivable
//  // Description
//  // communicate with AccountVantage thru proxied mysql table
//  // based on Invoice_CheckIfPaid and Invoice_Acctvantage
//  // Parameters
//  // ----------------------------------------------------

//  //NOTHING PAID, make aging
//  //where `Doc Amnt Due` = `Document Amount`

//  //EVERYTHING PAID
//  //where `Doc Amnt Due` = 0

//  // Modified by: Mel Bohince (9/27/16) use file import
//  // Modified by: Mel Bohince (9/28/16) include Credit memos so they clear

//$useAccountVantageSQL:=False  // Modified by: Mel Bohince (9/27/16) use file import

//C_LONGINT($i;$numRecs;av_error;$ar_rec)
//C_REAL($paid_amt)
//C_TEXT($1)

//If (Count parameters>0)  //test
//ON ERR CALL("av_error_occurred")
//SQL LOGIN("IP:"+<>AcctVantageIP;"Laura Gader";"apple123";*)
//$numRecs:=1000
//READ ONLY([Addresses])

//ALERT("Go check the SQL page on the AV server. Then click Ok.")

//SQL LOGOUT

//Else 
//av_error:=0
//READ WRITE([Customers_Invoices])
//  //Find what is still outstanding
//QUERY([Customers_Invoices];[Customers_Invoices]Status="Posted";*)  //first time
//QUERY([Customers_Invoices]; | ;[Customers_Invoices]Status="Posted?";*)  //already reviewed
//QUERY([Customers_Invoices]; | ;[Customers_Invoices]Status="Aging";*)  //already reviewed
//QUERY([Customers_Invoices]; | ;[Customers_Invoices]Status="Paid*")  //partials
//  // Modified by: Mel Bohince (9/28/16) include Credit memos so they clear
//  //QUERY([Customers_Invoices]; & ;[Customers_Invoices]ExtendedPrice<0)  //don't look at credits

//$numRecs:=Records in selection([Customers_Invoices])
//If ($numRecs>0)  //insert them into the mysql database

//utl_Logfile ("AR.Log";"Server: "+<>AcctVantageIP+" Checking "+String($numRecs)+" invoices")
//  //connect
//If ($useAccountVantageSQL)
//ON ERR CALL("av_error_occurred")
//  //SQL LOGIN("IP:192.168.1.173";"Laura Gader";"apple123";*)
//SQL LOGIN("IP:"+<>AcctVantageIP;"Laura Gader";"apple123";*)

//Else   //loffer to do an import
//CONFIRM("Import text file to ARDocuments table?";"Import";"Skip")
//If (ok=1)
//av_Load_ARDocuments_from_file 
//End if 
//ok:=1
//End if 

//If (OK=1)
//uThermoInit ($numRecs;"Updating Invoices...")
//For ($i;1;$numRecs)
//If (av_error#0)  //break
//$i:=$i+$numRecs
//End if 
//$invoice_number:=String([Customers_Invoices]InvoiceNumber)

//  //reset
//ARRAY TEXT($aDocRef;0)
//ARRAY REAL($aDocAmt;0)
//ARRAY REAL($aDocDue;0)

//Begin SQL
//select `DocumentReference`, `Document Amount`, `Doc Amnt Due`
//from ARDocument 
//where `DocumentReference` = :[$invoice_number]
//into :$aDocRef, :$aDocAmt, :$aDocDue;
//End SQL


//If (Size of array($aDocRef)>0)  //found it
//  // Modified by: Mel Bohince (8/2/13) can be more than one DocRef record found per invoice number
//  //$paid_amt:=$aDocAmt{1}-$aDocDue{1}

//$paid_amt:=0  // could be more than 1 found
//For ($ar_rec;1;Size of array($aDocRef))
//$paid_amt:=$paid_amt+($aDocAmt{$ar_rec}-$aDocDue{$ar_rec})
//End for 

//If ($paid_amt#[Customers_Invoices]AmountPaid)  // looks like it changed
//[Customers_Invoices]AmountPaid:=$paid_amt
//[Customers_Invoices]DatePaidSet:=4D_Current_date 

//Case of 
//: ($paid_amt=0)
//[Customers_Invoices]Status:="Aging"

//: ($paid_amt=[Customers_Invoices]ExtendedPrice)
//[Customers_Invoices]Status:="Paid"

//: ($paid_amt>[Customers_Invoices]ExtendedPrice)
//[Customers_Invoices]Status:="Paid+"

//: (($paid_amt+20)>=[Customers_Invoices]ExtendedPrice)  //close enuf, a little slack
//[Customers_Invoices]Status:="Paid"

//: ($paid_amt<[Customers_Invoices]ExtendedPrice)  // partial
//[Customers_Invoices]Status:="Paid*"

//Else   //what else could it be now
//utl_Logfile ("AR.Log";"  Invoice "+$invoice_number+"'s status could not be set.")
//End case 

//SAVE RECORD([Customers_Invoices])
//End if 

//Else 
//  //BEEP
//utl_Logfile ("AR.Log";"  Invoice "+$invoice_number+" was not found in AccountVantage.")
//If (Position("?";[Customers_Invoices]Status)=0)
//[Customers_Invoices]Status:=[Customers_Invoices]Status+"?"
//SAVE RECORD([Customers_Invoices])
//End if 
//End if 

//NEXT RECORD([Customers_Invoices])
//uThermoUpdate ($i)
//End for   //each row
//uThermoClose 

//If ($useAccountVantageSQL)
//SQL LOGOUT
//ON ERR CALL("")
//End if 


//utl_Logfile ("AR.Log";"   Done")

//Else 
//utl_Logfile ("AR.Log";"  Connection to Accountvantage FAILED")
//End if 


//Else 
//utl_Logfile ("AR.Log";"Checking 0 invoices")
//utl_Logfile ("AR.Log";"   Done")
//End if 
//End if   // params
