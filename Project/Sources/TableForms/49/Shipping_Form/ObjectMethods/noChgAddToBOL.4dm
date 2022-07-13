//(P) bPost
//re write of FG_ShipAddToBOL 

BOL_ListBox1("add-to-bol")

BOL_ListBox1("get-totals")

BOL_PickRelease(0)  //do the reset

Core_ObjectSetColor(->iTotal; -(Black:K11:16+(256*Light grey:K11:13)))

OBJECT SET ENABLED:C1123(bCancel; False:C215)  // could lose too much work by accident

EDIT ITEM:C870(release_number)