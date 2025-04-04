import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../../services/auth_service.dart';

class ConfigureProviders {

  final List<SingleChildWidget> providers;

  ConfigureProviders({required this.providers});

  static Future<ConfigureProviders> createDependencyTree() async{

    final authService = AuthService();

    return ConfigureProviders(providers: [
      ChangeNotifierProvider<AuthService>.value(value: authService),
    ]);
  }

}