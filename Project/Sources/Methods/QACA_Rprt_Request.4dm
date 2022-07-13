//%attributes = {}
//Method: QACA_Rprt_Request({bPrintCurrentRecord})
//Description: This will print record

If (True:C214)  //Initialize
	
	C_BOOLEAN:C305($1; $bPrintCurrentRecord)
	
	$bPrintCurrentRecord:=False:C215
	
	If (Count parameters:C259>=1)
		
		$bPrintCurrentRecord:=$1
		
	End if 
	
	C_OBJECT:C1216($oPrintRecord)
	
	OB SET:C1220($oPrintRecord; "TableNumber"; Table:C252(->[QA_Corrective_Actions:105]))
	OB SET:C1220($oPrintRecord; "ReportForm"; "Report")
	OB SET:C1220($oPrintRecord; "OutputForm"; "List")
	OB SET:C1220($oPrintRecord; "CurrentRecord"; $bPrintCurrentRecord)
	
End if   //Done Initialize

Rprt_PrintRecord($oPrintRecord)
