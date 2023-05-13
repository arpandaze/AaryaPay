import 'dart:convert';

import 'package:cryptography/cryptography.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import "package:libaaryapay/bloc/data_event.dart";
import "package:libaaryapay/bloc/data_state.dart";
import 'package:libaaryapay/caching/favorite.dart';
import 'package:libaaryapay/caching/profile.dart';
import 'package:libaaryapay/caching/transaction.dart';
import 'package:libaaryapay/transaction/bkvc.dart';
import 'package:libaaryapay/transaction/utils.dart';

const backendBase = 'http://localhost:8080';

class DataBloc extends Bloc<DataEvent, DataState> {
  static const storage = FlutterSecureStorage();
  final httpclient = http.Client();

  DataBloc() : super(const DataState()) {
    on<LoadDataEvent>(_onLoadData);
    on<RequestSyncEvent>(_onRequestSync);
    on<SubmitTVCEvent>(_onSubmitTVC);
    on<SubmitTAMEvent>(_onSubmitTAM);
    on<UserAuthenticatedEvent>(_onUserAuthenticated);
    on<UpdateServerKeyEvent>(_onUpdateServerKey);
    add(LoadDataEvent());
  }

  Future<void> _onLoadData(
    LoadDataEvent event,
    Emitter<DataState> emit,
  ) async {
    emit(await DataState.fromStorage(storage));
    add(RequestSyncEvent());
  }

  Future<void> _onRequestSync(
    RequestSyncEvent event,
    Emitter<DataState> emit,
  ) async {
    var url = Uri.parse('$backendBase/v1/sync');

    var transactionToSubmit =
        await state.transactions.getUnsubmittedTransactions();

    var base64Transactions = transactionToSubmit
        .map(
          (transaction) => base64.encode(
            transaction.authorizationMessage!.toBytes(),
          ),
        )
        .toList();

    final headers = {
      "Content-Type": "application/x-www-form-urlencoded",
      "Cookie": "session=${state.sessionToken}",
    };

    http.Response response;
    if (transactionToSubmit.isEmpty) {
      response = await httpclient.post(url, headers: headers);
    } else {
      response = await httpclient.post(url, headers: headers, body: {
        'transactions': base64Transactions,
      });
    }

    if (response.statusCode != 200) {
      return;
    }

    var resposeData = jsonDecode(response.body);

    List<Favorite> favorites = resposeData['favorites']
        .map<Favorite>(
          (favorite) => Favorite.fromJson(favorite),
        )
        .toList();

    BalanceKeyVerificationCertificate bkvc =
        BalanceKeyVerificationCertificate.fromBase64(resposeData['bkvc']);

    Profile profile = Profile.fromJson(resposeData['profile']);

    Transactions transactions = Transactions.fromJson(
      resposeData['transactions'],
      bkvc.userID,
    );

    DateTime lastSyncTime = bkvc.timeStamp;

    DataState newState = DataState(
      profile: profile,
      transactions: transactions,
      favorites: favorites,
      bkvc: bkvc,
      primary: state.primary,
      lastSyncTime: lastSyncTime,
      serverPublicKey: state.serverPublicKey,
      sessionToken: state.sessionToken,
      isLoaded: true,
    );

    emit(newState);
  }

  Future<void> _onSubmitTAM(
    SubmitTAMEvent event,
    Emitter<DataState> emit,
  ) async {
    var transaction = Transaction(
      authorizationMessage: event.tam,
      credit: event.tam.to == state.bkvc!.userID,
    );

    var newTransactions = Transactions(
      transactions: [...state.transactions.transactions, transaction],
    );

    DataState newState = state.copyWith(
      transactions: newTransactions,
    );

    newState.save(storage);
    emit(newState);

    add(RequestSyncEvent());
  }

  Future<void> _onSubmitTVC(
    SubmitTVCEvent event,
    Emitter<DataState> emit,
  ) async {
    Transaction? transaction;

    bool verified = await event.tvc.verify(state.serverPublicKey!);

    if (!verified) {
      throw Exception('TVC could not be verified!');
    }

    if (event.tvc.from != state.bkvc!.userID) {
      transaction = Transaction(
        receiverTvc: event.tvc,
        credit: true,
      );
    } else {
      transaction = Transaction(
        senderTvc: event.tvc,
        credit: false,
      );
    }

    var newTransactions = Transactions(
      transactions: [...state.transactions.transactions, transaction],
    );

    DataState newState = state.copyWith(
      transactions: newTransactions,
    );

    newState.save(storage);
    emit(newState);
  }

  Future<void> _onUpdateServerKey(
    UpdateServerKeyEvent event,
    Emitter<DataState> emit,
  ) async {
    var url = Uri.parse('$backendBase/v1/keys/server_keys');

    final response = await httpclient.get(url);

    var resposeData = jsonDecode(response.body);

    var publicKeyBase64 = resposeData['pubkey'];

    if (publicKeyBase64 == null) {
      throw Exception('Server key could not be retrieved!');
    }

    var serverPublicKeyDecoded = publicKeyFromBase64(publicKeyBase64);

    bool verified = await Ed25519().verify(
      utf8.encode(resposeData['message']),
      signature: Signature(
        base64Decode(resposeData['signature']),
        publicKey: serverPublicKeyDecoded,
      ),
    );

    if (!verified) {
      throw Exception('Server key could not be verified!');
    }

    DataState newState =
        state.copyWith(serverPublicKey: serverPublicKeyDecoded);

    newState.save(storage);

    emit(newState);
  }

  Future<void> _onUserAuthenticated(
    UserAuthenticatedEvent event,
    Emitter<DataState> emit,
  ) async {
    emit(state.copyWith(
      sessionToken: event.sessionToken,
      primary: event.isPrimary,
      isLoaded: false,
    ));
    add(RequestSyncEvent());
  }
}
