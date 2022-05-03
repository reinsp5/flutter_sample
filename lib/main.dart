import 'package:flutter/material.dart';
import 'package:flutter_sample/result_page/result_page.dart';
import 'package:flutter_sample/result_page/result_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ResultProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MainPage(),
      ),
    );
  }
}

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("MainPage"),
      ),
      body: MyForm(),
    );
  }
}

class MyForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ResultProvider resultProvider = Provider.of<ResultProvider>(context);
    return Form(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // 左寄せ
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "値を入力してください";
                }
                return null;
              },
              onChanged: (value) => resultProvider.placeName = value.toString(),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                if (resultProvider.placeName != null &&
                    resultProvider.placeName.isNotEmpty) {
                  resultProvider.getGeoPosition();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ResultPage()),
                  );
                }
              },
              child: Text("緯度／経度取得"),
            ),
          ),
        ],
      ),
    );
  }
}
