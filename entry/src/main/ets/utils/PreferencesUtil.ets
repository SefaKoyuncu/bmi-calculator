import dataPreferences from '@ohos.data.preferences';
import common from '@ohos.app.ability.common';

const PREFERENCES_NAME = 'BMI_PREFS';
const HISTORY_KEY = 'BMI_HISTORY';
const UNIT_KEY = 'UNIT_SYSTEM'; // 'metric' or 'imperial'

export interface BmiRecord {
  bmi: number;
  date: string;
}

export class PreferencesUtil {
  private static instance: PreferencesUtil;
  private pref: dataPreferences.Preferences | null = null;

  private constructor() {}

  public static getInstance(): PreferencesUtil {
    if (!PreferencesUtil.instance) {
      PreferencesUtil.instance = new PreferencesUtil();
    }
    return PreferencesUtil.instance;
  }

  public async init(context: common.Context): Promise<void> {
    try {
      this.pref = await dataPreferences.getPreferences(context, PREFERENCES_NAME);
    } catch (err) {
      console.error('Failed to get preferences', err);
    }
  }

  public async saveBmiRecord(bmi: number): Promise<void> {
    if (!this.pref) return;
    try {
      let historyJson = await this.pref.get(HISTORY_KEY, '[]') as string;
      let history: BmiRecord[] = JSON.parse(historyJson);

      const newRecord: BmiRecord = {
        bmi: bmi,
        date: new Date().toLocaleString()
      };

      history.unshift(newRecord); // Add to the beginning
      if (history.length > 10) {
        history = history.slice(0, 10); // Keep only the last 10
      }

      await this.pref.put(HISTORY_KEY, JSON.stringify(history));
      await this.pref.flush();
    } catch (err) {
      console.error('Failed to save BMI record', err);
    }
  }

  public async getHistory(): Promise<BmiRecord[]> {
    if (!this.pref) return [];
    try {
      let historyJson = await this.pref.get(HISTORY_KEY, '[]') as string;
      return JSON.parse(historyJson);
    } catch (err) {
      console.error('Failed to get BMI history', err);
      return [];
    }
  }

  public async setUnitSystem(unit: string): Promise<void> {
    if (!this.pref) return;
    await this.pref.put(UNIT_KEY, unit);
    await this.pref.flush();
  }

  public async getUnitSystem(): Promise<string> {
    if (!this.pref) return 'metric';
    return await this.pref.get(UNIT_KEY, 'metric') as string;
  }
}
