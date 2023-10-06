import 'package:net_source/net_source.dart';

final initialScript = [
  '''
CREATE TABLE users(id INTEGER, name TEXT, phoneNumber TEXT, email TEXT, photoURL TEXT, displayName TEXT, uid TEXT, emailVerified INTEGER, isAnonymous INTEGER, details TEXT, otherData TEXT, PRIMARY KEY(id, uid, email, displayName, phoneNumber, details, otherData ))
         ''',
  '''
CREATE TABLE expenses(id INTEGER, date TEXT, amount TEXT, category TEXT, image TEXT, description TEXT, location TEXT, user_uid TEXT, PRIMARY KEY(id, amount))
         ''',
  '''
CREATE TABLE expense_category(id INTEGER, parent INTEGER, name TEXT, description TEXT, user_uid TEXT, PRIMARY KEY(id, name))
         ''',
];
final migrations = <String>[
  // '''
  //   ALTER TABLE trips ADD COLUMN pause_id INTEGER;
  //   ''',
];
final kConfig = Config(
  baseUrl: '',
  socketUrl: '',
  host: '',
  dbName: 'my_expense_tracker.prod.db',
  initScript: initialScript,
  migrations: migrations,
);

final kDevConfig = Config(
  baseUrl: '',
  socketUrl: '',
  host: '',
  dbName: 'my_expense_tracker.dev.db',
  initScript: initialScript,
  migrations: migrations,
);
