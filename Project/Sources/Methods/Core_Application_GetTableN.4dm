//%attributes = {}
//Method:  Core_Application_GetTableN=>nApplicationTableNumber
//Description:  This method will return the application table number

If (True:C214)  //Initialize
	
	C_LONGINT:C283($0; $nApplicationTableNumber)
	
	C_TEXT:C284($tWindowName)
	C_TEXT:C284($tTableName)
	
	C_LONGINT:C283($nColonLocation; $nHyphenLocation)
	
	C_LONGINT:C283($nTable; $nNumberOfTables)
	
	$nApplicationTableNumber:=0
	
End if   //Done initialize

If (Current process name:C1392="Application process")  //Application process
	
	$tWindowName:=Get window title:C450(Frontmost window:C447)
	
	$nColonLocation:=Position:C15(":"; $tWindowName)
	$tWindowName:=Substring:C12($tWindowName; 1; ($nColonLocation-1))
	$nHyphenLocation:=Position:C15("-"; $tWindowName)
	
	$tTableName:=Substring:C12($tWindowName; ($nHyphenLocation+1))
	
	$nNumberOfTables:=Get last table number:C254
	
	For ($nTable; 1; $nNumberOfTables)  //Tables
		
		Case of   //Found Table
				
			: (Not:C34(Is table number valid:C999($nTable)))
			: (Table name:C256($nTable)#$tTableName)
				
			Else   //Found
				
				$nApplicationTableNumber:=$nTable
				
				$nTable:=$nNumberOfTables+1
				
		End case   //Done found table
		
	End for   //Done tables
	
End if   //Done application process

$0:=$nApplicationTableNumber