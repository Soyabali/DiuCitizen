import 'package:flutter/material.dart';
import 'package:puri/presentation/taxReceipt/downloadReceiptScreen.dart';
import 'package:url_launcher/url_launcher.dart';

import '../resources/app_text_style.dart';

class ReceiptCard extends StatelessWidget {
  final String sReceiptURL;
  final String sReceiptCode;
  final double fReceiptAmount;
  final String dReceiptDate;

  const ReceiptCard({
    Key? key,
    required this.sReceiptURL,
    required this.sReceiptCode,
    required this.fReceiptAmount,
    required this.dReceiptDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: Colors.grey.shade300),
      ),
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: InkWell(
        onTap: () async {

          print("-----32----$sReceiptURL");
          if(sReceiptURL!=null){

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => DownloadReceiptScreen(
                  pdfUrl: sReceiptURL,
                ),
              ),
            );
          }

          // final uri = Uri.parse(sReceiptURL);
          // if (await canLaunchUrl(uri)) {
          //   launchUrl(uri);
          // }

        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Container(
            color: Colors.white,
            child: Column(
              children: [
                /// Top Row
                Row(
                  children: [
                    Icon(Icons.calendar_month_outlined, size: 16, color: Colors.blueAccent),
                    SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          dReceiptDate, style: AppTextStyle.font12OpenSansRegularBlack45TextStyle,
                        ),
                        Text(
                          "Receipt Date",
                          style: AppTextStyle.font10OpenSansRegularBlack26TextStyle,
                        ),
                      ],
                    ),
                    Spacer(),
                    Row(
                      children: [
                        Text(
                          "Receipt",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.green.shade800,
                          ),
                        ),
                        Icon(Icons.arrow_forward_ios, size: 14, color: Colors.green.shade800),
                      ],
                    )
                  ],
                ),
                SizedBox(height: 10),
                Divider(thickness: 1, color: Colors.grey.shade300),
                /// Bottom Row
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        sReceiptCode,
                        style: AppTextStyle.font12OpenSansRegularBlack45TextStyle,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade700,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        "₹ ${fReceiptAmount.toStringAsFixed(1)}",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
