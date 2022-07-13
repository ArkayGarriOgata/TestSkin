Case of 
	: (Form event code:C388=On Display Detail:K2:22)
		real1:=0
		real2:=0
		real3:=0
		real4:=0
		real5:=0
		real6:=0
		real7:=0
		real8:=0
		real9:=0
		real10:=0
		real11:=0
		$currYr:=Year of:C25(dDateEnd)
		$purchYr:=(Year of:C25([Purchase_Orders_Items:12]ReqdDate:8))
		MESSAGES OFF:C175
		$period:=Num:C11(FiscalYear("periodNumber"; [Purchase_Orders_Items:12]ReqdDate:8))
		
		Case of 
			: ($purchYr=$currYr)
				Case of 
					: ($period<4)  //  Q1
						real1:=real1+[Purchase_Orders_Items:12]ExtPrice:11
						real2:=real2+[Purchase_Orders_Items:12]Qty_Shipping:4
					: ($period<7)  //  Q2
						real3:=real3+[Purchase_Orders_Items:12]ExtPrice:11
						real4:=real4+[Purchase_Orders_Items:12]Qty_Shipping:4
					: ($period<10)  //Q3
						real5:=real5+[Purchase_Orders_Items:12]ExtPrice:11
						real6:=real6+[Purchase_Orders_Items:12]Qty_Shipping:4
					Else   //             Q4
						real7:=real7+[Purchase_Orders_Items:12]ExtPrice:11
						real8:=real8+[Purchase_Orders_Items:12]Qty_Shipping:4
				End case 
				real9:=real9+[Purchase_Orders_Items:12]ExtPrice:11
				real10:=real10+[Purchase_Orders_Items:12]Qty_Shipping:4
				
			: ($purchYr=($currYr-1))  //last year
				real11:=real11+[Purchase_Orders_Items:12]ExtPrice:11
				
			Else   //out of bounds
				//
		End case 
		
		
		
End case 
//