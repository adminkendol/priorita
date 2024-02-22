import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class WarningDialog extends StatelessWidget {
  const WarningDialog(
      {Key? key,
      required this.title,
      required this.description,
      required this.labelA,
      required this.labelB,
      required this.actA,
      required this.actB})
      : super(key: key);

  final String title, description, labelA, labelB;
  final Function actA;
  final Function actB;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      backgroundColor: const Color(0xffffffff),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Container(
        margin: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 15),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),
            Container(
              margin: const EdgeInsets.all(15),
              child: Text(
                description,
                style: const TextStyle(fontSize: 13),
                overflow: TextOverflow.visible,
              ),
            ),
            const SizedBox(height: 20),
            const Divider(
              height: 1,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 50,
              child: InkWell(
                highlightColor: Colors.grey[200],
                onTap: () {
                  actA();
                },
                child: Center(
                  child: Text(
                    labelA,
                    style: TextStyle(
                      fontSize: 15.0,
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            const Divider(
              height: 1,
            ),
            labelB.isNotEmpty
                ? SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    child: InkWell(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(15.0),
                        bottomRight: Radius.circular(15.0),
                      ),
                      highlightColor: Colors.grey[200],
                      onTap: () {
                        actB();
                      },
                      child: Center(
                        child: Text(
                          labelB,
                          style: const TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
