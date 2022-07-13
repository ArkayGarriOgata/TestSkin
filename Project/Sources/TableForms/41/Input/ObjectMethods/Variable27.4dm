C_TEXT:C284($cpn)
C_LONGINT:C283($i; $numRecs)

If ([Customers_Order_Lines:41]Status:9#"Accepted")
	$cpn:=Request:C163("What is the correct 20 character or less Product Code"; [Customers_Order_Lines:41]ProductCode:5)
	If (ok=1)
		READ ONLY:C145([Finished_Goods:26])
		$numFG:=qryFinishedGood("#CPN"; $cpn)
		If ($numFG>0)
			If ($numFG>1)
				CREATE SET:C116([Finished_Goods:26]; "somefound")  //
				$numFG:=qryFinishedGood([Customers_Order_Lines:41]CustID:4; $cpn)
				If ($numFG=0)
					USE SET:C118("somefound")
				End if 
				CLEAR SET:C117("somefound")
			End if   //
			
			If ([Customers_Order_Lines:41]CustID:4=[Finished_Goods:26]CustID:2)
				ok:=1
			Else 
				uConfirm("Warning: The custid field for this item is "+[Finished_Goods:26]CustID:2+" and doesn't match this orderline."; "Continue"; "Cancel")  //happens with prep items
			End if 
			
			If (ok=1)
				[Customers_Order_Lines:41]ProductCode:5:=$cpn
				$line:=[Finished_Goods:26]Line_Brand:15
				If (Length:C16($line)=0)
					$line:=[Customers_Orders:40]CustomerLine:22
				End if 
				[Customers_Order_Lines:41]CustomerLine:42:=$line
				REDUCE SELECTION:C351([Finished_Goods:26]; 0)
				QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]OrderLine:4=[Customers_Order_Lines:41]OrderLine:3)
				$numRecs:=Records in selection:C76([Customers_ReleaseSchedules:46])
				If ($numRecs>0)
					ARRAY TEXT:C222($aCPN; $numRecs)
					ARRAY TEXT:C222($aLine; $numRecs)
					For ($i; 1; $numRecs)
						$aCPN{$i}:=$cpn
						$aLine{$i}:=$line
					End for 
					ARRAY TO SELECTION:C261($aCPN; [Customers_ReleaseSchedules:46]ProductCode:11; $aLine; [Customers_ReleaseSchedules:46]CustomerLine:28)
					
				End if 
				
				If (Records in selection:C76([Job_Forms_Items:44])>0)
					uConfirm("You must fix the related Job item links!"; "OK"; "Help")
				End if 
				
			End if 
			
		Else 
			uConfirm($cpn+" was not found in Finished Goods item master."; "OK"; "Help")
		End if 
		
	End if   //ok
	
Else 
	uConfirm("Orderline is booked, use a Change Order."; "OK"; "Help")
End if 