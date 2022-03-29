var formChanges;

// --------- declarations ---------

var autoSaveFun = function autosave() {
  $('form.autosave').each(function(index) {
    if(formChanges[index] && !$(this).hasClass('no-autosave')){
      $(this).ajaxSubmit(function(data) {
        formChanges[index] = false;
        if(data && data.new_url) this.attr('action', data.new_url).attr('method', 'patch');
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

function saveForm(form, input_for_id=null, callback=null) {
  var id;
  console.log("form", form, input_for_id);
  form.ajaxSubmit(function(data) {
    if(data && data.new_url) {form.attr('action', data.new_url).attr('method', 'patch')};
    window.SnackBar({message: "<i class='far fa-save'></i>", position: "tr", dismissible: false, timeout: 2000});
    console.log("record id", data.id);
    if(input_for_id) input_for_id.val(data.id).change();
    if(callback != null) callback();
  })
}

function saveAllForms() {
  $('form.autosave').each(function() {
    saveForm($(this));
  });
}

function createModalListeners(selector) {
  $(selector).on('shown.bs.modal', setModalPositioning);
  $(selector).each(function() {
    if($(this).data('depth') < 1) $(this).on('shown.bs.modal', function() {
      $('form.autosave.save-before-modals').each(function() {
        saveForm($(this));
      })
    });
  });
  $(selector).on('hidden.bs.modal', setModalPositioning);
}

// --------- rdy ---------

$(function() {
  setTimeout(function() {

    $('form.autosave').each(function(index) {
      if(!$(this).hasClass('block-submit')){
        let form = $(this);
        $(this).ajaxForm({
          success: function(data, x, y, form) {
            formChanges[index] = false
            if(data && data.new_url) form.attr('action', data.new_url).attr('method', 'patch');
            window.SnackBar({message: "<i class='far fa-save'></i>", position: "tr", dismissible: false, timeout: 2000});
            if(form.hasClass("base-form")) $('.adjacent-base-form').each(function() {
              saveForm($(this));
            })
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
      $(this).css("height", Math.max(38, this.scrollHeight) + "px").css('overflow-y','hidden');
    }).on("input", function () {
      this.style.height = "auto";
      this.style.height = (Math.max(38, this.scrollHeight)) + "px";
    });

    $("textarea.one-line").keydown(function(e){
      if (e.keyCode == 13 && !e.shiftKey) e.preventDefault();
    });

    setInterval(autoSaveFun,10000);

  }, 250);
 
  $('[data-bs-toggle="popover"]').popover();

  createModalListeners(".modal");
  if($(location.hash).hasClass("modal")) setTimeout(function() {
    $(location.hash).modal('show');
  }, 100); 

});

// -------- Tom Select presets --------

var ts_sort_text_asc_max_null = {
  sortField: {
    field: "text",
    direction: "asc"
  },
  maxItems: null,
  maxOptions: null
};

ts_max_null = {
  maxItems: null,
  maxOptions: null
};

var ts_sort_text_asc_max_1 = {
  sortField: {
    field: "text",
    direction: "asc"
  },
  maxItems: 1,
  maxOptions: null
};

var ts_sort_text_asc_max_1_create = {
  sortField: {
    field: "text",
     direction: "asc"
  },
  maxItems: 1,
  create: true,
  maxOptions: null
};
