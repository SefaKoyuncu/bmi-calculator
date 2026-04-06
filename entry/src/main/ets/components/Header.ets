@Component
export default struct Header{
  build() {
    Text($r('app.string.header'))
      .fontSize(12)
      .fontColor(Color.White)
      .fontWeight(FontWeight.Bold)
      .backgroundColor($r('app.color.blue_color'))
      .borderRadius(6)
      .width('80%')
      .height('10%')
      .textAlign(TextAlign.Center)
  }
}
