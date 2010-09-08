$(document).ready(function() {	  
  
  $('a.re-xtra-history-show').live('click', function() {    
    var id = $(this).attr('href').replace('#', '')
      
    $.re_block();
    $.get('/re_history/' + id, null, null, 'script');
  	return false;  
  });  
  
  $("#re_history_show_close").live('click', function() {
    $.fancybox.close();
    return false;
  });  
  
});


