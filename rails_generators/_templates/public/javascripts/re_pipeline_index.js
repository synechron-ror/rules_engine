$(document).ready(function() {	  

  // RULE LIST  
  $('a.pipeline-rule-list-toggle').live('click', function() {    
    var id = $(this).attr('href').replace('#', '');
    
    var $div = $(this).find('div:first')
    var $list = $('#pipeline_rule_list_' + id)
    if ($div.hasClass('pipeline-rule-list-down')) {
      $list.slideUp(150, function() {
        $div.removeClass('pipeline-rule-list-down');
        $div.addClass('pipeline-rule-list-right');
      });
    } else {
      $list.slideDown(150, function() {
        $div.removeClass('pipeline-rule-list-right');
        $div.addClass('pipeline-rule-list-down');
      });
    }
  });
  
});


