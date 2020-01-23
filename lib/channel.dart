import 'jinja_example.dart';

class JinjaExampleChannel extends ApplicationChannel {
  Environment environment;

  @override
  Future prepare() async {
    logger.onRecord.listen((rec) => print("$rec ${rec.error ?? ""} ${rec.stackTrace ?? ""}"));

    environment = Environment(
        loader: FileSystemLoader(path: './views', autoReload: true), leftStripBlocks: true, trimBlocks: true);
  }

  @override
  Controller get entryPoint {
    final router = Router();

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
