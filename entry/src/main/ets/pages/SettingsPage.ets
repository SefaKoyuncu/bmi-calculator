import { PreferencesUtil } from '../utils/PreferencesUtil';
import { ReminderManager } from '../utils/ReminderManager';

@Entry
@Component
export struct SettingsPage {
  @State isReminderActive: boolean = false;
  @Consume('NavPathStack') pageStack: NavPathStack;

  async aboutToAppear() {
    await PreferencesUtil.getInstance().init(getContext(this));
    this.isReminderActive = await PreferencesUtil.getInstance().getValue('REMINDER_ACTIVE', false) as boolean;
  }

  build() {
    NavDestination() {
      Column() {
        Row() {
          Text($r('app.string.settings'))
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
            .fontColor(Color.White)
        }
        .width('100%')
        .padding({ top: 40, bottom: 20 })
        .justifyContent(FlexAlign.Center)

        List({ space: 12 }) {
          ListItem() {
            Row() {
              Text($r('app.string.reminders'))
                .fontSize(14)
                .fontColor(Color.White)
              Blank()
              Toggle({ type: ToggleType.Switch, isOn: this.isReminderActive })
                .selectedColor($r('app.color.blue_color'))
                .onChange(async (isOn: boolean) => {
                  this.isReminderActive = isOn;
                  await PreferencesUtil.getInstance().putValue('REMINDER_ACTIVE', isOn);
                  if (isOn) {
                    await ReminderManager.getInstance().addWeeklyReminder(getContext(this));
                  } else {
                    await ReminderManager.getInstance().cancelAllReminders();
                  }
                })
            }
            .width('90%')
            .padding(12)
            .backgroundColor('#1A1A1A')
            .borderRadius(15)
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
    .hideTitleBar(true)
  }
}
