//  //(S) [CONTROL]VendorEvent'ibMod
//If (Not(User in group(Current user;"Purchasing"))) & (Not(User in group(Current user;"Requisitioning")))
//uNotAuthorized 
//Else 
ViewSetter(2; ->[Customers_ReleaseSchedules:46])
//End if 
//EOS