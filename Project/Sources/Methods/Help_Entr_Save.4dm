//%attributes = {}
//Method: Help_Entr_Save(oHelp)
//Description:  This method saves a [Help] record

If (True:C214)  //Initialize
	
	C_OBJECT:C1216($esHelp; $eHelp)
	C_OBJECT:C1216($oStatus)
	
	C_TEXT:C284($tHelp)
	C_TEXT:C284($tQuery)
	
	$esHelp:=New object:C1471()
	$eHelp:=New object:C1471()
	$oStatus:=New object:C1471()
	
	$tHelp:=Table name:C256(->[Help:36])
	
	If (Form:C1466.tHelp_Key=CorektBlank)  // Query 
		
		$tQuery:="Category = "+Form:C1466.tCategory+" and "+\
			"Title = "+Form:C1466.tTitle
		
	Else   //Modifying
		
		$tQuery:="Help_Key = "+Form:C1466.tHelp_Key
		
	End if   //Done query
	
End if   //Done initialize

$esHelp:=ds:C1482[$tHelp].query($tQuery)

If ($esHelp.length=0)  // New 
	
	$eHelp:=ds:C1482[$tHelp].new()
	
Else   //Modify
	
	$eHelp:=$esHelp.first()
	
End if   //Done new

$eHelp.Category:=Form:C1466.tCategory
$eHelp.Title:=Form:C1466.tTitle
$eHelp.PathName:=Form:C1466.tPathName
$eHelp.Keyword:=Form:C1466.tKeyword

UNLOAD RECORD:C212([Help:36])  //Usermode check 

$oStatus:=$eHelp.save()

$tQuery:="Category = "+Form:C1466.tCategory

Help_Entr_Initialize(CorektPhaseClear)

$esHelp:=ds:C1482[$tHelp].query($tQuery)

Help_Entr_LoadHList($esHelp)