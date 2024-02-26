import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Chat extends StatefulWidget {
  final String myselft;
  final String target;
  const Chat({super.key, required this.myselft, required this.target});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  bool inputText = false;
  List userList = [];
  String docid = 'null';
  int countMess = 0;
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

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

  getdocumentid() async {
    final ref = FirebaseFirestore.instance
        .collection('single_chat')
        .where(Filter.or(
            Filter.and(Filter("user1", isEqualTo: widget.myselft),
                Filter("user2", isEqualTo: widget.target)),
            Filter.and(Filter("user1", isEqualTo: widget.target),
                Filter("user2", isEqualTo: widget.myselft))))
        .get()
        .then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((DocumentSnapshot doc) {
        setState(() {
          docid = doc.id;
        });
      });
    });
  }

  @override
  void initState() {
    super.initState();
    fetchDatabaseList();
    getdocumentid();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    DateTime now = DateTime.now();
    int gio = now.hour;
    int phut = now.minute;
    return Scaffold(
      body: Container(
        width: screenSize.width,
        height: screenSize.height,
        color: const Color.fromARGB(116, 225, 251, 255),
        child: Center(
          child: Column(children: [
            Container(
              width: screenSize.width,
              height: 90,
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
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                              getName(),
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: Text(
                              'Truy cập 10 phút trước',
                              style: TextStyle(
                                color: Color.fromARGB(255, 132, 132, 132),
                              ),
                            ),
                          ),
                        ]),
                    const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: Icon(Icons.search, size: 30),
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: Icon(Icons.call, size: 30),
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: Icon(Icons.video_call, size: 30),
                          ),
                        ]),
                  ]),
            ),
            const Padding(padding: EdgeInsets.only(top: 15)),
            Expanded(
              child: StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('single_chat')
                      .doc(docid)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const Text('');
                    } else if (!snapshot.hasData || snapshot.data == null) {
                      return const Text('');
                    } else {
                      var yourData =
                          snapshot.data?.data() as Map<String, dynamic>?;
                      getdocumentid();
                      if (yourData != null) {
                        countMess = int.parse(yourData['count_messages']);
                        return ListView.builder(
                            controller: _scrollController,
                            itemCount: int.parse(yourData['count_messages']),
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(
                                    left: 10, right: 10, bottom: 10),
                                child: Align(
                                  alignment: yourData[widget.myselft +
                                              ('-') +
                                              (index + 1).toString()] ==
                                          null
                                      ? Alignment.centerLeft
                                      : Alignment.centerRight,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.grey,
                                        width: 0.3,
                                      ),
                                      color: yourData[widget.myselft +
                                                  ('-') +
                                                  (index + 1).toString()] ==
                                              null
                                          ? const Color.fromARGB(
                                              255, 255, 252, 252)
                                          : const Color.fromARGB(
                                              255, 178, 231, 255),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(5)),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10,
                                          right: 10,
                                          top: 7,
                                          bottom: 7),
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              yourData[widget.myselft +
                                                      ('-') +
                                                      (index + 1).toString()] ??
                                                  yourData[widget.target +
                                                      ('-') +
                                                      (index + 1).toString()],
                                              style: const TextStyle(
                                                  color: Colors.black),
                                            ),
                                            const Padding(
                                                padding:
                                                    EdgeInsets.only(top: 3)),
                                            Text(
                                              '$gio:$phut',
                                              style: const TextStyle(
                                                fontSize: 10,
                                                color: Color.fromARGB(
                                                    255, 136, 136, 136),
                                              ),
                                            ),
                                          ]),
                                    ),
                                  ),
                                ),
                              );
                            });
                      } else {
                        return const Text('');
                      }
                    }
                  }),
            ),
            Stack(alignment: AlignmentDirectional.centerEnd, children: [
              TextField(
                onChanged: (text) {
                  setState(() {
                    if (_messageController.text != '') {
                      inputText = true;
                    } else {
                      inputText = false;
                    }
                  });
                },
                controller: _messageController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.face),
                  suffixIcon: inputText
                      ? GestureDetector(
                          onTap: addMessage,
                          child: const Icon(
                            Icons.send,
                            size: 30,
                            color: Colors.blue,
                          ),
                        )
                      : null,
                  hintText: 'Tin nhắn',
                  filled: true,
                  fillColor: Colors.white,
                  border: const OutlineInputBorder(),
                ),
              ),
              if (inputText == false)
                Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                  const Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: Icon(Icons.more_horiz, size: 30),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: Icon(Icons.mic, size: 30),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: IconButton(
                      onPressed: () => {},
                      icon: const Icon(Icons.image, size: 30),
                    ),
                  ),
                ]),
            ]),
          ]),
        ),
      ),
    );
  }

//luu tin nhan len csdl
  void addMessage() async {
    if (_messageController.text != '') {
      if (docid == 'null') {
        //khoi tao tin nhan dau tien
        Map<String, String> datatosave = {
          'user1': widget.myselft,
          'user2': widget.target,
          widget.myselft + ('-1'): _messageController.text,
          'count_messages': '1',
          'last_message': _messageController.text
        };
        FirebaseFirestore.instance.collection('single_chat').add(datatosave);
        //cap nhap lai docid
        getdocumentid();
      } else {
        // them tin nhan moi vao document da co
        CollectionReference collectionReference =
            FirebaseFirestore.instance.collection('single_chat');
        DocumentReference documentReference = collectionReference.doc(docid);
        await documentReference.update({
          widget.myselft + ('-') + (countMess + 1).toString():
              _messageController.text,
          'count_messages': (countMess + 1).toString(),
          'last_message': _messageController.text
        });
      }
      setState(() {
        inputText = false;
        _messageController.text = '';
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      });
    }
  }

  // Lay ten cua doi phuong
  String getName() {
    for (int i = 0; i < userList.length; i++) {
      if (userList[i]['phone'] == widget.target) {
        return userList[i]['name'];
      }
    }
    return 'Username';
  }
}
