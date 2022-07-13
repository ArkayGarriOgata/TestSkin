// ----------------------------------------------------
// User name (OS): CS
// Date: 10/8/97
// ----------------------------------------------------
// Object Method: [Finished_Goods].Input.lockField17
// Description:
// After entering a file number(outline number)
// locate any other FGs which have the same file no AND a SnS date
// if one (or more) is found set this record to the found date
// Also locate a pcking qty too.
//•120997  MLB  UPR 1908
//•040402  MLB fix query
// ----------------------------------------------------

C_DATE:C307($date)
C_LONGINT:C283($PckQty)

MESSAGES OFF:C175

RELATE ONE:C42([Finished_Goods:26]OutLine_Num:4)
If (Records in selection:C76([Finished_Goods_SizeAndStyles:132])>0)
	[Finished_Goods:26]DateSnSReceived:57:=[Finished_Goods_SizeAndStyles:132]DateCreated:3
	[Finished_Goods:26]HaveSnS:54:=True:C214
	If ([Finished_Goods_SizeAndStyles:132]Approved:9)
		[Finished_Goods:26]DateSnS_Approved:83:=[Finished_Goods_SizeAndStyles:132]DateApproved:8
	End if 
	//FG_getDimensions
	[Finished_Goods:26]Width:7:=[Finished_Goods_SizeAndStyles:132]Dim_A:17
	[Finished_Goods:26]Depth:8:=[Finished_Goods_SizeAndStyles:132]Dim_B:18
	[Finished_Goods:26]Height:9:=[Finished_Goods_SizeAndStyles:132]Dim_Ht:19
	If (Length:C16([Finished_Goods_Specifications:98]StockType:21)=0)
		[Finished_Goods_Specifications:98]StockType:21:=[Finished_Goods_SizeAndStyles:132]StockType:20
	End if 
	If ([Finished_Goods_Specifications:98]StockCaliper:23=0)
		[Finished_Goods_Specifications:98]StockCaliper:23:=[Finished_Goods_SizeAndStyles:132]StockCaliper:21
	End if 
	If (Length:C16([Finished_Goods:26]Style:32)=0)
		[Finished_Goods:26]Style:32:=[Finished_Goods_SizeAndStyles:132]Style:14
	End if 
	[Finished_Goods:26]SquareInch:6:=[Finished_Goods_SizeAndStyles:132]SquareInches:48
	[Finished_Goods:26]StripHoles:38:=[Finished_Goods_SizeAndStyles:132]Windowed:23
	If ([Finished_Goods:26]StripHoles:38)
		SetObjectProperties(""; ->[Finished_Goods:26]WindowMatl:39; True:C214; ""; True:C214)  // Modified by: Mark Zinke (5/13/13)
		SetObjectProperties(""; ->[Finished_Goods:26]WindowGauge:40; True:C214; ""; True:C214)  // Modified by: Mark Zinke (5/13/13)
		SetObjectProperties(""; ->[Finished_Goods:26]WindowWth:41; True:C214; ""; True:C214)  // Modified by: Mark Zinke (5/13/13)
		SetObjectProperties(""; ->[Finished_Goods:26]WindowHth:42; True:C214; ""; True:C214)  // Modified by: Mark Zinke (5/13/13)
	End if 
End if 

//If (Length([Finished_Goods]PackingSpecification)=0) | (True)  //for now keep them the same
//[Finished_Goods]PackingSpecification:=[Finished_Goods]OutLine_Num
//End if 

$PckQty:=0  //•120997  MLB  UPR 1908, first try the ShipContainers file, if fail, do it the ot
QUERY:C277([Finished_Goods_PackingSpecs:91]; [Finished_Goods_PackingSpecs:91]FileOutlineNum:1=[Finished_Goods:26]OutLine_Num:4)  //•040402  MLB fix query
If (Records in selection:C76([Finished_Goods_PackingSpecs:91])=1)
	$PckQty:=[Finished_Goods_PackingSpecs:91]CaseCount:2
	[Finished_Goods:26]PackingQty:45:=$PckQty
	
Else 
	BEEP:C151
	ALERT:C41("Check your PackingSpec.")
End if 