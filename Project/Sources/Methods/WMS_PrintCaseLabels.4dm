//%attributes = {}
// Method: WMS_PrintCaseLabels () -> 
// ----------------------------------------------------
// by: mel: 01/21/05, 12:23:36
// ----------------------------------------------------
// Description:
// print labels for an entered jobit
// Updates:
//see http://www.planetlabel.com/ for sizes
// ----------------------------------------------------
//$currentPrinter:=Get current printer
//C_TEXT($aLocation;$aModel)
//PRINTERS LIST(◊aPrinterNames;$aLocation;$aModel)
//◊aPrinterNames{0}:=$currentPrinter
//◊aPrinterNames:=Find in array(◊aPrinterNames;$currentPrinter)

//$winRef:=Open form window([CONTROL];"SelectPrinter_dio")
//DIALOG([CONTROL];"SelectPrinter_dio")
//CLOSE WINDOW($winRef)

//util_PAGE_SETUP(->[WMS_ItemMaster];"CaseLabel_Laser")
// PDF_setUp (t1+".pdf")
//SET CURRENT PRINTER(◊aPrinterNames{0})
//Print form([WMS_ItemMaster];"CaseLabel_Laser")
//PAGE BREAK

C_TEXT:C284(sDesc)
C_TEXT:C284($caseID; wmsCaseId1; wmsCaseId2; wmsHumanReadable1; wmsHumanReadable2; $lot; $2; $form)
sDesc:="FINISH GOOD ITEM NOT FOUND"
C_DATE:C307(wmsDateMfg)
wmsDateMfg:=4D_Current_date
C_LONGINT:C283($style; $1; $numRecs; $numLabels; $first; wmsCaseNumber; wmsCaseQty)
C_LONGINT:C283($numCols; $numRows; $numberUp)
READ WRITE:C146([Job_Forms_Items:44])

If (Count parameters:C259=0)
	READ ONLY:C145([Customers:16])
	READ ONLY:C145([Finished_Goods:26])
	READ ONLY:C145([Finished_Goods_PackingSpecs:91])
	$style:=Num:C11(Request:C163("Number Up (1, 12, or 30):"))
	$lot:=Request:C163("Jobit:")
	
Else 
	$style:=$1
	$lot:=$2
End if 
If (Not:C34(<>modification4D_25_03_19))  // BEGIN 4D Professional Services : UNLOAD RECORD
	
	CUT NAMED SELECTION:C334([Job_Forms_Items:44]; "beforeLabeling")
	UNLOAD RECORD:C212([Job_Forms_Items:44])
	
Else 
	
	CUT NAMED SELECTION:C334([Job_Forms_Items:44]; "beforeLabeling")
	
End if   // END 4D Professional Services : January 2019 

$numRecs:=qryJMI($lot)

If (fLockNLoad(->[Job_Forms_Items:44])) & ($numRecs>0)
	$nextCaseNumPrinted:=[Job_Forms_Items:44]LastCase:41+1
	
	SET QUERY LIMIT:C395(1)
	$numRecs:=qryFinishedGood([Job_Forms_Items:44]CustId:15; [Job_Forms_Items:44]ProductCode:3)
	sDesc:=Uppercase:C13(Substring:C12([Finished_Goods:26]CartonDesc:3; 1; 80))
	QUERY:C277([Customers:16]; [Customers:16]ID:1=[Job_Forms_Items:44]CustId:15)
	If ([Finished_Goods_PackingSpecs:91]FileOutlineNum:1#[Finished_Goods:26]OutLine_Num:4)  //already on the pkspk
		QUERY:C277([Finished_Goods_PackingSpecs:91]; [Finished_Goods_PackingSpecs:91]FileOutlineNum:1=[Finished_Goods:26]OutLine_Num:4)
	End if 
	SET QUERY LIMIT:C395(0)
	If (Records in selection:C76([Finished_Goods_PackingSpecs:91])>0)
		wmsCaseQty:=[Finished_Goods_PackingSpecs:91]CaseCount:2
	Else 
		wmsCaseQty:=0
	End if 
	wmsCaseQty:=Num:C11(Request:C163("Case Quantity:"; String:C10(wmsCaseQty)))
	wmsDateMfg:=Date:C102(Request:C163("Date of Mfg:"; String:C10(wmsDateMfg; System date short:K1:1)))
	If ($nextCaseNumPrinted=1)
		$numLabels:=Num:C11(Request:C163("Number of Labels:"; String:C10(([Job_Forms_Items:44]Qty_Yield:9\wmsCaseQty)+1)))
	Else 
		$numLabels:=Num:C11(Request:C163("Number of Labels:"; "1"))
	End if 
	$first:=Num:C11(Request:C163("Beginning with:"; String:C10($nextCaseNumPrinted)))
	wmsCaseNumber:=$first
	//$elc:=ELC_isEsteeLauderCompany 
	sPO:=""
	sOF:=""
	$continue:=True:C214
	If (ELC_isEsteeLauderCompany([Job_Forms_Items:44]CustId:15))
		//$style:=121
		sPO:=Request:C163("PO Number: "; ""; "Print"; "No PO")
		If (ok=0)
			//$continue:=False
		End if 
	Else 
		sPO:=Request:C163("PO Number: "; ""; "Add PO"; "No PO")
		If (Length:C16(sPO)>0) & (ok=1)
			sPO:="PO#: "+sPO
		End if 
	End if 
	
	sOF:=Request:C163("Opening Force: "; ""; "Add OF"; "No OF")
	If (Length:C16(sOF)>0) & (ok=1)
		sOF:="OF: "+sOF
	End if 
	
	If ($continue)
		Case of 
			: ($style=30)
				$form:="CaseLabel_Laser_30up"
				$numCols:=3
				$numRows:=10
				$spacer:="Avery5920"
			: ($style=12)
				$form:="CaseLabel_Laser_12up"
				$numCols:=2
				$numRows:=6
				$spacer:=""
			: ($style=6)
				$form:="CaseLabel_Laser_6up"
				$numCols:=2
				$numRows:=3
				$spacer:="Avery5920"  //actually a 5164
				
			: ($style=121)
				$form:="EsteeLauder_Laser_6up"
				$numCols:=2  //1  `2 labels per case are required
				$numRows:=3
				$spacer:="Avery5920"  //actually a 5164
				sCPN:="*"+Replace string:C233([Job_Forms_Items:44]ProductCode:3; "-"; "")+"*"
				iCPN:=Replace string:C233([Job_Forms_Items:44]ProductCode:3; "-"; " ")
				sQty:="*"+String:C10(wmsCaseQty)+"*"
				
			: ($style=1)
				$form:="CaseLabel_Laser_1up"
				$numCols:=1
				$numRows:=1
				$spacer:=""
		End case 
		$numberUp:=$numCols*$numRows  //side by side, 2 col, 6 rows
		
		util_PAGE_SETUP(->[WMS_ItemMasters:123]; $form)
		PDF_setUp($lot+".pdf")
		
		$labels:=0
		$up:=0
		//print spacer
		If (Length:C16($spacer)>0)
			Print form:C5([WMS_ItemMasters:123]; $spacer)
		End if 
		
		While ($labels<$numLabels)
			$up:=$up+$numCols
			If ($up>$numberUp)
				PAGE BREAK:C6(>)
				$up:=$numCols
				If (Length:C16($spacer)>0)
					Print form:C5([WMS_ItemMasters:123]; $spacer)
				End if 
			End if 
			//no need to store the case Id until it is scanned in after the pallet build, at least thats today's plan.
			$caseID:=WMS_CaseId(""; "set"; $lot; wmsCaseNumber; wmsCaseQty)
			wmsCaseId1:=WMS_CaseId($caseID; "barcode")
			wmsHumanReadable1:=WMS_CaseId($caseID; "human")
			wmsCaseNumber1:=wmsCaseNumber
			wmsCaseNumber:=wmsCaseNumber+1
			
			If ($numCols>1) & (wmsCaseNumber>=$first)
				$caseID:=WMS_CaseId(""; "set"; $lot; wmsCaseNumber; wmsCaseQty)
				wmsCaseId2:=WMS_CaseId($caseID; "barcode")
				wmsHumanReadable2:=WMS_CaseId($caseID; "human")
				wmsCaseNumber2:=wmsCaseNumber
				wmsCaseNumber:=wmsCaseNumber+1
				If ($numCols>2) & (wmsCaseNumber>=$first)
					$caseID:=WMS_CaseId(""; "set"; $lot; wmsCaseNumber; wmsCaseQty)
					wmsCaseId3:=WMS_CaseId($caseID; "barcode")
					wmsHumanReadable3:=WMS_CaseId($caseID; "human")
					wmsCaseNumber3:=wmsCaseNumber
					wmsCaseNumber:=wmsCaseNumber+1
				Else 
					wmsCaseId3:=""
					wmsHumanReadable3:=""
					wmsCaseNumber3:=0
				End if 
			Else 
				wmsCaseId2:=""
				wmsHumanReadable2:=""
				wmsCaseNumber2:=0
			End if 
			
			Print form:C5([WMS_ItemMasters:123]; $form)
			
			$labels:=$labels+$numCols
			
		End while 
		PAGE BREAK:C6
		APPLY TO SELECTION:C70([Job_Forms_Items:44]; [Job_Forms_Items:44]LastCase:41:=wmsCaseNumber-1)
		If (Not:C34(<>modification4D_25_03_19))  // BEGIN 4D Professional Services : UNLOAD RECORD
			
			UNLOAD RECORD:C212([Job_Forms_Items:44])
			
		Else 
			
			// see line 213
			
			
		End if   // END 4D Professional Services : January 2019 
		
	End if 
	
Else 
	uConfirm("[JobMakesItem] record locked, can not print labels now."; "Later"; "OK")
End if 

USE NAMED SELECTION:C332("beforeLabeling")