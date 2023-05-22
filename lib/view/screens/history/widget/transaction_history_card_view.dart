import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_cash/controller/localization_controller.dart';
import 'package:six_cash/data/model/transaction_model.dart';
import 'package:six_cash/helper/date_converter.dart';
import 'package:six_cash/helper/price_converter.dart';
import 'package:six_cash/helper/transaction_type.dart';
import 'package:six_cash/util/app_constants.dart';
import 'package:six_cash/util/color_resources.dart';
import 'package:six_cash/util/dimensions.dart';
import 'package:six_cash/util/images.dart';
import 'package:six_cash/util/styles.dart';
class TransactionHistoryCardView extends StatelessWidget {
  final Transactions transactions;
  const TransactionHistoryCardView({Key key, this.transactions}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    String _userPhone;
    String _userName;
    bool _isCredit = transactions.transactionType == AppConstants.SEND_MONEY
        || transactions.transactionType == AppConstants.WITHDRAW
        || transactions.transactionType == TransactionType.CASH_OUT;

    try{

      _userPhone = transactions.transactionType == AppConstants.SEND_MONEY
          ? transactions.receiver.phone : transactions.transactionType == AppConstants.RECEIVED_MONEY
          ? transactions.sender.phone : transactions.transactionType == AppConstants.ADD_MONEY
          ? transactions.sender.phone : transactions.transactionType == AppConstants.CASH_IN
          ? transactions.sender.phone : transactions.transactionType == AppConstants.WITHDRAW
          ? transactions.receiver.phone : transactions.userInfo.phone;

      _userName = transactions.transactionType == AppConstants.SEND_MONEY
          ? transactions.receiver.name : transactions.transactionType == AppConstants.RECEIVED_MONEY
          ? transactions.sender.name : transactions.transactionType == AppConstants.ADD_MONEY
          ? transactions.sender.name : transactions.transactionType == AppConstants.CASH_IN
          ? transactions.sender.name : transactions.transactionType == AppConstants.WITHDRAW
          ? transactions.receiver.name : transactions.userInfo.name;
    }catch(e){
     _userPhone = 'no_user'.tr;
     _userName = 'no_user'.tr;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
      child: Stack(
        children: [
         Column(
          children: [
            Row(
              children: [

                Container(
                  height: 50,width: 50,
                  padding: const EdgeInsets.all(8.0),
                  child: transactions.transactionType == null
                      ? SizedBox()
                      : Image.asset(Images.getTransactionImage(transactions.transactionType)),
                ),

                SizedBox(width: 5,),

                Column(crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        transactions.transactionType.tr,
                        style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_DEFAULT),
                      ),
                      SizedBox(height: Dimensions.PADDING_SIZE_SUPER_EXTRA_SMALL),

                      Text(
                        _userName ?? '',
                        maxLines: 1,overflow: TextOverflow.ellipsis,
                        style: rubikRegular.copyWith(
                          fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL,
                        ),
                      ),
                      SizedBox(height: Dimensions.PADDING_SIZE_SUPER_EXTRA_SMALL),

                      Text(_userPhone ?? '', style: rubikMedium.copyWith(
                        fontSize: Dimensions.FONT_SIZE_SMALL,
                      ),),
                      SizedBox(height: Dimensions.PADDING_SIZE_SUPER_EXTRA_SMALL),

                      Text(
                        'TrxID: ${transactions.transactionId}',
                        style: rubikRegular.copyWith(fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL),
                      ),

                    ]),
                Spacer(),

                Text(
                  '${_isCredit ? '-' : '+'} ${PriceConverter.convertPrice(double.parse(transactions.amount.toString()))}',
                  style: rubikMedium.copyWith(
                    fontSize: Dimensions.FONT_SIZE_DEFAULT,
                    color: _isCredit ? Colors.redAccent : Colors.green,
                  ),
                ),

              ],
            ),
            SizedBox(height: 5),

            Divider(height: .125,color: ColorResources.getGreyColor()),
          ],
        ),

          Get.find<LocalizationController>().isLtr ?  Positioned(
            bottom:  3 ,
              right: 2,
              child: Text(
                DateConverter.localDateToIsoStringAMPM(DateTime.parse(transactions.createdAt)),
                style: rubikRegular.copyWith(
                  fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL,
                  color: ColorResources.getHintColor(),
                ),
              ),
          ) :
          Positioned(
            bottom:  3 ,
            left: 2,
            child: Text(
              DateConverter.localDateToIsoStringAMPM(DateTime.parse(transactions.createdAt)),
              style: rubikRegular.copyWith(
                fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL,
                color: ColorResources.getHintColor(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

