import 'dart:async';

import 'package:flutter/material.dart';
// import 'package:gtk_flutter/src/authentication.dart';
import 'package:gtk_flutter/src/widgets.dart';
// import 'package:provider/provider.dart';

// import 'main.dart';

class GuestBookMessage {
  GuestBookMessage({required this.name, required this.message});

  final String name;
  final String message;
}

enum Attending { yes, no, unknown }

class GuestBook extends StatefulWidget {
  const GuestBook({required this.addMessage, required this.messages});

  final FutureOr<void> Function(String message) addMessage;
  final List<GuestBookMessage> messages; // new

  @override
  _GuestBookState createState() => _GuestBookState();
}

class _GuestBookState extends State<GuestBook> {
  final _formKey = GlobalKey<FormState>(debugLabel: '_GuestBookState');
  final _controller = TextEditingController();

  @override
  // Modify from here
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // to here.
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Leave a message',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter your message to continue';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 8),
                StyledButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      await widget.addMessage(_controller.text);
                      _controller.clear();
                    }
                  },
                  child: Row(
                    children: const [
                      Icon(Icons.send),
                      SizedBox(width: 4),
                      Text('SEND'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        // Modify from here
        const SizedBox(height: 8),
        for (var message in widget.messages)
          Paragraph('${message.name}: ${message.message}'),
        const SizedBox(height: 8),
      ],
      // to here.
    );
  }
}

class YesNoSelection extends StatelessWidget {
  const YesNoSelection({required this.state, required this.onSelection});

  final Attending state;
  final void Function(Attending selection) onSelection;

  @override
  Widget build(BuildContext context) {
    switch (state) {
      case Attending.yes:
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(elevation: 0),
                onPressed: () => onSelection(Attending.yes),
                child: const Text('YES'),
              ),
              const SizedBox(width: 8),
              TextButton(
                onPressed: () => onSelection(Attending.no),
                child: const Text('NO'),
              ),
            ],
          ),
        );
      case Attending.no:
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              TextButton(
                onPressed: () => onSelection(Attending.yes),
                child: const Text('YES'),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                style: ElevatedButton.styleFrom(elevation: 0),
                onPressed: () => onSelection(Attending.no),
                child: const Text('NO'),
              ),
            ],
          ),
        );
      default:
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              StyledButton(
                onPressed: () => onSelection(Attending.yes),
                child: const Text('YES'),
              ),
              const SizedBox(width: 8),
              StyledButton(
                onPressed: () => onSelection(Attending.no),
                child: const Text('NO'),
              ),
            ],
          ),
        );
    }
  }
}


// class HomePage extends StatelessWidget {
//   const HomePage({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Consumer<ApplicationState>(
//       builder: (context, appState, _) => Authentication(
//         email: appState.email,
//         loginState: appState.loginState,
//         startLoginFlow: appState.startLoginFlow,
//         verifyEmail: appState.verifyEmail,
//         signInWithEmailAndPassword: appState.signInWithEmailAndPassword,
//         cancelRegistration: appState.cancelRegistration,
//         registerAccount: appState.registerAccount,
//         signOut: appState.signOut,
//       ),
//     );
//   }
// }


//
// class HomePage extends StatelessWidget {
//   const HomePage({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Consumer<ApplicationState>(
//       builder: (context, appState, _) => Authentication(
//         email: appState.email,
//         loginState: appState.loginState,
//         startLoginFlow: appState.startLoginFlow,
//         verifyEmail: appState.verifyEmail,
//         signInWithEmailAndPassword: appState.signInWithEmailAndPassword,
//         cancelRegistration: appState.cancelRegistration,
//         registerAccount: appState.registerAccount,
//         signOut: appState.signOut,
//       ),
//     );
//     // return Scaffold(
//     //   appBar: AppBar(
//     //     title: const Text('Firebase Meetup'),
//     //   ),
//     //   body: ListView(
//     //     children: <Widget>[
//     //       Image.asset('assets/codelab.png'),
//     //       const SizedBox(height: 8),
//     //       const IconAndDetail(Icons.calendar_today, 'October 30'),
//     //       const IconAndDetail(Icons.location_city, 'San Francisco'),
//     //       Consumer<ApplicationState>(
//     //         builder: (context, appState, _) => Authentication(
//     //           email: appState.email,
//     //           loginState: appState.loginState,
//     //           startLoginFlow: appState.startLoginFlow,
//     //           verifyEmail: appState.verifyEmail,
//     //           signInWithEmailAndPassword: appState.signInWithEmailAndPassword,
//     //           cancelRegistration: appState.cancelRegistration,
//     //           registerAccount: appState.registerAccount,
//     //           signOut: appState.signOut,
//     //         ),
//     //       ),
//     //       const Divider(
//     //         height: 8,
//     //         thickness: 1,
//     //         indent: 8,
//     //         endIndent: 8,
//     //         color: Colors.grey,
//     //       ),
//     //       const Header("What we'll be doing"),
//     //       const Paragraph(
//     //         'Join us for a day full of Firebase Workshops and Pizza!',
//     //       ),
//     //       // Modify from here
//     //       Consumer<ApplicationState>(
//     //         builder: (context, appState, _) => Column(
//     //           crossAxisAlignment: CrossAxisAlignment.start,
//     //           children: [
//     //             // Add from here
//     //             if (appState.attendees >= 2)
//     //               Paragraph('${appState.attendees} people going')
//     //             else if (appState.attendees == 1)
//     //               const Paragraph('1 person going')
//     //             else
//     //               const Paragraph('No one going'),
//     //             // To here.
//     //             if (appState.loginState == ApplicationLoginState.loggedIn) ...[
//     //               // Add from here
//     //               YesNoSelection(
//     //                 state: appState.attending,
//     //                 onSelection: (attending) => appState.attending = attending,
//     //               ),
//     //               // To here.
//     //               const Header('Discussion'),
//     //               GuestBook(
//     //                 addMessage: (message) =>
//     //                     appState.addMessageToGuestBook(message),
//     //                 messages: appState.guestBookMessages,
//     //               ),
//     //             ],
//     //           ],
//     //         ),
//     //       ),
//     //       // To here.
//     //     ],
//     //   ),
//     // );
//   }
// }