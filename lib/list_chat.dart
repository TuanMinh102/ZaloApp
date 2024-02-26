import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:zalo/addFriend_List.dart';
import 'package:zalo/chat.dart';

class ListChat extends StatefulWidget {
  final String myselft;
  const ListChat({super.key, required this.myselft});

  @override
  State<ListChat> createState() => _ListChatState();
}

class _ListChatState extends State<ListChat> {
  List userList = [];
  List friendList = [];
  bool inputText = false;
  bool messageCat = true;
  bool contactCat = false;
  int countfriend = 0;

  final TextEditingController _searchController = TextEditingController();

  fetchDatabaseList() async {
    final result =
        await FirebaseFirestore.instance.collection('accounts').get();
    if (result == null) {
    } else {
      setState(() {
        userList = result.docs.map((e) => e.data()).toList();
      });
    }
    final result2 = await FirebaseFirestore.instance
        .collection('list_friends')
        .where('user', isEqualTo: widget.myselft)
        .get();
    if (result2 == null) {
    } else {
      setState(() {
        friendList = result2.docs.map((e) => e.data()).toList();
        countfriend = friendList.length;
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
    DateTime now = DateTime.now();
    int ngay = now.day;
    int thang = now.month;
    int nam = now.year;
    String date =
        ngay.toString() + ('/') + thang.toString() + ('/') + nam.toString();
    return Scaffold(
      body: Container(
        width: screenSize.width,
        height: screenSize.height,
        color: const Color.fromARGB(116, 225, 251, 255),
        child: Center(
          child: Column(children: [
            Stack(alignment: AlignmentDirectional.centerEnd, children: [
              TextField(
                onChanged: (text) {
                  setState(() {
                    if (_searchController.text != '') {
                      inputText = true;
                    } else {
                      inputText = false;
                    }
                  });
                },
                style: const TextStyle(color: Colors.white),
                controller: _searchController,
                decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(vertical: 20),
                    isDense: true,
                    prefixIcon:
                        Icon(Icons.search, color: Colors.white, size: 30),
                    hintText: 'Tìm kiếm',
                    hintStyle: TextStyle(color: Colors.white),
                    filled: true,
                    fillColor: Colors.lightBlue,
                    border: InputBorder.none),
              ),
              const Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                Padding(
                  padding: EdgeInsets.only(right: 10),
                  child: Icon(Icons.qr_code, color: Colors.white, size: 30),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 10),
                  child: Icon(Icons.add, color: Colors.white, size: 30),
                ),
              ]),
            ]),
            if (messageCat && !inputText)
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('single_chat')
                        .where(Filter.or(
                            Filter("user1", isEqualTo: widget.myselft),
                            Filter("user2", isEqualTo: widget.myselft)))
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return const Text('');
                      } else if (!snapshot.hasData || snapshot.data == null) {
                        return const Text('');
                      } else {
                        List<DocumentSnapshot> yourData = snapshot.data!.docs;
                        if (yourData.isNotEmpty) {
                          return ListView.builder(
                              itemCount: yourData.length,
                              itemBuilder: (context, index) {
                                return Column(children: [
                                  if (index == 0)
                                    Zalo_Cloud(screenSize.width, date),
                                  GestureDetector(
                                    onTap: () => {
                                      toChat(yourData[index]['user1'],
                                          yourData[index]['user2'])
                                    },
                                    child: container(
                                        screenSize.width,
                                        90,
                                        'images/user.png',
                                        '',
                                        yourData[index]['user1'],
                                        yourData[index]['user2'],
                                        yourData[index]['last_message'],
                                        date),
                                  ),
                                ]);
                              });
                        } else {
                          return const Text('');
                        }
                      }
                    }),
              )
            else if (messageCat && inputText)
              findPhoneNum(screenSize.width, date)
            else if (contactCat)
              contact(),
            SizedBox(
              width: screenSize.width,
              height: 70,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.grey,
                    width: 1,
                  ),
                ),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GestureDetector(
                        onTap: () => {active('message')},
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.message,
                                color: messageCat ? Colors.blue : Colors.grey,
                              ),
                              Text(
                                'Tin nhắn',
                                style: TextStyle(
                                    color:
                                        messageCat ? Colors.blue : Colors.grey),
                              ),
                            ]),
                      ),
                      GestureDetector(
                        onTap: () => {active('contact')},
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.contact_page_sharp,
                                color: contactCat ? Colors.blue : Colors.grey,
                              ),
                              Text(
                                'Danh bạ',
                                style: TextStyle(
                                    color:
                                        contactCat ? Colors.blue : Colors.grey),
                              ),
                            ]),
                      ),
                      const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.window,
                              color: Colors.grey,
                            ),
                            Text(
                              'Khám phá',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ]),
                      const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.alarm,
                              color: Colors.grey,
                            ),
                            Text(
                              'Nhật ký',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ]),
                      const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.people,
                              color: Colors.grey,
                            ),
                            Text(
                              'Cá nhân',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ]),
                    ]),
              ),
            ),
          ]),
        ),
      ),
    );
  }

// Lay ten cua doi phuong
  String getName(String phone1, String phone2) {
    String phone;
    if (phone1 == widget.myselft) {
      phone = phone2;
    } else {
      phone = phone1;
    }
    for (int i = 0; i < userList.length; i++) {
      if (userList[i]['phone'] == phone) {
        return userList[i]['name'];
      }
    }
    return 'Username';
  }

//Lay ten cua doi phuong
  String getName2(String phone) {
    for (int i = 0; i < userList.length; i++) {
      if (userList[i]['phone'] == phone) {
        return userList[i]['name'];
      }
    }
    return 'Username';
  }

  //Chuyen den cuoc tro chuyen
  void toChat(String phone1, String phone2) {
    if (widget.myselft != _searchController.text) {
      if (phone1 == widget.myselft) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Chat(
              myselft: phone1,
              target: phone2,
            ),
          ),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Chat(
              myselft: phone2,
              target: phone1,
            ),
          ),
        );
      }
    }
  }

  // giao dien tim kiem bang sdt
  Widget findPhoneNum(double width, String date) {
    setState(() {
      inputText = true;
    });
    return Expanded(
      child: Column(children: [
        const Padding(padding: EdgeInsets.only(top: 10)),
        Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          decoreBoxText('TẤT CẢ', Colors.black, 1),
          decoreBoxText('TIN NHẮN', Colors.grey, 1),
          decoreBoxText('KHÁM PHÁ', Colors.grey, 1),
        ]),
        const Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.only(left: 20, top: 20),
            child: Text(
              'Tìm bạn qua số điện thoại',
            ),
          ),
        ),
        const Padding(padding: EdgeInsets.only(top: 10)),
        StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('accounts')
                .where('phone', isEqualTo: _searchController.text)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Text('');
              } else if (!snapshot.hasData || snapshot.data == null) {
                return const Text('');
              } else {
                List<DocumentSnapshot> yourData = snapshot.data!.docs;
                if (yourData.isNotEmpty) {
                  return GestureDetector(
                    onTap: () =>
                        {toChat(widget.myselft, _searchController.text)},
                    child: Container(
                      width: width,
                      height: 90,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.grey,
                            width: 0.5,
                          ),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: Row(children: [
                          const CircleAvatar(
                            radius: 25,
                            backgroundImage: AssetImage(
                              'images/user.png',
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    yourData[0]['name'],
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                  RichText(
                                    text: TextSpan(children: [
                                      const TextSpan(
                                          text: ('Số điện thoại: '),
                                          style:
                                              TextStyle(color: Colors.black)),
                                      TextSpan(
                                          text: yourData[0]['phone'],
                                          style: const TextStyle(
                                              color: Colors.blue)),
                                    ]),
                                  ),
                                ]),
                          ),
                          if (checkIsMy())
                            StreamBuilder<QuerySnapshot>(
                                stream: FirebaseFirestore.instance
                                    .collection('list_friends')
                                    .where(Filter.and(
                                        Filter('user',
                                            isEqualTo: widget.myselft),
                                        Filter('friend',
                                            isEqualTo: _searchController.text)))
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasError) {
                                    return const Text('');
                                  } else if (!snapshot.hasData ||
                                      snapshot.data == null) {
                                    return const Text('');
                                  } else {
                                    List<DocumentSnapshot> yourData2 =
                                        snapshot.data!.docs;
                                    //chua ket ban
                                    if (yourData2.isEmpty) {
                                      return StreamBuilder<QuerySnapshot>(
                                          stream: FirebaseFirestore.instance
                                              .collection('requests')
                                              .where(Filter.or(
                                                  Filter.and(
                                                      Filter('sender',
                                                          isEqualTo:
                                                              widget.myselft),
                                                      Filter('receiver',
                                                          isEqualTo:
                                                              _searchController
                                                                  .text)),
                                                  Filter.and(
                                                      Filter('sender',
                                                          isEqualTo:
                                                              _searchController
                                                                  .text),
                                                      Filter('receiver',
                                                          isEqualTo:
                                                              widget.myselft))))
                                              .snapshots(),
                                          builder: (context, snapshot) {
                                            if (snapshot.hasError) {
                                              return const Text('');
                                            } else if (!snapshot.hasData ||
                                                snapshot.data == null) {
                                              return const Text('');
                                            } else {
                                              List<DocumentSnapshot> yourData3 =
                                                  snapshot.data!.docs;
                                              if (yourData3.isNotEmpty) {
                                                if (yourData3[0]['sender'] ==
                                                    widget.myselft) {
                                                  return btn(
                                                      'Thu hồi',
                                                      yourData[0]['phone'],
                                                      date);
                                                } else {
                                                  return Expanded(
                                                    child: Row(children: [
                                                      btn(
                                                          'Từ chối',
                                                          yourData[0]['phone'],
                                                          date),
                                                      btn(
                                                          'Đồng ý',
                                                          yourData[0]['phone'],
                                                          date)
                                                    ]),
                                                  );
                                                }
                                              } else {
                                                return btn('Kết bạn',
                                                    yourData[0]['phone'], date);
                                              }
                                            }
                                          });
                                    } else {
                                      return const Text('');
                                    }
                                  }
                                }),
                        ]),
                      ),
                    ),
                  );
                } else {
                  return const Text('');
                }
              }
            }),
      ]),
    );
  }

// nut ket ban, thu hoi, dong y, tu choi
  Widget btn(String title, String phone, String date) {
    return Expanded(
      child: Align(
        alignment: Alignment.centerRight,
        child: ElevatedButton(
          onPressed: () {
            if (title == 'Kết bạn') {
              sendAddFriend(phone, date);
            } else if (title == 'Thu hồi' || title == 'Từ chối') {
              cancelAddFriend(phone);
            } else if (title == 'Đồng ý') {
              accept(phone);
            }
          },
          child: Text(
            title,
            style: TextStyle(
                color: title == 'Từ chối'
                    ? Colors.red
                    : const Color.fromARGB(255, 44, 158, 251),
                fontSize: title == 'Từ chối' || title == 'Đồng ý' ? 10 : null),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: title == 'Từ chối'
                ? const Color.fromARGB(255, 222, 233, 252)
                : const Color.fromARGB(255, 232, 251, 255),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
          ),
        ),
      ),
    );
  }

//hop chat
  Widget container(double width, double height, String img, String name,
      String name1, String name2, String lastMess, String date) {
    return Container(
      width: width,
      height: height,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: Colors.grey,
            width: 0.5,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: Row(children: [
          CircleAvatar(
            radius: 25,
            backgroundImage: AssetImage(
              img,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    constraints: const BoxConstraints(
                      maxWidth: 230,
                    ),
                    child: Text(
                      name1 != '' && name2 != '' ? getName(name1, name2) : name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ),
                  Container(
                    constraints: const BoxConstraints(
                      maxWidth: 180,
                    ),
                    child: Text(
                      lastMess,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ]),
          ),
          Expanded(
            child: Text(
              date,
              textAlign: TextAlign.right,
              style: const TextStyle(
                color: Color.fromARGB(255, 130, 130, 130),
              ),
            ),
          ),
        ]),
      ),
    );
  }

// check tab
  void active(String active) {
    if (active == 'message') {
      setState(() {
        messageCat = true;
        contactCat = false;
      });
    } else {
      setState(() {
        messageCat = false;
        contactCat = true;
      });
    }
  }

//tab Danh ba
  Widget contact() {
    return Expanded(
      child: Column(children: [
        const Padding(padding: EdgeInsets.only(top: 10)),
        Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          decoreBoxText('BẠN BÈ', Colors.black, 1),
          decoreBoxText('NHÓM', Colors.grey, 1),
          decoreBoxText('OA', Colors.grey, 1),
        ]),
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 20, top: 20),
            child: GestureDetector(
              onTap: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ListAdd(
                      myselft: widget.myselft,
                    ),
                  ),
                )
              },
              child: Row(children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(10)),
                  child: const Icon(
                    Icons.people,
                    color: Colors.white,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Text(
                    'Lời mời kết bạn',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ]),
            ),
          ),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 20, top: 20),
            child: Row(children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(10)),
                child: const Icon(
                  Icons.contact_phone,
                  color: Colors.white,
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 20),
                child: Text(
                  'Danh bạ máy',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ]),
          ),
        ),
        Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Container(
                height: 5, color: const Color.fromARGB(255, 222, 233, 252))),
        Row(children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(top: 10, left: 20),
              child: Container(
                decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 222, 233, 252),
                    borderRadius: BorderRadius.all(Radius.circular(50))),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    ('Tất cả ') + countfriend.toString(),
                    style: const TextStyle(fontSize: 15),
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(top: 10, left: 15),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color.fromARGB(255, 197, 197, 197),
                    width: 1,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(50)),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    'Mới truy cập',
                    style: TextStyle(
                        color: Color.fromARGB(255, 134, 134, 134),
                        fontSize: 15),
                  ),
                ),
              ),
            ),
          ),
        ]),
        const Padding(
            padding: EdgeInsets.only(top: 5),
            child: Divider(color: Colors.grey, thickness: 0.2)),
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('list_friends')
                  .where('user', isEqualTo: widget.myselft)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Text('');
                } else if (!snapshot.hasData || snapshot.data == null) {
                  return const Text('');
                } else {
                  List<DocumentSnapshot> yourData2 = snapshot.data!.docs;
                  if (yourData2.isNotEmpty) {
                    return ListView.builder(
                      itemCount: yourData2.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () => {
                            toChat(widget.myselft, yourData2[index]['friend'])
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(children: [
                                    const Padding(
                                        padding: EdgeInsets.only(left: 20)),
                                    const CircleAvatar(
                                        radius: 25,
                                        backgroundImage: AssetImage(
                                          'images/user.png',
                                        )),
                                    const Padding(
                                        padding: EdgeInsets.only(left: 20)),
                                    Text(
                                      getName2(yourData2[index]['friend']),
                                      style: const TextStyle(fontSize: 17),
                                    )
                                  ]),
                                  Row(children: [
                                    const Padding(
                                        padding: EdgeInsets.only(right: 15),
                                        child: Icon(Icons.phone)),
                                    const Padding(
                                        padding: EdgeInsets.only(right: 15),
                                        child: Icon(Icons.video_call)),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 15),
                                      child: IconButton(
                                        onPressed: () => {
                                          dialog(yourData2[index]['friend'])
                                        },
                                        icon: const Icon(Icons.remove_circle,
                                            color: Colors.red),
                                      ),
                                    ),
                                  ]),
                                ]),
                          ),
                        );
                      },
                    );
                  } else {
                    return const Text('');
                  }
                }
              }),
        ),
      ]),
    );
  }

//
  Widget decoreBoxText(String title, Color color, double width) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: color,
            width: width,
          ),
        ),
      ),
      child: Text(
        title,
        style: TextStyle(fontSize: 15, color: color),
      ),
    );
  }

// kiem tra sdt khac ban than
  bool checkIsMy() {
    if (_searchController.text == widget.myselft) {
      return false;
    }
    return true;
  }

// gui loi moi ket ban
  void sendAddFriend(String receiver, String date) {
    //khoi tao loi moi ket ban
    Map<String, String> datatosave = {
      'sender': widget.myselft,
      'receiver': receiver,
      'date': date
    };
    FirebaseFirestore.instance.collection('requests').add(datatosave);
  }

//thu hoi va tu choi loi moi ket ban
  void cancelAddFriend(String receiver) async {
    String request_docid = 'null';
    final getid = await FirebaseFirestore.instance
        .collection('requests')
        .where(Filter.or(
            Filter.and(Filter('sender', isEqualTo: widget.myselft),
                Filter('receiver', isEqualTo: receiver)),
            Filter.and(Filter('sender', isEqualTo: receiver),
                Filter('receiver', isEqualTo: widget.myselft))))
        .get()
        .then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((DocumentSnapshot doc) {
        request_docid = doc.id;
      });
    });
    final huy = await FirebaseFirestore.instance
        .collection('requests')
        .doc(request_docid);
    huy.delete();
  }

//dong y ket ban va xoa loi yeu cau
  void accept(String phone) async {
    addFrToFirebase(widget.myselft, phone);
    cancelAddFriend(phone);
  }

// them ban be vao firebase tu 2 phia
  void addFrToFirebase(String userPhone1, String userPhone2) async {
    // khoi tao ban be dau tien cua user1
    Map<String, String> datatosave = {
      'user': userPhone1,
      'friend': userPhone2,
    };
    FirebaseFirestore.instance.collection('list_friends').add(datatosave);
    // khoi tao ban be dau tien cua user2
    Map<String, String> datatosave2 = {
      'user': userPhone2,
      'friend': userPhone1,
    };
    FirebaseFirestore.instance.collection('list_friends').add(datatosave2);
  }

//zalo va cloud chat
  Widget Zalo_Cloud(double width, String date) {
    return Column(children: [
      container(width, 90, 'images/icloud.png', 'Cloud của tôi', '', '',
          'Lưu trữ tài liệu của bạn', date),
      container(width, 90, 'images/zalo.png', 'Zalo', '', '',
          'Cập nhật phiên bản mới nhất', date),
    ]);
  }

  //xoa ban tu 2 phia
  void removeFriend(String phone) async {
    String docid = 'null';
    final getid = await FirebaseFirestore.instance
        .collection('list_friends')
        .where(Filter.and(Filter('user', isEqualTo: widget.myselft),
            Filter('friend', isEqualTo: phone)))
        .get()
        .then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((DocumentSnapshot doc) {
        docid = doc.id;
      });
    });
    final huy =
        await FirebaseFirestore.instance.collection('list_friends').doc(docid);
    huy.delete();
    //
    String docid2 = 'null';
    final getid2 = await FirebaseFirestore.instance
        .collection('list_friends')
        .where(Filter.and(Filter('user', isEqualTo: phone),
            Filter('friend', isEqualTo: widget.myselft)))
        .get()
        .then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((DocumentSnapshot doc) {
        docid2 = doc.id;
      });
    });
    final huy2 =
        await FirebaseFirestore.instance.collection('list_friends').doc(docid2);
    huy2.delete();
  }

//xac nhan xoa ban be
  void dialog(String phone) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Xác nhận'),
            content: const Text(
              'Bạn có chắc muốn xóa người này ra khỏi danh sách bạn bè!',
              style: TextStyle(fontSize: 15),
            ),
            actions: <Widget>[
              Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Hủy'),
                ),
                TextButton(
                  onPressed: () {
                    removeFriend(phone);
                    Navigator.of(context).pop();
                  },
                  child: const Text('Xóa'),
                ),
              ]),
            ],
          );
        });
  }
}
