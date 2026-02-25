document.addEventListener('alpine:init', () => {
    Alpine.data('notifyinter', () => ({
        instructionsActive: false,
        instructionHeader: '',
        instructionDescription: '',
        notifications: [],
        positionClass: '',

        interactActive: false,
        interactKey: '',
        interactText: '',

        addNotification(type, message, timer) {
            const isDuplicate = this.notifications.some(notification => 
                notification.type === type && notification.message === message
            );

            if (!isDuplicate) {
                const id = Date.now();
                this.notifications.push({ id, type, message });

                setTimeout(() => {
                    this.notifications = this.notifications.filter(notification => notification.id !== id);
                }, timer);
            }
        },

        init() {
            window.addEventListener('message', (event) => {
                const eventData = event.data;

                if (eventData.action === 'showInstruction') {
                    this.instructionsActive = true;
                    this.instructionHeader = eventData.data.title;
                    this.instructionDescription = eventData.data.description;

                    if(eventData.data.position === 'left-center') {
                        this.positionClass = 'top-1/2 left-0 transform -translate-y-1/2';
                    }
                } else if (eventData.action === 'hideInstruction') {
                    this.instructionsActive = false;
                    this.positionClass = '';
                } else if (eventData.action === 'showInteract') {
                    this.interactActive = true;
                    this.interactKey = eventData.data.key || '';
                    this.interactText = eventData.data.text || '';
                } else if (eventData.action === 'hideInteract') {
                    this.interactActive = false;
                    this.interactKey = '';
                    this.interactText = '';
                } else if(eventData.action === 'showNotification') {
                    this.addNotification(eventData.data.type, eventData.data.message, eventData.data.timer);
                }
            });
        }
    }));
});
