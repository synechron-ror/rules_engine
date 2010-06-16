get_pipeline_job_list = function(page) {
  var pipeline = $('#re_job_list_pipeline').attr('href').replace('#', '');
  $.get('/re_pipelines/' + pipeline + '/re_jobs?page=' + page, null, null, 'script');
}


$(document).ready(function() {	  
  get_pipeline_job_list(1);
  
  $('a.re-job-page-prev-enabled').live('click', function() {
    var page = $(this).attr('href').replace('#', ''); 
    
    $('#re_job_list').hide();
    $('#re_job_list_pending').show();
    get_pipeline_job_list(page);  
    
  	return false;  
  });  

  $('a.re-job-page-prev-disabled').live('click', function() {
    return false;
  });
  

  $('a.re-job-page-next-enabled').live('click', function() {
    var page = $(this).attr('href').replace('#', ''); 

    $('#re_job_list').hide();
    $('#re_job_list_pending').show();
    get_pipeline_job_list(page);  

  	return false;  
  });  

  $('a.re-job-page-next-disabled').live('click', function() {
    return false;
  });  
});


