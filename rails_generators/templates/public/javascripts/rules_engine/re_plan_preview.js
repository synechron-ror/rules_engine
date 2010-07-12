$(document).ready(function() {	  
  
  $('a.re-plan-preview').live('click', function() {    
    var id = $(this).attr('href').replace('#', '')
      
    $.re_block();
    $.get('/re_plans/' + id + '/preview', null, null, 'script');
  	return false;  
  });  
  
  $("#re_plan_preview_close").live('click', function() {
    $.fancybox.close();
    return false;
  });  
  
});


