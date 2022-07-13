//%attributes = {}
// -------
// Method: Zebra_DesignerPro_CaseLabelData   ( ) ->
// By: Mel Bohince @ 06/21/17, 11:47:02
// Description
// 
// ----------------------------------------------------
// Modified by: Mel Bohince (7/19/17) repeat columns taht are likely to be barcoded for sake of DesignerPro template, add custname and Opening force
// Modified by: Mel Bohince (8/4/17) offer to use alias instead of cpn
// Modified by: Mel Bohince (11/9/17) encode dom date with a letter month
// Modified by: Mel Bohince (1/22/18) remove unnecessary questions, send one label, let zebradesigner count number to make since case id is not used.

C_TEXT:C284($codedDOM; $lot; $text; $docName; $Desc; $custname)
C_LONGINT:C283($numRecs; $nextCaseNumPrinted; $numLabels; $first; $label)
C_BOOLEAN:C305($useCaseID)
//uConfirm ("Use case_id for lot?";"Case_id";"Jobit")
//If (ok=1)
//$useCaseID:=True
//Else 
$useCaseID:=False:C215
//End if 

$lot:=Request:C163("Jobit:"; [Job_Forms_Items:44]Jobit:4; "Ok"; "Cancel")
If (ok=1)
	//uConfirm ("Use Product Code or Alias?";"Product Code";"Alias")  // Modified by: Mel Bohince (8/4/17) 
	//If (ok=1)
	//$useCPN:=True
	//Else 
	//$useCPN:=False
	READ ONLY:C145([Finished_Goods:26])
	//End if 
	
	$numRecs:=qryJMI($lot)
	If ($numRecs>0)
		C_TIME:C306($docRef)
		
		$title:=""
		$text:=""
		$docName:=[Job_Forms_Items:44]Jobit:4+"-"+fYYMMDD(4D_Current_date)+"_"+Replace string:C233(String:C10(4d_Current_time; <>HHMM); ":"; "")+".txt"
		$docRef:=util_putFileName(->$docName)
		If ($docRef#?00:00:00?)
			
			If (fLockNLoad(->[Job_Forms_Items:44])) & ($numRecs>0)
				$nextCaseNumPrinted:=[Job_Forms_Items:44]LastCase:41+1
				
				SET QUERY LIMIT:C395(1)
				$numRecs:=qryFinishedGood([Job_Forms_Items:44]CustId:15; [Job_Forms_Items:44]ProductCode:3)
				$Desc:=Uppercase:C13(Substring:C12([Finished_Goods:26]CartonDesc:3; 1; 80))
				QUERY:C277([Customers:16]; [Customers:16]ID:1=[Job_Forms_Items:44]CustId:15)
				$custname:=[Customers:16]ShortName:57
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
				wmsDateMfg:=[Job_Forms_Items:44]Glued:33
				//wmsDateMfg:=Current date
				wmsDateMfg:=Date:C102(Request:C163("Date of Mfg:"; String:C10(wmsDateMfg; System date short:K1:1)))
				$codedDOM:=(Char:C90(64+Month of:C24(wmsDateMfg)))+String:C10(Day of:C23(wmsDateMfg); "00")+Substring:C12(String:C10(Year of:C25(wmsDateMfg); "0000"); 3)
				
				If ($nextCaseNumPrinted=1)
					$numLabels:=1  //Num(Request("Number of Labels:";String(([Job_Forms_Items]Qty_Yield\wmsCaseQty)+1)))
				Else 
					$numLabels:=1  //Num(Request("Number of Labels:";"1"))
				End if 
				$first:=1  //Num(Request("Beginning with:";String($nextCaseNumPrinted)))
				wmsCaseNumber:=$first
				
				sPO:=""
				sPO:=Request:C163("PO Number: "; ""; "Add PO"; "No PO")
				
				sOF:=""
				//sOF:=Request("Opening Force: ";"";"Add OF";"No OF")
				//If (ok=1) & (Length(sOF)>0)
				//sOF:="O/F:"+sOF
				//End if 
				
				//repeat columns that are likely to be barcoded
				$text:="sku\talias\tjobit\tdesc\tpo\tof\tqty\tdate_mfg\tcaseid\tcustname\t"+"bc_sku\tbc_jobit\tbc_po\tbc_qty\tbc_date_mfg\tbc_caseid\tbc_alias\tc_dom\r"
				
				For ($label; 1; $numLabels)
					
					
					$numfg:=qryFinishedGood("#CPN"; [Job_Forms_Items:44]ProductCode:3)
					
					If ($useCaseID)
						$caseID:=WMS_CaseId(""; "set"; $lot; wmsCaseNumber; wmsCaseQty)
					Else 
						$caseID:=Replace string:C233([Job_Forms_Items:44]Jobit:4; "."; "")
					End if 
					//wmsCaseId1:=WMS_CaseId ($caseID;"barcode")
					//wmsHumanReadable1:=WMS_CaseId ($caseID;"human")
					//wmsCaseNumber1:=wmsCaseNumber
					wmsCaseNumber:=wmsCaseNumber+1
					$text:=$text+[Job_Forms_Items:44]ProductCode:3+"\t"+[Finished_Goods:26]AliasCPN:106+"\t"+[Job_Forms_Items:44]Jobit:4+"\t"+$Desc+"\t"+sPO+"\t"+sOF+"\t"+String:C10(wmsCaseQty)+"\t"+String:C10(wmsDateMfg; Internal date short special:K1:4)+"\t"+$caseID+"\t"+$custname+"\t"
					$text:=$text+[Job_Forms_Items:44]ProductCode:3+"\t"+[Job_Forms_Items:44]Jobit:4+"\t"+sPO+"\t"+String:C10(wmsCaseQty)+"\t"+String:C10(wmsDateMfg; Internal date short:K1:7)+"\t"+$caseID+"\t"+[Finished_Goods:26]AliasCPN:106+"\t"+$codedDOM+"\r"
				End for 
				
				SEND PACKET:C103($docRef; $text)
				CLOSE DOCUMENT:C267($docRef)
				
				APPLY TO SELECTION:C70([Job_Forms_Items:44]; [Job_Forms_Items:44]LastCase:41:=wmsCaseNumber-1)
				//UNLOAD RECORD([Job_Forms_Items])
				
			Else 
				uConfirm("[JobMakesItem] record locked, can not print labels now."; "Later"; "OK")
			End if 
			
		Else 
			uConfirm("Unable to create document "+$docName; "Later"; "OK")
		End if 
		
	Else 
		uConfirm("jobit not found")
	End if 
End if   //jobit
