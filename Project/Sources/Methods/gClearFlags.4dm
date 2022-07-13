//%attributes = {"publishedWeb":true}
//(P) gClearFlags: clears all flags when user returns to splash

fChoose:=False:C215  //used by uLookup to indicate choice in progress
fMod:=False:C215  //used by mod routines to indicate Mod in progress
fRev:=False:C215  //used by rev routines to indicate Rev in progress
fDel:=False:C215  //used by del routines to indicate Del in progress
fUserMaint:=False:C215  //indicates Resp record update in progress
fWindCancel:=False:C215  //indicates user cancel window
fWindClose:=False:C215  //indicates user clo se& save window
fAdHocLocal:=True:C214  //indicates adhocs to process locally
fChg:=True:C214