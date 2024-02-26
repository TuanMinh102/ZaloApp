import 'dart:async';

class LoginBloc {
  final StreamController _phoneController = StreamController();
  final StreamController _passController = StreamController();
  Stream get phoneStream => _phoneController.stream;
  Stream get passStream => _passController.stream;

  bool isValidInput(String phone, String pass) {
    if (phone.isEmpty || phone.length < 10) {
      _phoneController.sink.addError("Số điện thoại không hợp lệ");
      return false;
    }
    _phoneController.sink.add("ok");
    if (pass.isEmpty || pass.length > 6) {
      _passController.sink.addError("Mật khẩu tối đa 6 ký tự");
      return false;
    }
    _passController.sink.add("ok");
    return true;
  }

  bool isValidAccount(String phone, String pass, List<dynamic> l) {
    bool validPhone = false;
    bool validPass = false;
    for (int i = 0; i < l.length; i++) {
      if (phone == l[i]['phone']) {
        validPhone = true;
      }
    }
    if (validPhone == false) {
      _phoneController.sink.addError("Số điện thoại không đúng");
      return false;
    }
    for (int i = 0; i < l.length; i++) {
      if (pass == l[i]['password']) {
        validPass = true;
      }
    }
    if (validPass == false) {
      _passController.sink.addError("Mật khẩu không đúng");
      return false;
    }
    for (int i = 0; i < l.length; i++) {
      if (phone == l[i]['phone'] && pass == l[i]['password']) {
        _phoneController.sink.add("ok");
        _passController.sink.add("ok");
        return true;
      }
    }
    _passController.sink.addError("Mật khẩu không đúng");
    return false;
  }

  void dispose() {
    _phoneController.close();
    _passController.close();
  }
}
