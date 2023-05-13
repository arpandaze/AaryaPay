import 'dart:convert';

import 'package:libaaryapay/transaction/tam.dart';
import 'package:libaaryapay/transaction/tvc.dart';
import 'package:uuid/uuid.dart';

class Transactions {
  final List<Transaction> transactions;
  const Transactions({this.transactions = const []});

  factory Transactions.fromJson(List<dynamic> json, UuidValue userId) {
    return Transactions(
      transactions: json.map<Transaction>((transaction) {
        return Transaction.fromJson(transaction, userId);
      }).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'transactions': transactions.map((transaction) {
        return transaction.toJson();
      }).toList(),
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'transactions': transactions.map((transaction) {
        return transaction.toMap();
      }).toList(),
    };
  }

  factory Transactions.fromMap(Map<String, dynamic> map, UuidValue userId) {
    return Transactions(
      transactions: List<Transaction>.from(
          map['transactions']?.map((x) => Transaction.fromMap(x, userId))),
    );
  }

  Future<List<Transaction>> getUnsubmittedTransactions() async {
    return transactions.where((element) => !element.isSubmitted).toList();
  }

  Future<Transaction> getLatest() async {
    return transactions.last;
  }
}

class Transaction {
  String? id;
  DateTime? verificationTime;

  String? senderFirstName;
  String? senderMiddleName;
  String? senderLastName;
  String? receiverFirstName;
  String? receiverMiddleName;
  String? receiverLastName;

  TransactionVerificationCertificate? senderTvc;
  TransactionVerificationCertificate? receiverTvc;
  TransactionAuthorizationMessage? authorizationMessage;

  bool credit;

  Transaction({
    required this.credit,
    this.id,
    this.verificationTime,
    this.senderFirstName,
    this.senderMiddleName,
    this.senderLastName,
    this.receiverFirstName,
    this.receiverMiddleName,
    this.receiverLastName,
    this.senderTvc,
    this.receiverTvc,
    this.authorizationMessage,
  });

  bool get isCredit {
    return credit;
  }

  bool get isDebit {
    return !credit;
  }

  bool get isSubmitted {
    return (senderTvc != null) || (receiverTvc != null);
  }

  UuidValue get senderId {
    if (isSubmitted) {
      var tvcChoice = senderTvc ?? receiverTvc;
      return tvcChoice!.from;
    } else {
      return authorizationMessage!.bkvc.userID;
    }
  }

  UuidValue get receiverId {
    if (isSubmitted) {
      return receiverTvc!.bkvc.userID;
    } else {
      return authorizationMessage!.to;
    }
  }

  double get amount {
    if (isSubmitted) {
      return senderTvc!.amount;
    } else {
      return authorizationMessage!.amount;
    }
  }

  DateTime get generationTime {
    return senderTvc!.timeStamp;
  }

  factory Transaction.fromJson(Map<String, dynamic> json, UuidValue userId) {
    var senderTVCBytes = base64Decode(json['sender_tvc']);
    var receiverTVCBytes = base64Decode(json['receiver_tvc']);

    var senderTvc =
        TransactionVerificationCertificate.fromBytes(senderTVCBytes);
    var receiverTvc =
        TransactionVerificationCertificate.fromBytes(receiverTVCBytes);

    var senderId = senderTvc.bkvc.userID;

    var isTransactionDebit = senderId == userId;

    return Transaction(
      id: json['id'],
      senderFirstName: json['sender_first_name'],
      senderMiddleName: json['sender_middle_name'],
      senderLastName: json['sender_last_name'],
      receiverFirstName: json['receiver_first_name'],
      receiverMiddleName: json['receiver_middle_name'],
      receiverLastName: json['receiver_last_name'],
      verificationTime: senderTvc.verificationTime,
      senderTvc: senderTvc,
      receiverTvc: receiverTvc,
      credit: isTransactionDebit,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sender_first_name': senderFirstName,
      'sender_middle_name': senderMiddleName,
      'sender_last_name': senderLastName,
      'receiver_first_name': receiverFirstName,
      'receiver_middle_name': receiverMiddleName,
      'receiver_last_name': receiverLastName,
      'sender_tvc': base64Encode(senderTvc!.toBytes()),
      'receiver_tvc': base64Encode(receiverTvc!.toBytes()),
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'sender_first_name': senderFirstName,
      'sender_middle_name': senderMiddleName,
      'sender_last_name': senderLastName,
      'receiver_first_name': receiverFirstName,
      'receiver_middle_name': receiverMiddleName,
      'receiver_last_name': receiverLastName,
      'sender_tvc':
          senderTvc != null ? base64Encode(senderTvc!.toBytes()) : null,
      'receiver_tvc':
          receiverTvc != null ? base64Encode(receiverTvc!.toBytes()) : null,
      'verification_time': verificationTime,
      'authorization_message': authorizationMessage != null
          ? base64Encode(authorizationMessage!.toBytes())
          : null,
      'credit': credit,
    };
  }

  factory Transaction.fromMap(Map<String, dynamic> map, UuidValue userId) {
    var senderTVCBytes = base64Decode(map['sender_tvc']);
    var receiverTVCBytes = base64Decode(map['receiver_tvc']);

    var senderTvc =
        TransactionVerificationCertificate.fromBytes(senderTVCBytes);
    var receiverTvc =
        TransactionVerificationCertificate.fromBytes(receiverTVCBytes);

    var senderId = senderTvc.bkvc.userID;

    var isTransactionDebit = senderId == userId;

    return Transaction(
      id: map['id'],
      senderFirstName: map['sender_first_name'],
      senderMiddleName: map['sender_middle_name'],
      senderLastName: map['sender_last_name'],
      receiverFirstName: map['receiver_first_name'],
      receiverMiddleName: map['receiver_middle_name'],
      receiverLastName: map['receiver_last_name'],
      verificationTime: map['verification_time'],
      senderTvc: senderTvc,
      receiverTvc: receiverTvc,
      credit: isTransactionDebit,
    );
  }
}
