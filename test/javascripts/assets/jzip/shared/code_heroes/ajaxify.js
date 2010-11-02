
CodeHeroes.Ajaxify = (function() {
  var bind = function() {
    $("form.ajaxify").live("submit", function(event) {
      alert("Sending an Ajax request based on an Ajaxified form!");
      event.preventDefault();
    });
  };

  return {
    init: function() {
      bind();
    }
  };
}());
