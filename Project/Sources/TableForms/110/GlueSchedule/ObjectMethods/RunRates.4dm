If (True:C214)  //Initialize
	
	C_BOOLEAN:C305($bVisible)
	C_LONGINT:C283($nFormEvent)
	C_OBJECT:C1216($oRunRate)
	
	$bVisible:=((Current user:C182="Michael Sanctuary") | (Current user:C182="Shannon Parker"))
	$nFormEvent:=FORM Event:C1606.code
	
	$oRunRate:=New object:C1471()
	
End if   //Done initialize

Case of   //Form event
		
	: ($nFormEvent=On Load:K2:1)
		
		OBJECT SET VISIBLE:C603(OBJECT Get pointer:C1124->; $bVisible)
		
	: ($nFormEvent=On Clicked:K2:4)
		
		xTitle:="Run Rates"
		dDateEnd:=4D_Current_date
		dDateBegin:=dDateEnd-1
		
		DIALOG:C40([zz_control:1]; "DateRange2")
		
		If (OK=1)  //Report
			
			$oRunRate.dStart:=dDateBegin
			$oRunRate.dEnd:=dDateEnd
			
			JbMc_Rprt_RunRate($oRunRate)
			
		End if   //Done report
		
End case   //Done form event