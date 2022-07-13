//(lp) FgCostingRpt3
//•1/31/97 -cs- modifed to print from arrays, and reduce number of
//searches done during the 'During' phase of this report
//to speed up its printing time.
//•1/31/97 added code to saev report to disk if requested

C_TEXT:C284($Tab; $Cr)
C_TEXT:C284($num)
$Num:="##,###,###,##0"  //format for numbers if saving to disk
$Tab:=Char:C90(9)
$Cr:=Char:C90(13)

Case of 
	: (Form event code:C388=On Display Detail:K2:22)  //each f/g record
		t3a:="JOB IT: "
		MESSAGES OFF:C175
		//• 1/28/97 cs removed below for speed, printing from arrays
		//SEARCH([FG_Locations];[FG_Locations]ProductCode=[Finished_Goods
		//«]ProductCode;*)
		//SEARCH([FG_Locations]; & [FG_Locations]CustID=[Finished_Goods]CustID;*
		//«)
		//SEARCH([FG_Locations]; & [FG_Locations]Location="Ex:@")
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
		//1/31/97 added 2 parameters to ugetjobcosts4 & other internal mods
		uGetJobCosts5(->real6; ->real7; ->real8; ->real9; ->real10; ->real11; ->real12; ->real13; ->real14; ->real15; ->[Finished_Goods:26]ProductCode:1; ->[Finished_Goods:26]CustID:2)
		//total the costs
		real1:=real6+real11
		real2:=real7+real12
		real3:=real8+real13
		real4:=real9+real14  //burden - total
		real5:=real10+real15
		
		If (fSave)  //•1/31/97 if saving to disk, setup in monthendsuite
			SEND PACKET:C103(vDoc; [Finished_Goods:26]ProductCode:1+$Tab)
			SEND PACKET:C103(vDoc; String:C10(Real1; $Num)+$Tab+String:C10(Real2; $Num)+$Tab+String:C10(Real3; $Num)+$Tab+String:C10(Real4; $Num)+$Tab+String:C10(Real5; $Num)+$Tab)
			SEND PACKET:C103(vDoc; String:C10(Real6; $Num)+$Tab+String:C10(Real7; $Num)+$Tab+String:C10(Real8; $Num)+$Tab+String:C10(Real9; $Num)+$Tab+String:C10(Real10; $Num)+$Tab)
			SEND PACKET:C103(vDoc; String:C10(Real11; $Num)+$Tab+String:C10(Real12; $Num)+$Tab+String:C10(Real13; $Num)+$Tab+String:C10(Real14; $Num)+$Tab+String:C10(Real15; $Num))
			SEND PACKET:C103(vDoc; $Tab+t3a+$Cr)
		End if 
		
	: (Form event code:C388=On Printing Break:K2:19) & (Level:C101=1) & (fSave)  //•1/31/97 if saving to disk
		SEND PACKET:C103(vDoc; "Customer Totals:"+$Tab)
		SEND PACKET:C103(vDoc; String:C10(Real1a; $Num)+$Tab+String:C10(Real2a; $Num)+$Tab+String:C10(Real3a; $Num)+$Tab+String:C10(Real4a; $Num)+$Tab+String:C10(Real5a; $Num)+$Tab)
		SEND PACKET:C103(vDoc; String:C10(Real6a; $Num)+$Tab+String:C10(Real7a; $Num)+$Tab+String:C10(Real8a; $Num)+$Tab+String:C10(Real9a; $Num)+$Tab+String:C10(Real10a; $Num)+$Tab)
		SEND PACKET:C103(vDoc; String:C10(Real11a; $Num)+$Tab+String:C10(Real12a; $Num)+$Tab+String:C10(Real13a; $Num)+$Tab+String:C10(Real14a; $Num)+$Tab+String:C10(Real15a; $Num)+$Cr)
		
	: (Form event code:C388=On Printing Break:K2:19) & (Level:C101=0) & (fSave)  //•1/31/97 if saving to disk
		SEND PACKET:C103(vDoc; $Cr+"Arkay Totals:"+$Tab)
		SEND PACKET:C103(vDoc; String:C10(Real1t; $Num)+$Tab+String:C10(Real2t; $Num)+$Tab+String:C10(Real3t; $Num)+$Tab+String:C10(Real4t; $Num)+$Tab+String:C10(Real5t; $Num)+$Tab)
		SEND PACKET:C103(vDoc; String:C10(Real6t; $Num)+$Tab+String:C10(Real7t; $Num)+$Tab+String:C10(Real8t; $Num)+$Tab+String:C10(Real9t; $Num)+$Tab+String:C10(Real10t; $Num)+$Tab)
		SEND PACKET:C103(vDoc; String:C10(Real11t; $Num)+$Tab+String:C10(Real12t; $Num)+$Tab+String:C10(Real13t; $Num)+$Tab+String:C10(Real14t; $Num)+$Tab+String:C10(Real15t; $Num)+$Cr)
		SEND PACKET:C103(vDoc; $Cr+$Cr)
End case 
//