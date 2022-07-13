//%attributes = {}
// -------
// Method: PF_prepGlueSchedule   ( ) ->
// By: Mel Bohince @ 03/22/18, 14:36:51
// Description
// weak attempt at a backup of priorities using apply formula 
// ----------------------------------------------------
C_TEXT:C284($1; $mutable)
C_LONGINT:C283($delim)
If (Count parameters:C259=1)  //($1="save")  
	//480#10*1234567
	[Job_Forms_Items:44]PriorPriority:59:=[Job_Forms_Items:44]Gluer:47+"#"+String:C10([Job_Forms_Items:44]Priority:48)+"*"+String:C10([Job_Forms_Items:44]GlueEstimatedEnd:53)
	[Job_Forms_Items:44]Gluer:47:=""
	[Job_Forms_Items:44]Priority:48:=999999
	[Job_Forms_Items:44]GlueEstimatedEnd:53:=0
	
Else   //restore
	$mutable:=[Job_Forms_Items:44]PriorPriority:59
	$delim:=Position:C15("#"; $mutable)
	[Job_Forms_Items:44]Gluer:47:=Substring:C12([Job_Forms_Items:44]PriorPriority:59; 1; ($delim-1))
	$mutable:=Substring:C12($mutable; ($delim+1))
	$delim:=Position:C15("*"; $mutable)
	[Job_Forms_Items:44]Priority:48:=Num:C11(Substring:C12($mutable; 1; ($delim-1)))
	$mutable:=Substring:C12($mutable; ($delim+1))
	[Job_Forms_Items:44]GlueEstimatedEnd:53:=Num:C11($mutable)
End if 
