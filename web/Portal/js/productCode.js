// Globals
var columnDefs = [];
var gridOptions = {};
var callOffDialog, callOffForm;




$(document).ready(function () {

			// specify the columns
		columnDefs = [
			{ headerName: "Product Code", field: "product_code", sortable: true, filter: true, resizable: true, width: 130, pinned: "left"  },
			{ headerName: "On Hand", field: "qty_onhand", sortable: true, filter: true, width: 100, cellStyle: { textAlign: 'right' } },
			{ headerName: "Released", field: "qty_wip", sortable: true, filter: true, width: 100, cellStyle: { textAlign: 'right' } },
			{ headerName: "Product Line", field: "product_line", sortable: true, filter: true, resizable: true, width: 140 },
			{ headerName: "Description", field: "description", sortable: true, filter: true, resizable: true, width: 140 }
		];
	
		// let the grid know which columns and what data to use
		gridOptions = {
			columnDefs: columnDefs,
			rowSelection: 'multiple',
			rowData: [],
			onSelectionChanged: onSelectionChanged
		};



		var ttQueryType = getAllUrlParams().mode;

		if (ttQueryType === "navcanship"){
			$("#queryBox").hide();

		}


		$( "#navbar" ).load( "navbar.html"); // Load Top Navbar
		// Next, load side bar menu
	
		$( "#sidebar" ).load( "sidbar.html", function() {
			$("#"+ttQueryType).addClass("active");

			var ttMenuName = $( "#"+ttQueryType ).find( "span" ).html(); // Get the currently selected side bar menu name.
			$("#searchTitle").html("Search by " + ttMenuName); // Set the title

		});
	


		if(typeof ttQueryType === "undefined"){
			window.location.href = "login.html";
		}else{
			initProductCodeScreen();
		}





});




$( function() {
    var emailRegex = /^[a-zA-Z0-9.!#$%&'*+\/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$/,
      subjectField = $( "#subject" ),
      bodyField = $( "#body" ),
      allFields = $( [] ).add( subjectField ).add( bodyField ),
      tips = $( ".validateTips" );
 
 
    function checkLength( o, n) {
      if ( o.val().length == 0 ) {
        o.addClass( "ui-state-error" );
        updateTips( n + " field is empty. ");
        return false;
      } else {
        return true;
      }
    }
 
    function checkRegexp( o, regexp, n ) {
      if ( !( regexp.test( o.val() ) ) ) {
        o.addClass( "ui-state-error" );
        updateTips( n );
        return false;
      } else {
        return true;
      }
    }
 
    function sendEmail() {
      var valid = true;
      allFields.removeClass( "ui-state-error" );
 
      valid = valid && checkLength( subjectField, "subject", 3, 16 );
      valid = valid && checkLength( bodyField, "body", 6, 80 );
 
      if ( valid ) {
        sendEmailToServer();
      }
      return valid;
    }
 
    callOffDialog = $( "#dialog-form" ).dialog({
      autoOpen: false,
      height: 400,
	  width: 450,
	  position: { my: 'top', at: 'top+150' },
      modal: true,
      buttons: {
        "SendEmail": {
			text: "Send Email",
			id: "sendEmailButton",
			click: function(){
				sendEmail();
			}   
		 },
        Cancel: function() {
			callOffDialog.dialog( "close" );
        }
      },
      close: function() {
        callOffForm[ 0 ].reset();
        allFields.removeClass( "ui-state-error" );
      }
    });
 
    callOffForm = callOffDialog.find( "form" ).on( "submit", function( event ) {
      event.preventDefault();
      sendEmail();
    });
 
    $( "#create-user" ).button().on( "click", function() {
		callOffDialog.dialog( "open" );
    });
  } );



  function updateTips( t ) {
	$( ".validateTips" ).text( t ).addClass( "ui-state-highlight" );
	setTimeout(function() {
		$( ".validateTips" ).removeClass( "ui-state-highlight", 1500 );
	}, 500 );
  }





function initProductCodeScreen(){

    loadSessionData(function (){
		queryGrid();
    });
 
};




    
function onSelectionChanged() {
	var selectedNodes = gridOptions.api.getSelectedNodes();
	var selectedData = selectedNodes.map(function (node) { return node.data });
	var selectedDataStringPresentation = selectedData.map(function (node) { return fillRecordTemplate(node) }).join('<br>');
	$("#gridDetail").html(selectedDataStringPresentation);

};

function fillRecordTemplate(record) {


	recordHtml = '<div class="grid-container">'
	recordHtml += '<div class="grid-item-label">Product Code:</div>'+'<div class="grid-item" id="selProductCode">'+record.product_code+'</div>'
	recordHtml += '<div class="grid-item-label">Product Line:</div>'+'<div class="grid-item">'+record.product_line+'</div>'
	recordHtml += '<div class="grid-item-label">Description:</div>'+'<div class="grid-item">'+record.description+'</div>'
	recordHtml += '<div class="grid-item-label">Packing Spec:</div>'+'<div class="grid-item">'+record.packing_spec+'</div>'
	recordHtml += '<div class="grid-item-label">On Hand:</div>'+'<div class="grid-item" id="selQtyOnHand">'+record.qty_onhand+'</div>'
	recordHtml += '<div class="grid-item-label">Certification:</div>'+'<div class="grid-item">'+record.qty_certification+'</div>'
	recordHtml += '<div class="grid-item-label">Open Jobs:</div>'+'<div class="grid-item">'+record.qty_wip+'</div>'
	recordHtml += '<div class="grid-item-label">Open Orders:</div>'+'<div class="grid-item">'+record.qty_open_order+'</div>'
	recordHtml += '<div class="grid-item-label">Released:</div> '+'<div class="grid-item">'+record.qty_scheduled+'</div>'
	recordHtml += '<div class="grid-item-label"></div> '+'<div class="grid-item"><input type="button" name="send_btn" value="Call Off" id="send_btn" class="submit-button" style="width:100%;" onclick="callOff()"></div>'
	recordHtml += '</div>'
  
	recordHtml += '</div>'



	return recordHtml;
};
    
function queryGrid() {
	var ttQueryType = getAllUrlParams().mode;

	queryValue = document.getElementById("queryBox").value;
	fillGrid(ttQueryType, queryValue);

};



function callOff(){




	var ttPC = $("#selProductCode").html()
	var ttOH =  $("#selQtyOnHand").html()
	
	var theRequest = new FourDWebRequest();
	theRequest.initWithAddress("", "","customer_Portal");
	theRequest.addParameter('Action', "gotoCalloff");
	
	theRequest.addParameter('ProductCode', ttPC );
	theRequest.addParameter('OnHand', ttOH);


	theRequest.sendRequest(true, function() {
										var ttResponse = this.fourDResponse;
										if(ttResponse.length >0){
											var obReturn = JSON.parse(ttResponse);

											if (obReturn.success == true){
												if ( obReturn.hasOwnProperty('callOffSubject') ) {
													$("#subject").val(obReturn.callOffSubject);
												}	
												if ( obReturn.hasOwnProperty('callOffBody') ) {
													$("#body").val(obReturn.callOffBody);
												}	
												callOffDialog.dialog( "open" );
											

											}else{
												alert("An error occurred, the request cannot be processed.");
											}
											
																						
										} else {
											alert("An error occurred, the request cannot be processed.");
										}
										}, 
										function()
										{
											alert('error: '+this.fourDError)
										}
							);


};


function sendEmailToServer(){

	var theRequest = new FourDWebRequest();
	theRequest.initWithAddress("", "","customer_Portal");
	theRequest.addParameter('Action', "sendCallOffEmail");
	
	theRequest.addParameter('subject', $("#subject").val() );
	theRequest.addParameter('body',  $("#body").val());


	$("#sendEmailButton").prop("disabled", true);
	theRequest.sendRequest(true, function() {
										var ttResponse = this.fourDResponse;
										if(ttResponse.length >0){
											var obReturn = JSON.parse(ttResponse);

											if (obReturn.success == true){

												callOffDialog.dialog( "close" );
												$("#sendEmailButton").prop("disabled", false);
												
											}else{
												updateTips( obReturn.errorText);
												$("#sendEmailButton").prop("disabled", false);
											}
											
																						
										} else {
											alert("An error occurred, the request cannot be processed.");
											$("#sendEmailButton").prop("disabled", false);
										}
										}, 
										function()
										{
											alert('error: '+this.fourDError);
											$("#sendEmailButton").prop("disabled", false);
										}
							);

};



function fillGrid(ttQueryType, queryValue) {

	if(typeof ttQueryType === "undefined"){
		ttQueryType = "navProductCode"
	}

	if(typeof queryValue === "undefined"){
		queryValue = ""
	}


	// lookup the container we want the Grid to use
	document.getElementById('myGrid').innerHTML = ''; // Force refreshing of grid
	var eGridDiv = document.querySelector('#myGrid');

	// create the grid passing in the div to use together with the columns & data we want to use
	new agGrid.Grid(eGridDiv, gridOptions);

	//Call to the API

	url = "/portal/portal?portal=customer_Portal&action=" + ttQueryType + "&queryString=" + queryValue ;

	fetch(url).then(function (response) {
		var ttResponse = response.json();
		return ttResponse;
	}).then(function (resp) {
		gridOptions.api.setRowData(resp.data);
	});

};





