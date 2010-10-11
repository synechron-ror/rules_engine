$(document).ready(function() {	  
  
  $('a.re-xtra-workflow-preview').live('click', function() {    
    var id = $(this).attr('href').replace('#', '')
      
    $.re_block();
    $.get('/re_workflows/' + id + '/preview', null, null, 'script');
  	return false;  
  });  
  
  $("#re_workflow_preview_close").live('click', function() {
    $.fancybox.close();
    return false;
  });  
  
});


