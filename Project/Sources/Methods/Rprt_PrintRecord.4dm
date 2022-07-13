//%attributes = {}
//Method: Rprt_PrintRecord(oPrintRecord)
//Description: This method will print record

//.   $nTableNumber:=OB Get($oPrintRecord;"TableNumber";Is longint)
//.   $tReportForm:=OB Get($oPrintRecord;"ReportForm";Is text)
//.   $tOutputForm:=OB Get($oPrintRecord;"OutputForm";is text)
//.   $bCurrentRecord:=OB Get($oPrintRecord;"CurrentRecord";Is boolean)

If (True:C214)  //Initialize
	
	C_OBJECT:C1216($1; $oPrintRecord)
	C_POINTER:C301($pTable)
	C_LONGINT:C283($nTableNumber)
	C_TEXT:C284($tReportForm; $tOutputForm)
	C_BOOLEAN:C305($bCurrentRecord)
	
	$oPrintRecord:=$1
	
	$nTableNumber:=OB Get:C1224($oPrintRecord; "TableNumber"; Is longint:K8:6)
	$tReportForm:=OB Get:C1224($oPrintRecord; "ReportForm"; Is text:K8:3)
	$tOutputForm:=OB Get:C1224($oPrintRecord; "OutputForm"; Is text:K8:3)
	$bCurrentRecord:=OB Get:C1224($oPrintRecord; "CurrentRecord"; Is boolean:K8:9)
	
	$pTable:=Table:C252($nTableNumber)
	
End if   //Done Initialize

If ($bCurrentRecord)  //Just print the current record
	
	COPY NAMED SELECTION:C331($pTable->; "TableSelection")
	ONE RECORD SELECT:C189($pTable->)
	
	OK:=1
	
Else   //Bring up search
	
	NumRecs1:=fSelectBy  //generic search equal or range on any four fields 
	
	FIRST RECORD:C50($pTable->)
	
End if   //Done just print the current record

If (OK=1)  //Ok to print
	
	FORM SET OUTPUT:C54($pTable->; $tReportForm)
	
	util_PAGE_SETUP($pTable->; $tReportForm)
	
	PRINT SETTINGS:C106
	
	OPEN PRINTING JOB:C995
	
	While (Not:C34(End selection:C36($pTable->)))  //Loop thru all the records
		
		PRINT RECORD:C71($pTable->; *)
		NEXT RECORD:C51($pTable->)
		
	End while   //Done looping thru all the records
	
	CLOSE PRINTING JOB:C996
	
End if   //Done ok to print

If ($bCurrentRecord)
	
	USE NAMED SELECTION:C332("TableSelection")
	CLEAR NAMED SELECTION:C333("TableSelection")
	
End if 

FORM SET OUTPUT:C54($pTable->; $tOutputForm)
