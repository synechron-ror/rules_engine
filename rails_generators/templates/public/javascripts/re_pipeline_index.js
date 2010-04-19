$(document).ready(function() {	  

  // RULE LIST  
  $('a.re-pipeline-rule-list-toggle').live('click', function() {    
    var id = $(this).attr('href').replace('#', '');
    
    var $div = $(this).find('div:first')
    var $list = $('#re_pipeline_rule_list_' + id)
    if ($div.hasClass('re-pipeline-rule-list-down')) {
      $list.slideUp(150, function() {
        $div.removeClass('re-pipeline-rule-list-down');
        $div.addClass('re-pipeline-rule-list-right');
      });
    } else {
      $list.slideDown(150, function() {
        $div.removeClass('re-pipeline-rule-list-right');
        $div.addClass('re-pipeline-rule-list-down');
      });
    }
  });
  
});


