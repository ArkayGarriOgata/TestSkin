//%attributes = {"publishedWeb":true}
//(P) JCOBuildA  Build array A
//Based on gBuildA
//$1 - boolean - is this build for a Form(true) or a Job (false)
//Returns false if there is a probem
//• 12/10/97 cs created
//•090498  MLB  cluge to guard against range check error
//•090598  MLB  more cluge to guard against range check error
// • mel (8/24/04, 16:23:44) above line misses returns
// Modified by: Mel Bohince (11/8/16)  break out of the loop after o/s caused skip of plastic (20-plastic substrate)

C_LONGINT:C283($i; $lastComm; $distinct; $matlBud; $hit)
C_BOOLEAN:C305($0)
ARRAY LONGINT:C221($budComm; 15)  //ther are actually less than 15 but this is a nice number

zwStatusMsg("Close Out"; "    calculating materials"+Char:C90(13))

READ ONLY:C145([Raw_Materials_Transactions:23])
READ ONLY:C145([Raw_Materials_Groups:22])

rBoardPrcnt:=1

$0:=True:C214
If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
	
	QUERY:C277([Job_Forms_Materials:55]; [Job_Forms_Materials:55]JobForm:1=[Job_Forms:42]JobFormID:5)  //03026/96 TJF
	CREATE SET:C116([Job_Forms_Materials:55]; "theBudget")  //set of budgeted materials
	
Else 
	
	QUERY:C277([Job_Forms_Materials:55]; [Job_Forms_Materials:55]JobForm:1=[Job_Forms:42]JobFormID:5)  //03026/96 TJF
	
End if   // END 4D Professional Services : January 2019 query selection

$matlBud:=Records in selection:C76([Job_Forms_Materials:55])
$distinct:=0

QUERY:C277([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]JobForm:12=[Job_Forms:42]JobFormID:5; *)
QUERY:C277([Raw_Materials_Transactions:23];  & ; [Raw_Materials_Transactions:23]Xfer_Type:2="Issue")

$transfers:=Records in selection:C76([Raw_Materials_Transactions:23])
ARRAY REAL:C219($RmCost; $Transfers)
ARRAY TEXT:C222($RMRawCode; $Transfers)
ARRAY TEXT:C222($RMCommKey; $Transfers)
ARRAY INTEGER:C220($RmCommCode; $Transfers)

SELECTION TO ARRAY:C260([Raw_Materials_Transactions:23]CommodityCode:24; $RmCommCode; [Raw_Materials_Transactions:23]Raw_Matl_Code:1; $RmRawCode; [Raw_Materials_Transactions:23]Commodity_Key:22; $RMCommKey; [Raw_Materials_Transactions:23]ActExtCost:10; $RmCost)
SORT ARRAY:C229($RmCommCode; $RmRawCode; $RmCost; $RMCommKey; >)
If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 next record
	
	If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
		
		QUERY SELECTION:C341([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]CommodityCode:24=13)  //locate those commodity 13 (outside service) transactions
		CREATE SET:C116([Raw_Materials_Transactions:23]; "OutsideService")
		uClearSelection(->[Raw_Materials_Transactions:23])
		
	Else 
		
		SET QUERY DESTINATION:C396(Into set:K19:2; "OutsideService")
		QUERY:C277([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]JobForm:12=[Job_Forms:42]JobFormID:5; *)
		QUERY:C277([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]Xfer_Type:2="Issue"; *)
		QUERY:C277([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]CommodityCode:24=13)  //locate those commodity 13 (outside service) transactions
		SET QUERY DESTINATION:C396(Into current selection:K19:1)
		REDUCE SELECTION:C351([Raw_Materials_Transactions:23]; 0)
		
	End if   // END 4D Professional Services : January 2019 query selection
	
	
Else 
	
	C_LONGINT:C283($number_record)
	SET QUERY DESTINATION:C396(Into variable:K19:4; $number_record)
	QUERY:C277([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]JobForm:12=[Job_Forms:42]JobFormID:5; *)
	QUERY:C277([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]Xfer_Type:2="Issue"; *)
	QUERY:C277([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]CommodityCode:24=13)  //locate those commodity 13 (outside service) transactions
	SET QUERY DESTINATION:C396(Into current selection:K19:1)
	REDUCE SELECTION:C351([Raw_Materials_Transactions:23]; 0)
	
End if   // END 4D Professional Services : January 2019 query selection
If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 Next record
	
	For ($i; 1; $MatlBud)  //* build an array of distinct Comm codes, from Budgeted materials to report on
		$comm:=Num:C11(Substring:C12([Job_Forms_Materials:55]Commodity_Key:12; 1; 2))
		
		If ($comm=0)  //backward compatiblity problem
			QUERY:C277([Raw_Materials:21]; [Raw_Materials:21]Raw_Matl_Code:1=[Job_Forms_Materials:55]Raw_Matl_Code:7)
			$comm:=Num:C11(Substring:C12([Raw_Materials:21]Commodity_Key:2; 1; 2))
		End if 
		$hit:=Find in array:C230($budComm; $comm)
		
		If ($hit=-1)
			$distinct:=$distinct+1
			$budComm{$distinct}:=$comm
		End if 
		NEXT RECORD:C51([Job_Forms_Materials:55])
	End for 
	
Else 
	
	ARRAY TEXT:C222($_Commodity_Key; 0)
	ARRAY TEXT:C222($_Raw_Matl_Code; 0)
	
	
	SELECTION TO ARRAY:C260([Job_Forms_Materials:55]Commodity_Key:12; $_Commodity_Key; [Job_Forms_Materials:55]Raw_Matl_Code:7; $_Raw_Matl_Code)
	
	For ($i; 1; $MatlBud; 1)
		$comm:=Num:C11(Substring:C12($_Commodity_Key{$i}; 1; 2))
		
		If ($comm=0)
			QUERY:C277([Raw_Materials:21]; [Raw_Materials:21]Raw_Matl_Code:1=$_Raw_Matl_Code{$i})
			$comm:=Num:C11(Substring:C12([Raw_Materials:21]Commodity_Key:2; 1; 2))
		End if 
		$hit:=Find in array:C230($budComm; $comm)
		
		If ($hit=-1)
			$distinct:=$distinct+1
			$budComm{$distinct}:=$comm
		End if 
		
	End for 
	
End if   // END 4D Professional Services : January 2019 First record

For ($i; 1; $Transfers)  //* build an array of distinct Comm codes, from Actual materials  to report on  
	$hit:=Find in array:C230($budComm; $RMCommCode{$i})
	
	If ($hit=-1)
		$distinct:=$distinct+1
		$budComm{$distinct}:=$RMCommCode{$i}
	End if 
End for 
ARRAY LONGINT:C221($budComm; $Distinct)  //resize to actual distinct values - more effecient than resiing array all the tim
SORT ARRAY:C229($budComm; >)

//If (Size of array($RMCommCode)>0)
//*  ** Planned Materials
If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 next record
	
	$CommsToPrin:=Size of array:C274($budComm)+Records in set:C195("OutsideService")  //Number of distinc commodity + one line each for outside serv detail
	CLEAR SET:C117("Outsideservice")
	
Else 
	
	$CommsToPrin:=Size of array:C274($budComm)+$number_record  //Number of distinc commodity + one line each for outside serv detail
	
	
End if   // END 4D Professional Services : January 2019 query selection

$CurrentTran:=1
ARRAY TEXT:C222(ayA1; $CommsToPrin)  //upr 1407 make larger
ARRAY REAL:C219(ayA2; $CommsToPrin)
ARRAY REAL:C219(ayA3; $CommsToPrin)
ARRAY REAL:C219(ayA4; $CommsToPrin)
ARRAY REAL:C219(ayA5; $CommsToPrin)
ARRAY REAL:C219(ayA6; $CommsToPrin)
ARRAY REAL:C219(ayA7; $CommsToPrin)

For ($i; 1; $CommstoPrin)  //for each distinct commodity/detail to print
	$LastComm:=$budComm{$CurrentTran}
	$RmIndex:=Find in array:C230($RmCommCode; $budComm{$CurrentTran})
	
	If ([Raw_Materials_Groups:22]Commodity_Key:3#String:C10($BudComm{$CurrentTran}; "00-"))
		QUERY:C277([Raw_Materials_Groups:22]; [Raw_Materials_Groups:22]Commodity_Key:3=String:C10($BudComm{$CurrentTran}; "00-"))
	End if 
	
	If (Records in selection:C76([Raw_Materials_Groups:22])=1)
		ayA1{$i}:=String:C10($budComm{$CurrentTran}; "00")+[Raw_Materials_Groups:22]Description:2
	Else 
		ayA1{$i}:="  No name for "+String:C10($budComm{$CurrentTran}; "00-")
	End if 
	
	If ($BudComm{$CurrentTran}=13)  //outside services
		$ServiceItem:=$i+1
	End if 
	
	If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
		USE SET:C118("theBudget")  //--------- Get Book Estimate ----------------
		QUERY SELECTION:C341([Job_Forms_Materials:55]; [Job_Forms_Materials:55]Commodity_Key:12=(String:C10($BudComm{$CurrentTran}; "00-")+"@"))
		
	Else 
		QUERY:C277([Job_Forms_Materials:55]; [Job_Forms_Materials:55]JobForm:1=[Job_Forms:42]JobFormID:5; *)  //03026/96 TJF
		QUERY:C277([Job_Forms_Materials:55]; [Job_Forms_Materials:55]Commodity_Key:12=(String:C10($BudComm{$CurrentTran}; "00-")+"@"))
		
	End if   // END 4D Professional Services : January 2019 query selection
	
	If (Records in selection:C76([Job_Forms_Materials:55])>0)
		ayA2{$i}:=ayA2{$i}+Round:C94((Sum:C1([Job_Forms_Materials:55]Planned_Cost:8)); 0)  //* Sum Planned costs for Materials in the current Commodity
	Else 
		ayA2{$i}:=0
	End if 
	
	Repeat 
		If ($RmIndex>0)
			ayA4{$i}:=ayA4{$i}+(Round:C94($RmCost{$RmIndex}; 0)*-1)  //According to Melissa 9/13/93 Cost_Std should be Cost_Act
			ayA6{$i}:=ayA6{$i}+(Round:C94($RmCost{$RmIndex}; 0)*-1)  //* Sum   Actual Extented Material costs
		End if 
		ayA3{$i}:=Round:C94(ayA2{$i}*rH2; 0)
		ayA5{$i}:=ayA3{$i}-ayA4{$i}
		ayA7{$i}:=ayA3{$i}-ayA6{$i}
		
		If ($budComm{$CurrentTran}=13)  //*    setup individual outside services
			If ($ServiceItem<=Size of array:C274(ayA1))  //•090498  MLB  
				//•090498  MLB  move line below
				ayA2{$ServiceItem}:=0  // zero for individual outside service
				
				If ($RmIndex>0) & ($RmIndex<=Size of array:C274($RMRawCode))  //•090498  MLB 
					ayA1{$ServiceItem}:="13~"+"•"+$RMRawCode{$RmIndex}  //material description            
					ayA4{$ServiceItem}:=(Round:C94($RmCost{$RmIndex}; 0)*-1)  //According to Melissa 9/13/93 Cost_Std should be Cost_Act
					ayA6{$ServiceItem}:=(Round:C94($RmCost{$RmIndex}; 0)*-1)  //*       Actual Extented Material costs - zero for individual outside service
				End if 
				ayA3{$ServiceItem}:=Round:C94(ayA2{$ServiceItem}*rH2; 0)
				ayA5{$ServiceItem}:=ayA3{$ServiceItem}-ayA4{$ServiceItem}
				ayA7{$ServiceItem}:=0
				If ($ServiceItem<Size of array:C274(ayA1))  //•090498  MLB  
					$ServiceItem:=$ServiceItem+1
				End if 
			End if   //size of
		End if   //os
		$RmIndex:=Find in array:C230($RmCommCode; $BudComm{$CurrentTran}; $RmIndex+1)
	Until ($RmIndex<0)
	
	Case of 
		: ($budComm{$CurrentTran}=1)  //board
			rBoardPrcnt:=(ayA4{$i}-ayA2{$i})/ayA2{$i}  //used later for adjusting machine runs
		: ($BudComm{$CurrentTran}=13)  //outside services
			// Modified by: Mel Bohince (11/8/16) idk y this was here to break out of the loop, but caused skip of plastic (20-plastic substrate)
			//$i:=$ServiceItem+$i-1  //add number of individual items to loop counter (-1 due to incrm of $ServiceItem)
	End case 
	$CurrentTran:=$CurrentTran+1
	
	If ($CurrentTran>Size of array:C274($BudComm))
		$i:=$CommstoPrin+1
	End if 
End for 
SORT ARRAY:C229(ayA1; ayA2; ayA3; ayA4; ayA5; ayA6; ayA7; >)

For ($i; 1; Size of array:C274(ayA1))  //lop off the sort character
	ayA1{$i}:=Substring:C12(ayA1{$i}; 3)
	
	If (Position:C15("~"; ayA1{$i})=1)  //replace tilde (used for sorting) with option - space (same size as big letter)
		ayA1{$i}[[1]]:=" "
	End if 
End for 
If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
	
	CLEAR SET:C117("theBudget")
Else 
	
	
End if   // END 4D Professional Services : January 2019 query selection
