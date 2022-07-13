//%attributes = {"publishedWeb":true}
//PM: Zebra_LabelSetup(jobit;labelStyle) -> 
//@author mlb - 11/6/01  10:00
//put in some overrides 02/19/08
// Modified by: Mel Bohince (2/13/14) use Loreal style if not P&G, Lauder, and [FG]AliasCPN not null
// Modified by: Mel Bohince (2/14/14) choose label style based on hasAlias

C_TEXT:C284(sJMI; $1; $2; labelStyle; $cr)
C_LONGINT:C283($i; $numJMI; iItemNumber; iLastLabel; iTabs; wmsCaseNumber1; wmsCaseQty; wmsSkidNumber; iNumberUp)
C_DATE:C307(dDate; wmsDateMfg)
C_TEXT:C284(coc_num)
C_BOOLEAN:C305($continue; hasAlias; has_ChainOfCustody)
$continue:=True:C214
//[Job_Forms_Items]LastCase
//[Job_Forms_Items]LastSkid
sJMI:=$1

labelStyle:=$2
READ ONLY:C145([Job_Forms_Items:44])
$numJMI:=qryJMI(sJMI)
If ($numJMI>0)
	sCustId:=[Job_Forms_Items:44]CustId:15
	
	coc_num:=RM_isCertified_FSC_orSFI("jobit"; sJMI)
	If (Length:C16(coc_num)>0)
		coc_num:=" "+Replace string:C233(coc_num; Char:C90(13); " ")
		has_ChainOfCustody:=True:C214
	End if 
	
	dDate:=4D_Current_date
	//iItemNumber:=0`this was to set the last used label on the jmi record
	iLastLabel:=0
	$cr:=Char:C90(13)
	READ ONLY:C145([z_administrators:2])
	ALL RECORDS:C47([z_administrators:2])
	tFrom:=[z_administrators:2]CompanyName:2
	
	READ ONLY:C145([Finished_Goods:26])
	RELATE ONE:C42([Job_Forms_Items:44]ProductCode:3)
	sCPN:=[Job_Forms_Items:44]ProductCode:3
	sDesc:=Substring:C12(Replace string:C233([Finished_Goods:26]CartonDesc:3; $cr; ","); 1; 45)
	hasAlias:=(Length:C16([Finished_Goods:26]AliasCPN:106)>0)
	READ ONLY:C145([Customers:16])
	RELATE ONE:C42([Job_Forms_Items:44]CustId:15)
	tTo:=[Customers:16]ShortName:57
	
	READ ONLY:C145([Customers_Order_Lines:41])
	RELATE ONE:C42([Job_Forms_Items:44]OrderItem:2)
	If (Records in selection:C76([Customers_Order_Lines:41])>0)  //get po#
		sPO:=[Customers_Order_Lines:41]PONumber:21+coc_num  //over-ridden by the lauder label to just coc#
	Else 
		sPO:=coc_num
	End if 
	
	Case of   //put in some overrides     02/19/08
			// moved lauder test up 6/26/08
		: (ELC_isEsteeLauderCompany(sCustId))
			If (labelStyle#"ELC-v4")
				labelStyle:="Lauder"  //force new label
			End if 
			
		: (labelStyle="MH10.8")
			//allow but rare, only one to allow to address
			$foundAddress:=qryAddress([Customers_Order_Lines:41]defaultShipTo:17)
			If ($foundAddress>0)
				tTo:=[Addresses:30]Name:2+$cr+[Addresses:30]Address1:3+$cr+[Addresses:30]City:6+"   "+[Addresses:30]State:7+"  "+[Addresses:30]Zip:8+$cr+[Addresses:30]Country:9
			End if 
			
			tFrom:=tFrom+$cr
			If (User in group:C338(Current user:C182; "Roanoke"))
				tFrom:=tFrom+"350 East Park Drive"+$cr
				tFrom:=tFrom+"Roanoke  VA  24019 USA"
			Else 
				tFrom:=tFrom+[z_administrators:2]DefaultShipTo2:6+$cr
				tFrom:=tFrom+[z_administrators:2]DefaultShipTo3:7
			End if 
			
		: (labelStyle="Landscape")  //depreciated
			labelStyle:="Arkay"
			
		: (labelStyle="Mary Kay")  //depreciated
			labelStyle:="Arkay"
			
		: (labelStyle="Lauder")  //depreciated
			labelStyle:="Lauder"
			
			//next test gives bad result on unspecified lauder labels so it was moved down 6/26/08,
		: (Length:C16(labelStyle)<3)  //unspecifed
			labelStyle:="Arkay"
			
		Else 
			//use what is passed, such as p&g, loreal
	End case 
	
	//remove characters that are bad for zebra
	For ($i; 1; Length:C16(tTo))  //tTo:=Replace string(tTo;Char(142);"e")`tTo:=Replace string(tTo;"ô";"o")  doesn't work
		Case of 
			: (Character code:C91(tTo[[$i]])=142)
				tTo[[$i]]:="e"
			: (Character code:C91(tTo[[$i]])=153)
				tTo[[$i]]:="o"
		End case 
	End for 
	
	tToName:=tTo  // Modified by: Mel Bohince (3/27/18) 
	iQty:=[Finished_Goods_PackingSpecs:91]CaseCount:2
	//guess how many labels are needed
	If (iQty#0)
		iCnt:=Int:C8([Job_Forms_Items:44]Qty_Yield:9/iQty)
	Else 
		iCnt:=1
	End if 
	
	If (Current user:C182="Designer") | (Current user:C182="Administrator")  //so tests don't forget to reduce the number of labels
		iCnt:=1
	End if 
	
	sOF:=[Finished_Goods_PackingSpecs:91]OpeningForce:33
	If (Length:C16(sOF)>0)
		sOF:="OF:  "+sOF
	End if 
	
	Zebra_ArkayBarcode
	
	Case of   //special data requirements based on customers
		: (ELC_isEsteeLauderCompany(sCustId))
			Zebra_Data_Lauder
			
		: (sCustId="00765")  //L’Oréal
			sPO:="PO# "+sPO
			If (Not:C34(has_ChainOfCustody))
				sCriterion4:="NEW CODE: "+[Finished_Goods:26]AliasCPN:106
			Else 
				sCriterion4:=coc_num
			End if 
			sCriterion5:=""
			
		: (sCustId="01469")  //Zirh
			sPO:="PO# "+sPO
			sCriterion4:="NEW CODE: "+[Finished_Goods:26]AliasCPN:106
			sCriterion5:=""
			
		: (sCustId="00199") | (sCustId="01359")  //P&G's
			If (hasAlias)
				sCriterion4:="LINKED CODE"  //certified
				sCriterion5:=[Finished_Goods:26]AliasCPN:106
			Else 
				sCriterion4:=""  //certified
				sCriterion5:=""
			End if 
			
		: (sCustId="01597") | (sCustId="01805")  //shiseido
			If (Position:C15("PO# "; sPO)>0)
				sPO:=Replace string:C233(sPO; "PO# "; "")
			End if 
			
			sCriterion4:="*"+[Finished_Goods:26]UPC:37+"*"
			sCriterion5:=[Finished_Goods:26]UPC:37
			
		: (has_ChainOfCustody)
			sCriterion4:=coc_num
			labelStyle:="loreal"
			
		: (hasAlias)
			sCriterion4:="a.k.a.: "+[Finished_Goods:26]AliasCPN:106
			labelStyle:="loreal"
			
		Else 
			sPO:="PO# "+sPO
			sCriterion4:=""  //certified
			sCriterion5:=""  //item      
	End case 
	
	If ($continue)
		iTabs:=0
		windowTitle:="Pick Zebra Label Style for jobit "+sJMI
		$winRef:=OpenFormWindow(->[WMS_Label_Tracking:75]; "ZebraLabelPicker"; ->windowTitle; windowTitle)
		DIALOG:C40([WMS_Label_Tracking:75]; "ZebraLabelPicker")
		CLOSE WINDOW:C154($winRef)
		
		//If (iItemNumber>0)  `return unused
		//iItemNumber:=WMS_setNextItemId (->[WMS_ItemMasters];iItemNumber)
		//End if 
	End if 
	
Else 
	BEEP:C151
	uConfirm(sJMI+" was not found"; "Try again"; "Help")
End if 