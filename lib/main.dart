import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:zalo/list_chat.dart';
import 'package:zalo/login_bloc.dart';
import 'package:flutter/services.dart';
import 'package:zalo/signUp.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const DangNhap());
}

class DangNhap extends StatelessWidget {
  const DangNhap({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sign In',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(
        title: 'Sign In',
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  LoginBloc bloc = LoginBloc();
  bool _showPass = false;
  List userList = [];
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

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
                        stream: bloc.phoneStream,
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
                            stream: bloc.passStream,
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
                      width: 300,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          checkLogin(userList);
                        },
                        child: Text(
                          'Đăng nhập với mật khẩu',
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
                    const Padding(padding: EdgeInsets.only(top: 20)),
                    SizedBox(
                      width: 300,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {},
                        child: Text(
                          'Gửi yêu cầu đăng nhập',
                          style: TextStyle(color: Colors.blue),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                            side:
                                const BorderSide(color: Colors.grey, width: 1),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: RichText(
                        text: TextSpan(
                            text: 'Quên mật khẩu?',
                            style: const TextStyle(
                              color: Colors.black,
                            ),
                            recognizer: TapGestureRecognizer()..onTap = () {}),
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
                      text: "Bạn chưa có tài khoản? ",
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    TextSpan(
                        text: ' Đăng ký ngay',
                        style: const TextStyle(
                            color: Color.fromARGB(255, 4, 127, 227),
                            decoration: TextDecoration.underline,
                            fontSize: 15),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const DangKy(),
                              ),
                            );
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

  //Kiem tra dang nhap
  void checkLogin(List<dynamic> l) {
    if (bloc.isValidInput(_phoneController.text, _passController.text) &&
        bloc.isValidAccount(_phoneController.text, _passController.text, l)) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ListChat(
            myselft: _phoneController.text,
          ),
        ),
      );
    }
  }
}
