//%attributes = {"publishedWeb":true}
//Procedure: uPurgeEstUnify()  062995  MLB
//•062995  MLB  UPR 1507
//•040296  MLB  rewrite to try to fix "line 15" runtime error
//•050196  MLB  above didn't work so comment out at bottom
//•050296  MLB  "blank set didn't fix, comment out Kill set
//• 12/18/97 cs create sets for related tables
//• 12/19/97 cs uncommented two unions
//•063099  mlb  file rename problem
If (Count parameters:C259=0)
	CREATE EMPTY SET:C140([Estimates:17]; "DeleteThese")
	UNION:C120("New"; "RFQ"; "DeleteThese")
	UNION:C120("Estimated"; "DeleteThese"; "DeleteThese")
	UNION:C120("Priced"; "DeleteThese"; "DeleteThese")
	UNION:C120("Quoted"; "DeleteThese"; "DeleteThese")
	UNION:C120("Ordered"; "DeleteThese"; "DeleteThese")
	UNION:C120("Accepted"; "DeleteThese"; "DeleteThese")
	UNION:C120("Budgeting"; "DeleteThese"; "DeleteThese")
	UNION:C120("Budget"; "DeleteThese"; "DeleteThese")
	UNION:C120("Contract"; "DeleteThese"; "DeleteThese")
	UNION:C120("Hold"; "DeleteThese"; "DeleteThese")  //only warn`• 12/19/97 cs uncommented this
	UNION:C120("Kill"; "DeleteThese"; "DeleteThese")  //•050296  MLB  `• 12/19/97 cs uncommented this too
	UNION:C120("Super"; "DeleteThese"; "DeleteThese")  //ADDED 062300
	UNION:C120("blank"; "DeleteThese"; "DeleteThese")
	//create sets for related files for later deletion
	CREATE EMPTY SET:C140([Estimates_Carton_Specs:19]; "CARTON_SPEC")  //• 12/18/97 cs 
	CREATE EMPTY SET:C140([Estimates_Differentials:38]; "Differential")  //•063099  mlb  file rename problem
	CREATE EMPTY SET:C140([Estimates_DifferentialsForms:47]; "DifferentialForm")  //•063099  mlb  file rename problem
	CREATE EMPTY SET:C140([Estimates_Materials:29]; "Material_Est")
	CREATE EMPTY SET:C140([Estimates_Machines:20]; "Machine_Est")
	CREATE EMPTY SET:C140([Estimates_FormCartons:48]; "FormCartons")
	CREATE EMPTY SET:C140([Estimates_PSpecs:57]; "EST_PSPECS")
	CREATE EMPTY SET:C140([Work_Orders:37]; "Est_Ship_tos")
	
	CREATE EMPTY SET:C140([Estimates:17]; "ESTIMATE")
	
Else   //param
	CLEAR SET:C117("New")  //• 3/30/98 cs 
	CLEAR SET:C117("RFQ")
	CLEAR SET:C117("Estimated")
	CLEAR SET:C117("Priced")
	CLEAR SET:C117("Quoted")
	CLEAR SET:C117("Ordered")
	CLEAR SET:C117("Accepted")
	CLEAR SET:C117("Budgeting")
	CLEAR SET:C117("Budget")
	CLEAR SET:C117("Contract")
	CLEAR SET:C117("Hold")
	CLEAR SET:C117("Kill")
	CLEAR SET:C117("blank")
	CLEAR SET:C117("Super")
End if   //parma
//