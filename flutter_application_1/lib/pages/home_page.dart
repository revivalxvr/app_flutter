import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_application_1/models/database.dart';
import 'package:flutter_application_1/models/transaction_with_category.dart';
import 'package:flutter_application_1/pages/transaction_page.dart';
// import 'package:flutter/src/widgets/placeholder.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  final DateTime selectedDate;
  const HomePage({Key? key, required this.selectedDate}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AppDb database = AppDb();
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SafeArea(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                          child: Icon(
                            Icons.download,
                            color: Colors.green,
                          ),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5))),
                      SizedBox(
                        width: 15,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Income",
                            style: GoogleFonts.montserrat(
                                color: Colors.white, fontSize: 13),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text("Rp 5.000.000",
                              style: GoogleFonts.montserrat(
                                  color: Colors.white, fontSize: 15))
                        ],
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                          child: Icon(
                            Icons.upload,
                            color: Colors.red,
                          ),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5))),
                      SizedBox(
                        width: 15,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Expense",
                            style: GoogleFonts.montserrat(
                                color: Colors.white, fontSize: 13),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text("Rp 1.200.000",
                              style: GoogleFonts.montserrat(
                                  color: Colors.white, fontSize: 15))
                        ],
                      )
                    ],
                  )
                ],
              ),
              width: double.infinity,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 75, 73, 73),
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text("Transection",
                style: GoogleFonts.montserrat(
                    fontSize: 16, fontWeight: FontWeight.bold)),
          ),
          StreamBuilder<List<TransactionWithCategory>>(
              stream: database.getTransactionByDateRepo(widget.selectedDate),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  if (snapshot.hasData) {
                    if (snapshot.data!.length > 0) {
                      return ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Card(
                                elevation: 12,
                                child: ListTile(
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: Icon(Icons.delete),
                                        onPressed: () async {
                                          await database.deleteTransactionRepo(
                                              snapshot
                                                  .data![index].transaction.id);
                                          setState(() {});
                                        },
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.edit),
                                        onPressed: () {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      TransactionPage(
                                                        transactionWithCategory:
                                                            snapshot
                                                                .data![index],
                                                      )));
                                        },
                                      )
                                    ],
                                  ),
                                  title: Text("Rp. " +
                                      snapshot.data![index].transaction.amount
                                          .toString()),
                                  subtitle: Text(snapshot
                                          .data![index].category.name +
                                      " (" +
                                      snapshot.data![index].transaction.name +
                                      ")"),
                                  leading: Container(
                                      child: (snapshot
                                                  .data![index].category.type ==
                                              2)
                                          ? Icon(Icons.upload,
                                              color: Colors.red)
                                          : Icon(Icons.download,
                                              color: Colors.green),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(5))),
                                ),
                              ),
                            );
                          });
                    } else {
                      return Center(
                        child: Text("Tidak ada data"),
                      );
                    }
                  } else {
                    return Center(
                      child: Text("Tidak ada data"),
                    );
                  }
                }
              }),
        ]),
      ),
    );
  }
}
