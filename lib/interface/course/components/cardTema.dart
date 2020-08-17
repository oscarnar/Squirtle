import 'package:flutter/material.dart';
import 'package:squirtle/models/courseModel.dart';

class CardTema extends StatelessWidget {
  CardTema({this.tema});
  final Tema tema;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: Container(
        height: size.width * 0.25,
        color: Colors.blue[200],
        //shape: RoundedRectangleBorder(
        //  side: BorderSide(color: Colors.white70, width: 1),
        //  borderRadius: BorderRadius.circular(20),
        //),
        child: InkWell(
          onTap: () {
            print("Tap on Card");
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                tema.name,
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}