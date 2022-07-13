//%attributes = {}
// Method: rfc_New () -> 
// ----------------------------------------------------
// by: mel: 02/25/04, 17:33:10
// ----------------------------------------------------
// Modified by: Mel Bohince (5/13/14)


C_TEXT:C284($fileNum; $0)
C_TEXT:C284($1; $request)
C_LONGINT:C283($numChrgs)

$0:="*** Canceled ***"
$request:=$1
$pjtId:=$2
$today:=4D_Current_date

If ([Customers_Projects:9]id:1#$pjtId)
	QUERY:C277([Customers_Projects:9]; [Customers_Projects:9]id:1=$pjtId)
End if 

If (Records in selection:C76([Customers_Projects:9])=1)
	CREATE RECORD:C68([Finished_Goods_SizeAndStyles:132])
	$fileNum:=rfc_newOutlineNumber("rfc")
	[Finished_Goods_SizeAndStyles:132]FileOutlineNum:1:=$fileNum
	[Finished_Goods_SizeAndStyles:132]ProjectNumber:2:=$pjtId
	[Finished_Goods_SizeAndStyles:132]DateCreated:3:=$today
	[Finished_Goods_SizeAndStyles:132]CreatedBy:57:=<>zResp
	[Finished_Goods_SizeAndStyles:132]TasksCompleted:56:="________"  //controlled by checkboxes on the screen
	[Finished_Goods_SizeAndStyles:132]CustID:52:=[Customers_Projects:9]Customerid:3  // Modified by: Mel Bohince (5/13/14) 
	SAVE RECORD:C53([Finished_Goods_SizeAndStyles:132])
	
	//If (Length($request)=0)  ` make a requests
	//CREATE RECORD([_obsolete_Projects_Requests])
	//$request:=app_set_id_as_string (Table(->[_obsolete_Projects_Requests]))  `fGetNextID (->[_obsolete_Projects_Requests];5)
	//[_obsolete_Projects_Requests]id:=$request
	//[_obsolete_Projects_Requests]RequestOn:=$today
	//[_obsolete_Projects_Requests]ProjectNumber:=$pjtId
	//[_obsolete_Projects_Requests]Custid:=pjtCustid
	//[_obsolete_Projects_Requests]RequestType:="RFC"+" - "+$fileNum
	//SAVE RECORD([_obsolete_Projects_Requests])
	//End if 
	
	$0:=$fileNum
	
	$sFile:=sFile  //cover a side effect of Viewsetter
	<>PassThrough:=True:C214
	CREATE SET:C116([Finished_Goods_SizeAndStyles:132]; "◊PassThroughSet")
	REDUCE SELECTION:C351([Finished_Goods_SizeAndStyles:132]; 0)
	<>Activitiy:=1
	ViewSetter(2; ->[Finished_Goods_SizeAndStyles:132])
	sFile:=$sFile  //Table name(->[Request])  `reset this for normal exit
End if   //project