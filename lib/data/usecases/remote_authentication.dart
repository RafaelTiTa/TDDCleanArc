import 'package:meta/meta.dart';

import '../http/http.dart';
import '../../domain/usecases/usecases.dart';

class RemoteAuthentication {
  final HttpClient httpClient;
  final String url;
  Future<void> auth(AuthenticationParams params) async {
    await httpClient.request(url: url, method: 'post', body: params.toJson());
  }

  RemoteAuthentication({
    @required this.httpClient,
    @required this.url,
  });
}
