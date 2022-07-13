//%attributes = {"publishedWeb":true}
//(s)sbPlanIt

C_TEXT:C284($text)
C_LONGINT:C283($i; $numRecs; $numForms; $fldsPerForm; $eor; $eofld; $hit; $formNumber)
C_TEXT:C284($case)
C_TEXT:C284($est)

$est:=[Estimates:17]EstimateNo:1
$case:=[Estimates_Differentials:38]diffNum:3  //Request("Which differential are the forms for?";"AA")  `[CaseScenario]caseNum
If (OK=1)
	// RELATE MANY([ESTIMATE]EstimateNo)
	If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4 
		
		If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
			
			QUERY:C277([Estimates_Carton_Specs:19]; [Estimates_Carton_Specs:19]Estimate_No:2=[Estimates:17]EstimateNo:1)
			CREATE SET:C116([Estimates_Carton_Specs:19]; "hold")
			QUERY SELECTION:C341([Estimates_Carton_Specs:19]; [Estimates_Carton_Specs:19]diffNum:11=$case)
			
		Else 
			
			SET QUERY DESTINATION:C396(Into set:K19:2; "hold")
			QUERY:C277([Estimates_Carton_Specs:19]; [Estimates_Carton_Specs:19]Estimate_No:2=[Estimates:17]EstimateNo:1)
			SET QUERY DESTINATION:C396(Into current selection:K19:1)
			QUERY:C277([Estimates_Carton_Specs:19]; [Estimates_Carton_Specs:19]Estimate_No:2=[Estimates:17]EstimateNo:1; *)
			QUERY:C277([Estimates_Carton_Specs:19]; [Estimates_Carton_Specs:19]diffNum:11=$case)
			
		End if   // END 4D Professional Services : January 2019 query selection
		
	Else 
		
		C_TEXT:C284($criteria)
		$criteria:=[Estimates:17]EstimateNo:1
		QUERY:C277([Estimates_Carton_Specs:19]; [Estimates_Carton_Specs:19]Estimate_No:2=[Estimates:17]EstimateNo:1; *)
		QUERY:C277([Estimates_Carton_Specs:19]; [Estimates_Carton_Specs:19]diffNum:11=$case)
		
		
	End if   // END 4D Professional Services : January 2019
	
	ARRAY TEXT:C222($aTheCPNs; 0)
	ARRAY LONGINT:C221($aCartonRec; 0)
	SELECTION TO ARRAY:C260([Estimates_Carton_Specs:19]; $aCartonRec; [Estimates_Carton_Specs:19]ProductCode:5; $aTheCPNs)
	$numForms:=Num:C11(Request:C163("How many forms?"; "1"))
	$numTabs:=Num:C11(Request:C163("Number of columns between Want Qty and 1st I#?"; "4"))
	$numRecs:=0
	$fldsPerForm:=3  //items, ups, want
	ARRAY TEXT:C222($aCPN; $numRecs)
	ARRAY LONGINT:C221($aWqty; $numRecs)
	ARRAY TEXT:C222($aPO; $numRecs)
	ARRAY LONGINT:C221($aRqty; $numRecs)
	ARRAY DATE:C224($aDate; $numRecs)
	ARRAY LONGINT:C221($aPqty; $numRecs)
	ARRAY LONGINT:C221($aForm; $numRecs; ($numForms*$fldsPerForm))
	xNotes:=""
	Open window:C153(2; 40; 508; 338; 0; "Paste TEXT from clipboard.")
	DIALOG:C40([Finished_Goods:26]; "Notesdialog")
	ERASE WINDOW:C160
	$eor:=Position:C15("•"; xNotes)
	
	While ($eor#0)
		$text:=Substring:C12(xNotes; 1; $eor)
		$numRecs:=$numRecs+1
		MESSAGE:C88(String:C10($numRecs; "000")+" "+$text)
		ARRAY TEXT:C222($aCPN; $numRecs)
		ARRAY LONGINT:C221($aWqty; $numRecs)
		ARRAY TEXT:C222($aPO; $numRecs)
		ARRAY LONGINT:C221($aRqty; $numRecs)
		ARRAY DATE:C224($aDate; $numRecs)
		ARRAY LONGINT:C221($aPqty; $numRecs)
		ARRAY LONGINT:C221($aForm; $numRecs; ($numForms*$fldsPerForm))
		//load the fields
		$eofld:=Position:C15(Char:C90(9); $text)
		$aCPN{$numRecs}:=Substring:C12($text; 1; ($eofld-1))  //fStripSpace ("B";Substring($text;1;($eofld-1)))
		$text:=Substring:C12($text; ($eofld+1))
		$eofld:=Position:C15(Char:C90(9); $text)
		$aWqty{$numRecs}:=Num:C11(Substring:C12($text; 1; ($eofld-1)))
		$text:=Substring:C12($text; ($eofld+1))
		If ($numTabs>0)
			$eofld:=Position:C15(Char:C90(9); $text)
			$aPO{$numRecs}:=Substring:C12($text; 1; ($eofld-1))
			$text:=Substring:C12($text; ($eofld+1))
			If ($numTabs>1)
				$eofld:=Position:C15(Char:C90(9); $text)
				$aRqty{$numRecs}:=Num:C11(Substring:C12($text; 1; ($eofld-1)))
				$text:=Substring:C12($text; ($eofld+1))
				If ($numTabs>2)
					$eofld:=Position:C15(Char:C90(9); $text)
					$aDate{$numRecs}:=Date:C102(Substring:C12($text; 1; ($eofld-1)))
					$text:=Substring:C12($text; ($eofld+1))
					If ($numTabs>3)
						$eofld:=Position:C15(Char:C90(9); $text)
						$aPqty{$numRecs}:=Num:C11(Substring:C12($text; 1; ($eofld-1)))
						$text:=Substring:C12($text; ($eofld+1))
					End if   //3
				End if   //2
			End if   //1
		End if   //0
		$eofld:=Position:C15(Char:C90(9); $text)
		//load the forms
		For ($i; 1; $numForms*$fldsPerForm; $fldsPerForm)
			If (($eofld>0) & ($eofld<$eor))
				MESSAGE:C88(".")
				$aForm{$numRecs}{0+$i}:=Num:C11(Substring:C12($text; 1; ($eofld-1)))
				$text:=Substring:C12($text; ($eofld+1))
				$eofld:=Position:C15(Char:C90(9); $text)
				$aForm{$numRecs}{1+$i}:=Num:C11(Substring:C12($text; 1; ($eofld-1)))
				$text:=Substring:C12($text; ($eofld+1))
				$eofld:=Position:C15(Char:C90(9); $text)
				$aForm{$numRecs}{2+$i}:=Num:C11(Substring:C12($text; 1; ($eofld-1)))
				$text:=Substring:C12($text; ($eofld+1))
				$eofld:=Position:C15(Char:C90(9); $text)
			Else   //loading forms
				BEEP:C151
				ALERT:C41("Woops, end of line marker delivered premature.")
				$i:=$i+$numForms
			End if 
		End for 
		MESSAGE:C88(Char:C90(13))
		xNotes:=Substring:C12(xNotes; ($eor+2))
		$eor:=Position:C15("•"; xNotes)
	End while   //end of read
	//get rid of old forms
	$continue:=True:C214
	QUERY:C277([Estimates_DifferentialsForms:47]; [Estimates_DifferentialsForms:47]DiffFormId:3=$est+$case+"@")
	If (Records in selection:C76([Estimates_DifferentialsForms:47])>0)
		CONFIRM:C162("This Differential already has forms, Delete them?")
		If (ok=1)
			If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 First record
				
				FIRST RECORD:C50([Estimates_DifferentialsForms:47])
				
				
			Else 
				
			End if   // END 4D Professional Services : January 2019 First record
			// 4D Professional Services : after Order by , query or any query type you don't need First record  
			If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 Next record
				
				For ($i; 1; Records in selection:C76([Estimates_DifferentialsForms:47]))
					RELATE MANY:C262([Estimates_DifferentialsForms:47]DiffFormId:3)
					DELETE SELECTION:C66([Estimates_FormCartons:48])
					NEXT RECORD:C51([Estimates_DifferentialsForms:47])
				End for 
				DELETE SELECTION:C66([Estimates_DifferentialsForms:47])
				
			Else 
				
				//4d PS:use ramate many selection 
				RELATE MANY SELECTION:C340([Estimates_FormCartons:48]DiffFormID:2)
				DELETE SELECTION:C66([Estimates_FormCartons:48])
				DELETE SELECTION:C66([Estimates_DifferentialsForms:47])
				
			End if   // END 4D Professional Services : January 2019 First record
			
		Else 
			$continue:=False:C215
		End if 
	End if 
	//create new forms
	If ($continue)
		BEEP:C151
		For ($i; 1; $numForms)
			CREATE RECORD:C68([Estimates_DifferentialsForms:47])
			[Estimates_DifferentialsForms:47]DiffId:1:=$est+$case
			[Estimates_DifferentialsForms:47]FormNumber:2:=$i
			[Estimates_DifferentialsForms:47]DiffFormId:3:=$est+$case+String:C10($i; "00")
			[Estimates_DifferentialsForms:47]NumberSheets:4:=Num:C11(Request:C163("Number of Sheets for form #: "+String:C10($i); "0"))
			SAVE RECORD:C53([Estimates_DifferentialsForms:47])
		End for 
		//match products to  forms
		For ($i; 1; $numRecs)
			$hit:=Find in array:C230($aTheCPNs; $aCPN{$i})
			If ($hit#-1)
				//get rid of old ones in the formCartons and caseForm
				GOTO RECORD:C242([Estimates_Carton_Specs:19]; $aCartonRec{$hit})
				$formNumber:=0
				For ($j; 1; $numForms*$fldsPerForm; $fldsPerForm)
					$formNumber:=$formNumber+1
					If ($aForm{$i}{2+$j}#0)
						CREATE RECORD:C68([Estimates_FormCartons:48])
						[Estimates_FormCartons:48]Carton:1:=[Estimates_Carton_Specs:19]CartonSpecKey:7
						[Estimates_FormCartons:48]DiffFormID:2:=$est+$case+String:C10($formNumber; "00")
						[Estimates_FormCartons:48]ItemNumber:3:=$aForm{$i}{0+$j}
						[Estimates_FormCartons:48]NumberUp:4:=$aForm{$i}{1+$j}
						[Estimates_FormCartons:48]MakesQty:5:=$aForm{$i}{2+$j}
						SAVE RECORD:C53([Estimates_FormCartons:48])
					End if 
				End for 
			Else 
				BEEP:C151
				ALERT:C41($aCPN{$i}+" was not found in case "+$case)
			End if 
		End for 
	End if   //continue
	If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4 
		
		USE SET:C118("hold")
		CLEAR SET:C117("hold")
		
		
	Else 
		
		QUERY:C277([Estimates_Carton_Specs:19]; [Estimates_Carton_Specs:19]Estimate_No:2=$criteria)
		
		
		
	End if   // END 4D Professional Services : January 2019 query selection
	CLOSE WINDOW:C154
End if 