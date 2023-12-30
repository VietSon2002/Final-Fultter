import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'book.dart';
import 'db_helper.dart';
import 'auth_provider.dart';
import 'edit_book.dart';

class SearchBookGridItem extends StatelessWidget {
  final Book book;
  final Function(int) onAddToCart;
  final VoidCallback? onEdit;
  final Function(int) onDelete;

  SearchBookGridItem({
    required this.book,
    required this.onAddToCart,
    this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final bool isAdmin = authProvider.role == 'admin';

    return Container(
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
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          Text('Giá tiền: ${book.price}00 VNĐ'),
          ElevatedButton(
            onPressed: () {
              onAddToCart(book.id);
              final snackBar = SnackBar(
                content: Text('Sách đã được thêm vào giỏ hàng'),
                duration: Duration(seconds: 1),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            },
            child: Text('Thêm vào giỏ hàng'),
          ),
          if (isAdmin && onEdit != null)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: onEdit!,
                  child: Text('Chỉnh sửa'),
                ),
                SizedBox(width: 5),
                TextButton(
                  onPressed: () => onDelete(book.id),
                  child: Text('Xóa sách'),
                ),
              ],
            ),
          Divider(),
        ],
      ),
    );
  }
}

class SearchBookScreen extends StatefulWidget {
  final String? query;

  SearchBookScreen({this.query});

  @override
  _SearchBookScreenState createState() => _SearchBookScreenState();
}

class _SearchBookScreenState extends State<SearchBookScreen> {
  final DBHelper dbHelper = DBHelper();
  List<Book> searchResults = [];

  @override
  void initState() {
    super.initState();
    if (widget.query != null && widget.query!.isNotEmpty) {
      performSearch(widget.query!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tìm kiếm sách'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Kết quả tìm kiếm cho "${widget.query}"'),
            SizedBox(height: 10),
            Expanded(
              child: searchResults.isNotEmpty
                  ? GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16.0,
                        mainAxisSpacing: 16.0,
                      ),
                      itemCount: searchResults.length,
                      itemBuilder: (context, index) {
                        return SearchBookGridItem(
                          book: searchResults[index],
                          onAddToCart: (bookId) => addToCart(bookId),
                          onEdit: () =>
                              navigateToEditBook(searchResults[index].id),
                          onDelete: deleteBook,
                        );
                      },
                    )
                  : Center(
                      child: Text('Không tìm thấy kết quả'),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  void performSearch(String keyword) async {
    if (keyword.isNotEmpty) {
      List<Book> results = await dbHelper.searchBooks(keyword);
      setState(() {
        searchResults = results;
      });
    }
  }

  void addToCart(int bookId) {
    dbHelper.addToCart(bookId);
  }

  void navigateToEditBook(int bookId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditBookScreen(
          bookId: bookId,
          dbHelper: dbHelper,
        ),
      ),
    ).then((result) {
      if (result == true) {
        loadBooks();
      }
    });
  }

  void deleteBook(int bookId) async {
    await dbHelper.deleteBook(bookId);
    setState(() {
      searchResults.removeWhere((book) => book.id == bookId);
    });
  }

  void loadBooks() async {
    final List<Book> loadedBooks = await dbHelper.getAllBooks();
    setState(() {
      searchResults = loadedBooks;
    });
  }
}
