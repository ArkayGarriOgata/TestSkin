delayUntil:=TSTimeStamp(delayUntilDate; delayUntilTime)
zwStatusMsg("BatchRunner"; "Will run in "+String:C10((delayUntil-TSTimeStamp)/60; "###,##0.0")+" minutes.")