//%attributes = {}
// _______
// Method: patternEntityColl2ListBox   ( ) ->
// By: Mel Bohince @ 09/23/19, 14:35:11
// Description
// dont pass the entity collection directly to the 
// list box via the form variable; instead,
// copy that to a new object and then it becomes
// an attribute of the "Form" object

// see Job_price_component

// ----------------------------------------------------
$cpn:="91411363"
C_OBJECT:C1216($jobIts)
$jobIts:=ds:C1482.Job_Forms_Items.query("ProductCode = :1"; $cpn).orderBy("Jobit asc")

C_OBJECT:C1216($form_o)
$form_o:=New object:C1471
$form_o.jobItems:=$jobIts

$winRef:=OpenFormWindow(->[Job_Forms_Items:44]; "PickJobitFromList")
DIALOG:C40([Job_Forms_Items:44]; "PickJobitFromList"; $form_o)

//now the listbox's data source is Form.jobItems
//and the current item can be Form.currItem
