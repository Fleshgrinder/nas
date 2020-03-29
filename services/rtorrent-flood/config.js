const Config = {
    baseURI: '/',
    dbCleanInterval: 86400,
    dbPath: '/usr/src/app/config/server/db/',
    floodServerHost: '127.0.0.1',
    floodServerPort: 3000,
    maxHistoryStates: 30,
    pollInterval: 50,
    secret: process.env.FLOOD_SECRET,
    scgi: {
        socket: true,
        socketPath: '/usr/src/app/config/rtorrent/rpc.sock',
    },
    ssl: false,
};

module.exports = Config;
