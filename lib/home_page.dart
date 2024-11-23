import 'package:crud_perpustakaan/insert.dart';
import 'package:crud_perpustakaan/update.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'delete.dart';

class BookListPage extends StatefulWidget {
  const BookListPage({super.key});

  @override
  State<BookListPage> createState() => _BookListPageState();
}

class _BookListPageState extends State<BookListPage> {
  List<Map<String, dynamic>> books = [];

  @override
  void initState() {
    super.initState();
    fetchBooks(); // panggil fungsi untuk fetch data buku
  }

  // fungsi untuk mengambil data buku dari supabase
  Future<void> fetchBooks() async {
    final response = await Supabase.instance.client.from('books').select();

    setState(() {
      books = List<Map<String, dynamic>>.from(response);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Daftar Buku',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.pink[100],
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: fetchBooks, // tombol untuk refresh
          ),
        ],
      ),
      body: books.isEmpty
          ? const Center(
              child: CircularProgressIndicator(),
            ) // seperti loading
          : ListView.builder(
              // membuat tampilan list secara urut
              itemCount: books.length,
              itemBuilder: (context, index) {
                final book = books[index];
                return ListTile(
                  title: Text(
                    book['title'] ?? 'No Title',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        book['author'] ?? 'No Author',
                        style: const TextStyle(
                          fontSize: 14,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      Text(
                        book['description'] ?? 'No Description',
                      ),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          // arahkan ke halaman EditBookPage dengan mengirimkan route
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditBookPage(book: book),
                            ),
                          ).then((_) {
                            fetchBooks(); // refresh data setelah kembali dari halaman edit
                          });
                        },
                      ),
                      // tombol delete
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          // konfirmasi sebelum menghapus buku
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Delete Book'),
                                content:
                                    const Text('Are you sure want to delete?'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      await deleteBook(book['id']);
                                      Navigator.of(context).pop();
                                      await fetchBooks();
                                    },
                                    child: const Text('Delete'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      )
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigasi ke halaman AddBookPage
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddBookPage()),
          ).then((_) {
            fetchBooks(); // Refresh data setelah kembali dari halaman AddBookPage
          });
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.pink[200],
      ),
    );
  }
}
