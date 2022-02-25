var formChanges;

// --------- declarations ---------

var autoSaveFun = function autosave() {
  $('form.autosave').each(function(index) {
    if(formChanges[index]){
      $(this).ajaxSubmit(function(data) {
        formChanges[index] = false;
        if(data.new_url) this.attr('action', data.new_url).attr('method', 'patch');
        window.SnackBar({message: "<i class='far fa-save'></i>", position: "tr", dismissible: false, timeout: 2000});
      }.bind($(this)))
    }
  });
}

var setModalPositioning = function modalPosition(){
  let num_open = $(".modal.show").length;
  $(".modal-backdrop.show").css('opacity', 0.5/num_open);
  $.each($(".modal.show").toArray().sort((a, b) => a.getAttribute('data-depth') - b.getAttribute('data-depth')), function(i, v) {
    $(v).css({width: (100/num_open)+'%', marginLeft: ((100/num_open)*i)+'%'});
  });
}

function timeoutReload(location_hash){
  console.log("timeout relaoding running");
  if(location_hash){
    location.hash = location_hash;
  } else {
    location.hash = '';
  }
  setTimeout(function(){
    // if(location_hash) 
      window.location.reload(true);
    // else window.location.href = window.location.href;
  }, 200)
}

function saveForm(form, input_for_id=null) {
  var id;
  console.log("form", form);
  form.ajaxSubmit(function(data) {
    console.log("Save form data", data);
    if(data.new_url) form.attr('action', data.new_url).attr('method', 'patch');
    window.SnackBar({message: "<i class='far fa-save'></i>", position: "tr", dismissible: false, timeout: 2000});
    if(input_for_id) input_for_id.val(data.id);
  })
}

function saveAllForms() {
  $('form.autosave').each(function() {
    saveForm($(this));
  });
}

function createModalListeners() {
  $('.modal').on('shown.bs.modal', setModalPositioning);
  // $('.modal').on('shown.bs.modal', function() {
  //   saveAllForms();
  // });
  $('.modal').on('hidden.bs.modal', setModalPositioning);
}

// --------- rdy ---------

$(function() {
  setTimeout(function() {

    $('form.autosave').each(function(index) {
      if(!$(this).hasClass('block-submit')){
        $(this).ajaxForm({
          success: function(data, x, y, form) {
            formChanges[index] = false
            if(data.new_url) form.attr('action', data.new_url).attr('method', 'patch');
            window.SnackBar({message: "<i class='far fa-save'></i>", position: "tr", dismissible: false, timeout: 2000});
          }
        });
      }
    });
    $('.modal').modal({backdrop: 'static', keyboard: false})  

    formChanges = $('form.autosave').map(function() { return false; });

    $('form.autosave').each(function(index) {
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
 
  $('[data-bs-toggle="popover"]').popover();

  createModalListeners();
  if($(location.hash).hasClass("modal")) setTimeout(function() {
    $(location.hash).modal('show');
  }, 100); 

});
