//Why use this:
//.    You want to support On After Keystoke event and not On Data Change

//How to use this:
//.    Name the picture Modl_nFormName_Find
//.    Name the variable Modl_tFormName_Find
//.      the only event for this is On After Keystroke
//.    Modl_FormName_Initialize in CorektPhaseClear set the variable
//.        Modl_tFormName_Find:=CorektBlank
//.    Modl_FormName_Initialize in CorektPhaseInitialize set the placeholder
//.        OBJECT SET PLACEHOLDER(Modl_tFormName_Find;"Name")
//.    Script of object put:  Modl_OM_Variable(Object Get Pointer)
//.    In Modl_OM_Variable and the following condition
//.           : ($tVariableName=Modl_tFormName_Find)
//.              Modl_FormName_Find 
//.    Create method Modl_FormName_Find 
