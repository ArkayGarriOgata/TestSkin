//%attributes = {"publishedWeb":true}
//(p) rINkOrderForm
//print an Order form for ink for a specific Jobform
//All parametrs are optional - no parameters = call from report menu
//$1 - string - PO Number
//$2 - boolan - is this a new order (true) or revised(false) PO
//$3 - String - anything flag to suppress print settings
//• 6/1/98 cs created
//• 8/4/98 cs updated to allow printing with job bag

C_BOOLEAN:C305($2; $PrintSettin; $Revised; $Continue)
C_TEXT:C284($1; $PO)
C_TEXT:C284($3)

$Continue:=False:C215

If (Count parameters:C259=0)  //• 8/4/98 cs need to request & verify Jobform - setup to print
	Repeat 
		$JobForm:=Request:C163("Enter Job Form."; "00000.00")
		
		If (OK=1)
			QUERY:C277([Job_Forms:42]; [Job_Forms:42]JobFormID:5=$Jobform)
			
			Case of 
				: (Records in selection:C76([Job_Forms:42])=1)
					$PO:=[Job_Forms:42]InkPONumber:54
					$Revised:=([Job_Forms:42]InkPONumber:54="")
					$PrintSettin:=True:C214
					$Continue:=True:C214
				: (Records in selection:C76([Job_Forms:42])>1)
					ALERT:C41("Please Enter a UNIQUE Job form.")
					OK:=1
				Else 
					ALERT:C41("Job Form entered NOT found.")
					OK:=1
			End case 
		Else 
			$Contiinue:=False:C215
		End if 
	Until (OK=0) | (Records in selection:C76([Job_Forms:42])=1)
Else 
	$PO:=$1
	$Revised:=$2
	$PrintSettin:=(Count parameters:C259<3)
	$Continue:=True:C214
End if   //• 8/4/98 cs end

If ($Continue) & ($PO#"")  //• 8/4/98 cs insure that there is a PO for the Jobform
	t3:=("New"*Num:C11($Revised))+("REVISED"*Num:C11(Not:C34($Revised)))  //sub title for report
	
	If ([Purchase_Orders:11]PONo:1#$PO)
		QUERY:C277([Purchase_Orders:11]; [Purchase_Orders:11]PONo:1=$Po)
	End if 
	RELATE MANY:C262([Purchase_Orders:11]PONo:1)  //get po items
	
	If (Records in selection:C76([Purchase_Orders:11])>0) & (Records in selection:C76([Purchase_Orders_Items:12])>0)
		ORDER BY:C49([Purchase_Orders_Items:12]; [Purchase_Orders_Items:12]POItemKey:1; >)
		FORM SET OUTPUT:C54([Purchase_Orders:11]; "InkOrderForm")
		ORDER BY:C49([Purchase_Orders:11]; [Purchase_Orders:11]PONo:1; >)
		util_PAGE_SETUP(->[Purchase_Orders:11]; "InkOrderForm")
		
		If ($PrintSettin)  //supress print settings (we are printing in a loop)
			PRINT SETTINGS:C106
		End if 
		CLOSE WINDOW:C154
		
		If (OK=1)
			PDF_setUp("inkform"+$PO+".pdf")
			NewWindow(500; 400; 0; 4; "Ink Order Form")
			PRINT RECORD:C71([Purchase_Orders:11]; *)
			CLOSE WINDOW:C154
		End if 
		FORM SET OUTPUT:C54([Purchase_Orders:11]; "list")
	Else 
		ALERT:C41("No Ink required for this Jobform."+Char:C90(13)+"Therefore there is No 'Ink Order Form' being printed.")
	End if 
Else 
	
	If ($PO="") & (OK=1)  //• 8/4/98 cs 
		ALERT:C41("The selected Jobform does NOT need an 'Ink Order Form' printed.")
	End if 
End if 