//bCancelRec
fCancel:=True:C214
fRMMaint:=False:C215

UNLOAD RECORD:C212([Raw_Materials_Transactions:23])
UNLOAD RECORD:C212([Raw_Materials_Locations:25])
UNLOAD RECORD:C212([Raw_Materials_Allocations:58])
//EOS