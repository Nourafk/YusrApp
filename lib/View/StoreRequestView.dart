import 'package:flutter/material.dart';
import 'package:yusr/Widget/app_text_field.dart';
import 'package:yusr/Widget/custom_text_widget.dart';
import '../Model/StoresRequest.dart';

class StoreRequest extends StatefulWidget {
  final store;
  StoreRequest(this.store, {super.key});
  @override
  State<StoreRequest> createState() => _TextfieldGeneralWidgetState(store);
}

class _TextfieldGeneralWidgetState extends State<StoreRequest> {
  StoresRequest? store;
  _TextfieldGeneralWidgetState(store) {
    this.store = store;
  }

  final storeController = TextEditingController();
  final storeDescriptionController = TextEditingController();
  String nameLocation = '';
  double lat = 0.0;
  double long = 0.0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    storeController.dispose();
    storeDescriptionController.dispose();
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomText("صورة المتجر",
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
                          image: NetworkImage(store!.imageStore),
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
                storeController,
                Icon(
                  Icons.text_fields_rounded,
                  color: Color(0x8F909090),
                ),
                store!.nameStore,
                "name",
                "request",
                "text"),
            const SizedBox(
              height: 20,
            ),
            textFeild(
                storeDescriptionController,
                Icon(
                  Icons.description,
                  color: Color(0x8F909090),
                ),
                store!.desStore,
                "description",
                "request",
                "text"),
            const SizedBox(
              height: 20,
            ),
            Container(
              height: 60,
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Color(0x76909090))),
              child: InkWell(
                onTap: () {},
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                        child: CustomText(
                      store!.state,
                      color: Colors.grey,
                      maxLines: 1,
                    )),
                    Icon(
                      Icons.location_on,
                      color: Color.fromRGBO(215, 171, 101, 1),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      );
}
