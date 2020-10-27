var wonderfulLife = "It's a wonderful life!"
var sampleJsonText = '{' +
                     '  "name": "Lily",' +
                     '  "breed": "Pug",' +
                     '  "age": 1' +
                     '}';

function printHelloWorld() {
    window.webkit.messageHandlers.test.postMessage(sampleJsonText);
}

window.onload = printHelloWorld;
