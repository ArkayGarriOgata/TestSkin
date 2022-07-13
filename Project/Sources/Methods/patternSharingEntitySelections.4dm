//%attributes = {}
// _______
// Method: patternSharingEntitySelections   ( ) ->
// By: Mel Bohince @ 12/04/20, 21:14:56
// Description
// v17 entity selctions can not be passed to other processes,
// these are some workarounds
//for instance you want to execute on the server some work on a clients es
// ----------------------------------------------------

C_OBJECT:C1216($es_before; $es_after)

If (False:C215)  //first show doing it by switch to classic mode
	//convert entitySelection to collection
	
	C_COLLECTION:C1488($clients_c; $server_c)  //collections used to pass the ent sel to/from the exec on server method
	$clients_c:=New collection:C1472
	
	REDUCE SELECTION:C351([Customers:16]; 0)
	
	$es_before:=ds:C1482.Customers.query("Active = :1"; True:C214)
	
	USE ENTITY SELECTION:C1513($es_before)  //switch to classic to pass an array
	ARRAY LONGINT:C221($_records; 0)  //reuse this array
	LONGINT ARRAY FROM SELECTION:C647([Customers:16]; $_records)
	ARRAY TO COLLECTION:C1563($clients_c; $_records)
	
	$server_c:=New collection:C1472
	$server_c:=$clients_c  //simulate ex on server function
	
	//convert collection back to entitySelection
	REDUCE SELECTION:C351([Customers:16]; 0)  //reset this example
	
	ARRAY LONGINT:C221($_records; 0)
	COLLECTION TO ARRAY:C1562($server_c; $_records)
	CREATE SELECTION FROM ARRAY:C640([Customers:16]; $_records)
	
	$es_after:=Create entity selection:C1512([Customers:16])
	
Else   //now do it with obj commands
	
	$es_before:=ds:C1482.Customers.query("Active = :1"; True:C214)  //this is the es that we want to send as an argument to the server
	$es_after:=ds:C1482.Customers.newSelection()  //simulate the return from the server function
	
	C_COLLECTION:C1488($clients_c; $server_c)  //collections used to pass the ent sel to/from the exec on server method
	$clients_c:=New collection:C1472
	$clients_c:=$es_before.toCollection("ID"; dk with primary key:K85:6)  // this collection can now be passed as an argument to a method
	
	//this is the simulatioin of a server function returning a collection made from an es
	$server_c:=$clients_c  //simulate server returning a collection
	
	//now reconstitute the es from the servers returned collection
	$es_after:=ds:C1482.Customers.fromCollection($server_c)
End if 

