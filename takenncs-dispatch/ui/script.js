    $(document).ready(function() {
        menuOpen = false
        var calls = {}
        Functions = {}

        window.addEventListener('message', function (event) {
            var event = event.data;

            if (event.action === 'addCall') {
                Functions.CreateNotification(event.data)
            } else if (event.action === 'showCalls') {
                $.post("https://takenncs-dispatch/loadCalls", JSON.stringify({})); menuOpen = true 
            } else if (event.action === 'loadCalls') {
                Functions.LoadCalls(event.data)
            } else if (event.action === 'closeDispatch') {
                $.post("https://takenncs-dispatch/closeDispatch", JSON.stringify({})); menuOpen = false
                $('#content').children().fadeOut(500)
            } else if (event.action === 'addResponder') {
                let $notification

                $notification = $(`<div class="h-auto bg-gray-800 bg-opacity-90 text-white text-left px-1.5 py-1.5 text-base rounded border-gray-900 mt-2"><span class="bg-green-500 text-white text-xs font-semibold px-2.5 py-0.5 rounded">${event.data.id}</span><span class="bg-indigo-800 text-white text-xs font-semibold ml-1 px-2.5 py-0.5 mb-2 rounded">${event.data.call}</span><span class="text-white text-xs font-semibold ml-1 w-16 rounded">${event.data.worker}</span><br></div>`).hide().fadeIn(500)
        
                $('#workerLogs').prepend($notification)
        
                setTimeout(() => {
                    $($notification).fadeOut(500)
                }, 5000);
            }
        });

        Function.AcceptCall = function(id) {
            $.post("https://takenncs-dispatch/acceptCall", JSON.stringify({id: id}));
        }

        Functions.CreateNotification = function(data) {
            if (menuOpen) {
                $.post("https://takenncs-dispatch/loadCalls", JSON.stringify({}));
            } else {
                let $notification

                $notification = $(`<div class="w-96 h-auto bg-gray-800 bg-opacity-90 text-white text-left px-1.5 py-1.5 text-base rounded-l border-r-6 border-gray-900 mt-2"><button onclick="Function.AcceptCall(${data.id})" class="absolute right-0 mr-4"><i class="fa-solid fa-location-dot fa-2x"></i></button><span class="bg-green-500 text-white text-xs font-semibold px-2.5 py-0.5 rounded">${data.id}</span><span class="bg-indigo-800 text-white text-xs font-semibold ml-1 px-2.5 py-0.5 mb-2 rounded">${data.call}</span><span class="text-white text-xs font-semibold ml-1 w-16 rounded">${data.description}</span><br><i class="fa-solid fa-earth-europe fa-sm mt-4"></i><span class="px-1 text-white text-xs">${data.location}</span><br></div>`).hide().fadeIn(500)
        
                $('#content').prepend($notification)
        
                if (menuOpen === false) {
                    setTimeout(() => {
                        $($notification).fadeOut(500)
                    }, 3000);
                }
            }
        }

        Functions.LoadCalls = function(calls) {
            $($("#content")).html("");
        
            if (calls !== null) {
                $.each(calls, function(k,v){
                    let $item = $(`<div class="w-96 h-auto bg-gray-800 bg-opacity-90 text-white text-left px-1.5 py-1.5 text-base rounded-l border-r-6 border-gray-900 mt-2"><button onclick="Function.AcceptCall(${v.id})" class="absolute right-0 mr-4"><i class="fa-solid fa-location-dot fa-2x"></i></button><span class="bg-green-500 text-white text-xs font-semibold px-2.5 py-0.5 rounded">${v.id}</span><span class="bg-indigo-800 text-white text-xs font-semibold ml-1 px-2.5 py-0.5 mb-2 rounded">${v.call}</span><span class="text-white text-xs font-semibold ml-1 w-16 rounded">${v.description}</span><br><i class="fa-solid fa-earth-europe fa-sm mt-4"></i><span class="px-1 text-white text-xs">${v.location}</span><br></div>`).hide().fadeIn(500)

                    $($("#content")).prepend($item);
                });
            }
        }
    })