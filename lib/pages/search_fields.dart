import 'package:flutter/material.dart';
import 'package:tracking_cuaca/pages/result.dart';

class SearchField extends StatefulWidget {
  const SearchField({super.key});

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  TextEditingController placeController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Tracking Cuaca',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.blueAccent,
          centerTitle: true,
        ),
        body: Center(
            child: Container(
          padding: const EdgeInsets.only(left: 80, right: 80),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                decoration: const InputDecoration(hintText: "ex: Jakarta"),
                controller: placeController,
              ),
              const SizedBox(
                height: 20.0,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return Result(
                      place: placeController.text,
                    );
                  }));

                  print(placeController.text);
                },
                child: const Text('Search'),
              )
            ],
          ),
        )),
      ),
    );
  }
}
