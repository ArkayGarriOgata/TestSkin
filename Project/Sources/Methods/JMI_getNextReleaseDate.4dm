//%attributes = {}
// ----------------------------------------------------
// User name (OS): Mel Bohince
// Date and time: 08/15/11, 12:19:22
// ----------------------------------------------------
// Method: JMI_getNextReleaseDate({cpn;which_release;->qty_rtn;->mustship_rtn})
// return the n(th) firm release
//see also JMI_getNextReleaseQty

// Modified by: Mel Bohince (10/12/11) Dont include release if shipto = n/a
// ----------------------------------------------------
// Modified by: Mel Bohince (2/25/14) add which next release to look for
// Modified by: Mel Bohince (3/7/14) option to return qty and must ship so successive calls to
// &  can be avoided
// Modified by: Mel Bohince (5/15/14) include THC=-2 which are payuse 
// Modified by: Mel Bohince (9/9/14) include [Customers_ReleaseSchedules]UserDefined_1 as glue comment if requested arg.
// Modified by: Mel Bohince (4/13/16) 0 = option to get covered relesae
// Modified by: Mel Bohince (7/12/19) Kris wants the N/A's included

C_TEXT:C284($1; $cpn)
C_LONGINT:C283($qty; $2; $levelQtyDays)
C_POINTER:C301($ptr_qty_rtn; $3; $ptr_mustship_rtn; $4; $ptr_comment_rtn; $5)
C_DATE:C307($0; $firstDate)
C_BOOLEAN:C305($levelQty)
$levelQtyDays:=0  // this will subtotal the qty's for this date if multiple releases

If (Count parameters:C259=0)
	$cpn:=[Job_Forms_Items:44]ProductCode:3
Else 
	$cpn:=$1
End if 

//If ($cpn="6FKW-01-0114")
//  //TRACE
//End if 


If (Count parameters:C259>1)  //Modified by: Mel Bohince(2/25/14)//add which next release to look for
	$which_release:=$2  // 0 will be temporary until after search
Else 
	$which_release:=1  //get the next uncovered release
End if 

If (Count parameters:C259>2)  //pointers to other rtn values
	$ptr_qty_rtn:=$3
	$ptr_mustship_rtn:=$4
	$ptr_comment_rtn:=$5
End if 

READ ONLY:C145([Customers_ReleaseSchedules:46])

QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]ProductCode:11=$cpn; *)
QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]CustomerRefer:3#"<@"; *)
QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]OpenQty:16>0; *)
// Modified by: Mel Bohince (7/12/19) Kris wants the N/A's included
//QUERY([Customers_ReleaseSchedules]; & ;[Customers_ReleaseSchedules]Shipto#"N/A";*)  //quazi hold state
QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]Shipto:10#"?????"; *)  //quazi hold state
// Modified by: Mel Bohince (5/15/14) include THC=-2 which are payuse, to revert uncomment line 48 and comment 49-51
//QUERY([Customers_ReleaseSchedules]; & ;[Customers_ReleaseSchedules]THC_State>1;*)  //excludeing -2 payuse
If ($which_release>0)  // Modified by: Mel Bohince (4/13/16) 0 = option to get covered relesae
	QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]THC_State:39#0; *)  //not already covered; want need mfg or payuse
	QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]THC_State:39#1; *)  //not already covered in xc cc
End if 
QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]THC_State:39#-1; *)  //shipped
QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]Sched_Date:5#!00-00-00!)

If ($which_release=0)  // Modified by: Mel Bohince (4/13/16) 
	$which_release:=1  //reset to first release of returned selection
End if 
//QUERY SELECTION([Customers_ReleaseSchedules];[Customers_ReleaseSchedules]THC_State>1;*)
//QUERY SELECTION([Customers_ReleaseSchedules];|;[Customers_ReleaseSchedules]THC_State=-2)


If (Records in selection:C76([Customers_ReleaseSchedules:46])>0)
	ARRAY DATE:C224($aDate; 0)
	ARRAY LONGINT:C221($aQty; 0)
	ARRAY BOOLEAN:C223($aMustShip; 0)
	SELECTION TO ARRAY:C260([Customers_ReleaseSchedules:46]Sched_Date:5; $aDate; [Customers_ReleaseSchedules:46]Sched_Qty:6; $aQty; [Customers_ReleaseSchedules:46]MustShip:53; $aMustShip; [Customers_ReleaseSchedules:46]UserDefined_1:52; $aComment)
	REDUCE SELECTION:C351([Customers_ReleaseSchedules:46]; 0)
	SORT ARRAY:C229($aDate; $aQty; $aMustShip; >)
	
	If (Size of array:C274($aDate)>=$which_release)  //Modified by: Mel Bohince(2/25/14)//add which next release to look for
		$0:=$aDate{$which_release}
		If (Count parameters:C259>2)  //pointers to other rtn values
			//If ($levelQty)
			$firstDate:=Add to date:C393($aDate{$which_release}; 0; 0; $levelQtyDays)  //add a few days to level this out
			$i:=$which_release
			$qty:=0
			While ($i<=Size of array:C274($aDate))
				If ($aDate{$i}<=$firstDate)
					$qty:=$qty+$aQty{$i}+$i  //add the $i value to qty looks a bit off for detection
				End if 
				$i:=$i+1
			End while 
			$ptr_qty_rtn->:=$qty
			
			//Else //don't level
			//$ptr_qty_rtn->:=$aQty{$which_release}
			//End if // leveling
			
			$ptr_mustship_rtn->:=$aMustShip{$which_release}
			$ptr_comment_rtn->:=$aComment{$which_release}
			
		End if 
		
	Else 
		$0:=!00-00-00!
		If (Count parameters:C259>2)  //pointers to other rtn values
			$ptr_qty_rtn->:=0
			$ptr_mustship_rtn->:=False:C215
			$ptr_comment_rtn->:=""
		End if 
	End if 
	
Else 
	$0:=!00-00-00!
	If (Count parameters:C259>2)  //pointers to other rtn values
		$ptr_qty_rtn->:=0
		$ptr_mustship_rtn->:=False:C215
		$ptr_comment_rtn->:=""
	End if 
End if 