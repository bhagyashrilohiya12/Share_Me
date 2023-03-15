import 'package:cpr_user/pages/user/my_profile_page/components/configure_page.dart';
import 'package:cpr_user/providers/session_provider.dart';
import 'package:flutter/widgets.dart';

class ConfigureProvider with ChangeNotifier {
  final SessionProvider sessionProvider;
  final displayName = TextEditingController();
  final birthday = TextEditingController();
  final countryCode = TextEditingController();
  final mobile = TextEditingController();
  final gender = TextEditingController();
  final maritalStatus = TextEditingController();
  bool busy = false;

  ConfigureProvider(this.sessionProvider) {
    displayName.text = sessionProvider.user!.displayName!;
    birthday.text = sessionProvider.user!.dateOfBirth?.toIso8601String() ?? '';
    countryCode.text = sessionProvider.user!.countryCode!;
    mobile.text = sessionProvider.user!.mobile!;
    gender.text = sessionProvider.user!.gender! ==0?"Male":"Female";
    maritalStatus.text = sessionProvider.user!.maritalStatus!;
  }

  Future<void> updateUser() async {
    sessionProvider.user!.displayName = displayName.text;
    sessionProvider.user!.dateOfBirth = DateTime.tryParse(birthday.text);
    sessionProvider.user!.countryCode = countryCode.text;
    sessionProvider.user!.mobile = mobile.text;
    sessionProvider.user!.gender = gender.text=="Male"?0:1;
    sessionProvider.user!.maritalStatus = maritalStatus.text;

    return sessionProvider.updateUser();
  }

  void startLoading() {
    busy = true;
    notifyListeners();
  }

  void stopLoading() {
    busy = false;
    notifyListeners();
  }
}
