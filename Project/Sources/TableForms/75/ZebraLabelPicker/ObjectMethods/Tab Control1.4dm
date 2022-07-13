//OM: iTabs() -> 
//@author Mel - 5/7/03  18:37
// Modified by: Mel Bohince (2/19/14) try to match intialization done in Zebra_LabelSetup before dicking with different styles
// Modified by: Mel Bohince (5/14/18) on elc v4, strip hyphens like the onload script  WHY IS NOT IN JUST ONE SCRIPT?? NO TIME TO BACK TEST MY FRIEND
C_TEXT:C284(mfg_code)
C_DATE:C307(wmsDateMfg)
$tabNumber:=Selected list items:C379(iTabs)
GET LIST ITEM:C378(iTabs; $tabNumber; $itemRef; labelStyle)
zwStatusMsg("LABEL STYLE"; labelStyle)
Zebra_ArkayBarcode
Case of 
	: (labelStyle="Arkay")
		If (Position:C15("PO# "; sPO)=0)
			sPO:="PO# "+sPO
		End if 
		
	: (labelStyle="Lauder")
		Zebra_Data_Lauder
		
	: (labelStyle="L’Oréal")
		sCriterion5:=""
		If (sCustId="00765")
			If (Position:C15("PO# "; sPO)=0)
				sPO:="PO# "+sPO
			End if 
			
			If (Not:C34(has_ChainOfCustody))
				sCriterion4:="NEW CODE: "+[Finished_Goods:26]AliasCPN:106
			Else 
				sCriterion4:=coc_num
			End if 
			
		Else 
			If (has_ChainOfCustody)
				sCriterion4:=coc_num
			Else 
				If (hasAlias)
					sCriterion4:="a.k.a.: "+[Finished_Goods:26]AliasCPN:106
				Else 
					sCriterion4:=""
				End if 
			End if 
		End if 
		
	: (labelStyle="P&G")
		If (Position:C15("PO# "; sPO)>0)
			sPO:=Replace string:C233(sPO; "PO# "; "")
		End if 
		If (hasAlias)
			sCriterion4:="LINKED CODE"  //certified
			sCriterion5:=[Finished_Goods:26]AliasCPN:106
		Else 
			sCriterion4:=""  //certified
			sCriterion5:=""
		End if 
		
	: (labelStyle="MH10.8")
		//allow but rare, only one to allow to address
		$cr:=Char:C90(13)
		$foundAddress:=qryAddress([Customers_Order_Lines:41]defaultShipTo:17)
		If ($foundAddress>0)
			tTo:=[Addresses:30]Name:2+$cr+[Addresses:30]Address1:3+$cr+[Addresses:30]City:6+"   "+[Addresses:30]State:7+"  "+[Addresses:30]Zip:8+$cr+[Addresses:30]Country:9
		End if 
		
		tFrom:=tFrom+$cr
		If (User in group:C338(Current user:C182; "Roanoke"))
			tFrom:=tFrom+"350 East Park Drive"+$cr
			tFrom:=tFrom+"Roanoke  VA  24019 USA"
		Else 
			tFrom:=tFrom+"100 Marcus Blvd. Suite 2"+$cr
			tFrom:=tFrom+"Hauppauge  NY  11788 USA"
		End if 
		
	: (labelStyle="custom")
		sDesc:=""
		rReal1:=0.75
		rReal2:=0.75
		rReal3:=1.5
		rReal13:=Round:C94(rReal3*(12/15); 2)
		rReal4:=1
		rReal12:=6
		
	: (labelStyle="Skid Labels")
		$barcodeValue:=WMS_SkidId(""; "set"; "2"; 0)
		SSCC_HumanReadable:=WMS_SkidId($barcodeValue; "human")
		SSCC_Barcode:=WMS_SkidId(SSCC_HumanReadable; "barcode")
		
		rbLabelType1:=1  //radio button to set skidLableText
		skidLableText:=""
		iNumberUp:=2  //number of labels to print for each skid label
		
	: (labelStyle="ShsdoChntcl")
		
		OBJECT SET ENTERABLE:C238(Zbra_tLabel_LotBatch; False:C215)
		OBJECT SET ENTERABLE:C238(Zbra_tLabel_Company; False:C215)
		OBJECT SET ENTERABLE:C238(Zbra_tLabel_MadeInUSA; False:C215)
		
		OBJECT SET BORDER STYLE:C1262(Zbra_tLabel_LotBatch; Border None:K42:27)
		OBJECT SET BORDER STYLE:C1262(Zbra_tLabel_Company; Border None:K42:27)
		OBJECT SET BORDER STYLE:C1262(Zbra_tLabel_MadeInUSA; Border None:K42:27)
		
		OBJECT SET RGB COLORS:C628(Zbra_tLabel_LotBatch; Foreground color:K23:1; Background color none:K23:10)
		OBJECT SET RGB COLORS:C628(Zbra_tLabel_Company; Foreground color:K23:1; Background color none:K23:10)
		OBJECT SET RGB COLORS:C628(Zbra_tLabel_MadeInUSA; Foreground color:K23:1; Background color none:K23:10)
		
		Case of 
				
			: ([Finished_Goods:26]CustID:2="01597")  //Shiseido
				
				Zbra_tLabel_LotBatch:="Lot Code:"
				Zbra_tLabel_Company:=Uppercase:C13("arkay packaging")
				Zbra_tLabel_MadeInUSA:="Made in USA"
				Zbra_tLabel_Title:="Shiseido"
				
			: ([Finished_Goods:26]CustID:2="02269")  //Chantecaille
				
				Zbra_tLabel_LotBatch:="Batch"
				Zbra_tLabel_Company:="Chantecaille"
				Zbra_tLabel_MadeInUSA:=CorektBlank
				Zbra_tLabel_Title:="Chantecaille"
				
			Else 
				
				OBJECT SET ENTERABLE:C238(Zbra_tLabel_LotBatch; True:C214)
				OBJECT SET ENTERABLE:C238(Zbra_tLabel_Company; True:C214)
				OBJECT SET ENTERABLE:C238(Zbra_tLabel_MadeInUSA; True:C214)
				
				OBJECT SET BORDER STYLE:C1262(Zbra_tLabel_LotBatch; Border Sunken:K42:31)
				OBJECT SET BORDER STYLE:C1262(Zbra_tLabel_Company; Border Sunken:K42:31)
				OBJECT SET BORDER STYLE:C1262(Zbra_tLabel_MadeInUSA; Border Sunken:K42:31)
				
				OBJECT SET RGB COLORS:C628(Zbra_tLabel_LotBatch; Foreground color:K23:1; Background color:K23:2)
				OBJECT SET RGB COLORS:C628(Zbra_tLabel_Company; Foreground color:K23:1; Background color:K23:2)
				OBJECT SET RGB COLORS:C628(Zbra_tLabel_MadeInUSA; Foreground color:K23:1; Background color:K23:2)
				
				Zbra_tLabel_Title:=CUST_getName([Finished_Goods:26]CustID:2)
				
		End case 
		
		If (Position:C15("PO# "; sPO)>0)
			sPO:=Replace string:C233(sPO; "PO# "; "")
		End if 
		
		sCriterion4:=""+[Finished_Goods:26]UPC:37+""
		sCriterion5:=[Finished_Goods:26]UPC:37
		
	: (labelStyle="ELC-v4")
		sCriterion1:="02"  //slow it down for quality
		If (Position:C15("PO# "; sPO)>0)
			sPO:=Replace string:C233(sPO; "PO# "; "")
		End if 
		
		mfg_code:=ELC_getMfgCode([Job_Forms_Items:44]ProductCode:3)
		$alias:=Replace string:C233([Finished_Goods:26]AliasCPN:106; "-"; "")  // Modified by: Mel Bohince (5/14/18)
		Case of 
			: (Length:C16($alias)=10)  //just add the code
				sCriterion4:=""+$alias+mfg_code+""  // Modified by: Mel Bohince (5/14/18) remove '*'
				sCriterion5:=$alias+mfg_code
				
			: (Length:C16($alias)=13)
				sCriterion4:=""+$alias+""
				sCriterion5:=$alias
			Else 
				$cpn:=Replace string:C233([Finished_Goods:26]ProductCode:1; "-"; "")
				sCriterion4:=""+$cpn+mfg_code+""
				sCriterion5:=$cpn+mfg_code
		End case 
		
	: (labelStyle="Revlon")
		
		If (Position:C15("PO# "; sPO)>0)
			sPO:=Replace string:C233(sPO; "PO# "; "")
		End if 
		
		sCriterion4:="fancydate"
		sCriterion5:=[Finished_Goods:26]AliasCPN:106
		
	: (labelStyle="Nest")
		If (Position:C15("PO# "; sPO)>0)
			sPO:=Replace string:C233(sPO; "PO# "; "")
		End if 
		
		sCriterion4:=""+[Finished_Goods:26]UPC:37+""
		sCriterion5:=[Finished_Goods:26]UPC:37
		
	: (labelStyle="LVMH")
		If (Position:C15("PO# "; sPO)>0)
			sPO:=Replace string:C233(sPO; "PO# "; "")
		End if 
		mfg_code:=Substring:C12([Job_Forms_Items:44]JobForm:1; 2; 4)  //ELC_getMfgCode ([Job_Forms_Items]ProductCode)
		$alias:=[Finished_Goods:26]AliasCPN:106
		sCriterion4:="02"+$alias+"10"+mfg_code+"37"+String:C10(wmsCaseQty)
		skidLableText:="(02)"+$alias+"(10)"+mfg_code+"(37)"+String:C10(wmsCaseQty)
		sCriterion5:=$alias
		
	Else 
		//no touch
End case 