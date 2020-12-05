import 'package:flutter/material.dart';



class FullScreenImage extends StatelessWidget {

  String imagePath;

  FullScreenImage({this.imagePath});

  final LinearGradient linearGradient = new LinearGradient(
    colors: [Colors.black , Colors.blueGrey],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    body: SizedBox.expand(
      child: Container(
       decoration: BoxDecoration(
         gradient: linearGradient,
       ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Hero(
                tag: imagePath,
                child: Image.network(imagePath),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                AppBar(
                elevation: 0,
                backgroundColor: Colors.transparent,
                leading: IconButton(
                 icon: Icon(Icons.close),
                 color: Colors.white,
                 onPressed: (){
                  Navigator.of(context).pop();
                 },
                ),
                )
              ],
              ),
            ),
          ],
        ),
      ),
    ),
    );
  }
}
