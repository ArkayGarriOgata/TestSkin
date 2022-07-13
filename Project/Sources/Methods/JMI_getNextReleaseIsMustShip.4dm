//%attributes = {}

// Method: JMI_getNextReleaseIsMustShip ( )  -> 
// ----------------------------------------------------
// Author: Mel Bohince
// Created: 03/03/14, 13:42:14
// ----------------------------------------------------
// Description
// 
//
// ----------------------------------------------------

C_TEXT:C284($1; $cpn)
C_LONGINT:C283($qty; $2)
C_BOOLEAN:C305($0)

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
//QUERY([Customers_ReleaseSchedules]; & ;[Customers_ReleaseSchedules]THC_State#0;*)  //not already covered; want need mfg or payuse
//QUERY([Customers_ReleaseSchedules]; & ;[Customers_ReleaseSchedules]THC_State#1;*)  //not already covered in xc cc
//QUERY([Customers_ReleaseSchedules]; & ;[Customers_ReleaseSchedules]THC_State#-1;*)  //shipped
QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]Sched_Date:5#!00-00-00!)

If (Records in selection:C76([Customers_ReleaseSchedules:46])>0)
	ARRAY DATE:C224($aDate; 0)
	ARRAY BOOLEAN:C223($aMustShip; 0)
	SELECTION TO ARRAY:C260([Customers_ReleaseSchedules:46]Sched_Date:5; $aDate; [Customers_ReleaseSchedules:46]MustShip:53; $aMustShip)
	REDUCE SELECTION:C351([Customers_ReleaseSchedules:46]; 0)
	SORT ARRAY:C229($aDate; $aMustShip; >)
	$0:=$aMustShip{$which_release}
	
Else 
	$0:=False:C215
End if 

