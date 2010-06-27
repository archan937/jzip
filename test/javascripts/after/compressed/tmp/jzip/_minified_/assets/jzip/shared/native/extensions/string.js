
String.prototype.humanize=function(){return this[0].toUpperCase()+this.replace(/_/g," ").slice(1);};