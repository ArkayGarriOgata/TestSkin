//(LP)[finishedGoods].FGcostingRpt4
//12/8/94
Case of 
	: (Form event code:C388=On Display Detail:K2:22)  //each f/g record
		//get the valued costs
		t3a:="JOB IT: "
		MESSAGES OFF:C175
		//SEARCH([FG_Locations];[FG_Locations]ProductCode=[Finished_Goods]ProductCode;*)
		//SEARCH([FG_Locations]; & [FG_Locations]CustID=[Finished_Goods]CustID;*)
		//SEARCH([FG_Locations];[FG_Locations]Location="FG:@";*)
		//SEARCH([FG_Locations]; | [FG_Locations]Location="Ex:@";*)
		//SEARCH([FG_Locations]; & [FG_Locations]ProductCode=[Finished_Goods]ProductCode;*
		//SEARCH([FG_Locations]; & [FG_Locations]CustID=[Finished_Goods]CustID)
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
		uGetJobCosts4(->real6; ->real7; ->real8; ->real9; ->real10; ->real11; ->real12; ->real13; ->real14; ->real15)
		
		If (False:C215)  //kieth doesn't want this
			//get the excess costs
			QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]ProductCode:1=[Finished_Goods:26]ProductCode:1; *)
			QUERY:C277([Finished_Goods_Locations:35];  & ; [Finished_Goods_Locations:35]CustID:16=[Finished_Goods:26]CustID:2; *)
			QUERY:C277([Finished_Goods_Locations:35];  & ; [Finished_Goods_Locations:35]Location:2="CE:@")
			
			uGetJobCosts4(->real11; ->real12; ->real13; ->real14; ->real15)
		End if   //false
		
		//total the costs
		real1:=real6+real11
		real2:=real7+real12
		real3:=real8+real13
		real4:=real9+real14
		real5:=real10+real15
		
		MESSAGES ON:C181
End case 
//