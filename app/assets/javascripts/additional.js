// --------- declarations ---------

var changeMade = false;

var autoSaveFun = function autosave() {
  if(changeMade){
    $('form').each(function () {
      $(this).ajaxSubmit(function() {
        changeMade = false;
        window.SnackBar({message: "Autosaved form"})
      })
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

  $('form').ajaxForm({success: function() {
    window.SnackBar({message: "Saved form"})
  }});

  setInterval(autoSaveFun,10000);

  $('input, select').change(function() {
    changeMade = true;
  });


})
