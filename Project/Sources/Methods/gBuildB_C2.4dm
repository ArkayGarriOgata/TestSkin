//%attributes = {"publishedWeb":true}
//(P) gBuildB_C2  Build arrays B & C
//May 6, 1996 TJF
//-------------------------------

C_LONGINT:C283($i; $k; $distinct; $machBud; $hit)
C_TEXT:C284($PrevCC)
C_TEXT:C284($PrevDesc)
C_DATE:C307($Date)

READ ONLY:C145([Cost_Centers:27])
READ ONLY:C145([Job_Forms_Machine_Tickets:61])

MESSAGES OFF:C175  //042096 TJF

QUERY:C277([Job_Forms_Machines:43]; [Job_Forms_Machines:43]JobForm:1=[Job_Forms:42]JobFormID:5)  //*032696 TJF
SELECTION TO ARRAY:C260([Job_Forms_Machines:43]CostCenterID:4; $MJ_CC; [Job_Forms_Machines:43]Sequence:5; $MJ_Seq; [Job_Forms_Machines:43]Effectivity:3; $MJ_EDate; [Job_Forms_Machines:43]Planned_MR_Hrs:15; $MJ_BMRHrs; [Job_Forms_Machines:43]Planned_RunHrs:37; $MJ_BRunHrs; [Job_Forms_Machines:43]OutsideService:41; $MJ_OutSer)

//++++++++++++++++++++++++++++++
//array for un-issued machine test
$machBud:=Records in selection:C76([Job_Forms_Machines:43])
$distinct:=0
ARRAY TEXT:C222($budMach; $machBud)
ARRAY DATE:C224($eDate; $machBud)  //````````````*****
If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 Next record
	
	FIRST RECORD:C50([Job_Forms_Machines:43])
	For ($i; 1; $machBud)
		$hit:=Find in array:C230($budMach; [Job_Forms_Machines:43]CostCenterID:4)
		If ($hit=-1)
			$distinct:=$distinct+1
			$budMach{$distinct}:=[Job_Forms_Machines:43]CostCenterID:4
			$eDate{$distinct}:=[Job_Forms_Machines:43]Effectivity:3  //````````````*****
		End if 
		NEXT RECORD:C51([Job_Forms_Machines:43])
	End for 
	
Else 
	
	ARRAY TEXT:C222($_CostCenterID; 0)
	ARRAY DATE:C224($_Effectivity; 0)
	
	SELECTION TO ARRAY:C260([Job_Forms_Machines:43]CostCenterID:4; $_CostCenterID; [Job_Forms_Machines:43]Effectivity:3; $_Effectivity)
	
	For ($i; 1; $machBud; 1)
		$hit:=Find in array:C230($budMach; $_CostCenterID{$i})
		If ($hit=-1)
			$distinct:=$distinct+1
			$budMach{$distinct}:=$_CostCenterID{$i}
			$eDate{$distinct}:=$_Effectivity{$i}
		End if 
		
	End for 
	
End if   // END 4D Professional Services : January 2019 First record

ARRAY TEXT:C222($budMach; $distinct)
ARRAY DATE:C224($eDate; $distinct)
SORT ARRAY:C229($budMach; $eDate; >)
ARRAY LONGINT:C221($hasActual; $distinct)
//++++++++++++++++++++++++++++++
RELATE MANY SELECTION:C340([Job_Forms_Machine_Tickets:61]JobForm:1)  //this use to was a relate many, it couldn't work!
SELECTION TO ARRAY:C260([Job_Forms_Machine_Tickets:61]CostCenterID:2; $MT_CC; [Job_Forms_Machine_Tickets:61]Sequence:3; $MT_Seq; [Job_Forms_Machine_Tickets:61]MR_Act:6; $MT_AMR; [Job_Forms_Machine_Tickets:61]MR_AdjStd:14; $MT_AdjMR; [Job_Forms_Machine_Tickets:61]Run_Act:7; $MT_ARun; [Job_Forms_Machine_Tickets:61]Run_AdjStd:15; $MT_AdjRun; [Job_Forms_Machine_Tickets:61]DateEntered:5; $MT_Date)
SORT ARRAY:C229($MT_CC; $MT_Seq; $MT_AMR; $MT_AdjMR; $MT_ARun; $MT_AdjRun; $MT_Date)
$PrevCC:=""
$PrevDesc:=""
$k:=0

For ($i; 1; Size of array:C274($MT_CC))
	sCostCenter:=CostCtr_Substitution($MT_CC{$i})
	If ([Cost_Centers:27]ID:1#sCostCenter)
		$e:=1
		$founddate:=False:C215
		Repeat 
			$e:=Find in array:C230($MJ_CC; $MT_CC{$i}; $e)
			If ($e#-1)
				If ($MJ_Seq{$e}=$MT_Seq{$i})
					$Date:=$MJ_EDate{$e}  //use efficitivity date
					$founddate:=True:C214
				End if 
				$e:=$e+1
			Else 
				If (Not:C34($founddate))
					$Date:=$MT_Date{$i}  //use date machine ticket was entered
				End if 
			End if 
		Until ($e=-1)
		findCC(sCostCenter; $Date)
		
	End if 
	
	If ($PrevDesc=[Cost_Centers:27]Description:3)  //just tally the actual hrs
		ayB4{$k}:=ayB4{$k}+$MT_AdjMR{$i}  //[MachineTicket]MR_AdjStd
		ayB6{$k}:=ayB6{$k}+$MT_AMR{$i}  //[MachineTicket]MR_Act
		
		ayC4{$k}:=ayC4{$k}+$MT_AdjRun{$i}  //[MachineTicket]Run_AdjStd
		ayC6{$k}:=ayC6{$k}+$MT_ARun{$i}  //[MachineTicket]Run_Act
		
	Else   //finish out the last mach tick
		If ($PrevCC#"")  //not the first loop
			ayB2{$k}:=Round:C94(ayB2{$k}*ayBX{$k}; 0)  //convert to dollars
			ayB3{$k}:=Round:C94(ayB2{$k}*rH2; 0)
			ayB4{$k}:=Round:C94(ayB4{$k}*ayBX{$k}; 0)  //convert to dollars
			ayB5{$k}:=ayB3{$k}-ayB4{$k}
			ayB6{$k}:=Round:C94(ayB6{$k}*ayBX{$k}; 0)  //convert to dollars
			ayB7{$k}:=ayB3{$k}-ayB6{$k}
			
			ayC2{$k}:=Round:C94(ayC2{$k}*ayCX{$k}; 0)  //convert to dollars
			ayC3{$k}:=Round:C94(ayC2{$k}*rH2; 0)
			ayC4{$k}:=Round:C94(ayC4{$k}*ayCX{$k}; 0)  //convert to dollars
			ayC5{$k}:=ayC3{$k}-ayC4{$k}
			ayC6{$k}:=Round:C94(ayC6{$k}*ayCX{$k}; 0)  //convert to dollars
			ayC7{$k}:=ayC3{$k}-ayC6{$k}
			
			$hit:=Find in array:C230($budMach; $PrevCC)  //mark the commodity as being used
			If ($hit>0)
				$hasActual{$hit}:=1
			End if 
		End if 
		//set up for next cost ctr
		$k:=$k+1
		$PrevCC:=sCostCenter  //[MachineTicket]CostCenterID
		$PrevDesc:=[Cost_Centers:27]Description:3
		
		ARRAY TEXT:C222(ayB1; $k)  //upr 1407
		ARRAY REAL:C219(ayB2; $k)
		ARRAY REAL:C219(ayB3; $k)
		ARRAY REAL:C219(ayB4; $k)
		ARRAY REAL:C219(ayB5; $k)
		ARRAY REAL:C219(ayB6; $k)
		ARRAY REAL:C219(ayB7; $k)
		ARRAY REAL:C219(ayBX; $k)
		ayB1{$k}:=Substring:C12([Cost_Centers:27]cc_Group:2; 1; 2)+Substring:C12([Cost_Centers:27]Description:3; 1; 30)  //upr 1407
		ayBX{$k}:=[Cost_Centers:27]MHRoopSales:7
		
		ARRAY TEXT:C222(ayC1; $k)
		ARRAY REAL:C219(ayC2; $k)
		ARRAY REAL:C219(ayC3; $k)
		ARRAY REAL:C219(ayC4; $k)
		ARRAY REAL:C219(ayC5; $k)
		ARRAY REAL:C219(ayC6; $k)
		ARRAY REAL:C219(ayC7; $k)
		ARRAY REAL:C219(ayCX; $k)
		ayC1{$k}:=ayB1{$k}
		ayCX{$k}:=ayBX{$k}
		
		//------------------- Get Book Estimete --------
		ayB2{$k}:=0
		ayC2{$k}:=0
		// TRACE
		$p:=1
		Repeat 
			$p:=Find in array:C230($MJ_CC; sCostCenter; $p)
			If ($p#-1)
				
				If ($MJ_OutSer{$p}=False:C215)
					ayB2{$k}:=ayB2{$k}+$MJ_BMRHrs{$p}
					ayC2{$k}:=ayC2{$k}+$MJ_BRunHrs{$p}
				End if 
				$p:=$p+1
			End if 
		Until ($p=-1)
		
		//------------------------------------------------------
		ayB4{$k}:=ayB4{$k}+$MT_AdjMR{$i}  //[MachineTicket]MR_AdjStd
		ayB6{$k}:=ayB6{$k}+$MT_AMR{$i}  //[MachineTicket]MR_Act
		
		ayC4{$k}:=ayC4{$k}+$MT_AdjRun{$i}  //[MachineTicket]Run_AdjStd
		ayC6{$k}:=ayC6{$k}+$MT_ARun{$i}  //[MachineTicket]Run_Act
		
	End if 
End for 

//-------------- Do the last CC --------------------
ayB2{$k}:=Round:C94(ayB2{$k}*ayBX{$k}; 0)  //convert to dollars
ayB3{$k}:=Round:C94(ayB2{$k}*rH2; 0)
ayB4{$k}:=Round:C94(ayB4{$k}*ayBX{$k}; 0)  //convert to dollars
ayB5{$k}:=ayB3{$k}-ayB4{$k}
ayB6{$k}:=Round:C94(ayB6{$k}*ayBX{$k}; 0)  //convert to dollars
ayB7{$k}:=ayB3{$k}-ayB6{$k}

ayC2{$k}:=Round:C94(ayC2{$k}*ayCX{$k}; 0)  //convert to dollars
ayC3{$k}:=Round:C94(ayC2{$k}*rH2; 0)
ayC4{$k}:=Round:C94(ayC4{$k}*ayCX{$k}; 0)  //convert to dollars
ayC5{$k}:=ayC3{$k}-ayC4{$k}
ayC6{$k}:=Round:C94(ayC6{$k}*ayCX{$k}; 0)  //convert to dollars
ayC7{$k}:=ayC3{$k}-ayC6{$k}

$hit:=Find in array:C230($budMach; $PrevCC)  //mark the commodity as being used
If ($hit>0)
	$hasActual{$hit}:=1
End if 

//set up un-issued bduget items
For ($i; 1; Size of array:C274($budMach))
	If ($hasActual{$i}=0)
		$k:=$k+1
		If ([Cost_Centers:27]ID:1#$budMach{$i})
			//gFindCC ([MachineTicket]CostCenterID)`upr 1420 2/6/95
			findCC($budMach{$i}; $eDate{$i})
			// findCostCenter ($budMach{$i};$eDate{$i})
		End if 
		
		ARRAY TEXT:C222(ayB1; $k)
		ARRAY REAL:C219(ayB2; $k)
		ARRAY REAL:C219(ayB3; $k)
		ARRAY REAL:C219(ayB4; $k)
		ARRAY REAL:C219(ayB5; $k)
		ARRAY REAL:C219(ayB6; $k)
		ARRAY REAL:C219(ayB7; $k)
		ARRAY REAL:C219(ayBX; $k)
		ayB1{$k}:=Substring:C12([Cost_Centers:27]cc_Group:2; 1; 2)+Substring:C12([Cost_Centers:27]Description:3; 1; 30)
		ayBX{$k}:=[Cost_Centers:27]MHRoopSales:7
		
		ARRAY TEXT:C222(ayC1; $k)
		ARRAY REAL:C219(ayC2; $k)
		ARRAY REAL:C219(ayC3; $k)
		ARRAY REAL:C219(ayC4; $k)
		ARRAY REAL:C219(ayC5; $k)
		ARRAY REAL:C219(ayC6; $k)
		ARRAY REAL:C219(ayC7; $k)
		ARRAY REAL:C219(ayCX; $k)
		ayC1{$k}:=ayB1{$k}
		ayCX{$k}:=ayBX{$k}
		
		//------------------- Get Book Estimete ----------
		ayB2{$k}:=0
		ayC2{$k}:=0
		$p:=1
		Repeat 
			$p:=Find in array:C230($MJ_CC; $budMach{$i}; $p)
			If ($p#-1)
				If ($MJ_OutSer{$p}=False:C215)
					ayB2{$k}:=ayB2{$k}+$MJ_BMRHrs{$p}
					ayC2{$k}:=ayC2{$k}+$MJ_BRunHrs{$p}
				End if 
				$p:=$p+1
			End if 
		Until ($p=-1)
		
		ayB2{$k}:=Round:C94(ayB2{$k}*ayBX{$k}; 0)  //convert to dollars
		ayB3{$k}:=Round:C94(ayB2{$k}*rH2; 0)
		ayB4{$k}:=Round:C94(ayB4{$k}*ayBX{$k}; 0)  //convert to dollars
		ayB5{$k}:=ayB3{$k}-ayB4{$k}
		ayB6{$k}:=Round:C94(ayB6{$k}*ayBX{$k}; 0)  //convert to dollars
		ayB7{$k}:=ayB3{$k}-ayB6{$k}
		
		ayC2{$k}:=Round:C94(ayC2{$k}*ayCX{$k}; 0)  //convert to dollars
		ayC3{$k}:=Round:C94(ayC2{$k}*rH2; 0)
		ayC4{$k}:=Round:C94(ayC4{$k}*ayCX{$k}; 0)  //convert to dollars
		ayC5{$k}:=ayC3{$k}-ayC4{$k}
		ayC6{$k}:=Round:C94(ayC6{$k}*ayCX{$k}; 0)  //convert to dollars
		ayC7{$k}:=ayC3{$k}-ayC6{$k}
		
	End if 
End for 
SORT ARRAY:C229(ayB1; ayB2; ayB3; ayB4; ayB5; ayB6; ayB7; ayBX; >)
SORT ARRAY:C229(ayC1; ayC2; ayC3; ayC4; ayC5; ayC6; ayC7; ayCX; >)
For ($i; 1; Size of array:C274(ayB1))  //lop off the sort character
	ayB1{$i}:=Substring:C12(ayB1{$i}; 3)
	ayC1{$i}:=Substring:C12(ayC1{$i}; 3)
End for 
CLEAR SET:C117("opeartions")