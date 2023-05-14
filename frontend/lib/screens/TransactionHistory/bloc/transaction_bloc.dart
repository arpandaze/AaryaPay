import 'package:aaryapay/repository/transaction.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:libaaryapay/transaction/tvc.dart';
import 'package:uuid/uuid.dart';

part 'transaction_event.dart';
part 'transaction_state.dart';

class TranscationBloc extends Bloc<TranscationEvent, TranscationState> {
  final transactionRepository = TransactionRepository();

  static const storage = FlutterSecureStorage();

  TranscationBloc() : super(const TranscationState()) {
    on<LoadTransaction>(_onLoadTransaction);
    on<LoadParticularUser>(_onLoadParticularUser);
    on<ClearLoadedUser>(_onClearLoadedUser);
    add(LoadTransaction());
  }

  void _onLoadTransaction(
      LoadTransaction event, Emitter<TranscationState> emit) async {
    try {
      var decodedData = await transactionRepository.getTransactions();
      var user_id = (await storage.read(key: 'user_id'));
      var uuid = UuidValue.fromList(Uuid.parse(user_id!));

      List<Map<String, dynamic>>? decodedTVC = [];
      for (var item in decodedData['data']) {
        bool isSender = false;
        TransactionVerificationCertificate senderTVC =
            TransactionVerificationCertificate.fromBase64(item['sender_tvc']);
        TransactionVerificationCertificate recieverTVC =
            TransactionVerificationCertificate.fromBase64(item['receiver_tvc']);
        if (senderTVC.from == uuid) {
          isSender = true;
        }

        decodedTVC.add({
          "senderTVC": senderTVC,
          "receiverTVC": recieverTVC,
          "isSender": isSender,
          "transactionID" : item['id']
        });
      }

      emit(state.copywith(
          loaded: true,
          transactionHistory: decodedData['data'],
          transactionDecoded: decodedTVC));
    } catch (e) {
      print(e.toString());
    }
  }

  void _onClearLoadedUser(
      ClearLoadedUser event, Emitter<TranscationState> emit) async {
    emit(TranscationState(
        transactionHistory: state.transactionHistory, loaded: true));
  }

  void _onLoadParticularUser(
      LoadParticularUser event, Emitter<TranscationState> emit) async {
    var decodedData = await transactionRepository.getUserName(
        event.senderID, event.recieverID);

    if (decodedData?["success"]) {
      String sMidName = "";
      String rMidName = "";
      if (decodedData?["sender"]["middle_name"] != "") {
        sMidName = decodedData?["sender"]["middle_name"] + " ";
      }
      if (decodedData?["reciever"]["middle_name"] != "") {
        rMidName = decodedData?["reciever"]["middle_name"] + " ";
      }
      emit(
        state.copywith(
          senderName:
              "${decodedData?["sender"]["first_name"]} $sMidName${decodedData?["sender"]["last_name"]}",
          recieverName:
              "${decodedData?["reciever"]["first_name"]} $rMidName${decodedData?["reciever"]["last_name"]}",
          item: event.item,
        ),
      );
    }
  }
}
