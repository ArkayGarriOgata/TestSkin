// _______
// Method: [ProductionSchedules].PrePressViewer.SearchPicker   ( ) ->
// By: MelvinBohince @ 03/04/22, 12:14:33
// Description
// 
// ----------------------------------------------------


Case of 
		
	: (Form event code:C388=On Load:K2:1)
		// Init the var itself
		// this can be done anywhere else in your code
		C_TEXT:C284($ObjectName; vSearch)
		vSearch:=""
		
		// customise the SearchPicker
		$ObjectName:=OBJECT Get name:C1087(Object current:K67:2)
		SearchPicker SET HELP TEXT($ObjectName; "Find Job Sequence")
		GOTO OBJECT:C206(*; "$ObjectName")
		
	: (Form event code:C388=On Data Change:K2:15)
		
		If (Not:C34(searchWidgetInited))
			searchWidgetInited:=True:C214
		Else 
			
			Case of 
				: (Length:C16(vSearch)>2)
					
					Form:C1466.topLeft_es:=Form:C1466.topLeft_es.query("JobSequence = :1"; "@"+vSearch+"@").orderBy("Priority")
					Form:C1466.bottomLeft_es:=Form:C1466.bottomLeft_es.query("JobSequence = :1"; "@"+vSearch+"@").orderBy("Priority")
					Form:C1466.topRight_es:=Form:C1466.topRight_es.query("JobSequence = :1"; "@"+vSearch+"@").orderBy("Priority")
					Form:C1466.bottomRight_es:=Form:C1466.bottomRight_es.query("JobSequence = :1"; "@"+vSearch+"@").orderBy("Priority")
					
				: (Length:C16(vSearch)=0)
					$criterion_s:=PS_PrePressFilter
					
				Else 
					//wait for more typing
			End case 
			
		End if 
		
End case 
