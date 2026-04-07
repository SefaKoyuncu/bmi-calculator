import { DBManager, BMIRecord } from '../utils/DBManager';

@Component
export struct HistoryPage {
  @State records: BMIRecord[] = [];

  async aboutToAppear() {
    this.records = await DBManager.getInstance().queryAll();
  }

  build() {
    NavDestination() {
      Column() {
        Text($r('app.string.history'))
          .fontSize('16fp')
          .fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.text_primary'))
          .margin({ top: '15vp', bottom: '10vp' })

        if (this.records.length === 0) {
          Column() {
            Text('No records found')
              .fontSize('14fp')
              .fontColor($r('app.color.text_secondary'))
          }
          .flexGrow(1)
          .justifyContent(FlexAlign.Center)
        } else {
          List({ space: 8 }) {
            ForEach(this.records, (item: BMIRecord) => {
              ListItem() {
                Row() {
                  Column() {
                    Text(this.formatDate(item.date))
                      .fontSize('12fp')
                      .fontColor($r('app.color.text_secondary'))
                    Text(`${item.weight}kg / ${item.height}cm`)
                      .fontSize('14fp')
                      .fontColor($r('app.color.text_primary'))
                      .margin({ top: '2vp' })
                  }
                  .alignItems(HorizontalAlign.Start)

                  Blank()

                  Text(item.bmi.toString())
                    .fontSize('18fp')
                    .fontWeight(FontWeight.Bold)
                    .fontColor(this.getCategoryColor(item.bmi))
                }
                .width('100%')
                .padding('10vp')
                .backgroundColor('#1AFFFFFF')
                .borderRadius('15vp')
              }
            }, (item: BMIRecord) => item.id?.toString())
          }
          .width('90%')
          .flexGrow(1)
          .margin({ bottom: '20vp' })
        }
      }
      .width('100%')
      .height('100%')
      .backgroundColor($r('app.color.background_color'))
    }
    .hideTitleBar(true)
  }

  private formatDate(timestamp: number): string {
    let date = new Date(timestamp);
    return `${date.getMonth() + 1}/${date.getDate()} ${date.getHours()}:${date.getMinutes().toString().padStart(2, '0')}`;
  }

  private getCategoryColor(bmi: number): string {
    if (bmi < 18.5) return '#3CAAFF';
    if (bmi < 25.0) return '#44E643';
    if (bmi < 30.0) return '#FDE912';
    if (bmi < 35.0) return '#FF9416';
    return '#F60207';
  }
}
