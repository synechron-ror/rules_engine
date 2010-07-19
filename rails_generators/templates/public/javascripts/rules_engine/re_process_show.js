$(document).ready(function() {	  
  
  $('a.re-xtra-process-show').live('click', function() {    
    var id = $(this).attr('href').replace('#', '')
      
    $.re_block();
    $.get('/re_processes/' + id, null, null, 'script');
  	return false;  
  });  
  
  $("#re_process_show_close").live('click', function() {
    $.fancybox.close();
    return false;
  });  
  
});


