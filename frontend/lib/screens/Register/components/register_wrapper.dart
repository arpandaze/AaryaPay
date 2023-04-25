// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:aaryapay/components/CustomActionButton.dart';
//
// class RegisterWrapper extends StatelessWidget {
//   const RegisterWrapper(
//       {Key? key,
//       required this.children,
//       this.backButton,
//       this.title,
//       this.pageIndex,
//       this.backButttonFunction,
//       this.actionButtonFunction,
//       this.actionButtonLabel})
//       : super(key: key);
//   final Widget children;
//   final bool? backButton;
//   final String? title;
//   final String? pageIndex;
//   final String? actionButtonLabel;
//   final Function()? backButttonFunction;
//   final Function()? actionButtonFunction;
//
//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;
//     return Scaffold(
//         backgroundColor: Theme.of(context).colorScheme.background,
//         body: SafeArea(
//           top: true,
//           bottom: true,
//           left: true,
//           right: true,
//           child: body(size, context),
//         ));
//   }
//
//   Widget body(Size size, BuildContext context) {
//     return SingleChildScrollView(
//       child: Column(
//         children: [
//           SizedBox(
//             height: size.height * 0.1,
//             child: Container(
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Container(
//                     width: size.width * 0.1,
//                     // padding: const EdgeInsets.all(15),
//                     alignment: Alignment.center,
//                     child: Visibility(
//                         visible: backButton ?? false,
//                         child: GestureDetector(
//                             behavior: HitTestBehavior.opaque,
//                             onTap: backButttonFunction,
//                             child: const Icon(
//                               FontAwesomeIcons.arrowLeftLong,
//                               size: 20,
//                             ))),
//                   ),
//                   Container(
//                     alignment: Alignment.center,
//                     padding: const EdgeInsets.all(15),
//                     child: Text(title!,
//                         style: Theme.of(context).textTheme.headlineSmall!),
//                   ),
//                   Container(
//                     width: size.width * 0.1,
//                     alignment: Alignment.center,
//                     // padding: const EdgeInsets.all(15),
//                     child: Text("${pageIndex}",
//                         style: Theme.of(context).textTheme.titleSmall!),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           Container(  
//             height: size.height * 0.3,
//             decoration: const BoxDecoration(
//               image: DecorationImage(
//                 fit: BoxFit.contain,
//                 image: AssetImage("assets/images/logo.png"),
//               ),
//             ),
//           ),
//           Container(
//             height: size.height * 0.48,
//             padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
//             child: children,
//           ),
//           Container(
//             child: CustomActionButton(
//               width: size.width * 0.78,
//               borderRadius: 10,
//               label: actionButtonLabel,
//               onClick: actionButtonFunction,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
