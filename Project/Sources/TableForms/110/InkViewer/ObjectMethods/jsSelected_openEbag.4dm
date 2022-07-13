// _______
// Method: [ProductionSchedules].PrePressViewer.openEbag_BTL   ( ) ->
// By: MelvinBohince @ 03/02/22, 09:21:20
// Description
// 
// ----------------------------------------------------

If (Length:C16(Form:C1466.activeJobSequence_t)=12)  //12345.78.012
	
	<>jobform:=Substring:C12(Form:C1466.activeJobSequence_t; 1; 8)
	<>jobformseq:=Form:C1466.activeJobSequence_t
	eBag_UI
	
	PS_PrePressRefreshLBs
	
Else   //btn is disabled, this shouldn't happen
	uConfirm("Select a JobSequence first."; "Ok")
End if 