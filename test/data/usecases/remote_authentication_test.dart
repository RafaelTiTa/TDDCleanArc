import 'package:test/test.dart';
import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';

import 'package:for_devs/domain/usecases/usecases.dart';
import 'package:for_devs/data/usecases/usecases.dart';
import 'package:for_devs/data/http/http.dart';
import 'package:for_devs/domain/helpers/helpers.dart';

class HttpClientSpy extends Mock implements HttpClient {}

void main() {
  RemoteAuthentication sut;
  HttpClient httpClient;
  String url;

  setUp(() {
    httpClient = HttpClientSpy();
    url = faker.internet.httpUrl();
    sut = RemoteAuthentication(httpClient: httpClient, url: url);
  });

  test('Should call HttpClient with correct values', () async {
    final params = AuthenticationParams(
      email: faker.internet.email(),
      password: faker.internet.password(),
    );

    await sut.auth(params);

    verify(httpClient.request(
      url: url,
      method: 'post',
      body: {'email': params.email, 'password': params.password},
    ));
  });
  test('Should InvalidCredentialsError if HttpClient returns 401', () async {
    when(httpClient.request(
            url: anyNamed('url'),
            method: anyNamed('method'),
            body: anyNamed('body')))
        .thenThrow(HttpError.unauthorized);

    final params = AuthenticationParams(
        email: faker.internet.email(), password: faker.internet.password());

    final future = sut.auth(params);

    expect(future, throwsA(DomainError.invalidCredentials));
  });
}
