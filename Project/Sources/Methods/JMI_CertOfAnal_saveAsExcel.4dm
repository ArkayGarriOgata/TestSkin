//%attributes = {"publishedWeb":true}
//PM: JMI_CertOfAnal_saveAsExcel() -> 
//@author mlb - 5/24/02  10:38

util_deleteDocument("COA_"+[Job_Forms_Items:44]Jobit:4)

$docRef:=Create document:C266("COA_"+[Job_Forms_Items:44]Jobit:4)

If (OK=1)
	xTitle:="Certificate of Analyis Worksheet for "+[Job_Forms_Items:44]Jobit:4+<>CR+<>CR
	xText:=""
	xText:=xText+"Customer"+<>TB+[Customers:16]Name:2+(2*<>TB)+"P.O.#"+<>TB+[Customers_Order_Lines:41]PONumber:21+<>CR
	xText:=xText+"Product Code"+<>TB+[Job_Forms_Items:44]ProductCode:3+(2*<>TB)+"Desc"+<>TB+[Finished_Goods:26]CartonDesc:3+<>CR
	xText:=xText+"Qty Glued"+<>TB+String:C10([Job_Forms_Items:44]Qty_Actual:11)+(2*<>TB)+"DWGs"+<>TB+[Finished_Goods:26]OutLine_Num:4+<>TB+[Finished_Goods:26]ControlNumber:61+<>CR
	xText:=xText+"Mfg. Lot#"+<>TB+[Job_Forms_Items:44]Jobit:4+(2*<>TB)+"Mfg. Date"+<>TB+String:C10([Job_Forms_Items:44]Glued:33; System date short:K1:1)+<>CR
	xText:=xText+"Pallets"+<>TB+String:C10([Job_Forms_Items:44]Pallets:38)+(2*<>TB)+"UPC %"+<>TB+String:C10([Finished_Goods_Specifications:98]UPCsize:38)+<>TB+"UPC #"+<>TB+[Finished_Goods:26]UPC:37+<>CR
	xText:=xText+"Stock"+<>TB+[Raw_Materials_Transactions:23]Raw_Matl_Code:1+(2*<>TB)+"Stk Lot"+<>TB+[Raw_Materials_Transactions:23]POItemKey:4+<>CR+<>CR
	
	xText:=xText+"Sample"+<>TB+"Board Caliper"+<>TB+"2nd Score Caliper"+<>TB+"4th Score Caliper"+<>TB+"Diff Btw 2nd & 4th"+<>TB+"Score Bend Ratio"+<>TB+"Glue Flap Skew"+<>TB+"O/F Carton"+<>TB+"O/F Sleeve"+<>TB+"COF UV"+<>TB+"COF WB"+<>CR
	If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 Next record
		
		FIRST RECORD:C50([Job_Forms_Items_CertOfAnal:117])
		For ($i; 1; Records in selection:C76([Job_Forms_Items_CertOfAnal:117]))
			xText:=xText+String:C10([Job_Forms_Items_CertOfAnal:117]Sample:2)+<>TB+String:C10([Job_Forms_Items_CertOfAnal:117]Caliper:3)+<>TB+String:C10([Job_Forms_Items_CertOfAnal:117]CaliperSecondScore:4)+<>TB+String:C10([Job_Forms_Items_CertOfAnal:117]CaliperFourthScore:5)+<>TB+String:C10([Job_Forms_Items_CertOfAnal:117]CaliperDifference:6)+<>TB+String:C10([Job_Forms_Items_CertOfAnal:117]ScoreBendRatio:7)+<>TB+String:C10([Job_Forms_Items_CertOfAnal:117]GlueFlapSkew:8)+<>TB+String:C10([Job_Forms_Items_CertOfAnal:117]OpeningForceCarton:9)+<>TB+String:C10([Job_Forms_Items_CertOfAnal:117]OpeningForceSleeve:11)+<>TB+String:C10([Job_Forms_Items_CertOfAnal:117]CoeffOfFrictionUV:10)+<>TB+String:C10([Job_Forms_Items_CertOfAnal:117]CoeffOfFrictionWB:12)+<>CR
			NEXT RECORD:C51([Job_Forms_Items_CertOfAnal:117])
		End for 
		FIRST RECORD:C50([Job_Forms_Items_CertOfAnal:117])
		
	Else 
		
		
		ARRAY INTEGER:C220($_Sample; 0)
		ARRAY REAL:C219($_Caliper; 0)
		ARRAY REAL:C219($_CaliperSecondScore; 0)
		ARRAY REAL:C219($_CaliperFourthScore; 0)
		ARRAY REAL:C219($_CaliperDifference; 0)
		ARRAY REAL:C219($_ScoreBendRatio; 0)
		ARRAY REAL:C219($_GlueFlapSkew; 0)
		ARRAY REAL:C219($_OpeningForceCarton; 0)
		ARRAY REAL:C219($_OpeningForceSleeve; 0)
		ARRAY REAL:C219($_CoeffOfFrictionUV; 0)
		ARRAY REAL:C219($_CoeffOfFrictionWB; 0)
		
		
		SELECTION TO ARRAY:C260([Job_Forms_Items_CertOfAnal:117]Sample:2; $_Sample; [Job_Forms_Items_CertOfAnal:117]Caliper:3; $_Caliper; [Job_Forms_Items_CertOfAnal:117]CaliperSecondScore:4; $_CaliperSecondScore; [Job_Forms_Items_CertOfAnal:117]CaliperFourthScore:5; $_CaliperFourthScore; [Job_Forms_Items_CertOfAnal:117]CaliperDifference:6; $_CaliperDifference; [Job_Forms_Items_CertOfAnal:117]ScoreBendRatio:7; $_ScoreBendRatio; [Job_Forms_Items_CertOfAnal:117]GlueFlapSkew:8; $_GlueFlapSkew; [Job_Forms_Items_CertOfAnal:117]OpeningForceCarton:9; $_OpeningForceCarton; [Job_Forms_Items_CertOfAnal:117]OpeningForceSleeve:11; $_OpeningForceSleeve; [Job_Forms_Items_CertOfAnal:117]CoeffOfFrictionUV:10; $_CoeffOfFrictionUV; [Job_Forms_Items_CertOfAnal:117]CoeffOfFrictionWB:12; $_CoeffOfFrictionWB)
		
		For ($i; 1; Size of array:C274($_CoeffOfFrictionWB); 1)
			xText:=xText+String:C10($_Sample{$i})+<>TB+String:C10($_Caliper{$i})+<>TB+String:C10($_CaliperSecondScore{$i})+<>TB+String:C10($_CaliperFourthScore{$i})+<>TB+String:C10($_CaliperDifference{$i})+<>TB+String:C10($_ScoreBendRatio{$i})+<>TB+String:C10($_GlueFlapSkew{$i})+<>TB+String:C10($_OpeningForceCarton{$i})+<>TB+String:C10($_OpeningForceSleeve{$i})+<>TB+String:C10($_CoeffOfFrictionUV{$i})+<>TB+String:C10($_CoeffOfFrictionWB{$i})+<>CR
			
		End for 
		FIRST RECORD:C50([Job_Forms_Items_CertOfAnal:117])
		
	End if   // END 4D Professional Services : January 2019 query selection
	
	xText:=xText+"Mean:"+<>TB+String:C10(rReal1)+<>TB+String:C10(rReal2)+<>TB+String:C10(rReal3)+<>TB+String:C10(rReal4)+<>TB+String:C10(rReal5)+<>TB+String:C10(rReal6)+<>TB+String:C10(rReal7)+<>TB+String:C10(rReal29)+<>TB+String:C10(rReal8)+<>TB+String:C10(rReal33)+<>CR
	xText:=xText+"Std Dev:"+<>TB+String:C10(rReal9)+<>TB+String:C10(rReal10)+<>TB+String:C10(rReal11)+<>TB+String:C10(rReal12)+<>TB+String:C10(rReal13)+<>TB+String:C10(rReal14)+<>TB+String:C10(rReal15)+<>TB+String:C10(rReal30)+<>TB+String:C10(rReal16)+<>TB+String:C10(rReal34)+<>CR
	xText:=xText+"Cpk:"+<>TB+String:C10(rReal17)+<>TB+<>TB+<>TB+String:C10(rReal18)+<>TB+String:C10(rReal19)+<>TB+String:C10(rReal20)+<>TB+String:C10(rReal21)+<>TB+String:C10(rReal31)+<>TB+String:C10(rReal22)+<>TB+String:C10(rReal35)+<>CR
	xText:=xText+"PPM Out:"+<>TB+String:C10(rReal23)+<>TB+<>TB+<>TB+String:C10(rReal24)+<>TB+String:C10(rReal25)+<>TB+String:C10(rReal26)+<>TB+String:C10(rReal27)+<>TB+String:C10(rReal32)+<>TB+String:C10(rReal28)+<>TB+String:C10(rReal36)+<>CR
	xText:=xText+<>CR+<>CR+<>CR+<>CR
	SEND PACKET:C103($docRef; xTitle)
	SEND PACKET:C103($docRef; xText)
	
	xTitle:=(3*<>TB)+"ARKAY PACKAGING"+<>CR+(3*<>TB)+"350 East Park Drive, Roanoke, Virginia 24019"+<>CR+<>CR
	xTitle:=xTitle+(3*<>TB)+Uppercase:C13("Certificate of Analyis / Certificate of Compliance")+<>CR+<>CR+<>CR
	xText:=""
	xText:=xText+"Customer"+<>TB+[Customers:16]Name:2+<>CR+<>CR
	
	xText:=xText+"Material Identification"+<>CR
	xText:=xText+"Description:"+(2*<>TB)+[Finished_Goods:26]CartonDesc:3+(1*<>TB)+"Purchase Order#:"+(2*<>TB)+[Customers_Order_Lines:41]PONumber:21+<>CR
	xText:=xText+"Specification Number:"+(2*<>TB)+""+(1*<>TB)+"Release #:"+(2*<>TB)+"0"+<>CR
	xText:=xText+"Drawing Number:"+(2*<>TB)+""+(1*<>TB)+"Mfg. Lot#:"+(2*<>TB)+[Job_Forms_Items:44]Jobit:4+<>CR
	xText:=xText+"Die ID:"+(2*<>TB)+""+(1*<>TB)+"Qty.Produced in lot"+(2*<>TB)+String:C10([Job_Forms_Items:44]Qty_Actual:11)+<>CR
	xText:=xText+"Manufacturing Date:"+(2*<>TB)+String:C10([Job_Forms_Items:44]Glued:33; System date short:K1:1)+(1*<>TB)+"Pallets"+(2*<>TB)+String:C10([Job_Forms_Items:44]Pallets:38)+<>CR
	xText:=xText+"Shipment Date:"+(2*<>TB)+"00/00/00"+<>TB+"Total scrap:"+(2*<>TB)+String:C10([Job_Forms_Items:44]Qty_Actual:11-[Job_Forms_Items:44]Qty_Good:10)+<>CR+<>CR
	
	xText:=xText+"Raw Materials"+<>CR
	xText:=xText+"Stock:"+<>TB+[Raw_Materials_Transactions:23]Raw_Matl_Code:1+(2*<>TB)+"Lot Number:"+<>TB+[Raw_Materials_Transactions:23]POItemKey:4+<>CR+<>CR
	
	xText:=xText+"Quality Control Summary"+<>CR
	xText:=xText+"Dimension/Attribute"+(2*<>TB)+"Nominal"+<>TB+"Lower Limit"+<>TB+"Upper Limit"+<>TB+"Mean"+<>TB+"Standard Deviation"+<>TB+"Cpk"+<>TB+"PPM Out of Spec."+<>CR
	For ($i; 1; Size of array:C274(aAttribute))
		xText:=xText+aAttribute{$i}+(2*<>TB)+String:C10(aNominal{$i})+<>TB+String:C10(aLowerLimit{$i})+<>TB+String:C10(aUpperLimit{$i})+<>TB+String:C10(aMean{$i})+<>TB+String:C10(aStdDev{$i})+<>TB+String:C10(aCpk{$i})+<>TB+String:C10(aPPM{$i})+<>CR
	End for 
	
	xText:=xText+<>CR+"UPC Check  ANSI/TRAD"+(2*<>TB)+"Trad"+(2*<>TB)+"PCS %"+<>TB+"100"+<>CR+<>CR
	xText:=xText+"1. The raw materials used are as specified in the "+"Individual and Master Packing Material Specifications."+<>CR
	xText:=xText+"2. All the components were produced in compliances with current GMPs."+<>CR
	xText:=xText+"3. Any pertinent test results related to the particular"+" certificate are available upon request."+<>CR
	xText:=xText+"4. Sampling Plan: ANSI/ASQC Z1.4-1993 SINGLE "+"SAMPLING NORMAL INSPECTION LEVEL II."+<>CR+<>CR+<>CR+<>CR+<>CR
	
	xText:=xText+"_________________"+(5*<>TB)+"______"+<>CR
	xText:=xText+"Authorized Signature"+(5*<>TB)+"Date"+<>CR
	xText:=xText+"(Typed name and date valid for e-mail)"+<>CR+<>CR+<>CR
	xText:=xText+"QA-COA 2/12/02"+<>CR
	SEND PACKET:C103($docRef; xTitle)
	SEND PACKET:C103($docRef; xText)
	
	CLOSE DOCUMENT:C267($docRef)
	BEEP:C151
	// obsolete call, method deleted 4/28/20 uDocumentSetType 
	$err:=util_Launch_External_App(Document)
	zwStatusMsg("COA"; "Save in document "+document)
End if 