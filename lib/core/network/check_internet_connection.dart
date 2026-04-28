import 'package:internet_connection_checker/internet_connection_checker.dart';

abstract class CheckInternetConnection {
  Future<bool> get isConnected;
}

class CheckInternetConnectionImpl implements CheckInternetConnection {
  final InternetConnectionChecker connectionChecker;

  CheckInternetConnectionImpl(this.connectionChecker);

  @override
  Future<bool> get isConnected => connectionChecker.hasConnection;
}
