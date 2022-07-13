//%attributes = {"publishedWeb":true}
//PM: JML_getFinalOKs(form) -> date
//@author mlb - 3/4/02  11:44
// • mel (5/20/05, 10:42:55) overrides refer'd wrong array

C_TEXT:C284($1)
C_DATE:C307($0; $lastestDate)
C_BOOLEAN:C305($break)
C_LONGINT:C283($i; $numJMI)

If (True:C214)
	If (Count parameters:C259=1)
		$numJMI:=qryJMI($1; 0; "@")
		If (Records in selection:C76([Job_Forms_Items:44])=0)  //this job has no items (still from estimate)
			REDUCE SELECTION:C351([Finished_Goods:26]; 0)
		Else 
			If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
				
				uRelateSelect(->[Finished_Goods:26]ProductCode:1; ->[Job_Forms_Items:44]ProductCode:3; 0)  //• upr 1848  
				
			Else 
				
				RELATE ONE SELECTION:C349([Job_Forms_Items:44]; [Finished_Goods:26])
				
			End if   // END 4D Professional Services : January 2019 query selection
			
		End if 
		
	Else 
		//USE SET("ToProduce") `selection of fg made beforehand
	End if 
	
	$lastestDate:=!00-00-00!
	
	If (Records in selection:C76([Finished_Goods:26])>0)
		ARRAY DATE:C224($aSns; 0)
		ARRAY DATE:C224($aColor; 0)
		ARRAY DATE:C224($aSpec; 0)
		READ ONLY:C145([Customers:16])  // assume job is for just one customer
		RELATE ONE:C42([Finished_Goods:26]CustID:2)
		$requiredSizeAndStyle:=[Customers:16]NeedSizeAndStyle:58
		$requiredColor:=[Customers:16]NeedColorApproval:59
		$requiredSpecSheet:=[Customers:16]NeedSpecSheet:51
		SELECTION TO ARRAY:C260([Finished_Goods:26]DateSnS_Approved:83; $aSns; [Finished_Goods:26]DateColorApproved:86; $aColor; [Finished_Goods:26]DateSpecApproved:89; $aSpec)
		//*     are they all in?
		$break:=False:C215
		For ($i; 1; Size of array:C274($aSns))
			//allow omissions for some customers
			If (Not:C34($requiredSizeAndStyle)) & ($aSns{$i}=!00-00-00!)
				$aSns{$i}:=!2001-01-01!
			End if 
			If (Not:C34($requiredColor)) & ($aColor{$i}=!00-00-00!)
				$aColor{$i}:=!2001-01-01!  // • mel (5/20/05, 10:42:55)
			End if 
			If (Not:C34($requiredSpecSheet)) & ($aSpec{$i}=!00-00-00!)
				$aSpec{$i}:=!2001-01-01!  // • mel (5/20/05, 10:42:55)
			End if 
			
			Case of   //bail if any are null
				: ($aSns{$i}=!00-00-00!)
					$break:=True:C214
				: ($aColor{$i}=!00-00-00!)
					$break:=True:C214
				: ($aSpec{$i}=!00-00-00!)
					$break:=True:C214
			End case 
			
			If ($break)
				$i:=$i+10000
			Else   //get the latest date
				If ($aSns{$i}>$lastestDate)
					$lastestDate:=$aSns{$i}
				End if 
				If ($aColor{$i}>$lastestDate)
					$lastestDate:=$aColor{$i}
				End if 
				If ($aSpec{$i}>$lastestDate)
					$lastestDate:=$aSpec{$i}
				End if 
			End if 
		End for 
		
		If (Not:C34($break))
			$0:=$lastestDate
		End if 
	End if 
	
Else   // the ToDo method
	QUERY:C277([To_Do_Tasks:100]; [To_Do_Tasks:100]Jobform:1=$1)
	If (Records in selection:C76([To_Do_Tasks:100])>0)
		If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
			
			CREATE SET:C116([To_Do_Tasks:100]; "appvl")
			QUERY SELECTION:C341([To_Do_Tasks:100]; [To_Do_Tasks:100]Done:4=False:C215)
			If (Records in selection:C76([To_Do_Tasks:100])=0)  //all approved
				USE SET:C118("appvl")  //get latest date
				ARRAY DATE:C224($aDate; 0)
				SELECTION TO ARRAY:C260([To_Do_Tasks:100]DateDone:6; $aDate)
				SORT ARRAY:C229($aDate; <)
				$0:=$aDate{1}
			Else 
				$0:=!00-00-00!
			End if 
			CLEAR SET:C117("appvl")
			
		Else 
			
			$0:=!00-00-00!
			ARRAY DATE:C224($aDate; 0)
			QUERY SELECTION:C341([To_Do_Tasks:100]; [To_Do_Tasks:100]Done:4=False:C215)
			If (Records in selection:C76([To_Do_Tasks:100])=0)  //all approved
				DISTINCT VALUES:C339([To_Do_Tasks:100]DateDone:6; $aDate)
				If (Size of array:C274($aDate)>0)
					$0:=$aDate{Size of array:C274($aDate)}
				End if 
			End if 
			
		End if   // END 4D Professional Services : January 2019 query selection
		
	Else 
		$0:=4D_Current_date
	End if 
End if 