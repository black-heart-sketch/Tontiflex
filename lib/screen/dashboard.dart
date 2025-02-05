import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:tontiflex/controllers/credit_request_controller.dart';
import 'package:tontiflex/database/credit/credit_class.dart';
import 'package:tontiflex/database/mutuelle/community_controller.dart';
import 'package:tontiflex/database/user_db/user_controller.dart';
import 'package:tontiflex/routes/app_router.dart';
import 'package:tontiflex/screen/history.dart';
import 'package:provider/provider.dart';
import '../database/payment/payment_class.dart';
import '../database/payment/payment_controller.dart';
import '../theme/color.dart';
import 'package:intl/intl.dart';

@RoutePage(name: 'DashBoardScreenRoute')
class DashbaordPage extends StatefulWidget {
  const DashbaordPage({Key? key}) : super(key: key);

  @override
  State<DashbaordPage> createState() => _DashbaordPageState();
}

class _DashbaordPageState extends State<DashbaordPage> {
  final PaymentController _paymentService = PaymentController();
  List<Payment> _userPayments = [];
  int pageIndex = 0;
  int _currentPage = 0;
  final PageController _pageController = PageController(viewportFraction: 0.8);
  double _totalAmount = 0;
  final logger = Logger();

  // Add these controllers
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _repaymentDateController = TextEditingController();

  // Add this property to store credit requests
  List<Credit> _creditRequests = [];

  double _totalDebt = 0.0;

  @override
  void initState() {
    super.initState();
    _fetchUserPayments();
    _fetchCreditRequests();
    _pageController.addListener(_onPageChanged);
  }

  @override
  void dispose() {
    _pageController.removeListener(_onPageChanged);
    _pageController.dispose();
    _amountController.dispose();
    _repaymentDateController.dispose();
    super.dispose();
  }

  void _onPageChanged() {
    int page = _pageController.page!.round();
    if (page != _currentPage) {
      setState(() {
        _currentPage = page;
      });
    }
  }

  Future<void> _fetchUserPayments() async {
    final userController = Provider.of<UserController>(context, listen: false);
    final userId = userController.currentUser!.userId.toString();
    try {
      List<Payment> payments = await _paymentService.getPaymentsByUserId(userId);
      double total = 0;
      for (var payment in payments) {
        // logger.e(payment.amount);
        total += double.parse(payment.amount);
      }
      setState(() {
        _userPayments = payments;
        _totalAmount = total;
      });
    } catch (e) {
      print('Error fetching user payments: $e');
    }
  }

  // Add this method to fetch credit requests
  Future<void> _fetchCreditRequests() async {
    final userController = Provider.of<UserController>(context, listen: false);
    final userId = userController.currentUser!.userId;
    final creditRequestController = Provider.of<CreditRequestController>(context, listen: false);

    try {
      List<Credit> requests = await creditRequestController.fetchCreditRequestsByUserId(userId.toString());
      double totalDebt = requests.fold(0, (sum, request) => sum + request.amount);
      setState(() {
        _creditRequests = requests;
        _totalDebt = totalDebt;
      });
    } catch (e) {
      print('Error fetching credit requests: $e');
    }
  }



  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: primary,
      appBar: PreferredSize(
        child: getAppBar(),
        preferredSize: Size.fromHeight(60),
      ),
      body: getBody(),
    );
  }

  Widget getAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: primary,
      leading: IconButton(
          onPressed: () {},
          icon:Icon(Icons.person)),
      actions: [IconButton(onPressed: () {}, icon: Icon(Icons.search))],
    );
  }

  Widget getBody() {
    final userCom=context.read<CommunityController>();
    final usercontro=context.read<UserController>();
    userCom.getCommunitiesByUserId(usercontro.currentUser!.userId.toString());
    var size = MediaQuery.of(context).size;
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: size.height * 0.25,
          decoration: BoxDecoration(color: primary),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: 110,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    PageView.builder(
                      controller: _pageController,
                      itemCount: userCom.userCommunities.length,
                      itemBuilder: (context, index) {
                        String comName = '';
                        double tota=0;
                        var community = userCom.userCommunities[index];
                        logger.e(userCom.userCommunities.length);
                        // logger.e(_userPayments[index].amount);
                        _userPayments.forEach((val){
                          if(val.communityId==community.id){
                            tota=tota+double.parse(val.amount);
                          }
                          logger.e('here is  $tota');
                        });
                        comName = community.name.toString();
                        bool isCurrent = index == _currentPage;
                        return AnimatedOpacity(
                          duration: Duration(milliseconds: 300),
                          opacity: isCurrent ? 1.0 : 0.5,
                          child: Container(
                            width: size.width * 0.7,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 5),
                                      child: Icon(
                                        Icons.currency_franc,
                                        size: 30,
                                        color: isCurrent ? white : white.withOpacity(0.5),
                                      ),
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                      tota.toString(),
                                      style: TextStyle(
                                        fontSize: 35,
                                        color: isCurrent ? white : white.withOpacity(0.5),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8),
                                Text(
                                  comName,
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: white.withOpacity(0.5),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    if (_currentPage > 0)
                      Positioned(
                        left: 0,
                        child: IconButton(
                          icon: Icon(Icons.arrow_back_ios, color: white),
                          onPressed: () {
                            _pageController.previousPage(
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          },
                        ),
                      ),
                    if (_currentPage < userCom.userCommunities.length - 1)
                      Positioned(
                        right: 0,
                        child: IconButton(
                          icon: Icon(Icons.arrow_forward_ios, color: white),
                          onPressed: () {
                            _pageController.nextPage(
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          },
                        ),
                      ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  width: double.infinity,
                  child: Row(
                    children: [
                      SizedBox(
                        width: 15,
                      ),
                      Flexible(
                        child: GestureDetector(
                          onTap: () =>  AutoRouter.of(context).push(PaymentForm()),

                  child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                                color: secondary.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(12)),
                            child: Center(
                              child: Text(
                                "Deposit",
                                style: TextStyle(
                                    color: white, fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Flexible(
                        child: GestureDetector(
                          onTap: (){
                            AutoRouter.of(context).push(RetrieveFundRoute());
                          },
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                                color: secondary.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(12)),
                            child: Center(
                              child: Text(
                                "Retrieval",
                                style: TextStyle(
                                    color: white, fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  color: white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25))),
              child: getAccountSection(),
            ),
          ),
        ),
      ],
    );
  }

  Widget getAccountSection() {
    return Padding(
      padding: const EdgeInsets.only(top: 25, bottom: 40, left: 15, right: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Accounts",
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 15,
          ),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: grey.withOpacity(0.1),
                  spreadRadius: 10,
                  blurRadius: 10,
                  // changes position of shadow
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                                color: secondary.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(12)),
                            child: Center(
                              child: Icon(
                                Icons.wallet,
                                color: primary,
                                size: 20,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Text(
                            "40832-810-5-7000-012345",
                            style: TextStyle(fontSize: 15),
                          )
                        ],
                      ),
                      Icon(
                        Icons.keyboard_arrow_down,
                        color: primary,
                      )
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 50),
                    child: Divider(
                      thickness: 0.2,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                            color: secondary.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(12)),
                        child: Center(
                          child: Icon(
                            Icons.currency_franc,
                            color: primary,
                            size: 20,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Text(
                        "${_totalAmount.toStringAsFixed(2)} Fcfa",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w600),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 50),
                    child: Divider(
                      thickness: 0.2,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                            color: secondary.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(12)),
                        child: Center(
                          child: Icon(
                            Icons.currency_exchange,
                            color: primary,
                            size: 20,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Text(
                        "${_totalDebt.toStringAsFixed(2)} Fcfa",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w600),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 25,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Demandes de credit",
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
              Container(
                width: 150,
                height: 40,
                child: ElevatedButton.icon(
                  onPressed: () => _showCreditRequestModal(context),
                  icon: Icon(Icons.add),
                  label: Text("Demander"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: secondary.withOpacity(0.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              )
            ],
          ),
          SizedBox(
            height: 15,
          ),
          // Replace the existing GestureDetector with this ListView
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: _creditRequests.length,
            itemBuilder: (context, index) {
              Credit request = _creditRequests[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: grey.withOpacity(0.1),
                        spreadRadius: 10,
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: secondary.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Center(
                                    child: Icon(
                                      Icons.credit_card,
                                      color: primary,
                                      size: 20,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 15),
                                Text(
                                  DateFormat('dd/MM/yyyy').format(request.requestDate),
                                  style: TextStyle(fontSize: 15),
                                ),
                              ],
                            ),
                            Text(
                              "${request.amount.toStringAsFixed(2)} Fcfa",
                              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Text(
                          "Remboursement: ${DateFormat('dd/MM/yyyy').format(request.repaymentDate)}",
                          style: TextStyle(fontSize: 13, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _showCreditRequestModal(BuildContext context) {
    // Reset controllers
    _amountController.clear();
    _repaymentDateController.clear();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Demande de Crédit',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _amountController,
                  decoration: InputDecoration(
                    labelText: 'Montant',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _repaymentDateController,
                  decoration: InputDecoration(
                    labelText: 'Date de remboursement',
                    border: OutlineInputBorder(),
                  ),
                  readOnly: true,
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now().add(Duration(days: 30)),
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(Duration(days: 365)),
                    );
                    if (pickedDate != null) {
                      String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
                      _repaymentDateController.text = formattedDate;
                    }
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    _submitCreditRequest();
                    Navigator.pop(context);
                  },
                  child: Text('Soumettre la demande'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _submitCreditRequest() async {
    // Get the current user ID
    final userController = Provider.of<UserController>(context, listen: false);
    final userId = userController.currentUser!.userId;
    final creditRequestController = Provider.of<CreditRequestController>(context, listen: false);

    // Prepare the credit request data
    Map<String, dynamic> creditRequestData = {
      'userId': userId,
      'amount': double.parse(_amountController.text),
      'requestDate': DateTime.now().toIso8601String(),
      'repaymentDate': _repaymentDateController.text,
    };
    Credit creditRequest = Credit(
      userId: int.parse(userId.toString()),
      amount: double.parse(_amountController.text),
      requestDate: DateTime.now(),
      repaymentDate: DateTime.parse(_repaymentDateController.text),
    );

   creditRequestController.createCreditRequest(creditRequest);
    print('Credit Request Data: $creditRequestData');
  }
}
