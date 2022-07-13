//%attributes = {"publishedWeb":true}
//JMI_get1stRelease
//see also JML_get1stRelease, REL_getNextRelease
// • mel (11/10/04, 15:54:34) don't report a date if other open jobits

C_DATE:C307($0)
C_TEXT:C284($jmi_peg; $1; $thisCPN; $2)
$0:=<>MAGIC_DATE

If (Count parameters:C259=0)
	$jmi_peg:=[Job_Forms_Items:44]OrderItem:2
	$thisCPN:=[Job_Forms_Items:44]ProductCode:3
Else 
	$jmi_peg:=$1
	$thisCPN:=$2
End if 

Case of 
		//: ($otherOpenJMI>0) & (False)  ` • mel (11/9/04, 16:31:23) forget about items with other open jobits, can't say witch will do which.
		//can't really tell, so don't include releases for this item
	Else 
		READ ONLY:C145([Customers_ReleaseSchedules:46])
		QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]OrderLine:4=$jmi_peg; *)
		QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]OpenQty:16>0; *)
		QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]THC_State:39>0; *)
		QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]Sched_Date:5#!00-00-00!)
		
		If (Records in selection:C76([Customers_ReleaseSchedules:46])=0)  //060898 mlb
			QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]ProductCode:11=$thisCPN; *)
			QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]OpenQty:16>0; *)
			QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]THC_State:39>0; *)
			QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]Sched_Date:5#!00-00-00!)
		End if 
		
		If (Records in selection:C76([Customers_ReleaseSchedules:46])>0)
			ARRAY DATE:C224($aDate; 0)
			SELECTION TO ARRAY:C260([Customers_ReleaseSchedules:46]Sched_Date:5; $aDate)
			REDUCE SELECTION:C351([Customers_ReleaseSchedules:46]; 0)
			SORT ARRAY:C229($aDate; >)
			$0:=$aDate{1}
		End if 
		
End case 