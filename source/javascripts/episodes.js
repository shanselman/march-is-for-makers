$(document).ready(function() {
  $(".show-notes").hide();
  $(".js-show-notes").on("click", function(){
    $(this).closest(".episode-description").find(".show-notes").slideToggle();
  });
});
