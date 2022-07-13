
If (Form event code:C388=On Load:K2:1)
	
	C_TEXT:C284($tCustID)
	ARRAY TEXT:C222($atRevlon; 0)
	
	APPEND TO ARRAY:C911($atRevlon; "02085")  //Revlon
	APPEND TO ARRAY:C911($atRevlon; "00074")  //Elizabeth Arden Inc. CT
	
	$tCustID:=FG_getCustIDT([Finished_Goods_PackingSpecs:91]FileOutlineNum:1)
	
	Case of   //Comment
			
		: (Find in array:C230($atRevlon; $tCustID)=CoreknNoMatchFound)
		: (Position:C15("ARKAY CASE ID"; [Finished_Goods_PackingSpecs:91]CaseComment:21)>0)
			
		Else   //Add comment
			
			If (Length:C16([Finished_Goods_PackingSpecs:91]CaseComment:21)>0)
				
				[Finished_Goods_PackingSpecs:91]CaseComment:21:=[Finished_Goods_PackingSpecs:91]CaseComment:21+CorektCR
				
			End if 
			
			[Finished_Goods_PackingSpecs:91]CaseComment:21:=[Finished_Goods_PackingSpecs:91]CaseComment:21+"ADDITIONAL ARKAY CASE ID REQUIRED FOR REVLON LABELS"
			
	End case   //Done comment
	
End if 

util_textNoGremlins(Self:C308)
