import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'book.dart';

class DBHelper {
  static Database? _database;

  DBHelper() {
    initDatabase();
  }

  Future<void> initDatabase() async {
    if (_database == null) {
      _database = await openDatabase(
        join(await getDatabasesPath(), 'bookstore_books.db'),
        onCreate: (db, version) {
          return db.execute('''
          CREATE TABLE books(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            author TEXT,
            description TEXT,
            price REAL,
            image TEXT
          )
          ''');
        },
        version: 1,
      );
    }
  }

  Future<List<Book>> getAllBooks() async {
    await initDatabase(); // Đảm bảo rằng database đã được khởi tạo

    final List<Map<String, dynamic>> books = await _database!.query('books');
    return List.generate(books.length, (index) {
      return Book(
        id: books[index]['id'],
        title: books[index]['title'],
        author: books[index]['author'],
        description: books[index]['description'],
        price: books[index]['price'],
        image: books[index]['image'],
      );
    });
  }

  Future<void> deleteBook(int bookId) async {
    await initDatabase(); // Đảm bảo rằng database đã được khởi tạo

    await _database!.delete(
      'books',
      where: 'id = ?',
      whereArgs: [bookId],
    );
  }

  Future<void> addToCart(int bookId) async {
    // Thực hiện hành động thêm sách vào giỏ hàng
    // Ví dụ: Cart.addToCart(bookId);
  }

  Future<void> updateBook(Book book) async {
    await initDatabase(); // Đảm bảo rằng database đã được khởi tạo

    await _database!.update(
      'books',
      book.toMap(),
      where: 'id = ?',
      whereArgs: [book.id],
    );
  }

  Future<void> insertBook(Book book) async {
    await initDatabase(); // Đảm bảo rằng database đã được khởi tạo

    await _database!.insert(
      'books',
      book.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}
