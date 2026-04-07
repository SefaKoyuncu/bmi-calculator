@Component
export struct TabPage {
  @State bmiValue: number = 0;
  @Consume('NavPathStack') pageStack: NavPathStack;

  aboutToAppear() {
    const params = this.pageStack.getParamByName('TabPage')
    if (params && params.length > 0) {
      this.bmiValue = params[0] as number;
    }
  }

  build() {
    NavDestination() {
      Column() {
        Text($r('app.string.header'))
          .fontSize('14fp')
          .fontColor($r('app.color.text_secondary'))
          .margin({ top: '20vp' })

        Stack() {
          Gauge({ value: this.bmiValue, min: 10, max: 50 }) {
            Column() {
              Text(this.bmiValue.toString())
                .fontSize('28fp')
                .fontWeight(FontWeight.Bold)
                .fontColor($r('app.color.text_primary'))
              Text('BMI')
                .fontSize('12fp')
                .fontColor($r('app.color.text_secondary'))
            }
          }
          .startAngle(210)
          .endAngle(150)
          .colors([[0x3CAAFF, 0.2], [0x44E643, 0.2], [0xFDE912, 0.2], [0xFF9416, 0.2], [0xF60207, 0.2]])
          .strokeWidth(15)
          .width('180vp')
          .height('180vp')
        }
        .margin({ top: '10vp' })

        Text(this.getCategory())
          .fontSize('18fp')
          .fontWeight(FontWeight.Bold)
          .fontColor(this.getCategoryColor())
          .margin({ top: '5vp' })

        Scroll() {
          Text(this.getMessage())
            .fontSize('14fp')
            .fontColor($r('app.color.text_primary'))
            .textAlign(TextAlign.Center)
            .padding({ left: '20vp', right: '20vp' })
        }
        .flexGrow(1)
        .margin({ top: '10vp', bottom: '20vp' })
      }
      .width('100%')
      .height('100%')
      .backgroundColor($r('app.color.background_color'))
    }
    .hideTitleBar(true)
  }

  private getCategory(): string {
    if (this.bmiValue < 18.5) return 'Underweight';
    if (this.bmiValue < 25.0) return 'Normal';
    if (this.bmiValue < 30.0) return 'Overweight';
    if (this.bmiValue < 35.0) return 'Obese Class I';
    return 'Obese Class II';
  }

  private getCategoryColor(): Color | string {
    if (this.bmiValue < 18.5) return '#3CAAFF';
    if (this.bmiValue < 25.0) return '#44E643';
    if (this.bmiValue < 30.0) return '#FDE912';
    if (this.bmiValue < 35.0) return '#FF9416';
    return '#F60207';
  }

  private getMessage(): string {
    if (this.bmiValue < 18.5) return 'Your journey to strength starts here—small steps can lead to powerful transformations!';
    if (this.bmiValue < 25.0) return 'You are in a great place—keep up the balance and stay strong and energized!';
    if (this.bmiValue < 30.0) return 'Every healthy choice counts—you are closer to your goals than you think!';
    return 'You have the power to change your story—every effort is a step toward a brighter, healthier future!';
  }
}
