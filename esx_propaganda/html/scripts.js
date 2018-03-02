

$(document).ready(function(){
  // Partial Functions
  function closeMain() {
	  
    $(".app").css("display","none");
	
  }
  
  function openMain() { //hide parts of ui etc
  
    $(".app").css("display","block");
	
  }
  
  function closeAll() {
	  
    $(".app").css("display","none");
	
  }
  
  function emptyEditor(){
	  
	$("textarea").val("");
	
  }
  
  function postArticle() {
	
	var _title = $.trim($(".title").val());
	var _bait = $.trim($(".bait").val());
	var _content = $.trim($(".content").val());
	var _imgurl = $.trim($(".imgurl").val());
	
	var _type = "";
	
	if($("#uutinen").is(":checked")) {
		
		_type = "uutinen";
		
	} else {
		
		_type = "viihde";
		
	}
	
	$.post('http://esx_propaganda/postArticle', JSON.stringify({title : _title, bait_title : _bait, content : _content, imgurl : _imgurl, type : _type}));
	emptyEditor();
	$.post('http://esx_propaganda/closePropaganda', JSON.stringify({}));
	
  }
  
  // Listen for NUI Events
  window.addEventListener('message', function(event){

	var item = event.data;

    if(item.openPropaganda == true) {
      
	  openMain();
	  
    }
    
	if(item.openPropaganda == false) {
	  
      closeMain();
	  
    }


  });
  // On 'Esc' call close method
  document.onkeyup = function (data) {
   
   if (data.which == 27 ) {
      
	  closeMain();
	  $.post('http://esx_propaganda/closePropaganda', JSON.stringify({}));
	  
	}
  };
  
   $(".btnClose").click(function(){
    
		$.post('http://esx_propaganda/closePropaganda', JSON.stringify({}));
    
	});
	
	$(".btnSend").click(function(){
		postArticle();
	});
	

});
 