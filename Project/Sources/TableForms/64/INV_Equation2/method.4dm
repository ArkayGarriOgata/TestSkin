Case of 
	: (Form event code:C388=On Header:K2:17)
		iBB:=0
		iIN:=0
		iOUT:=0
		iEB:=0
		iERR:=0
		iADJ:=0
		
	: (Form event code:C388=On Printing Detail:K2:18)
		$cost:=Round:C94([Finished_Goods_Inv_Summaries:64]CostTotal:7*[Finished_Goods_Inv_Summaries:64]Quantity:3/1000; 0)
		Case of 
			: ([Finished_Goods_Inv_Summaries:64]z_Group:10="_~BAL")
				If ([Finished_Goods_Inv_Summaries:64]DateFrozen:8=dDateBegin)
					iBB:=iBB+$cost
					rB1:=rB1+$cost
				Else 
					iEB:=iEB+$cost
					rB5:=rB5+$cost
				End if 
				
			: ([Finished_Goods_Inv_Summaries:64]z_Group:10="_IN@")
				iIN:=iIN+$cost
				rB2:=rB2+$cost
				
			: ([Finished_Goods_Inv_Summaries:64]z_Group:10="_OUT@")
				iOUT:=iOUT+$cost
				rB3:=rB3+$cost
				
			: ([Finished_Goods_Inv_Summaries:64]z_Group:10="_ADJ@")
				iADJ:=iADJ+$cost
				rB4:=rB4+$cost
		End case 
		
	: (Form event code:C388=On Printing Break:K2:19)
		iERR:=iBB+iIN-iOUT-iEB+iADJ
		rB6:=rB6+iERR
		//
		If (Level:C101=0)
			BEEP:C151
			//rB1:=Subtotal(iBB)
			//rB2:=Subtotal(iIN)
			//rB3:=Subtotal(iOUT)
			//rB4:=Subtotal(iADJ)
			//rB5:=Subtotal(iEB)
			//rB6:=Subtotal(iERR)
		End if 
End case 
//