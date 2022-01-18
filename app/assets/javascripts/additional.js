var formChanges;

// --------- declarations ---------

var autoSaveFun = function autosave() {
  $('.in-app form').each(function(index) {
    if(formChanges[index]){
      $(this).ajaxSubmit(function(data) {
        formChanges[index] = false;
        if(data.new_url) this.attr('action', data.new_url).attr('method', 'patch');
        window.SnackBar({message: "Autosaved form"})
      }.bind($(this)))
    }
  });
}

// --------- rdy ---------

$(function() {
  setTimeout(function() {

    $('.in-app form').each(function(index) {
      $(this).ajaxForm({
        success: function(data, x, y, form) {
          formChanges[index] = false
          if(data.new_url) form.attr('action', data.new_url).attr('method', 'patch');
          window.SnackBar({message: "Saved form"})
        }
      });
    });

    formChanges = $('.in-app form').map(function() { return false; });

    $('.in-app form').each(function(index) {
      $(this).find('input, select, textarea').change(function() {
        formChanges[index] = true;
      });
    });
      
    $("textarea").each(function () {
      this.setAttribute("style", "height:" + (this.scrollHeight) + "px;overflow-y:hidden;");
    }).on("input", function () {
      this.style.height = "auto";
      this.style.height = (this.scrollHeight) + "px";
    });

    setInterval(autoSaveFun,10000);

  }, 250);
});
