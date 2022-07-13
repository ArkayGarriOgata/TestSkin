//%attributes = {}
// ----------------------------------------------------
// User name (OS): Mel Bohince
// Date and time: 08/15/11, 12:21:50
// Modified by: Mel Bohince (10/12/11) Dont include release if shipto = n/a
// ----------------------------------------------------
// Method: JMI_getNextReleaseQty
// see also JMI_getNextReleaseDate
// ----------------------------------------------------
// Modified by: Mel Bohince (4/13/16) 0 = option to get covered relesae

C_TEXT:C284($1; $cpn)
C_LONGINT:C283($0; $qty; $2)
C_BOOLEAN:C305($levelQty)
$levelQty:=False:C215
READ ONLY:C145([Customers_ReleaseSchedules:46])

If (Count parameters:C259=0)
	$cpn:=[Job_Forms_Items:44]ProductCode:3
Else 
	$cpn:=$1
End if 

If (Count parameters:C259>1)
	$which_release:=$2
Else 
	$which_release:=1
End if 

QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]ProductCode:11=$cpn; *)
QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]CustomerRefer:3#"<@"; *)
QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]OpenQty:16>0; *)
QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]Shipto:10#"N/A"; *)  //quazi hold state
QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]Shipto:10#"?????"; *)  //quazi hold state
QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]THC_State:39>1; *)  //was includeing -2 payuse
If ($which_release>0)  // Modified by: Mel Bohince (4/13/16) 0 = option to get covered relesae
	QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]THC_State:39#0; *)  //not already covered; want need mfg or payuse
	QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]THC_State:39#1; *)  //not already covered in xc cc
End if 
QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]THC_State:39#-1; *)  //shipped
QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]Sched_Date:5#!00-00-00!)

If ($which_release=0)  // Modified by: Mel Bohince (4/13/16) 
	$which_release:=1  //reset to first release of returned selection
End if 

$qty:=0
If (Records in selection:C76([Customers_ReleaseSchedules:46])>0)
	ARRAY DATE:C224($aDate; 0)
	ARRAY LONGINT:C221($aQty; 0)
	SELECTION TO ARRAY:C260([Customers_ReleaseSchedules:46]Sched_Date:5; $aDate; [Customers_ReleaseSchedules:46]Sched_Qty:6; $aQty)
	REDUCE SELECTION:C351([Customers_ReleaseSchedules:46]; 0)
	If (Size of array:C274($aDate)>=$which_release)
		SORT ARRAY:C229($aDate; $aQty; >)
		If ($levelQty)
			$firstDate:=Add to date:C393($aDate{$which_release}; 0; 0; 1)  //add a few days to level this out
			$i:=$which_release
			While ($i<=Size of array:C274($aDate))
				If ($aDate{$i}<=$firstDate)
					$qty:=$qty+$aQty{$i}+$i
				End if 
				$i:=$i+1
			End while 
			
		Else 
			$qty:=$aQty{$which_release}
		End if 
		
	End if 
End if 

$0:=$qty