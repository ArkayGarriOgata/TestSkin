// JavaScript Document
function FourDWebRequest(){
	if (window.XMLHttpRequest) {
		this.xmlHttpReq = new XMLHttpRequest();
	}
	// IE
	else if (window.ActiveXObject) {
		this.xmlHttpReq = new ActiveXObject("Microsoft.XMLHTTP");
	}
	this.ipAddress='localhost';
	this.portNumber='80';
	this.message='';
	this.binaryData = null;
	this.numParams = 0;
	this.fourDResponse = '';
	this.fourDError = '';
	this.onSuccess = null;
	this.onError = null;
	
	//custom Properties will here below this
	
	//Functions
	this.initWithAddress = function(ttIP, ttPort, ttMessage)
		{
			this.ipAddress=ttIP;
			this.portNumber=ttPort;
			this.message=ttMessage;
		};
		
	this.addParameter = function(ttName, ttValue)
		{
			this[ttName]=ttValue;
			
			this.numParams++; // Increment the parameter count
		};
	
	
	
	this.addData = function(ttBinaryData)
		{
			this.binaryData = ttBinaryData; 
		};
	

	this.sendRequest = function(fAsync, successFunction, errorFunction)
		{
			
			
			//for (var name in this) {
			//	alert(name+':'+this[name]);
			//} 
			var jsBody = {}

			
			this.onSuccess = successFunction; // Set the success Function
			this.onError = errorFunction;
		
			var ttURL = '/';//'http://google.com/lizard';//this.ipAddress+':'+this.portNumber+'/'+this.message;
			//var ttBody = 'iPodURL='+this.message;
			jsBody.iPodURL = this.message;
			
			
			//ttBody = ttBody+'?CACHE='+Math.random();
			jsBody.CACHE = Math.random();
			
			// Append the properties
			
			
			for (var name in this) 
			{
				if((name != 'xmlHttpReq') &&
					(name != 'ipAddress') &&
					(name != 'portNumber') &&
					(name != 'message') &&
					(name != 'binaryData') &&
					(name != 'numParams') &&
					(name != 'fourDResponse') &&
					(name != 'fourDError') &&
					(name != 'onSuccess') &&
					(name != 'onError') &&
					(name != 'initWithAddress') &&
					(name != 'addParameter') &&
					(name != 'addData') &&
					(name != 'sendRequest')	 )
				{
				
					//ttBody = ttBody+'&'+name+'='+this[name];
					jsBody[name] = this[name];
				
				}
			}
			
			if(this.binaryData)
			{
				//ttBody = ttBody+'&BinaryData='+this.binaryData;
				jsBody.BinaryData = this.binaryData;
			}
			
			
			var ttBody = JSON.stringify(jsBody);
			
			this.xmlHttpReq.open("POST", ttURL, fAsync);
			this.xmlHttpReq.setRequestHeader('Content-Type', 'text/plain; charset=UTF-8');
			//this.xmlHttpReq.setRequestHeader("Content-length", ttBody.length);
			if (fAsync){   // Asynchronous Request
			
					var this4DRequest=this;
					this4DRequest.xmlHttpReq.onreadystatechange = function() {
					   if (this4DRequest.xmlHttpReq.readyState != 4)  { return; }
					    if (this4DRequest.xmlHttpReq.status != 200)  {
						 // Handle error, e.g. Display error message on page
						 this4DRequest.fourDError = 'Error, status = '+this4DRequest.xmlHttpReq.status;
						 this4DRequest.fourDResponse = '';
						 this4DRequest.onError.call(this4DRequest, this4DRequest.fourDError);
						 return;
						} 
						this4DRequest.fourDResponse = this4DRequest.xmlHttpReq.responseText;
						this4DRequest.fourDResponse = this4DRequest.fourDResponse.replace('<EOF>', '');
						this4DRequest.onSuccess.call(this4DRequest);
					 };				
															
					try{
						this.xmlHttpReq.send(ttBody);	
					}catch (err){
						 this.fourDError = err;
						 this.onError.call(this4DRequest, this4DRequest.fourDError);
					}
					
			}else{  // Synchronous Request
	
					var this4DRequest=this;
					this.xmlHttpReq.send(ttBody);	
					if(this.xmlHttpReq.status != 200){
						 this.fourDError = err;
						 this.onError.call(this4DRequest, this4DRequest.fourDError);
						 return;
					}else{
						this.fourDResponse = this.xmlHttpReq.responseText;	
						this.fourDResponse = this.fourDResponse.replace('<EOF>', '');
						this.onSuccess.call(this4DRequest);
					}
					
					
					
			}
			
			
				
		
	
	};




}
