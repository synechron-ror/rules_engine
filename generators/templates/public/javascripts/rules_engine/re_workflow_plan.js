$(document).ready(function() {	  
  
  get_workflow_plan = function(page) {
    var id = $('.re-menu-workflow-plan:first').attr('id').replace('re_menu_workflow_plan_', '')
    $.get('/re_workflows/' + id + '/plan?page=' + page, null, null, 'script');
  }
  
  get_workflow_plan(1);
  
  $('.re-xtra-workflow-next-enabled').live('click', function() {    
    var page = $(this).attr('href').replace('#', '')

    $('#re_workflow_plan').hide();
    $('#re_workflow_plan_pending').show();
    
    get_workflow_plan(page);
    return false;  
  });  
  $('.re-xtra-workflow-next-disabled').live('click', function() {    
    return false;
  });  

  $('.re-xtra-workflow-prev-enabled').live('click', function() {    
    var page = $(this).attr('href').replace('#', '')

    $('#re_workflow_plan').hide();
    $('#re_workflow_plan_pending').show();
    
    get_workflow_plan(page);
    return false;  
  });  
  $('.re-xtra-workflow-prev-disabled').live('click', function() {    
    return false;
  });  

});


