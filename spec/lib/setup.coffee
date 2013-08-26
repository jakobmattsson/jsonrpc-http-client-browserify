mocha.setup({ ui: 'bdd', timeout: 10000, ignoreLeaks: true })

window.reqSpec = (file) -> require('spec/' + file)
window.reqSrc = (file) -> require('src/' + file)
