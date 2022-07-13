
Case of 
	: (Form event code:C388=On Load:K2:1)
		
		
	: (Form event code:C388=On Selection Change:K2:29)
		Form:C1466.bin:=Form:C1466.clickedBin
		
	: (Form event code:C388=On After Edit:K2:43)
		C_OBJECT:C1216($bin_e; $status_o)
		$bin_e:=New object:C1471
		$bin_e:=Form:C1466.bins.currItem
		$bin_e.Quantity:=Form:C1466.bins.currItem.Quantity
		$status_o:=$bin_e.save()
		
		Form:C1466.bins:=Form:C1466.bins
		
	: (Form event code:C388=On Double Clicked:K2:5)
		//orda_action_open 
		
		Form:C1466.bin:=Form:C1466.clickedBin
		Form:C1466.rm:=ds:C1482.Raw_Materials.query("Raw_Matl_Code = :1"; Form:C1466.bin.PartNumber).first()
		//Form.rm.ent:=Form.rm
		FORM GOTO PAGE:C247(2)
		
		
	: (Form event code:C388=On Drop:K2:12)
		C_LONGINT:C283($rowNum)
		$rowNum:=Drop position:C608-1
		
		C_OBJECT:C1216($bin_e; $part_e; $status_o)
		If ($rowNum>=0)
			$bin_e:=Form:C1466.bins[$rowNum]
			$bin_e.PartNumber:=Form:C1466.clickedPart.Raw_Matl_Code
			$bin_e.Raw_Matl_fk:=Form:C1466.clickedPart.pk_id
			$bin_e.Quantity:=0
			$status_o:=$bin_e.save()
			
			$part_e:=Form:C1466.clickedPart
			$part_e.PreferedBin:=$bin_e.Bin
			$status_o:=$part_e.save()
			
			Form:C1466.bins:=Form:C1466.bins  // this line is required to refresh listbox display
			Form:C1466.parts:=Form:C1466.parts
		End if 
		
End case 
