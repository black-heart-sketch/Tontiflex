import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';
import 'package:tontiflex/database/payment/payment_controller.dart';
import 'package:tontiflex/database/user_db/user_controller.dart';
import 'package:tontiflex/routes/app_router.dart';
@RoutePage(name: 'RetrieveFundRoute')
class FundRetrievalForm extends StatefulWidget {
  const FundRetrievalForm({super.key});

  @override
  State<FundRetrievalForm> createState() => _FundRetrievalFormState();
}

class _FundRetrievalFormState extends State<FundRetrievalForm> {
  final _formKey = GlobalKey<FormBuilderState>();
  final amountController = TextEditingController();
  final phoneController = TextEditingController();
  final cardNumberController = TextEditingController();
  final cvvController = TextEditingController();
  String selectedRetrievalOption = 'OM';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Retrieve Funds"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 22),
                _buildTextField(amountController, "Amount", Icons.attach_money, keyboardType: TextInputType.number),
                const SizedBox(height: 15),
                _buildRetrievalOptions(),
                const SizedBox(height: 15),
                _buildRetrievalFields(),
                const SizedBox(height: 30),
                Center(
                  child: ElevatedButton(
                    onPressed: retrieveFunds,
                    child: const Text('Submit Retrieval Request'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint, IconData icon, {TextInputType keyboardType = TextInputType.text}) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, color: Colors.grey.withOpacity(0.7)),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _buildRetrievalOptions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildRetrievalOption("OM"),
        _buildRetrievalOption("MOMO"),
        _buildRetrievalOption("Credit Card"),
      ],
    );
  }

  Widget _buildRetrievalOption(String option) {
    return ChoiceChip(
      label: Text(option),
      selected: selectedRetrievalOption == option,
      onSelected: (_) => setState(() => selectedRetrievalOption = option),
      selectedColor: Colors.green,
    );
  }

  Widget _buildRetrievalFields() {
    if (selectedRetrievalOption == 'OM' || selectedRetrievalOption == 'MOMO') {
      return _buildTextField(phoneController, "Phone Number", Icons.phone, keyboardType: TextInputType.phone);
    } else if (selectedRetrievalOption == 'Credit Card') {
      return Column(
        children: [
          _buildTextField(cardNumberController, "Card Number", Icons.credit_card, keyboardType: TextInputType.number),
          const SizedBox(height: 15),
          _buildTextField(cvvController, "CVV", Icons.lock, keyboardType: TextInputType.number),
        ],
      );
    }
    return const SizedBox.shrink();
  }

  void retrieveFunds() async {
    final userController = Provider.of<UserController>(context, listen: false);
    final paymentController = Provider.of<PaymentController>(context, listen: false);
    final userId = userController.currentUser!.userId.toString();

    final retrievalRequest = {
      'userId': userId,
      'amount': amountController.text,
      'method': selectedRetrievalOption,
      'phone': (selectedRetrievalOption == 'OM' || selectedRetrievalOption == 'MOMO') ? phoneController.text : null,
      'cardNumber': selectedRetrievalOption == 'Credit Card' ? cardNumberController.text : null,
      'cvv': selectedRetrievalOption == 'Credit Card' ? cvvController.text : null,
    };

    // final result = await paymentController.retrieveFunds(retrievalRequest);
    // if (result) {
    //   AutoRouter.of(context).push(const EntryPointRoute());
    // }
  }
}



