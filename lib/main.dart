import 'package:flutter/material.dart';
import 'package:rest_api_practice/models/user.dart';
import 'package:rest_api_practice/services/api_service.dart';




void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Api Practice',
      home: UserListScreen(),
    );
  }
}

class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {

  List<User> users = [];
  bool isLoading = true;
  String error = "";

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  // KULLANICILARI YÜKLEYEN METHOD
  Future<void> _loadUsers() async {
    try {
      setState(() {
        isLoading = true;  // Yükleniyor göster
        error = '';        // Hataları temizle
      });

      // API'DEN KULLANICILARI ÇEK
      List<User> userList = await ApiService.getUsers();

      // EKRANI GÜNCELLE
      setState(() {
        users = userList;    // Gelen kullanıcıları listeye ata
        isLoading = false;   // Yüklenme bitti
      });

    } catch (e) {
      // HATA OLURSA
      setState(() {
        error = e.toString();  // Hata mesajını kaydet
        isLoading = false;     // Yüklenme bitti (ama hata var)
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Kullanıcı Listesi"),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _loadUsers,  // Tıklanınca kullanıcıları yeniden yükle
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  // ANA İÇERİĞİ OLUŞTURAN METHOD
  Widget _buildBody() {
    // DURUM 1: YÜKLENİYOR
    if (isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),  // Dönen progress
            SizedBox(height: 20),
            Text('Kullanıcılar yükleniyor...'),
          ],
        ),
      );
    }

    // DURUM 2: HATA VAR
    if (error.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Hata: $error', style: TextStyle(color: Colors.red)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _loadUsers,  // Tekrar dene
              child: Text('Tekrar Dene'),
            ),
          ],
        ),
      );
    }

    // DURUM 3: BAŞARILI - LİSTE GÖSTER
    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) {
        User user = users[index];  // Sıradaki kullanıcı

        return Card(
          margin: EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              child: Text(user.id.toString()),  // Kullanıcı ID'si
            ),
            title: Text(
              user.name,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(user.email),
          ),
        );
      },
    );
  }
}



