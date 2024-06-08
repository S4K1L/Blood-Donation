import 'package:blood_donation/core/utils/pref_utils.dart';

import '../app_export.dart';

class InitialBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(PrefUtils());
  }
}
