//%attributes = {}
//  // ----------------------------------------------------
//  // User name (OS): mel
//  // Date and time: 06/25/09, 14:09:25
//  // ----------------------------------------------------
//  // Method: av_accounts_receivable
//  // Description
//  // communicate with AccountVantage thru proxied mysql table
//  // based on Invoice_CheckIfPaid and Invoice_Acctvantage
//  // ----------------------------------------------------

//C_LONGINT($result;$i;$numRecs;$conn_id;$rowset;$rowCount;$insert_stmt;$invoice_number)
//C_TEXT($1;$status)
//C_TEXT($sql)

//If (Not(<>MySQL_Registered))
//$error:=MySQL Register ("AJAUOAJ15D58M5DG")
//If ($error=0)
//ALERT("MyConnect Registration Failed.")
//Else 
//<>MySQL_Registered:=True
//End if 
//$wasSet:=MySQL Set Error Handler ("DB_Error")
//End if 

//Case of 
//: ($1="request")
//$winRef:=Open window(480;100;880;200;Plain no zoom box window;"aMs to AcctVantage Adaptor Log")
//MESSAGE(Char(13)+String(4d_Current_time)+" "+"Query for aging Invoices")
//QUERY([Customers_Invoices];[Customers_Invoices]Status="Posted";*)  //first time
//QUERY([Customers_Invoices]; | ;[Customers_Invoices]Status="Posted?";*)  //already reviewed
//QUERY([Customers_Invoices]; | ;[Customers_Invoices]Status="Aging";*)  //already reviewed
//QUERY([Customers_Invoices]; | ;[Customers_Invoices]Status="Paid*";*)  //partials
//QUERY([Customers_Invoices]; & ;[Customers_Invoices]ExtendedPrice>0)  //don't look at credits

//$numRecs:=Records in selection([Customers_Invoices])
//If ($numRecs>0)  //insert them into the mysql database
//SELECTION TO ARRAY([Customers_Invoices]InvoiceNumber;$aInvoiceNumber)
//  //connect
//MESSAGE(Char(13)+String(4d_Current_time)+" "+"Connecting MySQL on localhost")
//$conn_id:=MySQL Connect ("127.0.0.1";"root";"root";"accounts_receivable";3306)  //DB_ConnectionManager ("Open")
//If ($conn_id>0)
//  //wait for ready signal
//MESSAGE(Char(13)+String(4d_Current_time)+" "+"Waiting for signal")
//Repeat 
//$rowset:=MySQL Select ($conn_id;"select status_flag from semaphore where id = 'av'")
//$rowCount:=MySQL Get Row Count ($rowset)
//If ($rowCount=1)
//$status:=MySQL Get String Column ($rowset;"status_flag")
//MySQL Delete Row Set ($rowset)
//Else   //create the record
//$status:="WAIT"
//$sql:="insert into semaphore (id, status_flag) values ( ?, ?)"
//$insert_stmt:=MySQL New SQL Statement ($conn_id;$sql)
//MySQL Set String In SQL ($insert_stmt;1;"av")
//MySQL Set String In SQL ($insert_stmt;2;$status)
//$result:=MySQL Execute ($conn_id;"";$insert_stmt)
//End if 
//DELAY PROCESS(Current process;120)
//Until ($status="WAIT")

//  //delete existing invoices
//$sql:="delete from invoices where true"
//MESSAGE(Char(13)+String(4d_Current_time)+" "+$sql)
//  //$delStmt:=MySQL New SQL Statement ($conn_id;$delete)
//$result:=MySQL Execute ($conn_id;$sql)

//  //prepare stmt
//$sql:="insert into invoices (`invoice_number`) values ( ?)"
//MESSAGE(Char(13)+String(4d_Current_time)+" "+$sql)
//$insert_stmt:=MySQL New SQL Statement ($conn_id;$sql)

//  //loop array
//$result:=MySQL Execute ($conn_id;"BEGIN")
//For ($i;1;Size of array($aInvoiceNumber))
//MySQL Set Longint In SQL ($insert_stmt;1;$aInvoiceNumber{$i})
//$result:=MySQL Execute ($conn_id;"";$insert_stmt)
//End for 

//$result:=MySQL Execute ($conn_id;"COMMIT")
//  //delete stmt
//MySQL Delete SQL Statement ($insert_stmt)

//  //set the get signal
//$result:=MySQL Execute ($conn_id;"update semaphore set status_flag = 'GET'")
//MESSAGE(Char(13)+String(4d_Current_time)+" "+"setting GET flag, waiting for READY")
//  //wait for ready signal
//Repeat 
//DELAY PROCESS(Current process;120)

//$rowset:=MySQL Select ($conn_id;"select status_flag from semaphore where id = 'av'")
//$status:=MySQL Get String Column ($rowset;"status_flag")
//MySQL Delete Row Set ($rowset)
//Until ($status="READY")

//MESSAGE(Char(13)+String(4d_Current_time)+" "+"Applying payments")
//$rowset:=MySQL Select ($conn_id;"select invoice_number, amt_due, amt_paid from invoices where true")
//$rowCount:=MySQL Get Row Count ($rowset)
//If ($rowCount>0)
//For ($i;1;$rowCount)
//$invoice_number:=MySQL Get Longint Column ($rowset;"invoice_number")
//$due_amt:=MySQL Get Real Column ($rowset;"amt_due")
//$paid_amt:=MySQL Get Real Column ($rowset;"amt_paid")
//  //update invoices
//QUERY([Customers_Invoices];[Customers_Invoices]InvoiceNumber=$invoice_number)
//If (Records in selection([Customers_Invoices])=1)
//[Customers_Invoices]AmountPaid:=$paid_amt
//Case of 
//: ([Customers_Invoices]ExtendedPrice<0)  //invoice not found, note that search excluded credits
//[Customers_Invoices]Status:="Posted?"
//: ($due_amt<0)  //amount due equals 0
//[Customers_Invoices]Status:="Paid+"
//[Customers_Invoices]DatePaidSet:=4D_Current_date
//: ($due_amt<20)  //amount due equals 0
//[Customers_Invoices]Status:="Paid"
//[Customers_Invoices]DatePaidSet:=4D_Current_date
//: ($due_amt>=[Customers_Invoices]ExtendedPrice)  //never paid
//[Customers_Invoices]Status:="Aging"
//: ($due_amt<[Customers_Invoices]ExtendedPrice)  //parial
//[Customers_Invoices]Status:="Paid*"
//End case 

//If (Modified record([Customers_Invoices]))
//SAVE RECORD([Customers_Invoices])
//End if 
//End if 

//$result:=MySQL Next Row ($rowset)
//End for   //each row
//End if   //row count
//MySQL Delete Row Set ($rowset)

//  //set the wait signal
//MESSAGE(Char(13)+String(4d_Current_time)+" "+"setting WAIT flag")
//$result:=MySQL Execute ($conn_id;"update semaphore set status_flag = 'WAIT'")

//  //close connection
//MySQL Close ($conn_id)  //$conn_id:=DB_ConnectionManager ("Close")
//CLOSE WINDOW($winRef)
//End if   //connected
//End if   //invoices to check
//End case 