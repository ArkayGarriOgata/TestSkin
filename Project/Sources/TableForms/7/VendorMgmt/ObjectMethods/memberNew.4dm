// _______
// Method: [Vendors].VendorMgmt.memberNew   ( ) ->
// By: Mel Bohince @ 04/16/20, 09:02:24
// Description
// 
// ----------------------------------------------------

OBJECT SET ENABLED:C1123(*; "memberValidate1"; False:C215)  //only enable if change was made

Form:C1466.editEntity:=Form:C1466.masterClass.new()  //create a reference
//Form.editEntity[Form.idField]:=app_set_id_as_string (Form.masterTable)//see trigger


FORM GOTO PAGE:C247(2)
