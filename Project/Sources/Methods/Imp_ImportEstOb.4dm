//%attributes = {"publishedWeb":true}
// Method: Imp_ImportEstOb

//• 8/11/97 cs  keep this one
//x_ImportEst  see also x_ExportEst, gEstDel, doPurgeEstimate
//see also uImpEstFolders
//12/29/94
//5/2/95
//•062895  MLB  UPR 1507
//•081195  MLB  added FilePack
//•120695  MLB  UPR 234 chg method of primary keying CartonSpec records
//• 4/17/98 cs fixed reference to $1 - no parameter to this procedure
// Modified by: Mel Bohince (2/17/16) add pk_id:=Generate UUID so no dup key errors

C_TEXT:C284($newEst; $oldEst)
C_TEXT:C284($custId)
C_TEXT:C284($est)  //•081195  MLB  
C_TEXT:C284($EstPath)
C_LONGINT:C283($err)

READ WRITE:C146([Estimates:17])
READ WRITE:C146([Estimates_PSpecs:57])
READ WRITE:C146([Process_Specs:18])
READ WRITE:C146([Process_Specs_Materials:56])
READ WRITE:C146([Process_Specs_Machines:28])
READ WRITE:C146([Estimates_Carton_Specs:19])
READ WRITE:C146([Estimates_Differentials:38])
READ WRITE:C146([Process_Specs:18])
READ WRITE:C146([Estimates_FormCartons:48])
READ WRITE:C146([Estimates_Machines:20])
READ WRITE:C146([Estimates_Materials:29])
READ WRITE:C146([Customers:16])
READ WRITE:C146([Addresses:30])

CUT NAMED SELECTION:C334([Estimates:17]; "beforeImport")
$err:=0
$EstPath:=Select folder:C670("'Select the Estimate's folder")
If ($EstPath#"")  //Mel's HD:5-1234.12:
	$oldEst:=Substring:C12(HFSShortName($EstPath); 1; 9)  //5-1234.12
	ARRAY TEXT:C222(aMembers; 0)
	$err:=HFSCatToArray2($EstPath; ->aMembers)
	If ($err#0)
		BEEP:C151
		ALERT:C41("Error while looking for estimate members.")
	Else 
		If (Size of array:C274(aMembers)#13)
			BEEP:C151
			ALERT:C41("Some members of estimate "+$est+" are missing.")
			$err:=-1
		Else 
			$est:=$EstPath+$oldEst  //Mel's HD:5-1234.12:5-1234.12
		End if 
		
	End if 
	//$est:=Request("Import which estimate:";"0-0000.00")
	//If (ok=1)
	
	If (Length:C16($oldEst)=9) & ($err=0)
		QUERY:C277([Estimates:17]; [Estimates:17]EstimateNo:1=$oldEst)
		If (Records in selection:C76([Estimates:17])=1)
			uConfirm("Create New estimate or Overlay "+$oldEst; "New"; "Overlay")
			If (OK=1)  //create new
				fileNum:=Table:C252(->[Estimates:17])
				$newEst:=EstOffsetAdjust  //String(Year of(4D_Current_date)-1990)+"-"+String((Se444quence number([ESTIMATE])+◊aOffSet{Table(->[ESTIMATE])});"0000")+".00"
				BEEP:C151
				uConfirm($oldEst+" will be renamed to "+$newEst; "OK"; "Help")
				
			Else   //overlay
				QryPurgeEstprts
				uPurgeEstDel
				$newEst:=$oldEst
			End if 
			
		Else   //not found
			$newEst:=$oldEst
		End if 
		
		MESSAGE:C88(Char:C90(13)+"Estimate")
		SET CHANNEL:C77(10; ($est+"_01"))
		RECEIVE RECORD:C79([Estimates:17])
		If (OK=1)
			Open window:C153(20; 50; 180; 350; 1; "")
			[Estimates:17]EstimateNo:1:=$newEst
			$custId:=[Estimates:17]Cust_ID:2
			[Estimates:17]pk_id:68:=Generate UUID:C1066
			SAVE RECORD:C53([Estimates:17])
			MESSAGE:C88(Char:C90(13)+"link pspec")
			SET CHANNEL:C77(10; ($est+"_03"))
			RECEIVE RECORD:C79([Estimates_PSpecs:57])
			While (OK=1)
				[Estimates_PSpecs:57]EstimateNo:1:=$newEst
				[Estimates_PSpecs:57]pk_id:6:=Generate UUID:C1066
				SAVE RECORD:C53([Estimates_PSpecs:57])
				RECEIVE RECORD:C79([Estimates_PSpecs:57])
			End while 
			SET CHANNEL:C77(11)
			MESSAGE:C88(Char:C90(13)+"cspec")
			SET CHANNEL:C77(10; ($est+"_04"))
			RECEIVE RECORD:C79([Estimates_Carton_Specs:19])
			$i:=0
			ARRAY TEXT:C222($csk; $i)  //•120695  MLB  UPR 234 chg method of primary keying CartonSpec records
			ARRAY TEXT:C222($Ncsk; $i)  //•120695  MLB  UPR 234 chg method of primary keying CartonSpec records
			While (OK=1)
				[Estimates_Carton_Specs:19]Estimate_No:2:=$newEst
				$i:=$i+1
				ARRAY TEXT:C222($csk; $i)  //•120695  MLB  UPR 234 chg method of primary keying CartonSpec records
				ARRAY TEXT:C222($Ncsk; $i)  //•120695  MLB  UPR 234 chg method of primary keying CartonSpec records
				$csk{$i}:=[Estimates_Carton_Specs:19]CartonSpecKey:7
				//°[CARTON_SPEC]CartonSpecKey:=Sequ444ence number([CARTON_SPEC])+◊aOffSet{19}
				[Estimates_Carton_Specs:19]CartonSpecKey:7:=fCSpecID  //•120695  MLB  UPR 234 chg method of primary keying CartonSpec records
				$Ncsk{$i}:=[Estimates_Carton_Specs:19]CartonSpecKey:7
				[Estimates_Carton_Specs:19]pk_id:78:=Generate UUID:C1066
				SAVE RECORD:C53([Estimates_Carton_Specs:19])
				RECEIVE RECORD:C79([Estimates_Carton_Specs:19])
			End while 
			SET CHANNEL:C77(11)
			
			MESSAGE:C88(Char:C90(13)+"diffs")
			SET CHANNEL:C77(10; ($est+"_05"))
			RECEIVE RECORD:C79([Estimates_Differentials:38])
			While (OK=1)
				[Estimates_Differentials:38]estimateNum:2:=$newEst
				[Estimates_Differentials:38]Id:1:=$newEst+[Estimates_Differentials:38]diffNum:3
				[Estimates_Differentials:38]pk_id:46:=Generate UUID:C1066
				SAVE RECORD:C53([Estimates_Differentials:38])
				RECEIVE RECORD:C79([Estimates_Differentials:38])
			End while 
			SET CHANNEL:C77(11)
			
			ARRAY TEXT:C222($pspecs; 0)
			QUERY:C277([Process_Specs:18]; [Process_Specs:18]Cust_ID:4=$custId)
			SELECTION TO ARRAY:C260([Process_Specs:18]ID:1; $pspecs)
			
			MESSAGE:C88(Char:C90(13)+"mat'l pspec")
			SET CHANNEL:C77(10; ($est+"_08"))
			RECEIVE RECORD:C79([Process_Specs_Materials:56])
			While (OK=1)
				If (Find in array:C230($pspecs; [Process_Specs_Materials:56]ProcessSpec:1)=-1)
					[Process_Specs_Materials:56]pk_id:22:=Generate UUID:C1066
					SAVE RECORD:C53([Process_Specs_Materials:56])
				End if 
				RECEIVE RECORD:C79([Process_Specs_Materials:56])
			End while 
			SET CHANNEL:C77(11)
			
			MESSAGE:C88(Char:C90(13)+"mach pspecs")
			SET CHANNEL:C77(10; ($est+"_09"))
			RECEIVE RECORD:C79([Process_Specs_Machines:28])
			While (OK=1)
				If (Find in array:C230($pspecs; [Process_Specs_Machines:28]ProcessSpec:1)=-1)
					[Process_Specs_Machines:28]pk_id:26:=Generate UUID:C1066
					SAVE RECORD:C53([Process_Specs_Machines:28])
				End if 
				RECEIVE RECORD:C79([Process_Specs_Machines:28])
			End while 
			SET CHANNEL:C77(11)
			
			MESSAGE:C88(Char:C90(13)+"pspec")
			SET CHANNEL:C77(10; ($est+"_06"))
			RECEIVE RECORD:C79([Process_Specs:18])
			While (OK=1)
				If (Find in array:C230($pspecs; [Process_Specs:18]ID:1)=-1)
					[Process_Specs:18]pk_id:109:=Generate UUID:C1066
					SAVE RECORD:C53([Process_Specs:18])
				End if 
				RECEIVE RECORD:C79([Process_Specs:18])
			End while 
			SET CHANNEL:C77(11)
			
			ARRAY TEXT:C222($pspecs; 0)
			
			MESSAGE:C88(Char:C90(13)+"forms")
			SET CHANNEL:C77(10; ($est+"_07"))
			RECEIVE RECORD:C79([Estimates_DifferentialsForms:47])
			While (OK=1)
				[Estimates_DifferentialsForms:47]DiffId:1:=$newEst+Substring:C12([Estimates_DifferentialsForms:47]DiffId:1; 10)
				[Estimates_DifferentialsForms:47]DiffFormId:3:=$newEst+Substring:C12([Estimates_DifferentialsForms:47]DiffFormId:3; 10)
				[Estimates_DifferentialsForms:47]pk_id:37:=Generate UUID:C1066
				SAVE RECORD:C53([Estimates_DifferentialsForms:47])
				RECEIVE RECORD:C79([Estimates_DifferentialsForms:47])
			End while 
			SET CHANNEL:C77(11)
			
			MESSAGE:C88(Char:C90(13)+"form's cartons")
			SET CHANNEL:C77(10; ($est+"_10"))
			RECEIVE RECORD:C79([Estimates_FormCartons:48])
			While (OK=1)
				$i:=Find in array:C230($csk; [Estimates_FormCartons:48]Carton:1)
				
				If ($i>0)  //• 4/17/98 cs fixed reference to $1 - no parameter to this procedure
					[Estimates_FormCartons:48]Carton:1:=$Ncsk{$i}
				Else 
					ALERT:C41("Something is screwed."+Char:C90(13)+"FormCarton CartonSpec key ("+[Estimates_FormCartons:48]Carton:1+") was not found."+Char:C90(13)+"Continuing")
				End if 
				[Estimates_FormCartons:48]DiffFormID:2:=$newEst+Substring:C12([Estimates_FormCartons:48]DiffFormID:2; 10)
				[Estimates_FormCartons:48]pk_id:18:=Generate UUID:C1066
				SAVE RECORD:C53([Estimates_FormCartons:48])
				RECEIVE RECORD:C79([Estimates_FormCartons:48])
			End while 
			SET CHANNEL:C77(11)
			
			MESSAGE:C88(Char:C90(13)+"form's machines")
			SET CHANNEL:C77(10; ($est+"_11"))
			RECEIVE RECORD:C79([Estimates_Machines:20])
			While (OK=1)
				[Estimates_Machines:20]DiffFormID:1:=$newEst+Substring:C12([Estimates_Machines:20]DiffFormID:1; 10)
				[Estimates_Machines:20]EstimateNo:14:=$newEst
				[Estimates_Machines:20]pk_id:48:=Generate UUID:C1066
				SAVE RECORD:C53([Estimates_Machines:20])
				RECEIVE RECORD:C79([Estimates_Machines:20])
			End while 
			SET CHANNEL:C77(11)
			
			MESSAGE:C88(Char:C90(13)+"form's materials")
			SET CHANNEL:C77(10; ($est+"_12"))
			RECEIVE RECORD:C79([Estimates_Materials:29])
			While (OK=1)
				[Estimates_Materials:29]DiffFormID:1:=$newEst+Substring:C12([Estimates_Materials:29]DiffFormID:1; 10)
				[Estimates_Materials:29]EstimateNo:5:=$newEst
				[Estimates_Materials:29]pk_id:33:=Generate UUID:C1066
				SAVE RECORD:C53([Estimates_Materials:29])
				RECEIVE RECORD:C79([Estimates_Materials:29])
			End while 
			SET CHANNEL:C77(11)
			
			RELATE ONE:C42([Estimates:17]Cust_ID:2)
			If (Records in selection:C76([Customers:16])<1)
				MESSAGE:C88(Char:C90(13)+"CUSTOMER")
				SET CHANNEL:C77(10; ($est+"_13"))
				RECEIVE RECORD:C79([Customers:16])
				If (OK=1)
					[Customers:16]pk_id:67:=Generate UUID:C1066
					SAVE RECORD:C53([Customers:16])
				End if 
				SET CHANNEL:C77(11)
			End if 
			
			QUERY:C277([Addresses:30]; [Addresses:30]ID:1=[Estimates:17]z_Bill_To_ID:5)
			If (Records in selection:C76([Addresses:30])<1)
				MESSAGE:C88(Char:C90(13)+"BILL TO")
				SET CHANNEL:C77(10; ($est+"_14"))
				RECEIVE RECORD:C79([Addresses:30])
				If (OK=1)
					[Addresses:30]pk_id:44:=Generate UUID:C1066
					SAVE RECORD:C53([Addresses:30])
				End if 
				SET CHANNEL:C77(11)
			End if 
			
		Else 
			BEEP:C151
			ALERT:C41($oldEst+" is not a valid estimate number.")
		End if 
	End if 
	CLOSE WINDOW:C154
Else 
	BEEP:C151
	ALERT:C41("Estimate folder could not be opened.")
End if 
SET CHANNEL:C77(11)
If (Not:C34(<>modification4D_25_03_19))  // BEGIN 4D Professional Services : UNLOAD RECORD
	
	UNLOAD RECORD:C212([Estimates:17])
	
Else 
	
	// you have query on line [Estimates] 283
	
End if   // END 4D Professional Services : January 2019 

UNLOAD RECORD:C212([Estimates_PSpecs:57])
UNLOAD RECORD:C212([Process_Specs:18])
UNLOAD RECORD:C212([Process_Specs_Materials:56])
UNLOAD RECORD:C212([Process_Specs_Machines:28])
UNLOAD RECORD:C212([Estimates_Carton_Specs:19])
UNLOAD RECORD:C212([Estimates_Differentials:38])
UNLOAD RECORD:C212([Process_Specs:18])
UNLOAD RECORD:C212([Estimates_FormCartons:48])
UNLOAD RECORD:C212([Estimates_Machines:20])
UNLOAD RECORD:C212([Estimates_Materials:29])
UNLOAD RECORD:C212([Customers:16])
UNLOAD RECORD:C212([Addresses:30])

QUERY:C277([Estimates:17]; [Estimates:17]EstimateNo:1=$newEst)
pattern_PassThru(->[Estimates:17])
UNLOAD RECORD:C212([Estimates:17])
USE NAMED SELECTION:C332("beforeImport")
ViewSetter(2; ->[Estimates:17])