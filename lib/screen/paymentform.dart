import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_svg/svg.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:tontiflex/database/history/history_class.dart';
import 'package:tontiflex/database/history/history_controller.dart';
import 'package:tontiflex/database/mutuelle/community_controller.dart';
import 'package:tontiflex/database/payment/payment_class.dart';
import 'package:tontiflex/database/payment/payment_controller.dart';
import 'package:tontiflex/database/user_db/user_controller.dart';
import 'package:tontiflex/database/mutuelle/community_class.dart'; // Updated import
import 'package:tontiflex/routes/app_router.dart';

import '../constants.dart';

@RoutePage(name: 'PaymentForm')
class Paymentform extends StatefulWidget {
  const Paymentform({super.key});

  @override
  State<Paymentform> createState() => _PaymentformState();
}

class _PaymentformState extends State<Paymentform> {
  final _formKey = GlobalKey<FormBuilderState>();
  final descriptionController = TextEditingController();
  final amountController = TextEditingController();
  final phoneController = TextEditingController();
  final cardNumberController = TextEditingController();
  final cvvController = TextEditingController();
  List<Community> userCommunities = []; // Updated to use Community
  String? selectedCommunity;
  String selectedPaymentOption = 'OM';

  @override
  void initState() {
    super.initState();
    fetchUserCommunities(); // Updated method name
  }

  void fetchUserCommunities() async {
    final userController = Provider.of<UserController>(context, listen: false);
    final communityController = Provider.of<CommunityController>(context, listen: false); // Updated to use CommunityController
    final userId = userController.currentUser!.userId.toString();
    userCommunities = await communityController.getCommunitiesByUserId(userId); // Updated to use CommunityController
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Payment"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset('assets/images/payer.png'),
                const SizedBox(height: 22),
                _buildTextField(descriptionController, "Description", Icons.description),
                const SizedBox(height: defaultPadding),
                _buildTextField(amountController, "Amount", Icons.attach_money, keyboardType: TextInputType.number),
                const SizedBox(height: defaultPadding),
                _buildCommunityDropdown(), // Updated method name
                const SizedBox(height: defaultPadding),
                _buildPaymentOptions(),
                const SizedBox(height: defaultPadding),
                _buildPaymentFields(),
                const SizedBox(height: defaultPadding * 2),
                Center(
                  child: ElevatedButton(
                    onPressed: makePayment,
                    child: Text('Submit Payment'),
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

  Widget _buildCommunityDropdown() {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        hintText: "Select a Community", // Updated hint text
        prefixIcon: Icon(Icons.arrow_drop_down, color: Colors.grey.withOpacity(0.7)),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      value: selectedCommunity,
      items: userCommunities.map((community) {
        return DropdownMenuItem(
          value: community.id, // Use community ID
          child: Text(community.name ?? 'No Name'), // Use community name
        );
      }).toList(),
      onChanged: (value) => setState(() => selectedCommunity = value),
    );
  }

  Widget _buildPaymentOptions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildPaymentOption("OM"),
        _buildPaymentOption("MOMO"),
        _buildPaymentOption("Credit Card"),
      ],
    );
  }

  Widget _buildPaymentOption(String option) {
    return ChoiceChip(
      label: Text(option),
      selected: selectedPaymentOption == option,
      onSelected: (_) => setState(() => selectedPaymentOption = option),
      selectedColor: Colors.blueAccent,
    );
  }

  Widget _buildPaymentFields() {
    if (selectedPaymentOption == 'OM' || selectedPaymentOption == 'MOMO') {
      return _buildTextField(phoneController, "Phone Number", Icons.phone, keyboardType: TextInputType.phone);
    } else if (selectedPaymentOption == 'Credit Card') {
      return Column(
        children: [
          _buildTextField(cardNumberController, "Card Number", Icons.credit_card, keyboardType: TextInputType.number),
          const SizedBox(height: defaultPadding),
          _buildTextField(cvvController, "CVV", Icons.lock, keyboardType: TextInputType.number),
        ],
      );
    }
    return SizedBox.shrink();
  }

  void makePayment() async {
    final logger = Logger();
    final userController = Provider.of<UserController>(context, listen: false);
    final paymentController = context.read<PaymentController>();
    final userId = userController.currentUser!.userId.toString();
    final communityName = userCommunities.firstWhere((c) => c.id == selectedCommunity)?.name;
    logger.e(selectedCommunity);
    Payment payment = Payment(
      userId: userId,
      description: descriptionController.text,
      amount: amountController.text,
      paymentMethod: selectedPaymentOption,
      phoneNumber: (selectedPaymentOption == 'OM' || selectedPaymentOption == 'MOMO') ? phoneController.text : null,
      cardNumber: selectedPaymentOption == 'Credit Card' ? cardNumberController.text : null,
      cvv: selectedPaymentOption == 'Credit Card' ? cvvController.text : null,
      communityId: selectedCommunity,
    );

    final result = await paymentController.makePayment(payment);
    if (result) {
      // Create a history record for the payment
      final history = History(
        userId: payment.userId, // Assuming payment has a userId field
        communityId: payment.communityId, // Assuming payment has a communityId field
        amount: payment.amount, // Assuming payment has an amount field
        date: DateTime.now().toString(), // Use the current date and time
        communityName: communityName, // Add the community name
      );

      // Use the HistoryController to create the history
      final historyController = context.read<HistoryController>();
      await historyController.createHistory(history);

      // Navigate to the next screen
      AutoRouter.of(context).push(const EntryPointRoute());
    }
  }
}