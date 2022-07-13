//%attributes = {"publishedWeb":true}
//Batch_RM_Allocations mlb 031501
// Modified by: MelvinBohince (2/25/22) 

//If (False)  //original way
// OBSOLETE OBSOLETE OBSOLETEModified by: MelvinBohince (3/28/22) OBSOLETE date now set by batched RM_AllocationSetDate_eos called by Batch_RM_Allocations
//RM_AllocationCleanup 
//RM_AllocationMakeIfNeed 
//RM_AllocationSetToPressDate 

//Else   // Modified by: MelvinBohince (2/25/22) 
RM_AllocationCleanup2  //remove the dead wood

RM_AllocateBoard_eos

RM_AllocateColdFoil_eos

RM_AllocateSensors_eos

RM_AllocationSetDate_eos  //get best date for each commodity


//End if 
