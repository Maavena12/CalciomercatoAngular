class DebugLogger {
  static bigLog({ name, data }) {
    console.log('\n\n\n\n\n<----------------------->\n')
    console.log(name, data)
    console.log('\n<----------------------->\n\n\n\n\n')
  }
}

export default DebugLogger