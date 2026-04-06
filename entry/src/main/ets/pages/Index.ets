import { TabPage } from './TabPage';
import { HistoryPage } from './HistoryPage';
import { SettingsPage } from './SettingsPage';
import Header from '../components/Header';
import { DBManager } from '../utils/DBManager';
import { PreferencesUtil } from '../utils/PreferencesUtil';

@Component
export struct PickerItem {
  @Prop label: Resource;
  @Prop value: string;
  @Prop unit: string;
  onClickAction: () => void = () => {};

  build() {
    Column() {
      Text(this.label)
        .fontSize(10)
        .fontColor($r('app.color.text_secondary'))
      Row() {
        Text(this.value)
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.blue_color'))
        Text(this.unit)
          .fontSize(10)
          .fontColor($r('app.color.text_secondary'))
          .margin({ left: 4, top: 8 })
      }
    }
    .width('90%')
    .padding(8)
    .backgroundColor('#1A1A1A')
    .borderRadius(12)
    .onClick(() => {
      this.onClickAction();
    })
  }
}

@Entry
@Component
struct Index {
  @State weightValue: number = 70
  @State heightValue: number = 170
  @State gender: number = 1 // 0 for female, 1 for male
  @Provide('NavPathStack') pageStack: NavPathStack = new NavPathStack()

  private weights: string[] = []
  private heights: string[] = []

  async aboutToAppear() {
    for (let i = 20; i <= 200; i++) {
      this.weights.push(i.toString())
    }
    for (let i = 50; i <= 250; i++) {
      this.heights.push(i.toString())
    }

    const context = getContext(this);
    await DBManager.getInstance().init(context);
    await PreferencesUtil.getInstance().init(context);
  }

  @Builder
  PagesMap(name: string) {
    if (name === 'TabPage') {
      TabPage()
    } else if (name === 'HistoryPage') {
      HistoryPage()
    } else if (name === 'SettingsPage') {
      SettingsPage()
    }
  }

  build() {
    Navigation(this.pageStack) {
      Stack({ alignContent: Alignment.Bottom }) {
        Column() {
          Header()
            .margin({ top: 35, bottom: 5 })

          List({ space: 8 }) {
            ListItem() {
              Row() {
                Text($r('app.string.female'))
                  .fontSize(10)
                  .fontColor(this.gender === 0 ? $r('app.color.blue_color') : Color.White)
                Radio({ value: 'female', group: 'gender' })
                  .checked(this.gender === 0)
                  .width(18)
                  .height(18)
                  .onChange((isChecked: boolean) => {
                    if (isChecked) this.gender = 0
                  })

                Blank().width(15)

                Radio({ value: 'male', group: 'gender' })
                  .checked(this.gender === 1)
                  .width(18)
                  .height(18)
                  .onChange((isChecked: boolean) => {
                    if (isChecked) this.gender = 1
                  })
                Text($r('app.string.male'))
                  .fontSize(10)
                  .fontColor(this.gender === 1 ? $r('app.color.blue_color') : Color.White)
              }
              .width('100%')
              .justifyContent(FlexAlign.Center)
            }

            ListItem() {
              PickerItem({
                label: $r('app.string.weight'),
                value: this.weightValue.toString(),
                unit: 'kg',
                onClickAction: () => {
                  TextPickerDialog.show({
                    range: this.weights,
                    selected: this.weightValue - 20,
                    onAccept: (value: TextPickerResult) => {
                      this.weightValue = parseInt(value.value as string)
                    }
                  })
                }
              })
            }

            ListItem() {
              PickerItem({
                label: $r('app.string.height'),
                value: this.heightValue.toString(),
                unit: 'cm',
                onClickAction: () => {
                  TextPickerDialog.show({
                    range: this.heights,
                    selected: this.heightValue - 50,
                    onAccept: (value: TextPickerResult) => {
                      this.heightValue = parseInt(value.value as string)
                    }
                  })
                }
              })
            }

            ListItem() {
              Button($r('app.string.calculate'))
                .width('90%')
                .height(36)
                .backgroundColor($r('app.color.blue_color'))
                .borderRadius(18)
                .onClick(() => {
                  let bmi = this.weightValue / ((this.heightValue / 100)**2)
                  this.pageStack.pushPath({
                    name: 'TabPage',
                    param: [bmi.toFixed(1), this.weightValue, this.heightValue]
                  })
                })
            }
            .margin({ top: 5, bottom: 40 })
          }
          .width('100%')
          .layoutWeight(1)
          .alignListItem(ListItemAlign.Center)
        }
        .width('100%')
        .height('100%')

        Row() {
          Button({ type: ButtonType.Circle }) {
            SymbolGlyph($r('sys.symbol.clock_fill'))
              .fontSize(20)
              .fontColor([Color.White])
          }
          .width(36)
          .height(36)
          .backgroundColor('#262626')
          .onClick(() => {
            this.pageStack.pushPath({ name: 'HistoryPage' })
          })

          Blank().width(40)

          Button({ type: ButtonType.Circle }) {
            SymbolGlyph($r('sys.symbol.gear_shape_fill'))
              .fontSize(20)
              .fontColor([Color.White])
          }
          .width(36)
          .height(36)
          .backgroundColor('#262626')
          .onClick(() => {
            this.pageStack.pushPath({ name: 'SettingsPage' })
          })
        }
        .margin({ bottom: 15 })
      }
      .width('100%')
      .height('100%')
      .backgroundColor(Color.Black)
    }
    .mode(NavigationMode.Stack)
    .hideTitleBar(true)
    .navDestination(this.PagesMap)
    .width('100%')
    .height('100%')
  }
}
