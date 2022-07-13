//%attributes = {}
// _______
// Method: _version210706   ( ) ->
// By: Mel Bohince @ 07/06/21, 12:13:51
// Description
// 
// ----------------------------------------------------

READ WRITE:C146([Cost_Centers:27])

QUERY:C277([Cost_Centers:27]; [Cost_Centers:27]Description:3="@wind@")
APPLY TO SELECTION:C70([Cost_Centers:27]; [Cost_Centers:27]cc_Group:2:="75.WINDOWING")

QUERY:C277([Cost_Centers:27]; [Cost_Centers:27]cc_Group:2="@BLANK@")
APPLY TO SELECTION:C70([Cost_Centers:27]; [Cost_Centers:27]cc_Group:2:="55.BLANKING")


REDUCE SELECTION:C351([Cost_Centers:27]; 0)
