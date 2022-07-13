//[caseform]numbersheets script   -JML   8/20/93

//updates the [formcartons]makesqty field when user changes this value
QUERY:C277([Estimates_FormCartons:48]; [Estimates_FormCartons:48]DiffFormID:2=[Estimates_DifferentialsForms:47]DiffFormId:3)  //ensure that related records are loaded
APPLY TO SELECTION:C70([Estimates_FormCartons:48]; [Estimates_FormCartons:48]MakesQty:5:=[Estimates_FormCartons:48]NumberUp:4*[Estimates_DifferentialsForms:47]NumberSheets:4)
ORDER BY:C49([Estimates_FormCartons:48]; [Estimates_FormCartons:48]ItemNumber:3; >)
REDRAW:C174([Estimates_FormCartons:48])