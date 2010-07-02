$(document).ready(function() {	  
  
  $('a#re_pipeline_new').live('click', function() {    
    
  $.re_block();
  $.get('/re_pipelines/new', null, function() {
        $.re_unblock();
        $.fancybox({ href: '#re_content'});
      }, 'script');
  	return false;  
  });  


  $("#re_pipeline_new_cancel").live('click', function() {
    $.fancybox.close();
    return false;
  });  

  $('#re_pipeline_new_insert').live('click', function() {
    $.re_block();    
    $.post($('#re_pipeline_new_form').attr('action'), $('#re_pipeline_new_form').serialize(), function() {
        $.fancybox.resize();
        $.re_unblock();
      }, 'script');
    
    return false;
  });
});


