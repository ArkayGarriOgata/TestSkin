//%attributes = {}
// _______
// Method: Bookings_Display   ( $display_c ;from; to) ->
// By: Mel Bohince @ 11/30/21, 09:01:24
// Description
// 
// ----------------------------------------------------
C_COLLECTION:C1488($display_c; $1)
$display_c:=$1
C_DATE:C307($2; $3)

$winRef:=Open form window:C675("Bookings_4DViewPro")
C_OBJECT:C1216($form_o)
$form_o:=New object:C1471("bookings_c"; $display_c; "from"; $2; "to"; $3)
DIALOG:C40("Bookings_4DViewPro"; $form_o)
CLOSE WINDOW:C154($winRef)
