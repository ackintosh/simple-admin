$('#modal-from-dom').bind('show', function() {
    var id = $(this).data('id');
    var removeBtn = $(this).find('#danger');
    removeBtn.attr('rel', id);
})

$('.confirm-delete').click(function(e) {
    e.preventDefault();
    
    var id = $(this).data('id');
    $('#modal-from-dom').data('id', id).modal('show');
});

$('#danger').click(function(e) {
  var formId = 'frm' + $(this).attr('rel');
  $('#'+formId).submit();
})
