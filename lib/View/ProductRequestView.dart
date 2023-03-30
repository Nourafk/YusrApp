import 'package:flutter/material.dart';
import 'package:yusr/Widget/app_text_field.dart';
import 'package:yusr/Widget/custom_text_widget.dart';
import '../Model/ProductRequest.dart';

class ProductRequest extends StatefulWidget {
  final product;
  ProductRequest(this.product, {super.key});
  @override
  State<ProductRequest> createState() => _TextfieldGeneralWidgetState(product);
}

class _TextfieldGeneralWidgetState extends State<ProductRequest> {
  ProductsRequest? product;
  _TextfieldGeneralWidgetState(product) {
    this.product = product;
  }

  final productController = TextEditingController();
  final productDescriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    productController.dispose();
    productDescriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          toolbarHeight: 60,
          automaticallyImplyLeading: true,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Color(0XFFd7ab65),
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            'عرض الطلب',
            style: TextStyle(
                color: Color(0XFFd7ab65),
                fontSize: 24,
                fontWeight: FontWeight.w400,
                fontFamily: 'Tajawal'),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
        ),
        body: ListView(
          padding: EdgeInsets.fromLTRB(
              20,
              MediaQuery.of(context).size.height * 0.001,
              20,
              MediaQuery.of(context).size.height * 0.02),
          children: [
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(
                  20,
                  MediaQuery.of(context).size.height * 0.001,
                  20,
                  MediaQuery.of(context).size.height * 0.001),
              child: Row(
                children: [
                  CustomText("      صورة المنتج",
                      color: Color(0x8F909090).withOpacity(0.9),
                      fontSize: 19,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Tajawal'),
                  SizedBox(
                    width: 45,
                  ),
                  Container(
                    height: 80,
                    width: 80,
                    margin: EdgeInsets.symmetric(horizontal: 0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        15,
                      ),
                      border: Border.all(color: Colors.white, width: 2),
                      image: DecorationImage(
                          image: NetworkImage(product!.imageProduct),
                          fit: BoxFit.cover),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            textFeild(
                productController,
                Icon(
                  Icons.text_fields_rounded,
                  color: Color(0x8F909090),
                ),
                product!.nameProduct,
                "name",
                "request",
                "text"),
            const SizedBox(
              height: 20,
            ),
            textFeild(
                productDescriptionController,
                Icon(
                  Icons.description,
                  color: Color(0x8F909090),
                ),
                product!.callories + ' cal',
                "name",
                "request",
                "text"),
            const SizedBox(
              height: 20,
            ),
            textFeild(
                productDescriptionController,
                Icon(
                  Icons.description,
                  color: Color(0x8F909090),
                ),
                product!.productType,
                "name",
                "request",
                "text"),
          ],
        ),
      );
}
