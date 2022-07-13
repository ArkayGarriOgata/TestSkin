//%attributes = {"publishedWeb":true}
//(p) DoPurgeRmXfers
//moved this code from DoPurge to simplify that code
//• 11/6/97 cs created
//• 1/23/98 cs handle archiving RM receipts
//• 3/27/98 cs added default path to file creation
//• 6/11/98 cs Fred mandate - keep issues ≤15 months
//•092899  mlb  UPR rewrite
//•101399  mlb don't delete if po item still in system

C_TEXT:C284(xTitle; xText; $Path)
C_TEXT:C284($Cr)
C_LONGINT:C283($i; $hit)

$Cr:=Char:C90(13)
$Path:=<>purgeFolderPath
dRmTransDat:=4D_Current_date-rRMdays

QUERY:C277([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]XferDate:3<dRmTransDat)
If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) CREATE EMPTY SET
	
	CREATE EMPTY SET:C140([Raw_Materials_Transactions:23]; "rmxfers2delete")
	
Else 
	
	ARRAY LONGINT:C221($_rmxfers2delete; 0)
	
	
End if   // END 4D Professional Services : January 2019 

ALL RECORDS:C47([Raw_Materials_Locations:25])
SELECTION TO ARRAY:C260([Raw_Materials_Locations:25]POItemKey:19; $aPOKey)
SET QUERY LIMIT:C395(1)
SET CHANNEL:C77(10; $Path+"RMX_"+fYYMMDD(4D_Current_date))
uThermoInit(Records in selection:C76([Raw_Materials_Transactions:23]); "Purging "+String:C10(Records in selection:C76([Raw_Materials_Transactions:23]); "###,##0"))
For ($i; 1; Records in selection:C76([Raw_Materials_Transactions:23]))
	$hit:=Find in array:C230($aPOKey; [Raw_Materials_Transactions:23]POItemKey:4)
	If ($hit<0)  //not in inventory
		QUERY:C277([Purchase_Orders_Items:12]; [Purchase_Orders_Items:12]POItemKey:1=[Raw_Materials_Transactions:23]POItemKey:4)
		If (Records in selection:C76([Purchase_Orders_Items:12])=0)
			If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) CREATE EMPTY SET
				
				ADD TO SET:C119([Raw_Materials_Transactions:23]; "rmxfers2delete")
				
				
			Else 
				
				APPEND TO ARRAY:C911($_rmxfers2delete; Record number:C243([Raw_Materials_Transactions:23]))
				
			End if   // END 4D Professional Services : January 2019 
			SEND RECORD:C78([Raw_Materials_Transactions:23])
		End if 
	End if 
	NEXT RECORD:C51([Raw_Materials_Transactions:23])
	uThermoUpdate($i)
End for 
SET QUERY LIMIT:C395(0)

SET CHANNEL:C77(11)
If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) CREATE EMPTY SET
	
	USE SET:C118("rmxfers2delete")
	CLEAR SET:C117("rmxfers2delete")
	
Else 
	
	CREATE SELECTION FROM ARRAY:C640([Raw_Materials_Transactions:23]; $_rmxfers2delete)
	
End if   // END 4D Professional Services : January 2019 

xText:=String:C10(Records in selection:C76([Raw_Materials_Transactions:23]))+" RM_Xfer Records Purged with date older than "+String:C10(dRmTransDat; Internal date short special:K1:4)
xTitle:=""

MESSAGE:C88(Char:C90(13)+"Deleting RM Transactions...")
DELETE SELECTION:C66([Raw_Materials_Transactions:23])
FLUSH CACHE:C297
REDUCE SELECTION:C351([Raw_Materials_Transactions:23]; 0)
uThermoClose

rPrintText("RM_Xfer_Purge"+fYYMMDD(4D_Current_date)+"_"+Replace string:C233(String:C10(4d_Current_time; <>HHMM); ":"; "")+".LOG")