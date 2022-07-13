//%attributes = {}
//Method: Rprt_Pick_CriterionSet(tReport_Key)
//Description:  This method will set the query options to display

If (True:C214)  //Initialize
	
	C_TEXT:C284($1; $tReport_Key)
	
	C_DATE:C307($dDefault)
	
	C_OBJECT:C1216($esRprt_Criterion)
	C_OBJECT:C1216($eRprt_Criterion)
	
	$tReport_Key:=$1
	
	$esRprt_Criterion:=New object:C1471()
	$eRprt_Criterion:=New object:C1471()
	
	$dDefault:=!00-00-00!
	
End if   //Done initialize

Rprt_Pick_Initialize((Current method name:C684+CorektPhaseClear))  //Clear values

$esRprt_Criterion:=ds:C1482.Rprt_Criterion.query("Report_Key = :1"; $tReport_Key)

For each ($eRprt_Criterion; $esRprt_Criterion)  //Criterion
	
	Case of   //Default
			
		: (($eRprt_Criterion.Title="Start Date") | ($eRprt_Criterion.Title="End Date"))  //Uses start or end date
			
			If (Position:C15(CorektLeftParen; $eRprt_Criterion.Default)>0)  //Add
				
				$dDefault:=Core_Date_UsePhraseD($eRprt_Criterion.Default; Current date:C33(*))
				
			Else   //Phrase
				
				$dDefault:=Core_Date_UsePhraseD($eRprt_Criterion.Default)
				
			End if   //Done add
			
			Rprt_Pick_Initialize((Current method name:C684+$eRprt_Criterion.Title); ->$dDefault)
			
		: (Position:C15(CorektPipe; $eRprt_Criterion.Default)>0)  //Uses popup value
			
			$tTitle:=$eRprt_Criterion.Title
			$tDefault:=$eRprt_Criterion.Default
			
			Rprt_Pick_Initialize(Current method name:C684+"PopUp"; ->$tTitle; ->$tDefault)
			
		: ($eRprt_Criterion.Title="Method")  //Use dialog
			
		Else   //Uses enterable value
			
			$tTitle:=$eRprt_Criterion.Title
			$tDefault:=$eRprt_Criterion.Default
			
			Rprt_Pick_Initialize(Current method name:C684+"Enterable"; ->$tTitle; ->$tDefault)
			
	End case   //Done default
	
End for each   //Done criterion
