//%attributes = {"publishedWeb":true}
//(p) Batch_VFIssue
//this will locate and process (post) all unposted issue tickets
//• 10/29/97 cs created
//$1 - (optional) string anything flag - run this for hand entered issues
//• 6/26/98 cs added new verification for qty on hand vers qty to issue
//• 7/31/98 cs validate Jobform existance before issue
//• 8/4/98 cs verfiy that the start date has been set

C_LONGINT:C283($TicketCount; $i; $Time; $JobCount; $BinIndex; $POIIndex; l1; l2)
C_DATE:C307($Date)

$Time:=4d_Current_time*1
$Date:=4D_Current_date

MESSAGES OFF:C175
READ WRITE:C146([Job_Forms_Issue_Tickets:90])
READ WRITE:C146([Job_Forms:42])  //• 4/21/98 cs 

If (Count parameters:C259=0)
	QUERY:C277([Job_Forms_Issue_Tickets:90]; [Job_Forms_Issue_Tickets:90]Posted:4=0)  //0 = not posted
Else   //search has been done - and there are records waiting in selection
End if 
$TicketCount:=Records in selection:C76([Job_Forms_Issue_Tickets:90])

If ($TicketCount>0)  //tickets to post
	ARRAY REAL:C219(aIssueQty; $TicketCount)
	ARRAY TEXT:C222(aIssueRm; $TicketCount)
	ARRAY TEXT:C222($IssuePOI; $TicketCount)
	ARRAY TEXT:C222(aIssueJF; $TicketCount)
	ARRAY LONGINT:C221($IssueTime; $TicketCount)
	ARRAY DATE:C224($IssueDate; $TicketCount)
	ARRAY TEXT:C222(aRmCode; $TicketCount)  //• 3/9/98 cs add RM code to reports
	SELECTION TO ARRAY:C260([Job_Forms_Issue_Tickets:90]Quantity:6; aIssueQty; [Job_Forms_Issue_Tickets:90]Raw_Matl_Code:2; aIssueRM; [Job_Forms_Issue_Tickets:90]PoItemKey:1; $IssuePOI; [Job_Forms_Issue_Tickets:90]JobForm:5; aIssueJF; [Job_Forms_Issue_Tickets:90]Posted:4; $IssuePosted; [Job_Forms_Issue_Tickets:90]PostTime:9; $IssueTime; [Job_Forms_Issue_Tickets:90]PostDate:8; $IssueDate; [Job_Forms_Issue_Tickets:90]Raw_Matl_Code:2; aRmCode)
	
	CREATE SET:C116([Job_Forms_Issue_Tickets:90]; "Posting")  //insure that order of records can be recovred for later array to selection
	uClearSelection(->[Raw_Materials_Locations:25])  //unload records from these files
	uClearSelection(->[Raw_Materials_Transactions:23])
	READ WRITE:C146([Raw_Materials_Locations:25])
	READ WRITE:C146([Raw_Materials_Transactions:23])
	Ni_LocateBins  //get bin records - populate needed arrays
	Ni_LocatePOIs  //get POItems - populate needed arrays
	Ni_NewBinHndlr("i"; Abs:C99(Records in selection:C76([Raw_Materials_Locations:25])-Records in selection:C76([Purchase_Orders_Items:12])))
	l1:=1  //l1 = number of elements used in new bin array  
	ARRAY TEXT:C222($JobForms; $TicketCount)
	$JobCount:=1
	
	For ($i; 1; Size of array:C274($IssuePOI))  //for each issue ticket, post 
		If (Find in array:C230($JobForms; Substring:C12(aIssueJF{$i}; 1; 8))<0)  //track job forms processed
			QUERY:C277([Job_Forms:42]; [Job_Forms:42]JobFormID:5=Substring:C12(aIssueJF{$i}; 1; 8))  //• 7/31/98 cs validate Jobform existance before issue
			$JobFormInx:=Records in selection:C76([Job_Forms:42])
			$JobForms{$JobCount}:=Substring:C12(aIssueJF{$i}; 1; 8)  //used later to recalc the actuals on the jobform
			$JobCount:=$JobCount+1
		End if 
		
		$BinIndex:=Find in array:C230(aRMPoiKey; $IssuePOI{$i})  //get index into bin record based on POI
		$POIIndex:=Find in array:C230(aPOIPoiKey; $IssuePOI{$i})  //get index into Po Item record based on POI from Issue
		
		Case of 
			: ($POIIndex<0)
				$IssuePosted{$i}:=2  //exception, no po Item
			: ($JobFormInx<=0)  //• 7/31/98 cs jobform does not exist no issue
				$IssuePosted{$i}:=5
				aRmCode{$i}:=aPoiRmCode{$POIIndex}  //flag this issue ticket with the rm code
			: ($BinIndex<0)
				$IssuePosted{$i}:=3  //exception, no bin
				NI_BinUpdate("New"; $i; $POIIndex; ->l1)
				Ni_RmXferCreat($i; $POIIndex; "")
				Ni_BudgetUpdat($i; $POIIndex)
			: (aIssueQty{$i}>aRMQty{$BinIndex})  //• 6/26/98 cs new exception - 4 = not enough quantity      
				$IssuePosted{$i}:=4
				aRmCode{$i}:=aPoiRmCode{$POIIndex}  //flag this issue ticket with the rm code
			Else   //will complete
				$IssuePosted{$i}:=1
				l2:=$BinIndex
				NI_BinUpdate("Mod"; $i; $POIIndex; ->l2)
				Ni_RmXferCreat($i; $POIIndex; aRmBin{$BinIndex})
				Ni_BudgetUpdat($i; $POIIndex)
		End case 
		$IssueTime{$i}:=$Time
		$IssueDate{$i}:=$Date
		
		If ($IssuePOsted{$i}=3) | ($IssuePOsted{$i}=1)  //an issue was/will be done
			uVerifyJobStart(Substring:C12(aIssueJF{$i}; 1; 8))  //• 8/4/98 cs verfiy that the start date has been set
		End if 
		
		If ($i%10=0)
			MESSAGE:C88(String:C10($i)+" of "+String:C10($TicketCount)+Char:C90(13))
		End if 
	End for 
	MESSAGE:C88("Committing New Bins..."+Char:C90(13))
	Ni_NewBinHndlr("C"; l1)  //commit new bins
	USE SET:C118("◊BinsToPost")
	ARRAY TO SELECTION:C261(aRmQty; [Raw_Materials_Locations:25]QtyOH:9; aRmAvail; [Raw_Materials_Locations:25]QtyAvailable:13; aRmCommit; [Raw_Materials_Locations:25]QtyCommitted:11; aRMCompId; [Raw_Materials_Locations:25]CompanyID:27)
	USE SET:C118("Posting")
	ARRAY TO SELECTION:C261($IssuePosted; [Job_Forms_Issue_Tickets:90]Posted:4; $IssueTime; [Job_Forms_Issue_Tickets:90]PostTime:9; $IssueDate; [Job_Forms_Issue_Tickets:90]PostDate:8; aRmCode; [Job_Forms_Issue_Tickets:90]Raw_Matl_Code:2)  //• 3/9/98 cs addd tracking of RM code
	MESSAGE:C88("Updating Actuals..."+Char:C90(13))
	RM_IssueCalcTotal("*")
	Ni_LocatePOIs("*")  //clear POItem arrays
	$TicketCount:=0
	ARRAY REAL:C219(aIssueQty; $TicketCount)
	ARRAY TEXT:C222(aIssueRm; $TicketCount)
	ARRAY TEXT:C222(aRMcode; $TicketCount)  //• 3/9/98 cs 
	ARRAY TEXT:C222($IssuePOI; $TicketCount)
	ARRAY LONGINT:C221($IssueTime; $TicketCount)
	ARRAY DATE:C224($IssueDate; $TicketCount)
	ARRAY TEXT:C222(aIssueJF; $TicketCount)  //can clear after issue calc is done
	uClearSelection(->[Raw_Materials_Locations:25])  //unload records from these files
	uClearSelection(->[Raw_Materials_Transactions:23])
	uClearSelection(->[Job_Forms:42])
	uClearSelection(->[Raw_Materials_Allocations:58])
	uClearSelection(->[Job_Forms_Materials:55])
	
	If (Count parameters:C259=1)
		rAIssExceptions("S")  //print exception report
	Else 
		rAIssExceptions  //print exception report
	End if 
End if 