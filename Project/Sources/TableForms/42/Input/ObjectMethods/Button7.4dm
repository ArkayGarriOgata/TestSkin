If (Records in set:C195("clickedIncluded")>0)
	CUT NAMED SELECTION:C334([Job_Forms_Items:44]; "hold")
	USE SET:C118("clickedIncluded")
	
	<>JOBIT:=[Job_Forms_Items:44]Jobit:4
	If (Length:C16(<>JOBIT)=11)
		//READ ONLY([Finished_Goods])
		$i:=qryFinishedGood([Job_Forms_Items:44]CustId:15; [Job_Forms_Items:44]ProductCode:3)
		If ($i>0)
			PK_ShippingContainerUI([Finished_Goods:26]OutLine_Num:4)
		Else 
			BEEP:C151
		End if 
	End if 
	USE NAMED SELECTION:C332("hold")
	
Else 
	uConfirm("Select a carton first."; "OK"; "Help")
End if 