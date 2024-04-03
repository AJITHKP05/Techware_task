import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ProductDetailPage extends StatelessWidget {
  final DocumentSnapshot<Object?> data;
  const ProductDetailPage({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
                child: SizedBox(
                    height: 50.sp,
                    width: 50.sp,
                    child: PrettyQrView.data(data: data["name"]))),
            const SizedBox(
              height: 20,
            ),
            customListTile(
              "Product name",
              data["name"],
            ),
            customListTile(
              "Measurement",
              data["measurement"],
            ),
            customListTile(
              "Price",
              data["price"].toString(),
            )
          ],
        ),
      ),
    );
  }

  customListTile(title, subtitle) {
    return ListTile(
      title: Text(title),
      subtitle: Text(subtitle),
    );
  }
}
