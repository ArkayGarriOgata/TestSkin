//%attributes = {"publishedWeb":true}
// _______
// Method: CostCtrCurrent   ( attributeDesired ; costcenterId {;->nonNumericVaribel}) 
//                             -> numeric value or cc's id if value set in param 3
//  original 120397  MLB
// By: Mel Bohince @ 06/03/21, 14:00:42
// Description
//  given a costcenter id, return the specified attribute
// ----------------------------------------------------
//•052198  MLB  add labor and burden
//•090399  mlb  UPR 2052 optional {Sales|Haup|Roan}` removed 06/03/21
//• mlb - 10/30/02  09:57 add dept name
// Modified by: Mel Bohince (6/3/21) rewrite with Storage, add 3rd param, 
//             see also methods CostCtrCurrent, CostCtrInit, CostCtrGroup
// Modified by: Mel Bohince (6/9/21) protection for empty collection and multiple effectivities

C_TEXT:C284($1; $whatAttribute; $2; $findCC)
C_POINTER:C301($3)  //optional {Sales|Haup|Roan}`•090399  mlb  UPR 2052

C_REAL:C285($0)
Case of 
	: ($1="init")  //catch old calls from startup, remove this later
		If (True:C214)  //use new way
			CostCtrInit
		Else   //old way
			CostCtrCurInit("effective"; $2)
		End if 
		
	: ($1="kill")  //for backward compatibility
		If (Storage:C1525.CostCenters#Null:C1517)
			Use (Storage:C1525)
				Use (Storage:C1525.CostCenters)
					Storage:C1525.CostCenters:=Null:C1517
				End use 
			End use 
		End if 
		
	Else 
		
		CostCtrInit  //setup if needed
		
		$findCC:=$2
		$whatAttribute:=Lowercase:C14($1)  //see also CostCtrInit for names
		
		C_COLLECTION:C1488($costCenter_c)
		$costCenter_c:=Storage:C1525.CostCenters.query("cc = :1"; $findCC)  //
		
		//below If block, untested, should work ;-)
		If ($costCenter_c.length>1)  //TODO, deal with multiple effective dates
			//as of 6/9/21 each cc has only one effective date, so the test rate stuff is not operable
			C_COLLECTION:C1488($orderedByEffectivity_c)
			$orderedByEffectivity_c:=$costCenter_c.orderBy("dated desc")
			$costCenter_c:=New collection:C1472
			$costCenter_c.push($orderedByEffectivity_c[0])
		End if 
		
		Case of 
			: ($costCenter_c.length=0)  // Modified by: Mel Bohince (6/9/21) 
				//ALERT($whatAttribute+" for C/C ' "+$findCC+" ' could not be found.")
				$0:=Num:C11($findCC)*-1
				
			: ($whatAttribute="desc") | ($whatAttribute="group") | ($whatAttribute="dept")  //$3 gets text
				If (Count parameters:C259=3)
					$3->:=$costCenter_c[0][$whatAttribute]
					$0:=Num:C11($costCenter_c[0]["cc"])
				Else 
					uConfirm("CostCtrCurrent needs a 3rd parameter for a date."; "Ok"; "Abort")
					$0:=-1
				End if 
				
			: ($whatAttribute="dated")  //$3 gets date
				If (Count parameters:C259=3)
					$3->:=Date:C102($costCenter_c[0][$whatAttribute])
					$0:=Num:C11($costCenter_c[0]["cc"])
				Else 
					uConfirm("CostCtrCurrent needs a 3rd parameter for a date."; "Ok"; "Abort")
					$0:=-1
				End if 
				
			Else   //return a number
				$0:=$costCenter_c[0][$whatAttribute]
		End case 
		
		
		//############ OLD WAY ##############
		C_LONGINT:C283($hit)
		Case of   //skip the old way
			: (True:C214)
				//pass
				
			: ($1="OOP")
				$hit:=Find in array:C230(aStdCC; $2)
				If ($hit>-1)
					$0:=aOOP{$hit}
				Else 
					$0:=0
				End if 
				
			: ($1="Labor")
				$hit:=Find in array:C230(aStdCC; $2)
				If ($hit>-1)
					$0:=aLabor{$hit}
				Else 
					$0:=0
				End if 
				
			: ($1="Burden")
				$hit:=Find in array:C230(aStdCC; $2)
				If ($hit>-1)
					$0:=aBurden{$hit}
				Else 
					$0:=0
				End if 
				
			: ($1="Scrap")
				$hit:=Find in array:C230(aStdCC; $2)
				If ($hit>-1)
					$0:=aScrap{$hit}
				Else 
					$0:=0
				End if 
				
			: ($1="Down")
				$hit:=Find in array:C230(aStdCC; $2)
				If ($hit>-1)
					$0:=aDownBudget{$hit}
				Else 
					$0:=0
				End if 
				
			: ($1="Desc")
				$hit:=Find in array:C230(aStdCC; $2)
				If ($hit>-1)
					$0:=$hit
				Else 
					$0:=0
				End if 
				
			: ($1="Dept")
				$hit:=Find in array:C230(aStdCC; $2)
				If ($hit>-1)
					$0:=$hit
				Else 
					$0:=0
				End if 
				
			: ($1="Group")
				$hit:=Find in array:C230(aStdCC; $2)
				If ($hit>-1)
					$0:=$hit
				Else 
					$0:=0
				End if 
				
			: ($1="Dated")
				$hit:=Find in array:C230(aStdCC; $2)
				If ($hit>-1)
					$0:=$hit
				Else 
					$0:=0
				End if 
				
			: ($1="init")  //*   Load the CostCenter OOP standards  
				If (Count parameters:C259<=2)
					CostCtrCurInit("effective"; $2)
				Else 
					//CostCtrCurInit ("effective";$2;$3)
				End if 
				
			: ($1="sort")
				SORT ARRAY:C229(aStdCC; aOOP; aLabor; aBurden; aCostCtrDes; aScrap; aCostCtrEff; aCostCtrGroup; aDownBudget; aCostCtrDept; >)
				
			: ($1="sort2")
				MULTI SORT ARRAY:C718(aCostCtrGroup; >; aStdCC; >; aOOP; aLabor; aBurden; aCostCtrDes; aScrap; aCostCtrEff; aDownBudget; aCostCtrDept; >)
				
			: ($1="kill")
				ARRAY TEXT:C222(aStdCC; 0)
				ARRAY REAL:C219(aOOP; 0)
				ARRAY REAL:C219(aLabor; 0)
				ARRAY REAL:C219(aBurden; 0)
				ARRAY REAL:C219(aScrap; 0)
				ARRAY TEXT:C222(aCostCtrDes; 0)
				ARRAY DATE:C224(aCostCtrEff; 0)
				ARRAY TEXT:C222(aCostCtrDept; 0)
				ARRAY TEXT:C222(aCostCtrGroup; 0)
				ARRAY REAL:C219(aDownBudget; 0)
				
			Else 
				BEEP:C151
				//ALERT("Message not supported by CostCtrCurrent")
		End case 
		
End case   //called with 'init' or 'kill' message