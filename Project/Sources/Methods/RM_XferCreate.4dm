//%attributes = {"publishedWeb":true}
//gRMXferCreate: Create [RM_XFER] Record
//upr 1257 10/27/94
//$1 - longint - index into arrays 
//$2 - date - date of transaction
// $3 (optional) chargecode string to parse for rm_xfer data
//  $4 (optional) message note to add to record

//10/29/94 issues made negative
//• 1/2/97 - cs - modification due to upr 0235
//•2/13/97 onsite alllow user to change location without changing company
//• 1/28/98 cs NAN checking
//• 4/1/98 cs Nan checking
//• 8/12d/98 cs efault Company ID = 1
//• mlb - 7/10/02  17:23 return recnumber created to calling method
//• mlb - 2/5/03  16:58 add consignment flag

C_LONGINT:C283($1; $0)
C_DATE:C307($2)
C_TEXT:C284($3; $ChargeCode; $Temp)
C_TEXT:C284($4)

$0:=-3

If (Count parameters:C259>=3)
	$ChargeCode:=$3
End if 
CREATE RECORD:C68([Raw_Materials_Transactions:23])
[Raw_Materials_Transactions:23]Raw_Matl_Code:1:=aRMCode{$1}
[Raw_Materials_Transactions:23]Xfer_Type:2:=Uppercase:C13(aRMType{$1})

If (Count parameters:C259>=2)
	[Raw_Materials_Transactions:23]XferDate:3:=$2
Else 
	[Raw_Materials_Transactions:23]XferDate:3:=4D_Current_date
End if 
aRMPOQty{$1}:=uNANCheck(aRMPOQty{$1})  //• 1/28/98 cs NAN checking

Case of 
	: (aRMType{$1}="Receipt") | (aRMType{$1}="T ")
		[Raw_Materials_Transactions:23]Xfer_State:33:="Posted"  // Modified by: Mel Bohince (4/20/16) 
		[Raw_Materials_Transactions:23]POItemKey:4:=aRMPONum{$1}+aRMPOItem{$1}
		[Raw_Materials_Transactions:23]Qty:6:=aRMSTKQty{$1}
		//po extended price would possible need a conversion
		[Raw_Materials_Transactions:23]UnitPrice:7:=aRMPOPrice{$1}
		[Raw_Materials_Transactions:23]POQty:8:=aRMPOQty{$1}
		[Raw_Materials_Transactions:23]ActCost:9:=uNANCheck(aRMStdPrice{$1})
		[Raw_Materials_Transactions:23]ActExtCost:10:=uNANCheck(Round:C94(aRMSTKQty{$1}*aRMStdPrice{$1}; 2))
		[Raw_Materials_Transactions:23]Location:15:=aRMBinNo{$1}
		//•upr 0235 related chages
		If (Count parameters:C259>=3)  //charge code is avail, use it
			
			//• 2/13/97 on site mod, charge code passed in will be correct      
			[Raw_Materials_Transactions:23]CompanyID:20:=ChrgCodeParse($ChargeCode; 1)
			
			If ([Raw_Materials_Transactions:23]CompanyID:20="")  //`• 8/12/98 cs default this
				[Raw_Materials_Transactions:23]CompanyID:20:="1"
			End if 
			//If ($Temp#[RM_XFER]CompanyID) & ($Temp#"")  `test for user changed
			//« location
			//[RM_XFER]CompanyID:=$Temp
			//End if 
			//end 2/13/97
			[Raw_Materials_Transactions:23]DepartmentID:21:=ChrgCodeParse($ChargeCode; 2)
			[Raw_Materials_Transactions:23]ExpenseCode:26:=ChrgCodeParse($ChargeCode; 3)
		Else   //use location for company
			$Temp:=ChrgCodeFrmLoc(aRmCompany{$1})  //•2/13/97 onsite aRmCompany - from layout 
		End if 
		//End upr 0235 mods    
		[Raw_Materials_Transactions:23]viaLocation:11:="VENDOR"
		[Raw_Materials_Transactions:23]ReceivingNum:23:=aRMRecNo{$1}
		
		
	: (aRMType{$1}="Issue")  //this has not been tested: was "I "
		[Raw_Materials_Transactions:23]XferDate:3:=adRMDate{$1}
		//[RM_XFER]PONo:=aRMBinPO{$1}
		[Raw_Materials_Transactions:23]POItemKey:4:=sThisIsPO  //BAK 8/25/94 Buuuuggggg Fix
		[Raw_Materials_Transactions:23]JobForm:12:=aRMJFNum{$1}
		[Raw_Materials_Transactions:23]Sequence:13:=aRMBudItem{$1}
		[Raw_Materials_Transactions:23]ReferenceNo:14:=aRMRefNo{$1}
		[Raw_Materials_Transactions:23]Location:15:="WIP"
		//•upr 0235 related chages
		If (Count parameters:C259>=3)  //charge code is avail, use it
			[Raw_Materials_Transactions:23]CompanyID:20:=ChrgCodeParse($ChargeCode; 1)
			[Raw_Materials_Transactions:23]DepartmentID:21:=ChrgCodeParse($ChargeCode; 2)
			[Raw_Materials_Transactions:23]ExpenseCode:26:=ChrgCodeParse($ChargeCode; 3)
		Else   //• 1/2/97 upr 0235 (assumed)     
			[Raw_Materials_Transactions:23]CompanyID:20:="1"
		End if 
		//End upr 0235 mods        
		[Raw_Materials_Transactions:23]viaLocation:11:=aRMBinNo{$1}
		[Raw_Materials_Transactions:23]Qty:6:=-aRMPOQty{$1}
		[Raw_Materials_Transactions:23]ActCost:9:=uNANCheck(aRMStdPrice{$1})
		[Raw_Materials_Transactions:23]ActExtCost:10:=uNANCheck(Round:C94(-aRMPOQty{$1}*aRMStdPrice{$1}; 2))
		
End case 
[Raw_Materials_Transactions:23]zCount:16:=1
[Raw_Materials_Transactions:23]ModDate:17:=4D_Current_date
[Raw_Materials_Transactions:23]ModWho:18:=<>zResp

If ([Raw_Materials:21]Raw_Matl_Code:1#aRMCode{$1})
	READ ONLY:C145([Raw_Materials:21])
	QUERY:C277([Raw_Materials:21]; [Raw_Materials:21]Raw_Matl_Code:1=aRMCode{$1})
End if 

If (Records in selection:C76([Raw_Materials:21])>0)
	[Raw_Materials_Transactions:23]Commodity_Key:22:=[Raw_Materials:21]Commodity_Key:2
	[Raw_Materials_Transactions:23]CommodityCode:24:=[Raw_Materials:21]CommodityCode:26
End if 

If (Count parameters:C259=4)  //there is a notation to add to transaction
	If (Length:C16($4)>0)  //and the note is NOT empty
		[Raw_Materials_Transactions:23]Reason:5:=[Raw_Materials_Transactions:23]Reason:5+" "+$4
	End if 
End if 

[Raw_Materials_Transactions:23]consignment:27:=[Purchase_Orders_Items:12]Consignment:49  //• mlb - 2/5/03  16:57

SAVE RECORD:C53([Raw_Materials_Transactions:23])
$0:=Record number:C243([Raw_Materials_Transactions:23])
UNLOAD RECORD:C212([Raw_Materials_Transactions:23])