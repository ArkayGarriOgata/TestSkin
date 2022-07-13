//%attributes = {}
// _______
// Method: PS_InkFilter   ( ) ->
// By: MelvinBohince @ 03/24/22, 13:53:57
// Description
// 
// ----------------------------------------------------

C_TEXT:C284($criterion_s; $0)

C_COLLECTION:C1488($criterion_c)
$criterion_c:=New collection:C1472

If (Form:C1466.params.oneWeek)
	$criterion_c.push("StartDate < "+String:C10(Add to date:C393(Current date:C33; 0; 0; 7); ISO date:K1:8))
End if 

If (Form:C1466.params.priorityUnder100)
	$criterion_c.push("Priority < 100")
End if 

If (Form:C1466.params.needInk)
	$criterion_c.push("InkReady = 00/00/00")
End if 

If (Form:C1466.params.showCompleted)
	$criterion_c.push("Completed >= 0")
Else 
	$criterion_c.push("Completed = 0")
End if 

If (Form:C1466.params.released)
	$criterion_c.push("JOB_FORM.PlnnerReleased > 00/00/00")
End if 

$criterion_s:=$criterion_c.join(" and ")
Form:C1466.topLeft_es:=Form:C1466.topLeftBase_es.query($criterion_s).orderBy("Priority")
Form:C1466.bottomLeft_es:=Form:C1466.bottomLeftBase_es.query($criterion_s).orderBy("Priority")
Form:C1466.topRight_es:=Form:C1466.topRightBase_es.query($criterion_s).orderBy("Priority")
Form:C1466.bottomRight_es:=Form:C1466.bottomRightBase_es.query($criterion_s).orderBy("Priority")

$0:=$criterion_s
