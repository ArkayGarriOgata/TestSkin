//%attributes = {}
//Method:  Core_Peek_Who({oReference})
//Description:  This method will record who peeked at...
//.   Form => default if no oReference
//      oReference.tCategory     oReference.tValue
//          Report                  {ReportName-ReportMethod}
//          Method                  {Method Name}

If (True:C214)  //Initialize
	
	C_OBJECT:C1216($1; $oReference)
	
	C_LONGINT:C283($nFormEvent)
	C_BOOLEAN:C305($bSave)
	
	C_TIME:C306(Core_hPeek_Start)
	
	C_OBJECT:C1216($eCorePeek)
	C_OBJECT:C1216($oWhoPeeked)
	C_OBJECT:C1216($oSave)
	
	$oReference:=New object:C1471()
	
	$nNumberOfParameters:=Count parameters:C259
	
	Case of   //Category
			
		: ($nNumberOfParameters=0)  //Form 
			
			If (Current form table:C627=Null:C1517)  //Project form
				
				$tTableName:="Project Form"
				
			Else   //Table form
				
				$tTableName:=Table name:C256(Current form table:C627)
				
			End if   //Done project form
			
			$tFormName:=Current form name:C1298
			
			$nFormEvent:=Form event code:C388
			
			$bSave:=($nFormEvent=On Unload:K2:2)
			
		: ($nNumberOfParameters=1)  //Report or Method
			
			$oReference:=$1
			
			$tTableName:=$oReference.tCategory
			
			$tFormName:=$oReference.tFormName
			
			$bSave:=True:C214
			
	End case   //Done category
	
End if   //Done initialize

Case of   //Form event
		
	: ($bSave)
		
		$oWhoPeeked.On:=Current date:C33
		$oWhoPeeked.Start:=Time string:C180(Core_hPeek_Start)
		$oWhoPeeked.End:=Time string:C180(Current time:C178(*))
		$oWhoPeeked.TableName:=$tTableName
		$oWhoPeeked.FormName:=$tFormName
		$oWhoPeeked.UserName:=Current user:C182
		
		$eCorePeek:=ds:C1482.Core_Peek.new()
		
		$eCorePeek.WhoPeeked:=$oWhoPeeked
		
		$oSave:=$eCorePeek.save()
		
	: ($nFormEvent=On Load:K2:1)
		
		Core_hPeek_Start:=Current time:C178(*)
		
End case   //Done form event
