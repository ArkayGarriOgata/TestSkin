//%attributes = {}
//Method:  Qury_View_Initialize(tStatus{;pOption1})
//Description:  This method will inititlaize the values for the
//  Qury_View form. It doesn't look for a form event so that
//  the form can be reinitialized without having to execute a
//  form event.

If (True:C214)  //Initialize
	
	C_TEXT:C284($1; $tPhase)
	
	C_LONGINT:C283($nRow)
	
	$tPhase:=$1
	
	$nRow:=0
	
End if   //Done initialize

Case of   //Phase
		
	: ($tPhase=CorektPhaseInitialize)
		
		Qury_View_Add(Form:C1466.cQuery)
		
End case   //Done phase
