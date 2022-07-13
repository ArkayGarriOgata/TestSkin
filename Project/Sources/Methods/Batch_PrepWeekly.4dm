//%attributes = {"publishedWeb":true}
//PM: Batch_PrepWeekly() -> 
//@author mlb - 7/3/01  10:24
//compare quoted vs actual prep dept costs
C_DATE:C307(dDateBegin; $2; dDateEnd; $3)
C_LONGINT:C283($i; $numPrepChg; $numFGS; $days)
C_TEXT:C284($t; $cr)
C_TEXT:C284($custid)
C_TEXT:C284(docName; xTitle; xText; distributionList; $1)
C_TIME:C306($docRef)
C_REAL:C285($qtyQuote; $qtyAct; $priceQuote; $priceActual; $variance)

$t:=Char:C90(9)
$cr:=Char:C90(13)
distributionList:=$1
$continue:=False:C215

READ ONLY:C145([Finished_Goods_Specifications:98])
READ ONLY:C145([Prep_Charges:103])
READ ONLY:C145([Prep_CatalogItems:102])
READ ONLY:C145([Customers:16])

//*get prep done this week (past 7 days)
If (Count parameters:C259=1)
	xTitle:="PrepCustom"
	dDateEnd:=4D_Current_date
	dDateBegin:=dDateEnd-6
	DIALOG:C40([zz_control:1]; "DateRange2")
	If (OK=1)
		$continue:=True:C214
	End if 
	
Else 
	$continue:=True:C214
	dDateBegin:=$2
	dDateEnd:=$3
	If ((dDateEnd-dDateBegin)>27)
		xTitle:="Prep Monthly"
	Else 
		xTitle:="Prep Weekly"
	End if 
End if 

If ($continue)
	xText:="Prep Charges "+String:C10(dDateBegin; System date short:K1:1)+"-"+String:C10(dDateEnd; System date short:K1:1)+$cr+$cr
	
	QUERY:C277([Finished_Goods_Specifications:98]; [Finished_Goods_Specifications:98]DatePrepDone:6<=dDateEnd; *)
	QUERY:C277([Finished_Goods_Specifications:98];  & ; [Finished_Goods_Specifications:98]DatePrepDone:6>=dDateBegin)
	
	$numFGS:=Records in selection:C76([Finished_Goods_Specifications:98])
	If ($numFGS>0)
		docName:=xTitle+fYYMMDD(4D_Current_date)
		$docRef:=util_putFileName(->docName)
		xText:=xText+"enclosed in document: "+docName+$cr+$cr
		
		ORDER BY:C49([Finished_Goods_Specifications:98]; [Finished_Goods_Specifications:98]FG_Key:1; >; [Finished_Goods_Specifications:98]ControlNumber:2; >)
		xText:=xText+"CustomerName"+$t+"Product Key"+$t+"Control Number"+$t+"DaysToComplete"+$t+"ServiceRequested"+$t+"ServiceItem"+$t+"QtyQuoted"+$t+"PriceQuoted"+$t+"QtyActual"+$t+"PriceActual"+$t+"Variance"+$cr
		$qtyQuote:=0
		$qtyAct:=0
		$priceQuote:=0
		$priceActual:=0
		$variance:=0
		If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) Next record
			
			For ($i; 1; $numFGS)
				//*get the customer name
				$custid:=Substring:C12([Finished_Goods_Specifications:98]FG_Key:1; 1; 5)
				SET QUERY LIMIT:C395(1)
				QUERY:C277([Customers:16]; [Customers:16]ID:1=$custid)
				SET QUERY LIMIT:C395(0)
				
				//*get corrisponding prep charges
				RELATE MANY:C262([Finished_Goods_Specifications:98]ControlNumber:2)
				$numPrepChg:=Records in selection:C76([Prep_Charges:103])
				
				If ([Finished_Goods_Specifications:98]DatePrepDone:6#!00-00-00!) & ([Finished_Goods_Specifications:98]DateSubmitted:5#!00-00-00!)
					$days:=[Finished_Goods_Specifications:98]DatePrepDone:6-[Finished_Goods_Specifications:98]DateSubmitted:5
				Else 
					$days:=-1
				End if 
				
				If ($numPrepChg>0)
					If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 First record
						
						ORDER BY:C49([Prep_Charges:103]; [Prep_Charges:103]ControlNumber:1)
						FIRST RECORD:C50([Prep_Charges:103])
						For ($j; 1; $numPrepChg)
							If (Length:C16(xText)>20000)
								SEND PACKET:C103($docRef; xText)
								xText:=""
							End if 
							
							QUERY:C277([Prep_CatalogItems:102]; [Prep_CatalogItems:102]ItemNumber:1=[Prep_Charges:103]PrepItemNumber:4)
							xText:=xText+[Customers:16]Name:2+$t+[Finished_Goods_Specifications:98]FG_Key:1+$t+[Finished_Goods_Specifications:98]ControlNumber:2+$t+String:C10($days)+$t+[Finished_Goods_Specifications:98]ServiceRequested:54+$t+[Prep_CatalogItems:102]Description:2+$t+String:C10([Prep_Charges:103]QuantityQuoted:2)+$t+String:C10([Prep_Charges:103]PriceQuoted:6)+$t+String:C10([Prep_Charges:103]QuantityActual:3)+$t+String:C10([Prep_Charges:103]PriceActual:5)+$t+String:C10([Prep_Charges:103]PriceQuoted:6-[Prep_Charges:103]PriceActual:5)+$cr
							$qtyQuote:=$qtyQuote+[Prep_Charges:103]QuantityQuoted:2
							$qtyAct:=$qtyAct+[Prep_Charges:103]QuantityActual:3
							$priceQuote:=$priceQuote+[Prep_Charges:103]PriceQuoted:6
							$priceActual:=$priceActual+[Prep_Charges:103]PriceActual:5
							$variance:=$variance+([Prep_Charges:103]PriceQuoted:6-[Prep_Charges:103]PriceActual:5)
							NEXT RECORD:C51([Prep_Charges:103])
						End for 
						
						
					Else 
						
						ARRAY TEXT:C222($_ControlNumber; 0)
						ARRAY REAL:C219($_QuantityQuoted; 0)
						ARRAY REAL:C219($_QuantityActual; 0)
						ARRAY REAL:C219($_PriceQuoted; 0)
						ARRAY REAL:C219($_PriceActual; 0)
						ARRAY TEXT:C222($_PrepItemNumber; 0)
						ARRAY TEXT:C222($_ItemNumber; 0)
						ARRAY TEXT:C222($_Description; 0)
						
						GET FIELD RELATION:C920([Prep_Charges:103]PrepItemNumber:4; $lienAller; $lienRetour)
						SET FIELD RELATION:C919([Prep_Charges:103]PrepItemNumber:4; Automatic:K51:4; Do not modify:K51:1)
						
						SELECTION TO ARRAY:C260([Prep_Charges:103]ControlNumber:1; $_ControlNumber; [Prep_Charges:103]QuantityQuoted:2; $_QuantityQuoted; [Prep_Charges:103]QuantityActual:3; $_QuantityActual; [Prep_Charges:103]PriceQuoted:6; $_PriceQuoted; [Prep_Charges:103]PriceActual:5; $_PriceActual; [Prep_Charges:103]PrepItemNumber:4; $_PrepItemNumber; [Prep_CatalogItems:102]ItemNumber:1; $_ItemNumber; [Prep_CatalogItems:102]Description:2; $_Description)
						
						SET FIELD RELATION:C919([Prep_Charges:103]PrepItemNumber:4; $lienAller; $lienRetour)
						
						SORT ARRAY:C229($_ControlNumber; $_QuantityQuoted; $_QuantityActual; $_PriceQuoted; $_PriceActual; $_PrepItemNumber; $_ItemNumber; $_Description)
						
						For ($j; 1; $numPrepChg; 1)
							If (Length:C16(xText)>20000)
								SEND PACKET:C103($docRef; xText)
								xText:=""
							End if 
							
							xText:=xText+[Customers:16]Name:2+$t+[Finished_Goods_Specifications:98]FG_Key:1+$t+[Finished_Goods_Specifications:98]ControlNumber:2+$t+String:C10($days)+$t+[Finished_Goods_Specifications:98]ServiceRequested:54+$t+$_Description{$j}+$t+String:C10($_QuantityQuoted{$j})+$t+String:C10($_PriceQuoted{$j})+$t+String:C10($_QuantityActual{$j})+$t+String:C10($_PriceActual{$j})+$t+String:C10($_PriceQuoted{$j}-$_PriceActual{$j})+$cr
							$qtyQuote:=$qtyQuote+$_QuantityQuoted{$j}
							$qtyAct:=$qtyAct+$_QuantityActual{$j}
							$priceQuote:=$priceQuote+$_PriceQuoted{$j}
							$priceActual:=$priceActual+$_PriceActual{$j}
							$variance:=$variance+($_PriceQuoted{$j}-$_PriceActual{$j})
							
							
						End for 
						
					End if   // END 4D Professional Services : January 2019 First record
					
				Else   //no prep charges
					xText:=xText+[Customers:16]Name:2+$t+[Finished_Goods_Specifications:98]FG_Key:1+$t+[Finished_Goods_Specifications:98]ControlNumber:2+$t+String:C10($days)+$t+[Finished_Goods_Specifications:98]ServiceRequested:54+$t+"No Prep Charges found"+$cr
				End if   //prep charges   
				
				NEXT RECORD:C51([Finished_Goods_Specifications:98])
			End for 
			
		Else 
			
			//Laghzaoui reduce next
			
			ARRAY TEXT:C222($_FG_Key; 0)
			ARRAY TEXT:C222($_ControlNumber1; 0)
			ARRAY DATE:C224($_DatePrepDone; 0)
			ARRAY DATE:C224($_DateSubmitted; 0)
			ARRAY TEXT:C222($_ServiceRequested; 0)
			
			SELECTION TO ARRAY:C260([Finished_Goods_Specifications:98]FG_Key:1; $_FG_Key; \
				[Finished_Goods_Specifications:98]ControlNumber:2; $_ControlNumber1; \
				[Finished_Goods_Specifications:98]DatePrepDone:6; $_DatePrepDone; \
				[Finished_Goods_Specifications:98]DateSubmitted:5; $_DateSubmitted; \
				[Finished_Goods_Specifications:98]ServiceRequested:54; $_ServiceRequested)
			
			//Laghzaoui correct after Mel Bug 
			For ($i; 1; Size of array:C274($_ControlNumber1); 1)
				
				//*get the customer name
				$custid:=Substring:C12($_FG_Key{$i}; 1; 5)
				SET QUERY LIMIT:C395(1)
				QUERY:C277([Customers:16]; [Customers:16]ID:1=$custid)
				SET QUERY LIMIT:C395(0)
				
				//*get corrisponding prep charges
				QUERY:C277([Prep_Charges:103]; [Prep_Charges:103]ControlNumber:1=$_ControlNumber1{$i})
				
				$numPrepChg:=Records in selection:C76([Prep_Charges:103])
				
				If ($_DatePrepDone{$i}#!00-00-00!) & ($_DateSubmitted{$i}#!00-00-00!)
					$days:=$_DatePrepDone{$i}-$_DateSubmitted{$i}
				Else 
					$days:=-1
				End if 
				
				If ($numPrepChg>0)
					
					ARRAY TEXT:C222($_ControlNumber; 0)
					ARRAY REAL:C219($_QuantityQuoted; 0)
					ARRAY REAL:C219($_QuantityActual; 0)
					ARRAY REAL:C219($_PriceQuoted; 0)
					ARRAY REAL:C219($_PriceActual; 0)
					ARRAY TEXT:C222($_PrepItemNumber; 0)
					ARRAY TEXT:C222($_ItemNumber; 0)
					ARRAY TEXT:C222($_Description; 0)
					
					GET FIELD RELATION:C920([Prep_Charges:103]PrepItemNumber:4; $lienAller; $lienRetour)
					SET FIELD RELATION:C919([Prep_Charges:103]PrepItemNumber:4; Automatic:K51:4; Do not modify:K51:1)
					
					SELECTION TO ARRAY:C260([Prep_Charges:103]ControlNumber:1; $_ControlNumber; [Prep_Charges:103]QuantityQuoted:2; $_QuantityQuoted; [Prep_Charges:103]QuantityActual:3; $_QuantityActual; [Prep_Charges:103]PriceQuoted:6; $_PriceQuoted; [Prep_Charges:103]PriceActual:5; $_PriceActual; [Prep_Charges:103]PrepItemNumber:4; $_PrepItemNumber; [Prep_CatalogItems:102]ItemNumber:1; $_ItemNumber; [Prep_CatalogItems:102]Description:2; $_Description)
					
					SET FIELD RELATION:C919([Prep_Charges:103]PrepItemNumber:4; $lienAller; $lienRetour)
					
					SORT ARRAY:C229($_ControlNumber; $_QuantityQuoted; $_QuantityActual; $_PriceQuoted; $_PriceActual; $_PrepItemNumber; $_ItemNumber; $_Description)
					
					For ($j; 1; $numPrepChg; 1)
						If (Length:C16(xText)>20000)
							SEND PACKET:C103($docRef; xText)
							xText:=""
						End if 
						
						xText:=xText+[Customers:16]Name:2+$t+$_FG_Key{$i}+$t+$_ControlNumber1{$i}+$t+String:C10($days)+$t+$_ServiceRequested{$i}+$t+$_Description{$j}+$t+String:C10($_QuantityQuoted{$j})+$t+String:C10($_PriceQuoted{$j})+$t+String:C10($_QuantityActual{$j})+$t+String:C10($_PriceActual{$j})+$t+String:C10($_PriceQuoted{$j}-$_PriceActual{$j})+$cr
						$qtyQuote:=$qtyQuote+$_QuantityQuoted{$j}
						$qtyAct:=$qtyAct+$_QuantityActual{$j}
						$priceQuote:=$priceQuote+$_PriceQuoted{$j}
						$priceActual:=$priceActual+$_PriceActual{$j}
						$variance:=$variance+($_PriceQuoted{$j}-$_PriceActual{$j})
						
						
					End for 
					
					
				Else   //no prep charges
					xText:=xText+[Customers:16]Name:2+$t+$_FG_Key{$i}+$t+$_ControlNumber1{$i}+$t+String:C10($days)+$t+$_ServiceRequested{$i}+$t+"No Prep Charges found"+$cr
				End if   //prep charges   
				
			End for 
			
		End if   // END 4D Professional Services : January 2019 
		
		xText:=xText+""+$t+""+$t+""+$t+""+$t+"TOTALS"+$t+$t+String:C10($qtyQuote)+$t+String:C10($priceQuote)+$t+String:C10($qtyAct)+$t+String:C10($priceActual)+$t+String:C10($variance)+$cr
		
		SEND PACKET:C103($docRef; xText)
		
		CLOSE DOCUMENT:C267($docRef)
		//// obsolete call, method deleted 4/28/20 uDocumentSetType (docName)
		EMAIL_Sender(xTitle; ""; "open attached with Excel"; distributionList; docName)
		util_deleteDocument(docName)
		
	Else   //no prep done
		xText:=xText+"No Prep marked as Done in this time period."
		EMAIL_Sender(xTitle; ""; xText; distributionList)
	End if   //prep this week
	
	xTitle:=""
	xText:=""
	REDUCE SELECTION:C351([Finished_Goods_Specifications:98]; 0)
	REDUCE SELECTION:C351([Prep_Charges:103]; 0)
	REDUCE SELECTION:C351([Customers:16]; 0)
	FG_PrepServiceSummaryRpt(distributionList; dDateBegin; dDateEnd)
End if 