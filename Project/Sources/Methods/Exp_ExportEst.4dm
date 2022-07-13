//%attributes = {"publishedWeb":true}
// Method: Exp_ExportEst
//x_ExportEst([ESTIMATE]EstimateNo)         see also Imp_ImportEstOb, gEstDel, doPu
//•081195  MLB  added filePack
//12/29/94 limit to 1 estimate, but export entire data structure of that estimate
//[ESTIMATE]   _01
//        < >>[Est_Ship_tos]    _02
//        < >>[EST_PSPECS]    _03
//                        < >  [PROCESS_SPEC]  _06
//                                       < >> [Material_PSpec]  _08
//                                       < >> [Operation_Seqs]  _09
//        < >>[CARTON_SPEC] _04
//        < >>[CaseScenario]   _05
//                        <  >>[PROCESS_SPEC]  _07
//                                       < >> [FormCartons]      _10
//                                       < >> [Machine_Est]       _11
//                                       < >> [Material_Est]      _12
//        < > [CUSTOMER]         _13
//        < > [Addresses]          _14 
//•062895  MLB  UPR 1507 add the next three exports
//        < >>[PREP_SPEC]        _15
//        < >>[Est_SubForms]    _16
//        < >>[ReproKits]          _17

//$1 estimate number to export


C_LONGINT:C283($i; $err)
C_TEXT:C284($1)
C_TEXT:C284($est; $volume)

MESSAGES OFF:C175

READ ONLY:C145([Estimates_PSpecs:57])
READ ONLY:C145([Process_Specs:18])
READ ONLY:C145([Process_Specs_Materials:56])
READ ONLY:C145([Process_Specs_Machines:28])
READ ONLY:C145([Estimates_Carton_Specs:19])
READ ONLY:C145([Estimates_Differentials:38])
READ ONLY:C145([Process_Specs:18])
READ ONLY:C145([Estimates_FormCartons:48])
READ ONLY:C145([Estimates_Machines:20])
READ ONLY:C145([Estimates_Materials:29])
READ ONLY:C145([Customers:16])
READ ONLY:C145([Addresses:30])

$Est:=$1
$volume:=uCreateFolder("Exported_Estimates")

QUERY:C277([Estimates:17]; [Estimates:17]EstimateNo:1=$est)
Case of 
	: (Records in selection:C76([Estimates:17])=1)
		$estFolder:=uCreateFolder("Exported_Estimates:"+$Est)
		$est:=$estFolder+$est
		NewWindow(180; 250; 3; -722; "Exporting")
		MESSAGE:C88(Char:C90(13)+"Exporting to "+$est+":")
		MESSAGE:C88(Char:C90(13)+"Estimate")
		MESSAGE:C88("    "+String:C10(Records in selection:C76([Estimates:17])))
		SET CHANNEL:C77(10; ($est+"_01"))
		SEND RECORD:C78([Estimates:17])
		SET CHANNEL:C77(11)
		
		RELATE ONE:C42([Estimates:17]Cust_ID:2)
		MESSAGE:C88(Char:C90(13)+"Customer")
		MESSAGE:C88("    "+String:C10(Records in selection:C76([Customers:16])))
		SET CHANNEL:C77(10; ($est+"_13"))
		SEND RECORD:C78([Customers:16])
		SET CHANNEL:C77(11)
		
		QUERY:C277([Addresses:30]; [Addresses:30]ID:1=[Estimates:17]z_Bill_To_ID:5)
		MESSAGE:C88(Char:C90(13)+"'Bill to' Address")
		MESSAGE:C88("    "+String:C10(Records in selection:C76([Addresses:30])))
		SET CHANNEL:C77(10; ($est+"_14"))
		SEND RECORD:C78([Addresses:30])
		SET CHANNEL:C77(11)
		
		QryPurgeEstprts
		
		MESSAGE:C88(Char:C90(13)+"link pspec")
		MESSAGE:C88("    "+String:C10(Records in selection:C76([Estimates_PSpecs:57])))
		SET CHANNEL:C77(10; ($est+"_03"))
		FIRST RECORD:C50([Estimates_PSpecs:57])
		While (Not:C34(End selection:C36([Estimates_PSpecs:57])))
			SEND RECORD:C78([Estimates_PSpecs:57])
			NEXT RECORD:C51([Estimates_PSpecs:57])
		End while 
		SET CHANNEL:C77(11)
		
		MESSAGE:C88(Char:C90(13)+"cspec")
		MESSAGE:C88("    "+String:C10(Records in selection:C76([Estimates_Carton_Specs:19])))
		SET CHANNEL:C77(10; ($est+"_04"))
		FIRST RECORD:C50([Estimates_Carton_Specs:19])
		While (Not:C34(End selection:C36([Estimates_Carton_Specs:19])))
			SEND RECORD:C78([Estimates_Carton_Specs:19])
			NEXT RECORD:C51([Estimates_Carton_Specs:19])
		End while 
		SET CHANNEL:C77(11)
		
		MESSAGE:C88(Char:C90(13)+"diffs")
		MESSAGE:C88("    "+String:C10(Records in selection:C76([Estimates_Differentials:38])))
		SET CHANNEL:C77(10; ($est+"_05"))
		FIRST RECORD:C50([Estimates_Differentials:38])
		While (Not:C34(End selection:C36([Estimates_Differentials:38])))
			SEND RECORD:C78([Estimates_Differentials:38])
			NEXT RECORD:C51([Estimates_Differentials:38])
		End while 
		SET CHANNEL:C77(11)
		
		MESSAGE:C88(Char:C90(13)+"pspec")
		SET CHANNEL:C77(10; ($est+"_06"))
		ARRAY TEXT:C222($pspecs; 0)
		If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) CREATE EMPTY SET
			
			DISTINCT VALUES:C339([Estimates_PSpecs:57]ProcessSpec:2; $pspecs)
			CREATE EMPTY SET:C140([Process_Specs:18]; "thePspecs")
			MESSAGE:C88("    "+String:C10(Size of array:C274($pspecs)))
			For ($i; 1; Size of array:C274($pspecs))
				QUERY:C277([Process_Specs:18]; [Process_Specs:18]ID:1=$pspecs{$i})
				SEND RECORD:C78([Process_Specs:18])
				ADD TO SET:C119([Process_Specs:18]; "thePspecs")
			End for 
			
			
		Else 
			
			RELATE ONE SELECTION:C349([Estimates_PSpecs:57]; [Process_Specs:18])
			CREATE SET:C116([Process_Specs:18]; "thePspecs")
			$n:=Records in selection:C76([Process_Specs:18])
			MESSAGE:C88("    "+String:C10($n))
			
			For ($i; 1; $n; 1)
				SEND RECORD:C78([Process_Specs:18])
				NEXT RECORD:C51([Process_Specs:18])
			End for 
			
			
		End if   // END 4D Professional Services : January 2019 
		
		SET CHANNEL:C77(11)
		
		MESSAGE:C88(Char:C90(13)+"forms")
		SET CHANNEL:C77(10; ($est+"_07"))
		//PROJECT SELECTION([CaseForm]Case)
		MESSAGE:C88("    "+String:C10(Records in selection:C76([Estimates_DifferentialsForms:47])))
		FIRST RECORD:C50([Estimates_DifferentialsForms:47])
		While (Not:C34(End selection:C36([Estimates_DifferentialsForms:47])))
			SEND RECORD:C78([Estimates_DifferentialsForms:47])
			NEXT RECORD:C51([Estimates_DifferentialsForms:47])
		End while 
		SET CHANNEL:C77(11)
		
		MESSAGE:C88(Char:C90(13)+"mat'l pspec")
		SET CHANNEL:C77(10; ($est+"_08"))
		USE SET:C118("thePspecs")
		If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
			
			uRelateSelect(->[Process_Specs_Materials:56]ProcessSpec:1; ->[Process_Specs:18]ID:1; 0)
			
			
		Else 
			
			RELATE MANY SELECTION:C340([Process_Specs_Materials:56]ProcessSpec:1)
			
		End if   // END 4D Professional Services : January 2019 query selection
		If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 First record
			
			MESSAGE:C88("    "+String:C10(Records in selection:C76([Process_Specs_Materials:56])))
			FIRST RECORD:C50([Process_Specs_Materials:56])
			
		Else 
			
			MESSAGE:C88("    "+String:C10(Records in selection:C76([Process_Specs_Materials:56])))
			//see line 142
			
		End if   // END 4D Professional Services : January 2019 First record
		// 4D Professional Services : after Order by , query or any query type you don't need First record  
		
		While (Not:C34(End selection:C36([Process_Specs_Materials:56])))
			SEND RECORD:C78([Process_Specs_Materials:56])
			NEXT RECORD:C51([Process_Specs_Materials:56])
		End while 
		SET CHANNEL:C77(11)
		
		MESSAGE:C88(Char:C90(13)+"mach pspecs")
		SET CHANNEL:C77(10; ($est+"_09"))
		If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
			
			uRelateSelect(->[Process_Specs_Machines:28]ProcessSpec:1; ->[Process_Specs:18]ID:1; 0)
			
			
		Else 
			
			RELATE MANY SELECTION:C340([Process_Specs_Machines:28]ProcessSpec:1)
			
			
		End if   // END 4D Professional Services : January 2019 query selection
		If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 First record
			
			MESSAGE:C88("    "+String:C10(Records in selection:C76([Process_Specs_Machines:28])))
			FIRST RECORD:C50([Process_Specs_Machines:28])
			
			
		Else 
			
			MESSAGE:C88("    "+String:C10(Records in selection:C76([Process_Specs_Machines:28])))
			// see line 173
			
			
		End if   // END 4D Professional Services : January 2019 First record
		// 4D Professional Services : after Order by , query or any query type you don't need First record  
		While (Not:C34(End selection:C36([Process_Specs_Machines:28])))
			SEND RECORD:C78([Process_Specs_Machines:28])
			NEXT RECORD:C51([Process_Specs_Machines:28])
		End while 
		SET CHANNEL:C77(11)
		CLEAR SET:C117("thePspecs")
		
		MESSAGE:C88(Char:C90(13)+"form's cartons")
		SET CHANNEL:C77(10; ($est+"_10"))
		//PROJECT SELECTION([FormCartons]Form)
		MESSAGE:C88("    "+String:C10(Records in selection:C76([Estimates_FormCartons:48])))
		FIRST RECORD:C50([Estimates_FormCartons:48])
		While (Not:C34(End selection:C36([Estimates_FormCartons:48])))
			SEND RECORD:C78([Estimates_FormCartons:48])
			NEXT RECORD:C51([Estimates_FormCartons:48])
		End while 
		SET CHANNEL:C77(11)
		
		MESSAGE:C88(Char:C90(13)+"form's machines")
		SET CHANNEL:C77(10; ($est+"_11"))
		//PROJECT SELECTION([Machine_Est]CaseFormID)
		MESSAGE:C88("    "+String:C10(Records in selection:C76([Estimates_Machines:20])))
		FIRST RECORD:C50([Estimates_Machines:20])
		While (Not:C34(End selection:C36([Estimates_Machines:20])))
			SEND RECORD:C78([Estimates_Machines:20])
			NEXT RECORD:C51([Estimates_Machines:20])
		End while 
		SET CHANNEL:C77(11)
		
		MESSAGE:C88(Char:C90(13)+"form's materials")
		SET CHANNEL:C77(10; ($est+"_12"))
		//PROJECT SELECTION([Material_Est]CaseFormID)
		MESSAGE:C88("    "+String:C10(Records in selection:C76([Estimates_Materials:29])))
		FIRST RECORD:C50([Estimates_Materials:29])
		While (Not:C34(End selection:C36([Estimates_Materials:29])))
			SEND RECORD:C78([Estimates_Materials:29])
			NEXT RECORD:C51([Estimates_Materials:29])
		End while 
		SET CHANNEL:C77(11)
		
		CLOSE WINDOW:C154
		
	: (Records in selection:C76([Estimates:17])>1)
		BEEP:C151
		ALERT:C41("You may only export one estimate at a time.")
		
	Else 
		BEEP:C151
		ALERT:C41($est+" was not found.")
End case 

MESSAGES ON:C181