If ([Finished_Goods_Inv_Summaries:64]ProductCode:11="003-85-11")
	utl_Trace
End if 

Case of 
	: (Form event code:C388=On Header:K2:17)
		iBB:=0
		iIN:=0
		iOUT:=0
		iEB:=0
		iERR:=0
		iADJ:=0
		
	: (Form event code:C388=On Printing Detail:K2:18)
		Case of 
			: ([Finished_Goods_Inv_Summaries:64]z_Group:10="_~BAL")
				If ([Finished_Goods_Inv_Summaries:64]DateFrozen:8=dDateBegin)
					iBB:=iBB+[Finished_Goods_Inv_Summaries:64]Quantity:3
					rB1:=rB1+[Finished_Goods_Inv_Summaries:64]Quantity:3
				Else 
					iEB:=iEB+[Finished_Goods_Inv_Summaries:64]Quantity:3
					rB5:=rB5+[Finished_Goods_Inv_Summaries:64]Quantity:3
				End if 
				
			: ([Finished_Goods_Inv_Summaries:64]z_Group:10="_IN@")
				iIN:=iIN+[Finished_Goods_Inv_Summaries:64]Quantity:3
				rB2:=rB2+[Finished_Goods_Inv_Summaries:64]Quantity:3
				
			: ([Finished_Goods_Inv_Summaries:64]z_Group:10="_OUT@")
				iOUT:=iOUT+[Finished_Goods_Inv_Summaries:64]Quantity:3
				rB3:=rB3+[Finished_Goods_Inv_Summaries:64]Quantity:3
				
			: ([Finished_Goods_Inv_Summaries:64]z_Group:10="_ADJ@")
				iADJ:=iADJ+[Finished_Goods_Inv_Summaries:64]Quantity:3
				rB4:=rB4+[Finished_Goods_Inv_Summaries:64]Quantity:3
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