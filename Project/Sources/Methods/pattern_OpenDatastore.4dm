//%attributes = {}
// _______
// Method: pattern_OpenDatastore   ( ) ->
// By: MelvinBohince @ 04/01/22, 14:36:38
// Description
// test connections to aMs
// ----------------------------------------------------

C_OBJECT:C1216($hostName_o; $r_ds)
//$hostName_o:=New object("hostname";"192.168.3.11:8088")
$hostName_o:=New object:C1471("hostname"; "192.168.1.136:8080")
$remoteId:="myAMS"

ON ERR CALL:C155("e_file_io_error")

$r_ds:=Open datastore:C1452($hostName_o; $remoteId)
If ($r_ds#Null:C1517)
	
	C_OBJECT:C1216($customers_es)
	//$customers_es:=$r_ds.Customers.query("Active = True").orderBy("Name")
	
	C_COLLECTION:C1488($customers_c)
	$customers_c:=$r_ds.Customers.query("Active = True").orderBy("Name").toCollection("Name").extract("Name")
	
End if 
ON ERR CALL:C155("")