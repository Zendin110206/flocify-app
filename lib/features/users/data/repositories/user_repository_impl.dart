// lib/features/users/data/repositories/user_repository_impl.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:proyek_flocify/features/users/domain/models/user_profile.dart';
import 'package:proyek_flocify/features/users/domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  // Buat referensi ke koleksi 'users' di Firestore.
  // Ini adalah praktik terbaik untuk mendefinisikannya sekali.
  final CollectionReference<UserProfile> _usersRef;

  UserRepositoryImpl({FirebaseFirestore? firestore})
    : _usersRef = (firestore ?? FirebaseFirestore.instance)
          .collection('users')
          .withConverter<UserProfile>(
            fromFirestore: (snapshot, _) =>
                UserProfile.fromJson(snapshot.data()!),
            toFirestore: (profile, _) => profile.toJson(),
          );

  @override
  Future<void> saveUserProfile(UserProfile userProfile) async {
    try {
      // Gunakan .set() pada dokumen dengan ID `userProfile.uid`.
      // Ini akan membuat dokumen baru jika belum ada, atau menimpanya jika sudah ada.
      // Ini sempurna untuk menyimpan profil pertama kali atau memperbaruinya.
      await _usersRef
          .doc(userProfile.uid)
          .set(userProfile, SetOptions(merge: true));
    } on FirebaseException catch (e) {
      // Log error dan lempar kembali sebagai exception yang lebih umum.
      print('FirebaseException in saveUserProfile: ${e.message}');
      throw Exception('Gagal menyimpan profil pengguna.');
    } catch (e) {
      print('Unknown exception in saveUserProfile: $e');
      throw Exception('Terjadi kesalahan yang tidak diketahui.');
    }
  }

  @override
  Future<UserProfile?> getUserProfile(String uid) async {
    try {
      final docSnapshot = await _usersRef.doc(uid).get();

      if (docSnapshot.exists) {
        // .data() akan mengembalikan objek UserProfile berkat .withConverter
        return docSnapshot.data();
      } else {
        // Jika dokumen tidak ada, kembalikan null.
        return null;
      }
    } on FirebaseException catch (e) {
      print('FirebaseException in getUserProfile: ${e.message}');
      throw Exception('Gagal mengambil profil pengguna.');
    }
  }

  @override
  Future<bool> doesUserProfileExist(String uid) async {
    try {
      final docSnapshot = await _usersRef.doc(uid).get();
      return docSnapshot.exists;
    } catch (e) {
      // Jika terjadi error, anggap saja tidak ada untuk keamanan.
      print('Error checking user profile existence: $e');
      return false;
    }
  }

  @override
  Stream<UserProfile?> getUserProfileStream(String uid) {
    // .doc(uid) menunjuk ke dokumen pengguna yang spesifik.
    // .snapshots() mengembalikan Stream yang akan 'memancarkan' data baru
    // setiap kali konten dokumen tersebut berubah.
    return _usersRef.doc(uid).snapshots().map((snapshot) {
      // Jika dokumen ada (exist), kembalikan datanya (yang sudah di-convert
      // ke UserProfile oleh withConverter). Jika tidak, kembalikan null.
      if (snapshot.exists) {
        return snapshot.data();
      }
      return null;
    });
  }
}
