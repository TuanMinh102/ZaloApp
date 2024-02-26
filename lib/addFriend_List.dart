import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ListAdd extends StatefulWidget {
  final String myselft;
  const ListAdd({super.key, required this.myselft});

  @override
  State<ListAdd> createState() => _ListAddState();
}

class _ListAddState extends State<ListAdd> {
  List userList = [];
  String tab = 'ĐÃ NHẬN';

  fetchDatabaseList() async {
    final result =
        await FirebaseFirestore.instance.collection('accounts').get();
    if (result == null) {
    } else {
      setState(() {
        userList = result.docs.map((e) => e.data()).toList();
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
    return Scaffold(
      body: Container(
        width: screenSize.width,
        height: screenSize.height,
        color: const Color.fromARGB(116, 225, 251, 255),
        child: Center(
          child: Column(children: [
            Container(
              width: screenSize.width,
              height: 60,
              color: Colors.blueAccent,
              child: Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Row(children: [
                  GestureDetector(
                    onTap: () => {
                      Navigator.pop(context),
                    },
                    child: const Icon(
                      Icons.arrow_back,
                      size: 25,
                      color: Colors.white,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: Text(
                      'Lời mời kết bạn',
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  const Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Icon(
                        Icons.settings,
                        size: 25,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ]),
              ),
            ),
            const Padding(padding: EdgeInsets.only(top: 10)),
            Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
              decoreBoxText('ĐÃ NHẬN', 1),
              decoreBoxText('ĐÃ GỬI', 1)
            ]),
            if (tab == 'ĐÃ NHẬN')
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('requests')
                        .where('receiver', isEqualTo: widget.myselft)
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
                                  container(
                                      'images/user.png',
                                      yourData[index]['sender'],
                                      yourData[index]['date']),
                                  Container(
                                    width: 350,
                                    height: 1.0,
                                    color: Colors.grey,
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 10),
                                  ),
                                ]);
                              });
                        } else {
                          return const Text('');
                        }
                      }
                    }),
              )
            else
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('requests')
                        .where('sender', isEqualTo: widget.myselft)
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
                                return Padding(
                                  padding: const EdgeInsets.only(
                                      top: 25, left: 20, right: 20),
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(children: [
                                          const CircleAvatar(
                                            radius: 30,
                                            child: Image(
                                              image:
                                                  AssetImage('images/user.png'),
                                            ),
                                          ),
                                          const Padding(
                                              padding:
                                                  EdgeInsets.only(left: 15)),
                                          Column(children: [
                                            Text(
                                              getName(
                                                  yourData[index]['receiver']),
                                              style:
                                                  const TextStyle(fontSize: 18),
                                            ),
                                            Text(('Đã gửi: ') +
                                                yourData[index]['date'])
                                          ]),
                                        ]),
                                        ElevatedButton(
                                          onPressed: () => {
                                            recall(yourData[index]['receiver'])
                                          },
                                          child: const Text(
                                            'Thu hồi',
                                            style:
                                                TextStyle(color: Colors.blue),
                                          ),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                const Color.fromARGB(
                                                    255, 212, 235, 255),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                            ),
                                          ),
                                        ),
                                      ]),
                                );
                              });
                        } else {
                          return const Text('');
                        }
                      }
                    }),
              ),
          ]),
        ),
      ),
    );
  }

//
  Widget decoreBoxText(String title, double width) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: tab == title ? Colors.blue : Colors.black,
            width: width,
          ),
        ),
      ),
      child: TextButton(
        onPressed: () => {
          if (title == "ĐÃ NHẬN")
            setState(() {
              tab = "ĐÃ NHẬN";
            })
          else
            setState(() {
              tab = "ĐÃ GỬI";
            })
        },
        child: Text(
          title,
          style: TextStyle(
              fontSize: 15, color: tab == title ? Colors.blue : Colors.black),
        ),
      ),
    );
  }

// Lay ten cua doi phuong
  String getName(String phone) {
    for (int i = 0; i < userList.length; i++) {
      if (userList[i]['phone'] == phone) {
        return userList[i]['name'];
      }
    }
    return 'Username';
  }

//
  Widget container(String img, String phone, String date) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(children: [
        CircleAvatar(
          radius: 30,
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
                    getName(phone),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
                Container(
                  constraints: const BoxConstraints(
                    maxWidth: 180,
                  ),
                  child: Text(
                    date,
                    style: const TextStyle(
                        color: Color.fromARGB(255, 143, 143, 143)),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Padding(padding: EdgeInsets.only(top: 10)),
                Container(
                  width: 300,
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(8)),
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 10, top: 10, bottom: 10),
                    child: Text(
                        ("Hi, I'm ") + getName(phone) + (".Let's be friends!")),
                  ),
                ),
                const Padding(padding: EdgeInsets.only(top: 10)),
                Container(
                  width: 300,
                  child: Row(children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          refuse(phone);
                        },
                        child: Text(
                          'Từ chối',
                          style: TextStyle(color: Colors.red),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 222, 233, 252),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                      ),
                    ),
                    const Padding(padding: EdgeInsets.only(left: 10)),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          accept(phone);
                        },
                        child: const Text(
                          'Đồng ý',
                          style: TextStyle(
                              color: Color.fromARGB(255, 44, 158, 251)),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 232, 251, 255),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                      ),
                    ),
                  ]),
                ),
              ]),
        ),
      ]),
    );
  }

// tu choi ket ban
  void refuse(String sender) async {
    String docid = 'null';
    final getid = await FirebaseFirestore.instance
        .collection('requests')
        .where(Filter.and(Filter('sender', isEqualTo: sender),
            Filter('receiver', isEqualTo: widget.myselft)))
        .get()
        .then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((DocumentSnapshot doc) {
        docid = doc.id;
      });
    });
    final tuchoi =
        await FirebaseFirestore.instance.collection('requests').doc(docid);
    tuchoi.delete();
  }

// dong y ket ban
  void accept(String phone) async {
    // khoi tao ban be dau tien cua user1
    Map<String, String> datatosave = {
      'user': widget.myselft,
      'friend': phone,
    };
    FirebaseFirestore.instance.collection('list_friends').add(datatosave);
    // khoi tao ban be dau tien cua user2
    Map<String, String> datatosave2 = {
      'user': phone,
      'friend': widget.myselft,
    };
    FirebaseFirestore.instance.collection('list_friends').add(datatosave2);
    refuse(phone);
  }

// thu hoi loi moi kb
  void recall(String receiver) async {
    String docid = 'null';
    final getid = await FirebaseFirestore.instance
        .collection('requests')
        .where(Filter.and(Filter('sender', isEqualTo: widget.myselft),
            Filter('receiver', isEqualTo: receiver)))
        .get()
        .then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((DocumentSnapshot doc) {
        docid = doc.id;
      });
    });
    final thuhoi =
        await FirebaseFirestore.instance.collection('requests').doc(docid);
    thuhoi.delete();
  }
}
