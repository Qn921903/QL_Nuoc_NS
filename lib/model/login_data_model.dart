

class LoginResult {
  final bool status;
  final String token;
  final String username;
  final int userid;

  LoginResult({
    required this.status,
    required this.token,
    required this.username,
    required this.userid,
  });

  factory LoginResult.fromJson(Map<String, dynamic>? json) {
    return LoginResult(
      status: json?['status'] ?? false,
      token: json?['token'] ?? '',
      username: json?['username'] ?? '',
      userid: json?['userid'] ?? 0,
    );
  }
}

class LoginError {
  final String code;
  final String message;
  final String details;
  final String validationErrors;

  LoginError({
    required this.code,
    required this.message,
    required this.details,
    required this.validationErrors,
  });

  factory LoginError.fromJson(Map<String, dynamic>? json) {
    return LoginError(
      code: json?['code'] ?? '',
      message: json?['message'] ?? '',
      details: json?['details'] ?? '',
      validationErrors: json?['validationErrors'] ?? '',
    );
  }
}

class LoginRequestResult {
  final LoginError? error;
  final LoginResult? result;

  LoginRequestResult({this.error, this.result});

  factory LoginRequestResult.fromJson(Map<String, dynamic>? json) {
    return LoginRequestResult(
      error: json?['error'] != null
          ? LoginError.fromJson(json!['error'])
          : null,
      result: json?['result'] != null
          ? LoginResult.fromJson(json!['result'])
          : null,
    );
  }
}



class LoginOfflineData{
  final String username;
  final String password;
  final int userid;
  final int tenantid;
  LoginOfflineData({required this.username,required this.password,required this.userid, required this.tenantid});
  factory LoginOfflineData.fromJson(Map<String, dynamic> json) {
    return LoginOfflineData(
      password: json['password'],
      username: json['username'],
      tenantid: json['tenantid']??2,
      userid: json['userid'],
    );
  }
  Map<String, dynamic> toJson() =>
      {
        'password': password,
        'username': username,
        'tenantid': tenantid,
        'userid': userid,
      };
}
