import 'dart:convert';
import 'dart:typed_data';

import 'package:aaryapay/global/bloc/data_bloc.dart';
import 'package:aaryapay/global/caching/transaction.dart';
import 'package:aaryapay/helper/utils.dart';
import 'package:aaryapay/screens/QrScan/components/bottom_bar.dart';
import 'package:aaryapay/screens/QrScan/components/qr_scanner_overlay.dart';
import 'package:aaryapay/screens/Send/payment_complete.dart';
import 'package:aaryapay/screens/Send/payment_recorded.dart';
import 'package:aaryapay/screens/Send/receiver_scan_confirmation.dart';
import 'package:aaryapay/screens/Send/send_money.dart';
import 'package:aaryapay/screens/Send/tvc_success_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aaryapay/screens/QrScan/qrscan_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QrScanScreen extends StatelessWidget {
  const QrScanScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocProvider(
      create: (context) => QrScannerBloc(),
      child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          body: SafeArea(
            top: true,
            bottom: true,
            left: true,
            right: true,
            child: body(size, context),
          )),
    );
  }

  Widget body(Size size, BuildContext context) {
    return BlocConsumer<DataBloc, DataState>(
      listener: (context, dataState) {
        if (dataState.goToScreen == GoToScreen.tvcSuccess) {
          Utils.mainAppNav.currentState!.push(
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  TVCSuccess(
                transaction: dataState.transactions.transactions.last,
              ),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                final curve = CurvedAnimation(
                  parent: animation,
                  curve: Curves.decelerate,
                );

                return Stack(
                  children: [
                    FadeTransition(
                      opacity: Tween<double>(
                        begin: 1.0,
                        end: 0.0,
                      ).animate(curve),
                    ),
                    SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0.0, 1.0),
                        end: Offset.zero,
                      ).animate(curve),
                      child: FadeTransition(
                        opacity: Tween<double>(
                          begin: 0.0,
                          end: 1.0,
                        ).animate(curve),
                        child: TVCSuccess(
                          transaction: dataState.transactions.transactions.last,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          );
        }
        if (dataState.goToScreen == GoToScreen.onlineTrans) {
          Utils.mainAppNav.currentState!.push(
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  PaymentComplete(
                transaction: dataState.latestTransaction!,
                sender: false,
              ),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                final curve = CurvedAnimation(
                  parent: animation,
                  curve: Curves.decelerate,
                );

                return Stack(
                  children: [
                    FadeTransition(
                      opacity: Tween<double>(
                        begin: 1.0,
                        end: 0.0,
                      ).animate(curve),
                    ),
                    SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0.0, 1.0),
                        end: Offset.zero,
                      ).animate(curve),
                      child: FadeTransition(
                        opacity: Tween<double>(
                          begin: 0.0,
                          end: 1.0,
                        ).animate(curve),
                        child: PaymentComplete(
                          transaction: dataState.latestTransaction!,
                          sender: false,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          );
        }
        if (dataState.goToScreen == GoToScreen.recOfflineTrans) {
          Utils.mainAppNav.currentState!.push(
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  PaymentRecorded(tvc: dataState.latestTransaction!),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                final curve = CurvedAnimation(
                  parent: animation,
                  curve: Curves.decelerate,
                );

                return Stack(
                  children: [
                    FadeTransition(
                      opacity: Tween<double>(
                        begin: 1.0,
                        end: 0.0,
                      ).animate(curve),
                    ),
                    SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0.0, 1.0),
                        end: Offset.zero,
                      ).animate(curve),
                      child: FadeTransition(
                        opacity: Tween<double>(
                          begin: 0.0,
                          end: 1.0,
                        ).animate(curve),
                        child:
                            PaymentRecorded(tvc: dataState.latestTransaction!),
                      ),
                    ),
                  ],
                );
              },
            ),
          );
        }
      },
      builder: (context, dataState) {
        return BlocConsumer<QrScannerBloc, QrScannerState>(
          listener: (context, state) {
            print("State Changed");

            if (state.isScanned && state.codeType == CodeType.TAM) {
              context.read<DataBloc>().add(SubmitTAMEvent(
                    state.tam!,
                    ticking: false,
                  ));
            }

            print(state.codeType);
            if (state.isScanned && state.codeType == CodeType.TVC) {
              context.read<DataBloc>().add(SubmitTVCEvent(
                    state.tvc!,
                  ));
            }
            if (state.isScanned && state.codeType == CodeType.user) {
              var result = utf8.decode(state.code!);
              var data = jsonDecode(result);
              print(data);
              var amount = dataState.balance;
              Utils.mainAppNav.currentState!.push(
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      SendMoney(
                    uuid: data['id'],
                    firstname: data['firstName'],
                    lastname: data['lastName'],
                    displayAmount: amount.toString(),
                  ),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    final curve = CurvedAnimation(
                      parent: animation,
                      curve: Curves.decelerate,
                    );

                    return Stack(
                      children: [
                        FadeTransition(
                          opacity: Tween<double>(
                            begin: 1.0,
                            end: 0.0,
                          ).animate(curve),
                        ),
                        SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0.0, 1.0),
                            end: Offset.zero,
                          ).animate(curve),
                          child: FadeTransition(
                            opacity: Tween<double>(
                              begin: 0.0,
                              end: 1.0,
                            ).animate(curve),
                            child: SendMoney(
                              uuid: data['id'],
                              firstname: data['firstName'],
                              lastname: data['lastName'],
                              displayAmount: amount.toString(),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              );

              context.read<QrScannerBloc>().add(CloseScanner());
            }
          },
          buildWhen: ((prev, next) => prev != next),
          builder: (context, state) {
            return Stack(
              children: [
                Container(
                  child: MobileScanner(
                    controller: MobileScannerController(
                      detectionSpeed: DetectionSpeed.noDuplicates,
                      facing: CameraFacing.back,
                      torchEnabled: false,
                    ),
                    onDetect: (capture) {
                      final List<Barcode> barcodes = capture.barcodes;
                      final Uint8List? image = capture.image;
                      for (final barcode in barcodes) {
                        context
                            .read<QrScannerBloc>()
                            .add(QrCodeScanned(barcode.rawBytes!));
                      }
                    },
                  ),
                ),
                QRScannerOverlay(
                  overlayColour: Colors.black.withOpacity(0.5),
                ),
                // Text(state.code ?? ""),
                Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.all(5),
                          child: IconButton(
                            onPressed: () => {
                              context.read<QrScannerBloc>().add(CloseScanner()),
                              Utils.mainAppNav.currentState!.pop()
                            },
                            icon: SvgPicture.asset('assets/icons/close.svg',
                                width: 20,
                                height: 20,
                                colorFilter: ColorFilter.mode(
                                    Theme.of(context).colorScheme.background,
                                    BlendMode.srcIn)),
                          ),
                        )
                      ],
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 40),
                      child: Text(
                        "Scan QR Code",
                        style: Theme.of(context).textTheme.displaySmall!.merge(
                              const TextStyle(height: 1.5).merge(
                                TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .background),
                              ),
                            ),
                      ),
                    ),
                    Text(
                      "to Pay",
                      style: Theme.of(context).textTheme.displaySmall!.merge(
                          const TextStyle(height: 1.5).merge(TextStyle(
                              color:
                                  Theme.of(context).colorScheme.background))),
                    ),
                  ],
                ),
                const BottomQrBar(),
              ],
            );
          },
        );
      },
    );
  }
}


// Utils.mainAppNav.currentState!.push(
//             PageRouteBuilder(
//               pageBuilder: (context, animation, secondaryAnimation) =>
//                   ReceiverConfirmation(
//                       transaction: dataState.latestTransaction),
//               transitionsBuilder:
//                   (context, animation, secondaryAnimation, child) {
//                 final curve = CurvedAnimation(
//                   parent: animation,
//                   curve: Curves.decelerate,
//                 );

//                 return Stack(
//                   children: [
//                     FadeTransition(
//                       opacity: Tween<double>(
//                         begin: 1.0,
//                         end: 0.0,
//                       ).animate(curve),
//                     ),
//                     SlideTransition(
//                       position: Tween<Offset>(
//                         begin: const Offset(0.0, 1.0),
//                         end: Offset.zero,
//                       ).animate(curve),
//                       child: FadeTransition(
//                         opacity: Tween<double>(
//                           begin: 0.0,
//                           end: 1.0,
//                         ).animate(curve),
//                         child: ReceiverConfirmation(
//                             transaction: dataState.latestTransaction),
//                       ),
//                     ),
//                   ],
//                 );
//               },
//             ),
//           );