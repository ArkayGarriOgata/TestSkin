//%attributes = {"publishedWeb":true}
//PM: JML_getReleaseList() -> 
//@author mlb - 3/11/03  15:31
//based on JML_get1stRelease(jobform) -> date
// • mel (8/23/04, 15:17:37) forget about pegging to orderlines, just get cpn

READ ONLY:C145([Customers_Order_Lines:41])

C_BOOLEAN:C305($stateChanged)

If (Not:C34(Read only state:C362([Job_Forms_Items:44])))
	READ ONLY:C145([Job_Forms_Items:44])
	$stateChanged:=True:C214
Else 
	$stateChanged:=False:C215
End if 
READ ONLY:C145([Customers_ReleaseSchedules:46])
C_TEXT:C284($1; $jobform)
$jobform:=$1

C_LONGINT:C283($numJMI; $jmi; $fg)
C_TEXT:C284($setTo; $text; $0)
$setTo:=" Rerun  FORECAST"  //ignor Excess  and Fill-in  
zwStatusMsg("List Rels"; $1)
$numJMI:=qryJMI($jobform; 0; "@")  //look at all the jobitems
If ($numJMI>0)
	If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 Next record
		CREATE EMPTY SET:C140([Customers_ReleaseSchedules:46]; "rels")  //collect all the open releases for this jobform
		For ($jmi; 1; $numJMI)
			
			Case of 
				: (Position:C15([Job_Forms_Items:44]OrderItem:2; $setTo)>0) | (True:C214)  // • mel (8/23/04, 15:17:14)
					QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]ProductCode:11=[Job_Forms_Items:44]ProductCode:3; *)
					QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]OpenQty:16>0; *)
					QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]THC_State:39#0; *)
					QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]Sched_Date:5#!00-00-00!)
					
					For ($fg; 1; Records in selection:C76([Customers_ReleaseSchedules:46]))
						ADD TO SET:C119([Customers_ReleaseSchedules:46]; "rels")
						NEXT RECORD:C51([Customers_ReleaseSchedules:46])
					End for 
					
				Else 
					QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]OrderLine:3=[Job_Forms_Items:44]OrderItem:2)
					If (Records in selection:C76([Customers_Order_Lines:41])>0)  //only do it for firm orders
						QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]OrderLine:4=[Job_Forms_Items:44]OrderItem:2; *)
						QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]OpenQty:16>0; *)
						QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]THC_State:39#0; *)
						QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]Sched_Date:5#!00-00-00!)
					End if   //valid orlind  
					
					If (Records in selection:C76([Customers_ReleaseSchedules:46])=0)  //open up the search
						QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]ProductCode:11=[Job_Forms_Items:44]ProductCode:3; *)
						QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]OpenQty:16>0; *)
						QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]THC_State:39#0; *)
						QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]Sched_Date:5#!00-00-00!)
					End if 
					
					For ($fg; 1; Records in selection:C76([Customers_ReleaseSchedules:46]))
						ADD TO SET:C119([Customers_ReleaseSchedules:46]; "rels")
						NEXT RECORD:C51([Customers_ReleaseSchedules:46])
					End for 
			End case 
			
			NEXT RECORD:C51([Job_Forms_Items:44])
		End for 
		
		USE SET:C118("rels")
		CLEAR SET:C117("rels")
		QUERY SELECTION:C341([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]THC_State:39>0; *)
		QUERY SELECTION:C341([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]CustomerRefer:3#("<@"))
		
	Else 
		//OD Else never gona work because mel use true condition
		
		ARRAY TEXT:C222($_ProductCode; 0)
		
		SELECTION TO ARRAY:C260([Job_Forms_Items:44]ProductCode:3; $_ProductCode)
		QUERY WITH ARRAY:C644([Customers_ReleaseSchedules:46]ProductCode:11; $_ProductCode)
		// Modified by: Mel Bohince (2/11/19) next 5 lines changed to Query Selection instead of just Query
		QUERY SELECTION:C341([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]OpenQty:16>0; *)
		QUERY SELECTION:C341([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]THC_State:39#0; *)
		QUERY SELECTION:C341([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]Sched_Date:5#!00-00-00!; *)
		QUERY SELECTION:C341([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]THC_State:39>0; *)
		QUERY SELECTION:C341([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]CustomerRefer:3#("<@"))
		
	End if   // END 4D Professional Services : January 2019 query selection
	
	//*      Get the earliest release
	//• mlb - 5/9/02  11:36 just look for what isn't covered by inventory
	If (Records in selection:C76([Customers_ReleaseSchedules:46])>0)
		C_TEXT:C284($t; $cr)
		$t:=Char:C90(9)
		$cr:=Char:C90(13)
		$text:="Date         "+$t+"  CPN            "+$t+"    Release#"+$cr
		ARRAY DATE:C224($aDate; 0)
		ARRAY LONGINT:C221($aRelNum; 0)
		ARRAY TEXT:C222($aCPN; 0)
		SELECTION TO ARRAY:C260([Customers_ReleaseSchedules:46]Sched_Date:5; $aDate; [Customers_ReleaseSchedules:46]ReleaseNumber:1; $aRelNum; [Customers_ReleaseSchedules:46]ProductCode:11; $aCPN)
		SORT ARRAY:C229($aDate; $aCPN; $aRelNum; >)
		For ($i; 1; Size of array:C274($aDate))
			$text:=$text+String:C10($aDate{$i}; Internal date short:K1:7)+$t+$aCPN{$i}+$t+"  #:"+String:C10($aRelNum{$i}; "#,###,###")+$cr
		End for 
		$0:=$text
		
	Else 
		$0:=""
	End if 
Else 
	$0:=""
End if   //jmi  

If ($stateChanged)
	READ WRITE:C146([Job_Forms_Items:44])
End if 