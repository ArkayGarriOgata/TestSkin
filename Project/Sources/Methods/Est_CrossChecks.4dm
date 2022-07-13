//%attributes = {"publishedWeb":true}
//PM:  Est_CrossChecks  -> continue? 9/13/99  MLB
//test for consistency and validity of input
//mlb01/11/01 add some gluers
// Modified by: Mel Bohince (8/1/16) use current state of fContinue
// Modified by: Mel Bohince (3/26/19) re-write with out use of sets, $modificationMLB_26_03_19

C_BOOLEAN:C305($0; $1; $2; $3; $Imaje; $Inspection; $StrateLine)  //true for pass, false for fail
C_LONGINT:C283($numSubForms; $4)  //  
C_BOOLEAN:C305($securitySensorsCosted; $complexGluingCosted; $inspectionCosted; $formChangeCosted; $stampingOperation; $diesCosted; $modificationMLB_26_03_19)  //Modified by: Mel Bohince (3/26/19) tests to be completed
$modificationMLB_26_03_19:=True:C214
$0:=<>fContinue  // Modified by: Mel Bohince (8/1/16) // no longer abort est calculation
$Imaje:=$1  //job spec requirement
$Inspection:=$2  //job spec requirement
$StrateLine:=$3  //job spec requirement
$numSubForms:=$4  //job spec requirement

//testing that given certain job spec requirements that the operations have been correctly set up for costing
SELECTION TO ARRAY:C260([Estimates_Machines:20]CostCtrID:4; $_costCtr; [Estimates_Machines:20]Flex_Field5:25; $_flex5; [Estimates_Machines:20]Flex_field6:37; $_flex6; [Estimates_Machines:20]FormChangeHere:9; $_formChg)
$numMachs:=Size of array:C274($_costCtr)
SELECTION TO ARRAY:C260([Estimates_Materials:29]Commodity_Key:6; $_comKey)
$numMatls:=Size of array:C274($_comKey)

If ($Imaje)  //---imaje
	$securitySensorsCosted:=False:C215
	
	For ($i; 1; $numMachs)
		If (Position:C15($_costCtr{$i}; <>GLUERS)>0)  //is this a gluing operation
			If ($_flex6{$i})
				$securitySensorsCosted:=True:C214  // at least one gluer is set as using sensor labels
			End if 
		End if 
	End for 
	
	If (Not:C34($securitySensorsCosted))
		Est_LogIt("WARNING "+" WARNING "+" WARNING ")
		Est_LogIt("WARNING "+" WARNING "+" WARNING "+": A carton has Security Sensors, but it has not been set on glueing operation. ")
		Est_LogIt("WARNING "+" WARNING "+" WARNING ")
		BEEP:C151
	End if 
End if   //---imaje

If (Not:C34($StrateLine))  //---complex gluing
	$complexGluingCosted:=False:C215
	
	For ($i; 1; $numMachs)
		If (Position:C15($_costCtr{$i}; <>GLUERS)>0)  //is this a gluing operation
			If ($_flex5{$i})
				$complexGluingCosted:=True:C214  // at least one gluer is set as using sensor labels
			End if 
		End if 
	End for 
	
	If (Not:C34($complexGluingCosted))
		Est_LogIt("WARNING "+" WARNING "+" WARNING ")
		Est_LogIt("WARNING "+" WARNING "+" WARNING"+": A carton has complex gluing, it has not been set on gluing operation. ")
		Est_LogIt("WARNING "+" WARNING "+" WARNING ")
		BEEP:C151
	End if 
End if   //---complex gluing

If ($Inspection)  //---$Inspection
	$inspectionCosted:=False:C215
	
	For ($i; 1; $numMachs)
		If ($_costCtr{$i}="502")
			$inspectionCosted:=True:C214  //need costcenter in the route
		End if 
	End for 
	
	If (Not:C34($inspectionCosted))
		Est_LogIt("WARNING "+" WARNING "+" WARNING ")
		Est_LogIt("WARNING "+" WARNING "+" WARNING"+": A carton has Inspection, but a 502 operation has not been included.")
		Est_LogIt("WARNING "+" WARNING "+" WARNING ")
		BEEP:C151
	End if 
End if   //---$Inspection

If ($numSubForms>1)  //---form change, issue error, not warning if fail
	$formChangeCosted:=False:C215
	
	For ($i; 1; $numMachs)
		If ($_formChg{$i})
			$formChangeCosted:=True:C214  //at least one specified
		End if 
	End for 
	
	If (Not:C34($formChangeCosted))
		Est_LogIt("ERROR "+" WARNING "+" WARNING ")
		Est_LogIt("ERROR "+" ERROR "+" ERROR"+": Subforms specified, must indicate the operation with a form change. ")
		Est_LogIt("ERROR "+" WARNING "+" WARNING ")
		$0:=False:C215  ///abort the calc in the calling method
		BEEP:C151
	End if 
End if   //---form change

//Check for dies if stamping is used
$stampingOperation:=False:C215
$diesCosted:=False:C215

For ($i; 1; $numMachs)
	If (Position:C15($_costCtr{$i}; <>STAMPERS)>0)  //is this a stamping operation, embossing is not a 462|463 anymore, see method CostCtr_Description_Tweak, regardless, dies are needed
		$stampingOperation:=True:C214  // at least one stamping sequence 
	End if 
End for 

If ($stampingOperation)
	$hit:=Find in array:C230($_comKey; "07@")  //look for dies
	$diesCosted:=($hit>-1)
	If (Not:C34($diesCosted))
		Est_LogIt("WARNING "+" WARNING "+" WARNING ")
		Est_LogIt("WARNING "+" WARNING "+" WARNING"+": Stamping/Embossing, but no dies. ")
		Est_LogIt("WARNING "+" WARNING "+" WARNING ")
		BEEP:C151
	End if 
End if 


