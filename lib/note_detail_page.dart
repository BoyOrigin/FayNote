import 'package:flutter/material.dart';
import 'db_helper.dart';
import 'note_model.dart';

class NoteDetailPage extends StatefulWidget {
  final Note? note;

  const NoteDetailPage({super.key, this.note});

  @override
  State<NoteDetailPage> createState() => _NoteDetailPageState();
}

class _NoteDetailPageState extends State<NoteDetailPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _contentController;

  @override
  void initState() {
    super.initState();
    // Jika ada note (Edit Mode), isi controller dengan data yang ada
    _titleController = TextEditingController(text: widget.note?.title ?? '');
    _contentController = TextEditingController(text: widget.note?.content ?? '');
  }

  Future addOrUpdateNote() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) return;

    final isUpdating = widget.note != null;

    if (isUpdating) {
      await updateNote();
    } else {
      await addNote();
    }

    if (mounted) {
      Navigator.of(context).pop(); // Kembali ke halaman list
    }
  }

  Future updateNote() async {
    final note = Note(
      id: widget.note!.id,
      title: _titleController.text,
      content: _contentController.text,
    );
    await DatabaseHelper.instance.update(note);
  }

  Future addNote() async {
    final note = Note(
      title: _titleController.text,
      content: _contentController.text,
    );
    await DatabaseHelper.instance.create(note);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.note != null ? 'Edit Catatan' : 'Tambah Catatan'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: addOrUpdateNote,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                decoration: const InputDecoration(
                  hintText: 'Judul',
                  border: InputBorder.none,
                ),
                validator: (title) => title != null && title.isEmpty ? 'Judul tidak boleh kosong' : null,
              ),
              const SizedBox(height: 8),
              Expanded(
                child: TextFormField(
                  controller: _contentController,
                  maxLines: null, // Unlimited lines
                  decoration: const InputDecoration(
                    hintText: 'Isi catatan...',
                    border: InputBorder.none,
                  ),
                  validator: (title) => title != null && title.isEmpty ? 'Isi tidak boleh kosong' : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}