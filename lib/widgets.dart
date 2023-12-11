import 'package:flutter/material.dart';
import 'search_book.dart';
import 'register.dart';
import 'book_list.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue,
      padding: EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset('assets/logo.png', height: 50, width: 50),
          Row(
            children: [
              NavLink('Trang chủ'),
              NavLink('Sách'),
              NavLink('Liên hệ', onPressed: () => showContactInfo(context)),
            ],
          ),
          AuthWidget(),
          CartButton(),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(60.0);
}

class NavLink extends StatelessWidget {
  final String title;
  final VoidCallback? onPressed;

  NavLink(this.title, {this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: InkWell(
        onTap: onPressed,
        child: Text(title, style: TextStyle(color: Colors.white)),
      ),
    );
  }
}

void showContactInfo(BuildContext context) {
  // Hiển thị thông tin liên hệ, ví dụ: sử dụng Dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Thông tin liên hệ'),
        content: Text('Email: nguyenvietson2002@gmail.com\nPhone: 0363228610'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Đóng'),
          ),
        ],
      );
    },
  );
}

class AuthWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (isAdmin) {
      return Row(
        children: [
          Text('Xin chào, $username!'),
          SizedBox(width: 10),
          ElevatedButton(onPressed: () => logout(), child: Text('Đăng xuất')),
        ],
      );
    } else {
      return Row(
        children: [
          ElevatedButton(onPressed: () => login(), child: Text('Đăng nhập')),
          SizedBox(width: 10),
          ElevatedButton(
            onPressed: () => register(context),
            child: Text('Đăng ký ngay'),
          ),
          SizedBox(width: 10),
        ],
      );
    }
  }
}

class CartButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    int cartItemCount = 0;
    return ElevatedButton(
      onPressed: () => navigateToCart(),
      child: Text('Giỏ hàng ($cartItemCount)'),
    );
  }
}

class SearchForm extends StatelessWidget {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: _searchController,
              decoration: InputDecoration(hintText: 'Nhập từ khóa tìm kiếm'),
              onFieldSubmitted: (value) => search(context),
            ),
          ),
          ElevatedButton(
            onPressed: () => search(context),
            child: Text('Tìm kiếm'),
          ),
        ],
      ),
    );
  }

  void search(BuildContext context) {
    String query = _searchController.text;

    // Xử lý tìm kiếm
    if (query.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SearchBookScreen(query: query),
        ),
      );
    }
  }
}

class AddBookButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // Chuyển hướng đến màn hình thêm sách
        Navigator.pushNamed(context, '/addBook');
      },
      child: Text('Thêm sách'),
    );
  }
}

String get username => 'User';

void login() {}

void logout() {}

void register(BuildContext context) {
  Navigator.push(
      context, MaterialPageRoute(builder: (context) => RegisterScreen()));
}

void search() {}

void navigateToCart() {}

void addToCart(int bookId) {}

void navigateToAddBook() {}

void navigateToEditBook(int bookId) {}
