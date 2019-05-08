const express = require('express')
const app = express()
const port = 8080

app.configure(() => {
    app.use(express.static(__dirname + '/static'));
});

app.get('/', function (req, res) {
    res.sendFile(__dirname + '/index.html');
});

app.listen(port, () => console.log(`Example app listening on port ${port}!`))