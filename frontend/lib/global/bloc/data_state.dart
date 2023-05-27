part of 'data_bloc.dart';

enum GoToScreen {
  unknown,
  offlineTrans,
  onlineTrans,
  recOfflineTrans,
  tvcSuccess,
}

class DataState extends Equatable {
  final SimplePublicKey? serverPublicKey;

  final Profile? profile;
  final Transactions transactions;
  final List<Favorite> favorites;
  final String? sessionToken;
  final BalanceKeyVerificationCertificate? bkvc;
  final bool? primary;
  final bool isLoaded;
  final bool isOnline;
  final TAMStatus tamStatus;
  final GoToScreen goToScreen;
  final Transaction? latestTransaction;

  SimplePublicKey get userPublicKey {
    return bkvc!.getPublicKey();
  }

  double get balance {
    if (bkvc == null) {
      return 0;
    }
    double balance = bkvc!.availableBalance;

    var unsubmittedTransactions = transactions.transactions
        .where((element) => !element.isSubmitted)
        .toList();

    for (var transaction in unsubmittedTransactions) {
      if (transaction.credit) {
        balance += transaction.authorizationMessage!.amount;
      } else {
        balance -= transaction.authorizationMessage!.amount;
      }
    }
    return balance;
  }

  DateTime get lastSyncTime {
    return bkvc!.timeStamp;
  }

  const DataState({
    this.profile,
    this.transactions = const Transactions(transactions: []),
    this.favorites = const [],
    this.bkvc,
    this.primary,
    this.serverPublicKey,
    this.sessionToken,
    this.isLoaded = false,
    this.isOnline = false,
    this.tamStatus = TAMStatus.other,
    this.goToScreen = GoToScreen.unknown,
    this.latestTransaction,
  });

  DataState copyWith({
    Profile? profile,
    List<Favorite>? favorites,
    Transactions? transactions,
    BalanceKeyVerificationCertificate? bkvc,
    bool? primary,
    SimplePublicKey? serverPublicKey,
    String? sessionToken,
    bool? isLoaded,
    bool? isOnline,
    TAMStatus? tamStatus,
    GoToScreen? goToScreen,
    Transaction? latestTransaction,
  }) {
    return DataState(
      profile: profile ?? this.profile,
      favorites: favorites ?? this.favorites,
      transactions: transactions ?? this.transactions,
      bkvc: bkvc ?? this.bkvc,
      primary: primary ?? this.primary,
      serverPublicKey: serverPublicKey ?? this.serverPublicKey,
      sessionToken: sessionToken ?? this.sessionToken,
      isLoaded: isLoaded ?? this.isLoaded,
      isOnline: isOnline ?? this.isOnline,
      tamStatus: tamStatus ?? this.tamStatus,
      goToScreen: goToScreen ?? this.goToScreen,
      latestTransaction: latestTransaction ?? this.latestTransaction,
    );
  }

  bool save(FlutterSecureStorage storage) {
    storage.write(key: 'profile', value: jsonEncode(profile));
    storage.write(key: 'transactions', value: jsonEncode(transactions));
    storage.write(key: 'favorites', value: jsonEncode(favorites));
    storage.write(
        key: 'bkvc', value: jsonEncode(base64Encode(bkvc!.toBytes())));
    storage.write(key: 'primary', value: jsonEncode(primary));
    storage.write(key: 'serverPublicKey', value: jsonEncode(serverPublicKey));
    storage.write(key: 'sessionToken', value: jsonEncode(sessionToken));
    return true;
  }

  static Future<DataState> fromStorage(FlutterSecureStorage storage) async {
    var storageProfile = await storage.read(key: 'profile');
    print(storageProfile);
    var decodedProfile = jsonDecode(storageProfile!);
    decodedProfile['dob'] = int.parse(decodedProfile['dob']);

    Profile? storageProfileObj =
        decodedProfile == null ? null : Profile.fromJson(decodedProfile);
    var userID = storageProfileObj?.id;

    var storageTransactions = await storage.read(key: 'transactions');
    Transactions storageTransactionsObj = storageTransactions == null
        ? Transactions(transactions: [])
        : Transactions.fromMap(jsonDecode(storageTransactions), userID!);

    var storageBkvc = await storage.read(key: 'bkvc');
    BalanceKeyVerificationCertificate? storageBkvcObj = storageBkvc == null
        ? null
        : BalanceKeyVerificationCertificate.fromBase64(jsonDecode(storageBkvc));

    var storagePrimary = await storage.read(key: 'primary');
    bool storagePrimaryObj =
        storagePrimary == null ? false : jsonDecode(storagePrimary) as bool;

    var favorites = await storage.read(key: 'favorites');
    var decodedFavorites = jsonDecode(favorites!);
    decodedFavorites.forEach((element) {
      element['date_added'] = int.parse(element['date_added']);
    });
    List<Favorite> storageFavoritesObj = decodedFavorites == null
        ? []
        : (decodedFavorites as List<dynamic>)
            .map((e) => Favorite.fromJson(e))
            .toList();

    var storageServerPublicKey = await storage.read(key: 'serverPublicKey');
    SimplePublicKey? storageServerPublicKeyObj = storageServerPublicKey == null
        ? null
        : jsonDecode(storageServerPublicKey);

    var storageSessionToken = await storage.read(key: 'sessionToken');
    String? storageSessionTokenObj = storageSessionToken == null
        ? null
        : jsonDecode(storageSessionToken) as String;

    DataState newState = DataState(
      profile: storageProfileObj,
      transactions: storageTransactionsObj,
      favorites: storageFavoritesObj,
      bkvc: storageBkvcObj,
      primary: storagePrimaryObj,
      serverPublicKey: storageServerPublicKeyObj,
      sessionToken: storageSessionTokenObj,
      isLoaded: true,
    );

    print("From Storage Load: $newState");
    return newState;
  }

  @override
  List<Object?> get props => [
        profile,
        transactions,
        favorites,
        bkvc,
        primary,
        serverPublicKey,
        sessionToken,
        isLoaded,
        isOnline,
        tamStatus,
        goToScreen,
        latestTransaction,
      ];
}
