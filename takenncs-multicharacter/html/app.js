$(document).ready(function() {
    console.log('[takenncs-multicharacter] takenncs-multicharacter loaded');
    
    let currentCharacter = null;
    let totalCharacters = 0;
    let maxCharacters = 5;
    let canCreate = false;

    window.addEventListener('message', function(event) {
        const data = event.data;

        switch(data.action) {
            case 'update':
                updateCharacterInfo(data.character, data.totalCharacters, data.maxCharacters, data.canCreate);
                break;
            case 'showCreator':
                showCreator();
                break;
            case 'closeCreator':
                hideCreator();
                break;
            case 'error':
                showError(data.message);
                break;
            case 'close':
                closeAll();
                break;
        }
    });

    function updateCharacterInfo(character, total, max, canCreateFlag) {
        
        currentCharacter = character;
        totalCharacters = total || 0;
        maxCharacters = max || 5;
        canCreate = canCreateFlag || false;

        $('#character-creator').addClass('hidden');
        
        if (totalCharacters > 0) {
            $('#character-select').removeClass('hidden');
            
            if (character && character.data) {
                const charData = character.data;
                
                $('#character-name').text(charData.name || 'Vaba Koht');
                $('#character-pid').text(charData.citizenid || '-');
                $('#character-job').text(charData.job || 'Töötu');
                
                // Formaadi kuupäev kenasti
                if (charData.dob && charData.dob !== '-') {
                    if (!isNaN(charData.dob) && charData.dob.length > 8) {
                        const date = new Date(parseInt(charData.dob));
                        const year = date.getFullYear();
                        const month = String(date.getMonth() + 1).padStart(2, '0');
                        const day = String(date.getDate()).padStart(2, '0');
                        $('#character-dob').text(year + '-' + month + '-' + day);
                    } else {
                        $('#character-dob').text(charData.dob);
                    }
                } else {
                    $('#character-dob').text('-');
                }
                
                if (charData.sex === 'male') {
                    $('#character-sex').text('Mees');
                } else if (charData.sex === 'female') {
                    $('#character-sex').text('Naine');
                } else {
                    $('#character-sex').text('-');
                }
            }
            
            $('#total-chars').text(totalCharacters + '/' + maxCharacters);
        } else {
            $('#character-select').addClass('hidden');
            $('#nochar').removeClass('hidden');
        }
    }

    function showCreator() {
        $('#character-select').addClass('hidden');
        $('#nochar').addClass('hidden');
        $('#character-creator').removeClass('hidden');
        $('#error').addClass('hidden');
        
        // Tühjenda väljad
        $('#firstname').val('');
        $('#lastname').val('');
        
        const today = new Date();
        const defaultDate = new Date(today.getFullYear() - 18, today.getMonth(), today.getDate());
        const year = defaultDate.getFullYear();
        const month = String(defaultDate.getMonth() + 1).padStart(2, '0');
        const day = String(defaultDate.getDate()).padStart(2, '0');
        $('#birthdate').val(year + '-' + month + '-' + day);
        
        $('#gender').val('m');
    }

    function hideCreator() {
        $('#character-creator').addClass('hidden');
        
        if (totalCharacters > 0) {
            $('#character-select').removeClass('hidden');
        } else {
            $('#nochar').removeClass('hidden');
        }
        
        $('#error').addClass('hidden');
    }

    function closeAll() {
        $('#character-select').addClass('hidden');
        $('#character-creator').addClass('hidden');
        $('#nochar').addClass('hidden');
        $('#error').addClass('hidden');
    }

    function showError(message) {
        $('#reason').text(message);
        $('#error').removeClass('hidden');
        
        setTimeout(function() {
            $('#error').addClass('hidden');
        }, 5000);
    }

    function validateName(name) {
        const nameRegex = /^[a-zA-ZÕÄÖÜõäöü]+$/;
        return nameRegex.test(name);
    }

    function handleButtonClick(button) {
        button.classList.add('active-click');
        setTimeout(() => {
            button.classList.remove('active-click');
        }, 150);
    }

    $('#left-btn').on('click', function() {
        handleButtonClick(this);
        fetch('https://takenncs-multicharacter/left', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({})
        });
    });

    $('#right-btn').on('click', function() {
        handleButtonClick(this);
        fetch('https://takenncs-multicharacter/right', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({})
        });
    });

    $('#play-btn').on('click', function() {
        handleButtonClick(this);
        fetch('https://takenncs-multicharacter/play', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({})
        });
    });

    $('#create-btn, #register').on('click', function() {
        handleButtonClick(this);
        showCreator();
    });

$('#create-submit').on('click', function() {
    handleButtonClick(this);
    
    const firstname = $('#firstname').val().trim();
    const lastname = $('#lastname').val().trim();
    const birthdate = $('#birthdate').val();
    const gender = $('#gender').val();

    if (!firstname || firstname.length < 2 || firstname.length > 20) {
        showError('Eesnimi peab olema 2-20 tähemärki pikk!');
        return;
    }

    if (!lastname || lastname.length < 2 || lastname.length > 20) {
        showError('Perekonnanimi peab olema 2-20 tähemärki pikk!');
        return;
    }

    if (!birthdate) {
        showError('Palun vali sünniaeg!');
        return;
    }

    if (!validateName(firstname)) {
        showError('Eesnimi tohib sisaldada ainult tähti!');
        return;
    }

    if (!validateName(lastname)) {
        showError('Perekonnanimi tohib sisaldada ainult tähti!');
        return;
    }

    const birthYear = parseInt(birthdate.split('-')[0]);
    const currentYear = new Date().getFullYear();
    const age = currentYear - birthYear;
    
    if (age < 16 || age > 100) {
        showError('Vanus peab olema 16-100 aastat!');
        return;
    }

    const data = {
        firstname: firstname,
        lastname: lastname,
        dob: birthdate,
        gender: gender
    };

    fetch('https://takenncs-multicharacter/createCharacter', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(data)
    })
    .then(response => response.json())
    .then(result => {
        if (result.success) {
            // Hide creator immediately
            hideCreator();
            
            // The client-side Lua will handle the rest
            // No need to do anything else here
            console.log('Character created successfully, waiting for server...');
        } else {
            showError(result.error || 'Karakteri loomine ebaõnnestus');
        }
    })
    .catch(error => {
        console.error('Error:', error);
        showError('Viga serveriga suhtlemisel');
    });
});


    $('#cancel-btn').on('click', function() {
        handleButtonClick(this);
        fetch('https://takenncs-multicharacter/cancel', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({})
        });
        hideCreator();
    });

    fetch('https://takenncs-multicharacter/ready', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({})
    });
    
});