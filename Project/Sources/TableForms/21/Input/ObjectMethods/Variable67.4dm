//12/6/94 test for records before calc
CUT NAMED SELECTION:C334([Raw_Materials_Allocations:58]; "hold")  //•031897  MLB  
If (Not:C34(RM_AllocationCalc([Raw_Materials:21]Raw_Matl_Code:1)))
	BEEP:C151
End if 
USE NAMED SELECTION:C332("hold")
//