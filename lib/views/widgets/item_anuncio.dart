import 'package:flutter/material.dart';

class ItemAnuncio extends StatelessWidget {
  const ItemAnuncio({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              SizedBox(
                width: 120,
                height: 120,
                child: Container(
                  color: Colors.orange,
                ),
              ),
              Expanded(
                  flex: 3,
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Vídeo Game Nintendo 64",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text("R\$ 1.200,80")
                      ],
                    ),
                  )),
              Expanded(
                  flex: 1,
                  child: TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                          backgroundColor: Colors.red,
                          padding: const EdgeInsets.all(10)),
                      child: const Icon(
                        Icons.delete,
                        color: Colors.white,
                      )))
            ],
          ),
        ),
      ),
    );
  }
}
