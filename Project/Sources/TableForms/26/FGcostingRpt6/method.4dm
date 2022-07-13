//(LP)[Finished_Goods].FGcostingRpt6`•081899  mlb  UPR 2053
C_TEXT:C284($num)
$Num:="##,###,###,##0"  //format for numbers if saving to disk
C_TEXT:C284($t; $cr)
$t:=Char:C90(9)
$cr:=Char:C90(13)

Case of 
	: (Form event code:C388=On Display Detail:K2:22)  //each f/g record
		//get the valued costs
		t3a:="JOB IT: "
		MESSAGES OFF:C175
		USE SET:C118("whichWarehouse")
		
		// ******* Verified  - 4D PS - January  2019 ********
		
		QUERY SELECTION:C341([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]ProductCode:1=[Finished_Goods:26]ProductCode:1; *)
		QUERY SELECTION:C341([Finished_Goods_Locations:35];  & ; [Finished_Goods_Locations:35]CustID:16=[Finished_Goods:26]CustID:2)
		
		
		// ******* Verified  - 4D PS - January 2019 (end) *********
		real6:=0
		real7:=0
		real8:=0
		real9:=0
		real10:=0
		real11:=0
		real12:=0
		real13:=0
		real14:=0
		real15:=0
		uGetJobCosts7bywarehouse(->real6; ->real7; ->real8; ->real9; ->real10; ->real11; ->real12; ->real13; ->real14; ->real15)
		//total the costs
		real1:=real6+real11
		real2:=real7+real12
		real3:=real8+real13
		real4:=real9+real14
		real5:=real10+real15
		
		QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]ProductCode:5=[Finished_Goods:26]ProductCode:1)
		If (Records in selection:C76([Customers_Order_Lines:41])>0)
			SELECTION TO ARRAY:C260([Customers_Order_Lines:41]DateOpened:13; $aDate; [Customers_Order_Lines:41]Price_Per_M:8; $aPrice)
			SORT ARRAY:C229($aDate; $aPrice; <)
			rPrice:=$aPrice{1}*(real1/1000)
			rMargin:=Round:C94(((rPrice-real10)/rPrice)*100; 0)
		Else 
			rPrice:=0
			rMargin:=0
		End if 
		
		If (fSave)  //•1/31/97 if saving to disk, setup in monthendsuite
			SEND PACKET:C103(vDoc; [Finished_Goods:26]ProductCode:1+$t)
			SEND PACKET:C103(vDoc; String:C10(Real1; $Num)+$t+String:C10(Real2; $Num)+$t+String:C10(Real3; $Num)+$t+String:C10(Real4; $Num)+$t+String:C10(Real5; $Num)+$t)
			SEND PACKET:C103(vDoc; String:C10(Real6; $Num)+$t+String:C10(Real7; $Num)+$t+String:C10(Real8; $Num)+$t+String:C10(Real9; $Num)+$t+String:C10(Real10; $Num)+$t)
			SEND PACKET:C103(vDoc; String:C10(Real11; $Num)+$t+String:C10(Real12; $Num)+$t+String:C10(Real13; $Num)+$t+String:C10(Real14; $Num)+$t+String:C10(Real15; $Num)+$t+String:C10(rPrice; $Num)+$t+String:C10(rMargin; $Num))
			SEND PACKET:C103(vDoc; $t+t3a+$cr)
		End if 
		
	: (Form event code:C388=On Printing Break:K2:19)
		Case of 
			: (Level:C101=1)  //•1/31/97 if saving to disk
				real1a:=Subtotal:C97(real1)
				real2a:=Subtotal:C97(real2)
				real3a:=Subtotal:C97(real3)
				real4a:=Subtotal:C97(real4)
				real5a:=Subtotal:C97(real5)
				real6a:=Subtotal:C97(real6)
				real7a:=Subtotal:C97(real7)
				real8a:=Subtotal:C97(real8)
				real9a:=Subtotal:C97(real9)
				real10a:=Subtotal:C97(real10)
				real11a:=Subtotal:C97(real11)
				real12a:=Subtotal:C97(real12)
				real13a:=Subtotal:C97(real13)
				real14a:=Subtotal:C97(real14)
				real15a:=Subtotal:C97(real15)
				rPriceSub:=Subtotal:C97(rPrice)
				rMarginSub:=Round:C94(((rPriceSub-real10a)/rPriceSub)*100; 0)
				
				If (fSave)
					SEND PACKET:C103(vDoc; "Customer Totals:"+$t)
					SEND PACKET:C103(vDoc; String:C10(Real1a; $Num)+$t+String:C10(Real2a; $Num)+$t+String:C10(Real3a; $Num)+$t+String:C10(Real4a; $Num)+$t+String:C10(Real5a; $Num)+$t)
					SEND PACKET:C103(vDoc; String:C10(Real6a; $Num)+$t+String:C10(Real7a; $Num)+$t+String:C10(Real8a; $Num)+$t+String:C10(Real9a; $Num)+$t+String:C10(Real10a; $Num)+$t)
					SEND PACKET:C103(vDoc; String:C10(Real11a; $Num)+$t+String:C10(Real12a; $Num)+$t+String:C10(Real13a; $Num)+$t+String:C10(Real14a; $Num)+$t+String:C10(Real15a; $Num)+$cr)
				End if 
				
			: (Level:C101=0)
				real1t:=Round:C94(Subtotal:C97(real1); 0)
				real2t:=Round:C94(Subtotal:C97(real2); 0)
				real3t:=Round:C94(Subtotal:C97(real3); 0)
				real4t:=Round:C94(Subtotal:C97(real4); 0)
				real5t:=Round:C94(Subtotal:C97(real5); 0)
				real6t:=Round:C94(Subtotal:C97(real6); 0)
				real7t:=Round:C94(Subtotal:C97(real7); 0)
				real8t:=Round:C94(Subtotal:C97(real8); 0)
				real9t:=Round:C94(Subtotal:C97(real9); 0)
				real10t:=Round:C94(Subtotal:C97(real10); 0)
				real11t:=Round:C94(Subtotal:C97(real11); 0)
				real12t:=Round:C94(Subtotal:C97(real12); 0)
				real13t:=Round:C94(Subtotal:C97(real13); 0)
				real14t:=Round:C94(Subtotal:C97(real14); 0)
				real15t:=Round:C94(Subtotal:C97(real15); 0)
				rPriceTotal:=Round:C94(Subtotal:C97(rPrice); 0)
				rMarginTotal:=Round:C94(((rPriceTotal-real10t)/rPriceTotal)*100; 0)
				
				If (fSave)  //•1/31/97 if saving to disk
					SEND PACKET:C103(vDoc; $cr+"Arkay Totals:"+$t)
					SEND PACKET:C103(vDoc; String:C10(Real1t; $Num)+$t+String:C10(Real2t; $Num)+$t+String:C10(Real3t; $Num)+$t+String:C10(Real4t; $Num)+$t+String:C10(Real5t; $Num)+$t)
					SEND PACKET:C103(vDoc; String:C10(Real6t; $Num)+$t+String:C10(Real7t; $Num)+$t+String:C10(Real8t; $Num)+$t+String:C10(Real9t; $Num)+$t+String:C10(Real10t; $Num)+$t)
					SEND PACKET:C103(vDoc; String:C10(Real11t; $Num)+$t+String:C10(Real12t; $Num)+$t+String:C10(Real13t; $Num)+$t+String:C10(Real14t; $Num)+$t+String:C10(Real15t; $Num)+$cr)
					SEND PACKET:C103(vDoc; $cr+$cr)
				End if 
		End case 
End case 
//