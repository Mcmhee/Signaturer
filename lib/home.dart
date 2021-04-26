import 'package:flutter/material.dart';
import 'package:signature/signature.dart';
import 'package:signaturer/page/signaturePreview.dart';

class home extends StatefulWidget {
  @override
  _homeState createState() => _homeState();
}

class _homeState extends State<home> {
  SignatureController controller;

  @override
  void initState() {
    super.initState();

    controller = SignatureController(
      penStrokeWidth: 5,
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Signature(
              controller: controller,
              backgroundColor: Colors.white,
            ),
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: Icon(Icons.check),
                  onPressed: () async {
                    if (controller.isNotEmpty) {
                      final signature = await exportSignature();

                      await Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            signaturePreview(signature: signature),
                      ));

                      controller.clear();
                    }
                  },
                  color: Colors.green,
                  iconSize: 39,
                ),
                IconButton(
                  icon: Icon(Icons.cancel_outlined),
                  onPressed: () => controller.clear(),
                  color: Colors.red,
                  iconSize: 39,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Future exportSignature() async {
    final exportController = SignatureController(
      exportBackgroundColor: Colors.white,
      penColor: Colors.black,
      penStrokeWidth: 4,
      points: controller.points,
    );

    final signature = await exportController.toPngBytes();
    exportController.dispose();

    return signature;
  }
}
