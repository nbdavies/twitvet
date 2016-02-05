$(document).ready(function() {
  // This is called after the document has loaded in its entirety
  // This guarantees that any elements we bind to will exist on the page
  // when we try to bind to them

  // See: http://docs.jquery.com/Tutorials:Introducing_$(document).ready()
  //$(document).on("pageload", function () {
    var backgroundColor;
    var score = $("#score").text();
    var $report = $(".right");
    if (score > 90) {
      $report.css("background-color", "#CCFFCC");
    } else if (score > 75) {
      $report.css("background-color", "#FFFFCC");
    } else {
      $report.css("background-color", "#FFCCCC");
    };
  //});
});
