import 'package:flutter/material.dart';

class ExpandIMG extends StatefulWidget {
  final String imgLink;
  const ExpandIMG({super.key, required this.imgLink});

  @override
  State<ExpandIMG> createState() => _ExpandIMGState();
}

class _ExpandIMGState extends State<ExpandIMG> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Center(
          child: Image.network(widget.imgLink),
        ),
      ),
    );
  }
}
