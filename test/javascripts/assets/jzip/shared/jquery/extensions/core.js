
$.extend({
  modules: function(object) {
    var array = [];
    $.each(object, function(property, names_only) {
      if (property.match(/^[ABCDEFGHIJKLMNOPQRSTUVWXYZ][abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ]+$/)) {
        array.push(names_only === true ? property : object[property]);
      }
    });
    return array;
  }
});

$.fn.extend({
  serializeHash: function() {
    var hash = {};
    $.each(this.serializeArray(), function() {
      if(hash[this.name] === undefined) {
        hash[this.name] = this.value;
      }
      else {
        if ($.isArray(hash[this.name])) {
          hash[this.name].push(this.value);
        }
        else if (this.name.match(/\[\]$/)) {
          hash[this.name] = [hash[this.name], this.value];
        }
        else {
          hash[this.name] = this.value;
        }
      }
    });

    return hash;
  }
});
