// _______
// Method: [ProductionSchedules].PrePressViewer.setDate_BTL   ( ) ->
// By: MelvinBohince @ 03/02/22, 09:08:06
// Description
// 
// ----------------------------------------------------


If (Length:C16(Form:C1466.activeJobSequence_t)=12)  //12345.78.012
	
	JML_SetDate(Substring:C12(Form:C1466.activeJobSequence_t; 1; 8); Num:C11(Substring:C12(Form:C1466.activeJobSequence_t; 10; 3)))
	
	PS_PrePressRefreshLBs
	
	
Else   //btn is disabled, this shouldn't happen
	ALERT:C41("Select a JobSequence first."; "Ok")
End if 