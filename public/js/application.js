$(document).ready(function() {
  // This is called after the document has loaded in its entirety
  // This guarantees that any elements we bind to will exist on the page
  // when we try to bind to them

  // See: http://docs.jquery.com/Tutorials:Introducing_$(document).ready()
  //$(document).on("pageload", function () {
    var backgroundColor;
    var score = $("#score").find('p').text();
    var $report = $(".colorify");
    if (score > 90) {
      $report.css("background-color", "#CCFFCC");
    } else if (score > 75) {
      $report.css("background-color", "#FFFFCC");
    } else if (score > 0) {
      $report.css("background-color", "#FFCCCC");
    };
  //});

    $('#search-bar').on("submit", function (event) {
      event.preventDefault();
      var request = $.ajax({
                    url: "/reports",
                    method: "post",
                    data: $(this).serialize()
                    }); // request sent
      request.done(function(response){
        // console.log(typeof response);
        // $(".errors").append(response);
      }); // response back
    })
});
