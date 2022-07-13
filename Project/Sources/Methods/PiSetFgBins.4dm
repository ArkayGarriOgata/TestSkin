//%attributes = {"publishedWeb":true}
//(p) PiSetFgBins
//• 4/9/97 cs  created
//Allows an admin person to set the bin value to an entered 
//quantity, while also creating a transaction for PI
//$1 - optional - indicate call is from Admin screen
//• 4/9/98 cs nan checking

C_TEXT:C284($1)
C_REAL:C285($Quantity; $Adjustment)
C_TEXT:C284($Location; $CPN; $Temp)
C_BOOLEAN:C305($Continue)

READ WRITE:C146([Finished_Goods_Locations:35])
READ WRITE:C146([Finished_Goods_Transactions:33])

$Location:=""
$CPN:=""

If (Count parameters:C259=1)  //call is from admin screen
	$Location:=RequestBigger("Please enter Location (as it is in stored in database)")  // Modified by: Mark Zinke (12/26/12) Was Request
	
	If (OK=1) & ($Location#"")  //entered Location
		QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]Location:2=$Location)  //find record
		Case of 
			: (Records in selection:C76([Finished_Goods_Locations:35])=0)  //not found
				ALERT:C41("No Fg_Location record found")
				$Continue:=False:C215
				
			: (Records in selection:C76([Finished_Goods_Locations:35])>1)  //too many found
				$CPN:=RequestBigger("More than One record found in this location, Please enter a CPN")  // Modified by: Mark Zinke (12/26/12) Was Request
				
				If ($CPN#"") & (OK=1)
					// ******* Verified  - 4D PS - January  2019 ********
					
					QUERY SELECTION:C341([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]ProductCode:1=$CPN)
					
					
					// ******* Verified  - 4D PS - January 2019 (end) *********
					Case of 
						: (Records in selection:C76([Finished_Goods_Locations:35])=0)
							$Continue:=False:C215
							ALERT:C41("No item with Product code: '"+$CPN+"' was found.")
						: (Records in selection:C76([Finished_Goods_Locations:35])>1)
							ALERT:C41("More than one Fg_Location record found")
							$Continue:=False:C215
						Else   //just right
							$Continue:=True:C214
					End case 
					
				Else 
					If (OK=1) & ($CPN="")
						ALERT:C41("You must enter a valid CPN")
					End if 
				End if 
				
			Else   //just right
				$Continue:=True:C214
		End case 
	Else 
		
		If ($Location="") & (OK=1)
			ALERT:C41("You Must enter a valid Location")
		End if 
	End if   //end OK=1 & Location#""
Else   //called from user environment
	
	If (Records in selection:C76([Finished_Goods_Locations:35])#1)  //if record in selection NOT 1 = then selected record is NOT in FG_Location
		ALERT:C41("You MUST select only one record in FG_LOCATIONS table")
		$Continue:=False:C215
	Else 
		FIRST RECORD:C50([Finished_Goods_Locations:35])  //insure that the record is ready
		$Continue:=True:C214
	End if 
End if 

If ($Continue)  //if it is OK to continue to create transaction
	$Temp:=Request:C163("Please enter NEW bin Quantity")
	
	If (OK=1) & ($Temp#"")  //if there was an entry
		$Quantity:=Num:C11($Temp)
		
		If ($Quantity>=0)  //if the entry was positive
			$Adjustment:=$Quantity-[Finished_Goods_Locations:35]QtyOH:9
			qryFinishedGood([Finished_Goods_Locations:35]CustID:16; [Finished_Goods_Locations:35]ProductCode:1)  //locate F/G record
			qryJMI([Finished_Goods_Locations:35]JobForm:19; 0; [Finished_Goods_Locations:35]ProductCode:1)  //locate JMI
			CREATE RECORD:C68([Finished_Goods_Transactions:33])  //create transaction
			[Finished_Goods_Transactions:33]XactionNum:24:=app_GetPrimaryKey  //app_AutoIncrement (->[Finished_Goods_Transactions])  `
			[Finished_Goods_Transactions:33]ProductCode:1:=[Finished_Goods_Locations:35]ProductCode:1
			[Finished_Goods_Transactions:33]CustID:12:=[Finished_Goods_Locations:35]CustID:16  //
			[Finished_Goods_Transactions:33]XactionType:2:="ADJUST"
			[Finished_Goods_Transactions:33]XactionDate:3:=4D_Current_date
			[Finished_Goods_Transactions:33]XactionTime:13:=4d_Current_time
			[Finished_Goods_Transactions:33]JobNo:4:=[Finished_Goods_Locations:35]JobForm:19
			[Finished_Goods_Transactions:33]JobForm:5:=[Finished_Goods_Locations:35]JobForm:19
			[Finished_Goods_Transactions:33]JobFormItem:30:=[Finished_Goods_Locations:35]JobFormItem:32
			[Finished_Goods_Transactions:33]Reason:26:="Phys Inv"  //subject for reason-used in reporting, sorting, very uniform
			[Finished_Goods_Transactions:33]Qty:6:=$Adjustment
			[Finished_Goods_Transactions:33]Location:9:=[Finished_Goods_Locations:35]Location:2
			[Finished_Goods_Transactions:33]viaLocation:11:="CYCLE CNT"
			[Finished_Goods_Transactions:33]zCount:10:=1
			[Finished_Goods_Transactions:33]ModDate:17:=4D_Current_date
			[Finished_Goods_Transactions:33]ModWho:18:=<>zResp
			[Finished_Goods_Transactions:33]FG_Classification:22:=[Finished_Goods:26]ClassOrType:28
			If (Records in selection:C76([Job_Forms_Items:44])>0)
				[Finished_Goods_Transactions:33]CoGS_M:7:=[Job_Forms_Items:44]PldCostTotal:21
				[Finished_Goods_Transactions:33]CoGSExtended:8:=uNANCheck(Round:C94(($adjustment/1000)*[Job_Forms_Items:44]PldCostTotal:21*(Num:C11(Not:C34([Finished_Goods_Transactions:33]SkipTrigger:14))); 2))
			Else 
				ALERT:C41("Could not find Costing Data -  [FG_Transactions]CoGS_M "+"&  [FG_Transactions]CoGSExtended "+Char:C90(13)+"will need to be"+" Manually entered (use Apply to selection)")
			End if 
			SAVE RECORD:C53([Finished_Goods_Transactions:33])
			
			[Finished_Goods_Locations:35]QtyOH:9:=$Quantity  //save location change
			[Finished_Goods_Locations:35]AdjQty:12:=$Adjustment
			[Finished_Goods_Locations:35]LastCycleDate:8:=4D_Current_date
			[Finished_Goods_Locations:35]AdjDate:15:=4D_Current_date
			[Finished_Goods_Locations:35]ModDate:21:=4D_Current_date
			[Finished_Goods_Locations:35]ModWho:22:=<>zResp
			SAVE RECORD:C53([Finished_Goods_Locations:35])
			ALERT:C41("Change Completed")
		Else 
			ALERT:C41("You Must Enter a POSITIVE Quantity")
		End if 
	End if 
End if 