Case of 
	: (Form event code:C388=On Display Detail:K2:22)
		C_BOOLEAN:C305($OK)
		$OK:=False:C215
		rReal3:=[Finished_Goods_Locations:35]QtyOH:9-[Finished_Goods_Locations:35]PiFreezeQty:28  //difference
		$i:=Find in array:C230(aJob2; [Finished_Goods_Locations:35]JobForm:19)
		
		Repeat 
			If ($i>0)
				$OK:=(aCPN{$i}=[Finished_Goods_Locations:35]ProductCode:1)
				If (Not:C34($OK))
					$i:=Find in array:C230(aJob2; [Finished_Goods_Locations:35]JobForm:19; $i+1)
				End if 
			End if 
		Until ($OK) | ($i<0)
		
		If ($i>0)  //if there was cost info
			rReal2:=aActCost{$i}  //print it
			$i:=Find in array:C230(aCpn2; [Finished_Goods_Locations:35]ProductCode:1)  //find the cpn in FIn/Good array
			If (aUOM{$i}="M")  //if the Unit of Measure is "m" (thousands) 
				rReal4:=rReal2*(rReal3/1000)  //divide difference by 1000
			Else   //cost is per unit
				rReal4:=rReal3*rReal2
			End if 
		Else   //no costs
			rReal4:=0
			rReal2:=0
		End if 
End case 