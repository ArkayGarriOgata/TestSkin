//%attributes = {}

// Method: PSG_MasterArray (msg;numeric;text) ->  
// ----------------------------------------------------
// Author: Mel Bohince
// Created: 02/25/14, 09:11:27
// ----------------------------------------------------
// Description
// manage the arrays used in the GlueSchedule listbox
// based on pattern_Collection
// ----------------------------------------------------
// Modified by: Mel Bohince (9/30/14) save changed glue style back to fg record
// Modified by: Mel Bohince (5/6/15) was read write 
// Modified by: MelvinBohince (3/18/22) apply changes to all subforms on Store

C_TEXT:C284($msg; $1; $3)
C_LONGINT:C283($0; $2; $numJMI; $numJML; $i; $hit; $numOthers)

$msg:=$1
//utl_Logfile ("bench_mark.log";"PSG_MasterArray("+$msg+")")

Case of 
	: ($msg="new")
		$0:=PSG_MasterArray("size"; 0)
		
	: ($msg="add")  //***TODO
		//INSERT IN ARRAY(aRecNum;1;1)
		//$0:=Size of array(aRecNum)
		//CREATE RECORD([Job_Forms_Items])
		//SAVE RECORD([Job_Forms_Items])
		//aRecNum{1}:=Record number([Job_Forms_Items])
		
	: ($msg="dispose")
		$0:=PSG_MasterArray("size"; 0)
		//CLEAR NAMED SELECTION("inMemory")
		
	: ($msg="delete")  //***TODO
		//GOTO RECORD([Job_Forms_Items];aRecNum{$2})
		//DELETE RECORD([Job_Forms_Items])
		//DELETE FROM ARRAY(aRecNum;$2)
		//$0:=Size of array(aRecNum)
		
	: ($msg="size")
		//Arrays loaded from the jobit table unless noted
		ARRAY LONGINT:C221(aRecNum; $2)  //hidden
		ARRAY TEXT:C222(aGluer; $2)
		ARRAY LONGINT:C221(aPrior; $2)
		ARRAY TEXT:C222(aCustLine; $2)  //Arrays from fg and release tables
		ARRAY TEXT:C222(aCPN; $2)
		ARRAY TEXT:C222(aJobit; $2)
		ARRAY LONGINT:C221(aSubForm; $2)  //hidden
		ARRAY TEXT:C222(aCustID; $2)  //hidden
		ARRAY LONGINT:C221(aQtyPlnd; $2)  //really going to be Want qty
		ARRAY LONGINT:C221(aQtyReleased; $2)  //Arrays from fg and release tables
		ARRAY DATE:C224(aReleased; $2)  //Arrays from fg and release tables
		ARRAY DATE:C224(aHRD; $2)
		ARRAY TEXT:C222(aStyle; $2)
		ARRAY TEXT:C222(aOutline; $2)
		ARRAY TEXT:C222(aSeparate; $2)
		ARRAY TEXT:C222(aPrinted; $2)  //Array from the jobmaster log
		ARRAY TEXT:C222(aDieCut; $2)  //Array from the jobmaster log
		ARRAY TEXT:C222(aComment; $2)
		ARRAY TEXT:C222(aProgressStatus; $2)
		ARRAY BOOLEAN:C223(aLaunch; $2)  //launch or original/Repeat
		ARRAY BOOLEAN:C223(aMustShip; $2)
		ARRAY REAL:C219(aDurationHrs; $2)
		ARRAY BOOLEAN:C223(aCasesOrdered; $2)
		ARRAY BOOLEAN:C223(aCasesMade; $2)  // Modified by: Mel Bohince (2/3/16) 
		ARRAY LONGINT:C221(aCashFlow; $2)  // Modified by: Mel Bohince (9/16/16) 
		
		
		$0:=Size of array:C274(aRecNum)
		
	: ($msg="sizeOf")
		$0:=Size of array:C274(aRecNum)
		
	: ($msg="sort")  // make sure what your sorting by is populated!!!
		//;aGlueListBox;aRowStyle;axlRowColor;axlRowBkgd;abHidden)// exclude the listbox arrays, theyre handled clientside
		Case of   //1 - 10 are on server oriented, 11 & up are listbox oriented
			: ($2=1)  //by CPN, hrd, jobit -- HRD 00/00/00's have to be moved to <>MAGIC_DATE first
				MULTI SORT ARRAY:C718(aCPN; >; aHRD; >; aJobit; >; aReleased; aRecNum; aGluer; aPrior; aCustLine; aSubForm; aCustID; aQtyPlnd; aQtyReleased; aStyle; aOutline; aSeparate; aPrinted; aDieCut; aComment; aProgressStatus; aLaunch; aMustShip; aDurationHrs; aCasesOrdered; aCasesMade; aCashFlow)
				$0:=$2
				
			: ($2=2)  //by jobit
				SORT ARRAY:C229(aJobit; aReleased; aRecNum; aGluer; aPrior; aCustLine; aCPN; aSubForm; aCustID; aQtyPlnd; aQtyReleased; aHRD; aStyle; aOutline; aSeparate; aPrinted; aDieCut; aComment; aProgressStatus; aLaunch; aMustShip; aDurationHrs; aCasesOrdered; aCasesMade; aCashFlow; >)
				$0:=$2
				
			: ($2=3)  //by planned qty desending
				SORT ARRAY:C229(aQtyPlnd; aReleased; aRecNum; aGluer; aPrior; aCustLine; aCPN; aJobit; aSubForm; aCustID; aQtyReleased; aHRD; aStyle; aOutline; aSeparate; aPrinted; aDieCut; aComment; aProgressStatus; aLaunch; aMustShip; aDurationHrs; aCasesOrdered; aCasesMade; aCashFlow; <)
				$0:=$2
				
			: ($2=4)  //by release date
				SORT ARRAY:C229(aReleased; aRecNum; aGluer; aPrior; aCustLine; aCPN; aJobit; aSubForm; aCustID; aQtyPlnd; aQtyReleased; aHRD; aStyle; aOutline; aSeparate; aPrinted; aDieCut; aComment; aProgressStatus; aLaunch; aMustShip; aDurationHrs; aCasesOrdered; aCasesMade; aCashFlow; >)
				$0:=$2
				
			: ($2=5)  //by gluer, priority, and release date
				MULTI SORT ARRAY:C718(aGluer; >; aPrior; >; aReleased; >; aQtyPlnd; >; aRecNum; aCustLine; aCPN; aJobit; aSubForm; aCustID; aQtyReleased; aHRD; aStyle; aOutline; aSeparate; aPrinted; aDieCut; aComment; aProgressStatus; aLaunch; aMustShip; aDurationHrs; aCasesOrdered; aCasesMade; aCashFlow)
				$0:=$2
				
			: ($2=6)  //by gluer, priority, and release date
				MULTI SORT ARRAY:C718(aGluer; >; aJobit; >; aPrior; aReleased; aQtyPlnd; aRecNum; aCustLine; aCPN; aSubForm; aCustID; aQtyReleased; aHRD; aStyle; aOutline; aSeparate; aPrinted; aDieCut; aComment; aProgressStatus; aLaunch; aMustShip; aDurationHrs; aCasesOrdered; aCasesMade; aCashFlow)
				$0:=$2
				
			: ($2=9)  //look for more useful default order
				MULTI SORT ARRAY:C718(aReleased; >; aHRD; >; aGluer; >; aRecNum; aPrior; aCustLine; aCPN; aJobit; aSubForm; aCustID; aQtyPlnd; aQtyReleased; aStyle; aOutline; aSeparate; aPrinted; aDieCut; aComment; aProgressStatus; aLaunch; aMustShip; aDurationHrs; aCasesOrdered; aCasesMade; aCashFlow)
				$0:=$2
				
			Else 
				$0:=-1
		End case 
		
	: ($msg="load")
		READ ONLY:C145([Job_Forms_Items:44])  // Modified by: Mel Bohince (5/6/15) was read write 
		QUERY:C277([Job_Forms_Items:44]; [Job_Forms_Items:44]Completed:39=!00-00-00!; *)  //get all the uncompleted items
		QUERY:C277([Job_Forms_Items:44];  & ; [Job_Forms_Items:44]Gluer:47#"NOT")  //see PSG_NotGlued
		$numJMI:=PSG_MasterArray("size"; Records in selection:C76([Job_Forms_Items:44]))  //size it now so supplimental arrays are built at the same time
		
		SELECTION TO ARRAY:C260([Job_Forms_Items:44]; aRecNum; [Job_Forms_Items:44]Gluer:47; aGluer; [Job_Forms_Items:44]Priority:48; aPrior; [Job_Forms_Items:44]ProductCode:3; aCPN; [Job_Forms_Items:44]Jobit:4; aJobit; [Job_Forms_Items:44]SubFormNumber:32; aSubForm; [Job_Forms_Items:44]CustId:15; aCustID; [Job_Forms_Items:44]Qty_Want:24; aQtyPlnd; [Job_Forms_Items:44]MAD:37; aHRD; [Job_Forms_Items:44]GlueStyle:51; aStyle; [Job_Forms_Items:44]OutlineNumber:43; aOutline; [Job_Forms_Items:44]Separate:49; aSeparate; [Job_Forms_Items:44]GluerComment:50; aComment; [Job_Forms_Items:44]GlueRate:52; aDurationHrs; [Job_Forms_Items:44]Cases:44; aCasesOrdered; [Job_Forms_Items:44]CasesMade:55; aCasesMade; [Job_Forms_Items:44]CashFlow:58; aCashFlow)
		//COPY NAMED SELECTION([Job_Forms_Items];"inMemory")
		REDUCE SELECTION:C351([Job_Forms_Items:44]; 0)
		
		$0:=Size of array:C274(aRecNum)
		//now need consolidate then get data from suplimental tables aCustLine, aQtyReleased, aReleased, aPrinted, aDieCut, apPrinted, apDieCut
		
	: ($msg="consolidate")
		$rtn:=PSG_MasterArray("sort"; 2)  //by jobit
		$lastJobit:="start"
		$numJMI:=Size of array:C274(aJobit)
		//$checksum:=0
		For ($i; 1; $numJMI)  //Consolidate subforms and set up hashtable for cache of related tables
			//$checksum:=$checksum+aQtyPlnd{$i}
			If (aJobit{$i}=$lastJobit)
				aQtyPlnd{$i-1}:=aQtyPlnd{$i-1}+aQtyPlnd{$i}
				//aDurationHrs{$i-1}:=aDurationHrs{$i-1}+aDurationHrs{$i}
				aQtyPlnd{$i}:=0
				//aDurationHrs{$i}:=0
			Else 
				$lastJobit:=aJobit{$i}
			End if 
			
			If (aHRD{$i}=!00-00-00!)
				aHRD{$i}:=<>MAGIC_DATE  //Move way out so they don't screw up the sorting
			End if 
		End for   //consolidating subform qty's
		
		//now clear out the ones that aren't needed after consolidation
		$rtn:=PSG_MasterArray("sort"; 3)  //descending by planned qty
		$hit:=Find in array:C230(aQtyPlnd; 0)
		If ($hit>-1)
			$numJMI:=PSG_MasterArray("size"; ($hit-1))
		End if 
		
		//$checksum2:=0
		//For ($i;1;$numJMI)  //Check if consolidated subforms has same qty as before consolidating
		//$checksum2:=$checksum2+aQtyPlnd{$i}
		//End for 
		
		$0:=$numJMI
		
	: ($msg="more_details")
		//utl_Logfile ("bench_mark.log";"THC CHeck("+$msg+")")
		//check for new releases and set THC if any are found
		//$fence:=util_DateOfNext3Days 
		//READ ONLY([Customers_ReleaseSchedules])
		//QUERY([Customers_ReleaseSchedules];[Customers_ReleaseSchedules]Sched_Date<=$fence;*)
		//QUERY([Customers_ReleaseSchedules]; & ;[Customers_ReleaseSchedules]CustomerRefer#"<@";*)
		//QUERY([Customers_ReleaseSchedules]; & ;[Customers_ReleaseSchedules]PayU=0;*)
		//QUERY([Customers_ReleaseSchedules]; & ;[Customers_ReleaseSchedules]THC_State=9)
		//If (Records in selection([Customers_ReleaseSchedules])>0)
		//  //utl_Logfile ("bench_mark.log";"THC Run("+$msg+")")
		//  //<>ThcBatchDat:=Add to date(Current date;0;0;-1)  //force run
		//BatchTHCcalc ("no-rpt")
		//End if 
		
		//utl_Logfile ("bench_mark.log";"hashtables("+$msg+")")
		ARRAY TEXT:C222(aJML_jobform; 0)
		ARRAY TEXT:C222(aCustomer; 0)
		ARRAY TEXT:C222(aFinishedGoodKey; 0)
		
		For ($i; 1; Size of array:C274(aJobit))  //set up hashtable for cache of related tables
			$jobform:=Substring:C12(aJobit{$i}; 1; 8)
			$hit:=Find in array:C230(aJML_jobform; $jobform)
			If ($hit=-1)
				APPEND TO ARRAY:C911(aJML_jobform; $jobform)  //Will use this next for query with array
			End if 
			
			$hit:=Find in array:C230(aCustomer; aCustID{$i})
			If ($hit=-1)
				APPEND TO ARRAY:C911(aCustomer; aCustID{$i})  //Will use this next for query with array
			End if 
			
			$fgkey:=aCustID{$i}+":"+aCPN{$i}
			$hit:=Find in array:C230(aFinishedGoodKey; $fgkey)
			If ($hit=-1)
				APPEND TO ARRAY:C911(aFinishedGoodKey; $fgkey)  //Will use this next for query with array
			End if 
			
		End for   //each jobit hashtable
		
		//Cache the glue ready and printed data
		QUERY WITH ARRAY:C644([Job_Forms_Master_Schedule:67]JobForm:4; aJML_jobform)
		ARRAY TEXT:C222(aJML_jobform; 0)  //reset to match select2array
		ARRAY DATE:C224(aJML_glue_ready; 0)  //converting a date to yes or blank
		ARRAY DATE:C224(aJML_printed; 0)
		ARRAY TEXT:C222(aJML_glue_readyYN; 0)
		ARRAY TEXT:C222(aJML_printedYN; 0)
		SELECTION TO ARRAY:C260([Job_Forms_Master_Schedule:67]JobForm:4; aJML_jobform; [Job_Forms_Master_Schedule:67]GlueReady:28; aJML_glue_ready; [Job_Forms_Master_Schedule:67]Printed:32; aJML_printed)
		SORT ARRAY:C229(aJML_jobform; aJML_glue_ready; aJML_printed; >)
		$numJML:=Size of array:C274(aJML_jobform)
		ARRAY TEXT:C222(aJML_glue_readyYN; $numJML)
		ARRAY TEXT:C222(aJML_printedYN; $numJML)
		For ($i; 1; $numJML)  //convert date to yes or blank for glue ready and printed
			If (aJML_glue_ready{$i}#!00-00-00!)
				aJML_glue_readyYN{$i}:="YES"
			Else 
				aJML_glue_readyYN{$i}:=""
			End if 
			If (aJML_printed{$i}#!00-00-00!)
				aJML_printedYN{$i}:="Yes"
			Else 
				aJML_printedYN{$i}:=""
			End if 
		End for 
		ARRAY DATE:C224(aJML_glue_ready; 0)
		ARRAY DATE:C224(aJML_printed; 0)
		
		//Cache the in WIP array
		QUERY WITH ARRAY:C644([Job_Forms:42]JobFormID:5; aJML_jobform)
		
		ARRAY TEXT:C222(aJF_jobform; 0)  //reset to match select2array
		ARRAY TEXT:C222(aJF_status; 0)
		SELECTION TO ARRAY:C260([Job_Forms:42]JobFormID:5; aJF_jobform; [Job_Forms:42]Status:6; aJF_status)
		SORT ARRAY:C229(aJF_jobform; aJF_status; >)
		$numJML:=Size of array:C274(aJML_jobform)
		
		//Cache the customer name
		READ ONLY:C145([Customers:16])
		QUERY WITH ARRAY:C644([Customers:16]ID:1; aCustomer)
		ARRAY TEXT:C222(aCustomer; 0)  //Reset to match select2array
		SELECTION TO ARRAY:C260([Customers:16]ID:1; aCustomer; [Customers:16]Name:2; aCustomerName)
		SORT ARRAY:C229(aCustomer; aCustomerName; >)
		
		//Cache the fg data of line, orig or repeat, gluetype, and style
		QUERY WITH ARRAY:C644([Finished_Goods:26]FG_KEY:47; aFinishedGoodKey)
		ARRAY TEXT:C222(aFinishedGoodKey; 0)  //Reset to match select2array
		SELECTION TO ARRAY:C260([Finished_Goods:26]FG_KEY:47; aFinishedGoodKey; [Finished_Goods:26]GlueType:34; aFinishedGoodGlueType; [Finished_Goods:26]Line_Brand:15; aFinishedGoodLine; [Finished_Goods:26]OriginalOrRepeat:71; aFinishedGoodOR)
		SORT ARRAY:C229(aFinishedGoodKey; aFinishedGoodGlueType; aFinishedGoodLine; aFinishedGoodOR; >)
		//utl_Logfile ("bench_mark.log";"begin loop("+$msg+")")
		//fill in the missing values
		$rtn:=PSG_MasterArray("sort"; 1)  //descending by cpn cause if more than one open jobit, spread the releases out
		$lastCPN:="start"
		$release_number:=1
		For ($i; 1; Size of array:C274(aJobit))
			//look for multiple open jobits and thc the releases
			//If (aCPN{$i}="6fkw-01-0114")
			//TRACE
			//End if 
			aCashFlow{$i}:=Round:C94(aCashFlow{$i}/1000; 0)
			If ($lastCPN=aCPN{$i})  //look for next release
				$release_number:=$release_number+1
			Else   //just get the first release
				$release_number:=1
				$lastCPN:=aCPN{$i}
			End if 
			// Modified by: Mel Bohince (9/9/14) add [Customers_ReleaseSchedules]UserDefined_1 to comments
			aReleased{$i}:=JMI_getNextReleaseDate(aCPN{$i}; $release_number; ->aQtyReleased{$i}; ->aMustShip{$i}; ->$UserDefined1)
			If (aReleased{$i}=!00-00-00!)
				aReleased{$i}:=<>MAGIC_DATE  //Move way out so they don't screw up the sorting
				aQtyReleased{$i}:=0
				aMustShip{$i}:=False:C215
			Else 
				If (aMustShip{$i})
					If (Position:C15("Must Ship"; aComment{$i})=0)
						aComment{$i}:=aComment{$i}+" Must Ship "+String:C10(aReleased{$i})
					End if 
				End if 
				
				If (Position:C15($UserDefined1; aComment{$i})=0)
					aComment{$i}:=aComment{$i}+" "+$UserDefined1
				End if 
			End if 
			//aReleased{$i}:=JMI_getNextReleaseDate (aCPN{$i};$release_number)
			//If (aReleased{$i}=!00/00/00!)
			//aReleased{$i}:=<>MAGIC_DATE  //Move way out so they don't screw up the sorting
			//aQtyReleased{$i}:=0
			//aMustShip{$i}:=False
			//Else 
			//aQtyReleased{$i}:=JMI_getNextReleaseQty (aCPN{$i};$release_number)
			//aMustShip{$i}:=JMI_getNextReleaseIsMustShip (aCPN{$i};$release_number)
			//If (aMustShip{$i})
			//If (Position("Must Ship";aComment{$i})=0)
			//aComment{$i}:=aComment{$i}+" Must Ship "+String(aReleased{$i})
			//End if 
			//End if 
			//End if 
			
			//Get custname prefix
			$hit:=Find in array:C230(aCustomer; aCustID{$i})
			If ($hit>-1)
				$cust_name:=Substring:C12(aCustomerName{$hit}; 1; 4)
			Else 
				$cust_name:="n/f_"
			End if 
			
			//Get fg rec data
			$fgkey:=aCustID{$i}+":"+aCPN{$i}
			$hit:=Find in array:C230(aFinishedGoodKey; $fgkey)
			If ($hit>-1)
				If (Length:C16(aStyle{$i})=0)  //not already set
					aStyle{$i}:=aFinishedGoodGlueType{$hit}
				End if 
				aCustLine{$i}:=$cust_name+"-"+aFinishedGoodLine{$hit}
				aLaunch{$i}:=(aFinishedGoodOR{$hit}#"Repeat")  //FG_LaunchItem
				
			Else 
				If (Length:C16(aStyle{$i})=0)  //Not already set
					aStyle{$i}:="n/f"
				End if 
				aCustLine{$i}:=$cust_name+"n/f"
				aLaunch{$i}:=False:C215
			End if 
			
			If (aHRD{$i}=!00-00-00!)  // this was moved up to "consolidate as the HRD sort is needed before grabbing release info
				aHRD{$i}:=<>MAGIC_DATE  //Move way out so they don't screw up the sorting
			End if 
			
			If (Length:C16(aSeparate{$i})=0)  //not yet determined
				//look to see if other items are on the same form
				SET QUERY DESTINATION:C396(Into variable:K19:4; $numOthers)
				QUERY:C277([Job_Forms_Items:44]; [Job_Forms_Items:44]JobForm:1=Substring:C12(aJobit{$i}; 1; 8); *)
				QUERY:C277([Job_Forms_Items:44];  & ; [Job_Forms_Items:44]ProductCode:3#aCPN{$i})
				SET QUERY DESTINATION:C396(Into current selection:K19:1)
				If ($numOthers>0)
					aSeparate{$i}:="YES"
				End if 
			End if 
			
			If (Length:C16(aGluer{$i})=0)
				aGluer{$i}:="N/A"
			End if 
			
			//give visual on stage of job, word to process and red/green for quickview
			$jobform:=Substring:C12(aJobit{$i}; 1; 8)
			$hit:=Find in array:C230(aJML_jobform; $jobform)
			If ($hit>-1)
				aPrinted{$i}:=aJML_printedYN{$hit}
				aDieCut{$i}:=aJML_glue_readyYN{$hit}
			Else 
				aPrinted{$i}:="n/f"
				aDieCut{$i}:="n/f"
			End if 
			
			$hit:=Find in array:C230(aJF_jobform; $jobform)
			If ($hit>-1)
				aProgressStatus{$i}:=aJF_status{$hit}
			Else 
				aProgressStatus{$i}:="n/f"
			End if 
			
		End for   // each jobit
		REDUCE SELECTION:C351([Customers:16]; 0)  // Modified by: Mel Bohince (8/10/15) 
		
		
	: ($msg="store")
		If (Count parameters:C259=2)
			$hit:=$2
		Else 
			$hit:=aGlueListBox
		End if 
		
		PSG_UpdateJobit($hit)  // Modified by: MelvinBohince (3/18/22) 
		
		If (False:C215)  //Modified by: MelvinBohince (3/18/22) 
			
			//READ WRITE([Job_Forms_Items])
			//  GOTO RECORD([Job_Forms_Items];aRecNum{$hit})
			//If (fLockNLoad (->[Job_Forms_Items]))
			//If (User in group(Current user;"Role_Glue_Scheduling"))
			
			//[Job_Forms_Items]Gluer:=aGluer{$hit}
			//[Job_Forms_Items]Priority:=aPrior{$hit}
			//[Job_Forms_Items]Separate:=aSeparate{$hit}
			//[Job_Forms_Items]GluerComment:=aComment{$hit}
			//If ([Job_Forms_Items]GlueStyle#aStyle{$hit})  // Modified by: Mel Bohince (9/30/14) 
			//$updateFG:=True
			//Else 
			//$updateFG:=False
			//End if 
			//[Job_Forms_Items]GlueStyle:=aStyle{$hit}
			//[Job_Forms_Items]MAD:=aHRD{$hit}
			//[Job_Forms_Items]GlueRate:=aDurationHrs{$hit}
			//[Job_Forms_Items]Cases:=aCasesOrdered{$hit}
			//[Job_Forms_Items]CasesMade:=aCasesMade{$hit}
			//SAVE RECORD([Job_Forms_Items])
			//If (Not(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) REDUCE SELECTION
			
			//UNLOAD RECORD([Job_Forms_Items])
			//REDUCE SELECTION([Job_Forms_Items];0)  // Modified by: Mel Bohince (5/6/15) 
			
			//Else 
			
			//REDUCE SELECTION([Job_Forms_Items];0)  // Modified by: Mel Bohince (5/6/15) 
			
			//End if   // END 4D Professional Services : January 2019 
			
			//If ($updateFG)  // Modified by: Mel Bohince (9/30/14) 
			//READ WRITE([Finished_Goods])
			//QUERY([Finished_Goods];[Finished_Goods]ProductCode=aCPN{$hit})
			//If (Records in selection([Finished_Goods])>0)
			//APPLY TO SELECTION([Finished_Goods];[Finished_Goods]GlueType:=aStyle{$hit})
			//If (Records in set("LockedSet")>0)
			//uConfirm ("Style could not be saved in locked F/G record.";"Ok";"Help")
			//End if 
			//If (Not(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) REDUCE SELECTION
			
			//UNLOAD RECORD([Finished_Goods])
			//REDUCE SELECTION([Finished_Goods];0)  // Modified by: Mel Bohince (5/6/15) 
			
			
			//Else 
			
			//REDUCE SELECTION([Finished_Goods];0)  // Modified by: Mel Bohince (5/6/15) 
			
			
			//End if   // END 4D Professional Services : January 2019 
			//End if 
			
			//End if 
			//$0:=aRecNum{$hit}
			//PSG_ServerArrays ("die!")  //Kill the stored procedure so other users can get the changes
			
			//Else 
			//If (aCasesMade{$hit}#[Job_Forms_Items]CasesMade)  // Modified by: Mel Bohince (2/5/16) 
			//[Job_Forms_Items]CasesMade:=aCasesMade{$hit}
			//SAVE RECORD([Job_Forms_Items])
			//If (Not(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) REDUCE SELECTION
			
			//UNLOAD RECORD([Job_Forms_Items])
			//REDUCE SELECTION([Job_Forms_Items];0)
			
			
			//Else 
			
			//REDUCE SELECTION([Job_Forms_Items];0)
			
			//End if   // END 4D Professional Services : January 2019 
			//$0:=aRecNum{$hit}
			//PSG_ServerArrays ("die!")  //Kill the stored procedure so other users can get the changes
			
			//Else 
			//ALERT("You do not have access to make changes.")
			//aGluer{$hit}:=[Job_Forms_Items]Gluer
			//aPrior{$hit}:=[Job_Forms_Items]Priority
			//aSeparate{$hit}:=[Job_Forms_Items]Separate
			//aComment{$hit}:=[Job_Forms_Items]GluerComment
			//aStyle{$hit}:=[Job_Forms_Items]GlueStyle
			//aHRD{$hit}:=[Job_Forms_Items]MAD
			//aDurationHrs{$hit}:=[Job_Forms_Items]GlueRate
			//aCasesOrdered{$hit}:=[Job_Forms_Items]Cases
			//aCasesMade{$hit}:=[Job_Forms_Items]CasesMade
			//$0:=-2
			//End if 
			//End if 
			
			//Else 
			//uConfirm ("Changes were not saved for item "+aJobit{$hit}+", try again later.";"OK";"Locked")
			//aGluer{$hit}:=[Job_Forms_Items]Gluer
			//aPrior{$hit}:=[Job_Forms_Items]Priority
			//aSeparate{$hit}:=[Job_Forms_Items]Separate
			//aComment{$hit}:=[Job_Forms_Items]GluerComment
			//aStyle{$hit}:=[Job_Forms_Items]GlueStyle
			//aHRD{$hit}:=[Job_Forms_Items]MAD
			//aDurationHrs{$hit}:=[Job_Forms_Items]GlueRate
			//aCasesOrdered{$hit}:=[Job_Forms_Items]Cases
			//aCasesMade{$hit}:=[Job_Forms_Items]CasesMade
			//$0:=-1
			//End if 
			//REDUCE SELECTION([Job_Forms_Items];0)
			//READ ONLY([Job_Forms_Items])
			
		End if   //false Modified by: MelvinBohince (3/18/22) 
		
	: ($msg="find")  //***TODO
		Case of 
			: ($3="test")
				$0:=Find in array:C230(aCPN; $2)
			Else 
				$0:=No current record:K29:2
		End case 
		
	: ($msg="get_from_server")  //establish a client side copy of the arrays for display and edit
		GET PROCESS VARIABLE:C371($2; aRecNum; aRecNum; aGluer; aGluer; aPrior; aPrior; aCustLine; aCustLine; aCPN; aCPN; aJobit; aJobit; aSubForm; aSubForm; aCustID; aCustID; aQtyPlnd; aQtyPlnd; aQtyReleased; aQtyReleased; aReleased; aReleased; aHRD; aHRD; aStyle; aStyle; aOutline; aOutline; aSeparate; aSeparate; aProgressStatus; aProgressStatus; aPrinted; aPrinted; aDieCut; aDieCut; aComment; aComment; aLaunch; aLaunch; aMustShip; aMustShip; aDurationHrs; aDurationHrs; aCasesOrdered; aCasesOrdered; aCasesMade; aCasesMade; aCashFlow; aCashFlow)
		$0:=Size of array:C274(aRecNum)
		
End case 

//utl_Logfile ("bench_mark.log";"PSG_MasterArray("+$msg+") END")