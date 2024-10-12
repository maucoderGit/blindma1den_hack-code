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
      (BuildContext context, ScrollController scrollController) => SingleChildScrollView(
    controller: scrollController,
    child: Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 15),
                    child: Text(""),
                  )
              )),
            ],
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
                  hintText: 'sale_order_notification.default_message', userTyped: (value) {
                }, obscure: false, defaultValue: "",
                ),
              )),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                style: TextButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: Colors.transparent,
                    disabledForegroundColor: Colors.grey
                ),
                onPressed: () async {

                  Navigator.pop(context, true);
                },
                child: const Text("sale_order_notification.send_message"),
              ),
            ],
          ),
        ],
      )),
  ));
}