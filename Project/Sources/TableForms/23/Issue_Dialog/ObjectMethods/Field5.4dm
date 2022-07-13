tText:=""
If (sMsg#"eBag")
	QUERY:C277([Job_Forms_Machines:43]; [Job_Forms_Machines:43]JobForm:1=[Raw_Materials_Transactions:23]JobForm:12; *)
	QUERY:C277([Job_Forms_Machines:43];  & ; [Job_Forms_Machines:43]Sequence:5=[Raw_Materials_Transactions:23]Sequence:13)
	If (Records in selection:C76([Job_Forms_Machines:43])=0)
		tText:=String:C10([Raw_Materials_Transactions:23]Sequence:13; "000")+" was not found."
		uConfirm(tText; "Ok"; "Help")
		[Raw_Materials_Transactions:23]Sequence:13:=0
		GOTO OBJECT:C206([Raw_Materials_Transactions:23]Sequence:13)
	Else 
		[Raw_Materials_Transactions:23]CostCenter:19:=[Job_Forms_Machines:43]CostCenterID:4
		[Raw_Materials_Transactions:23]ReferenceNo:14:=[Raw_Materials_Transactions:23]CostCenter:19+fYYMMDD(Current date:C33)
	End if 
	
	ARRAY TEXT:C222(aPOitem; 0)
	ARRAY TEXT:C222(aRM; 0)
	ARRAY TEXT:C222(aRMLocation; 0)
	ARRAY REAL:C219(aQtyAvail; 0)
	$jobform:=[Raw_Materials_Transactions:23]JobForm:12
	$seq:=[Raw_Materials_Transactions:23]Sequence:13
	ARRAY TEXT:C222(aRMbom; 0)
	Begin SQL
		select distinct(Raw_Matl_Code) from Job_Forms_Materials where Raw_Matl_Code <> '' and JobForm = :$jobform and Sequence = :$seq order by Raw_Matl_Code into :aRMbom;
	End SQL
	
	$msg:="Materials:"+Char:C90(13)
	For ($i; 1; Size of array:C274(aRMbom))
		$msg:=$msg+aRMbom{$i}+Char:C90(13)
	End for 
	
	Begin SQL
		select POItemKey, Raw_Matl_Code, Location, (QtyOH+ConsignmentQty) from Raw_Materials_Locations where Raw_Matl_Code in
		(select distinct(Raw_Matl_Code) from Job_Forms_Materials where Raw_Matl_Code <> '' and JobForm = :$jobform and Sequence = :$seq) order by Raw_Matl_Code, POItemKey
		into :aPOitem, :aRM, :aRMLocation, :aQtyAvail;
	End SQL
	
	$msg:=$msg+Char:C90(13)+"PO's Available:"+Char:C90(13)
	$lastRM:="start"
	If (Size of array:C274(aPOitem)>0)
		For ($i; 1; Size of array:C274(aPOitem))
			If ($lastRM#aRM{$i})
				$msg:=$msg+Char:C90(13)
				$lastRM:=aRM{$i}
			End if 
			$msg:=$msg+aPOitem{$i}+" at "+aRMLocation{$i}+" "+aRM{$i}+" avail: "+String:C10(aQtyAvail{$i})+Char:C90(13)
		End for 
		//util_FloatingAlert ($msg)
	Else 
		$msg:=$msg+"No inventory or consignment found for R/M's called for on sequence "+String:C10($seq; "000")
	End if 
	tText:=$msg
	
	GOTO OBJECT:C206([Raw_Materials_Transactions:23]POItemKey:4)
	
End if 