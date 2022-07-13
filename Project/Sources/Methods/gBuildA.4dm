//%attributes = {"publishedWeb":true}
//(P) gBuildA  Build array A
//12/30/94 major revisions
//upr 1407 make string array larger
//*03026/96 TJF    gBuild(JobFormID)
//042096 TJF
//050596 TJF removed alerts
//-------------------------------

C_LONGINT:C283($i; $lastComm; $k; $distinct; $matlBud; $hit)

MESSAGES OFF:C175  //042096 TJF
READ ONLY:C145([Raw_Materials_Transactions:23])
READ ONLY:C145([Raw_Materials_Groups:22])
//build an array of budget items that can be
//tested in case a budgeted item is not actually used
If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
	
	QUERY:C277([Job_Forms_Materials:55]; [Job_Forms_Materials:55]JobForm:1=[Job_Forms:42]JobFormID:5)  //*03026/96 TJF
	CREATE SET:C116([Job_Forms_Materials:55]; "theBudget")
	
	
Else 
	
	QUERY:C277([Job_Forms_Materials:55]; [Job_Forms_Materials:55]JobForm:1=[Job_Forms:42]JobFormID:5)  //*03026/96 TJF
	
	
End if   // END 4D Professional Services : January 2019 query selection
$matlBud:=Records in selection:C76([Job_Forms_Materials:55])
$distinct:=0
ARRAY LONGINT:C221($budComm; $distinct)
If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 Next record
	
	For ($i; 1; $matlBud)
		$comm:=Num:C11(Substring:C12([Job_Forms_Materials:55]Commodity_Key:12; 1; 2))
		
		If ($comm=0)  //backward compatiblity problem
			QUERY:C277([Raw_Materials:21]; [Raw_Materials:21]Raw_Matl_Code:1=[Job_Forms_Materials:55]Raw_Matl_Code:7)
			$comm:=Num:C11(Substring:C12([Raw_Materials:21]Commodity_Key:2; 1; 2))
		End if 
		$hit:=Find in array:C230($budComm; $comm)
		
		If ($hit=-1)
			$distinct:=$distinct+1
			ARRAY LONGINT:C221($budComm; $distinct)
			$budComm{$distinct}:=$comm
		End if 
		NEXT RECORD:C51([Job_Forms_Materials:55])
	End for 
	
Else 
	
	ARRAY TEXT:C222($_Commodity_Key; 0)
	ARRAY TEXT:C222($_Raw_Matl_Code; 0)
	
	
	SELECTION TO ARRAY:C260([Job_Forms_Materials:55]Commodity_Key:12; $_Commodity_Key; [Job_Forms_Materials:55]Raw_Matl_Code:7; $_Raw_Matl_Code)
	
	For ($i; 1; Size of array:C274($_Commodity_Key); 1)
		$comm:=Num:C11(Substring:C12($_Commodity_Key{$i}; 1; 2))
		
		If ($comm=0)  //backward compatiblity problem
			QUERY:C277([Raw_Materials:21]; [Raw_Materials:21]Raw_Matl_Code:1=$_Raw_Matl_Code{$i})
			$comm:=Num:C11(Substring:C12([Raw_Materials:21]Commodity_Key:2; 1; 2))
		End if 
		$hit:=Find in array:C230($budComm; $comm)
		
		If ($hit=-1)
			$distinct:=$distinct+1
			ARRAY LONGINT:C221($budComm; $distinct)
			$budComm{$distinct}:=$comm
		End if 
		
	End for 
	
End if   // END 4D Professional Services : January 2019 First record

SORT ARRAY:C229($budComm; >)
ARRAY LONGINT:C221($hasActual; $distinct)

QUERY:C277([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]JobForm:12=[Job_Forms:42]JobFormID:5; *)
QUERY:C277([Raw_Materials_Transactions:23];  & ; [Raw_Materials_Transactions:23]Location:15="WIP")

If (Records in selection:C76([Raw_Materials_Transactions:23])>0)
	ORDER BY:C49([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]CommodityCode:24; >)
End if 
$lastComm:=0
$k:=0

//*  ** Planned Materials
If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) Next record
	
	For ($i; 1; Records in selection:C76([Raw_Materials_Transactions:23]))
		If ([Raw_Materials_Transactions:23]CommodityCode:24=$lastComm)
			//According to Melissa 9/13/93 Cost_Std should be Cost_Act
			ayA4{$k}:=ayA4{$k}+(Round:C94([Raw_Materials_Transactions:23]ActExtCost:10; 0)*-1)
			ayA6{$k}:=ayA6{$k}+(Round:C94([Raw_Materials_Transactions:23]ActExtCost:10; 0)*-1)
			
		Else   //finish off the calculation for last commodity
			If ($lastComm#0)  // don't do for first pass
				ayA3{$k}:=Round:C94(ayA2{$k}*rH2; 0)
				ayA5{$k}:=ayA3{$k}-ayA4{$k}
				ayA7{$k}:=ayA3{$k}-ayA6{$k}
				
				$hit:=Find in array:C230($budComm; $lastComm)  //mark the commodity as being used
				If ($hit>0)
					$hasActual{$hit}:=1
				End if 
				
				If ($lastComm=1)
					ayE2{18}:=ayA6{$k}
					ayE2{22}:=ayA5{$k}
				End if 
			End if 
			
			//set up next commodity
			$lastComm:=[Raw_Materials_Transactions:23]CommodityCode:24
			$k:=$k+1
			ARRAY TEXT:C222(ayA1; $k)  //upr 1407 make larger
			ARRAY REAL:C219(ayA2; $k)
			ARRAY REAL:C219(ayA3; $k)
			ARRAY REAL:C219(ayA4; $k)
			ARRAY REAL:C219(ayA5; $k)
			ARRAY REAL:C219(ayA6; $k)
			ARRAY REAL:C219(ayA7; $k)
			
			QUERY:C277([Raw_Materials_Groups:22]; [Raw_Materials_Groups:22]Commodity_Key:3=String:C10($lastComm; "00-"))
			If (Records in selection:C76([Raw_Materials_Groups:22])=1)
				ayA1{$k}:=String:C10($lastComm; "00")+[Raw_Materials_Groups:22]Description:2
			Else 
				ayA1{$k}:="  No name for "+String:C10($lastComm; "00-")
			End if 
			
			//--------- Get Book Estimate ----------------
			If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
				USE SET:C118("theBudget")
				QUERY SELECTION:C341([Job_Forms_Materials:55]; [Job_Forms_Materials:55]Commodity_Key:12=(String:C10($lastComm; "00-")+"@"))
				
				
			Else 
				QUERY:C277([Job_Forms_Materials:55]; [Job_Forms_Materials:55]JobForm:1=[Job_Forms:42]JobFormID:5; *)  //*03026/96 TJF
				QUERY:C277([Job_Forms_Materials:55]; [Job_Forms_Materials:55]Commodity_Key:12=(String:C10($lastComm; "00-")+"@"))
				
				
			End if   // END 4D Professional Services : January 2019 query selection
			If (Records in selection:C76([Job_Forms_Materials:55])>0)
				ayA2{$k}:=ayA2{$k}+Round:C94((Sum:C1([Job_Forms_Materials:55]Planned_Cost:8)); 0)  //* Sum Planned costs for Materials in the current Commodity
			Else 
				ayA2{$k}:=0
			End if 
			
			//-------------------------------------------
			//According to Melissa 9/13/93 Cost_Std should be Cost_Act
			ayA4{$k}:=ayA4{$k}+(Round:C94([Raw_Materials_Transactions:23]ActExtCost:10; 0)*-1)  //* Sum (negative)  Actual Extented Material costs
			ayA6{$k}:=ayA6{$k}+(Round:C94([Raw_Materials_Transactions:23]ActExtCost:10; 0)*-1)
			
		End if   //different commodity
		
		NEXT RECORD:C51([Raw_Materials_Transactions:23])
	End for 
	
	
Else 
	
	ARRAY REAL:C219($_ActExtCost; 0)
	ARRAY INTEGER:C220($_CommodityCode; 0)
	
	SELECTION TO ARRAY:C260([Raw_Materials_Transactions:23]ActExtCost:10; $_ActExtCost; \
		[Raw_Materials_Transactions:23]CommodityCode:24; $_CommodityCode)
	
	For ($i; 1; Size of array:C274($_CommodityCode); 1)
		If ($_CommodityCode{$i}=$lastComm)
			//According to Melissa 9/13/93 Cost_Std should be Cost_Act
			ayA4{$k}:=ayA4{$k}+(Round:C94($_ActExtCost{$i}; 0)*-1)
			ayA6{$k}:=ayA6{$k}+(Round:C94($_ActExtCost{$i}; 0)*-1)
			
		Else   //finish off the calculation for last commodity
			If ($lastComm#0)  // don't do for first pass
				ayA3{$k}:=Round:C94(ayA2{$k}*rH2; 0)
				ayA5{$k}:=ayA3{$k}-ayA4{$k}
				ayA7{$k}:=ayA3{$k}-ayA6{$k}
				
				$hit:=Find in array:C230($budComm; $lastComm)  //mark the commodity as being used
				If ($hit>0)
					$hasActual{$hit}:=1
				End if 
				
				If ($lastComm=1)
					ayE2{18}:=ayA6{$k}
					ayE2{22}:=ayA5{$k}
				End if 
			End if 
			
			//set up next commodity
			$lastComm:=$_CommodityCode{$i}
			$k:=$k+1
			ARRAY TEXT:C222(ayA1; $k)  //upr 1407 make larger
			ARRAY REAL:C219(ayA2; $k)
			ARRAY REAL:C219(ayA3; $k)
			ARRAY REAL:C219(ayA4; $k)
			ARRAY REAL:C219(ayA5; $k)
			ARRAY REAL:C219(ayA6; $k)
			ARRAY REAL:C219(ayA7; $k)
			
			QUERY:C277([Raw_Materials_Groups:22]; [Raw_Materials_Groups:22]Commodity_Key:3=String:C10($lastComm; "00-"))
			If (Records in selection:C76([Raw_Materials_Groups:22])=1)
				ayA1{$k}:=String:C10($lastComm; "00")+[Raw_Materials_Groups:22]Description:2
			Else 
				ayA1{$k}:="  No name for "+String:C10($lastComm; "00-")
			End if 
			
			//--------- Get Book Estimate ----------------
			QUERY:C277([Job_Forms_Materials:55]; [Job_Forms_Materials:55]JobForm:1=[Job_Forms:42]JobFormID:5; *)  //*03026/96 TJF
			QUERY:C277([Job_Forms_Materials:55]; [Job_Forms_Materials:55]Commodity_Key:12=(String:C10($lastComm; "00-")+"@"))
			
			
			If (Records in selection:C76([Job_Forms_Materials:55])>0)
				ayA2{$k}:=ayA2{$k}+Round:C94((Sum:C1([Job_Forms_Materials:55]Planned_Cost:8)); 0)  //* Sum Planned costs for Materials in the current Commodity
			Else 
				ayA2{$k}:=0
			End if 
			
			//-------------------------------------------
			//According to Melissa 9/13/93 Cost_Std should be Cost_Act
			ayA4{$k}:=ayA4{$k}+(Round:C94($_ActExtCost{$i}; 0)*-1)  //* Sum (negative)  Actual Extented Material costs
			ayA6{$k}:=ayA6{$k}+(Round:C94($_ActExtCost{$i}; 0)*-1)
			
		End if   //different commodity
		
	End for 
	
	
End if   // END 4D Professional Services : January 2019 
//------------- Do last material -----------------
ayA3{$k}:=Round:C94(ayA2{$k}*rH2; 0)  //* Planned over run allowance
ayA5{$k}:=ayA3{$k}-ayA4{$k}  //* Sum  (Planned costs - Actuals)
ayA7{$k}:=ayA3{$k}-ayA6{$k}
$hit:=Find in array:C230($budComm; $lastComm)  //mark the commodity as being used

If ($hit>0)
	$hasActual{$hit}:=1
End if 

If ($lastComm=1)
	ayE2{18}:=ayA6{$k}
	ayE2{22}:=ayA5{$k}
End if 
//* ** set up un-issued bduget items
For ($i; 1; $distinct)
	If ($hasActual{$i}=0)
		$k:=$k+1
		ARRAY TEXT:C222(ayA1; $k)  //upr 1407 make larger
		ARRAY REAL:C219(ayA2; $k)
		ARRAY REAL:C219(ayA3; $k)
		ARRAY REAL:C219(ayA4; $k)
		ARRAY REAL:C219(ayA5; $k)
		ARRAY REAL:C219(ayA6; $k)
		ARRAY REAL:C219(ayA7; $k)
		QUERY:C277([Raw_Materials_Groups:22]; [Raw_Materials_Groups:22]Commodity_Key:3=String:C10($budComm{$i}; "00-"))
		
		If (Records in selection:C76([Raw_Materials_Groups:22])=1)
			ayA1{$k}:=String:C10($budComm{$i}; "00")+[Raw_Materials_Groups:22]Description:2
		Else 
			ayA1{$k}:="  No name for "+String:C10($budComm{$i}; "00-")
		End if 
		If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
			USE SET:C118("theBudget")
			QUERY SELECTION:C341([Job_Forms_Materials:55]; [Job_Forms_Materials:55]Commodity_Key:12=(String:C10($budComm{$i}; "00-")+"@"))
			
		Else 
			QUERY:C277([Job_Forms_Materials:55]; [Job_Forms_Materials:55]JobForm:1=[Job_Forms:42]JobFormID:5; *)  //*03026/96 TJF
			QUERY:C277([Job_Forms_Materials:55]; [Job_Forms_Materials:55]Commodity_Key:12=(String:C10($budComm{$i}; "00-")+"@"))
			
		End if   // END 4D Professional Services : January 2019 query selection
		If (Records in selection:C76([Job_Forms_Materials:55])>0)
			ayA2{$k}:=ayA2{$k}+Round:C94((Sum:C1([Job_Forms_Materials:55]Planned_Cost:8)); 0)  //* Sum Planned costs for Materials in the current Commodity
		Else 
			ayA2{$k}:=0
		End if 
		ayA3{$k}:=Round:C94(ayA2{$k}*rH2; 0)  //* Planned over run allowance
		ayA5{$k}:=ayA3{$k}-ayA4{$k}  //* Sum  (Planned costs - Actuals)
		ayA7{$k}:=ayA3{$k}-ayA6{$k}
	End if 
End for 
SORT ARRAY:C229(ayA1; ayA2; ayA3; ayA4; ayA5; ayA6; ayA7; >)

For ($i; 1; Size of array:C274(ayA1))  //lop off the sort character
	ayA1{$i}:=Substring:C12(ayA1{$i}; 3)
End for 
If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
	
	CLEAR SET:C117("theBudget")
Else 
	
End if   // END 4D Professional Services : January 2019 query selection
