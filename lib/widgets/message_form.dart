import 'package:flutter/material.dart';
import 'package:flutter_apps/constants/border_radius.dart';
import 'package:flutter_apps/screens/area.dart';
import 'package:flutter_apps/widgets/custom_text_input.dart';

Widget registerMessageWidget(
    double minExtent,
    double maxExtent,
    double initialExtent,
    UserSelection selection,
    DraggableScrollableController sheetController,
    BuildContext context,
) {
  return DraggableScrollableSheet(
      controller: sheetController,
      minChildSize: minExtent,
      maxChildSize: maxExtent,
      initialChildSize: initialExtent,
      builder:
      (BuildContext context, ScrollController scrollController) => Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: Theme.of(context).canvasColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      child: SingleChildScrollView(
        controller: scrollController, child: Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: Icon(Icons.person),
            title: Text("Share your review!"),
          ),
          const SizedBox(height: 20.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(width: MediaQuery.of(context).size.width / 1.15, child: Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  side: const BorderSide(
                      color: Color.fromRGBO(191, 191, 191, 1.0)
                  ),
                  borderRadius: cardRadius(),
                ),
                child: CustomTextInput(
                  hintText: 'Describe tu experiencia con todos los usuarios. \n\nTu mensaje puede ahorrar muchos malos momentos.', userTyped: (value) {
                }, obscure: false, defaultValue: "",
                ),
              )),
            ],
          ),
          const SizedBox(height: 20.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                style: TextButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    disabledBackgroundColor: Colors.transparent,
                    disabledForegroundColor: Colors.grey
                ),
                onPressed: () async {

                  Navigator.pop(context, true);
                },
                child: const Text("Enviar mensaje"),
              ),
            ],
          ),
        ],
      )),
  )));
}