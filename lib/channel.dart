import 'jinja_example.dart';

class JinjaExampleChannel extends ApplicationChannel {
  JinjaExampleChannel() {
    environment = Environment(
      loader: FileSystemLoader(path: './views', autoReload: true),
      leftStripBlocks: true,
      trimBlocks: true,
    );

    environment.templates.forEach((k, v) {
      print(k);
    });
  }

  Environment environment;

  @override
  Future prepare() async {
    logger.onRecord.listen((rec) => print("$rec ${rec.error ?? ""} ${rec.stackTrace ?? ""}"));
  }

  /// Construct the request channel.
  ///
  /// Return an instance of some [Controller] that will be the initial receiver
  /// of all [Request]s.
  ///
  /// This method is invoked after [prepare].
  @override
  Controller get entryPoint {
    final router = Router();

    // Prefer to use `link` instead of `linkFunction`.
    // See: https://aqueduct.io/docs/http/request_controller/
    router.route('/').linkFunction((request) async {
      return Response.ok(environment.getTemplate('index.html').render(), headers: {
        HttpHeaders.contentTypeHeader: 'text/html; charset=utf-8',
      });
    });

    router.route('/user/:name').linkFunction((request) async {
      final String name = request.path.variables['name'];
      return Response.ok(environment.getTemplate('user.html').render(name: name), headers: {
        HttpHeaders.contentTypeHeader: 'text/html; charset=utf-8',
      });
    });

    return router;
  }
}
