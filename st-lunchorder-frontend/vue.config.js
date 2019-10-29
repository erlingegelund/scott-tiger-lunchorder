module.exports = {
    devServer: {
        proxy: {
            '^/ords': {
                target: 'http://192.168.122.10:8080/'
            }
        }
    }
}