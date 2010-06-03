get_pipeline_job_list = function(page) {
  var pipeline = $('#re_job_list_pipeline').attr('href').replace('#', '');
  $.get('/re_pipelines/' + pipeline + '/re_jobs?page=' + page, null, null, 'script');
}


$(document).ready(function() {	  
  get_pipeline_job_list(1);
  
  $('a.re-job-detail').live('click', function() {    
    var job = $(this).attr('href').replace('#', '');
      
    tb_show("", '#?TB_inline=true&inlineId=tb_temp_frame&height=450&width=800', false);
    block_thickbox();
    $.get('/re_jobs/' + job, null, unblock_thickbox, 'script');
    
  	return false;  
  });  


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


  $('a.re-job-page-refresh').live('click', function() {
    var page = $(this).attr('href').replace('#', ''); 
    
    $('#re_job_list_empty').hide();
    $('#re_job_list').hide();
    $('#re_job_list_pending').show();
    get_pipeline_job_list(page);  

  	return false;  
  });  
  
  
});


