import { FormExtensionAbility, formBindingData, formInfo } from '@kit.FormKit';
import { Want } from '@kit.AbilityKit';
import { DBManager } from '../utils/DBManager';

export default class WidgetCardAbility extends FormExtensionAbility {
  async onAddForm(want: Want): Promise<formBindingData.FormBindingData> {
    await DBManager.getInstance().init(this.context);
    const records = await DBManager.getInstance().getAllRecords();
    let latestBmi = 'N/A';
    let latestCategory = 'Enter Data';

    if (records.length > 0) {
      latestBmi = records[0].bmi;
      const bmi = parseFloat(latestBmi);
      if (bmi < 18.5) latestCategory = 'Underweight';
      else if (bmi < 24.9) latestCategory = 'Healthy';
      else if (bmi < 29.9) latestCategory = 'Overweight';
      else latestCategory = 'Obese';
    }

    const formData: Record<string, string> = {
      'bmi': latestBmi,
      'category': latestCategory
    };
    return formBindingData.createFormBindingData(formData);
  }

  onCastToNormalForm(formId: string): void {
  }

  onUpdateForm(formId: string): void {
  }

  onChangeFormVisibility(formEvents: Record<string, string>): void {
  }

  onFormEvent(formId: string, message: string): void {
  }

  onRemoveForm(formId: string): void {
  }

  onConfigurationUpdate(config: any): void {
  }

  onAcquireFormState(want: Want): formInfo.FormState {
    return formInfo.FormState.READY;
  }
}
