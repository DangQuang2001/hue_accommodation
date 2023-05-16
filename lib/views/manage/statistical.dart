import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class StatisticalManage extends StatefulWidget {
  const StatisticalManage({Key? key}) : super(key: key);

  @override
  State<StatisticalManage> createState() => _StatisticalManageState();
}

class _StatisticalManageState extends State<StatisticalManage> {
  late TooltipBehavior _tooltipBehavior;

  late List<SalesData1> _salesData;

  @override
  void initState() {
    _salesData = <SalesData1>[
      SalesData1('Jan', 35, 25, ),
      SalesData1('Feb', 28, 22, ),
      SalesData1('Mar', 34, 20, ),
      SalesData1('Apr', 32, 23, ),
      SalesData1('May', 40, 26, ),
    ];

    _tooltipBehavior = TooltipBehavior(enable: true);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SingleChildScrollView(
        child: Column(
          children: [
            appBar(context),
            numberRent(context),
            revenue(context),
          ],
        ),
      ) ,
    );
  }

  Widget appBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 40.0, left: 20, right: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 30,
              height: 30,
              decoration: const BoxDecoration(),
              child: const Center(
                child: Icon(
                  Icons.arrow_back_outlined,
                  size: 30,
                ),
              ),
            ),
          ),
          Text(
            '    Statistical  ',
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          const SizedBox(
            width: 30,
          )
        ],
      ),
    );
  }

  Widget numberRent(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 450,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SfCartesianChart(

            primaryXAxis: CategoryAxis(
              visibleMaximum: 3,
            ),
            // Chart title
            // Enable legend
            legend: Legend(isVisible: true),
            // Enable tooltip
            tooltipBehavior: _tooltipBehavior,

            series: <LineSeries<SalesData, String>>[
              LineSeries<SalesData, String>(
                  name: "number of renters",
                  dataSource:  <SalesData>[
                    SalesData('Jan', 0),
                    SalesData('Feb', 1),
                    SalesData('Mar', 9),
                    SalesData('Apr', 10),
                    SalesData('May', 0)
                  ],
                  xValueMapper: (SalesData sales, _) => sales.year,
                  yValueMapper: (SalesData sales, _) => sales.sales,
                  // Enable data label
                  dataLabelSettings: const DataLabelSettings(isVisible: true)
              )
            ]
        ),
      ),
    );
  }

  Widget revenue(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 450,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SfCartesianChart(
          primaryXAxis: CategoryAxis(),
          legend: Legend(isVisible: true),
          title: ChartTitle(text: 'Revenue'),
          tooltipBehavior: TooltipBehavior(enable: true),
          series: <ChartSeries<SalesData1, String>>[
            StackedBarSeries<SalesData1, String>(

              dataSource: _salesData,
              xValueMapper: (SalesData1 sales, _) => sales.month,
              yValueMapper: (SalesData1 sales, _) => sales.sales1,
              name: 'Expense',
            ),
            StackedBarSeries<SalesData1, String>(
              dataSource: _salesData,
              xValueMapper: (SalesData1 sales, _) => sales.month,
              yValueMapper: (SalesData1 sales, _) => sales.sales2,
              name: 'Revenue',
            ),

          ],
        ),
      ),
    );

  }

}
class SalesData {
  SalesData(this.year, this.sales);
  final String year;
  final double sales;
}
class SalesData1 {
  SalesData1(this.month, this.sales1, this.sales2);

  final String month;
  final double sales1;
  final double sales2;
}
