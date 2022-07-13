
$tabNumber:=Selected list items:C379(ieBagTabs)
GET LIST ITEM:C378(ieBagTabs; $tabNumber; $itemRef; $itemText)
overwindow:="MachineLog for "+sCriterion1
$winRef:=OpenFormWindow(->[Job_Forms_Machine_Tickets:61]; "Input"; ->overwindow; "")
C_TEXT:C284(machineClass)
machineClass:=CostCtr_getClass([Job_Forms_Machine_Tickets:61]CostCenterID:2)  // Modified by: Mel Bohince (10/19/16) 
// Modified by: Mel Bohince (1/17/20) 
UNLOAD RECORD:C212([Job_Forms_Machine_Tickets:61])
READ WRITE:C146([Job_Forms_Machine_Tickets:61])
LOAD RECORD:C52([Job_Forms_Machine_Tickets:61])
//end modified

MODIFY RECORD:C57([Job_Forms_Machine_Tickets:61]; *)
CLOSE WINDOW:C154($winRef)

UNLOAD RECORD:C212([Job_Forms_Machine_Tickets:61])

// ******* Verified  - 4D PS - January  2019 ********
READ ONLY:C145([Job_Forms_Machine_Tickets:61])
QUERY SELECTION:C341([Job_Forms_Machine_Tickets:61]; [Job_Forms_Machine_Tickets:61]Sequence:3=Num:C11(Substring:C12($itemText; 1; 3)))


// ******* Verified  - 4D PS - January 2019 (end) *********

ORDER BY:C49([Job_Forms_Machine_Tickets:61]; [Job_Forms_Machine_Tickets:61]Sequence:3; >; [Job_Forms_Machine_Tickets:61]GlueMachItemNo:4; >; [Job_Forms_Machine_Tickets:61]DateEntered:5; >; [Job_Forms_Machine_Tickets:61]P_C:10; <)
