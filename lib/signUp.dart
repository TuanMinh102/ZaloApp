import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:zalo/auth_bloc.dart';
import 'package:flutter/services.dart';
import 'package:zalo/main.dart';

class DangKy extends StatefulWidget {
  const DangKy({super.key});

  @override
  State<DangKy> createState() => _DangKyState();
}

class _DangKyState extends State<DangKy> {
  AuthBloc auth = AuthBloc();
  bool _showPass = false;
  List userList = [];
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();

  fetchDatabaseList() async {
    final result2 =
        await FirebaseFirestore.instance.collection('accounts').get();
    if (result2 == null) {
    } else {
      setState(() {
        userList = result2.docs.map((e) => e.data()).toList();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchDatabaseList();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    return Scaffold(
      body: Container(
        width: screenSize.width,
        height: screenSize.height,
        color: const Color.fromARGB(255, 119, 193, 253),
        child: Center(
          child: Column(children: [
            const Text(
              'Zalo',
              style: TextStyle(
                  color: Color.fromARGB(255, 0, 140, 255),
                  fontSize: 60,
                  fontWeight: FontWeight.bold),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 70, right: 70),
              child: Text(
                'Đăng nhập tài khoản Zalo để kết nối với ứng dụng Zalo Chat',
                style: TextStyle(color: Colors.black, fontSize: 15),
                textAlign: TextAlign.center,
              ),
            ),
            const Padding(padding: EdgeInsets.only(top: 20)),
            Container(
              width: 400,
              height: 400,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    spreadRadius: 3,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 350,
                      child: StreamBuilder(
                        stream: auth.phoneStream,
                        builder: (context, snapshot) => TextField(
                          controller: _phoneController,
                          style: const TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                            hintText: 'Số điện thoại',
                            errorText: snapshot.hasError
                                ? snapshot.error.toString()
                                : null,
                            hintStyle: const TextStyle(color: Colors.black),
                            prefixIcon: const Icon(
                              Icons.phone,
                              color: Colors.black,
                            ),
                            enabledBorder: const OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 1),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Padding(padding: EdgeInsets.only(top: 20)),
                    SizedBox(
                      width: 350,
                      child: Stack(
                        alignment: AlignmentDirectional.centerEnd,
                        children: [
                          StreamBuilder(
                            stream: auth.passStream,
                            builder: (context, snapshot) => TextField(
                              controller: _passController,
                              obscureText: !_showPass,
                              style: const TextStyle(color: Colors.black),
                              decoration: InputDecoration(
                                hintText: 'Mật khẩu',
                                errorText: snapshot.hasError
                                    ? snapshot.error.toString()
                                    : null,
                                hintStyle: const TextStyle(color: Colors.black),
                                prefixIcon: const Icon(
                                  Icons.lock,
                                  color: Colors.black,
                                ),
                                enabledBorder: const OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.grey, width: 1),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: GestureDetector(
                              onTap: showHide,
                              child: Text(
                                _showPass ? "ẨN" : "HIỆN",
                                style: const TextStyle(
                                    fontSize: 13,
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Padding(padding: EdgeInsets.only(top: 20)),
                    SizedBox(
                      width: 350,
                      child: StreamBuilder(
                        stream: auth.confirmStream,
                        builder: (context, snapshot) => TextField(
                          controller: _confirmController,
                          obscureText: !_showPass,
                          style: const TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                            hintText: 'Xác nhận mật khẩu',
                            errorText: snapshot.hasError
                                ? snapshot.error.toString()
                                : null,
                            hintStyle: const TextStyle(color: Colors.black),
                            prefixIcon: const Icon(
                              Icons.lock,
                              color: Colors.black,
                            ),
                            enabledBorder: const OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 1),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Padding(padding: EdgeInsets.only(top: 20)),
                    SizedBox(
                      width: 300,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          checkSignUp(userList);
                        },
                        child: Text(
                          'Đăng ký với mật khẩu',
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ),
                    ),
                  ]),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 30),
                child: RichText(
                  text: TextSpan(children: [
                    const TextSpan(
                      text: "Bạn đã có tài khoản? ",
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    TextSpan(
                        text: ' Đăng nhập ngay',
                        style: const TextStyle(
                            color: Color.fromARGB(255, 4, 127, 227),
                            decoration: TextDecoration.underline,
                            fontSize: 15),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.pop(context);
                          }),
                  ]),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  // Hien thi mat khau
  void showHide() {
    setState(() {
      _showPass = !_showPass;
    });
  }

  //Kiem tra dang ky
  void checkSignUp(List<dynamic> l) {
    if (auth.isValid(_phoneController.text, _passController.text,
        _confirmController.text, l)) {
      TextEditingController nameController = TextEditingController();
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Đăng ký'),
              content: const Text('Nhập họ tên của bạn'),
              actions: <Widget>[
                TextField(
                  controller: nameController,
                ),
                Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Hủy'),
                  ),
                  TextButton(
                    onPressed: () {
                      if (nameController.text != '') {
                        saveData(nameController.text);
                        Navigator.of(context).pop();
                        dialog();
                      }
                    },
                    child: const Text('Ok'),
                  ),
                ]),
              ],
            );
          });
    }
  }

//luu du lieu vao firebase
  void saveData(String name) {
    //khoi tao tai khoan
    Map<String, String> datatosave = {
      'phone': _phoneController.text,
      'password': _passController.text,
      'name': name
    };
    FirebaseFirestore.instance.collection('accounts').add(datatosave);
  }

  //thong bao thanh cong
  void dialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Thông báo'),
            content: const Text(
              'Đăng ký thành công!',
              style: TextStyle(color: Colors.green, fontSize: 20),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                  Navigator.of(context).pop();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DangNhap(),
                    ),
                  );
                },
                child: const Text('Đăng nhập'),
              ),
            ],
          );
        });
  }
}
