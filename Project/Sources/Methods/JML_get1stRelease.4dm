//%attributes = {"publishedWeb":true}
//PM: JML_get1stRelease(jobform) -> date
//@author mlb - 3/4/02  10:10
//see also JMI_get1stRelease, JML_getReleaseList
// • mel (8/23/04, 15:17:37) forget about pegging to orderlines, just get cpn
// • mel (11/9/04, 16:31:23) forget about items with other open jobits, can't say witch will do which.
// Modified by: Mel Bohince (4/13/16) consider the forecasts

READ ONLY:C145([Customers_Order_Lines:41])
READ ONLY:C145([Customers_ReleaseSchedules:46])

C_BOOLEAN:C305($stateChanged; $includeForecasts)
C_DATE:C307($0)
C_TEXT:C284($1; $jobform; $2)
C_LONGINT:C283($numJMI; $jmi; $fg; $otherOpenJMI)
C_TEXT:C284($setTo)

If (Not:C34(Read only state:C362([Job_Forms_Items:44])))
	READ ONLY:C145([Job_Forms_Items:44])
	$stateChanged:=True:C214
Else 
	$stateChanged:=False:C215
End if 
ARRAY TEXT:C222($aCPN; 0)
ARRAY DATE:C224($aDate; 0)

$jobform:=$1
If (Count parameters:C259>1)
	$includeForecasts:=True:C214
Else 
	$includeForecasts:=False:C215
End if 

//zwStatusMsg ("1stRel";$1)
If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
	
	$numJMI:=qryJMI($jobform; 0; "@")  //look at all the jobitems
	SELECTION TO ARRAY:C260([Job_Forms_Items:44]ProductCode:3; $aCPN)
	QUERY WITH ARRAY:C644([Customers_ReleaseSchedules:46]ProductCode:11; $aCPN)
	QUERY SELECTION:C341([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]OpenQty:16>0; *)
	If (Not:C34($includeForecasts))
		QUERY SELECTION:C341([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]CustomerRefer:3#"<@"; *)
	End if 
	QUERY SELECTION:C341([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]Shipto:10#"N/A"; *)  //quazi hold state
	QUERY SELECTION:C341([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]Shipto:10#"?????"; *)  //quazi hold state
	QUERY SELECTION:C341([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]THC_State:39>1; *)
	QUERY SELECTION:C341([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]Sched_Date:5#!00-00-00!)  //quazi hold state
	
Else 
	
	//you need to see line 36
	
	QUERY BY FORMULA:C48([Customers_ReleaseSchedules:46]; \
		([Customers_ReleaseSchedules:46]ProductCode:11=[Job_Forms_Items:44]ProductCode:3)\
		 & ([Job_Forms_Items:44]ProductCode:3="@")\
		 & ([Job_Forms_Items:44]JobForm:1=$jobform)\
		 & ([Customers_ReleaseSchedules:46]OpenQty:16>0)\
		)
	
	If (Not:C34($includeForecasts))
		QUERY SELECTION:C341([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]CustomerRefer:3#"<@"; *)
	End if 
	QUERY SELECTION:C341([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]Shipto:10#"N/A"; *)  //quazi hold state
	QUERY SELECTION:C341([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]Shipto:10#"?????"; *)  //quazi hold state
	QUERY SELECTION:C341([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]THC_State:39>1; *)
	QUERY SELECTION:C341([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]Sched_Date:5#!00-00-00!)  //quazi hold state
	
End if   // END 4D Professional Services : January 2019 query selection

If (Records in selection:C76([Customers_ReleaseSchedules:46])>0)
	SELECTION TO ARRAY:C260([Customers_ReleaseSchedules:46]Sched_Date:5; $aDate)
	SORT ARRAY:C229($aDate; >)
	$0:=$aDate{1}
Else 
	$0:=<>MAGIC_DATE
End if 


If (False:C215)
	$setTo:=" Rerun  FORECAST"  //ignor Excess  and Fill-in  
	If ($numJMI>0)
		CREATE EMPTY SET:C140([Customers_ReleaseSchedules:46]; "rels")  //collect all the open releases for this jobform
		For ($jmi; 1; $numJMI)
			$otherOpenJMI:=0
			$thisCPN:=[Job_Forms_Items:44]ProductCode:3
			If ([Job_Forms_Items:44]MAD:37#!00-00-00!)
				$thisMAD:=[Job_Forms_Items:44]MAD:37
			Else 
				$thisMAD:=<>MAGIC_DATE
			End if 
			SET QUERY DESTINATION:C396(Into variable:K19:4; $otherOpenJMI)  // • mel (11/9/04, 16:31:23) forget about items with other open jobits, can't say witch will do which.
			QUERY:C277([Job_Forms_Items:44]; [Job_Forms_Items:44]ProductCode:3=$thisCPN; *)
			QUERY:C277([Job_Forms_Items:44];  & ; [Job_Forms_Items:44]Completed:39=!00-00-00!; *)
			QUERY:C277([Job_Forms_Items:44];  & ; [Job_Forms_Items:44]MAD:37#!00-00-00!; *)
			QUERY:C277([Job_Forms_Items:44];  & ; [Job_Forms_Items:44]MAD:37<$thisMAD; *)
			QUERY:C277([Job_Forms_Items:44];  & ; [Job_Forms_Items:44]JobForm:1#$jobform)
			SET QUERY DESTINATION:C396(Into current selection:K19:1)
			
			Case of 
				: ($otherOpenJMI>0)  // • mel (11/9/04, 16:31:23) forget about items with other open jobits, can't say witch will do which.
					//can't really tell, so don't include releases for this item
					
				: (Position:C15([Job_Forms_Items:44]OrderItem:2; $setTo)>0) | (True:C214)  // • mel (8/23/04, 15:17:14)
					SET QUERY DESTINATION:C396(Into set:K19:2; "includeThese")
					QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]ProductCode:11=[Job_Forms_Items:44]ProductCode:3; *)
					QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]OpenQty:16>0; *)
					QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]THC_State:39>0; *)  //• mlb - 5/9/02  11:36 just look for what isn't covered by inventory
					QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]Sched_Date:5#!00-00-00!)
					SET QUERY DESTINATION:C396(Into current selection:K19:1)
					
					If (Records in set:C195("includeThese")>0)
						UNION:C120("rels"; "includeThese"; "rels")
					End if 
					//For ($fg;1;Records in selection([ReleaseSchedule]))
					//ADD TO SET([ReleaseSchedule];"rels")
					//NEXT RECORD([ReleaseSchedule])
					//End for 
					
				Else 
					QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]OrderLine:3=[Job_Forms_Items:44]OrderItem:2)
					If (Records in selection:C76([Customers_Order_Lines:41])>0)  //only do it for firm orders
						QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]OrderLine:4=[Job_Forms_Items:44]OrderItem:2; *)
						QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]OpenQty:16>0; *)
						QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]Sched_Date:5#!00-00-00!)
						
						For ($fg; 1; Records in selection:C76([Customers_ReleaseSchedules:46]))
							ADD TO SET:C119([Customers_ReleaseSchedules:46]; "rels")
							NEXT RECORD:C51([Customers_ReleaseSchedules:46])
						End for 
					End if   //valid orlind  
			End case 
			
			NEXT RECORD:C51([Job_Forms_Items:44])
		End for 
		
		USE SET:C118("rels")
		CLEAR SET:C117("rels")
		//*      Get the earliest release
		
		//see above QUERY SELECTION([ReleaseSchedule];[ReleaseSchedule]THC_State>0)
		If (Records in selection:C76([Customers_ReleaseSchedules:46])>0)
			
			ARRAY DATE:C224($aDate; 0)
			SELECTION TO ARRAY:C260([Customers_ReleaseSchedules:46]Sched_Date:5; $aDate)
			SORT ARRAY:C229($aDate; >)
			$0:=$aDate{1}
		End if 
	End if   //jmi  
	
End if   //false

If ($stateChanged)
	READ WRITE:C146([Job_Forms_Items:44])
End if 

