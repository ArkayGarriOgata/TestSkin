//%attributes = {}
//Method:  Help_Entr_Find
//Description:  This method will find and load the hlist
Compiler_0000_ConstantsToDo
If (True:C214)  //Initialize
	
	C_COLLECTION:C1488($cCriterian)
	
	C_LONGINT:C283($nNumberOfCharacters)
	
	C_OBJECT:C1216($esHelp)
	
	C_TEXT:C284($tFind)
	C_TEXT:C284($tHelp; $tObjectName; $tQuery)
	
	$esHelp:=New object:C1471()
	
	$tHelp:=Table name:C256(->[Help:36])
	
	$tObjectName:=OBJECT Get name:C1087(Object current:K67:2)
	
End if   //Done initialize

Case of   //Form event code
		
	: (Form event code:C388=-1)
		
		C_TEXT:C284(Help_Entr_tFind)
		
		SearchPicker SET HELP TEXT($tObjectName; "Find in help")  //widget that 4d uses to sets text for search bar
		
	: (Form event code:C388=On Data Change:K2:15)  //if the value in the search field is changed
		
		$nNumberOfCharacters:=Length:C16(Help_Entr_tFind)
		
		Case of   //Find
				
			: ($nNumberOfCharacters=0)  // clear the form again
				
				Help_Entr_Initialize(CorektPhaseClear)
				
			: ($nNumberOfCharacters<4)  //Need three characters
				
			Else   //Do Find
				
				$tFind:=Get edited text:C655
				
				If ($tFind#CorektBlank)  //Something to find
					
					//create query
					$cCriterian:=New collection:C1472
					$cCriterian.push("Category = "+$tFind)
					$cCriterian.push("Title = "+$tFind)
					$cCriterian.push("Keyword = "+$tFind)
					
					$tQuery:=$cCriterian.join(" or ")
					$tQuery:=$tQuery+" order by Category, Title"
					
					$esHelp:=ds:C1482.Help.query($tQuery)  //create entity selection
					
					Help_Entr_LoadHList($esHelp)
					
					Help_Entr_Manager
					
				End if   //Done something to find
				
		End case   //Done find
		
End case   //Done form event code



