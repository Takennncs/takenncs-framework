function hideMenu() {
    let event = new MessageEvent('message', {
        data: {
            action: 'hideMenu'
        }
    });

    window.dispatchEvent(event);
    $.post("https://takenncs-dmv/disableFocus", JSON.stringify({}));
}

$(document).ready(function () {
    // ESC keypress to close the menu
    $(document).keydown(function (event) {
        var keycode = (event.keyCode ? event.keyCode : event.which);
        if (keycode == '27') {
            hideMenu();
        }
    });

    $(document).on('click', '#examButton', function () {
        hideMenu();
        $.post("https://takenncs-dmv/startExam", JSON.stringify({}));
    });
});