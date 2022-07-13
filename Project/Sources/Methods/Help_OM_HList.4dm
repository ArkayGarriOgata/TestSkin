//%attributes = {}
//Method: Help_OM_HList(tHListName;tFormName)
//Description:  This method runs the code for the HLists in the Help module

If (True:C214)  //Initialize
	
	C_TEXT:C284($1; $tHListName)
	C_TEXT:C284($2; $tFormName)
	
	C_LONGINT:C283($nTable; $nField)
	C_LONGINT:C283($nFormEvent)
	
	$tHListName:=$1
	$tFormName:=$2
	
	$nFormEvent:=Form event code:C388
	
End if   //Done initialize

Case of   //HList
		
	: (($tFormName="Help_Entr") & ($tHListName="CorenHList99"))
		
		Help_Entr_HList
		
	: (($tFormName="Help_View") & ($tHListName="CorenHList1"))
		
		Help_View_HList
		
End case   //Done HList