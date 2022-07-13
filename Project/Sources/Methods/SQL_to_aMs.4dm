//%attributes = {}
// Method: SQL_to_aMs   ( ) ->
// By: Mel Bohince @ 03/22/20, 18:01:34
// Description
// remote connect template to ams server for doing sql query
// MAKE SURE AMS SERVER HAS THE SQL SERVER RUNNING, NOT CURRENTLY THE DEFAULT
// ----------------------------------------------------]
//sample call:
//C_OBJECT($connection;$result)
//$connection:=New object("ams_user";"VirtualFactory";"ams_pwd";"1147")
//$result:=SQL_to_aMs($connection)

C_TEXT:C284($holdCurrentErrorMethod; currentMethod; $user; $pwd)
C_OBJECT:C1216($1; $0; $result)
$result:=New object:C1471

If (Count parameters:C259=0)  //test
	$user:="VirtualFactory"
	$pwd:="1147"
Else 
	$user:=$1.ams_user
	$pwd:=$1.ams_pwd
End if 

$holdCurrentErrorMethod:=Method called on error:C704
ON ERR CALL:C155("e_SQL_error")  //will set ok:=0 if called

SQL LOGIN:C817("IP:192.168.1.62:19812"; $user; $pwd; *)

If (ok=1)  //logged in, run query
	
	$result.success:=True:C214
	
	//#################
	//example query:
	//#################
	
	ARRAY TEXT:C222($custid; 0)
	ARRAY REAL:C219($rev; 0)
	ARRAY REAL:C219($cost; 0)
	ARRAY REAL:C219($qty; 0)
	
	Begin SQL
		SELECT  CustID, sum(Price_Extended), sum(Cost_Extended), sum(Quantity)
		from Customers_Order_Lines
		where DateOpened >= '01/01/2020' and
		UPPER(Status) not in('CANCEL', 'CANCELLED', 'KILL', 'NEW', 'CONTRACT', 'OPENED', 'CREDIT HOLD', 'HOLD', 'REJECTED')
		group by CustID
		into  :$custid, :$rev, :$cost, :$qty
	End SQL
	
	$result.num_recs:=Size of array:C274($custid)
	///////////
	//End example query
	
	SQL LOGOUT:C872
	
Else 
	
	$result.success:=False:C215
	
	If (Count parameters:C259=0)
		ALERT:C41("aMs Login failed.")
	End if 
	
End if   //logged in

ON ERR CALL:C155($holdCurrentErrorMethod)

$0:=$result

