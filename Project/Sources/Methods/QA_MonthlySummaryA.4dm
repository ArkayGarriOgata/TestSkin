//%attributes = {"publishedWeb":true}
//PM: QA_MonthlySummaryA() -> 
//@author mlb - 9/26/01  13:56
//get a range of fg transactions

C_DATE:C307($1; $2; dDateEnd; dDateBegin)
C_LONGINT:C283($i; $numFGX)
C_TEXT:C284($t; $cr)
C_TEXT:C284(xTitle; xText)
C_TIME:C306($docRef)

zwStatusMsg("QA SUM"; "Monthly Summary A")

$t:=Char:C90(9)
$cr:=Char:C90(13)
xText:=""

MESSAGES OFF:C175
//*Find the transactions to report
REDUCE SELECTION:C351([Finished_Goods_Transactions:33]; 0)

If (Count parameters:C259>=2)
	dDateBegin:=$1
	dDateEnd:=$2
	If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
		
		QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]XactionDate:3>=dDateBegin; *)
		QUERY:C277([Finished_Goods_Transactions:33];  & ; [Finished_Goods_Transactions:33]XactionDate:3<=dDateEnd)
		If (Count parameters:C259=3)
			QUERY SELECTION:C341([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]CustID:12=$3)
		End if 
		
	Else 
		If (Count parameters:C259=3)
			QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]CustID:12=$3; *)
		End if 
		QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]XactionDate:3>=dDateBegin; *)
		QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]XactionDate:3<=dDateEnd)
		//laghzaoui:other element can't be modifier we need more detaille
		
	End if   // END 4D Professional Services : January 2019 query selection
	
	OK:=1
	$numFGX:=Records in selection:C76([Finished_Goods_Transactions:33])
Else 
	$numFGX:=qryByDateRange(->[Finished_Goods_Transactions:33]XactionDate:3; "Date Range of FG Transactions")
	If ($numFGX>-1)
		OK:=1
	Else 
		OK:=0
	End if 
End if   //params

If (OK=1)
	xTitle:="Month Quality Summary A for "+String:C10(dDateBegin; System date short:K1:1)+" to "+String:C10(dDateEnd; System date short:K1:1)+$cr
	//QUERY SELECTION([FG_Transactions];[FG_Transactions]XactionType="Move")
	// Laghzaoui revoir
	If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4
		CREATE SET:C116([Finished_Goods_Transactions:33]; "periodFGX")
		
		//get total for percentages
		USE SET:C118("periodFGX")
		
	Else 
		
		CREATE SET:C116([Finished_Goods_Transactions:33]; "periodFGX")
		//what after gona be modifier after
		
	End if   // END 4D Professional Services : January 2019 query selection
	
	$from:="CC:@"
	$to:="FG:@"
	QUERY SELECTION:C341([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]viaLocation:11=$from; *)
	//QUERY SELECTION([FG_Transactions]; | ;[FG_Transactions]viaLocation="XC:@";*)
	QUERY SELECTION:C341([Finished_Goods_Transactions:33];  & ; [Finished_Goods_Transactions:33]Location:9=$to)
	$qtyGrandTotal:=Sum:C1([Finished_Goods_Transactions:33]Qty:6)
	
	xText:=xText+"A.  Outgoing Quality"+$cr
	
	xText:=xText+$cr+$t+" CC: to FG:"+$cr
	USE SET:C118("periodFGX")
	$from:="CC:"
	$to:="FG:"
	QUERY SELECTION:C341([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]viaLocation:11=$from; *)
	QUERY SELECTION:C341([Finished_Goods_Transactions:33];  & ; [Finished_Goods_Transactions:33]Location:9=$to)
	$qtyH:=Sum:C1([Finished_Goods_Transactions:33]Qty:6)
	
	USE SET:C118("periodFGX")
	$from:="CC:R"
	$to:="FG:R@"
	QUERY SELECTION:C341([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]viaLocation:11=$from; *)
	QUERY SELECTION:C341([Finished_Goods_Transactions:33];  & ; [Finished_Goods_Transactions:33]Location:9=$to)
	$qtyR:=Sum:C1([Finished_Goods_Transactions:33]Qty:6)
	$qtyT:=$qtyH+$qtyR
	
	xText:=xText+$t+$t+"Hauppauge:"+$t
	xText:=xText+String:C10($qtyH)+$t+String:C10($qtyH/$qtyGrandTotal*100)+$cr
	xText:=xText+$t+$t+"Roanoke:"+$t
	xText:=xText+String:C10($qtyR)+$t+String:C10($qtyR/$qtyGrandTotal*100)+$cr
	xText:=xText+$t+$t+"Total:"+$t
	xText:=xText+String:C10($qtyT)+$t+String:C10($qtyT/$qtyGrandTotal*100)+$cr
	
	xText:=xText+$cr+$t+" CC: to EX:"+$cr
	USE SET:C118("periodFGX")
	$from:="@"
	$to:="EX:"
	QUERY SELECTION:C341([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]viaLocation:11=$from; *)
	QUERY SELECTION:C341([Finished_Goods_Transactions:33];  & ; [Finished_Goods_Transactions:33]Location:9=$to)
	$qtyH:=Sum:C1([Finished_Goods_Transactions:33]Qty:6)
	
	USE SET:C118("periodFGX")
	$from:="@"
	$to:="EX:R@"
	QUERY SELECTION:C341([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]viaLocation:11=$from; *)
	QUERY SELECTION:C341([Finished_Goods_Transactions:33];  & ; [Finished_Goods_Transactions:33]Location:9=$to)
	$qtyR:=Sum:C1([Finished_Goods_Transactions:33]Qty:6)
	$qtyT:=$qtyH+$qtyR
	
	xText:=xText+$t+$t+"Hauppauge:"+$t
	xText:=xText+String:C10($qtyH)+$t+String:C10($qtyH/$qtyGrandTotal*100)+$cr
	xText:=xText+$t+$t+"Roanoke:"+$t
	xText:=xText+String:C10($qtyR)+$t+String:C10($qtyR/$qtyGrandTotal*100)+$cr
	xText:=xText+$t+$t+"Total:"+$t
	xText:=xText+String:C10($qtyT)+$t+String:C10($qtyT/$qtyGrandTotal*100)+$cr
	
	xText:=xText+$cr+$t+" EX: to XC:"+$cr
	USE SET:C118("periodFGX")
	$from:="EX:"
	$to:="XC:"
	QUERY SELECTION:C341([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]viaLocation:11=$from; *)
	QUERY SELECTION:C341([Finished_Goods_Transactions:33];  & ; [Finished_Goods_Transactions:33]Location:9=$to)
	$qtyH:=Sum:C1([Finished_Goods_Transactions:33]Qty:6)
	
	USE SET:C118("periodFGX")
	$from:="EX:R"
	$to:="XC:R@"
	QUERY SELECTION:C341([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]viaLocation:11=$from; *)
	QUERY SELECTION:C341([Finished_Goods_Transactions:33];  & ; [Finished_Goods_Transactions:33]Location:9=$to)
	$qtyR:=Sum:C1([Finished_Goods_Transactions:33]Qty:6)
	$qtyT:=$qtyH+$qtyR
	
	xText:=xText+$t+$t+"Hauppauge:"+$t
	xText:=xText+String:C10($qtyH)+$t+String:C10($qtyH/$qtyGrandTotal*100)+$cr
	xText:=xText+$t+$t+"Roanoke:"+$t
	xText:=xText+String:C10($qtyR)+$t+String:C10($qtyR/$qtyGrandTotal*100)+$cr
	xText:=xText+$t+$t+"Total:"+$t
	xText:=xText+String:C10($qtyT)+$t+String:C10($qtyT/$qtyGrandTotal*100)+$cr
	
	xText:=xText+$cr+$t+" XC: to FG:"+$cr
	USE SET:C118("periodFGX")
	$from:="XC:"
	$to:="FG:"
	QUERY SELECTION:C341([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]viaLocation:11=$from; *)
	QUERY SELECTION:C341([Finished_Goods_Transactions:33];  & ; [Finished_Goods_Transactions:33]Location:9=$to)
	$qtyH:=Sum:C1([Finished_Goods_Transactions:33]Qty:6)
	
	USE SET:C118("periodFGX")
	$from:="XC:R"
	$to:="FG:R@"
	QUERY SELECTION:C341([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]viaLocation:11=$from; *)
	QUERY SELECTION:C341([Finished_Goods_Transactions:33];  & ; [Finished_Goods_Transactions:33]Location:9=$to)
	$qtyR:=Sum:C1([Finished_Goods_Transactions:33]Qty:6)
	$qtyT:=$qtyH+$qtyR
	
	xText:=xText+$t+$t+"Hauppauge:"+$t
	xText:=xText+String:C10($qtyH)+$t+String:C10($qtyH/$qtyGrandTotal*100)+$cr
	xText:=xText+$t+$t+"Roanoke:"+$t
	xText:=xText+String:C10($qtyR)+$t+String:C10($qtyR/$qtyGrandTotal*100)+$cr
	xText:=xText+$t+$t+"Total:"+$t
	xText:=xText+String:C10($qtyT)+$t+String:C10($qtyT/$qtyGrandTotal*100)+$cr
	
	xText:=xText+$cr+$t+" EX: to Scrap:"+$cr
	USE SET:C118("periodFGX")
	$from:="@:"
	$to:="SC:"
	QUERY SELECTION:C341([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]viaLocation:11=$from; *)
	QUERY SELECTION:C341([Finished_Goods_Transactions:33];  & ; [Finished_Goods_Transactions:33]Location:9=$to)
	CREATE SET:C116([Finished_Goods_Transactions:33]; "haup")
	$qtyH:=Sum:C1([Finished_Goods_Transactions:33]Qty:6)
	
	USE SET:C118("periodFGX")
	$from:="@:R@"
	$to:="SC:R@"
	QUERY SELECTION:C341([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]viaLocation:11=$from; *)
	QUERY SELECTION:C341([Finished_Goods_Transactions:33];  & ; [Finished_Goods_Transactions:33]Location:9=$to)
	CREATE SET:C116([Finished_Goods_Transactions:33]; "roan")
	$qtyR:=Sum:C1([Finished_Goods_Transactions:33]Qty:6)
	
	$qtyT:=$qtyH+$qtyR
	
	USE SET:C118("haup")
	If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 First record
		
		ORDER BY:C49([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]ReasonNotes:28; >)
		FIRST RECORD:C50([Finished_Goods_Transactions:33])
		
		
	Else 
		
		ORDER BY:C49([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]ReasonNotes:28; >)
		
	End if   // END 4D Professional Services : January 2019 First record
	// 4D Professional Services : after Order by , query or any query type you don't need First record  
	ARRAY TEXT:C222($aReason; 0)
	ARRAY LONGINT:C221($aQty; 0)
	$lastReason:="noreason"
	If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 Next record
		
		While (Not:C34(End selection:C36([Finished_Goods_Transactions:33])))
			If ([Finished_Goods_Transactions:33]ReasonNotes:28#$lastReason)
				INSERT IN ARRAY:C227($aReason; 1; 1)
				INSERT IN ARRAY:C227($aQty; 1; 1)
				$aQty{1}:=0
				$lastReason:=[Finished_Goods_Transactions:33]ReasonNotes:28
				$aReason{1}:=$lastReason
			End if 
			$aQty{1}:=$aQty{1}+[Finished_Goods_Transactions:33]Qty:6
			NEXT RECORD:C51([Finished_Goods_Transactions:33])
		End while 
		
	Else 
		
		ARRAY TEXT:C222($_ReasonNotes; 0)
		ARRAY LONGINT:C221($_Qty; 0)
		
		SELECTION TO ARRAY:C260([Finished_Goods_Transactions:33]ReasonNotes:28; $_ReasonNotes; [Finished_Goods_Transactions:33]Qty:6; $_Qty)
		
		For ($Iter; 1; Size of array:C274($_Qty); 1)
			If ($_ReasonNotes{$Iter}#$lastReason)
				INSERT IN ARRAY:C227($aReason; 1; 1)
				INSERT IN ARRAY:C227($aQty; 1; 1)
				$aQty{1}:=0
				$lastReason:=$_ReasonNotes{$Iter}
				$aReason{1}:=$lastReason
			End if 
			$aQty{1}:=$aQty{1}+$_Qty{$Iter}
			
		End for 
		
	End if   // END 4D Professional Services : January 2019 First record
	
	For ($i; 1; Size of array:C274($aReason))
		xText:=xText+$t+$t+$t+String:C10($aQty{$i})+$t+String:C10($aQty{$i}/$qtyGrandTotal*100)+$t+$aReason{$i}+$cr
	End for 
	
	xText:=xText+$t+$t+"Hauppauge:"+$t
	xText:=xText+String:C10($qtyH)+$t+String:C10($qtyH/$qtyGrandTotal*100)+$cr
	
	USE SET:C118("roan")
	If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 First record
		
		ORDER BY:C49([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]ReasonNotes:28; >)
		FIRST RECORD:C50([Finished_Goods_Transactions:33])
		
		
	Else 
		
		ORDER BY:C49([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]ReasonNotes:28; >)
		
	End if   // END 4D Professional Services : January 2019 First record
	// 4D Professional Services : after Order by , query or any query type you don't need First record  
	ARRAY TEXT:C222($aReason; 0)
	ARRAY LONGINT:C221($aQty; 0)
	$lastReason:="noreason"
	If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 Next record
		
		While (Not:C34(End selection:C36([Finished_Goods_Transactions:33])))
			If ([Finished_Goods_Transactions:33]ReasonNotes:28#$lastReason)
				INSERT IN ARRAY:C227($aReason; 1; 1)
				INSERT IN ARRAY:C227($aQty; 1; 1)
				$aQty{1}:=0
				$lastReason:=[Finished_Goods_Transactions:33]ReasonNotes:28
				$aReason{1}:=$lastReason
			End if 
			$aQty{1}:=$aQty{1}+[Finished_Goods_Transactions:33]Qty:6
			NEXT RECORD:C51([Finished_Goods_Transactions:33])
		End while 
		
	Else 
		
		ARRAY TEXT:C222($_ReasonNotes; 0)
		ARRAY LONGINT:C221($_Qty; 0)
		
		SELECTION TO ARRAY:C260([Finished_Goods_Transactions:33]ReasonNotes:28; $_ReasonNotes; [Finished_Goods_Transactions:33]Qty:6; $_Qty)
		
		For ($Iter; 1; Size of array:C274($_Qty); 1)
			If ($_ReasonNotes{$Iter}#$lastReason)
				INSERT IN ARRAY:C227($aReason; 1; 1)
				INSERT IN ARRAY:C227($aQty; 1; 1)
				$aQty{1}:=0
				$lastReason:=$_ReasonNotes{$Iter}
				$aReason{1}:=$lastReason
			End if 
			$aQty{1}:=$aQty{1}+$_Qty{$Iter}
			
		End for 
		
	End if   // END 4D Professional Services : January 2019 First record
	
	For ($i; 1; Size of array:C274($aReason))
		xText:=xText+$t+$t+$t+String:C10($aQty{$i})+$t+String:C10($aQty{$i}/$qtyGrandTotal*100)+$t+$aReason{$i}+$cr
	End for 
	
	xText:=xText+$t+$t+"Roanoke:"+$t
	xText:=xText+String:C10($qtyR)+$t+String:C10($qtyR/$qtyGrandTotal*100)+$cr
	xText:=xText+$t+$t+"Total:"+$t
	xText:=xText+String:C10($qtyT)+$t+String:C10($qtyT/$qtyGrandTotal*100)+$cr
	
	xText:=xText+$cr+$t+" Total to FG:"+$cr
	USE SET:C118("periodFGX")
	$from:="CC:"
	$to:="FG:"
	If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
		
		QUERY SELECTION:C341([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]viaLocation:11=$from; *)
		QUERY SELECTION:C341([Finished_Goods_Transactions:33];  | ; [Finished_Goods_Transactions:33]viaLocation:11="XC:"; *)
		QUERY SELECTION:C341([Finished_Goods_Transactions:33];  & ; [Finished_Goods_Transactions:33]Location:9=$to)
		QUERY SELECTION:C341([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]Location:9#"FG:R@")
		$qtyH:=Sum:C1([Finished_Goods_Transactions:33]Qty:6)
		
	Else 
		
		QUERY SELECTION:C341([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]viaLocation:11=$from; *)
		QUERY SELECTION:C341([Finished_Goods_Transactions:33];  | ; [Finished_Goods_Transactions:33]viaLocation:11="XC:"; *)
		QUERY SELECTION:C341([Finished_Goods_Transactions:33];  & ; [Finished_Goods_Transactions:33]Location:9=$to; *)
		QUERY SELECTION:C341([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]Location:9#"FG:R@")
		
		$qtyH:=Sum:C1([Finished_Goods_Transactions:33]Qty:6)
		
	End if   // END 4D Professional Services : January 2019 First record
	
	
	USE SET:C118("periodFGX")
	$from:="CC:R"
	$to:="FG:R@"
	QUERY SELECTION:C341([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]viaLocation:11=$from; *)
	QUERY SELECTION:C341([Finished_Goods_Transactions:33];  | ; [Finished_Goods_Transactions:33]viaLocation:11="XC:R"; *)
	QUERY SELECTION:C341([Finished_Goods_Transactions:33];  & ; [Finished_Goods_Transactions:33]Location:9=$to)
	$qtyR:=Sum:C1([Finished_Goods_Transactions:33]Qty:6)
	$qtyT:=$qtyH+$qtyR
	
	xText:=xText+$t+$t+"Hauppauge:"+$t
	xText:=xText+String:C10($qtyH)+$t+String:C10($qtyH/$qtyGrandTotal*100)+$cr
	xText:=xText+$t+$t+"Roanoke:"+$t
	xText:=xText+String:C10($qtyR)+$t+String:C10($qtyR/$qtyGrandTotal*100)+$cr
	xText:=xText+$t+$t+"Total:"+$t
	xText:=xText+String:C10($qtyT)+$t+String:C10($qtyT/$qtyGrandTotal*100)+$t+String:C10($qtyGrandTotal)+$cr
	
	docName:="QA_MonthlySummaryOld"+fYYMMDD(dDateEnd)
	$docRef:=util_putFileName(->docName)
	SEND PACKET:C103($docRef; xTitle+$cr+$cr)
	SEND PACKET:C103($docRef; xText)
	CLOSE DOCUMENT:C267($docRef)
	BEEP:C151
	// obsolete call, method deleted 4/28/20 uDocumentSetType (docName)
	$err:=util_Launch_External_App(docName)
	
	xText:=""
	CLEAR SET:C117("periodFGX")
End if   //ok
zwStatusMsg("QA SUM"; "Monthly Summary A Fini")