//%attributes = {"publishedWeb":true}
//PM:  RM_doesExist  110999  mlb
//formerly  `(s) sValidateRm
//validates Rm code selection, allows creation under some conditions
//called from [material_psepc]incl,[material_pspec]input, [material_est]caseformin
//  [material_est]input,[materialjob]input (rawmat field)
//$1 - pointer - to RM Code
//$2 - string - commodity key
//$3 - string - anything, flag this call from an input layout
//• 1/27/98  cs created
//• 5/20/98 cs insure that RM code has no spaces leading or trailing
//•110999  mlb  add return value
//mlb 04/14/11 don't allow use of obsolete rm's
// Modified by: Mel Bohince (1/20/21) remove 4D-PS code that caused error

C_POINTER:C301($1)
C_TEXT:C284($2)
C_TEXT:C284($3)
C_BOOLEAN:C305($0)  //•110999  mlb  UPR 

If (Not:C34(Read only state:C362([Raw_Materials:21])))
	READ ONLY:C145([Raw_Materials:21])  //avoid locking RM recorrd.
End if 
$1->:=fStripSpace("B"; Substring:C12($1->; 1; 20))  //• 5/20/98 cs insure that RM code has no spaces leading or trailing
QUERY:C277([Raw_Materials:21]; [Raw_Materials:21]Raw_Matl_Code:1=$1->)  //locate raw material entered

Case of 
	: (Records in selection:C76([Raw_Materials:21])>=1)  //added 04/14/11
		If ([Raw_Materials:21]Status:25="Obsolete")  //should be Active or PhaseOut
			If (Length:C16([Raw_Materials:21]Successor:34)>0)
				uConfirm([Raw_Materials:21]Raw_Matl_Code:1+" is Obsolete."+Char:C90(13)+"It has been replace with "+[Raw_Materials:21]Successor:34; "OK"; "Help")
				$1->:=[Raw_Materials:21]Successor:34
			Else 
				uConfirm("The Raw Material Code you have entered is Obsolete."+Char:C90(13)+"If you need to use it, contact Dan Mayrosh."; "OK"; "Help")
				$1->:=""
			End if 
			
		End if 
		
	: (Records in selection:C76([Raw_Materials:21])=0)
		Case of 
			: ($2="02@")  //allow (for INKs ONLY) ability to create RM shell
				uConfirm("The Raw Material Code you have entered does not exist in AMS."+Char:C90(13)+"If the Ink Formula you entered ("+$1->+") is correct, Do you want to create it?"; "Create"; "Retry")
				If (OK=1)  //user confirmed entry of incorrect ink formula
					RMShellCreate($1->; $2)
				Else 
					$1->:=""
				End if 
				
			: ($2="03@")  //allow (for INKs ONLY) ability to create RM shell
				uConfirm("The Raw Material Code you have entered does not exist in AMS."+Char:C90(13)+"If the Coating Formula you entered ("+$1->+") is correct, Do you want to create it?"; "Create"; "Retry")
				If (OK=1)  //user confirmed entry of incorrect ink formula
					RMShellCreate($1->; $2)
				Else 
					$1->:=""
				End if 
				
			: ($2="33@")  //looking for f/g sub-component
				<>USE_SUBCOMPONENT:=True:C214
				READ ONLY:C145([Finished_Goods:26])
				$numFG:=qryFinishedGood("#CPN"; $1->)
				If ($numFG=0)  // Modified by: Mel Bohince (1/20/21) remove 4D-PS code that caused error
					uConfirm($1->+" is not a valid fg Product Code for a subcomponent."; "OK"; "Help")
					$1->:=""
				End if 
				
			: (Count parameters:C259=3)  //if not found, stop entry
				uConfirm("The Raw Material Code Entered in NOT valid."+Char:C90(13)+"Please Enter a valid RM Code."+Char:C90(13)+"Click the 'Pick' button for a list of valid Rm Codes."; "OK"; "Help")
				$1->:=""
				
			Else   //if not found, stop entry
				uConfirm("The Raw Material Code Entered in NOT valid."+Char:C90(13)+"Please Enter a valid RM Code."+Char:C90(13)+"Click the 'Pick' button for a list of valid Rm Codes."; "OK"; "Help")
				$1->:=""
		End case 
End case 

$0:=($1->#"")
UNLOAD RECORD:C212([Raw_Materials:21])