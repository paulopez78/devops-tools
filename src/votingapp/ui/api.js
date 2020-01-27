const votingApi = (function () {
    const apiUrl = `//${window.location.host}/vote`;

    const client = (url, method, body) =>
        fetch(url, { method, headers: { Accept: 'application/json', 'Content-Type': 'application/json' }, body });

    const get = () =>
        client(apiUrl, 'GET')
            .then(r => r.json());

    const start = (topics) =>
        client(apiUrl, 'POST', JSON.stringify({ topics: topics }))
            .then(r => r.json());

    const finish = () =>
        client(apiUrl, 'DELETE')
            .then(r => r.json());

    const vote = (topic) =>
        client(apiUrl, 'PUT', JSON.stringify({ topic: topic }))
            .then(r => r.json());

    const subscribe = (action) => {
        const webSocket = new WebSocket(`ws://${window.location.host}/ws`);
        webSocket.onmessage = ({ data }) => {
            action(JSON.parse(data));
        }
    }

    return {
        get,
        start,
        finish,
        vote,
        subscribe
    }
})();