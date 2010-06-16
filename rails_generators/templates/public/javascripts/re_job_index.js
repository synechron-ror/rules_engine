$(document).ready(function() {	  

  $('a.re-job-detail').live('click', function() {    
    var job = $(this).attr('href').replace('#', '');
      
    $.re_block();
    $.get('/re_jobs/' + job, null, function() {
        $.re_unblock();
        $.fancybox({ href: '#re_content'});
      }, 'script');
    
  	return false;  
  });  

});


