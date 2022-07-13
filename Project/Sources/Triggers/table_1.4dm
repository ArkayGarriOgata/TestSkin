//don't sync this table
// -------
// Method: Trigger on [zz_control]   ( ) ->
// By: Mel Bohince @ 03/22/19, 15:23:07
// Description
// 
// ----------------------------------------------------

//don't sync this table
// ----------------------------------------------------

C_LONGINT:C283($0)

$0:=0  //assume granted

Case of 
		
	: (Trigger event:C369=On Saving Existing Record Event:K3:2)
		<>modification4D_10_05_19:=[zz_control:1]_ShowBOLwPrintBillBtn:2
		//<>modification4D_14_01_19:=[zz_control]_4DProfessionalServices_Step_1  // added by: Mel Bohince (1/24/19) set this in user enviroment
		//<>modification4D_06_02_19:=[zz_control]_4DProfessionalServices_Step_2
		//<>modification4D_13_02_19:=[zz_control]_4DProfessionalServices_Step_3
		//<>modification4D_28_02_19:=[zz_control]_4DProfessionalServices_Step_4
		//<>modification4D_25_03_19:=[zz_control]_4DProfessionalServices_Step_5
End case 