$(document).ready(function() {	  
  
  $('a.re-list-rule-help').live('click', function() {    
    var values = $(this).attr('href').replace('#', '').split('|');
    
    $.re_block();
    if (parseInt(values[0]) == 0)
      $.get('/re_workflows/' + values[1] + '/rules/help?rule_class_name=' + values[2], null, null, 'script');
    else
      $.get('/re_plans/' + values[0] + '/workflows/' + values[1] + '/rules/help?rule_class_name=' + values[2], null, null, 'script');
    
    return false;  
  });  

  $("#re_rule_help_cancel").live('click', function() {
    $.fancybox.close();    
    return false;
  });  
  
});


