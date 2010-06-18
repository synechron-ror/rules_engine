$(document).ready(function() {	  
  
  get_job_list = function(page) {
    $.get('/re_jobs?page=' + page, null, null, 'script');
  }
  
  get_job_list(1);
});


