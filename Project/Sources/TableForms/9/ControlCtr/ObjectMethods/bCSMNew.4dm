// ----------------------------------------------------
// Object Method: [Customers_Projects].ControlCtr.bCSMNew
// ----------------------------------------------------

QUERY:C277([Finished_Goods_Color_SpecMaster:128]; [Finished_Goods_Color_SpecMaster:128]id:1=atID{abColorLB})  // Added by: Mark Zinke (3/26/13)
Pjt_setReferId(pjtId)
ViewSetter(1; ->[Finished_Goods_Color_SpecMaster:128])
FORM GOTO PAGE:C247(ppHome)
SELECT LIST ITEMS BY POSITION:C381(tc_PjtControlCtr; 1)