import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:prayerapp/models/UserDB.dart';

const String USER_COLLECTION_REF = "User";
const String PRAYER_TRACKING_COLLECTION_REF = "PrayerTracking";

class DatabaseService {
  final _firestore = FirebaseFirestore.instance;

  late final CollectionReference<UserDB> _userRef;
  late final CollectionReference _prayerTrackingRef;

  DatabaseService() {
    _userRef = _firestore.collection(USER_COLLECTION_REF).withConverter<UserDB>(
          fromFirestore: (snapshots, _) => UserDB.fromJson(
            snapshots.data()!,
          ),
          toFirestore: (user, _) => user.toJson(),
    );
    _prayerTrackingRef = _firestore.collection(PRAYER_TRACKING_COLLECTION_REF);
  }

  Stream<QuerySnapshot<UserDB>> getUser() {
    return _userRef.snapshots();
  }

  void addUser(UserDB user) async {
    await _userRef.add(user);
  }

  void updateUser(String userID, UserDB user) {
    _userRef.doc(userID).update(user.toJson());
  }

  void deleteUser(String userID) {
    _userRef.doc(userID).delete();
  }

  Future<void> addPrayerData({
    required String userId,
    required String prayerName,
    required bool isOffered,
  }) async {
    
    // String date = DateTime.now().toLocal().toString();
    await _prayerTrackingRef.add({
      'userID': userId,
      'date': Timestamp.now(),
      'prayerName': prayerName,
      'isOffered': isOffered,
    });
  }

  Future<List<Map<String, dynamic>>> getPrayerData(String userId) async {
    QuerySnapshot querySnapshot = await _prayerTrackingRef
        .where('userID', isEqualTo: userId)
        .get();

    List<Map<String, dynamic>> prayerDataList = [];

    querySnapshot.docs.forEach((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      prayerDataList.add(data);
    });

    return prayerDataList;
  }

  Future<List<Map<String, dynamic>>> getPrayerDataInDateRange(String userId, DateTime startDate, DateTime endDate) async {
  QuerySnapshot querySnapshot = await _prayerTrackingRef
      .where('userID', isEqualTo: userId)
      .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
      .where('date', isLessThanOrEqualTo: Timestamp.fromDate(endDate))
      .get();

  List<Map<String, dynamic>> prayerDataList = [];

  querySnapshot.docs.forEach((doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    prayerDataList.add(data);
  });

  return prayerDataList;
}

Future<void> deletePrayerData({
    required String userId,
    required String prayerName,
  }) async {
    QuerySnapshot querySnapshot = await _prayerTrackingRef
        .where('userID', isEqualTo: userId)
        .where('prayerName', isEqualTo: prayerName)
        .get();

    querySnapshot.docs.forEach((doc) {
      doc.reference.delete();
    });
  }

}
