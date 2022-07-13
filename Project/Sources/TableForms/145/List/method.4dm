Case of 
	: (Form event code:C388=On Outside Call:K2:11)
		If (<>fQuit4D)
			CANCEL:C270
			bdone:=1
		Else 
			
			If (Substring:C12(<>PO; 1; 1)="!")
				QUERY:C277([Finished_Goods_DeliveryForcasts:145]; [Finished_Goods_DeliveryForcasts:145]ProductCode:2=Substring:C12(<>PO; 2))
			Else 
				QUERY:C277([Finished_Goods_DeliveryForcasts:145]; [Finished_Goods_DeliveryForcasts:145]refer:3=<>PO)
				If (Records in selection:C76([Finished_Goods_DeliveryForcasts:145])=0) & (Substring:C12(<>PO; 1; 2)="BR")
					$po:="BP"+Substring:C12(<>PO; 3)
					QUERY:C277([Finished_Goods_DeliveryForcasts:145]; [Finished_Goods_DeliveryForcasts:145]refer:3=$po)
				End if 
			End if 
			CREATE SET:C116(filePtr->; "◊LastSelection"+String:C10(fileNum))
			<>PO:=""
			ORDER BY:C49([Finished_Goods_DeliveryForcasts:145]; [Finished_Goods_DeliveryForcasts:145]asOf:9; <)
			SET WINDOW TITLE:C213(fNameWindow(Current form table:C627))
			SHOW PROCESS:C325(Current process:C322)
			BRING TO FRONT:C326(Current process:C322)
		End if 
		
	: (Form event code:C388=On Activate:K2:9)
		CREATE SET:C116(filePtr->; "◊LastSelection"+String:C10(fileNum))
		SET WINDOW TITLE:C213(fNameWindow(Current form table:C627))
		
	: (Form event code:C388=On Close Box:K2:21)
		//bDone:=1
		//CANCEL
		HIDE PROCESS:C324(Current process:C322)
		
	: (Form event code:C388=On Unload:K2:2)
		//BEEP  `bDone:=1
		HIDE PROCESS:C324(Current process:C322)
End case 
//