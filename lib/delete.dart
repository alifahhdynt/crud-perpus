import 'dart:async'; 
import 'package:supabase_flutter/supabase_flutter.dart'; 
// Fungsi untuk menghapus buku berdasarkan ID
Future<void> deleteBook(int bookId) async {
  // Melakukan operasi penghapusan pada tabel 'books' di database Supabase
  await Supabase.instance.client
      .from('books') // Menentukan tabel 'books' di database Supabase
      .delete() // Menentukan bahwa operasi yang dilakukan adalah menghapus data
      .eq('id',
          bookId); // Menentukan kondisi untuk menghapus data berdasarkan 'id' yang cocok dengan bookId
}
