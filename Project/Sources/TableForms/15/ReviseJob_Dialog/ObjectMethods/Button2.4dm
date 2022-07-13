$hit:=Find in array:C230(aSelected; "X")  //$i:=Find in array(ause;"•")
If ($hit=-1)
	ALERT:C41("You must select at least one Job Form record.")
Else 
	ACCEPT:C269
End if 

If (Length:C16(sState)>0)
	If (iJobId#0)
		$continue:=False:C215
		For ($i; 1; Size of array:C274(aSelected))
			If (aSelected{$i}="X")
				$continue:=True:C214
				$i:=$i+Size of array:C274(aSelected)
			End if 
		End for 
		
		If ($continue)
			If (Length:C16(tTitle)>0)
				SET QUERY LIMIT:C395(1)
				QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]XactionType:2="Ship"; *)  //•051299  mlb  UPR 1921, a rev now will change the CoGS
				QUERY:C277([Finished_Goods_Transactions:33];  & ; [Finished_Goods_Transactions:33]JobForm:5=(String:C10(iJobId)+"@"))
				SET QUERY LIMIT:C395(0)
				If (Records in selection:C76([Finished_Goods_Transactions:33])>0)  //•051299  mlb  UPR 1921, a rev now will change the CoGS
					BEEP:C151
					$authorization:=Request:C163("WARNING: Job has begun shipping, existing Cost of Good Sold may change."+Char:C90(13)+"Enter authorization code:"; "hoops"; "Authorize"; "Cancel")
					If (ok=1) & ($authorization="hoops")
						$continue:=True:C214
					Else 
						$continue:=True:C214
					End if 
				Else 
					$continue:=True:C214
				End if 
				
			Else 
				BEEP:C151
				ALERT:C41("You must describe the changes in this revision.")
				REJECT:C38
			End if 
			
		Else 
			BEEP:C151
			ALERT:C41("Select forms to revise or click Cancel.")
			REJECT:C38
		End if 
		
	Else 
		BEEP:C151
		ALERT:C41("Enter a Job to revise or click Cancel.")
		REJECT:C38
	End if 
	
Else 
	BEEP:C151
	ALERT:C41("Enter a Differential  or click Cancel.")
	REJECT:C38
End if 