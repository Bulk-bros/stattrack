import 'package:flutter/material.dart';
import 'package:stattrack/components/app/custom_app_bar.dart';
import 'package:stattrack/components/buttons/main_button.dart';
import 'package:stattrack/styles/font_styles.dart';

class TermsOfServicePage extends StatelessWidget {
  const TermsOfServicePage({Key? key, required this.onAccept})
      : super(key: key);

  final void Function() onAccept;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(headerTitle: 'Terms of Service'),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          _buildSection(title: 'Agreement to terms', body: [
            'By accepting our terms you confirm that you have read through and agree with every point dicussed belove'
          ]),
          _buildSection(title: 'Data storage', body: [
            'All your data will be stored in firebase, but can only be accessed when signed in with your credentials.',
            'You can at any times delete your account which will delete all data related to you and your account'
          ]),
          _buildSection(title: 'Your soul', body: [
            'By creating a account you accept that during the lifespan of your account your soul is sold to us at bulk bros :)'
          ]),
          MainButton(
            callback: onAccept,
            label: 'Accept',
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: FontStyles.fsTitle3,
          fontWeight: FontStyles.fwTitle,
        ),
      ),
    );
  }

  Widget _buildSection({required String title, required List<String> body}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        _buildSectionTitle(title),
        ...body.map((p) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(p),
              const SizedBox(
                height: 8.0,
              ),
            ],
          );
        }),
        const SizedBox(
          height: 16.0,
        ),
      ],
    );
  }
}
