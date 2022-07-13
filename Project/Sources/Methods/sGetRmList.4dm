//%attributes = {"publishedWeb":true}
//(p) sGetRmList - 
//• 5/29/97 cs  placed 
//• 6/3/97 cs added check for Estimating generic Comodity keys
//see also - bgetRm - [material est]input, [process spec]input
//$1 - pointer to commodity key field
//$2- pointer to RawMAterial Code Field
//$3 - (optional) pointer to Sequence # field
//• 7/23/98 cs added code to update material estimates &
//•082402  mlb  fix table name
//possibly material pspecs

C_LONGINT:C283($RecNo)

If (Count parameters:C259=3)
	uConfirm("You are about to select a Raw Material code for Sequence '"+String:C10($3->; "000")+"' which is a '"+$1->+"' commodity type."; "Continue"; "Try Again")
Else 
	OK:=1
End if 

If (OK=1)
	If ($1->#"")
		
		Case of 
			: (Position:C15("-Special"; $1->)>0)
				$queryBy:=Substring:C12($1->; 1; 2)+"@"  //get all for the intended commodity
			: (Find in array:C230(<>EstCommKey; $1->)>-1)  //• 6/3/97 cs  & below line
				$queryBy:=$1->+"@"
			Else 
				$queryBy:=Substring:C12($1->; 1; 2)+"@"  //get all for the intended commodity
		End case 
		
		$recNo:=fPickList(->[Raw_Materials:21]Raw_Matl_Code:1; ->[Raw_Materials:21]Commodity_Key:2; ->[Raw_Materials:21]Description:4; $queryBy)  //get all for the intended commodity
		
		If ($recNo#-1)
			GOTO RECORD:C242([Raw_Materials:21]; $recNo)
			$2->:=[Raw_Materials:21]Raw_Matl_Code:1
			If (Table name:C256(Table:C252($1))="Job_Forms_Materials")  //update mat est only from mat job,`•082402  mlb  fix table name
				MatBud2MatEst
				RM_AllocationChk([Jobs:15]CustID:2)
			End if 
			POST KEY:C465(9)  //force cursor out of field so that it correctly redraws      
		End if 
		
	Else 
		uConfirm("You must pick a Commodity and Subgroup first."; "OK"; "Help")
	End if 
End if 
uClearSelection(->[Raw_Materials:21])