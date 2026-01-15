import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'dart:io';
import 'db_helper.dart';
import 'note_model.dart';
import 'note_detail_page.dart';
import 'contact_list_page.dart';
import 'product_list_page.dart';
import 'dashboard_page.dart';

void main() {
  if (Platform.isWindows || Platform.isLinux) {
    // Initialize FFI
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  runApp(
    const MaterialApp(home: NotesPage(), debugShowCheckedModeBanner: false),
  );
}

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  late List<Note> notes;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    refreshNotes();
  }

  // Method untuk refresh data dari database
  Future refreshNotes() async {
    setState(() => isLoading = true);
    notes = await DatabaseHelper.instance.readAllNotes();
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FayNote'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_bag),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProductListPage(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.contacts),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ContactListPage(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.dashboard),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const DashboardPage()),
              );
            },
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : notes.isEmpty
          ? const Center(child: Text('Belum ada catatan'))
          : ListView.builder(
              itemCount: notes.length,
              itemBuilder: (context, index) {
                final note = notes[index];
                return Card(
                  child: ListTile(
                    title: Text(
                      note.title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(note.content),
                    onTap: () async {
                      // Navigasi ke Edit (bawa data note)
                      await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => NoteDetailPage(note: note),
                        ),
                      );
                      refreshNotes(); // Refresh setelah kembali dari edit
                    },
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () async {
                        // Hapus data
                        await DatabaseHelper.instance.delete(note.id!);
                        refreshNotes();
                      },
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          // Navigasi ke Tambah (tanpa data note)
          await Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const NoteDetailPage()),
          );
          refreshNotes(); // Refresh setelah kembali dari tambah
        },
      ),
    );
  }
}
