const { environment } = require('@rails/webpacker')
const coffee =  require('./loaders/coffee')
const elm =  require('./loaders/elm')
const typescript =  require('./loaders/typescript')

environment.loaders.append('typescript', typescript)
environment.loaders.append('elm', elm)
environment.loaders.append('coffee', coffee)
module.exports = environment
