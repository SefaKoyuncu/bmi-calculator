@Component
export struct TabPage {
  @State dRotate: number = 0;
  @State bmiValue: number = 0;
  @Consume('NavPathStack') pageStack: NavPathStack;

  aboutToAppear() {
    const params = this.pageStack.getParamByName('TabPage');
    if (params && params.length > 0) {
      this.bmiValue = params[0] as number;
    }

    setTimeout(() => {
      if (!this.dRotate) {
        if (this.bmiValue < 18.5) {
          this.dRotate = 18;
        } else if (this.bmiValue < 24.9) {
          this.dRotate = 54;
        } else if (this.bmiValue < 29.9) {
          this.dRotate = 90;
        } else if (this.bmiValue < 39.9) {
          this.dRotate = 120;
        } else if (this.bmiValue >= 40.0) {
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
          .padding({ bottom: 110 })

        // Gauge needle representation
        Column() {
          Row()
            .width(10)
            .height(10)
            .borderRadius(5)
            .backgroundColor(Color.Red)
            .clip(true)
        }
        .width('50%')
        .height('55%')
        .rotate({ angle: this.dRotate - 90 })
        .animation({
          duration: 2000,
          curve: Curve.EaseInOut,
          delay: 100
        })

        Column() {
          Text(`BMI: ${this.bmiValue}`)
            .fontSize(14)
            .fontWeight(FontWeight.Bold)
            .fontColor($r('app.color.blue_color'))

          Text(this.getCategoryName())
            .fontSize(12)
            .fontWeight(FontWeight.Bold)
            .fontColor(Color.Red)
            .margin({ top: 5 })

          Text(this.getMessageBasedOnBMI())
            .fontStyle(FontStyle.Italic)
            .fontSize(10)
            .fontWeight(FontWeight.Medium)
            .fontColor(Color.Black)
            .height('20%')
            .width('80%')
            .textAlign(TextAlign.Center)
            .margin({ top: 10 })

          Button('Back')
            .fontSize(10)
            .height(25)
            .margin({ top: 10 })
            .onClick(() => this.pageStack.pop())
        }
        .padding({ top: 40 })
      }
      .width('100%')
      .height('100%')
      .backgroundColor(Color.White)
    }
    .hideTitleBar(true)
  }

  private getCategoryName(): Resource {
    const bmi = this.bmiValue;
    if (bmi < 18.5) return $r('app.string.bmi_category_underweight');
    if (bmi < 24.9) return $r('app.string.bmi_category_normal');
    if (bmi < 29.9) return $r('app.string.bmi_category_overweight');
    if (bmi < 39.9) return $r('app.string.bmi_category_obese');
    return $r('app.string.bmi_category_extremely_obese');
  }

  private getMessageBasedOnBMI(): Resource {
    const bmi = this.bmiValue;
    if (bmi < 18.5) return $r('app.string.bmi_tip_underweight');
    if (bmi < 24.9) return $r('app.string.bmi_tip_normal');
    if (bmi < 29.9) return $r('app.string.bmi_tip_overweight');
    if (bmi < 39.9) return $r('app.string.bmi_tip_obese');
    return $r('app.string.bmi_tip_extremely_obese');
  }
}
