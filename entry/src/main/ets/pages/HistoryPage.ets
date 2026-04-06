import { DBManager, BmiRecord } from '../utils/DBManager';

@Entry
@Component
export struct HistoryPage {
  @State records: BmiRecord[] = [];
  @Consume('NavPathStack') pageStack: NavPathStack;

  async aboutToAppear() {
    this.records = await DBManager.getInstance().getAllRecords();
  }

  formatDate(timestamp: number): string {
    const date = new Date(timestamp);
    return `${date.getFullYear()}/${date.getMonth() + 1}/${date.getDate()} ${date.getHours()}:${date.getMinutes()}`;
  }

  build() {
    NavDestination() {
      Column() {
        Row() {
          Text($r('app.string.history'))
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
            .fontColor(Color.White)
        }
        .width('100%')
        .padding({ top: 40, bottom: 10 })
        .justifyContent(FlexAlign.Center)

        if (this.records.length === 0) {
          Column() {
            Text('Empty')
              .fontColor($r('app.color.text_secondary'))
              .fontSize(14)
          }
          .justifyContent(FlexAlign.Center)
          .layoutWeight(1)
        } else {
          List({ space: 12 }) {
            ForEach(this.records, (record: BmiRecord) => {
              ListItem() {
                Row() {
                  Column() {
                    Text(`BMI: ${record.bmi}`)
                      .fontSize(16)
                      .fontWeight(FontWeight.Bold)
                      .fontColor($r('app.color.blue_color'))
                    Text(this.formatDate(record.timestamp))
                      .fontSize(10)
                      .fontColor($r('app.color.text_secondary'))
                      .margin({ top: 4 })
                  }
                  .alignItems(HorizontalAlign.Start)

                  Blank()

                  Column() {
                    Text(`${record.weight}kg`)
                      .fontSize(12)
                      .fontColor(Color.White)
                    Text(`${record.height}cm`)
                      .fontSize(12)
                      .fontColor(Color.White)
                  }
                  .alignItems(HorizontalAlign.End)

                  Button({ type: ButtonType.Circle }) {
                    Image($r('sys.media.ohos_ic_public_delete'))
                      .width(16)
                      .height(16)
                      .fillColor($r('app.color.accent_red'))
                  }
                  .backgroundColor(Color.Transparent)
                  .margin({ left: 10 })
                  .onClick(async () => {
                    await DBManager.getInstance().deleteRecord(record.id);
                    this.records = await DBManager.getInstance().getAllRecords();
                  })
                }
                .width('90%')
                .padding(12)
                .backgroundColor('#1A1A1A')
                .borderRadius(15)
              }
            }, (record: BmiRecord) => record.id.toString())
          }
          .width('100%')
          .layoutWeight(1)
          .alignListItem(ListItemAlign.Center)
          .margin({ bottom: 40 })
        }
      }
      .width('100%')
      .height('100%')
      .backgroundColor(Color.Black)
    }
    .hideTitleBar(true)
  }
}
