//%attributes = {"publishedWeb":true}
//(p) JCO_NewBinHndlr
//create arrays for new bins, or insert new bin
//assign new bin values
//$1 string (one charater) type of action to take
//$2 - long int - number of elements to create, or element to assign to
//$3 - long int - index into POI arrays to assign from
//$4 - long int - Index into Issue ticket arrays to assign from
//Returns - next element in new bin arrays to asign to
//• 10/31/97 cs created
//• 3/9/98 cs 
//• 3/11/98 cs add JOBform to new bin for tie to issuing

C_TEXT:C284($1; $Type)
C_LONGINT:C283($2; $Count; $3; $4; $0; $MaxSize)

$Type:=$1
If (Type:C295(aNewRM)=5)
	$Maxsize:=Records in set:C195("BinsToPost")
Else 
	$MaxSize:=Size of array:C274(aNewRM)
End if 

Case of 
	: ($Type="+")  //add an element
		$Count:=$Maxsize+1
	: ($Type="A") & ($2<=$Maxsize)  //assign only, $2 is element to assign to
		$Count:=$2
	: ($Type="A") & ($2<=$Maxsize)  //assign but element to assing to is out of range, treat as add
		$Count:=$Maxsize+1
		$Type:="+"
	: ($Type="i")  //initialize
		$Count:=$2
	: ($Type="C")  //commiting to table
		$Count:=$2-1  //used to insure arrays are sized to used amounts     
End case 

If ($Type#"C")
	If ($Type#"A")  //there is need to change array sizes
		ARRAY TEXT:C222(aNewRM; $Count)
		ARRAY TEXT:C222(aNewPoiKey; $Count)
		ARRAY REAL:C219(aNewQty; $Count)
		ARRAY REAL:C219(aNewCost; $Count)
		ARRAY TEXT:C222(aNewCompID; $Count)
		ARRAY TEXT:C222(aNewDept; $Count)
		ARRAY TEXT:C222(aNewExpCode; $Count)
		ARRAY DATE:C224(aNewModDate; $Count)
		ARRAY TEXT:C222(aNewModWho; $Count)
	End if 
	
	If ($Type#"I")  //do assignments
		aRmCode{$4}:=aPOIRmCode{$3}  //• 3/9/98 cs track RMCode from POI back into Issue ticket    
		aNewRm{$Count}:=aPOIRmCode{$3}
		aNewPoiKey{$Count}:=aPOIPoiKey{$3}
		aNewQty{$Count}:=-aIssueQty{$4}
		aNewCost{$Count}:=uNANCheck(aPOIPrice{$3})
		aNewCompID{$Count}:=aPOICompId{$3}
		aNewDept{$Count}:=aPOIDept{$3}
		aNewExpCode{$Count}:=aPOIExpCode{$3}
		aNewModDate{$Count}:=4D_Current_date
		aNewModWho{$Count}:=<>zResp
	End if 
	$0:=$Count+1
	
Else   //commit new bins to table
	ARRAY TEXT:C222(aNewRM; $Count)  //resize to actually used amounts so that no blank records are created
	ARRAY TEXT:C222(aNewPoiKey; $Count)
	ARRAY REAL:C219(aNewQty; $Count)
	ARRAY REAL:C219(aNewCost; $Count)
	ARRAY TEXT:C222(aNewCompID; $Count)
	ARRAY TEXT:C222(aNewDept; $Count)
	ARRAY TEXT:C222(aNewExpCode; $Count)
	ARRAY DATE:C224(aNewModDate; $Count)
	ARRAY TEXT:C222(aNewModWho; $Count)
	uClearSelection(->[Raw_Materials_Locations:25])  //clear selection so array -> select will create new
	COPY ARRAY:C226(aNewQty; $Commit)  //committed amount is positive
	ARRAY TEXT:C222($Location; Size of array:C274($Commit))  //setup 
	
	For ($Count; 1; Size of array:C274($Commit))
		$Commit{$Count}:=-$Commit{$Count}
		$Location{$Count}:=("Arkay"*Num:C11(aNewCompId{$Count}="1"))+("Roanoke"*Num:C11(aNewCompId{$Count}="2"))+("Labels"*Num:C11(aNewCompId{$Count}="3"))
	End for 
	//create Bin records from arrays
	ARRAY TO SELECTION:C261(aNewRM; [Raw_Materials_Locations:25]Raw_Matl_Code:1; aNewPoiKey; [Raw_Materials_Locations:25]POItemKey:19; aNewQty; [Raw_Materials_Locations:25]QtyOH:9; aNewQty; [Raw_Materials_Locations:25]QtyAvailable:13; $Commit; [Raw_Materials_Locations:25]QtyCommitted:11; aNewCost; [Raw_Materials_Locations:25]ActCost:18; aNewCompID; [Raw_Materials_Locations:25]CompanyID:27; aNewModDate; [Raw_Materials_Locations:25]ModDate:21; aNewModWho; [Raw_Materials_Locations:25]ModWho:22; $Location; [Raw_Materials_Locations:25]Location:2)
	$Count:=0  //clean up
	ARRAY TEXT:C222(aNewRM; $Count)
	ARRAY TEXT:C222(aNewPoiKey; $Count)
	ARRAY REAL:C219(aNewQty; $Count)
	ARRAY REAL:C219(aNewCost; $Count)
	ARRAY TEXT:C222(aNewCompID; $Count)
	ARRAY TEXT:C222(aNewDept; $Count)
	ARRAY TEXT:C222(aNewExpCode; $Count)
	ARRAY DATE:C224(aNewModDate; $Count)
	ARRAY TEXT:C222(aNewModWho; $Count)
	ARRAY TEXT:C222(aNewJobForm; $Count)
	$0:=0
End if 