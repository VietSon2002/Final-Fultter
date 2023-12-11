import 'package:flutter/material.dart';
import 'book.dart';
import 'db_helper.dart';

class BookList extends StatefulWidget {
  final DBHelper dbHelper;

  BookList(this.dbHelper);

  @override
  _BookListState createState() => _BookListState();
}

class _BookListState extends State<BookList> {
  List<Book> books = [];

  @override
  void initState() {
    super.initState();
    loadBooks();
  }

  Future<void> loadBooks() async {
    final List<Book> loadedBooks = await widget.dbHelper.getAllBooks();
    setState(() {
      books = loadedBooks;
    });
  }

  void deleteBook(int bookId) async {
    await widget.dbHelper.deleteBook(bookId);
    setState(() {
      books.removeWhere((book) => book.id == bookId);
    });
  }

  void navigateToEditBook(int bookId) {
    // Nếu bạn có màn hình chỉnh sửa sách, bạn có thể sử dụng Navigator để chuyển đến đó
    // Navigator.push(context, MaterialPageRoute(builder: (context) => EditBookScreen(bookId)));
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4, // Số quyển sách trên mỗi hàng
        crossAxisSpacing:
            16.0, // Khoảng cách giữa các quyển sách theo chiều ngang
        mainAxisSpacing: 16.0, // Khoảng cách giữa các hàng theo chiều dọc
      ),
      itemCount: books.length,
      itemBuilder: (context, index) {
        return BookItem(
          books[index],
          widget.dbHelper,
          onDelete: deleteBook,
          onEdit: () => navigateToEditBook(books[index].id),
        );
      },
    );
  }
}

class BookItem extends StatelessWidget {
  final Book book;
  final DBHelper dbHelper;
  final Function(int) onDelete;
  final VoidCallback? onEdit;

  BookItem(this.book, this.dbHelper, {required this.onDelete, this.onEdit});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 460, // Đặt chiều rộng mong muốn
      height: 250, // Đặt chiều cao mong muốn
      child: Column(
        children: [
          Image.asset('assets/images/${book.image}', height: 180, width: 180),
          Text(
            book.title,
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text('Tác giả: ${book.author}'),
          Text(
            'Mô tả: ${book.description}',
            maxLines: 2, // Chỉ hiển thị 2 dòng
            overflow:
                TextOverflow.ellipsis, // Hiển thị "..." khi vượt quá 2 dòng
          ),
          Text('Giá tiền: ${book.price}00 VND'),
          ElevatedButton(
            onPressed: () => addToCart(book.id),
            child: Text('Thêm vào giỏ hàng'),
          ),
          if (isAdmin) ...[
            TextButton(
              onPressed: onEdit,
              child: Text('Chỉnh sửa'),
            ),
            TextButton(
              onPressed: () => onDelete(book.id),
              child: Text('Xóa sách'),
            ),
          ],
          Divider(),
        ],
      ),
    );
  }

  void addToCart(int bookId) {
    dbHelper.addToCart(bookId);
  }
}

bool get isAdmin => true;
