$(function() {
	setInterval(function() {
		var id = $("input[name='id']").val();
		$.post (
			'/check',
			{
				'id': id
			}, function (result) {
				if (result == 'conflict') {
					$('#conflict-warning').show('slow');
				} else {
					$('#conflict-warning').hide('slow');
				}
			}
		);
	}, 3000);
})
