import 'package:flutter/material.dart';
import 'widgets.dart';
import 'db_helper.dart';
import 'book_list.dart';

class MyHomePage extends StatelessWidget {
  final DBHelper dbHelper = DBHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(), // Đây là nơi có thể xảy ra lỗi
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Danh sách sách',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            SearchForm(),
            SizedBox(height: 10),
            if (isUseAdmin) AddBookButton(),
            Expanded(
              child: BookList(dbHelper),
            ),
          ],
        ),
      ),
    );
  }
}
