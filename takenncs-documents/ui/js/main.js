$(function() {
    window.addEventListener('message', function(event) {
        switch (event.data.action) {
            case 'showId':
                $('#id-card').show();
                $('#firstname').text(event.data.userInfo.firstname || 'FN');
                $('#lastname').text(event.data.userInfo.lastname || 'LN');
                $('#sex').text(event.data.userInfo.sex || 'SEX');
                $('#dob').text(event.data.userInfo.dob || 'DOB');
                $('#pid').text(event.data.userInfo.pid || 'PID');
                if (event.data.userInfo.picture) {
                    $('#profilePicture').attr('src', event.data.userInfo.picture);
                }
                break;

            case 'hide':
                $('#id-card').hide();
                break;
        }
    });
});