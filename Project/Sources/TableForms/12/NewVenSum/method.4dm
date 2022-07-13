//Layout Proc.: [po_item]VenSumReport()  062695  MLB
Case of 
	: (Form event code:C388=On Display Detail:K2:22)
		//•062695  MLB  UPR 219    rewrite
		//switch to poItemDate from reqdDATe
		C_LONGINT:C283($hit; $period)
		C_DATE:C307($dateOf1st)
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
		r10:=1  //• 12/22/97 cs used as numerator when doing conversion
		r11:=1  //• 12/22/97 cs used as denominator when doing conversion
		
		If ([Purchase_Orders_Items:12]PoItemDate:40>=dDateBegin)
			$dateOf1st:=Date:C102(String:C10(Month of:C24([Purchase_Orders_Items:12]PoItemDate:40))+"/01/"+String:C10(Year of:C25([Purchase_Orders_Items:12]PoItemDate:40)))
			$Hit:=Find in array:C230(aDate; $dateOf1st)
			If ($Hit>0)
				$period:=Num:C11(Substring:C12(aPeriod{$Hit}; 5; 2))
			Else 
				$period:=0
			End if 
			$Qty:=VenSumConvert
			
			Case of 
				: ($period<4)  //  Q1
					real1:=real1+[Purchase_Orders_Items:12]ExtPrice:11
					real2:=real2+$Qty
				: ($period<7)  //  Q2
					real3:=real3+[Purchase_Orders_Items:12]ExtPrice:11
					real4:=real4+$Qty
				: ($period<10)  //Q3
					real5:=real5+[Purchase_Orders_Items:12]ExtPrice:11
					real6:=real6+$Qty
				Else   //             Q4
					real7:=real7+[Purchase_Orders_Items:12]ExtPrice:11
					real8:=real8+$Qty
			End case 
			real9:=real9+[Purchase_Orders_Items:12]ExtPrice:11
			real10:=real10+$Qty
			
		Else   //last year
			real11:=real11+[Purchase_Orders_Items:12]ExtPrice:11
		End if 
		
End case 
//