

OBJECT SET ENABLED:C1123(*; "memberValidate1"; False:C215)  //only enable if change was made

Form:C1466.editEntity:=masterClass.new()  //create a reference
//Form.editEntity[Form.idField]:=app_set_id_as_string (Form.masterTable)//see trigger


FORM GOTO PAGE:C247(2)
