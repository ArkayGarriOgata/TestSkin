//Why use this: This supports after keystroke by supporting on data change

//How to use this:
//.    Name the variable Modl_tFormName_Find
//.    Modl_FormName_Initialize in CorektPhaseClear set the variable
//.        Modl_tFormName_Find:=CorektBlank
//.    Script of object put:  Modl_OM_Variable(Object Get Pointer)
//.    In Modl_OM_Variable and the following condition
//.           : ($tVariableName=Modl_tFormName_Find)
//.              Modl_FormName_Find 
//.    Create method Modl_tFormName_Find and do the search

//.Commands provided by the widget:
//.    Modl_FormName_Initialize in the CorektPhaseInitialize you usually call this
//.       SearchPicker SET HELP TEXT("Modl_tFormName_Find";"HelpText")
//.    Modl_FormName_Manager you can control enterability
//.       SearchPicker SET ENTERABLE("Modl_tFormName_Find";bEnterable)


//Example of Modl+FormName_Find

//Method:  Core_Pick_Find
//Description:  This method handles the find for the select form
//  The only event for this object is on after keystroke

//If (True)  //Intialization

//C_LONGINT($nRow)
//C_TEXT($tFind)
//C_POINTER($pColumnArray)
//C_LONGINT($nColumn;$nNumberOfColumns)

//End if   //Done initialization

//$tFind:=Get edited text

//If ($tFind#CorektBlank)  //Something to find

//$tFind:=$tFind+"@"

//$nNumberOfColumns:=4

//For ($nColumn;1;$nNumberOfColumns)  //Loop through Column

//$pColumnArray:=Get pointer("Core_atPick_Value")  //+String($nColumn))

//$nRow:=Find in array($pColumnArray->;$tFind)

//If ($nRow>0)  //Found

//Core_Pick_Select ($nRow)

//$nColumn:=$nNumberOfColumns+1

//End if   //Done found

//End for   //Done looping through Column

//End if   //Done something to find