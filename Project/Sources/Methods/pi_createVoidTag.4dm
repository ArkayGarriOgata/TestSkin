//%attributes = {}
// ----------------------------------------------------
// User name (OS): work
// Date and time: 04/04/06, 16:44:58
// ----------------------------------------------------
// Method: pi_createVoidTag
// Description
// void a tag so that known gaps don't show on tag report
// ----------------------------------------------------

C_TEXT:C284($1; $startTag; $endTag)  //tag number as a string
C_LONGINT:C283($tagNum; $begin; $end)

If (Count parameters:C259=0)
	$pid:=New process:C317("pi_createVoidTag"; <>lMinMemPart; "Entering Voided Tags"; "init")
	
Else 
	Repeat 
		$begin:=0
		$end:=0
		zwStatusMsg("VOID'ING TAGS"; "Enter a range of tags.")
		$startTag:=Request:C163("Enter first tag# in range:"; ""; "Continue"; "Finished")
		If (Length:C16($startTag)>0) & (OK=1)
			$endTag:=Request:C163("Enter last tag# in range:"; $startTag; "Void Them"; "Abort")
			If (Length:C16($endTag)>0) & (OK=1)
				$begin:=Num:C11($startTag)
				$end:=Num:C11($endTag)
				For ($tagNum; $begin; $end)
					CREATE RECORD:C68([Raw_Materials_Transactions:23])
					[Raw_Materials_Transactions:23]Raw_Matl_Code:1:="VOID"
					[Raw_Materials_Transactions:23]UnitPrice:7:=0
					[Raw_Materials_Transactions:23]ActCost:9:=0
					[Raw_Materials_Transactions:23]ActExtCost:10:=0
					[Raw_Materials_Transactions:23]Location:15:="VOID"
					[Raw_Materials_Transactions:23]CompanyID:20:=""
					[Raw_Materials_Transactions:23]DepartmentID:21:=""
					[Raw_Materials_Transactions:23]ExpenseCode:26:=""
					[Raw_Materials_Transactions:23]Xfer_Type:2:="ADJUST"
					[Raw_Materials_Transactions:23]XferDate:3:=Current date:C33
					[Raw_Materials_Transactions:23]POItemKey:4:="VOIDVOID"
					[Raw_Materials_Transactions:23]Qty:6:=0
					[Raw_Materials_Transactions:23]Reason:5:="Phys Inv"
					[Raw_Materials_Transactions:23]viaLocation:11:="Tag: "+String:C10($tagNum)  //this is the Tag Number
					[Raw_Materials_Transactions:23]ReferenceNo:14:=String:C10($tagNum)
					[Raw_Materials_Transactions:23]ReceivingNum:23:=$tagNum
					[Raw_Materials_Transactions:23]zCount:16:=1
					[Raw_Materials_Transactions:23]ModDate:17:=4D_Current_date
					[Raw_Materials_Transactions:23]ModWho:18:=<>zResp
					[Raw_Materials_Transactions:23]Commodity_Key:22:=""
					[Raw_Materials_Transactions:23]CommodityCode:24:=0
					SAVE RECORD:C53([Raw_Materials_Transactions:23])
				End for 
				zwStatusMsg("VOID'ING TAGS"; $startTag+" to "+$endTag+" were voided. "+"Enter next range of tags.")
				
			Else 
				BEEP:C151
				zwStatusMsg("VOID CANCELLED"; "User cancelled")
			End if 
		Else 
			BEEP:C151
			zwStatusMsg("VOID CANCELLED"; "User cancelled")
		End if 
	Until (OK=0)
End if 