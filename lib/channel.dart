import 'jinja_conduit.dart';

class JinjaExampleChannel extends ApplicationChannel {
  late Environment environment;

  @override
  Future<void> prepare() async {
    logger.onRecord.listen((rec) {
      print("$rec ${rec.error ?? ""} ${rec.stackTrace ?? ""}");
    });

    environment = Environment(
      autoReload: true,
      loader: FileSystemLoader(path: './views'),
      leftStripBlocks: true,
      trimBlocks: true,
    );
  }

  Template get indexTemplate {
    return environment.getTemplate('index.html');
  }

  Template get userTemplate {
    return environment.getTemplate('user.html');
  }

  @override
  Controller get entryPoint {
    final headers = {HttpHeaders.contentTypeHeader: 'text/html; charset=utf-8'};

    return Router()
      ..route('/').linkFunction((request) => Response.ok(indexTemplate.render(), headers: headers))
      ..route('/user/:name').linkFunction(
          (request) => Response.ok(userTemplate.render({'name': request.path.variables['name']}), headers: headers));
  }
}
