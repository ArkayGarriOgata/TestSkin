//%attributes = {}
//Method:  Core_VdVl_Find
//Description:  This method handles the find
//  The only event for this object is on after keystroke

If (True:C214)  //Intialization
	
	C_BOOLEAN:C305($bDisplay)
	
	C_OBJECT:C1216($esCoreValidValue)
	
	C_TEXT:C284($tFind; $tQuery; $tTableName)
	
	$bDisplay:=True:C214
	
	$esCoreValidValue:=New object:C1471()
	
	$tFind:=Get edited text:C655
	$tTableName:=Table name:C256(->[Core_ValidValue:69])
	$tQuery:=CorektBlank
	
End if   //Done initialization

Case of   //Find
		
	: ($tFind=CorektBlank)
		
		$esCoreValidValue:=ds:C1482[$tTableName].all()
		
	: (Length:C16($tFind)<3)
		
		$bDisplay:=False:C215
		
	Else   //Verified
		
		$tFind:=$tFind+"@"
		
		$tQuery:="Category = "+CorektSingleQuote+$tFind+CorektSingleQuote+" or "+\
			"Identifier = "+CorektSingleQuote+$tFind+CorektSingleQuote
		
		$esCoreValidValue:=ds:C1482[$tTableName].query($tQuery)
		
End case   //Done find

If ($bDisplay)  //Display
	
	Core_VdVl_Initialize(CorektPhaseClear)
	
	Core_VdVl_LoadHList($esCoreValidValue)
	
	Core_VdVl_Manager(Current method name:C684)
	
End if   //Done display
