import 'package:dio/dio.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';

/// ZLibrary API 客户端
class ZLibraryApi {
  late Dio _dio;
  String _domain = 'pkuedu.online';

  ZLibraryApi({String? domain}) {
    if (domain != null) {
      _domain = domain;
    }
    _initDio();
  }

  void _initDio() {
    _dio = Dio(BaseOptions(
      baseUrl: 'https://$_domain',
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    ));

    // 添加 Cookie 管理器以保持会话
    final cookieJar = CookieJar();
    _dio.interceptors.add(CookieManager(cookieJar));

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        // 添加通用请求头
        options.headers['User-Agent'] = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36';
        handler.next(options);
      },
    ));
  }

  /// 设置 API 域名
  void setDomain(String domain) {
    _domain = domain;
    _initDio();
  }

  /// 获取当前域名
  String get domain => _domain;

  Future<Map<String, dynamic>> getSimilarBooks(String bookId, String hashId) async {
    // 实现相似书籍的API调用
    try {
      final response = await _dio.get(
        '/similar',
        queryParameters: {
          'bookId': bookId,
          'hashId': hashId,
        },
      );
      return response.data;
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }
  // ==================== 认证方法 ====================

  /// 使用邮箱密码登录
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await _dio.post(
        '/rpc.php',
        data: {
          'isModal': true,
          'email': email,
          'password': password,
          'action': 'login',
        },
      );
      return response.data is String ? {'success': false, 'error': 'Invalid response'} : response.data;
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }

  /// 使用令牌登录
  Future<Map<String, dynamic>> loginWithToken(String userId, String userKey) async {
    try {
      final response = await _dio.post(
        '/rpc.php',
        data: {
          'action': 'login',
          'uid': userId,
          'userkey': userKey,
        },
      );
      return response.data is String ? {'success': false, 'error': 'Invalid response'} : response.data;
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }

  /// 获取用户资料
  Future<Map<String, dynamic>> getProfile() async {
    try {
      final response = await _dio.get('/login.php');
      return response.data;
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }

  /// 发送注册验证码
  Future<Map<String, dynamic>> sendCode(String email, String password, String name) async {
    try {
      final response = await _dio.post(
        '/rpc.php',
        data: {
          'action': 'register',
          'email': email,
          'password': password,
          'name': name,
          'step': 'send',
        },
      );
      return response.data;
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }

  /// 验证注册验证码
  Future<Map<String, dynamic>> verifyCode(String email, String password, String name, String code) async {
    try {
      final response = await _dio.post(
        '/rpc.php',
        data: {
          'action': 'register',
          'email': email,
          'password': password,
          'name': name,
          'step': 'verify',
          'code': code,
        },
      );
      return response.data;
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }

  // ==================== 搜索方法 ====================

  /// 搜索图书
  Future<Map<String, dynamic>> search({
    String? message,
    int? yearFrom,
    int? yearTo,
    List<String>? languages,
    List<String>? extensions,
    String? order,
    int? page,
    int? limit,
  }) async {
    try {
      final params = <String, dynamic>{};
      if (message != null) params['q'] = message;
      if (yearFrom != null) params['yearFrom'] = yearFrom;
      if (yearTo != null) params['yearTo'] = yearTo;
      if (languages != null && languages.isNotEmpty) params['l'] = languages;
      if (extensions != null && extensions.isNotEmpty) params['e'] = extensions;
      if (order != null) params['order'] = order;
      if (page != null) params['page'] = page;
      if (limit != null) params['limit'] = limit;

      final response = await _dio.get(
        '/s/',
        queryParameters: params,
      );
      return response.data;
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }

  /// 获取图书详情
  Future<Map<String, dynamic>> getBookInfo(String bookId, String hashId) async {
    try {
      final response = await _dio.get(
        '/book/$bookId/$hashId',
      );
      return response.data;
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }

  /// 获取最热门图书
  Future<Map<String, dynamic>> getMostPopular() async {
    try {
      final response = await _dio.get('/mostpopular');
      return response.data;
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }

  /// 获取推荐图书
  Future<Map<String, dynamic>> getUserRecommended() async {
    try {
      final response = await _dio.get('/recommended');
      return response.data;
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }

  /// 获取最近添加的图书
  Future<Map<String, dynamic>> getRecently() async {
    try {
      final response = await _dio.get('/recently');
      return response.data;
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }

  // ==================== 用户图书方法 ====================

  /// 获取收藏图书
  Future<Map<String, dynamic>> getUserSaved({int? limit}) async {
    try {
      final params = <String, dynamic>{};
      if (limit != null) params['limit'] = limit;

      final response = await _dio.get(
        '/saved',
        queryParameters: params,
      );
      return response.data;
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }

  /// 收藏图书
  Future<Map<String, dynamic>> saveBook(String bookId) async {
    try {
      final response = await _dio.post(
        '/rpc.php',
        data: {
          'action': 'save',
          'bookId': bookId,
        },
      );
      return response.data;
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }

  /// 取消收藏
  Future<Map<String, dynamic>> unsaveUserBook(String bookId) async {
    try {
      final response = await _dio.post(
        '/rpc.php',
        data: {
          'action': 'unsave',
          'bookId': bookId,
        },
      );
      return response.data;
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }

  /// 获取下载记录
  Future<Map<String, dynamic>> getUserDownloaded({int? limit}) async {
    try {
      final params = <String, dynamic>{};
      if (limit != null) params['limit'] = limit;

      final response = await _dio.get(
        '/downloaded',
        queryParameters: params,
      );
      return response.data;
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }

  // ==================== 下载方法 ====================

  /// 下载图书
  Future<void> downloadBook(
    String bookId,
    String hash, {
    required String filePath,
    Function(int received, int total)? onProgress,
    CancelToken? cancelToken,
  }) async {
    final dio = Dio();

    await dio.download(
      'https://$_domain/dl/$bookId/$hash',
      filePath,
      cancelToken: cancelToken,
      onReceiveProgress: (received, total) {
        if (onProgress != null) {
          onProgress(received, total);
        }
      },
    );
  }
}