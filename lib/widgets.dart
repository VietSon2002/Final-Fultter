import 'package:flutter/material.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue,
      padding: EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset('assets/logo.png', height: 30, width: 30),
          Row(
            children: [
              NavLink('Trang chủ'),
              NavLink('Sách'),
              NavLink('Liên hệ'),
            ],
          ),
          AuthWidget(),
          CartButton(),
        ],
      ),
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(60.0); // Adjust the height as needed
}

class NavLink extends StatelessWidget {
  final String title;

  NavLink(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Text(title, style: TextStyle(color: Colors.white)),
    );
  }
}

class AuthWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (isLoggedIn) {
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
          Text('Chưa có tài khoản?'),
          TextButton(onPressed: () => register(), child: Text('Đăng ký ngay')),
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
  @override
  Widget build(BuildContext context) {
    return Form(
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              decoration: InputDecoration(hintText: 'Nhập từ khóa tìm kiếm'),
            ),
          ),
          ElevatedButton(onPressed: () => search(), child: Text('Tìm kiếm')),
        ],
      ),
    );
  }

  void search() {
    // Xử lý tìm kiếm
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

bool get isLoggedIn => true;
bool get isUseAdmin => true;
String get username => 'User';

void login() {}
void logout() {}
void register() {}
void search() {}
void navigateToCart() {}
void addToCart(int bookId) {}
void navigateToAddBook() {}
void navigateToEditBook(int bookId) {}
