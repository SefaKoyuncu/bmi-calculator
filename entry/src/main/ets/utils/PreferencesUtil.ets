import { preferences } from '@kit.ArkData';
import { common } from '@kit.AbilityKit';

export class PreferencesUtil {
  private static instance: PreferencesUtil;
  private pref: preferences.Preferences | undefined = undefined;
  private readonly PREF_NAME = 'BMI_PREFS';

  private constructor() {}

  public static getInstance(): PreferencesUtil {
    if (!PreferencesUtil.instance) {
      PreferencesUtil.instance = new PreferencesUtil();
    }
    return PreferencesUtil.instance;
  }

  public async init(context: common.Context): Promise<void> {
    try {
      this.pref = await preferences.getPreferences(context, this.PREF_NAME);
    } catch (err) {
      console.error('PreferencesUtil init failed', JSON.stringify(err));
    }
  }

  public async putValue(key: string, value: preferences.ValueType): Promise<void> {
    if (!this.pref) return;
    await this.pref.put(key, value);
    await this.pref.flush();
  }

  public async getValue(key: string, defaultValue: preferences.ValueType): Promise<preferences.ValueType> {
    if (!this.pref) return defaultValue;
    return await this.pref.get(key, defaultValue);
  }
}
