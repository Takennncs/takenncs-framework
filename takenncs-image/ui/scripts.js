$(function() {
    var currentPlayer = 0;

    $(document).keydown(function (event) {
        var keycode = event.keyCode ? event.keyCode : event.which;

        if (keycode == 27) {
            $.post('https://takenncs-image/closeMenu', JSON.stringify({}));
        }
    });

    window.addEventListener("message", function (event) {
        var data = event.data;
    
        if (data.action === "openMenu") {
            $('body').show();
            currentPlayer = data.id;
            console.log('^2[Image] Opening menu for player:', currentPlayer);
        } else if (data.action === "closeMenu") {
            $('body').hide();
            currentPlayer = 0;
        }
    });
    
    $("#doScreenshot").click(function(){
        var offset = $('#image').offset();
        
        console.log('^2[Image] Taking screenshot for player:', currentPlayer);
        
        $.post('https://takenncs-image/postImage', JSON.stringify({
            top: Math.round(offset.top),
            left: Math.round(offset.left),
            player: currentPlayer
        }));
    });
    
    dragElement(document.getElementById("container"));
    
    function dragElement(elmnt) {
        var pos1 = 0, pos2 = 0, pos3 = 0, pos4 = 0;
        
        elmnt.onmousedown = dragMouseDown;

        function dragMouseDown(e) {
            e = e || window.event;
            e.preventDefault();
            pos3 = e.clientX;
            pos4 = e.clientY;
            document.onmouseup = closeDragElement;
            document.onmousemove = elementDrag;
        }

        function elementDrag(e) {
            e = e || window.event;
            e.preventDefault();
            pos1 = pos3 - e.clientX;
            pos2 = pos4 - e.clientY;
            pos3 = e.clientX;
            pos4 = e.clientY;
            elmnt.style.top = (elmnt.offsetTop - pos2) + "px";
            elmnt.style.left = (elmnt.offsetLeft - pos1) + "px";
        }

        function closeDragElement() {
            document.onmouseup = null;
            document.onmousemove = null;
        }
    }
});