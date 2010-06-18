$(document).ready(function() {	  
  
  get_job_list = function(page) {
    var pipeline = $('#re_job_list_pipeline').attr('href').replace('#', '');
    $.get('/re_pipelines/' + pipeline + '/re_jobs?page=' + page, null, null, 'script');
  }
  
  get_job_list(1);
});


