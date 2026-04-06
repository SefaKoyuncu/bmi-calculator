let storage = new LocalStorage();

@Entry(storage)
@Component
struct WidgetCard {
  @LocalStorageProp('bmi') bmi: string = 'N/A';
  @LocalStorageProp('category') category: string = 'No Data';

  build() {
    Stack() {
      Image($r('app.media.icon')) // Placeholder for widget background
        .width('100%')
        .height('100%')
        .objectFit(ImageFit.Cover)
        .opacity(0.2)

      Column() {
        Text('Latest BMI')
          .fontSize(10)
          .fontColor('#999999')

        Text(this.bmi)
          .fontSize(24)
          .fontWeight(FontWeight.Bold)
          .fontColor('#37a1e0')
          .margin({ top: 2 })

        Text(this.category)
          .fontSize(10)
          .fontColor(Color.White)
          .backgroundColor('#333333')
          .padding({ left: 6, right: 6, top: 2, bottom: 2 })
          .borderRadius(10)
          .margin({ top: 4 })
      }
      .justifyContent(FlexAlign.Center)
    }
    .width('100%')
    .height('100%')
    .backgroundColor(Color.Black)
  }
}
