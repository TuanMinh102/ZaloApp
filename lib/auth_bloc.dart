import 'dart:async';

class AuthBloc {
  final StreamController _phoneController = StreamController();
  final StreamController _passController = StreamController();
  final StreamController _confirmController = StreamController();

  Stream get phoneStream => _phoneController.stream;
  Stream get passStream => _passController.stream;
  Stream get confirmStream => _confirmController.stream;

  bool isValid(String phone, String pass, String confirm, List<dynamic> l) {
    if (phone.isEmpty) {
      _phoneController.sink.addError("Nhập số điện thoại");
      return false;
    } else if (phone.substring(0, 1) != '0') {
      _phoneController.sink.addError("Số điện thoại không đúng định dạng");
      return false;
    } else if (!isPhoneNumberValid(phone)) {
      _phoneController.sink.addError("Số điện thoại gồm 10 số");
      return false;
    } else {
      for (int i = 0; i < l.length; i++) {
        if (phone == l[i]['phone']) {
          _phoneController.sink.addError("Số điện thoại đã tồn tại");
          return false;
        }
      }
    }
    _phoneController.sink.add("");
    //
    if (pass.isEmpty) {
      _passController.sink.addError("Nhập mật khẩu");
      return false;
    } else {
      if (pass.length < 6) {
        _passController.sink.addError("Mật khẩu ít nhất 6 ký tự");
        return false;
      }
    }
    _passController.sink.add("");
    //
    if (confirm.isEmpty) {
      _confirmController.sink.addError("Nhập mật khẩu xác nhận");
      return false;
    } else {
      if (confirm != pass) {
        _confirmController.sink.addError("Mật khẩu không khớp");
        return false;
      }
    }
    _confirmController.sink.add("");
    return true;
  }

  //
  bool isPhoneNumberValid(String phoneNumber) {
    RegExp regex = RegExp(r'^\d{10}$');
    return regex.hasMatch(phoneNumber);
  }

  void dispose() {
    _phoneController.close();
    _passController.close();
    _confirmController.close();
  }
}
