
Case of 
	: (Form event code:C388=On Load:K2:1)
		If (Is new record:C668([Raw_Materials_Transactions:23]))
			[Raw_Materials_Transactions:23]XferDate:3:=Current date:C33
			[Raw_Materials_Transactions:23]Xfer_Type:2:="Issue"
			[Raw_Materials_Transactions:23]XferTime:25:=Current time:C178
			[Raw_Materials_Transactions:23]Location:15:="WIP"
			[Raw_Materials_Transactions:23]ModDate:17:=[Raw_Materials_Transactions:23]XferDate:3
			[Raw_Materials_Transactions:23]ModWho:18:=<>zResp
			[Raw_Materials_Transactions:23]zCount:16:=1
			[Raw_Materials_Transactions:23]Reason:5:="RMX_Issue_Dialog"
			tText:=""
			tRoll_id:=""
			
			If (sMsg="eBag")
				[Raw_Materials_Transactions:23]JobForm:12:=sJobform
				If (iSeq>0)
					[Raw_Materials_Transactions:23]CostCenter:19:=sCC
					[Raw_Materials_Transactions:23]ReferenceNo:14:=[Raw_Materials_Transactions:23]CostCenter:19+fYYMMDD(Current date:C33)
					[Raw_Materials_Transactions:23]Sequence:13:=iSeq
					
					ARRAY TEXT:C222(aPOitem; 0)
					ARRAY TEXT:C222(aRM; 0)
					ARRAY TEXT:C222(aRMLocation; 0)
					ARRAY REAL:C219(aQtyAvail; 0)
					$jobform:=[Raw_Materials_Transactions:23]JobForm:12
					$seq:=[Raw_Materials_Transactions:23]Sequence:13
					Begin SQL
						select POItemKey, Raw_Matl_Code, Location, (QtyOH+ConsignmentQty) from Raw_Materials_Locations where Raw_Matl_Code in
						(select Raw_Matl_Code from Job_Forms_Materials where Raw_Matl_Code<>'' and JobForm= :$jobform and Sequence = :$seq) order by Raw_Matl_Code, POItemKey
						into :aPOitem, :aRM, :aRMLocation, :aQtyAvail
					End SQL
					
					$msg:=""
					$lastRM:="start"
					For ($i; 1; Size of array:C274(aPOitem))
						If ($lastRM#aRM{$i})
							$msg:=$msg+Char:C90(13)
							$lastRM:=aRM{$i}
						End if 
						$msg:=$msg+aPOitem{$i}+" at "+aRMLocation{$i}+" "+aRM{$i}+" avail: "+String:C10(aQtyAvail{$i})+Char:C90(13)
					End for 
					//util_FloatingAlert ($msg)
					tText:=$msg
					If (iSeq=10)
						GOTO OBJECT:C206(tRoll_id)
					Else 
						GOTO OBJECT:C206([Raw_Materials_Transactions:23]POItemKey:4)
					End if 
				Else 
					GOTO OBJECT:C206([Raw_Materials_Transactions:23]Sequence:13)
				End if 
				
			Else 
				REDUCE SELECTION:C351([Job_Forms:42]; 0)
				REDUCE SELECTION:C351([Job_Forms_Machines:43]; 0)
				GOTO OBJECT:C206([Raw_Materials_Transactions:23]JobForm:12)
			End if   //ebag
			
		Else 
			//BEEP
		End if 
		
		UNLOAD RECORD:C212([Purchase_Orders_Items:12])
		UNLOAD RECORD:C212([Raw_Materials_Locations:25])
		UNLOAD RECORD:C212([Raw_Materials_Allocations:58])
		UNLOAD RECORD:C212([Job_Forms_Materials:55])
		UNLOAD RECORD:C212([Raw_Material_Labels:171])
		
End case 

