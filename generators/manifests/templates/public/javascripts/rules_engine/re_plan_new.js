$(document).ready(function() {	  
  
  $('a#re_plan_new').live('click', function() {    
    $.re_block();
    $.get('/re_plans/new', null, null, 'script');
    	return false;  
    });  


  $("#re_plan_new_cancel").live('click', function() {
    $.fancybox.close();
    return false;
  });  

  $('#re_plan_new_insert').live('click', function() {
    $.re_block();    
    $.post($('#re_plan_new_form').attr('action'), $('#re_plan_new_form').serialize(), null, 'script');
    
    return false;
  });
});


