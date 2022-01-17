console.log('file loaded');

$(document).ready(function() {
  $("textarea").each(function () {
    this.setAttribute("style", "height:" + (this.scrollHeight) + "px;overflow-y:hidden;");
  }).on("input", function () {
    console.log("input detected");
    this.style.height = "auto";
    this.style.height = (this.scrollHeight) + "px";
  });
})
