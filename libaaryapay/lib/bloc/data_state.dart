import 'package:equatable/equatable.dart';
import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:cryptography/cryptography.dart';
import 'package:libaaryapay/caching/profile.dart';
import 'package:libaaryapay/caching/transaction.dart';
import 'package:libaaryapay/caching/favorite.dart';
import 'package:libaaryapay/transaction/bkvc.dart';

const backendBase = 'http://localhost:8080';

class DataState extends Equatable {
  final SimplePublicKey? serverPublicKey;

  final Profile? profile;
  final Transactions transactions;
  final List<Favorite> favorites;
  final String? sessionToken;
  final BalanceKeyVerificationCertificate? bkvc;
  final bool? primary;

  final DateTime? lastSyncTime;

  final bool isLoaded;

  SimplePublicKey get userPublicKey {
    return bkvc!.getPublicKey();
  }

  double get balance {
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

  const DataState({
    this.profile,
    this.transactions = const Transactions(transactions: []),
    this.favorites = const [],
    this.bkvc,
    this.primary,
    this.lastSyncTime,
    this.serverPublicKey,
    this.sessionToken,
    this.isLoaded = false,
  });

  DataState copyWith({
    Profile? profile,
    List<Favorite>? favorites,
    Transactions? transactions,
    BalanceKeyVerificationCertificate? bkvc,
    bool? primary,
    DateTime? lastSyncTime,
    SimplePublicKey? serverPublicKey,
    String? sessionToken,
    bool? isLoaded,
  }) {
    return DataState(
      profile: profile ?? this.profile,
      favorites: favorites ?? this.favorites,
      transactions: transactions ?? this.transactions,
      bkvc: bkvc ?? this.bkvc,
      primary: primary ?? this.primary,
      lastSyncTime: lastSyncTime ?? this.lastSyncTime,
      serverPublicKey: serverPublicKey ?? this.serverPublicKey,
      sessionToken: sessionToken ?? this.sessionToken,
      isLoaded: isLoaded ?? this.isLoaded,
    );
  }

  void save(FlutterSecureStorage storage) {
    storage.write(key: 'profile', value: jsonEncode(profile));
    storage.write(key: 'transactions', value: jsonEncode(transactions));
    storage.write(key: 'favorites', value: jsonEncode(favorites));
    storage.write(key: 'bkvc', value: jsonEncode(bkvc));
    storage.write(key: 'primary', value: jsonEncode(primary));
    storage.write(key: 'lastSyncTime', value: jsonEncode(lastSyncTime));
    storage.write(key: 'serverPublicKey', value: jsonEncode(serverPublicKey));
    storage.write(key: 'sessionToken', value: jsonEncode(sessionToken));
  }

  static Future<DataState> fromStorage(FlutterSecureStorage storage) async {
    var storageProfile = await storage.read(key: 'profile');
    Profile storageProfileObj =
        storageProfile == null ? null : jsonDecode(storageProfile);

    var storageTransactions = await storage.read(key: 'transactions');
    Transactions storageTransactionsObj = storageTransactions == null
        ? Transactions(transactions: [])
        : jsonDecode(storageTransactions);

    var storageBkvc = await storage.read(key: 'bkvc');
    BalanceKeyVerificationCertificate storageBkvcObj =
        storageBkvc == null ? null : jsonDecode(storageBkvc);

    var storagePrimary = await storage.read(key: 'primary');
    bool storagePrimaryObj =
        storagePrimary == null ? false : jsonDecode(storagePrimary) as bool;

    var storageLastSyncTime = await storage.read(key: 'lastSyncTime');
    DateTime storageLastSyncTimeObj = storageLastSyncTime == null
        ? DateTime.fromMillisecondsSinceEpoch(0)
        : jsonDecode(storageLastSyncTime) as DateTime;

    var favorites = await storage.read(key: 'favorites');
    List<Favorite> storageFavoritesObj = favorites == null
        ? []
        : jsonDecode(favorites).map((e) => Favorite.fromJson(e)).toList();

    var storageServerPublicKey = await storage.read(key: 'serverPublicKey');
    SimplePublicKey? storageServerPublicKeyObj = storageServerPublicKey == null
        ? null
        : jsonDecode(storageServerPublicKey) as SimplePublicKey;

    var storageSessionToken = await storage.read(key: 'sessionToken');
    String? storageSessionTokenObj = storageSessionToken == null
        ? null
        : jsonDecode(storageSessionToken) as String;

    return DataState(
      profile: storageProfileObj,
      transactions: storageTransactionsObj,
      favorites: storageFavoritesObj,
      bkvc: storageBkvcObj,
      primary: storagePrimaryObj,
      lastSyncTime: storageLastSyncTimeObj,
      serverPublicKey: storageServerPublicKeyObj,
      sessionToken: storageSessionTokenObj,
    );
  }

  @override
  List<Object?> get props => [
        profile,
        transactions,
        favorites,
        bkvc,
        primary,
        lastSyncTime,
        serverPublicKey,
        sessionToken,
        isLoaded,
      ];
}
