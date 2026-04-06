import { reminderAgentManager } from '@kit.BackgroundTasksKit';
import { notificationManager } from '@kit.NotificationKit';
import { common } from '@kit.AbilityKit';

export class ReminderManager {
  private static instance: ReminderManager;

  private constructor() {}

  public static getInstance(): ReminderManager {
    if (!ReminderManager.instance) {
      ReminderManager.instance = new ReminderManager();
    }
    return ReminderManager.instance;
  }

  public async addWeeklyReminder(context: common.Context): Promise<void> {
    // Note: In a real app, you'd check for notification permissions here.
    const targetReminder: reminderAgentManager.ReminderRequestCalendar = {
      reminderType: reminderAgentManager.ReminderType.REMINDER_TYPE_CALENDAR,
      dateTime: {
        year: 2024,
        month: 1,
        day: 1,
        hour: 10,
        minute: 0
      },
      repeatMonths: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12],
      daysOfWeek: [1], // Monday
      title: 'BMI Checkup',
      content: 'Time to record your BMI and track your health progress!',
      expiredContent: 'You missed your BMI checkup',
      snoozeContent: 'Remind me later',
      notificationId: 100,
      slotType: notificationManager.SlotType.SOCIAL_COMMUNICATION,
      wantAgent: {
        pkgName: 'com.example.bmicalculator',
        abilityName: 'EntryAbility'
      }
    };

    try {
      await reminderAgentManager.publishReminder(targetReminder);
    } catch (err) {
      console.error('ReminderManager publishReminder failed', JSON.stringify(err));
    }
  }

  public async cancelAllReminders(): Promise<void> {
    try {
      await reminderAgentManager.cancelAllReminders();
    } catch (err) {
      console.error('ReminderManager cancelAllReminders failed', JSON.stringify(err));
    }
  }
}
