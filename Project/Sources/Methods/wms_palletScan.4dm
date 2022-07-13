//%attributes = {}
// Method: wms_palletScan () -> 
// ----------------------------------------------------
// by: mel: 01/17/05, 13:34:53
// ----------------------------------------------------
// Description:
// method to scan all the cases on a skid checking for lot uniformity
//printing a pallet label at end
// Updates:

// ----------------------------------------------------
C_TEXT:C284($1)
C_LONGINT:C283($errCode)
C_BOOLEAN:C305($quit)
$quit:=False:C215  //done -- exit this method
C_TEXT:C284($event)  // main event loop is Prompt, Read, Process, or Quit

If (Count parameters:C259=0)
	$pid:=New process:C317("wms_palletScan"; <>lMinMemPart; "wms_palletScan"; "init")
	If (False:C215)
		wms_palletScan
	End if 
	
Else 
	
	If (HHP_Connect=0)
		
		//set initial state
		$event:="Prompt"
		hpp_prompt:="Scan First Case"
		$currentLot:=""
		$cursor:=0
		$soFar:=""
		Repeat 
			MESSAGE:C88("::"+$event+" "+hpp_prompt+Char:C90(13))
			//determine next action based on the event posted
			Case of 
				: ($event="Prompt")  //send prompt
					$errCode:=HPP_Send("prompt"; hpp_prompt)
					If ($errCode=0)
						$event:="Read"
					Else 
						hpp_errorSource:="While trying to send a "+hpp_prompt+" PROMPT to the scanner."
						$event:="Process"
					End if 
					
				: ($event="Read")
					hpp_value:=""
					$lot:=""
					$case:=""
					$qty:=0
					$errCode:=HPP_Send("get"; "")  //wait for answer, sets hpp_value
					If ($errCode=0)
						Case of 
							: (Length:C16(hpp_value)=0)
								hpp_errorSource:="Received no error or data when trying to read the scanner."
								$errCode:=-20005
								
							: (Length:C16(hpp_value)>19)  //treat as scanned case
								If (Position:C15(hpp_value; $soFar)=0)
									$soFar:=$soFar+hpp_value
									$lot:=WMS_CaseId(hpp_value; "jobit")
									$case:=WMS_CaseId(hpp_value; "serial")
									$qty:=Num:C11(WMS_CaseId(hpp_value; "qty"))
								Else 
									$errCode:=HPP_Send("beep")
									$errCode:=HPP_Send("beep")
									$errCode:=HPP_Send("bad")
									hpp_prompt:="Double Scan, go to next case"
									
									$event:="Prompt"
								End if 
								
							Else 
								//event issued to this host method
						End case 
						
					Else 
						hpp_errorSource:="While trying to read the scanner."
					End if 
					$event:="Process"
					
				: ($event="Process")
					
					Case of 
						: ($errCode#0)
							HPP_ErrorMsg(hpp_errorCode)
							$event:=Request:C163("What should happen now?"; "Quit")
							hpp_value:="ERROR"
							
						: (hpp_value="Quit")
							$event:="Quit"  //call for exit to outside loop
							
						: (hpp_value="PalletDone")
							$errCode:=HPP_Send("beep")
							$errCode:=HPP_Send("beep")
							$errCode:=HPP_Send("beep")
							$errCode:=HPP_Send("good")
							//store pallet composition
							//$palletID:="1"  `getNextPalletID
							//ARRAY TEXT(aPallet;$cursor)
							//For ($i;1;$cursor)
							//aPallet{$i}:=$palletID
							//End for 
							//REDUCE SELECTION([WMS_Composition];0)
							//ARRAY TO SELECTION(aPallet;[WMS_Composition]Container;aCase;[WMS_Composition]Content)
							//REDUCE SELECTION([WMS_Composition];0)
							
							ALERT:C41($currentLot+Char:C90(13)+"num Cases:  "+String:C10($caseCount)+Char:C90(13)+"quantity: "+String:C10($palletQty)+Char:C90(13)+"last case: "+$case+Char:C90(13))
							//print pallet label
							
							//set initial state
							$event:="Prompt"
							hpp_prompt:="Scan First Case"  //scan case 1 of 18
							$currentLot:=""
							$cursor:=0
							$soFar:=""
							//ARRAY TEXT(aPallet;0)  `set up for an Array to Selection
							//ARRAY TEXT(aCase;0)
							
						: (Length:C16($currentLot)=0)
							$currentLot:=$lot
							$palletQty:=$qty
							$caseCount:=1
							$cursor:=$cursor+1
							//get expect number of cases
							
							//aCase{$cursor}:=$case
							//create itemmaster record
							
							$errCode:=HPP_Send("beep")
							$errCode:=HPP_Send("good")
							hpp_prompt:="Scan Next Case"
							$event:="Prompt"
							
						: (Length:C16($lot)=0)
							$errCode:=HPP_Send("beep")
							$errCode:=HPP_Send("beep")
							$errCode:=HPP_Send("bad")
							hpp_prompt:="ReScan Same Case or quit"
							$event:="Prompt"
							
						: ($lot=$currentLot)
							$palletQty:=$palletQty+$qty
							$caseCount:=$caseCount+1
							//create itemmaster record
							
							$errCode:=HPP_Send("beep")
							$errCode:=HPP_Send("good")
							hpp_prompt:="Scan Next Case"
							$event:="Prompt"
							
						: ($lot#$currentLot)
							$errCode:=HPP_Send("beep")
							$errCode:=HPP_Send("beep")
							$errCode:=HPP_Send("bad")
							hpp_prompt:="Remove case "+$case
							$event:="Prompt"
							
						Else 
							hpp_prompt:=hpp_prompt+" again!"
							$event:="Prompt"
					End case 
					
				: ($event="Quit")
					$quit:=True:C214
					
					
			End case 
			
		Until ($quit)
		MESSAGE:C88("=====QUIT"+"Pallet scan ended with "+hpp_value)
		HPP_ErrorMsg(hpp_errorCode)
		
	Else 
		HPP_ErrorMsg(hpp_errorCode)
	End if 
	
	HHP_Connect("finished")
	
End if   //init