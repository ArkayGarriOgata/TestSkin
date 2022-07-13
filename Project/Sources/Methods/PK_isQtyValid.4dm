//%attributes = {}
// -------
// Method: PK_isQtyValid   ( outline; qty) ->
// By: Mel Bohince @ 03/26/18, 16:34:23
// Description
// attempt to stop wild qty's being entered when labels are made
// ----------------------------------------------------

C_BOOLEAN:C305($0)

READ ONLY:C145([Finished_Goods_PackingSpecs:91])
If ([Finished_Goods_PackingSpecs:91]FileOutlineNum:1#$1)
	SET QUERY LIMIT:C395(1)
	QUERY:C277([Finished_Goods_PackingSpecs:91]; [Finished_Goods_PackingSpecs:91]FileOutlineNum:1=$1)
	SET QUERY LIMIT:C395(0)
End if 

$overTolerance:=[Finished_Goods_PackingSpecs:91]CaseCount:2*1.1  // idk, just a guess
$underTolerance:=[Finished_Goods_PackingSpecs:91]CaseCount:2*0.5  //half case

Case of 
	: ($2=[Finished_Goods_PackingSpecs:91]CaseCount:2)
		$0:=True:C214
		
	: ($2>=$underTolerance) & ($2<=$overTolerance)
		uConfirm("Qty in tolerance range of "+String:C10($underTolerance)+" - "+String:C10($overTolerance)+". Proceed?"; "Proceed"; "Fix")
		If (ok=1)
			$0:=True:C214
		Else 
			$0:=False:C215
		End if 
		
	Else 
		uConfirm("Qty out of tolerance range of "+String:C10($underTolerance)+" - "+String:C10($overTolerance)+"."; "Fix"; "Fix")
		$0:=False:C215
End case 
