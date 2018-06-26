import './main.css';
import { Main } from './Main.elm';
import registerServiceWorker from './registerServiceWorker';

var app = Main.fullscreen(localStorage.session || null);

app.ports.storeSession.subscribe(function(session) {
    localStorage.session = session;
});

window.addEventListener(
    "storage",
    function(event) {
        if (event.storageArea === localStorage && event.key === "session") {
            app.ports.onSessionChange.send(event.newValue);
        }
    },
    false
);

registerServiceWorker();