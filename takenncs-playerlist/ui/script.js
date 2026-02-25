$('body,html').css("overflow","hidden");

function updateData(eventName, items) {
    let event = new CustomEvent(eventName, {
        detail: {
            items: items
        }
    });
    window.dispatchEvent(event);
}

function toggleMenuDisplay(state) {
	$("html").css({ display: state === true ? "block" : "none" });
}

$(document).ready(function () {
    $(document).keydown(function (event) {
        var keycode = (event.keyCode ? event.keyCode : event.which);
        if (keycode == '27') {
            toggleMenuDisplay(false);
            $.post("https://takenncs-playerlist/disableFocus", JSON.stringify({}));
        }
    });

    window.addEventListener('message', function (event) {
        var data = event.data;

        if (data.action === 'openMenu') {
            $('html').show(); 
            updateData('update-search-results', data.ply);
			$('#player_count').text(statusCounter(data.ply))
        } else if (data.action === 'closeMenu') {
            toggleMenuDisplay(false);
            $.post("https://takenncs-playerlist/disableFocus", JSON.stringify({}));
        }
    });

	function statusCounter(inputs) {
		let counter = 0;
		for (const input of inputs) {
		  	counter += 1;
		}
		return counter;
	}
});