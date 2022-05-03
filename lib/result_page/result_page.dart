import 'package:flutter/material.dart';
import 'package:flutter_sample/result_page/result_provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ResultPage extends StatelessWidget {
  const ResultPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ResultProvider resultProvider = Provider.of<ResultProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("ResultPage"),
      ),
      body: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                resultProvider.placeName,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Divider(
                thickness: 2.0,
              ),
              Row(
                children: _viewWeatherCalendar(resultProvider),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _viewWeatherCalendar(ResultProvider resultProvider) {
    DateTime date = DateTime.now();
    List<Widget> list = <Widget>[];
    for (int i = 0; i < resultProvider.weathers.length; i++) {
      list.add(
        Expanded(
          child: Padding(
            child: Column(
              children: [
                Text(
                    DateFormat('yyyy/M/d').format(date.add(Duration(days: i)))),
                const Divider(
                  thickness: 2.0,
                ),
                Text(resultProvider.weathers[i])
              ],
            ),
            padding: EdgeInsets.all(16.0),
          ),
        ),
      );
    }
    return list;
  }
}
