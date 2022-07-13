//%attributes = {}
If (False:C215)
	// _______
	// Method: PS_PrePressViewer_ui   ( ) ->
	// By: MelvinBohince @ 03/01/22, 10:38:49
	// Description
	// provide the prepress department a view of 4 Presses in one form
	// ----------------------------------------------------
End if 

C_LONGINT:C283($pid; $1)

If (Count parameters:C259=0)
	$pid:=New process:C317(Current method name:C684; 0; Current method name:C684; 1; *)
	SHOW PROCESS:C325($pid)
	
Else   //init
	SET MENU BAR:C67(<>defaultMenu)
	
	searchWidgetInited:=False:C215
	
	
	C_OBJECT:C1216($form_o)
	$form_o:=New object:C1471
	$form_o.params:=New object:C1471("oneWeek"; False:C215; "priorityUnder100"; False:C215; "needPlates"; True:C214; "showCompleted"; False:C215; "bagOk"; True:C214)
	
	//pairing press id's to each quadrant
	$form_o.topLeftPress:="420"
	$form_o.bottomLeftPress:="421"
	$form_o.topRightPress:="418"
	$form_o.bottomRightPress:="419"
	
	//selected job sequences of last clicked quadrant
	$form_o.activeJobSequence_t:=""
	
	//base entity selections for each quad to filter against on the form
	$form_o.topLeftBase_es:=ds:C1482.ProductionSchedules.query("CostCenter = :1"; $form_o.topLeftPress)
	$form_o.bottomLeftBase_es:=ds:C1482.ProductionSchedules.query("CostCenter = :1"; $form_o.bottomLeftPress)
	$form_o.topRightBase_es:=ds:C1482.ProductionSchedules.query("CostCenter = :1"; $form_o.topRightPress)
	$form_o.bottomRightBase_es:=ds:C1482.ProductionSchedules.query("CostCenter = :1"; $form_o.bottomRightPress)
	
	//selected objects in listboxes
	$form_o.clickedTopLeft_o:=Null:C1517
	$form_o.clickedBottomLeft_o:=Null:C1517
	$form_o.clickedTopRight_o:=Null:C1517
	$form_o.clickedBottomRight_o:=Null:C1517
	
	C_LONGINT:C283($winRef)
	$winRef:=OpenFormWindow(->[ProductionSchedules:110]; "PrePressViewer")
	DIALOG:C40([ProductionSchedules:110]; "PrePressViewer"; $form_o)
	CLOSE WINDOW:C154($winRef)
	
End if 
