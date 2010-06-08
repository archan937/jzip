
CodeHeroes.Frontend = (function() {
  var bind = function() {
    $("body.frontend a").live("click", function(event) {
      alert("Doing something frontend specific!");
      event.preventDefault();
    });
  };
  
  return {
    init: function() {
      bind();
    }
  };
}());
