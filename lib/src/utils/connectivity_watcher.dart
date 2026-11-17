import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityWatcher {
  final Connectivity _connectivity = Connectivity();

  Stream<bool> get connectionStatusStream =>
      _connectivity.onConnectivityChanged.map((result) =>
          !result.contains(ConnectivityResult.none));

  Future<bool> get isConnected async {
    final result = await _connectivity.checkConnectivity();
    return !result.contains(ConnectivityResult.none);
  }
}
