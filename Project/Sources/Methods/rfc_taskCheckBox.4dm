//%attributes = {}
// ----------------------------------------------------
// User name (OS): mel
// Date and time: 02/04/09, 15:58:02
// ----------------------------------------------------
// Method: rfc_taskCheckBox

// ----------------------------------------------------

C_POINTER:C301($1)
C_TEXT:C284($2)

//set Tasks completed for back-ward compatibility
If (Length:C16([Finished_Goods_SizeAndStyles:132]TasksCompleted:56)=0)
	[Finished_Goods_SizeAndStyles:132]TasksCompleted:56:="________"  //controlled by checkboxes on the screen
End if 

If (Count parameters:C259=1)  //completed checkbox itself was clicked, save state to record
	RESOLVE POINTER:C394($1; $varName; $tableNum; $fieldNum)  //should be something like task1 or task2 up to task8
	$char:=Num:C11(Substring:C12($varName; 5; 1))  //use this to determine
	If ($1->=1)  //task marked as done
		[Finished_Goods_SizeAndStyles:132]TasksCompleted:56:=Change string:C234([Finished_Goods_SizeAndStyles:132]TasksCompleted:56; "1"; $char)
	Else   //task still not done
		[Finished_Goods_SizeAndStyles:132]TasksCompleted:56:=Change string:C234([Finished_Goods_SizeAndStyles:132]TasksCompleted:56; "0"; $char)
	End if 
	
Else   //keep checkbox in sync with record
	Case of 
		: ($2="set-all")  //on form load, set the state of the complete checkbox variables to match the record
			For ($i; 1; 8)
				$ptrCheckbox:=Get pointer:C304("task"+String:C10($i))
				$ptrCheckbox->:=Num:C11([Finished_Goods_SizeAndStyles:132]TasksCompleted:56[[$i]])
			End for 
			
		: ($2="set-one")  //initialize the complete checkbox, set record to not done (0)
			RESOLVE POINTER:C394($1; $varName; $tableNum; $fieldNum)  //should be something like task1 or task2 up to task8
			$char:=Num:C11(Substring:C12($varName; 5; 1))  //use this to determine
			[Finished_Goods_SizeAndStyles:132]TasksCompleted:56:=Change string:C234([Finished_Goods_SizeAndStyles:132]TasksCompleted:56; "0"; $char)
			
		: ($2="clear-one")  //don't need the complete checkbox, set record to not needed (_)
			RESOLVE POINTER:C394($1; $varName; $tableNum; $fieldNum)  //should be something like task1 or task2 up to task8
			$char:=Num:C11(Substring:C12($varName; 5; 1))  //use this to determine
			[Finished_Goods_SizeAndStyles:132]TasksCompleted:56:=Change string:C234([Finished_Goods_SizeAndStyles:132]TasksCompleted:56; "_"; $char)
			
		: ($2="not-done")  //stage an addition request for tasks taht weren't completed
			$still_due:=Replace string:C233([Finished_Goods_SizeAndStyles:132]TasksCompleted:56; "1"; "_")
			$1->:=$still_due
			
		: ($2="reset")  //stage an addition request for tasks taht weren't completed
			[Finished_Goods_SizeAndStyles:132]TasksCompleted:56:=$1->
			
			If ([Finished_Goods_SizeAndStyles:132]TasksCompleted:56[[1]]="_")
				[Finished_Goods_SizeAndStyles:132]EstimatingOnly:55:=False:C215
			End if 
			If ([Finished_Goods_SizeAndStyles:132]TasksCompleted:56[[2]]="_")
				[Finished_Goods_SizeAndStyles:132]Samples:28:=False:C215
				[Finished_Goods_SizeAndStyles:132]qty_samples:35:=0
			End if 
			If ([Finished_Goods_SizeAndStyles:132]TasksCompleted:56[[3]]="_")
				[Finished_Goods_SizeAndStyles:132]DieOnDisk:29:=False:C215
				[Finished_Goods_SizeAndStyles:132]qty_DieOnDisk:36:=0
			End if 
			If ([Finished_Goods_SizeAndStyles:132]TasksCompleted:56[[4]]="_")
				[Finished_Goods_SizeAndStyles:132]EngDrawing:30:=False:C215
				[Finished_Goods_SizeAndStyles:132]qty_EngDrawing:37:=0
			End if 
			If ([Finished_Goods_SizeAndStyles:132]TasksCompleted:56[[5]]="_")
				[Finished_Goods_SizeAndStyles:132]ArtBoardOverlay:31:=False:C215
				[Finished_Goods_SizeAndStyles:132]qty_ArtBoard:38:=0
			End if 
			If ([Finished_Goods_SizeAndStyles:132]TasksCompleted:56[[6]]="_")
				[Finished_Goods_SizeAndStyles:132]ConveryFromDisk:32:=False:C215
				[Finished_Goods_SizeAndStyles:132]qty_ConvertDisk:39:=0
			End if 
			If ([Finished_Goods_SizeAndStyles:132]TasksCompleted:56[[7]]="_")
				[Finished_Goods_SizeAndStyles:132]DieSamples:33:=False:C215
				[Finished_Goods_SizeAndStyles:132]qty_DieSamples:40:=0
			End if 
			If ([Finished_Goods_SizeAndStyles:132]TasksCompleted:56[[8]]="_")
				[Finished_Goods_SizeAndStyles:132]EmailFile:34:=False:C215
				[Finished_Goods_SizeAndStyles:132]EmailAddress:41:=""
			End if 
			
			[Finished_Goods_SizeAndStyles:132]DateDone:6:=!00-00-00!
			[Finished_Goods_SizeAndStyles:132]Started_TimeStamp:4:=0
			
			$1->:=[Finished_Goods_SizeAndStyles:132]TasksCompleted:56
	End case 
	
End if 