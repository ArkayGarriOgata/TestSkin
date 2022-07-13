//%attributes = {}

// ----------------------------------------------------
// User name (OS): Philip Keth
// Date and time: 12/07/15, 11:02:36
// ----------------------------------------------------
// Method: UPDATE_DO
// Description
// 
//
// Parameters
// ----------------------------------------------------


C_TEXT:C284($t1Proc)
C_BOOLEAN:C305($f)
//ttUpdate:="Updating the program to Version "+String(<>kxiVersRes/100;"#0.0.0")+"…"
<>ttReport:=""
$f:=MULOADREC(->[zz_control:1])




//v4.9.7-PJK (8/7/14) rewritten to use the new component method
Case of 
	: (Records in selection:C76([zz_control:1])=0)  // Modified by: Mel Bohince (4/9/18) so new data file can be created
		////break
		
		//: (Not(STD_NeedsUpdate ([zz_control]UpdateVersion)))  //v1.0.0-PJK  if we are NOT moving to a new version, stop
		
		//: (Not(STD_AutoUpdate (->[zz_control]UpdateVersion)))  // if the update to a new version failed, we MUST quit
		//SAVE RECORD([zz_control])
		//ALERT("Update failed, contact your database administrator immediately!")
		//QUIT 4D
		
	Else   // the update was a success
		// perform any additional update code custom for this database
		SAVE RECORD:C53([zz_control:1])
		
		//READ ONLY([zz_control])
		//UNLOAD RECORD([zz_control])  //put to read only status
		//LOAD RECORD([zz_control])
		
		
		
End case 
//GetDatafileVersion (-><>kt2Version;-><>kxiVersData)

