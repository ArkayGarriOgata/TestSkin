//%attributes = {"publishedWeb":true}
//doLinkjs_n_os()  -JML   9/14/93
//•081595  MLB  
//This interface allows a user to link Orderlines to [Jobmakesitems] and vice-vers

C_TEXT:C284($1)  //"FromJobs"  or "FromOrders"

vViaWho:=$1
wWindowTitle("Push"; "Peg JobItems to Orderlines")
//NewWindow (330;280;0;5;"Peg JobItems to Orderlines")
OpenSheetWindow(->[zz_control:1]; "Link_Js_to_Os")
DIALOG:C40([zz_control:1]; "Link_Js_to_Os")
CLOSE WINDOW:C154
wWindowTitle("Pop")