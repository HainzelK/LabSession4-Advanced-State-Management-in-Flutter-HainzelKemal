# flutter_provider

    late GlobalState globalState -> late utk declare variabel yg not null tp diinisialisasi nanti

    Global state package -> atur counternya punya layout, mirip template. sekalian juga ada functinalities nya dalam

    super.initState();
    globalState = GlobalState(); -> setup awal untuk proyek flutter spy nd rusak, setup jg global state spy bs dipake nnti
    
DragItemWidget -> utk simpan datanya yg di draggablewidget nnti.
(request) async -> minta data yg mau didrag tetapi aplikasi tidak stop untuk minta itu data, klo ada itu data baru lanjut kerja drag item
allowedOperations: () => [DropOperation.copy], -> dispesifikasi apa yg bs dibuat disini spy dia cm buat itu, nda ada hal lain dia buat
DraggableWidget -> box spy user bs interaksi baru drag and drop (drag item)

formats: Formats.standardFormats -> ks tau format apa yang dia terima, standard format itu teks, gambar.
hitTestBehavior: HitTestBehavior.opaque -> cek apakah ada interaksi user dgn ini widget, klo ada cuma widget plg depan yg berinteraksi.
onDropOver: (event) -> cek apakah widget yang didrag bisa dilepaskan di bagianscreen yg ini
event.session.items.first -> item pertama yang sedang didrag

  if (localData is Map) {
    final index = localData['index'] as int?;
    if (index != null) {
      // Handle drop over event logic
      return DropOperation.copy;
    }
 return DropOperation.none; -> cek localdata ada tidak index, klo ada bikin dropoperation.copy (dicopy widgetnya kesana), klo nd ad dropoperation.none (nd dikasi drop widgetnya)

final reader = item.dataReader!;
if (reader.canProvide(Formats.plainText)) -> cek isi widget yg diangkat(yg pasti ada isinya/not null, cek isi datanya plainText ato tidak, klo io, lanjut

  if (reader.canProvide(Formats.plainText)) {
    reader.getValue<String>(Formats.plainText, (value) {
      if (value != null) {
        // Get the dropped item data
        final droppedLocalData = event.session.items.first.localData;
        if (droppedLocalData is Map) {
          final droppedIndex = droppedLocalData['index'] as int?;
          if (droppedIndex != null) {
            // Reordering based on drop position
            final dropIndex = _getDropIndex();
            if (dropIndex != null) {
              setState(() {
                final movedCounter = globalState.counters.removeAt(droppedIndex);
                globalState.counters.insert(dropIndex, movedCounter);
              });
              print('Counters reordered');
            }
          }
        }
      }
    }, onError: (error) {
      print('Error reading value $error');
    });
  } -> gunanya de cek index nya (droppedIndex) dari itu dropperation.copy, baru ubah indexnya itu yg dicopy (droppedIndex) jadi yg plg bawah (dropIndex atau index plg bawah)
onperformdrop lgsung delete yg widget dicopy bru lgsung taro ke plg bawah






