class MyCurve {
  public title: string;
  public curve: Curve;
  public color: Color | string;
  public position: number;

  constructor(title: string, curve: Curve, color: Color | string = '', position: number) {
    this.title = title;
    this.curve = curve;
    this.color = color;
    this.position = position;
  }
}

const myCurves: MyCurve[] = [
  new MyCurve(' Linear', Curve.Linear, '#f60207', 162),
  new MyCurve(' Ease', Curve.Ease, '#ff9416', 120),
  new MyCurve(' EaseIn', Curve.EaseIn, '#fde912', 90),
  new MyCurve(' EaseOut', Curve.EaseOut, '#44e643', 54),
  new MyCurve(' EaseInOut', Curve.EaseInOut, '#3caaff', 18)
]

import { DBManager } from '../utils/DBManager';

@Component
export struct TabPage {
  @State dRotate: number = 0;
  @State bmiValue: string = '0';
  @State weight: number = 0;
  @State height: number = 0;
  @Consume('NavPathStack') pageStack: NavPathStack;

  aboutToAppear() {
    const params = this.pageStack.getParamByName('TabPage') as any[];
    const param = params[0];
    this.bmiValue = param[0];
    this.weight = param[1];
    this.height = param[2];

    let bmiNum = parseFloat(this.bmiValue);

    setTimeout(() => {
      if (!this.dRotate) {
        if (bmiNum < 18.5) {
          this.dRotate = 18;
        } else if (bmiNum < 24.9) {
          this.dRotate = 54;
        } else if (bmiNum < 29.9) {
          this.dRotate = 90;
        } else if (bmiNum < 39.9) {
          this.dRotate = 120;
        } else if (bmiNum >= 40.0) {
          this.dRotate = 162;
        }
      }
    }, 300);
  }

  build() {
    NavDestination() {
      Stack() {
        Image($r('app.media.table'))
          .width('100%')
          .height('100%')
          .objectFit(ImageFit.Contain)
          .opacity(0.8)

        ForEach(myCurves, (item: MyCurve) => {
          Column() {
            Row()
              .width(12)
              .height(12)
              .borderRadius(6)
              .backgroundColor(item.color)
              .shadow({ radius: 4, color: Color.Black, offsetX: 2, offsetY: 2 })
          }
          .width('100%')
          .height('100%')
          .rotate({ angle: this.dRotate - 90 })
          .animation({
            duration: 2000,
            curve: item.curve,
            delay: 100
          })
          .justifyContent(FlexAlign.Center)
        }, (item: MyCurve) => item.title)

        Column() {
          Text(`${this.bmiValue}`)
            .fontSize(24)
            .fontWeight(FontWeight.Bolder)
            .fontColor(Color.White)
            .shadow({ radius: 10, color: Color.Black })

          Text(this.getMessageBasedOnBMI())
            .fontSize(10)
            .fontColor($r('app.color.text_secondary'))
            .textAlign(TextAlign.Center)
            .width('70%')
            .margin({ top: 10 })

          Button($r('app.string.save'))
            .margin({ top: 15 })
            .width(80)
            .height(30)
            .backgroundColor($r('app.color.blue_color'))
            .onClick(async () => {
              await DBManager.getInstance().addRecord(this.bmiValue, this.weight, this.height);
              this.pageStack.pop()
            })
        }
        .justifyContent(FlexAlign.Center)
        .width('100%')
        .height('100%')
        .padding({ top: 60 })
      }
      .width('100%')
      .height('100%')
      .backgroundColor(Color.Black)
    }
    .hideTitleBar(true)
  }

  private getMessageBasedOnBMI(): string {
    const bmi = parseFloat(this.bmiValue);
    if (bmi < 18.5) {
      return 'Underweight - Take small steps to a stronger you!';
    } else if (bmi < 24.9) {
      return 'Healthy - Great balance, stay energized!';
    } else if (bmi < 29.9) {
      return 'Overweight - Every healthy choice counts!';
    } else if (bmi < 39.9) {
      return 'Obese - Consistency will lead you to health!';
    } else {
      return 'Extremely Obese - Every effort is a step forward!';
    }
  }
}
