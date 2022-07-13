//(S) bSearchto
//upr 162 1/9/95
//• 10/21/97 cs partial rewrite - find all items not for loc etc
//• 12/4/97 cs added "2' to searches

C_TEXT:C284($Loc)

$Loc:=Request:C163("Enter Location: (postfix '@' for wildcard)"; "FG:")  //

If (ok=1) & ($Loc#"")
	QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]JobForm:5=[Job_Forms:42]JobFormID:5; *)  //•052196  MLB 
	QUERY:C277([Finished_Goods_Transactions:33];  & ; [Finished_Goods_Transactions:33]Location:9=$Loc)
	
	If (Records in selection:C76([Finished_Goods_Transactions:33])=0)
		uConfirm("FG Transfer records do not exist for 'To' Location "+$Loc; "OK"; "Help")
		rTotXfer:=0
	Else 
		ORDER BY:C49([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]Location:9; <; [Finished_Goods_Transactions:33]XactionDate:3; >)
		rTotXfer:=Sum:C1([Finished_Goods_Transactions:33]Qty:6)
	End if 
End if 