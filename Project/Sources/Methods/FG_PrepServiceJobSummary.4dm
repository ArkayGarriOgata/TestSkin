//%attributes = {"publishedWeb":true}
//PM: FG_PrepServiceJobSummary() -> 
//@author mlb - 10/26/01  15:58
C_TEXT:C284($1; $jobform)
$jobform:=$1
MESSAGES OFF:C175
C_LONGINT:C283($i; $j; $k; $numJMI)
C_TEXT:C284($t; $cr)
$t:=Char:C90(9)
$cr:=Char:C90(13)
C_TEXT:C284(xTitle; xText)
C_TIME:C306($docRef)
zwStatusMsg("Prep Sum"; "Reporting jobform "+$jobform)
docName:="PrepServiceJobSummary_"+$jobform
$docRef:=util_putFileName(->docName)
If (docName#"")
	xTitle:="Prep Service Job Summary for "+$jobform
	xText:="JOB IT"+$t+"CATEGORY"+$t+"PRODUCT CODE"+$t+"CONTROL#"+$t+"PREP DONE"+$t+"SERVICE"+$t+"$ QUOTED"+$t+"$ INCURRED"+$t+"ORDER#"+$t+"INVOICE#"+$cr
	SEND PACKET:C103($docRef; xTitle+$cr+$cr)
	
	//utl_LogIt ("init")
	READ ONLY:C145([Job_Forms_Items:44])
	READ ONLY:C145([Finished_Goods_Specifications:98])
	READ ONLY:C145([Prep_Charges:103])
	READ ONLY:C145([Prep_CatalogItems:102])
	QUERY:C277([Job_Forms_Items:44]; [Job_Forms_Items:44]JobForm:1=$jobform)
	//QUERY([JobMakesItem]; & ;[JobMakesItem]Category#"Repeat")
	$numJMI:=Records in selection:C76([Job_Forms_Items:44])
	
	If ($numJMI>0)
		//utl_LogIt ("JOB IT      CATEGORY PRODUCT CODE      CONTROL#  PREP DONE       "
		//«;0)
		ORDER BY:C49([Job_Forms_Items:44]; [Job_Forms_Items:44]Jobit:4; >)
		$dollarsActual:=0
		$dollarsQuoted:=0
		If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) Next record
			
			For ($i; 1; $numJMI)
				//utl_LogIt (Char(13)+[JobMakesItem]Jobit+"  "+[JobMakesItem]Category+"  "
				//«+[JobMakesItem]ProductCode;0)
				xText:=xText+[Job_Forms_Items:44]Jobit:4+$t+[Job_Forms_Items:44]Category:31+$t+[Job_Forms_Items:44]ProductCode:3+$cr
				QUERY:C277([Finished_Goods_Specifications:98]; [Finished_Goods_Specifications:98]ProductCode:3=[Job_Forms_Items:44]ProductCode:3)
				If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 Next record
					
					ORDER BY:C49([Finished_Goods_Specifications:98]; [Finished_Goods_Specifications:98]ControlNumber:2; >)
					For ($j; 1; Records in selection:C76([Finished_Goods_Specifications:98]))
						//utl_LogIt ((" "*40)+[FG_Specification]ControlNumber+"  "
						//«+String([FG_Specification]DatePrepDone;Short )+"  "+Replace 
						//«string([FG_Specification]CommentsFromPlanner;Char(13);" ");0)
						xText:=xText+($t*3)+[Finished_Goods_Specifications:98]ControlNumber:2+$t+String:C10([Finished_Goods_Specifications:98]DatePrepDone:6; System date short:K1:1)+$t+Replace string:C233([Finished_Goods_Specifications:98]CommentsFromPlanner:19; Char:C90(13); " ")+$cr
						RELATE MANY:C262([Finished_Goods_Specifications:98]ControlNumber:2)
						For ($k; 1; Records in selection:C76([Prep_Charges:103]))
							RELATE ONE:C42([Prep_Charges:103]PrepItemNumber:4)
							//utl_LogIt ((" "*60)+String([PrepCharges]PriceActual
							//«*[PrepCharges]QuantityActual;"$^,^^0")+"  "+[PrepCatalog]Description+"  "
							//«+String([PrepCharges]OrderNumber)+"  "+String([PrepCharges]InvoiceNumber);0)
							$thisQuote:=[Prep_Charges:103]PriceQuoted:6*[Prep_Charges:103]QuantityQuoted:2
							$thisActual:=[Prep_Charges:103]PriceActual:5*[Prep_Charges:103]QuantityActual:3
							$dollarsQuoted:=$dollarsQuoted+$thisQuote
							$dollarsActual:=$dollarsActual+$thisActual
							xText:=xText+($t*5)+[Prep_CatalogItems:102]Description:2+$t+String:C10($thisQuote)+$t+String:C10($thisActual)+$t+String:C10([Prep_Charges:103]OrderNumber:8)+$t+String:C10([Prep_Charges:103]InvoiceNumber:7)+$cr
							NEXT RECORD:C51([Prep_Charges:103])
						End for 
						NEXT RECORD:C51([Finished_Goods_Specifications:98])
					End for   //j
					
					
				Else 
					
					ARRAY TEXT:C222($_ControlNumber; 0)
					ARRAY DATE:C224($_DatePrepDone; 0)
					ARRAY TEXT:C222($_CommentsFromPlanner; 0)
					
					
					SELECTION TO ARRAY:C260([Finished_Goods_Specifications:98]ControlNumber:2; $_ControlNumber; [Finished_Goods_Specifications:98]DatePrepDone:6; $_DatePrepDone; [Finished_Goods_Specifications:98]CommentsFromPlanner:19; $_CommentsFromPlanner)
					
					SORT ARRAY:C229($_ControlNumber; $_DatePrepDone; $_CommentsFromPlanner; >)
					
					For ($j; 1; Size of array:C274($_CommentsFromPlanner); 1)
						
						xText:=xText+($t*3)+$_ControlNumber{$j}+$t+String:C10($_DatePrepDone{$j}; System date short:K1:1)+$t+Replace string:C233($_CommentsFromPlanner{$j}; Char:C90(13); " ")+$cr
						
						ARRAY TEXT:C222($_PrepItemNumber; 0)
						ARRAY REAL:C219($_PriceQuoted; 0)
						ARRAY REAL:C219($_QuantityQuoted; 0)
						ARRAY REAL:C219($_PriceActual; 0)
						ARRAY REAL:C219($_QuantityActual; 0)
						ARRAY LONGINT:C221($_OrderNumber; 0)
						ARRAY LONGINT:C221($_InvoiceNumber; 0)
						ARRAY TEXT:C222($_ItemNumber; 0)
						ARRAY TEXT:C222($_Description; 0)
						
						QUERY:C277([Prep_Charges:103]; [Prep_Charges:103]ControlNumber:1=$_ControlNumber{$j})
						GET FIELD RELATION:C920([Prep_Charges:103]PrepItemNumber:4; $lienAller; $lienRetour)
						SET FIELD RELATION:C919([Prep_Charges:103]PrepItemNumber:4; Automatic:K51:4; Do not modify:K51:1)
						
						SELECTION TO ARRAY:C260([Prep_Charges:103]PrepItemNumber:4; $_PrepItemNumber; [Prep_Charges:103]PriceQuoted:6; $_PriceQuoted; [Prep_Charges:103]QuantityQuoted:2; $_QuantityQuoted; [Prep_Charges:103]PriceActual:5; $_PriceActual; [Prep_Charges:103]QuantityActual:3; $_QuantityActual; [Prep_Charges:103]OrderNumber:8; $_OrderNumber; [Prep_Charges:103]InvoiceNumber:7; $_InvoiceNumber; [Prep_CatalogItems:102]ItemNumber:1; $_ItemNumber; [Prep_CatalogItems:102]Description:2; $_Description)
						
						SET FIELD RELATION:C919([Prep_Charges:103]PrepItemNumber:4; $lienAller; $lienRetour)
						
						
						For ($k; 1; Size of array:C274($_OrderNumber); 1)
							$thisQuote:=$_PriceQuoted{$k}*$_QuantityQuoted{$k}
							$thisActual:=$_PriceActual{$k}*$_QuantityActual{$k}
							$dollarsQuoted:=$dollarsQuoted+$thisQuote
							$dollarsActual:=$dollarsActual+$thisActual
							xText:=xText+($t*5)+$_Description{$k}+$t+String:C10($thisQuote)+$t+String:C10($thisActual)+$t+String:C10($_OrderNumber{$k})+$t+String:C10($_InvoiceNumber{$k})+$cr
							
						End for 
						
					End for 
					
					
				End if   // END 4D Professional Services : January 2019 First record
				NEXT RECORD:C51([Job_Forms_Items:44])
			End for 
			
			
		Else 
			
			ARRAY TEXT:C222($_Jobit; 0)
			ARRAY TEXT:C222($_Category; 0)
			ARRAY TEXT:C222($_ProductCode; 0)
			
			SELECTION TO ARRAY:C260([Job_Forms_Items:44]Jobit:4; $_Jobit; \
				[Job_Forms_Items:44]Category:31; $_Category; \
				[Job_Forms_Items:44]ProductCode:3; $_ProductCode)
			
			
			For ($i; 1; $numJMI; 1)
				
				xText:=xText+$_Jobit{$i}+$t+$_Category{$i}+$t+$_ProductCode{$i}+$cr
				QUERY:C277([Finished_Goods_Specifications:98]; [Finished_Goods_Specifications:98]ProductCode:3=$_ProductCode{$i})
				
				ARRAY TEXT:C222($_ControlNumber; 0)
				ARRAY DATE:C224($_DatePrepDone; 0)
				ARRAY TEXT:C222($_CommentsFromPlanner; 0)
				
				
				SELECTION TO ARRAY:C260([Finished_Goods_Specifications:98]ControlNumber:2; $_ControlNumber; [Finished_Goods_Specifications:98]DatePrepDone:6; $_DatePrepDone; [Finished_Goods_Specifications:98]CommentsFromPlanner:19; $_CommentsFromPlanner)
				
				SORT ARRAY:C229($_ControlNumber; $_DatePrepDone; $_CommentsFromPlanner; >)
				
				For ($j; 1; Size of array:C274($_CommentsFromPlanner); 1)
					
					xText:=xText+($t*3)+$_ControlNumber{$j}+$t+String:C10($_DatePrepDone{$j}; System date short:K1:1)+$t+Replace string:C233($_CommentsFromPlanner{$j}; Char:C90(13); " ")+$cr
					
					ARRAY TEXT:C222($_PrepItemNumber; 0)
					ARRAY REAL:C219($_PriceQuoted; 0)
					ARRAY REAL:C219($_QuantityQuoted; 0)
					ARRAY REAL:C219($_PriceActual; 0)
					ARRAY REAL:C219($_QuantityActual; 0)
					ARRAY LONGINT:C221($_OrderNumber; 0)
					ARRAY LONGINT:C221($_InvoiceNumber; 0)
					ARRAY TEXT:C222($_ItemNumber; 0)
					ARRAY TEXT:C222($_Description; 0)
					
					QUERY:C277([Prep_Charges:103]; [Prep_Charges:103]ControlNumber:1=$_ControlNumber{$j})
					GET FIELD RELATION:C920([Prep_Charges:103]PrepItemNumber:4; $lienAller; $lienRetour)
					SET FIELD RELATION:C919([Prep_Charges:103]PrepItemNumber:4; Automatic:K51:4; Do not modify:K51:1)
					
					SELECTION TO ARRAY:C260([Prep_Charges:103]PrepItemNumber:4; $_PrepItemNumber; [Prep_Charges:103]PriceQuoted:6; $_PriceQuoted; [Prep_Charges:103]QuantityQuoted:2; $_QuantityQuoted; [Prep_Charges:103]PriceActual:5; $_PriceActual; [Prep_Charges:103]QuantityActual:3; $_QuantityActual; [Prep_Charges:103]OrderNumber:8; $_OrderNumber; [Prep_Charges:103]InvoiceNumber:7; $_InvoiceNumber; [Prep_CatalogItems:102]ItemNumber:1; $_ItemNumber; [Prep_CatalogItems:102]Description:2; $_Description)
					
					SET FIELD RELATION:C919([Prep_Charges:103]PrepItemNumber:4; $lienAller; $lienRetour)
					
					
					For ($k; 1; Size of array:C274($_OrderNumber); 1)
						$thisQuote:=$_PriceQuoted{$k}*$_QuantityQuoted{$k}
						$thisActual:=$_PriceActual{$k}*$_QuantityActual{$k}
						$dollarsQuoted:=$dollarsQuoted+$thisQuote
						$dollarsActual:=$dollarsActual+$thisActual
						xText:=xText+($t*5)+$_Description{$k}+$t+String:C10($thisQuote)+$t+String:C10($thisActual)+$t+String:C10($_OrderNumber{$k})+$t+String:C10($_InvoiceNumber{$k})+$cr
						
					End for 
					
				End for 
				
			End for 
			
			
		End if   // END 4D Professional Services : January 2019 
		xText:=xText+$cr+$cr+($t*5)+"JOB TOTAL"+$t+String:C10($dollarsQuoted)+$t+String:C10($dollarsActual)+$t+""+$t+""+$cr
		
	Else 
		BEEP:C151
		ALERT:C41("No items found on this form.")  //All items on this job are repeats.")
	End if 
	
	//utl_LogIt ("show")
	
	SEND PACKET:C103($docRef; xText)
	
	CLOSE DOCUMENT:C267($docRef)
	zwStatusMsg("Prep Sum"; "Report save in document PrepServiceJobSummary_"+$jobform)
	BEEP:C151
	// obsolete call, method deleted 4/28/20 uDocumentSetType (docName)
	$err:=util_Launch_External_App(docName)
	
Else 
	BEEP:C151
	ALERT:C41("Couldn't open a document")
End if   //open doc