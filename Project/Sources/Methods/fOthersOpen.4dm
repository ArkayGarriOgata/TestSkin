//%attributes = {"publishedWeb":true}
//fOthersOpen->boolean
//check to see if other change orders are pending against
//an order before setting order status back to 'accepted'
//• 7/10/97 cs found that if a CCo is entered AND accepted in the same session
//  this routine returns a false positive pending CCOs
//added 3rd parameter -record number of initiating record, test for finding itself
// • mel (11/4/04, 10:42:43) refactor using new qry features

C_BOOLEAN:C305($0)
C_LONGINT:C283($order; $1; $Found)
C_TEXT:C284($2; $status)
C_TEXT:C284($cco; $3)
$order:=$1
$status:=$2
$cco:=$3

SET QUERY LIMIT:C395(1)
SET QUERY DESTINATION:C396(Into variable:K19:4; $Found)
QUERY:C277([Customers_Order_Change_Orders:34]; [Customers_Order_Change_Orders:34]OrderNo:5=$order; *)
QUERY:C277([Customers_Order_Change_Orders:34];  & ; [Customers_Order_Change_Orders:34]ChangeOrderNumb:1#$cco; *)
QUERY:C277([Customers_Order_Change_Orders:34];  & ; [Customers_Order_Change_Orders:34]ChgOrderStatus:20=$status)
SET QUERY DESTINATION:C396(Into current selection:K19:1)
SET QUERY LIMIT:C395(0)

$0:=($Found>0)

//PUSH RECORD([OrderChgHistory])
//
//QUERY([OrderChgHistory];[OrderChgHistory]OrderNo=$order;*)
//QUERY([OrderChgHistory]; & ;[OrderChgHistory]ChgOrderStatus=$status)
//
//  `• 7/10/97 cs start
//$Found:=Records in selection([OrderChgHistory])
//
//Case of 
//: ($Found=1)  `there was one record found pending √ whether this is the record we started on
//
//If (Count parameters=3)  `record number passed in
//
//If (Record number([OrderChgHistory])=$3)
//$0:=False  `the record found is the one we are sitting on to start with        
//Else   `we found a different record 
//$0:=True
//End if 
//Else   `no record number to check against, what we found must be concidered true
//$0:=True
//End if 
//
//: ($Found>0)  `there were 2 or more found pending(1 is caught above)
//$0:=True
//Else   `none were found, nothing pending
//$0:=False
//End case 
//  `• 7/10/97 cs end
//
//POP RECORD([OrderChgHistory])
//ONE RECORD SELECT([OrderChgHistory])
//