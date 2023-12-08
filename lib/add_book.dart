import 'package:flutter/material.dart';
import 'book.dart';

class AddBookScreen extends StatefulWidget {
  @override
  _AddBookScreenState createState() => _AddBookScreenState();
}

class _AddBookScreenState extends State<AddBookScreen> {
  @override
  Widget build(BuildContext context) {
    // Nhận dữ liệu được truyền qua từ màn hình trước
    final Book? book = ModalRoute.of(context)?.settings.arguments as Book?;

    return Scaffold(
      appBar: AppBar(
        title: Text('Thêm Sách'),
      ),
      body: Center(
        child: Text('Màn hình thêm sách sẽ được xây dựng ở đây.'),
      ),
    );
  }
}
