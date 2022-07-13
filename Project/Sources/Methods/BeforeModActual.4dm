//%attributes = {"publishedWeb":true}
//(p) BeforeModActual
//moved code from before of layout proc
//• 7/10/98 cs created
//• 7/10/98 cs create named selection of JMI because Page 6 changes selection
// Modified by: MelvinBohince (3/22/22) display fixed price if > 0

wWindowTitle("Push"; "Jobform {actuals} "+[Job_Forms:42]JobFormID:5)

//serverMethodDone_local:=False
//$server_pid:=Execute on server("Job_beforeOnLoadModAct";64*1024;"Updating items of "+[Job_Forms]JobFormID;[Job_Forms]JobFormID)
//
//If ([Job_Forms]StartDate=!00/00/00!) & (iMode<3)
//dDateBegin:=!00/00/00!
//$server_pid2:=Execute on server("Job_beforeOnLoadStartDate";64*1024;"Getting Start of "+[Job_Forms]JobFormID;[Job_Forms]JobFormID)
//End if 

If (iMode>2)  //• 12/17/97 cs disable closeout button on REveiw
	OBJECT SET ENABLED:C1123(*; "modOnly@"; False:C215)
End if 
OBJECT SET ENABLED:C1123(hdRec; False:C215)
OBJECT SET ENABLED:C1123(bDelete; False:C215)
fNewXFer:=False:C215  //BAK 10/12/94 - for new [RM_XFer] record
<>asJobAPages:=1
fRECALC:=False:C215
fRecalcAct:=False:C215

fBudMaint:=True:C214
fCalcAlloc:=False:C215
ProcId:=0  //budget veiwer proc id

READ ONLY:C145([Process_Specs:18])
READ ONLY:C145([Customers_Projects:9])
READ ONLY:C145([Finished_Goods_Transactions:33])
READ ONLY:C145([ProductionSchedules:110])

If (Read only state:C362([Job_Forms:42]))
	READ ONLY:C145([Job_Forms_Items:44])
	READ ONLY:C145([Job_Forms_Machines:43])
	READ ONLY:C145([Job_Forms_Materials:55])
	READ ONLY:C145([Job_Forms_Machine_Tickets:61])
	READ ONLY:C145([Raw_Materials_Transactions:23])
	<>rmXferInquire:=True:C214
Else 
	READ WRITE:C146([Job_Forms_Items:44])
	READ WRITE:C146([Job_Forms_Machines:43])
	READ WRITE:C146([Job_Forms_Materials:55])
	READ WRITE:C146([Job_Forms_Machine_Tickets:61])
	READ WRITE:C146([Raw_Materials_Transactions:23])
	READ WRITE:C146([Job_Forms_Master_Schedule:67])
	<>rmXferInquire:=False:C215
End if 

//C_TIME($timeOutAt)
//$timeOutAt:=Current time+†00:03:00†
//
//Repeat   `don't load related until SP from above is finished
//GET PROCESS VARIABLE($server_pid;serverMethodDone;serverMethodDone_local)
//DELAY PROCESS(Current process;10)
//Until (serverMethodDone_local) | (Current time>$timeOutAt)
//If (Current time<$timeOutAt)
//SET PROCESS VARIABLE($server_pid;serverMethodDone;False)  `release the SP
//End if 
//
//
//If ([Job_Forms]StartDate=!00/00/00!) & (iMode<3)
//serverMethodDone_local:=False
//C_TIME($timeOutAt)
//$timeOutAt:=Current time+†00:03:00†
//Repeat   `don't load related until SP from above is finished
//GET PROCESS VARIABLE($server_pid2;serverMethodDone;serverMethodDone_local)
//DELAY PROCESS(Current process;10)
//Until (serverMethodDone_local) | (Current time>$timeOutAt)
//If (Current time<$timeOutAt)
//GET PROCESS VARIABLE($server_pid2;dDateBegin;dDateBegin)
//[Job_Forms]StartDate:=dDateBegin
//SET PROCESS VARIABLE($server_pid2;serverMethodDone;False)  `release the SPEnd if 
//End if 
//End if 

Jobform_load_related

zwStatusMsg("sum"; "[Finished_Goods_Transactions]Qty")
rTotXfer:=Sum:C1([Finished_Goods_Transactions:33]Qty:6)


If (Not:C34(Read only state:C362([Job_Forms:42])))
	zwStatusMsg("pop"; "[Job_Forms_Items]Qty_MachTicket")
	DISTINCT VALUES:C339([Job_Forms_Items:44]ItemNumber:7; $aJobit)
	ARRAY LONGINT:C221($aMTqty; Size of array:C274($aJobit))
	
	SELECTION TO ARRAY:C260([Job_Forms_Machine_Tickets:61]GlueMachItemNo:4; $aMTJobit; [Job_Forms_Machine_Tickets:61]Good_Units:8; $aGood)
	
	C_LONGINT:C283($i; $numElements)
	$numElements:=Size of array:C274($aJobit)
	
	For ($i; 1; $numElements)
		$aMTqty{$i}:=0
		For ($j; 1; Size of array:C274($aMTJobit))
			If ($aMTJobit{$j}=$aJobit{$i})
				$aMTqty{$i}:=$aMTqty{$i}+$aGood{$j}
			End if 
		End for 
	End for 
	If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 First record
		
		FIRST RECORD:C50([Job_Forms_Items:44])
		
	Else 
		
		//see line 87
		
	End if   // END 4D Professional Services : January 2019 First record
	// 4D Professional Services : after Order by , query or any query type you don't need First record  
	
	For ($i; 1; Records in selection:C76([Job_Forms_Items:44]))
		$hit:=Find in array:C230($aJobit; [Job_Forms_Items:44]ItemNumber:7)
		If ($hit>-1)
			[Job_Forms_Items:44]Qty_MachTicket:36:=$aMTqty{$hit}
			$aMTqty{$hit}:=0
		Else 
			[Job_Forms_Items:44]Qty_MachTicket:36:=0
		End if 
		SAVE RECORD:C53([Job_Forms_Items:44])
		NEXT RECORD:C51([Job_Forms_Items:44])
	End for 
	
	zwStatusMsg("pop"; "Jobform_setStart_Date")
	
	Jobform_setStart_Date
End if 

//If ([Job_Forms]UnBudgetedVFIss)  `if there are unbudgeted issues from VF
//s1:="Unbudgeted issued against "+"this job. "
//s1:=s1+"Examine the Issues to determine"+" if the Closeout should use them."
//Else 
If ([Job_Forms:42]FixedSalesValue:92>0)  // Modified by: MelvinBohince (3/22/22) 
	s1:="Sales value for this jobform has been set to: "+String:C10([Job_Forms:42]FixedSalesValue:92; "$###,###,##0.00")
Else 
	s1:=""
End if 

//End if 

If (<>PHYSICAL_INVENORY_IN_PROGRESS)
	OBJECT SET ENABLED:C1123(*; "modOnly@"; False:C215)
End if 