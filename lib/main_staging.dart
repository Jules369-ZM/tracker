import 'package:auth_repo/auth_repo.dart';
import 'package:my_expense_tracker/app/app.dart';
import 'package:my_expense_tracker/bootstrap.dart';
import 'package:my_expense_tracker/utils/app_config.dart';
import 'package:services_repo/services_repo.dart';

void main() {
  bootstrap(
    () async => App(
      authRepo: await AuthRepo.init(kDevConfig),
      servicesRepo: await ServicesRepo.init(kDevConfig),
    ),
  );
}
