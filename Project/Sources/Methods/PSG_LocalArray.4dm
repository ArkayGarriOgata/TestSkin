//%attributes = {}

// Method: PSG_LocalArray ( )  -> 
// ----------------------------------------------------
// Author: Mel Bohince
// Created: 02/26/14, 14:29:39
// ----------------------------------------------------
// Description
// client side tricks on the master array
// based on pattern_Collection
// ----------------------------------------------------

// Modified by: Garri Ogata (9/10/20) added local values for columns so sorts can be changed easily should column order change
// Modified by: Mel Bohince (8/31/21) replace GET PICTURE FROM LIBRARY with READ PICTURE FILE

C_TEXT:C284($msg; $1)
C_LONGINT:C283($0; $2; $rtn_int)
C_TEXT:C284($3)

$msg:=$1

C_LONGINT:C283($nColGluer; $nColPriority)
C_LONGINT:C283($nColCustomer; $nColProductCode)
C_LONGINT:C283($nColJobit; $nColQtyWant)
C_LONGINT:C283($nColReleased; $nColHRD)

$nColGluer:=1
$nColPriority:=2
$nColCustomer:=3
$nColProductCode:=4
$nColJobit:=6
$nColQtyWant:=7
$nColReleased:=9
$nColHRD:=11

Case of 
	: ($msg="new")
		ARRAY TEXT:C222(aCustColor; 10)
		ARRAY LONGINT:C221(aCustColorValue; 10)
		// RGB color picker:   http://www.psyclops.com/tools/rgb/
		aCustColor{1}:="00199"  //png
		aCustColorValue{1}:=0x00FFDFFF
		
		aCustColor{2}:="00050"  //clin
		aCustColorValue{2}:=0x00E2FFDF
		
		aCustColor{3}:="00121"  //len
		aCustColorValue{3}:=0x00DFFFFF
		
		aCustColor{4}:="00074"  //earden
		aCustColorValue{4}:=0x00FFFFDF
		
		aCustColor{5}:="01780"  //bobby brn
		aCustColorValue{5}:=0x00CC99CC
		
		aCustColor{6}:="01547"  //intr-parfums
		aCustColorValue{6}:=0x00FFE0E0
		
		aCustColor{7}:="00015"  //arimas
		aCustColorValue{7}:=0x00D0FFC9
		
		aCustColor{8}:="00765"  //loreal
		aCustColorValue{8}:=0x0045A7EC
		
		aCustColor{9}:="01039"  //mac cosm
		aCustColorValue{9}:=0x0056CCCC
		
		aCustColor{10}:="01909"  //Strv
		aCustColorValue{10}:=0x00FF9999
		
		C_PICTURE:C286(pGreenPic; pRedPic; pBlankPic)
		C_TEXT:C284($pathToResource)  // Modified by: Mel Bohince (8/31/21) 
		$pathToResource:=Get 4D folder:C485(Current resources folder:K5:16)+"prodSched"+Folder separator:K24:12
		READ PICTURE FILE:C678($pathToResource+"GreenBox.png"; pGreenPic)
		READ PICTURE FILE:C678($pathToResource+"RedBox.png"; pRedPic)
		READ PICTURE FILE:C678($pathToResource+"BlankBox.png"; pBlankPic)
		
		$0:=PSG_LocalArray("size"; 0)
		
	: ($msg="add")
		
	: ($msg="dispose")
		$0:=PSG_LocalArray("size"; 0)
		
		
	: ($msg="hide")
		$0:=PSG_ApplySettingOptions
		
		
	: ($msg="size")
		ARRAY BOOLEAN:C223(aGlueListBox; $2)
		ARRAY LONGINT:C221(aRowStyle; $2)
		ARRAY LONGINT:C221(axlRowColor; $2)
		ARRAY LONGINT:C221(axlRowBkgd; $2)
		ARRAY BOOLEAN:C223(abHidden; $2)
		ARRAY PICTURE:C279(apPrinted; $2)
		ARRAY PICTURE:C279(apDieCut; $2)
		ARRAY PICTURE:C279(apProgressStatus; $2)
		
		$0:=Size of array:C274(aGlueListBox)
		
	: ($msg="sizeOf")
		$0:=Size of array:C274(aGlueListBox)
		
	: ($msg="sort")
		Case of 
			: ($2=1) | ($2=895)
				LISTBOX SORT COLUMNS:C916(aGlueListBox; $nColReleased; >; $nColHRD; >; $nColJobit; >)  //Rel,HRD,Jobit
				$0:=895
				
			: ($2=2) | ($2=128935)
				LISTBOX SORT COLUMNS:C916(aGlueListBox; $nColGluer; >; $nColPriority; >; $nColReleased; >; $nColHRD; >; $nColQtyWant; >; $nColJobit; >)  //gluer, prior, rel, hrd, qty, jobit
				$0:=128935
				
			: ($2=3) | ($2=985)
				LISTBOX SORT COLUMNS:C916(aGlueListBox; $nColHRD; >; $nColReleased; >; $nColJobit; >)  //Sort by HRD, release, and jobit
				$0:=985
				
			: ($2=4) | ($2=50)
				LISTBOX SORT COLUMNS:C916(aGlueListBox; $nColJobit; >)  //jobit
				$0:=50
				
			: ($2=5) | ($2=48)
				LISTBOX SORT COLUMNS:C916(aGlueListBox; $nColProductCode; >; $nColJobit; >)  //Sort by productcode and jobit
				$0:=48
				
			: ($2=6) | ($2=349)
				LISTBOX SORT COLUMNS:C916(aGlueListBox; $nColCustomer; >; $nColProductCode; >; $nColReleased; >)  //Sort by customer, product, release
				$0:=349
				
			: ($2=7) | ($2=125)
				LISTBOX SORT COLUMNS:C916(aGlueListBox; $nColCustomer; >; $nColProductCode; >; $nColReleased; >)  //Sort by customer, product, release
				$0:=125
				
			: ($2=8) | ($2=20)
				LISTBOX SORT COLUMNS:C916(aGlueListBox; $nColPriority; >)  //Sort by priority
				$0:=20
				
			Else 
				LISTBOX SORT COLUMNS:C916(aGlueListBox; $nColReleased; >; $nColHRD; >; $nColCustomer; >; $nColJobit; >)  //Rel,HRD,Cust,Jobit
				$0:=8935
		End case 
		
	: ($msg="Extend")
		C_TEXT:C284($text)
		C_LONGINT:C283($fence; $i; $increment)
		//uThermoInit ($numElements;"Processing Array")
		//ARRAY TEXT($aJobits;0)
		//$numElements:=Size of array(aGlueListBox)
		//For ($i;1;$numElements)
		//If (Not(abHidden{$i}))
		//APPEND TO ARRAY($aJobits;aJobit{$i})
		//End if 
		//uThermoUpdate ($i)
		//End for 
		//uThermoClose 
		
		$text:=Request:C163("Set"+psg_assignments+"'s Priorities, ignoring below: "; "10"; "Extend"; "Cancel")
		If (OK=1)
			$fence:=Num:C11($text)
			If ($fence>0)
				$increment:=10
				READ WRITE:C146([Job_Forms_Items:44])
				$numElements:=Size of array:C274(aGlueListBox)
				uThermoInit($numElements; "Processing Array")
				For ($i; 1; $numElements)
					If (Not:C34(abHidden{$i}))
						
						$save:=False:C215
						Case of 
							: (aPrior{$i}=0)
								aPrior{$i}:=$increment
								$increment:=$increment+10
								$save:=True:C214
								
							: (aPrior{$i}<0)  //lifted
								//do nothing
							: (aPrior{$i}<$fence)  //manually prioritize
								//do nothing
							: (aPrior{$i}=999)  //hold
								//do nothing
							Else 
								aPrior{$i}:=$increment
								$increment:=$increment+10
								$save:=True:C214
						End case 
						
						If ($save)
							GOTO RECORD:C242([Job_Forms_Items:44]; aRecNum{$i})
							If (fLockNLoad(->[Job_Forms_Items:44]))
								[Job_Forms_Items:44]Priority:48:=aPrior{$i}
								SAVE RECORD:C53([Job_Forms_Items:44])
							Else 
								uConfirm("Changes were not saved for item "+aJobit{$i}+", try again later."; "OK"; "Help")
								aPrior{$i}:=[Job_Forms_Items:44]Priority:48
							End if 
							If (Not:C34(<>modification4D_25_03_19))  // BEGIN 4D Professional Services : UNLOAD RECORD
								
								UNLOAD RECORD:C212([Job_Forms_Items:44])
								
							Else 
								
								// you have goto record
								
							End if   // END 4D Professional Services : January 2019 
							
						End if 
						
					Else   //its hidden, does old priority need stripped
						$ccID:=Num:C11(psg_assignments)
						$rowID:=Num:C11(aGluer{$i})
						If ($rowID=$ccID)
							aPrior{$i}:=0
							GOTO RECORD:C242([Job_Forms_Items:44]; aRecNum{$i})
							If (fLockNLoad(->[Job_Forms_Items:44]))
								[Job_Forms_Items:44]Priority:48:=aPrior{$i}
								SAVE RECORD:C53([Job_Forms_Items:44])
							Else 
								uConfirm("Changes were not saved for item "+aJobit{$i}+", try again later."; "OK"; "Help")
								aPrior{$i}:=[Job_Forms_Items:44]Priority:48
							End if 
							If (Not:C34(<>modification4D_25_03_19))  // BEGIN 4D Professional Services : UNLOAD RECORD
								
								UNLOAD RECORD:C212([Job_Forms_Items:44])
								
								
							Else 
								
								// you have goto record
								
							End if   // END 4D Professional Services : January 2019 
						End if 
					End if   //not hidden
					uThermoUpdate($i)
				End for 
				uThermoClose
				UNLOAD RECORD:C212([Job_Forms_Items:44])
				READ ONLY:C145([Job_Forms_Items:44])
				$rtn_int:=PSG_LocalArray("sort"; 8)  //priority
				
			Else 
				uConfirm("You must specify an 'ignore' priority greater than zero (0)."; "OK"; "Help")
			End if 
			
		End if 
		
	: ($msg="load")
		
		For ($i; 1; Size of array:C274(aGlueListBox))
			//Set base row color based on customer
			$hit:=Find in array:C230(aCustColor; aCustID{$i})
			If ($hit>-1)
				axlRowBkgd{$i}:=aCustColorValue{$hit}
			Else 
				axlRowBkgd{$i}:=0x00FFFFF0  //ivory
			End if 
			
			If (aReleased{$i}<Current date:C33)
				//aRowStyle{$i}:=Bold
				axlRowColor{$i}:=0x00FF0000  //lghtred= 0x00880000
			End if 
			
			If (aLaunch{$i})
				aRowStyle{$i}:=Bold:K14:2
				//axlRowColor{$i}:=0x00FF00FF
			End if 
			
			
			If (aPrinted{$i}="Yes")
				apPrinted{$i}:=pGreenPic
			Else 
				apPrinted{$i}:=pRedPic
			End if 
			
			If (aDieCut{$i}="Yes")
				apDieCut{$i}:=pGreenPic
			Else 
				apDieCut{$i}:=pRedPic
			End if 
			
			If (aProgressStatus{$i}="WIP")
				apProgressStatus{$i}:=pGreenPic
			Else 
				apProgressStatus{$i}:=pRedPic
			End if 
			
		End for 
		
	: ($msg="store")
		
		
	: ($msg="find")
		Case of 
			: ($3="test")
				$0:=Find in array:C230(aGlueListBox; $2)
			Else 
				$0:=No current record:K29:2
		End case 
		
End case 
