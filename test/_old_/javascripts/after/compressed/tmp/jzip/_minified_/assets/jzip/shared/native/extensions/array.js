
Array.prototype.first=function(){return this[0];};Array.prototype.last=function(){return this[this.length-1];};Array.prototype.min=function(){var r=null;for(var i=0;i<this.length;i++){if(r===null||this[i]<r){r=this[i];}}
return r;};Array.prototype.max=function(){var r=null;for(var i=0;i<this.length;i++){if(r===null||this[i]>r){r=this[i];}}
return r;};