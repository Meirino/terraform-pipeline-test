const express = require('express')
const app = express()
const port = 3000
const api_controller = require('./controllers/API_controller');

app.configure(() => {
    app.use(express.static(__dirname + '/static'));
});

app.get('/', (req, res) => {
    res.sendFile(__dirname + '/index.html');
});

app.get('/api/hello', () => {
    api_controller.hello_world();
});

app.listen(port, () => console.log(`Example app listening on port ${port}!`))