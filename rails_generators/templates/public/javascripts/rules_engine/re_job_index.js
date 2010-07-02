var get_job_list = null;
  
$(document).ready(function() {	  

  $('a.re-job-detail').live('mouseover', function(){
      var $tr = $(this).closest('tr');    
      if ($tr.hasClass('odd'))
        $tr.removeClass('odd').addClass('re-job-row-odd');      
      else
        $tr.addClass('re-job-row');          
    });
  
  $('a.re-job-detail').live('mouseout', function() {
      var $tr = $(this).closest('tr');
      if ($tr.hasClass('re-job-row-odd'))
        $tr.removeClass('re-job-row-odd').addClass('odd');      
      else
        $tr.removeClass('re-job-row');      
    });
  
  $('a.re-job-detail').live('click', function() {    
    var job = $(this).attr('href').replace('#', '');
      
    $.re_block();
    $.get('/re_jobs/' + job, null, function() {
        $.re_unblock();
        $.fancybox({ href: '#re_content'});
      }, 'script');
    
  	return false;  
  });  

  $('a.re-job-page-prev-enabled').live('click', function() {
    if (!get_job_list)
      return true
      
    var page = $(this).attr('href').replace('#', ''); 
    
    $('#re_job_list').hide();
    $('#re_job_list_pending').show();
    get_job_list(page);  
    
  	return false;  
  });  

  $('a.re-job-page-prev-disabled').live('click', function() {
    return false;
  });
  

  $('a.re-job-page-next-enabled').live('click', function() {
    if (!get_job_list)
      return true

    var page = $(this).attr('href').replace('#', ''); 
    
    $('#re_job_list').hide();
    $('#re_job_list_pending').show();
    get_job_list(page);  
    
  	return false;  
  });  

  $('a.re-job-page-next-disabled').live('click', function() {
    return false;
  })
  
  $("#re_jobs_close").live('click', function() {
    $.fancybox.close();    
    return false;
  });  
  
});


