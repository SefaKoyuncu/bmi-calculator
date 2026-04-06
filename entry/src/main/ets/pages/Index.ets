import { TabPage } from './TabPage';
import { HistoryPage } from './HistoryPage';
import Header from '../components/Header';
import { DBManager } from '../utils/DBManager';
import { ReminderManager } from '../utils/ReminderManager';
import { PreferencesUtil } from '../utils/PreferencesUtil';

@Component
export struct PickerItem {
  @Prop label: string;
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
    .width('100%')
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
  @State isReminderActive: boolean = false
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

    this.isReminderActive = await PreferencesUtil.getInstance().getValue('REMINDER_ACTIVE', false) as boolean;
  }

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
          .margin({ top: 30, bottom: 10 })

        List({ space: 10 }) {
          ListItem() {
            Row() {
              Text($r('app.string.female'))
                .fontSize(12)
                .fontColor(this.gender === 0 ? $r('app.color.blue_color') : Color.White)
              Radio({ value: 'female', group: 'gender' })
                .checked(this.gender === 0)
                .width(20)
                .height(20)
                .onChange((isChecked: boolean) => {
                  if (isChecked) this.gender = 0
                })

              Blank().width(20)

              Radio({ value: 'male', group: 'gender' })
                .checked(this.gender === 1)
                .width(20)
                .height(20)
                .onChange((isChecked: boolean) => {
                  if (isChecked) this.gender = 1
                })
              Text($r('app.string.male'))
                .fontSize(12)
                .fontColor(this.gender === 1 ? $r('app.color.blue_color') : Color.White)
            }
            .width('100%')
            .justifyContent(FlexAlign.Center)
          }

          ListItem() {
            PickerItem({
              label: 'Weight',
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
              label: 'Height',
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
              .height(40)
              .backgroundColor($r('app.color.blue_color'))
              .borderRadius(20)
              .onClick(() => {
                let bmi = this.weightValue / ((this.heightValue / 100)**2)
                this.pageStack.pushPath({
                  name: 'TabPage',
                  param: [bmi.toFixed(1), this.weightValue, this.heightValue]
                })
              })
          }
          .margin({ top: 10 })

          ListItem() {
            Button($r('app.string.history'))
              .width('90%')
              .height(40)
              .backgroundColor(Color.Transparent)
              .borderWidth(1)
              .borderColor($r('app.color.blue_color'))
              .fontColor($r('app.color.blue_color'))
              .fontSize(12)
              .borderRadius(20)
              .onClick(() => {
                this.pageStack.pushPath({ name: 'HistoryPage' })
              })
          }

          ListItem() {
            Row() {
               Text($r('app.string.reminders'))
                 .fontSize(12)
                 .fontColor(Color.White)
               Blank()
               Toggle({ type: ToggleType.Switch, isOn: this.isReminderActive })
                 .selectedColor($r('app.color.blue_color'))
                 .onChange(async (isOn: boolean) => {
                    this.isReminderActive = isOn
                    await PreferencesUtil.getInstance().putValue('REMINDER_ACTIVE', isOn);
                    if (isOn) {
                      await ReminderManager.getInstance().addWeeklyReminder(getContext(this))
                    } else {
                      await ReminderManager.getInstance().cancelAllReminders()
                    }
                 })
            }
            .width('90%')
            .padding(10)
            .backgroundColor('#1A1A1A')
            .borderRadius(12)
          }
        }
        .width('100%')
        .layoutWeight(1)
        .alignListItem(ListItemAlign.Center)
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
