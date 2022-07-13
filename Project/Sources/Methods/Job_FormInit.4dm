//%attributes = {"publishedWeb":true}
//Procedure: Job_FormInit()  120397  MLB
//set up a new job element and calc its value or just 
//gather up related Machine tickets
//value is based on the lessor of Want or Actual Qty
//•011298  MLB  UPR 1914 always calc total sales value
//•051998  MLB  make sure actqty not 0 or set by batch to 1
//•052098  MLB  for conversion costs later

C_TEXT:C284($1)
C_TEXT:C284($2)
C_REAL:C285($value)
C_LONGINT:C283($0; $hit; $j; $numJMI)
C_TEXT:C284($cr)
ARRAY TEXT:C222($aFG; 0)
ARRAY LONGINT:C221($aActQty; 0)
ARRAY LONGINT:C221($aWantQty; 0)
ARRAY DATE:C224($aDate; 0)
ARRAY REAL:C219($aPricePerM; 0)
ARRAY TEXT:C222($aFG; 0)
ARRAY LONGINT:C221($aActQty; 0)
ARRAY LONGINT:C221($aWantQty; 0)

$cr:=Char:C90(13)

READ ONLY:C145([Job_Forms_Items:44])
READ ONLY:C145([Customers_Order_Lines:41])

//*Create job element
$hit:=Find in array:C230(aJob; "")
If ($hit=-1)  //not found, so expand  
	$currSize:=Size of array:C274(aJob)
	Job_Form("init"; String:C10($currSize+10))
	$hit:=$currSize+1
End if 
$0:=$hit  //*    Return element number
aJob{$hit}:=$1
//•011298  MLB  UPR 1914 use to be protected by if params=2
//*  Initialize the Sales value 
//*       Get the qty of items actually produced on the job
$numJMI:=qryJMI(aJob{$hit}; 0; "@")  //get all the items for the job

SELECTION TO ARRAY:C260([Job_Forms_Items:44]ProductCode:3; $aFG; [Job_Forms_Items:44]Qty_Actual:11; $aActQty; [Job_Forms_Items:44]Qty_Want:24; $aWantQty)
REDUCE SELECTION:C351([Job_Forms_Items:44]; 0)
SORT ARRAY:C229($aFG; $aActQty; $aWantQty; >)
$value:=0
If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4
	
	For ($j; 1; $numJMI)  //*        For each item, get its sales value from orderlines
		QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]ProductCode:5=$aFG{$j})
		If (Records in selection:C76([Customers_Order_Lines:41])>0)
			SELECTION TO ARRAY:C260([Customers_Order_Lines:41]Price_Per_M:8; $aPricePerM; [Customers_Order_Lines:41]DateOpened:13; $aDate)
			REDUCE SELECTION:C351([Customers_Order_Lines:41]; 0)
			SORT ARRAY:C229($aDate; $aPricePerM; <)
			If ($aActQty{$j}>1) & ($aActQty{$j}<$aWantQty{$j})  //•051998  MLB  make sure act is not zero or batch=1
				$value:=$value+(($aActQty{$j}/1000)*$aPricePerM{1})
			Else 
				$value:=$value+(($aWantQty{$j}/1000)*$aPricePerM{1})
			End if 
			ARRAY DATE:C224($aDate; 0)
			ARRAY REAL:C219($aPricePerM; 0)
		End if 
	End for   //j
	
Else 
	
	ARRAY TEXT:C222($_ProductCode; 0)
	QUERY WITH ARRAY:C644([Customers_Order_Lines:41]ProductCode:5; $aFG)
	
	SELECTION TO ARRAY:C260([Customers_Order_Lines:41]Price_Per_M:8; $aPricePerM; \
		[Customers_Order_Lines:41]DateOpened:13; $aDate; \
		[Customers_Order_Lines:41]ProductCode:5; $_ProductCode)
	
	ARRAY DATE:C224($aDate; 0)
	ARRAY REAL:C219($aPricePerM; 0)
	
	SORT ARRAY:C229($aPricePerM; $aDate; $_ProductCode; <)
	
	For ($j; 1; $numJMI)  //*        For each item, get its sales value from orderlines
		$position:=Find in array:C230($_ProductCode; $aFG{$j})
		
		If ($position>0)
			
			If ($aActQty{$j}>1) & ($aActQty{$j}<$aWantQty{$j})  //•051998  MLB  make sure act is not zero or batch=1
				$value:=$value+(($aActQty{$j}/1000)*$aPricePerM{$position})
			Else 
				$value:=$value+(($aWantQty{$j}/1000)*$aPricePerM{$position})
			End if 
			
		End if 
	End for 
	
End if   // END 4D Professional Services : January 2019 query selection


aSalesValue{$hit}:=$value

QUERY:C277([Job_Forms:42]; [Job_Forms:42]JobFormID:5=aJob{$hit})  //•052098  MLB  for conversion costs later
If (Records in selection:C76([Job_Forms:42])>0)
	aMaterial{$hit}:=[Job_Forms:42]Pld_CostTtlMatl:19
	REDUCE SELECTION:C351([Job_Forms:42]; 0)
Else 
	aMaterial{$hit}:=0
End if 

If (Count parameters:C259=2)  //*  Initialize the Job's cost later, just gather machine tickets
	//*       Get all the Machine Tickets for the job
	If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4 
		
		QUERY:C277([Job_Forms_Machine_Tickets:61]; [Job_Forms_Machine_Tickets:61]JobForm:1=aJob{$hit})
		CREATE SET:C116([Job_Forms_Machine_Tickets:61]; "thisJob")
		
	Else 
		
		SET QUERY DESTINATION:C396(Into set:K19:2; "thisJob")
		QUERY:C277([Job_Forms_Machine_Tickets:61]; [Job_Forms_Machine_Tickets:61]JobForm:1=aJob{$hit})
		SET QUERY DESTINATION:C396(Into current selection:K19:1)
		
		
	End if   // END 4D Professional Services : January 2019 
	
	UNION:C120("thisJob"; "allJobs"; "allJobs")
	CLEAR SET:C117("thisJob")
End if 