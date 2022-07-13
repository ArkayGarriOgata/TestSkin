//OM: CommissionType() -> 
//@author mlb - 3/12/03  16:31

SAVE RECORD:C53([Customers_Projects:9])
$pjtSelected:=Selected list items:C379(pjt_picker)
GET LIST ITEM:C378(pjt_picker; $pjtSelected; $itemRef; $itemText)
SET LIST ITEM:C385(pjt_picker; $itemRef; [Customers_Projects:9]Name:2; $itemRef)
//REDRAW LIST(pjt_picker)