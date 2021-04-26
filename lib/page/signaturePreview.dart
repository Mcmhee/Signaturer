import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';

class signaturePreview extends StatelessWidget {
  final Uint8List signature;
  const signaturePreview({
    Key key,
    @required this.signature,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black12,
      appBar: AppBar(
        leading: CloseButton(
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text("Save to Gallary?"),
        centerTitle: true,
        elevation: 0.0,
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () => storeSignature(context),
          )
        ],
      ),
      body: Center(
        child: Image.memory(signature),
      ),
    );
  }

  Future storeSignature(BuildContext context) async {
    final status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }

    final time = DateTime.now().toString();
    final name = "signaturer-$time";

    final result = await ImageGallerySaver.saveImage(signature, name: name);
    final isSuccess = result['isSucess'];

    // if (isSuccess) {
    Navigator.pop(context);
    Fluttertoast.showToast(
        msg: "Saved to Gallery",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0);
    /*  } else {
      Fluttertoast.showToast(
          msg: "Error Saving to Gallery",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    } */
  }
}
