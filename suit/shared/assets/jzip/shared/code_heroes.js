
CodeHeroes = (function() {
  var initModules = function() {
    $.each($.modules(CodeHeroes), function(i, module) {
      initSubModules(module);
    });
  };

  var initSubModules = function(mod) {
    if (mod.init) {
      mod.init();
    }
    $.each($.modules(mod), function(i, m) {
      initSubModules(m);
    });
  };

  return {
    init: function() {
      initModules();
    }
  };
}());

$(CodeHeroes.init);
