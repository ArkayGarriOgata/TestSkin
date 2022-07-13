//%attributes = {"publishedWeb":true}
// -------
// Method: Batch_JMIActual   ( ) ->
// By: 021397  MLB
// Description
//  
//try to find JMIs which do not have an actual qty even 
//though they have already been produced. Probably
//as a result of a flaw in the ReviseJob proc when
//the job has already started production
//assert the actual qty in the JMI based on the sum of the receipt trans
//• 5/5/97 cs stop procedure from marking do Overs as closed
//•101298  MLB  stop accumulated xaction qty, messes up subforms
// • mel (8/23/04, 14:58:02) stop looking at transactions
// Modified by: Mel Bohince (10/5/15) dont touch proofs
// Modified by: Mel Bohince (3/29/18) remove the low job# section since job id # counter reset to 12001

MESSAGES OFF:C175

C_TEXT:C284($1; $type)

READ WRITE:C146([Job_Forms_Items:44])
READ ONLY:C145([Finished_Goods_Locations:35])
READ ONLY:C145([Finished_Goods_Transactions:33])
READ ONLY:C145([Job_Forms:42])

If (Count parameters:C259=0)
	uYesNoCancel("Assert the actual qty in the JMI based on the sum of the receipt transactions?"; "Revised"; "Zeros"; "Cancel")
	Case of 
		: (bAccept=1)
			$type:="Revised"
		: (bNo=1)
			$type:="Zeros"
		Else 
			$type:="None"  //canceled    
	End case 
	
Else 
	$type:=$1
End if 

Case of 
	: ($type="Revised")
		BEEP:C151
		ALERT:C41("Nah, you don't really want that to happen.")
		
	: ($type="Zeros")
		//NewWindow (200;100;5;5;"Batch JMI set actuals")
		C_TEXT:C284($lowJob; $jobform)
		C_LONGINT:C283($i; $numRecs; $qty; $hit)
		C_DATE:C307($today)
		$today:=4D_Current_date
		C_TEXT:C284(xTitle; xText)
		C_TEXT:C284($t; $cr)
		$t:=Char:C90(9)
		$cr:=Char:C90(13)
		
		
		ARRAY TEXT:C222($aJobForm; 0)
		ARRAY INTEGER:C220($aJobItem; 0)
		ARRAY LONGINT:C221($arQty; 0)
		ARRAY TEXT:C222($aTransType; 0)
		zwStatusMsg("JMI to 1"; " searching for [JobMakesItem]Qty_Actual<1...")
		QUERY:C277([Job_Forms_Items:44]; [Job_Forms_Items:44]Qty_Actual:11<1; *)
		QUERY:C277([Job_Forms_Items:44];  & ; [Job_Forms_Items:44]Completed:39=!00-00-00!)
		$numRecs:=Records in selection:C76([Job_Forms_Items:44])
		zwStatusMsg("JMI to 1"; String:C10($numRecs))
		//uRelateSelect (->[FG_Transactions]JobForm;->[JobMakesItem]JobForm)
		REDUCE SELECTION:C351([Finished_Goods_Transactions:33]; 0)  // • mel (8/23/04, 14:55:31) Don't do it on transactions, to many errors
		zwStatusMsg("JMI to 1"; " Loading transactions..."+String:C10(Records in selection:C76([Finished_Goods_Transactions:33])))
		SELECTION TO ARRAY:C260([Finished_Goods_Transactions:33]JobForm:5; $aJobForm; [Finished_Goods_Transactions:33]JobFormItem:30; $aJobItem; [Finished_Goods_Transactions:33]Qty:6; $arQty; [Finished_Goods_Transactions:33]XactionType:2; $aTransType)
		REDUCE SELECTION:C351([Finished_Goods_Transactions:33]; 0)
		zwStatusMsg("JMI to 1"; " Building transaction keys...")
		
		For ($i; 1; Size of array:C274($aJobForm))  //build a key
			$aJobForm{$i}:=$aJobForm{$i}+String:C10($aJobItem{$i}; "00")
		End for 
		SORT ARRAY:C229($aJobForm; $aJobItem; $arQty; $aTransType; >)
		
		ARRAY TEXT:C222($aJFjobform; 0)
		ARRAY DATE:C224($aClosed; 0)
		ARRAY DATE:C224($aComplete; 0)
		ARRAY TEXT:C222($aJobType; 0)
		
		//$testComment:="ROS[Job_Forms_Items]"//benchmark
		//$startMillisec:=Milliseconds  //benchmark
		
		If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
			
			uRelateSelect(->[Job_Forms:42]JobFormID:5; ->[Job_Forms_Items:44]JobForm:1)
			
		Else 
			zwStatusMsg("Relating"; " Searching "+Table name:C256(->[Job_Forms:42])+" file. Please Wait...")
			RELATE ONE SELECTION:C349([Job_Forms_Items:44]; [Job_Forms:42])
			zwStatusMsg(""; "")
		End if   // END 4D Professional Services : January 2019 query selection
		//$durationSec:=(Milliseconds-$startMillisec)/1000  //benchmark
		//utl_Logfile ("benchmark.log";Current method name+": "+$testComment+" took "+String($durationSec)+" seconds")
		
		zwStatusMsg("JMI to 1"; " Loading jobforms..."+String:C10(Records in selection:C76([Job_Forms:42])))
		SELECTION TO ARRAY:C260([Job_Forms:42]JobFormID:5; $aJFjobform; [Job_Forms:42]ClosedDate:11; $aClosed; [Job_Forms:42]Completed:18; $aComplete; [Job_Forms:42]JobType:33; $aJobType)
		REDUCE SELECTION:C351([Job_Forms:42]; 0)
		
		ARRAY TEXT:C222($aFGJobForm; 0)
		ARRAY INTEGER:C220($aFGJobItem; 0)
		ARRAY LONGINT:C221($aFGQty; 0)
		//$testComment:="QWA[Finished_Goods_Locations]JobForm"  //benchmark
		//$startMillisec:=Milliseconds  //benchmark
		If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
			
			uRelateSelect(->[Finished_Goods_Locations:35]JobForm:19; ->[Job_Forms_Items:44]JobForm:1)
			
		Else 
			
			zwStatusMsg("Relating"; " Searching "+Table name:C256(->[Finished_Goods_Locations:35])+" file. Please Wait...")
			ARRAY TEXT:C222($_JobForm; 0)
			DISTINCT VALUES:C339([Job_Forms_Items:44]JobForm:1; $_JobForm)
			QUERY WITH ARRAY:C644([Finished_Goods_Locations:35]JobForm:19; $_JobForm)
			zwStatusMsg(""; "")
			
		End if   // END 4D Professional Services : January 2019 query selection
		//$durationSec:=(Milliseconds-$startMillisec)/1000  //benchmark
		//utl_Logfile ("benchmark.log";Current method name+": "+$testComment+" took "+String($durationSec)+" seconds")
		
		zwStatusMsg("JMI to 1"; " Loading fg bins..."+String:C10(Records in selection:C76([Finished_Goods_Locations:35])))
		SELECTION TO ARRAY:C260([Finished_Goods_Locations:35]JobForm:19; $aFGJobForm; [Finished_Goods_Locations:35]JobFormItem:32; $aFGJobItem; [Finished_Goods_Locations:35]QtyOH:9; $aFGQty)
		REDUCE SELECTION:C351([Finished_Goods_Locations:35]; 0)
		For ($i; 1; Size of array:C274($aFGJobForm))  //build a key
			$aFGJobForm{$i}:=$aFGJobForm{$i}+String:C10($aFGJobItem{$i}; "00")
		End for 
		
		xTitle:="JMI Actual Qty Adjustments"
		xText:=""
		
		uThermoInit($numRecs; "Checking JMI actual quantities.")
		If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 First record
			FIRST RECORD:C50([Job_Forms_Items:44])
		Else 
			
			// see distinct value line 139
			
		End if   // END 4D Professional Services : January 2019 First record
		// 4D Professional Services : after Order by , query or any query type you don't need First record  
		
		For ($i; 1; $numRecs)
			$jobform:=[Job_Forms_Items:44]JobForm:1+String:C10([Job_Forms_Items:44]ItemNumber:7; "00")
			
			//• 5/5/97 cs (Start) added because do overs were marked as closed
			$hit:=Find in array:C230($aJFjobform; [Job_Forms_Items:44]JobForm:1)  //locte the job in the jobform data
			If ($hit>0)  //if found
				If ($aJobType{$Hit}="4@")  //check if this is a Do Over
					$Continue:=False:C215  //do not do anything else• 
				Else   //continue processing
					$Continue:=True:C214
				End if 
			Else   //continue processing
				$Continue:=True:C214
			End if 
			
			If ($Continue)  //if it is OK to process
				//`• 5/5/97 cs  end          
				$hit:=Find in array:C230($aJobForm; $jobform)  //find in Fg_transactions with zero JMI actual qty
				If ($hit>0)
					$qty:=1
					
					If (False:C215)  //•101298  MLB  messes up subforms somehting awful
						While ($hit>0)  //sum reciepts for this FG
							If ($aTransType{$hit}="Receipt")
								$qty:=$qty+$arQty{$hit}
							End if 
							$hit:=Find in array:C230($aJobForm; $jobform; $hit+1)
						End while 
					End if   //false
					
				Else 
					$qty:=0
				End if 
				
				If ($qty>[Job_Forms_Items:44]Qty_Actual:11)  //if the total of receipt found > actual qty recorded
					xText:=xText+$jobform+" set equal to transactions: "+String:C10($qty)+$cr
					[Job_Forms_Items:44]Qty_Actual:11:=$qty  //save the quantity from reciepts
					[Job_Forms_Items:44]ModWho:30:="Bat2"
					[Job_Forms_Items:44]ModDate:29:=$today
					SAVE RECORD:C53([Job_Forms_Items:44])
					
				Else   //look for close and complete dates
					$hit:=Find in array:C230($aJFjobform; [Job_Forms_Items:44]JobForm:1)
					If ($hit>0)
						If ($aClosed{$hit}#!00-00-00!) | ($aComplete{$hit}#!00-00-00!) | ($aJobType{$hit}="6@")  //| ($aJobType{$hit}="2@") 
							[Job_Forms_Items:44]Qty_Actual:11:=1
							[Job_Forms_Items:44]ModWho:30:="Bat3"
							[Job_Forms_Items:44]ModDate:29:=$today
							SAVE RECORD:C53([Job_Forms_Items:44])
							xText:=xText+$jobform+" closed "+$t+String:C10($aClosed{$hit}; <>middate)+$t+String:C10($aComplete{$hit}; <>middate)+$t+$aJobType{$hit}+$cr
							
						Else   // look for inventory
							$hit:=Find in array:C230($aFGjobform; $jobform)
							If ($hit>0)
								[Job_Forms_Items:44]Qty_Actual:11:=1
								[Job_Forms_Items:44]ModWho:30:="Bat4"
								[Job_Forms_Items:44]ModDate:29:=$today
								SAVE RECORD:C53([Job_Forms_Items:44])
								xText:=xText+$jobform+" has inventory "+$t+String:C10($aFGQty{$hit})+$cr
							End if   //inventory
						End if   //#closed etc
						
					End if 
					
				End if 
			End if   //`• 5/5/97  cs continue
			uThermoUpdate($i)
			NEXT RECORD:C51([Job_Forms_Items:44])
		End for 
		uThermoClose
		CLEAR SET:C117("receipts")
		REDUCE SELECTION:C351([Job_Forms_Items:44]; 0)
		If (Length:C16(xText)>0)
			distributionList:="mel.bohince@arkay.com"+Char:C90(9)
			QM_Sender(xTitle; ""; xText; distributionList)
		End if 
		//rPrintText ("JMI.LOG")
		//CLOSE WINDOW
	Else 
		//canceled    
End case 
MESSAGES ON:C181