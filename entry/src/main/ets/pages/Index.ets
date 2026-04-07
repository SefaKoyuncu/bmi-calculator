import CheckBox from '../components/CheckBox';
import Header from '../components/Header';
import { TabPage } from './TabPage';
import { HistoryPage } from './HistoryPage';
import { DBManager } from '../utils/DBManager';
import { vibrator } from '@kit.SensorServiceKit';
import { CustomValuePickerDialog } from '../components/CustomValuePickerDialog';

@Entry
@Component
struct Index {
  @State weightValue: number = 70
  @State heightValue: number = 170
  @State isMale: boolean = true
  @State focusOnWeight: boolean = true
  @Provide('NavPathStack') pageStack: NavPathStack = new NavPathStack()

  weightDialogController: CustomDialogController = new CustomDialogController({
    builder: CustomValuePickerDialog({
      title: $r('app.string.weight'),
      range: this.generateRange(30, 200),
      selectedIndex: this.weightValue - 30,
      confirm: (val: string) => {
        this.weightValue = parseInt(val)
      }
    }),
    alignment: DialogAlignment.Center,
    customStyle: true
  })

  heightDialogController: CustomDialogController = new CustomDialogController({
    builder: CustomValuePickerDialog({
      title: $r('app.string.height'),
      range: this.generateRange(100, 250),
      selectedIndex: this.heightValue - 100,
      confirm: (val: string) => {
        this.heightValue = parseInt(val)
      }
    }),
    alignment: DialogAlignment.Center,
    customStyle: true
  })

  @Builder
  PagesMap(name: string) {
    if (name === 'TabPage') {
      TabPage()
    } else if (name === 'HistoryPage') {
      HistoryPage()
    }
  }

  build() {
    Navigation(this.pageStack) {
      Column() {
        Header()

        CheckBox({ isMale: $isMale })
          .margin({ bottom: '10vp' })

        List({ space: 10 }) {
          ListItem() {
            Row() {
              Text($r('app.string.weight'))
                .fontSize('14fp')
                .fontColor(this.focusOnWeight ? $r('app.color.accent_color') : $r('app.color.text_secondary'))
              Blank()
              Text(`${this.weightValue} kg`)
                .fontSize('16fp')
                .fontColor(this.focusOnWeight ? $r('app.color.accent_color') : $r('app.color.text_primary'))
                .fontWeight(FontWeight.Medium)
            }
            .width('100%')
            .padding('12vp')
            .backgroundColor(this.focusOnWeight ? '#3337a1e0' : '#1AFFFFFF')
            .borderRadius('20vp')
            .borderWidth(this.focusOnWeight ? 2 : 0)
            .borderColor($r('app.color.accent_color'))
            .onClick(() => {
              this.focusOnWeight = true
              this.weightDialogController.open()
            })
          }

          ListItem() {
            Row() {
              Text($r('app.string.height'))
                .fontSize('14fp')
                .fontColor(!this.focusOnWeight ? $r('app.color.accent_color') : $r('app.color.text_secondary'))
              Blank()
              Text(`${this.heightValue} cm`)
                .fontSize('16fp')
                .fontColor(!this.focusOnWeight ? $r('app.color.accent_color') : $r('app.color.text_primary'))
                .fontWeight(FontWeight.Medium)
            }
            .width('100%')
            .padding('12vp')
            .backgroundColor(!this.focusOnWeight ? '#3337a1e0' : '#1AFFFFFF')
            .borderRadius('20vp')
            .borderWidth(!this.focusOnWeight ? 2 : 0)
            .borderColor($r('app.color.accent_color'))
            .onClick(() => {
              this.focusOnWeight = false
              this.heightDialogController.open()
            })
          }

          ListItem() {
            Button($r('app.string.calculate'))
              .width('100%')
              .height('40vp')
              .backgroundColor($r('app.color.accent_color'))
              .onClick(async () => {
                let bmi = parseFloat((this.weightValue / ((this.heightValue / 100) ** 2)).toFixed(1))
                await DBManager.getInstance().insertRecord({
                  weight: this.weightValue,
                  height: this.heightValue,
                  bmi: bmi,
                  date: Date.now()
                })
                this.pageStack.pushPath({
                  name: 'TabPage',
                  param: bmi
                })
              })
          }
          .margin({ top: '10vp' })

          ListItem() {
            Button($r('app.string.history'))
              .width('100%')
              .height('40vp')
              .backgroundColor(Color.Transparent)
              .borderWidth('1vp')
              .borderColor($r('app.color.accent_color'))
              .fontColor($r('app.color.accent_color'))
              .onClick(() => {
                this.pageStack.pushPath({ name: 'HistoryPage' })
              })
          }
        }
        .width('90%')
        .flexGrow(1)
      }
      .width('100%')
      .height('100%')
      .onCrownEvent((event) => {
        if (this.focusOnWeight) {
          this.weightValue += event.degree > 0 ? 1 : -1
          this.weightValue = Math.max(30, Math.min(200, this.weightValue))
        } else {
          this.heightValue += event.degree > 0 ? 1 : -1
          this.heightValue = Math.max(100, Math.min(250, this.heightValue))
        }
        this.triggerHaptic()
      })
      .backgroundColor($r('app.color.background_color'))
    }
    .mode(NavigationMode.Stack)
    .hideTitleBar(true)
    .navDestination(this.PagesMap)
  }

  private triggerHaptic() {
    try {
      vibrator.startVibration({
        type: 'time',
        duration: 10,
      }, {
        id: 0,
        usage: 'touch'
      });
    } catch (err) {
      console.error('Haptic failed', JSON.stringify(err));
    }
  }

  generateRange(start: number, end: number): string[] {
    let range: string[] = []
    for (let i = start; i <= end; i++) {
      range.push(i.toString())
    }
    return range
  }
}
