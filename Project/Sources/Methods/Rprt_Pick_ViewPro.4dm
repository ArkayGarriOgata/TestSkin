//%attributes = {}
//Method:  Rprt_Pick_ViewPro
//Description:  This method will run the report.
//.  The report needs to know:
//.     1. The parameters to expect and check if valid
//.     2. To display in "ViewPro" area

If (True:C214)  //Initialize
	
	C_BOOLEAN:C305($bExecute)
	
	C_OBJECT:C1216($oReport)
	C_OBJECT:C1216($esRprt_Criterion)
	C_OBJECT:C1216($eRprt_Crierion)
	C_OBJECT:C1216($oParameter)
	
	C_TEXT:C284($tReport_Key)
	
	$bExecute:=False:C215
	
	$oReport:=New object:C1471()
	$esRprt_Criterion:=New object:C1471()
	$eRprt_Criterion:=New object:C1471()
	$oParameter:=New object:C1471()
	
	$tReport_Key:=Form:C1466.tReport_Key
	
End if   //Done initialize

If (Core_Query_UniqueRecordB(->[Report:66]Report_Key:1; ->$tReport_Key; ->$oReport))  //Report
	
	$esRprt_Criterion:=ds:C1482.Rprt_Criterion.query("Report_Key = :1"; $tReport_Key)
	
	For each ($eRprt_Criterion; $esRprt_Criterion)  //Criterion
		
		Case of   //Parameter
				
			: ($eRprt_Criterion.Title="Start Date")
				
				OB SET:C1220($oParameter; $eRprt_Criterion.Title; Rprt_Pick_dStart)
				
			: ($eRprt_Criterion.Title="End Date")
				
				OB SET:C1220($oParameter; $eRprt_Criterion.Title; Rprt_Pick_dEnd)
				
			: (Position:C15(CorektPipe; $eRprt_Criterion.Default)>0)
				
				OB SET:C1220($oParameter; $eRprt_Criterion.Title; Rprt_Pick_atValue0{Rprt_Pick_atValue0})
				
			: ($eRprt_Criterion.Title="Method")  //Use dialog
				
			Else   //Value
				
				OB SET:C1220($oParameter; $eRprt_Criterion.Title; Form:C1466.tValue0)
				
		End case   //Done parameter
		
	End for each   //Done criterion
	
	Case of   //Execute
			
		: (OB Is empty:C1297($oReport))
		: (Not:C34(OB Is defined:C1231($oReport; "Method")))
			
		: (OB Is empty:C1297($oParameter))
			
			EXECUTE METHOD:C1007($oReport.Method)
			
			$bExecute:=True:C214
			
		Else   //Uses parameter
			
			EXECUTE METHOD:C1007($oReport.Method; *; $oParameter)
			
			$bExecute:=True:C214
			
	End case   //Done execute
	
	If ($bExecute)  //Save
		
		Rprt_Pick_Save
		
		Rprt_Pick_Initialize(Current method name:C684())
		
	End if   //Done save
	
End if   //Done report
