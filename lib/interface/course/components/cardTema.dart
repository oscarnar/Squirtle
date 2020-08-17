import 'package:flutter/material.dart';
import 'package:squirtle/models/courseModel.dart';

class CardTema extends StatelessWidget {
  CardTema({this.tema});
  final Tema tema;

  String listTextModules(List<Module> list) {
    String text = '';
    for (var x in list) {
      text += ('- ${x.name} \n');
    }
    return text;
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      height: size.width * 0.3,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.blue[100],
      ),
      child: InkWell(
        onTap: () {
          print("Tap on Card");
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              tema.name,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
            Text(
              listTextModules(tema.modules),
              style: TextStyle(fontSize: 14),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ],
        ),
      ),
    );
  }
}

class ListModules extends StatelessWidget {
  final List<Module> listModules;

  ListModules({this.listModules});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return ListView.builder(
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.only(
            top: size.width * 0.005,
            left: size.width * 0.005,
            right: size.width * 0.005,
            bottom: (() {
              if (index + 1 == listModules.length)
                return size.width * 0.005;
              else
                return 0.0;
            }()),
          ),
          child: Text(
            '- ${listModules[index].name}',
            style: TextStyle(
              fontSize: 13,
            ),
          ),
        );
      },
      itemCount: listModules.length,
    );
  }
}
