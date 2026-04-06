import { TabPage } from './TabPage';
import { PreferencesUtil, BmiRecord } from '../utils/PreferencesUtil';
import common from '@ohos.app.ability.common';

@Entry
@Component
struct Index {
  @State weightValue: string = ''
  @State heightValue: string = ''
  @State bmi: number = 0
  @State unitSystem: string = 'metric' // 'metric' or 'imperial'
  @State history: BmiRecord[] = []
  @State showHistory: boolean = false
  @Provide('NavPathStack') pageStack: NavPathStack = new NavPathStack()
  private context = getContext(this) as common.UIAbilityContext;

  async aboutToAppear() {
    await PreferencesUtil.getInstance().init(this.context);
    this.unitSystem = await PreferencesUtil.getInstance().getUnitSystem();
    this.history = await PreferencesUtil.getInstance().getHistory();
  }

  @Builder
  PagesMap(name: string) {
    if (name === 'TabPage') {
      TabPage()
    }
  }

  async handleCalculate() {
    let w = parseFloat(this.weightValue);
    let h = parseFloat(this.heightValue);

    if (isNaN(w) || isNaN(h) || h <= 0) return;

    let finalBmi = 0;
    if (this.unitSystem === 'metric') {
      finalBmi = w / ((h / 100) ** 2);
    } else {
      // Imperial: BMI = 703 * weight(lb) / [height(in)]^2
      finalBmi = 703 * w / (h ** 2);
    }

    this.bmi = parseFloat(finalBmi.toFixed(1));
    await PreferencesUtil.getInstance().saveBmiRecord(this.bmi);
    this.history = await PreferencesUtil.getInstance().getHistory();

    this.pageStack.pushPath({
      name: 'TabPage',
      param: this.bmi
    })
  }

  async toggleUnit() {
    this.unitSystem = this.unitSystem === 'metric' ? 'imperial' : 'metric';
    await PreferencesUtil.getInstance().setUnitSystem(this.unitSystem);
    this.weightValue = '';
    this.heightValue = '';
  }

  build() {
    Navigation(this.pageStack) {
      Scroll() {
        Column({ space: 10 }) {
          Text($r('app.string.header'))
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
            .margin({ top: 20 })

          // Unit Switcher
          Button(this.unitSystem === 'metric' ? $r('app.string.unit_metric') : $r('app.string.unit_imperial'))
            .fontSize(10)
            .height(25)
            .backgroundColor(Color.Gray)
            .onClick(() => this.toggleUnit())

          // Input Fields
          Row() {
            Text($r('app.string.weight_label'))
              .fontSize(12)
              .width('30%')
            TextInput({
              placeholder: this.unitSystem === 'metric' ? $r('app.string.weight_placeholder_metric') : $r('app.string.weight_placeholder_imperial'),
              text: this.weightValue
            })
              .fontSize(12)
              .width('70%')
              .type(InputType.Number)
              .onChange(val => this.weightValue = val)
          }.width('90%')

          Row() {
            Text($r('app.string.height_label'))
              .fontSize(12)
              .width('30%')
            TextInput({
              placeholder: this.unitSystem === 'metric' ? $r('app.string.height_placeholder_metric') : $r('app.string.height_placeholder_imperial'),
              text: this.heightValue
            })
              .fontSize(12)
              .width('70%')
              .type(InputType.Number)
              .onChange(val => this.heightValue = val)
          }.width('90%')

          Button($r('app.string.calculate_btn'))
            .width('80%')
            .height(30)
            .backgroundColor($r('app.color.blue_color'))
            .onClick(() => this.handleCalculate())

          if (this.history.length > 0) {
            Button($r('app.string.history_btn'))
              .width('80%')
              .height(30)
              .backgroundColor(Color.Orange)
              .onClick(() => this.showHistory = !this.showHistory)
          }

          if (this.showHistory) {
            Column() {
              Text($r('app.string.history_title'))
                .fontSize(14)
                .fontWeight(FontWeight.Bold)
                .margin({ top: 10 })

              ForEach(this.history, (item: BmiRecord) => {
                Row() {
                  Text(item.date.split(',')[0])
                    .fontSize(10)
                    .layoutWeight(1)
                  Text(`BMI: ${item.bmi}`)
                    .fontSize(10)
                    .fontWeight(FontWeight.Bold)
                }
                .width('90%')
                .padding(5)
              }, (item: BmiRecord) => item.date + item.bmi)
            }
          }
        }
        .width('100%')
        .padding({ bottom: 20 })
      }
    }
    .mode(NavigationMode.Stack)
    .hideTitleBar(true)
    .navDestination(this.PagesMap)
    .width('100%')
    .height('100%')
    .backgroundColor(Color.White)
  }
}
