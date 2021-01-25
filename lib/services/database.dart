import 'package:brew_crew/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:brew_crew/models/brew.dart';

class DatabaseService {
  final CollectionReference brewCollection =
      Firestore.instance.collection('brews');
  final String uid;

  DatabaseService({this.uid});

  Future updateUserData(String name, String sugars, int strength) async {
    return await brewCollection
        .document(uid)
        .setData({'name': name, 'sugars': sugars, 'strength': strength});
  }

  Stream<List<Brew>> get brews {
    return brewCollection.snapshots().map(_createBrewListFromSnapshot);
  }

  Stream<UserData> get userData {
    return brewCollection
        .document(uid)
        .snapshots()
        .map(_createUserDataFromSnapshot);
  }

  List<Brew> _createBrewListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents
        .map((doc) => Brew(
            name: doc.data['name'] ?? '',
            sugars: doc.data['sugars'] ?? '0',
            strength: doc.data['strength'] ?? 0))
        .toList();
  }

  UserData _createUserDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
        uid: uid,
        name: snapshot.data['name'],
        sugars: snapshot.data['sugars'],
        strength: snapshot.data['strength']);
  }
}
