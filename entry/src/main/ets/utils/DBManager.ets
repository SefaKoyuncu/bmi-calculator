import { relationalStore } from '@kit.ArkData';
import { common } from '@kit.AbilityKit';

export interface BmiRecord {
  id: number;
  bmi: string;
  weight: number;
  height: number;
  timestamp: number;
}

export class DBManager {
  private static instance: DBManager;
  private rdbStore: relationalStore.RdbStore | undefined = undefined;
  private readonly TABLE_NAME = 'BMI_RECORDS';
  private context: common.Context | undefined = undefined;

  private constructor() {}

  public static getInstance(): DBManager {
    if (!DBManager.instance) {
      DBManager.instance = new DBManager();
    }
    return DBManager.instance;
  }

  public async init(context: common.Context): Promise<void> {
    this.context = context;
    if (this.rdbStore) return;

    const STORE_CONFIG: relationalStore.StoreConfig = {
      name: 'bmi_database.db',
      securityLevel: relationalStore.SecurityLevel.S1
    };

    const SQL_CREATE_TABLE = `CREATE TABLE IF NOT EXISTS ${this.TABLE_NAME} (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      bmi TEXT,
      weight REAL,
      height REAL,
      timestamp INTEGER
    )`;

    try {
      this.rdbStore = await relationalStore.getRdbStore(context, STORE_CONFIG);
      await this.rdbStore.executeSql(SQL_CREATE_TABLE);
    } catch (err) {
      console.error('DBManager init failed', JSON.stringify(err));
    }
  }

  public async addRecord(bmi: string, weight: number, height: number): Promise<void> {
    if (!this.rdbStore) return;

    const valueBucket: relationalStore.ValuesBucket = {
      'bmi': bmi,
      'weight': weight,
      'height': height,
      'timestamp': Date.now()
    };

    try {
      await this.rdbStore.insert(this.TABLE_NAME, valueBucket);
    } catch (err) {
      console.error('DBManager addRecord failed', JSON.stringify(err));
    }
  }

  public async getAllRecords(): Promise<BmiRecord[]> {
    if (!this.rdbStore) return [];

    let predicates = new relationalStore.RdbPredicates(this.TABLE_NAME);
    predicates.orderByDesc('timestamp');

    try {
      const resultSet = await this.rdbStore.query(predicates);
      const records: BmiRecord[] = [];
      while (resultSet.goToNextRow()) {
        records.push({
          id: resultSet.getLong(resultSet.getColumnIndex('id')),
          bmi: resultSet.getString(resultSet.getColumnIndex('bmi')),
          weight: resultSet.getDouble(resultSet.getColumnIndex('weight')),
          height: resultSet.getDouble(resultSet.getColumnIndex('height')),
          timestamp: resultSet.getLong(resultSet.getColumnIndex('timestamp'))
        });
      }
      resultSet.close();
      return records;
    } catch (err) {
      console.error('DBManager getAllRecords failed', JSON.stringify(err));
      return [];
    }
  }

  public async deleteRecord(id: number): Promise<void> {
    if (!this.rdbStore) return;
    let predicates = new relationalStore.RdbPredicates(this.TABLE_NAME);
    predicates.equalTo('id', id);
    await this.rdbStore.delete(predicates);
  }
}
