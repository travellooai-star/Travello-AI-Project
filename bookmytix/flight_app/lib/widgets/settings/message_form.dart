import 'package:flight_app/ui/themes/theme_breakpoints.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:flight_app/models/list_item.dart';
import 'package:flight_app/ui/themes/theme_button.dart';
import 'package:flight_app/ui/themes/theme_spacing.dart';
import 'package:flight_app/ui/themes/theme_text.dart';
import 'package:flight_app/utils/picker.dart';
import 'package:flight_app/widgets/app_input/app_textfield.dart';

class MessageForm extends StatefulWidget {
  const MessageForm({super.key});

  @override
  State<MessageForm> createState() => _MessageFormState();
}

class _MessageFormState extends State<MessageForm> {
  final TextEditingController _chooseRef = TextEditingController();
  String? categoryTemp;
  final _messageKey = GlobalKey<FormBuilderState>();

  List<ListItem> categoryOptions = [
    ListItem(
      value: 'booking',
      label: 'Booking Assistance',
    ),
    ListItem(
      value: 'cancellation',
      label: 'Cancellation & Refund',
    ),
    ListItem(
      value: 'payment',
      label: 'Payment Issues',
    ),
    ListItem(
      value: 'account',
      label: 'Account Management',
    ),
    ListItem(
      value: 'technical',
      label: 'Technical Support',
    ),
    ListItem(
      value: 'feedback',
      label: 'Feedback & Suggestions',
    ),
    ListItem(
      value: 'other',
      label: 'Other Inquiries',
    ),
  ];

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: EdgeInsets.all(spacingUnit(4)),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  Theme.of(context).colorScheme.secondary.withOpacity(0.1),
                ],
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.all(spacingUnit(2)),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 60,
                  ),
                ),
                SizedBox(height: spacingUnit(2)),
                const Text(
                  'Message Sent Successfully!',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: spacingUnit(1)),
                Text(
                  'Thank you for contacting Travello AI',
                  style: ThemeText.subtitle2.copyWith(
                    color: Colors.grey.shade600,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: spacingUnit(1)),
                const Text(
                  'Our support team will get back to you within 24 hours.',
                  style: ThemeText.paragraph,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: spacingUnit(3)),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      _messageKey.currentState?.reset();
                      _chooseRef.clear();
                      setState(() {
                        categoryTemp = null;
                      });
                    },
                    style: ThemeButton.btnBig.merge(ThemeButton.primary),
                    child: const Text('DONE'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void openPicker(BuildContext context) {
    openRadioPicker(
      context: context,
      options: categoryOptions,
      title: 'Choose Category',
      initialValue: categoryTemp,
      onSelected: (value) {
        if (value != null) {
          String result =
              categoryOptions.firstWhere((e) => e.value == value).label;

          _messageKey.currentState?.patchValue({
            'topic': result,
          });
          _chooseRef.text = result;
        }
        setState(() {
          categoryTemp = value;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: ThemeSize.sm),
        child: FormBuilder(
          key: _messageKey,
          child: ListView(padding: EdgeInsets.all(spacingUnit(2)), children: [
            const VSpaceShort(),
            const Text(
                'We\'re here to help! Send us a message about your travel booking or any questions you have.',
                style: ThemeText.headline),
            const VSpace(),
            FormBuilderField(
              name: 'topic',
              builder: (FormFieldState<dynamic> field) {
                return AppTextField(
                  controller: _chooseRef,
                  label: 'Choose Topic',
                  onChanged: (value) => field.didChange(value),
                  errorText: field.hasError ? 'Please choose a topic' : null,
                  onTap: () {
                    openPicker(context);
                  },
                  suffix: const Icon(Icons.arrow_drop_down),
                );
              },
              validator: FormBuilderValidators.required(),
            ),
            const VSpaceShort(),
            FormBuilderField(
                name: 'subject',
                builder: (FormFieldState<dynamic> field) {
                  return AppTextField(
                    label: 'Subject',
                    onChanged: (value) => field.didChange(value),
                  );
                }),
            const VSpaceShort(),
            FormBuilderField(
              name: 'description',
              builder: (FormFieldState<dynamic> field) {
                return AppTextField(
                  label: 'Description',
                  maxLines: 5,
                  onChanged: (value) => field.didChange(value),
                  errorText:
                      field.hasError ? 'Please write mssage description' : null,
                );
              },
              validator: FormBuilderValidators.required(),
            ),
            const VSpace(),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  if (_messageKey.currentState?.saveAndValidate() ?? false) {
                    debugPrint(_messageKey.currentState?.value.toString());
                    _showSuccessDialog();
                  }
                },
                style: ThemeButton.btnBig.merge(ThemeButton.primary),
                child: const Text('SEND MESSAGE'),
              ),
            )
          ]),
        ),
      ),
    );
  }
}
