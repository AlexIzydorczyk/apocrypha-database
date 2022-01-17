// --------- declarations ---------

var changeMade = false;

var autoSaveFun = function autosave() {
  if(changeMade){
    $('form').each(function () {
      $(this).ajaxSubmit(function(data) {
        changeMade = false;
        if(data.new_url) this.attr('action', data.new_url).attr('method', 'patch');
        window.SnackBar({message: "Autosaved form"})
      }.bind($(this)))
    });
  }
}

// --------- rdy ---------

$(document).ready(function() {
  
  $("textarea").each(function () {
    this.setAttribute("style", "height:" + (this.scrollHeight) + "px;overflow-y:hidden;");
  }).on("input", function () {
    console.log("input detected");
    this.style.height = "auto";
    this.style.height = (this.scrollHeight) + "px";
  });

  $('form').ajaxForm({success: function(data, x, y, form) {
    changeMade = false;
    console.log($(this));
    if(data.new_url) form.attr('action', data.new_url).attr('method', 'patch');
    window.SnackBar({message: "Saved form"})
  }});

  setInterval(autoSaveFun,10000);

  $('input, select').change(function() {
    changeMade = true;
  });


})
