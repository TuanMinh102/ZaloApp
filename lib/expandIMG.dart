import 'package:flutter/material.dart';

class ExpandIMG extends StatefulWidget {
  final String img;
  const ExpandIMG({super.key, required this.img});

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
          child: Hero(
            tag: 'imageHero',
            child: Image.network(widget.img),
          ),
        ),
      ),
    );
  }
}
