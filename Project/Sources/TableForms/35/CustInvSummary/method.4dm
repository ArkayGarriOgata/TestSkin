Case of 
	: (Form event code:C388=On Display Detail:K2:22)
		MESSAGE:C88(".")
		If (Substring:C12([Finished_Goods_Locations:35]Location:2; 1; 2)="BH")
			If (Position:C15("bh"; t10)=0)
				t10:=t10+" bh "
			End if 
		End if 
		
		// r1:=r1+[FG_Locations]QtyOH
		$numJMI:=qryJMI([Finished_Goods_Locations:35]Jobit:33)
		If ($numJMI>0)
			If ([Job_Forms_Items:44]PldCostTotal:21>0)
				If (Position:C15("inf"; String:C10([Job_Forms_Items:44]PldCostTotal:21))=0)
					//r2:=r2+(([FG_Locations]QtyOH/1000)*[JobMakesItem]PldCostTotal)
					r2:=([Finished_Goods_Locations:35]QtyOH:9/1000)*[Job_Forms_Items:44]PldCostTotal:21
				Else 
					r2:=0  //r2+0
					If (Position:C15("∞"; t10)=0)
						t10:=t10+" ∞ "
					End if 
				End if 
			Else 
				r2:=0  //r2+0
				If (Position:C15("x"; t10)=0)
					t10:=t10+" x "
				End if 
			End if 
			
		Else 
			r2:=0  //r2+0
			If (Position:C15("j"; t10)=0)
				t10:=t10+" j "
			End if 
		End if 
		
		$lastPrice:=FG_getLastPrice([Finished_Goods_Locations:35]FG_Key:34)
		If ($lastPrice>0)
			r3:=([Finished_Goods_Locations:35]QtyOH:9/1000)*$lastPrice
		Else 
			r3:=0  //r3+0
			If (Position:C15("$"; t10)=0)
				t10:=t10+" $ "
			End if 
		End if 
		
		If (Records in selection:C76([Finished_Goods:26])=0)
			If (Position:C15("ƒ"; t10)=0)
				t10:=t10+" ƒ "
			End if 
		End if 
		
	: (Form event code:C388=On Header:K2:17)
		If (Level:C101=1)
			t10:=""
			r1:=0
			r2:=0
			r3:=0
			MESSAGE:C88(Char:C90(13)+[Finished_Goods_Locations:35]CustID:16)
		End if 
		
	: (Form event code:C388=On Printing Break:K2:19)
		Case of 
			: (Level:C101=1)
				If ([Customers:16]ID:1#[Finished_Goods_Locations:35]CustID:16)
					READ ONLY:C145([Customers:16])
					QUERY:C277([Customers:16]; [Customers:16]ID:1=[Finished_Goods_Locations:35]CustID:16)
				End if 
				r1:=Round:C94(Subtotal:C97([Finished_Goods_Locations:35]QtyOH:9); 0)
				r2:=Round:C94(Subtotal:C97(r2); 0)
				r3:=Round:C94(Subtotal:C97(r3); 0)
				
				MESSAGE:C88(Char:C90(13)+[Customers:16]Name:2)
				
				If (fSave)
					SEND PACKET:C103(vDoc; [Customers:16]Name:2+Char:C90(9))
					SEND PACKET:C103(vDoc; String:C10(r1)+Char:C90(9))
					SEND PACKET:C103(vDoc; String:C10(r2)+Char:C90(9))
					SEND PACKET:C103(vDoc; String:C10(r3)+Char:C90(9))
					SEND PACKET:C103(vDoc; t10+Char:C90(13))
				End if 
				
			: (Level:C101=0)
				r1:=Round:C94(Subtotal:C97([Finished_Goods_Locations:35]QtyOH:9); 0)
				r2:=Round:C94(Subtotal:C97(r2); 0)
				r3:=Round:C94(Subtotal:C97(r3); 0)
				If (fSave)
					SEND PACKET:C103(vDoc; Char:C90(13)+"GRAND TOTALS:"+Char:C90(9))
					SEND PACKET:C103(vDoc; String:C10(r1)+Char:C90(9))
					SEND PACKET:C103(vDoc; String:C10(r2)+Char:C90(9))
					SEND PACKET:C103(vDoc; String:C10(r3)+Char:C90(13)+Char:C90(13))
					SEND PACKET:C103(vDoc; "Notes: j = missing job cost record,"+"  ƒ = missing F/G record, bh = bill & hold included")
					SEND PACKET:C103(vDoc; ", x = zero job cost, $ = zero last price,"+" ∞ = inf cost."+Char:C90(13))
				End if 
		End case 
		
End case 