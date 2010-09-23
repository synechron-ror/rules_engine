$(document).ready(function() {	  
  
  $('a#re_workflow_new').live('click', function() {    
    $.re_block();
    $.get('/re_workflows/new', null, null, 'script');
    	return false;  
    });  


  $("#re_workflow_new_cancel").live('click', function() {
    $.fancybox.close();
    return false;
  });  

  $('#re_workflow_new_insert').live('click', function() {
    $.re_block();    
    $.post($('#re_workflow_new_form').attr('action'), $('#re_workflow_new_form').serialize(), null, 'script');
    
    return false;
  });
});


