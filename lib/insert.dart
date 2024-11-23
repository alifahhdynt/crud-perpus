import 'home_page.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Halaman untuk menambahkan buku baru
class AddBookPage extends StatefulWidget {
  const AddBookPage({super.key}); // Konstruktor untuk halaman AddBookPage

  @override
  State<AddBookPage> createState() =>
      _AddBookPageState(); // Membuat state untuk halaman ini
}

class _AddBookPageState extends State<AddBookPage> {
  final _formKey = GlobalKey<FormState>(); // Primary key untuk validasi form
  final TextEditingController _titleController =
      TextEditingController(); // Controller untuk input judul buku
  final TextEditingController _authorController =
      TextEditingController(); // Controller untuk input penulis buku
  final TextEditingController _descriptionController =
      TextEditingController(); // Controller untuk input deskripsi buku

  // Fungsi untuk menambahkan buku ke database Supabase
  Future<void> _addBook() async {
    if (_formKey.currentState!.validate()) {
      // Validasi input form
      final title = _titleController.text; // Mengambil nilai judul
      final author = _authorController.text; // Mengambil nilai penulis
      final description =
          _descriptionController.text; // Mengambil nilai deskripsi

      if (!_formKey.currentState!.validate()) {
        return;
      }

      // Memasukkan data buku ke dalam tabel 'books' di Supabase
      final response = await Supabase.instance.client.from('books').insert({
        'title': title,
        'author': author,
        'description': description,
      }).select();

      // Menampilkan snackbar jika gagal
      if (response == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Error: ${response}')), // Menampilkan pesan error jika gagal
        );
      } else {
        // Menampilkan snackbar jika buku berhasil ditambahkan
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Book added successfully')),
        );

        // Membersihkan form setelah berhasil menambahkan buku
        _titleController.clear();
        _authorController.clear();
        _descriptionController.clear();

        // Kembali ke halaman utama
        Navigator.pop(context,
            true); // Menutup halaman AddBookPage dan kembali ke halaman sebelumnya

        // Memindahkan ke halaman BookListPage (halaman daftar buku)/refresh
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                const BookListPage(), // Menampilkan halaman daftar buku
          ),
        );
      }
    }
  }

  // Membuat tampilan UI halaman AddBookPage
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Book'), // Judul halaman
        centerTitle: true, // Menjajarkan judul di tengah
        backgroundColor: Colors.pink[100],
      ),
      body: Padding(
        padding:
            const EdgeInsets.all(16.0), // Memberikan padding di sekitar form
        child: Form(
          key: _formKey, // Menghubungkan form dengan kunci validasi
          child: Column(
            children: [
              // Form input untuk judul buku
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the title'; // Validasi input judul
                  }
                  return null;
                },
              ),
              // Form input untuk penulis buku
              TextFormField(
                controller: _authorController,
                decoration: const InputDecoration(labelText: 'Author'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the author'; // Validasi input penulis
                  }
                  return null;
                },
              ),
              // Form input untuk deskripsi buku
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the description'; // Validasi input deskripsi
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20), // Jarak antar widget
              // Tombol untuk menambahkan buku
              TextButton(
                onPressed:
                    _addBook, // Memanggil fungsi _addBook saat tombol ditekan
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(
                      Colors.white), // Warna latar belakang tombol
                  shadowColor: WidgetStateProperty.all(
                      Colors.black), // Warna bayangan tombol
                  elevation:
                      WidgetStateProperty.all(4), // Elevasi bayangan tombol
                  padding: WidgetStateProperty.all<EdgeInsets>(
                    // Padding tombol
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                  ),
                ),
                child: const Text(
                  'Add Book', // Teks tombol
                  style: TextStyle(
                    color: Colors.purple, // Warna teks tombol
                    fontWeight: FontWeight.bold, // Menebalkan teks
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
