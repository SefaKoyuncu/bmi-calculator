@Component
export default struct Header {
  build() {
    Row() {
      Text($r('app.string.header'))
        .fontSize(14)
        .fontColor(Color.White)
        .fontWeight(FontWeight.Bold)
    }
    .justifyContent(FlexAlign.Center)
    .backgroundColor($r('app.color.blue_color'))
    .borderRadius(20)
    .width('90%')
    .height(40)
  }
}
