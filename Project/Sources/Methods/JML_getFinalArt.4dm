//%attributes = {"publishedWeb":true}
//PM: JML_getFinalArt({jobform}) -> 
//@author mlb - rewrite 3/4/02  11:43
If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
	
	C_TEXT:C284($1)
	C_DATE:C307($0)
	
	If (Count parameters:C259=1)
		C_LONGINT:C283($numJMI)
		$numJMI:=qryJMI($1; 0; "@")
		If (Records in selection:C76([Job_Forms_Items:44])=0)  //this job has no items (still from estimate)
			
			REDUCE SELECTION:C351([Finished_Goods:26]; 0)
		Else 
			uRelateSelect(->[Finished_Goods:26]ProductCode:1; ->[Job_Forms_Items:44]ProductCode:3; 0)  //• upr 1848  
		End if 
	End if 
	
	$0:=!00-00-00!
	
	If (Records in selection:C76([Finished_Goods:26])>0)
		ARRAY DATE:C224($atDate; 0)
		SELECTION TO ARRAY:C260([Finished_Goods:26]DateArtApproved:46; $atDate)
		QUERY SELECTION:C341([Finished_Goods:26]; [Finished_Goods:26]DateArtApproved:46=!00-00-00!)  //art received 
		
		If (Records in selection:C76([Finished_Goods:26])=0)  //set final ART OK date
			ARRAY DATE:C224($aDate; 0)
			ARRAY DATE:C224($aDate; Size of array:C274($atDate))
			For ($i; 1; Size of array:C274($atDate))
				$aDate{$i}:=$atDate{$i}
			End for 
			SORT ARRAY:C229($aDate; <)
			$0:=$aDate{1}
		End if 
	End if 
Else 
	
	C_TEXT:C284($1)
	C_DATE:C307($0)
	
	$0:=!00-00-00!
	QUERY BY FORMULA:C48([Finished_Goods:26]; \
		([Job_Forms_Items:44]JobForm:1=$1)\
		 & ([Job_Forms_Items:44]ProductCode:3="@")\
		 & ([Finished_Goods:26]ProductCode:1=[Job_Forms_Items:44]ProductCode:3)\
		)
	
	
	If (Records in selection:C76([Finished_Goods:26])>0)
		ARRAY DATE:C224($atDate; 0)
		SELECTION TO ARRAY:C260([Finished_Goods:26]DateArtApproved:46; $atDate)
		QUERY SELECTION:C341([Finished_Goods:26]; [Finished_Goods:26]DateArtApproved:46=!00-00-00!)  //art received 
		
		If (Records in selection:C76([Finished_Goods:26])=0)  //set final ART OK date
			
			SORT ARRAY:C229($atDate; <)
			$0:=$atDate{1}
		End if 
	End if 
	
End if   // END 4D Professional Services : January 2019 query selection
