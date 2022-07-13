//%attributes = {"publishedWeb":true}
//PM: POI_Accrual() -> 
//@author Mel - 5/20/03  10:38
//mlb 7/17/03 add qty conversion
//mlb 8/6/03 fix extended price

C_TEXT:C284($1)
C_TEXT:C284($t; $cr)
C_TEXT:C284(xTitle; xText)

$t:=Char:C90(9)
$cr:=Char:C90(13)

If (Count parameters:C259=0)
	$pid:=uSpawnProcess("POI_Accrual"; <>lMinMemPart; "Posting Accruals"; True:C214; False:C215; "init")
	If (False:C215)
		POI_Accrual
	End if 
	
Else 
	$poi:=Request:C163("Enter the PO item number to accrue:"; "123456789"; "Find"; "Done")
	While (ok=1)
		QUERY:C277([Purchase_Orders_Items:12]; [Purchase_Orders_Items:12]POItemKey:1=$poi)
		If (Records in selection:C76([Purchase_Orders_Items:12])=1)
			QUERY:C277([Vendors:7]; [Vendors:7]ID:1=[Purchase_Orders_Items:12]VendorID:39)
			zwStatusMsg($poi; [Vendors:7]Name:2+" ExpCode:"+[Purchase_Orders_Items:12]ExpenseCode:47+" Unit$:"+String:C10([Purchase_Orders_Items:12]UnitPrice:10))
			$qty:=Num:C11(Request:C163("Shipping Qty in "+[Purchase_Orders_Items:12]UM_Ship:5+"?"; String:C10([Purchase_Orders_Items:12]Qty_Shipping:4); "Post"; "Cancel"))
			If (ok=1) & ($qty#0)
				CREATE RECORD:C68([Purchase_Orders_Accruals:125])
				[Purchase_Orders_Accruals:125]POIkey:1:=$poi
				[Purchase_Orders_Accruals:125]Vendor:2:=[Vendors:7]Name:2
				[Purchase_Orders_Accruals:125]GLaccount:3:=" "+[Purchase_Orders_Items:12]CompanyID:45+"-"+[Purchase_Orders_Items:12]ExpenseCode:47
				[Purchase_Orders_Accruals:125]unitPrice:5:=[Purchase_Orders_Items:12]UnitPrice:10
				[Purchase_Orders_Accruals:125]qty:4:=Round:C94($qty*[Purchase_Orders_Items:12]FactNship2price:25/[Purchase_Orders_Items:12]FactDship2price:38; 3)  //   to convert shipping to billing units
				[Purchase_Orders_Accruals:125]extendPrice:6:=Round:C94([Purchase_Orders_Accruals:125]qty:4*[Purchase_Orders_Items:12]UnitPrice:10; 2)
				[Purchase_Orders_Accruals:125]DateEntered:7:=4D_Current_date
				SAVE RECORD:C53([Purchase_Orders_Accruals:125])
				zwStatusMsg("ACCRUAL"; [Vendors:7]Name:2+" ExpCode:"+[Purchase_Orders_Items:12]ExpenseCode:47+" Unit$:"+String:C10([Purchase_Orders_Items:12]UnitPrice:10)+"Billing Qty: "+String:C10([Purchase_Orders_Accruals:125]qty:4))
			End if 
			
		Else 
			BEEP:C151
			ALERT:C41($poi+" was not found."; "Try again")
			zwStatusMsg("ACCRUAL"; "")
		End if 
		
		$poi:=Request:C163("Enter the PO item number to accrue:"; "123456789"; "Find"; "Done")
	End while 
	zwStatusMsg("ACCRUAL"; "")
	CONFIRM:C162("Save a report to disk?"; "Report Now"; "No")
	If (ok=1)
		
		If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 Next record
			ALL RECORDS:C47([Purchase_Orders_Accruals:125])
			ORDER BY:C49([Purchase_Orders_Accruals:125]; [Purchase_Orders_Accruals:125]POIkey:1; >; [Purchase_Orders_Accruals:125]DateEntered:7; >)
			xTitle:="Accurals"
			xText:="POIkey"+$t+"Vendor"+$t+"GLaccount"+$t+"unitPrice"+$t+"qty"+$t+"extendPrice"+$t+"DateEntered"+$cr
			For ($i; 1; Records in selection:C76([Purchase_Orders_Accruals:125]))
				xText:=xText+[Purchase_Orders_Accruals:125]POIkey:1+$t+[Purchase_Orders_Accruals:125]Vendor:2+$t+[Purchase_Orders_Accruals:125]GLaccount:3+$t+String:C10([Purchase_Orders_Accruals:125]unitPrice:5)+$t+String:C10([Purchase_Orders_Accruals:125]qty:4)+$t+String:C10([Purchase_Orders_Accruals:125]extendPrice:6)+$t+String:C10([Purchase_Orders_Accruals:125]DateEntered:7; System date short:K1:1)+$cr
				NEXT RECORD:C51([Purchase_Orders_Accruals:125])
			End for 
			
		Else 
			
			ALL RECORDS:C47([Purchase_Orders_Accruals:125])
			
			ARRAY TEXT:C222($_POIkey; 0)
			ARRAY TEXT:C222($_Vendor; 0)
			ARRAY TEXT:C222($_GLaccount; 0)
			ARRAY REAL:C219($_unitPrice; 0)
			ARRAY REAL:C219($_qty; 0)
			ARRAY REAL:C219($_extendPrice; 0)
			ARRAY DATE:C224($_DateEntered; 0)
			
			
			SELECTION TO ARRAY:C260([Purchase_Orders_Accruals:125]POIkey:1; $_POIkey; [Purchase_Orders_Accruals:125]Vendor:2; $_Vendor; [Purchase_Orders_Accruals:125]GLaccount:3; $_GLaccount; [Purchase_Orders_Accruals:125]unitPrice:5; $_unitPrice; [Purchase_Orders_Accruals:125]qty:4; $_qty; [Purchase_Orders_Accruals:125]extendPrice:6; $_extendPrice; [Purchase_Orders_Accruals:125]DateEntered:7; $_DateEntered)
			
			SORT ARRAY:C229($_POIkey; $_DateEntered; $_Vendor; $_GLaccount; $_unitPrice; $_qty; $_extendPrice; >)
			
			xTitle:="Accurals"
			xText:="POIkey"+$t+"Vendor"+$t+"GLaccount"+$t+"unitPrice"+$t+"qty"+$t+"extendPrice"+$t+"DateEntered"+$cr
			For ($i; 1; Size of array:C274($_DateEntered); 1)
				
				xText:=xText+$_POIkey{$i}+$t+$_Vendor{$i}+$t+$_GLaccount{$i}+$t+String:C10($_unitPrice{$i})+$t+String:C10($_qty{$i})+$t+String:C10($_extendPrice{$i})+$t+String:C10($_DateEntered{$i}; System date short:K1:1)+$cr
				
			End for 
			
		End if   // END 4D Professional Services : January 2019 First record
		
		rPrintText("Accruals"+fYYMMDD(4D_Current_date)+"_"+Replace string:C233(String:C10(4d_Current_time; <>HHMM); ":"; "")+".xls")
	End if 
	
	CONFIRM:C162("Delete all records to start a new month?"; "No"; "Delete")
	If (ok=0)
		CONFIRM:C162("Are  you sure you wish to delete all the accruals?"; "No"; "Delete")
		If (ok=0)
			READ WRITE:C146([Purchase_Orders_Accruals:125])
			ALL RECORDS:C47([Purchase_Orders_Accruals:125])
			util_DeleteSelection(->[Purchase_Orders_Accruals:125])
		End if 
	End if 
End if 