// JavaScript Document

var theFormsEntryClass;

var obFormEntryObject;
// Create Base64 Object
var ttRollToDelete = '';

 




$(document).ready(function() {
	//theFormsEntryClass=new fourD_InspectionForms();
	obFormEntryObject = {};
	


	$("#rm_username").val('');
	$("#rm_password").val('');


	
	
	$("#RollScanField").on("change", function(e){
		e.preventDefault();
	  	addRollStockItem();
	  
	});
	
	$("#POSearchButton").bind( "click", function(e, ui) {
		e.preventDefault();
		searchPurchaseOrders($("#POSearchField").val());
		
		var url = '#POList';
		navGotoURL(url);
	});
	
	
	$("#POSearchClear").bind( "click", function(e, ui) {
		e.preventDefault();
 		$("#POSearchField").val('');
 
	});

	/*
	
	$('#RollScanField').on('touchstart', function (e) {
		e.preventDefault();
		   // inside this function the focus works
	});
	
	
	$('#RollScanField').on('touchend', function (e) {
			e.preventDefault();
			
			//$('#startScanner').trigger('click');
			   // inside this function the focus works
			   
			var textbox = document.getElementById('RollScanField');
			textbox.select();
	
			   
		  var delay = 2000; // That's crazy long, but good as an example
		  var $fakeInput = $("#RollLinearFeet");
		  var $targetInput = $('#RollScanField');
		// Prepend to target input container and focus fake input
		  $fakeInput.focus();
		
		  // Update placeholder (presentational purpose)
		  $targetInput.attr("placeholder", "Wait for it...");
		
		  // setTimeout, fetch or any async action will work
		  setTimeout(function() {
		
			// Shift focus to target input
			$targetInput
			  .attr("disabled", false)
			  .attr("placeholder", "I'm alive!")
			  .focus();
		
		  }, delay);		   
		   
		   
	});
	
	*/


    $("#startScannerButton").on("click", function(e) {
	 e.preventDefault();

	  // cache textarea as we need it more than once
	  var textarea = $("#RollScanField"),
		  
		  // save old value as we need to clear it
		  val = textarea.val();
	  
	  // if the value doesn't end in a space, add one
	  if (val.charAt(val.length-1) != " ") {
		val += " ";
	  }
	  
	  // focus textarea, clear value, re-apply
	  textarea
		.focus()
		.val("")
		.val(val);
		
		
		$("#startScannerButton").hide();
		
	});


				
				
				


/*
	var input = document.querySelector('input[type=file]'); // see Example 4

	input.onchange = function () {
	  var file = input.files[0];
	
	  upload(file);
	  //drawOnCanvas(file);   // see Example 6
	  //displayAsImage(file); // see Example 7
	};
*/

	/*
	$("#cart").on("mouseenter", function() {
    	$(".shopping-cart").fadeToggle( "fast");
  	});

	$("#cart").on("mouseleave", function() {
    	$(".shopping-cart").fadeToggle( "fast");
  	});

	$("#cart").on("click", function() {
    	//$(".shopping-cart").fadeToggle( "fast");
  			window.location.href = "/YVT/Checkout/checkout.shtml";
	});

	$("#checkout_button").on("click", function() {
		window.location.href = "/YVT/Checkout/checkout.shtml";
  	});
	*/

});



function dataURItoBlob(dataURI) {
  // convert base64 to raw binary data held in a string
  // doesn't handle URLEncoded DataURIs - see SO answer #6850276 for code that does this
  var byteString = atob(dataURI.split(',')[1]);

  // separate out the mime component
  var mimeString = dataURI.split(',')[0].split(':')[1].split(';')[0]

  // write the bytes of the string to an ArrayBuffer
  var ab = new ArrayBuffer(byteString.length);
  var ia = new Uint8Array(ab);
  for (var i = 0; i < byteString.length; i++) {
      ia[i] = byteString.charCodeAt(i);
  }

  // write the ArrayBuffer to a blob, and you're done
  var blob = new Blob([ab], {type: mimeString});
 
  return blob;

  // Old code
  // var bb = new BlobBuilder();
  // bb.append(ab);
  // return bb.getBlob(mimeString);
}
















function showPOsForVendor(ttVendorName){
	$("#POListVendor").html(ttVendorName);
	
	loadPurchaseOrders(ttVendorName);
	
	var url = '#POList';
	navGotoURL(url);
	
}




function loadVendorsForPOs(ttStatus){
	
	var theOrderClass=new fourD_Purchase_Orders();
	theOrderClass.init();


    //var ttSQL = "Purchase_Orders.Status = '"+ttStatus+"'";
	
	  var ttSQL = "(((Purchase_Orders.Status = 'Approved') OR (Purchase_Orders.Status LIKE 'Partial%')) AND (Purchase_Orders.INX_autoPO = false))";

	
	theOrderClass.queryTable(ttSQL, '', '', 
	function()
			{
				theOrderClass.useSectionsOnField('field4D_VendorName'); // Build sections based off of Vendor Name
				
				var ttText = '';

				for (var i = 0; i < theOrderClass.numberOfSections(); i++ )
				{
					var ttVendorName = theOrderClass.titleForSection(i);
					var ttPOsInSection = "";
					
					for(var j = 0; j < theOrderClass.numberOfRowsInSection(i); j++ ){
						theOrderClass.gotoRecordInSection(i, j);
						if(j > 0){
							ttPOsInSection = ttPOsInSection + ", "
						}
						ttPOsInSection = ttPOsInSection + theOrderClass.field4D_PONo;
					}
					
					//theOrderClass.gotoRecord(i);
					//var ttDisplayON = theOrderClass.field4D_PONo.replace("'", "`");
					ttText = ttText+"<li><a href='#' onclick='showPOsForVendor(\""+ttVendorName+"\")'>"+ttVendorName;
					ttText = ttText+"<p>"+ttPOsInSection+"</p>"
					ttText = ttText+"</a></li>"

				}
				
				$("#order_list").html(ttText);
				$('#order_list').listview('refresh');// reload the company list
				$('#order_list').enhanceWithin();
				
						

			}, 
		function()
		{
			popupAlert('error: '+this.fourDError);
		}
		, ["field4D_PONo", "field4D_VendorName", "field4D_PODate"]);

	
}



function searchPurchaseOrders(ttPONum){
	
	var theOrderClass=new fourD_Purchase_Orders();
	theOrderClass.init();

	var ttSQL = " (Purchase_Orders.PONo = '"+ttPONum+"') ";

	
	theOrderClass.queryTable(ttSQL, '', '', 
	function()
			{
				
				var ttText = '';
				
				
				var xlRecs = theOrderClass.getRecordsInSelection();
				
				if(xlRecs>0){

						for (var i = 0; i < xlRecs; i++)
						{
							theOrderClass.gotoRecord(i);
							var ttDisplayON = theOrderClass.field4D_PONo.replace("'", "`");
							ttText = ttText+"<li><a href='#' onclick='showPOItems(\""+theOrderClass.field4D_PONo+"\", \""+ttDisplayON+"\", \""+theOrderClass.field4D_VendorName+"\")'>"+theOrderClass.field4D_PONo+" - "+theOrderClass.field4D_VendorName+" ("+theOrderClass.field4D_Status+")"+"</a></li>";
		
						}
						
						$("#POList_list").html(ttText);
						$('#POList_list').listview('refresh');// reload the company list
						$('#POList_list').enhanceWithin();
				
				}else{
					window.alert('PO# '+ttPONum+' could not be found.');
					
					var url = '#one';
					navGotoURL(url);
				}
			}, 
		function()
		{
			popupAlert('error: '+this.fourDError);
		}
		, ["field4D_PONo", "field4D_VendorName", "field4D_PODate", "field4D_Status"]);

	
}










function loadPurchaseOrders(ttVendorName){
	
	var theOrderClass=new fourD_Purchase_Orders();
	theOrderClass.init();

	var ttSQL = "( ((Purchase_Orders.Status = 'Approved') OR (Purchase_Orders.Status LIKE 'Partial%')) AND ((Purchase_Orders.INX_autoPO = false) AND (Purchase_Orders.VendorName = '"+ttVendorName+"')) )";

	
	theOrderClass.queryTable(ttSQL, '', '', 
	function()
			{
				
				var ttText = '';

				for (var i = 0; i < theOrderClass.getRecordsInSelection(); i++)
				{
					theOrderClass.gotoRecord(i);
					var ttDisplayON = theOrderClass.field4D_PONo.replace("'", "`");
					ttText = ttText+"<li><a href='#' onclick='showPOItems(\""+theOrderClass.field4D_PONo+"\", \""+ttDisplayON+"\", \""+theOrderClass.field4D_VendorName+"\")'>"+theOrderClass.field4D_PONo+" - "+theOrderClass.field4D_VendorName+" ("+theOrderClass.field4D_Status+")"+"</a></li>";

				}
				
				$("#POList_list").html(ttText);
				$('#POList_list').listview('refresh');// reload the company list
				$('#POList_list').enhanceWithin();
			}, 
		function()
		{
			popupAlert('error: '+this.fourDError);
		}
		, ["field4D_PONo", "field4D_VendorName", "field4D_PODate", "field4D_Status"]);

	
}





function showPOItems(ttPONum, ttPODisplay, ttVendorName){
	//fourD_Purchase_Orders_Items
	$("#currentPONum").html(ttPODisplay);
	$("#currentPOVendor").html(ttVendorName);
	
	
	loadPurchaseOrdersItems(ttPONum);
	
	var url = '#POItemList';
	navGotoURL(url);
}




function loadPurchaseOrdersItems(ttPONum){
	
	var thePOItemClass=new fourD_Purchase_Orders_Items();
	thePOItemClass.init();

	var ttSQL = "( (Purchase_Orders_Items.PONo = '"+ttPONum+"')  AND (Purchase_Orders_Items.Deleted = false)  )";

	
	thePOItemClass.queryTable(ttSQL, '', '', 
	function()
			{
				
				var ttText = '';

				for (var i = 0; i < thePOItemClass.getRecordsInSelection(); i++)
				{
					thePOItemClass.gotoRecord(i);
					var ttDisplayON = thePOItemClass.field4D_PONo.replace("'", "`");
					var ttItemNumberString = '('+thePOItemClass.field4D_ItemNo+') '+thePOItemClass.field4D_Raw_Matl_Code;
					ttText = ttText+"<li><a href='#' onclick='showPOItemEntry(\""+thePOItemClass.field4D_POItemKey+"\", \""+ttDisplayON+"\", \""+ttItemNumberString+"\")'>("+thePOItemClass.field4D_ItemNo+") "+thePOItemClass.field4D_Raw_Matl_Code+" ( Open: "+thePOItemClass.field4D_Qty_Open+")"+"</a></li>";

				}
				
				$("#POItemList_list").html(ttText);
				$('#POItemList_list').listview('refresh');// reload the company list
				$('#POItemList_list').enhanceWithin();
			}, 
		function()
		{
			popupAlert('error: '+this.fourDError);
		}
		, ["field4D_PONo","field4D_POItemKey", "field4D_ItemNo", "field4D_Raw_Matl_Code", "field4D_Qty_Open"]);

	
}


function addRollStockItem(){
	//
	var ttPOItemKey = $("#currentPOItemKey").html();
	var ttNewRollID = $("#RollScanField").val();
	var ttLinearFeet = $("#RollLinearFeet").val();
	

	var theRequest=new FourDWebRequest();
	theRequest.initWithAddress("", "","api_NewRollStockRecord");
	theRequest.addParameter('POItemKey', ttPOItemKey);// Designates new image
	theRequest.addParameter('RollStockID', ttNewRollID);  
	theRequest.addParameter('LinearFeet', ttLinearFeet);  
		
	//var ttFileData = file.data;
	//theRequest.addData( base64ImageRepresentation);

	// Send the request Asynchronous
	theRequest.sendRequest(true, function() {
								   var ttResponse = this.fourDResponse;
								   if(ttResponse.length >0){
									   if (ttResponse == "SUCCESS"){
												loadRollStockItems(); // Reload the list

									   }else{
											//window.alert("Invalid username or password.");
											popupAlert("Invalid Username or Password!");
									   }
									
																				
								   } else {
									   popupAlert("An error occurred, the record cannot be saved at this time.");
								   }
								},null);
	
	
	
}

/*
function checkContainer () {
  if($('#RollScanField').is(':visible'))
  { //if the container is visible on the page
  
  
  		setTimeout( function() { 
		$('#RollScanField').trigger('touchstart');
		$('#RollScanField').trigger('touchend');
		//$('#startScanner').trigger('click'); 
		}, 500 );

	 
  } else {
    setTimeout(checkContainer, 50); //wait 50 ms, then try again
  }
}
*/


function setScanFieldActive(){
		setTimeout( function() { 
		$('#RollScanField').val(' ');
		$('#RollScanField').show(); // Hide initially

		$('#RollScanField').focus(); // Hide initially
		$('#RollScanField').select(); // Hide initially

		//checkContainer ();
		
		
			//$( '#RollScanField' ).focus();
			//clickElement($('#RollScanField'));
		}, 500 );

	
}


function deleteRollStock(ttNewRollID){
	$("#startScannerButton").show();
	
	ttRollToDelete = ttNewRollID;

	popupAlert("Are you sure you want to delete Roll ID: "+ttNewRollID, function(){ 
	
	
	
	
						var ttPOItemKey = $("#currentPOItemKey").html();
						
					
						var theRequest=new FourDWebRequest();
						theRequest.initWithAddress("", "","api_DeleteRollStockRecord");
						theRequest.addParameter('POItemKey', ttPOItemKey);// Designates new image
						theRequest.addParameter('RollStockID', ttRollToDelete);  
							
						// Send the request Asynchronous
						theRequest.sendRequest(true, function() {
													   var ttResponse = this.fourDResponse;
													   if(ttResponse.length >0){
														   if (ttResponse == "SUCCESS"){
																	loadRollStockItems(); // Reload the list

					
														   }else{
																//window.alert("Invalid username or password.");
																popupAlert("Invalid Username or Password!");
														   }
														
																									
													   } else {
														   popupAlert("An error occurred, the record cannot be saved at this time.");
													   }
													},null);
						
	
	
	
	
	
	
	
	 });
	
	
}



function loadRollStockItems(){
	//
	var ttPOItemKey = $("#currentPOItemKey").html();
	
	var theRollIDClass=new fourD_Raw_Materials_Tappi_Roll_id();
	theRollIDClass.init();

	var ttSQL = " Raw_Materials_Tappi_Roll_id.POItemKey = '"+ttPOItemKey+"' ";

	
	theRollIDClass.queryTable(ttSQL, '', '', 
	function()
			{
				
				var ttText = '';

				for (var i = 0; i < theRollIDClass.getRecordsInSelection(); i++)
				{
					theRollIDClass.gotoRecord(i);
					
					var obRolls = JSON.parse(theRollIDClass.field4D_Roll_id);
					var obRollArray = obRolls.rolls;
					
					for(var j=0; j < obRollArray.length; j++){
						ttText = ttText+ '<li>';
						
						ttText = ttText+'<a href="#"> <h3>'+obRollArray[j].roll+'</h3> <p class="ui-li-aside">'+obRollArray[j].linearFeet+' Linear Ft.</p> </a>';
						ttText = ttText+'<a href="#" onclick="deleteRollStock(\''+obRollArray[j].roll+'\')" class="delete">Delete</a>';
						
						ttText = ttText+'</li>';
								/*			
												
								ttText = ttText+'<li class="ui-li ui-li-static ui-btn-up-c';				
												
												
												
												
								if(j === 0){ // First
									ttText = ttText+' ui-corner-top';
								}
								
								if(j === (obRollArray.length-1)){ // Last
								  ttText = ttText+' ui-corner-bottom ui-li-last'
								}
									
								ttText = ttText+'">'+obRollArray[j].roll+' ('+obRollArray[j].linearFeet+' Linear Feet)'+'<a href="#" class="delete">Delete</a></li>';
							
								*/
								
												
												
												
						
						
					}
				


				}
				
				$("#RollID_list").html(ttText);
				$('#RollID_list').listview('refresh');// reload the company list
				$('#RollID_list').enhanceWithin();
				
				setScanFieldActive()

			}, 
		function()
		{
			popupAlert('error: '+this.fourDError);
		}
		, ["field4D_pk_id", "field4D_Linear_Feet", "field4D_Roll_id"]);
	
	
	

	
}


function showPOItemEntry(ttPOItemKey, ttPODisplay, ttItemNumberString){
	//fourD_Purchase_Orders_Items
	$("#currentItemPONum").html(ttPODisplay);
	$("#currentItemNumber").html(ttItemNumberString);
	$("#currentPOItemKey").html(ttPOItemKey);
	
	//$('#RollScanField').hide(); // Hide initially
	$("#startScannerButton").show();


	loadRollStockItems();
	
	var url = '#POItemEntry';
	navGotoURL(url);
}





