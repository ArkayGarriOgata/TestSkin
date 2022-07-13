//%attributes = {}
// ----------------------------------------------------
// User name (OS): Mark Zinke
// Date and time: 03/22/13, 13:41:48
// ----------------------------------------------------
// Method: ControlCtrManageLB
// Description:
// Manages all the ListBoxes on the ControlCtr form.
// SetObjectProperties, Mark Zinke (5/16/13)
// ----------------------------------------------------

C_TEXT:C284($tDoWhat; $1)
C_LONGINT:C283($i; $xlLength)

$tDoWhat:=$1

Case of 
	: ($tDoWhat="ArtFillLB")
		ARRAY BOOLEAN:C223(abOK; 0)
		ARRAY TEXT:C222(atProdCode; 0)
		ARRAY TEXT:C222(atCtrlNum; 0)
		ARRAY DATE:C224(adSubmitted; 0)
		ARRAY DATE:C224(adPrepDone; 0)
		ARRAY DATE:C224(adQADone; 0)
		ARRAY DATE:C224(adSent; 0)
		ARRAY DATE:C224(adReturned; 0)
		ARRAY TEXT:C222(atService; 0)
		ARRAY LONGINT:C221(axlRecNums; 0)
		
		SetObjectProperties(""; ->axlRecNums; False:C215)
		
		QUERY:C277([Finished_Goods_Specifications:98]; [Finished_Goods_Specifications:98]ProjectNumber:4=pjtId)
		ORDER BY:C49([Finished_Goods_Specifications:98]; [Finished_Goods_Specifications:98]FG_Key:1; >; [Finished_Goods_Specifications:98]ControlNumber:2; <)
		
		SELECTION TO ARRAY:C260([Finished_Goods_Specifications:98]Approved:10; abOK; [Finished_Goods_Specifications:98]ProductCode:3; atProdCode; [Finished_Goods_Specifications:98]ControlNumber:2; atCtrlNum; [Finished_Goods_Specifications:98]DateSubmitted:5; adSubmitted; [Finished_Goods_Specifications:98]DatePrepDone:6; adPrepDone; [Finished_Goods_Specifications:98]DateProofRead:7; adQADone; [Finished_Goods_Specifications:98]DateSentToCustomer:8; adSent; [Finished_Goods_Specifications:98]DateReturned:9; adReturned; [Finished_Goods_Specifications:98]ServiceRequested:54; atService; [Finished_Goods_Specifications:98]; axlRecNums)
		
	: ($tDoWhat="Color")
		ARRAY BOOLEAN:C223(abOK; 0)
		ARRAY TEXT:C222(atID; 0)
		ARRAY TEXT:C222(atName1; 0)
		ARRAY DATE:C224(adSubmitted; 0)
		ARRAY DATE:C224(adDone; 0)
		ARRAY DATE:C224(adSent; 0)
		ARRAY DATE:C224(adReturned; 0)
		
		QUERY:C277([Finished_Goods_Color_SpecMaster:128]; [Finished_Goods_Color_SpecMaster:128]projectId:4=pjtId)
		If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4 GOTO SELECTED RECORD
			
			SELECTION TO ARRAY:C260([Finished_Goods_Color_SpecMaster:128]Approved:23; abOK; [Finished_Goods_Color_SpecMaster:128]id:1; atID; [Finished_Goods_Color_SpecMaster:128]name:2; atName1; [Finished_Goods_Color_SpecMaster:128]DateSubmitted:19; adSubmitted; [Finished_Goods_Color_SpecMaster:128]DateDone:20; adDone; [Finished_Goods_Color_SpecMaster:128]DateSent:21; adSent; [Finished_Goods_Color_SpecMaster:128]DateReturned:22; adReturned)
			
			ARRAY TEXT:C222(atDescription; Size of array:C274(abOK))
			For ($i; 1; Records in selection:C76([Finished_Goods_Color_SpecMaster:128]))
				atName1{$i}:=atID{$i}+"  "+atName1{$i}
				GOTO SELECTED RECORD:C245([Finished_Goods_Color_SpecMaster:128]; $i)
				atDescription{$i}:=""
				atDescription{$i}:=CSM_countColors
				$xlLength:=CSM_getVerboseStock(->atDescription{$i})
				atDescription{$i}:=atDescription{$i}+Char:C90(9)
				$xlLength:=CSM_getVerboseFinish(->atDescription{$i})
				
				
			End for 
		Else 
			
			ARRAY TEXT:C222($_stockType; 0)
			ARRAY REAL:C219($_stockCaliper; 0)
			ARRAY TEXT:C222($_stockPrecoat; 0)
			ARRAY TEXT:C222($_finishLaminationRMcode; 0)
			ARRAY TEXT:C222($_finishStamps; 0)
			ARRAY TEXT:C222($_finishGlossLevel; 0)
			ARRAY TEXT:C222($_finishProcess; 0)
			ARRAY TEXT:C222($_finishType; 0)
			
			SELECTION TO ARRAY:C260([Finished_Goods_Color_SpecMaster:128]Approved:23; abOK; \
				[Finished_Goods_Color_SpecMaster:128]id:1; atID; \
				[Finished_Goods_Color_SpecMaster:128]name:2; atName1; \
				[Finished_Goods_Color_SpecMaster:128]DateSubmitted:19; adSubmitted; \
				[Finished_Goods_Color_SpecMaster:128]DateDone:20; adDone; \
				[Finished_Goods_Color_SpecMaster:128]DateSent:21; adSent; \
				[Finished_Goods_Color_SpecMaster:128]DateReturned:22; adReturned; \
				[Finished_Goods_Color_SpecMaster:128]stockType:5; $_stockType; \
				[Finished_Goods_Color_SpecMaster:128]stockCaliper:6; $_stockCaliper; \
				[Finished_Goods_Color_SpecMaster:128]stockPrecoat:8; $_stockPrecoat; \
				[Finished_Goods_Color_SpecMaster:128]finishLaminationRMcode:15; $_finishLaminationRMcode; \
				[Finished_Goods_Color_SpecMaster:128]finishStamps:14; $_finishStamps; \
				[Finished_Goods_Color_SpecMaster:128]finishGlossLevel:13; $_finishGlossLevel; \
				[Finished_Goods_Color_SpecMaster:128]finishProcess:12; $_finishProcess; \
				[Finished_Goods_Color_SpecMaster:128]finishType:11; $_finishType)
			
			ARRAY TEXT:C222(atDescription; Size of array:C274(abOK))
			C_TEXT:C284($text)
			C_TEXT:C284($t)
			$t:=", "
			
			For ($i; 1; Size of array:C274($_finishType); 1)
				atName1{$i}:=atID{$i}+"  "+atName1{$i}
				atDescription{$i}:=""
				C_LONGINT:C283($numColors)
				READ ONLY:C145([Finished_Goods_Color_SpecSolids:129])
				$numColors:=0  // Modified by: Mel Bohince (6/9/21) 
				SET QUERY DESTINATION:C396(Into variable:K19:4; $numColors)
				QUERY:C277([Finished_Goods_Color_SpecSolids:129]; [Finished_Goods_Color_SpecSolids:129]masterSet:3=atID{$i}; *)
				QUERY:C277([Finished_Goods_Color_SpecSolids:129];  & ; [Finished_Goods_Color_SpecSolids:129]colorName:10#"")
				SET QUERY DESTINATION:C396(Into current selection:K19:1)
				REDUCE SELECTION:C351([Finished_Goods_Color_SpecSolids:129]; 0)
				atDescription{$i}:=String:C10($numColors)+"/c; "
				$text:=""
				$text:=$_stockType{$i}+$t+\
					String:C10($_stockCaliper{$i}; "0.000###")+$t+\
					$_stockPrecoat{$i}+"; "
				$text:=Replace string:C233($text; " None "; "")
				$text:=Replace string:C233($text; $t+$t; "")
				atDescription{$i}:=atDescription{$i}+$text
				$xlLength:=Length:C16($text)
				atDescription{$i}:=atDescription{$i}+Char:C90(9)
				$text:=""
				$text:=$_finishType{$i}+$t+\
					$_finishProcess{$i}+$t+\
					$_finishGlossLevel{$i}+$t+\
					$_finishStamps{$i}+$t
				$text:=$text+$_finishLaminationRMcode{$i}+$t+\
					$_finishLaminationRMcode{$i}+"."
				$text:=Replace string:C233($text; " None "; "")
				$text:=Replace string:C233($text; $t+$t; "")
				atDescription{$i}:=atDescription{$i}+$text
				$xlLength:=Length:C16($text)
				
			End for 
		End if   // END 4D Professional Services : January 2019 query selection
		
		
	: ($tDoWhat="SSFillLB")
		ARRAY BOOLEAN:C223(abOK; 0)
		ARRAY TEXT:C222(atFileNum; 0)
		ARRAY DATE:C224(adDateSubmitted; 0)
		ARRAY DATE:C224(adDateWanted; 0)
		ARRAY DATE:C224(adDateDone; 0)
		ARRAY DATE:C224(adDateApproved; 0)
		ARRAY TEXT:C222(atCustCodeNum; 0)
		ARRAY TEXT:C222(atStandard; 0)
		ARRAY TEXT:C222(atStyle; 0)
		ARRAY TEXT:C222(atSSTop; 0)
		ARRAY TEXT:C222(atSSBottom; 0)
		ARRAY LONGINT:C221(axlRecNums; 0)
		
		SetObjectProperties(""; ->axlRecNums; False:C215)
		
		QUERY:C277([Finished_Goods_SizeAndStyles:132]; [Finished_Goods_SizeAndStyles:132]ProjectNumber:2=pjtId)
		ORDER BY:C49([Finished_Goods_SizeAndStyles:132]; [Finished_Goods_SizeAndStyles:132]FileOutlineNum:1; <)
		
		SELECTION TO ARRAY:C260([Finished_Goods_SizeAndStyles:132]Approved:9; abOK; [Finished_Goods_SizeAndStyles:132]FileOutlineNum:1; atFileNum; [Finished_Goods_SizeAndStyles:132]DateSubmitted:5; adDateSubmitted; [Finished_Goods_SizeAndStyles:132]DateWanted:42; adDateWanted; [Finished_Goods_SizeAndStyles:132]DateDone:6; adDateDone; [Finished_Goods_SizeAndStyles:132]DateApproved:8; adDateApproved; [Finished_Goods_SizeAndStyles:132]CustomerCodeNumber:45; atCustCodeNum; [Finished_Goods_SizeAndStyles:132]Standard:13; atStandard; [Finished_Goods_SizeAndStyles:132]Style:14; atStyle; [Finished_Goods_SizeAndStyles:132]Top:15; atSSTop; [Finished_Goods_SizeAndStyles:132]Bottom:16; atSSBottom; [Finished_Goods_SizeAndStyles:132]; axlRecNums)
		
	: ($tDoWhat="EstimatesFillLB")
		ARRAY TEXT:C222(atJobType; 0)
		ARRAY TEXT:C222(atEstimateNum; 0)
		ARRAY TEXT:C222(atStatus; 0)
		ARRAY DATE:C224(adModDate; 0)
		ARRAY DATE:C224(adDateRFQd; 0)
		ARRAY DATE:C224(adDateEstimated; 0)
		ARRAY DATE:C224(adDatePriced; 0)
		ARRAY TEXT:C222(atPONum; 0)
		ARRAY TEXT:C222(atContactAgent; 0)
		ARRAY LONGINT:C221(axlRecNums; 0)
		C_LONGINT:C283(xlDateStart; xlDateEnd)
		C_TEXT:C284(tModDateStart; tModDateEnd)
		
		SetObjectProperties(""; ->axlRecNums; False:C215)
		
		ARRAY TEXT:C222(atTextPick; 7)
		atTextPick{1}:=""
		atTextPick{2}:="Today"
		atTextPick{3}:="Yesterday"
		atTextPick{4}:="This Week"
		atTextPick{5}:="Last Week"
		atTextPick{6}:="This Month"
		atTextPick{7}:="Older"
		
		QUERY:C277([Estimates:17]; [Estimates:17]ProjectNumber:63=pjtId)
		
		SELECTION TO ARRAY:C260([Estimates:17]JobType:29; atJobType; [Estimates:17]EstimateNo:1; atEstimateNum; [Estimates:17]Status:30; atStatus; [Estimates:17]ModDate:37; adModDate; [Estimates:17]DateRFQ:52; adDateRfqd; [Estimates:17]DateEstimated:64; adDateEstimated; [Estimates:17]DatePrice:60; adDatePriced; [Estimates:17]POnumber:18; atPONum; [Estimates:17]z_Contact_Agent:43; atContactAgent; [Estimates:17]; axlRecNums)
		LISTBOX SORT COLUMNS:C916(abEstimateLB; 2; <)
		
		//Handle the date filter
		QUERY:C277([UserPrefs:184]; [UserPrefs:184]UserName:2=Current user:C182; *)
		QUERY:C277([UserPrefs:184];  & ; [UserPrefs:184]PrefType:4="EstDateFilter")
		
		If (Records in selection:C76([UserPrefs:184])=0)
			READ WRITE:C146([UserPrefs:184])
			CREATE RECORD:C68([UserPrefs:184])
			[UserPrefs:184]UserName:2:=Current user:C182
			[UserPrefs:184]PrefType:4:="EstDateFilter"
			[UserPrefs:184]LongIntField:7:=0
			[UserPrefs:184]LongIntField2:12:=0
			[UserPrefs:184]TextField:5:=""
			[UserPrefs:184]TextField2:3:=""
			SAVE RECORD:C53([UserPrefs:184])
		End if 
		
		xlDateStart:=[UserPrefs:184]LongIntField:7
		xlDateEnd:=[UserPrefs:184]LongIntField2:12
		tModDateStart:=[UserPrefs:184]TextField:5
		tModDateEnd:=[UserPrefs:184]TextField2:3
		
		Est_FilterEstimates(True:C214)
		
	: ($tDoWhat="OrderFillLB")
		ARRAY TEXT:C222(atOrderLine; 0)
		ARRAY TEXT:C222(atPONum; 0)
		ARRAY TEXT:C222(atCPN; 0)
		ARRAY LONGINT:C221(axlQtyOpen; 0)
		ARRAY LONGINT:C221(axlShipped; 0)
		ARRAY REAL:C219(axrCost; 0)
		ARRAY REAL:C219(axrPrice; 0)
		ARRAY TEXT:C222(atStatus; 0)
		ARRAY DATE:C224(adOpened; 0)
		ARRAY DATE:C224(adNeeded; 0)
		ARRAY LONGINT:C221(axlRecNums; 0)
		
		SetObjectProperties(""; ->axlRecNums; False:C215)
		
		QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]ProjectNumber:50=pjtId)
		ORDER BY:C49([Customers_Order_Lines:41]; [Customers_Order_Lines:41]ProductCode:5; >; [Customers_Order_Lines:41]OrderLine:3; <)
		
		SELECTION TO ARRAY:C260([Customers_Order_Lines:41]OrderLine:3; atOrderLine; [Customers_Order_Lines:41]PONumber:21; atPONum; [Customers_Order_Lines:41]ProductCode:5; atCPN; [Customers_Order_Lines:41]Qty_Open:11; axlQtyOpen; [Customers_Order_Lines:41]Qty_Shipped:10; axlShipped; [Customers_Order_Lines:41]Cost_Per_M:7; axrCost; [Customers_Order_Lines:41]Price_Per_M:8; axrPrice; [Customers_Order_Lines:41]Status:9; atStatus; [Customers_Order_Lines:41]DateOpened:13; adOpened; [Customers_Order_Lines:41]NeedDate:14; adNeeded; [Customers_Order_Lines:41]; axlRecNums)
		
	: ($tDoWhat="JobFillLB")
		ARRAY TEXT:C222(atJobType; 0)
		ARRAY TEXT:C222(atJobID; 0)
		ARRAY TEXT:C222(atStatus; 0)
		ARRAY DATE:C224(adStartDate; 0)
		ARRAY DATE:C224(adCompDate; 0)
		ARRAY DATE:C224(adClosedDate; 0)
		ARRAY DATE:C224(adNeedDate; 0)
		ARRAY REAL:C219(axrPldTotal; 0)
		ARRAY REAL:C219(axrActCost; 0)
		ARRAY INTEGER:C220(axiVersion; 0)
		ARRAY TEXT:C222(atProcSpec; 0)
		ARRAY LONGINT:C221(axlRecNums; 0)
		
		SetObjectProperties(""; ->axlRecNums; False:C215)
		
		QUERY:C277([Job_Forms:42]; [Job_Forms:42]ProjectNumber:56=pjtId)
		ORDER BY:C49([Job_Forms:42]; [Job_Forms:42]JobFormID:5; <)
		
		SELECTION TO ARRAY:C260([Job_Forms:42]JobType:33; atJobType; [Job_Forms:42]JobFormID:5; atJobID; [Job_Forms:42]Status:6; atStatus; [Job_Forms:42]StartDate:10; adStartDate; [Job_Forms:42]Completed:18; adCompDate; [Job_Forms:42]ClosedDate:11; adClosedDate; [Job_Forms:42]NeedDate:1; adNeedDate; [Job_Forms:42]Pld_CostTtl:14; axrPldTotal; [Job_Forms:42]ActFormCost:13; axrActCost; [Job_Forms:42]VersionNumber:57; axiVersion; [Job_Forms:42]ProcessSpec:46; atProcSpec; [Job_Forms:42]; axlRecNums)
		
	: ($tDoWhat="FilterEstimates")
		Est_FilterEstimates(True:C214)
		
	: ($tDoWhat="F/G")
		ARRAY TEXT:C222(atOrigOrRepeat; 0)
		ARRAY TEXT:C222(atCustID; 0)
		ARRAY TEXT:C222(atProdCode; 0)
		ARRAY TEXT:C222(atCartonDesc; 0)
		ARRAY TEXT:C222(atColorSpecMaster; 0)
		ARRAY TEXT:C222(atOutlineNum; 0)
		ARRAY TEXT:C222(atCtrlNum; 0)
		ARRAY DATE:C224(adDateSS; 0)
		ARRAY LONGINT:C221(axlRecNums; 0)
		
		SetObjectProperties(""; ->axlRecNums; False:C215)
		
		QUERY:C277([Finished_Goods:26]; [Finished_Goods:26]ProjectNumber:82=pjtId)
		ORDER BY:C49([Finished_Goods:26]; [Finished_Goods:26]FG_KEY:47; >)
		
		SELECTION TO ARRAY:C260([Finished_Goods:26]OriginalOrRepeat:71; atOrigOrRepeat; [Finished_Goods:26]CustID:2; atCustID; [Finished_Goods:26]ProductCode:1; atProdCode; [Finished_Goods:26]CartonDesc:3; atCartonDesc; [Finished_Goods:26]ColorSpecMaster:77; atColorSpecMaster; [Finished_Goods:26]OutLine_Num:4; atOutlineNum; [Finished_Goods:26]ControlNumber:61; atCtrlNum; [Finished_Goods:26]DateSnS_Approved:83; adDateSS; [Finished_Goods:26]DateArtApproved:46; adDateArt; [Finished_Goods:26]; axlRecNums)
		
	: ($tDoWhat="SuptItem")
		//Top
		ARRAY TEXT:C222(atID; 0)
		ARRAY TEXT:C222(atItemTypes; 0)
		ARRAY TEXT:C222(atLocation; 0)
		ARRAY DATE:C224(adExpDate; 0)
		ARRAY TEXT:C222(atDescription; 0)
		ARRAY LONGINT:C221(axlRecNums; 0)
		
		SetObjectProperties(""; ->axlRecNums; False:C215)
		
		SELECTION TO ARRAY:C260([JPSI_Job_Physical_Support_Items:111]ID:1; atID; [JPSI_Job_Physical_Support_Items:111]ItemType:2; atItemTypes; [JPSI_Job_Physical_Support_Items:111]Location:5; atLocation; [JPSI_Job_Physical_Support_Items:111]DateOfExpiration:8; adExpDate; [JPSI_Job_Physical_Support_Items:111]Description:4; atDescription; [JPSI_Job_Physical_Support_Items:111]; axlRecNums)
		
		//Bottom
		ARRAY TEXT:C222(atJobForm; 0)
		ARRAY TEXT:C222(atLocationBottom; 0)
		ARRAY LONGINT:C221(axlRecNumsB; 0)
		
		SetObjectProperties(""; ->axlRecNumsB; False:C215)
		
		If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4 GOTO SELECTED RECORD
			SELECTION TO ARRAY:C260([JTB_Job_Transfer_Bags:112]Jobform:3; atJobForm; [JTB_Job_Transfer_Bags:112]Location:4; atLocationBottom; [JTB_Job_Transfer_Bags:112]; axlRecNumsB)
			
			ARRAY TEXT:C222(atName2; Records in selection:C76([JTB_Job_Transfer_Bags:112]))
			For ($i; 1; Records in selection:C76([JTB_Job_Transfer_Bags:112]))
				GOTO SELECTED RECORD:C245([JTB_Job_Transfer_Bags:112]; $i)
				atName2{$i}:=Pjt_getName([JTB_Job_Transfer_Bags:112]PjtNumber:2)
			End for 
			
		Else 
			ARRAY TEXT:C222($_PjtNumber; 0)
			
			SELECTION TO ARRAY:C260([JTB_Job_Transfer_Bags:112]Jobform:3; atJobForm; \
				[JTB_Job_Transfer_Bags:112]Location:4; atLocationBottom; \
				[JTB_Job_Transfer_Bags:112]; axlRecNumsB; \
				[JTB_Job_Transfer_Bags:112]PjtNumber:2; $_PjtNumber)
			
			ARRAY TEXT:C222(atName2; Records in selection:C76([JTB_Job_Transfer_Bags:112]))
			For ($i; 1; Size of array:C274($_PjtNumber); 1)
				atName2{$i}:=Pjt_getName($_PjtNumber{$i})
			End for 
			
		End if   // END 4D Professional Services : January 2019 query selection
		
		
End case 