//%attributes = {"publishedWeb":true}
//(p) sAddCart2Est
//Moved this code from script - effeciency
//1016/97 cs created
//upr 1365 12/21/94
//2/15/95 so an Excess orderline can be created.
//•060295  MLB  UPR 184 allow search by brand and release
//•061395  MLB  UPR 1637 allow doing an add without first searching
//•120695  MLB  UPR 234 chg method of primary keying CartonSpec records
//•012296  MLB  put the add records into repeat loops to speed interface
//•960618 mlb stop sbillling search
// Modified by: Mel Bohince (4/18/18) add release date to pick dialog and outline and pspec
// Modified by: Garri Ogata (9/21/21) added EsCS_SetItemT ()
// Modified by: Mel Bohince (10/26/21) add clipboard option

C_LONGINT:C283($i; $numRecs; $hit; $numAdded; $winRef)

$winRef:=OpenSheetWindow(->[Finished_Goods:26]; "PickOptions")

//*Decide on method of adding cartons
DIALOG:C40([Finished_Goods:26]; "PickOptions")
CLOSE WINDOW:C154

If (OK=1)
	//*Establish the next item number to use  
	gEstimateLDWkSh("Wksht")
	
	$useCase:=<>sQtyWorksht  //"00"
	
	Case of 
		: (bNew=1)  //*.   Directly add carton
			Repeat 
				ADD RECORD:C56([Estimates_Carton_Specs:19]; *)
			Until (OK=0)
			
		: (bFromClipboard=1)  // Modified by: Mel Bohince (10/26/21)
			Est_getFGKEYfromClipboard
			
		Else   //original way, by brand or cust
			//*.   Get a list of cartons by establishing a current selection
			// BEGIN 4D Professional Services : January 2019 query selection
			If ([Estimates:17]Cust_ID:2#<>sCombindID)  // Modified by: Mel Bohince (4/21/18)   
				qryFinishedGood([Estimates:17]Cust_ID:2; "@"; 1)  //•060295  MLB  UPR 184,`•960618 mlb stop sbillling search
				If (bBrand=1)  //[ESTIMATE]Brand#"")`*.   Include only the ones in this brand
					QUERY SELECTION:C341([Finished_Goods:26]; [Finished_Goods:26]Line_Brand:15=[Estimates:17]Brand:3)
				End if 
				
			Else 
				If (bBrand=1)  //[ESTIMATE]Brand#"")`*.   Include only the ones in this brand
					QUERY:C277([Finished_Goods:26]; [Finished_Goods:26]Line_Brand:15=[Estimates:17]Brand:3)
				Else 
					ALL RECORDS:C47([Finished_Goods:26])
				End if 
			End if 
			// END 4D Professional Services : January 2019 query selection
			
			
			
			//*.   Load pick arrays  
			ARRAY BOOLEAN:C223(ListBox1; 0)
			ARRAY TEXT:C222(aSelected; 0)
			ARRAY LONGINT:C221(aLi; 0)
			ARRAY TEXT:C222(aCPN; 0)
			ARRAY TEXT:C222(aDesc; 0)
			ARRAY TEXT:C222(aOutline; 0)
			ARRAY TEXT:C222(aPSpec; 0)
			ARRAY INTEGER:C220(aWeek; 0)
			ARRAY TEXT:C222(aStock; 0)
			ARRAY DATE:C224(aNextRelease; 0)
			
			SELECTION TO ARRAY:C260([Finished_Goods:26]; aLi; [Finished_Goods:26]ProductCode:1; aCPN; [Finished_Goods:26]CartonDesc:3; aDesc; [Finished_Goods:26]OutLine_Num:4; aOutline; [Finished_Goods:26]ProcessSpec:33; aPSpec)
			SORT ARRAY:C229(aCPN; aDesc; aLi; aPSpec; aOutline; >)
			$numRecs:=Size of array:C274(aCPN)
			ARRAY TEXT:C222(aSelected; $numRecs)
			ARRAY INTEGER:C220(aWeek; $numRecs)
			ARRAY TEXT:C222(aStock; $numRecs)
			ARRAY DATE:C224(aNextRelease; $numRecs)
			// Modified by: Mel Bohince (4/18/18) 
			READ ONLY:C145([Customers_ReleaseSchedules:46])
			// see also JML_get1stRelease, JMI_get1stRelease, REL_getNextRelease
			For ($i; 1; Size of array:C274(aCPN))
				aNextRelease{$i}:=!00-00-00!
				aWeek{$i}:=0
				aStock{$i}:=""
			End for 
			// end Modified by: Mel Bohince (4/18/18) 
			
			$winRef:=OpenFormWindow(->[Finished_Goods:26]; "PickMultiFG")
			
			allowNew:=True:C214
			DIALOG:C40([Finished_Goods:26]; "PickMultiFG")  //window previously opened used, & erased
			CLOSE WINDOW:C154
			If (OK=1)
				If (bNew=1)  //user wishes to create a brand new process spec record
					Repeat 
						ADD RECORD:C56([Estimates_Carton_Specs:19]; *)
					Until (OK=0)
					
				Else   //user wishes to attach exisitng process specs to this estimate.
					$i:=1
					$numAdded:=0
					SELECTION TO ARRAY:C260([Estimates_Carton_Specs:19]ProductCode:5; $alreadyPicked)
					
					While ($i<=$numRecs)
						$i:=Find in array:C230(aSelected; "X"; $i)
						If ($i#-1)
							$hit:=Find in array:C230($alreadyPicked; aCPN{$i})
							If ($hit=-1)
								CREATE RECORD:C68([Estimates_Carton_Specs:19])
								[Estimates_Carton_Specs:19]Estimate_No:2:=[Estimates:17]EstimateNo:1
								[Estimates_Carton_Specs:19]diffNum:11:=$useCase  //◊sQtyWorksht  `defined in 00CompileString()  indicates records go to Qty-Worksheet
								[Estimates_Carton_Specs:19]Item:1:=EsCS_SetItemT(nextItem)
								//[Estimates_Carton_Specs]Item:=String(nextItem;"00")
								[Estimates_Carton_Specs:19]CartonSpecKey:7:=fCSpecID  //•120695  MLB  UPR 234 chg method of primary keying CartonSpec records
								[Estimates_Carton_Specs:19]CustID:6:=[Estimates:17]Cust_ID:2
								[Estimates_Carton_Specs:19]ProductCode:5:=aCPN{$i}
								[Estimates_Carton_Specs:19]OriginalOrRepeat:9:="Repeat"
								[Estimates_Carton_Specs:19]PONumber:73:=[Estimates:17]POnumber:18
								[Estimates_Carton_Specs:19]zCount:51:=1
								GOTO RECORD:C242([Finished_Goods:26]; aLi{$i})
								FG_CspecLikeFG
								SAVE RECORD:C53([Estimates_Carton_Specs:19])
								$numAdded:=$numAdded+1
								nextItem:=nextItem+1
							End if 
							$i:=$i+1
							
						Else 
							$i:=$numRecs+1  //break        
						End if 
					End while 
					gEstimateLDWkSh("Wksht")
				End if 
			End if 
			
			ARRAY LONGINT:C221(aLi; 0)
			ARRAY TEXT:C222(aCPN; 0)
			ARRAY TEXT:C222(aDesc; 0)  //
			ARRAY TEXT:C222(aSelected; 0)
			
	End case 
	
End if 

gEstimateLDWkSh("Last")