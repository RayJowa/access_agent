class Receipt {

  String receiptNumber;
  String policyID;
  String method;
  double amount;
  DateTime paidDate;
  DateTime recordedDate;
  List<MatchEntry> matches;
  double unmatchedAmount;

  Receipt({
    this.receiptNumber,
    this.policyID,
    this.method,
    this.amount,
    this.paidDate,
    this.recordedDate,
    this.matches,
    this.unmatchedAmount
});
}

class MatchEntry {
  String debitID;
  String amount;

  MatchEntry({
    this.amount,
    this.debitID
});
}

