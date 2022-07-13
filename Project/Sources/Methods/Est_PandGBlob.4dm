//%attributes = {}
// ----------------------------------------------------
// User name (OS): Mark Zinke
// Date and time: 04/18/13, 09:36:52
// ----------------------------------------------------
// Method: Est_PandGBlob
// ----------------------------------------------------

C_TEXT:C284($tDoWhat; $1)
C_LONGINT:C283($xlOffset)

$tDoWhat:=$1
$xlOffset:=0

Case of 
	: ($tDoWhat="Fill")
		DELETE FROM BLOB:C560([Job_Forms:42]PandGProblems:83; 0; 10000)
		
		VARIABLE TO BLOB:C532(atProdCodes; [Job_Forms:42]PandGProblems:83; *)
		VARIABLE TO BLOB:C532(axlAmount; [Job_Forms:42]PandGProblems:83; *)
		VARIABLE TO BLOB:C532(axlMax; [Job_Forms:42]PandGProblems:83; *)
		VARIABLE TO BLOB:C532(axlMin; [Job_Forms:42]PandGProblems:83; *)
		VARIABLE TO BLOB:C532(axlThisWant; [Job_Forms:42]PandGProblems:83; *)
		VARIABLE TO BLOB:C532(axlSupply; [Job_Forms:42]PandGProblems:83; *)
		VARIABLE TO BLOB:C532(axlDemand; [Job_Forms:42]PandGProblems:83; *)
		
	: ($tDoWhat="Read")
		BLOB TO VARIABLE:C533([Job_Forms:42]PandGProblems:83; atProdCodes; $xlOffset)
		BLOB TO VARIABLE:C533([Job_Forms:42]PandGProblems:83; axlAmount; $xlOffset)
		BLOB TO VARIABLE:C533([Job_Forms:42]PandGProblems:83; axlMax; $xlOffset)
		BLOB TO VARIABLE:C533([Job_Forms:42]PandGProblems:83; axlMin; $xlOffset)
		BLOB TO VARIABLE:C533([Job_Forms:42]PandGProblems:83; axlThisWant; $xlOffset)
		BLOB TO VARIABLE:C533([Job_Forms:42]PandGProblems:83; axlSupply; $xlOffset)
		BLOB TO VARIABLE:C533([Job_Forms:42]PandGProblems:83; axlDemand; $xlOffset)
		
	: ($tDoWhat="Clear")
		SET BLOB SIZE:C606([Job_Forms:42]PandGProblems:83; 0)
		
End case 