String myDateFormat(DateTime date) {
    return weeknum2Text(date.weekday) +
        ', ' +
        date.day.toString() +
        ' ' +
        num2month(date.month) +
        ' ' +
        date.year.toString();
  }

String weeknum2Text(int num) {
    switch (num) {
      case 1:
        return 'Mon';
      case 2:
        return 'Tue';
      case 3:
        return 'Wed';
      case 4:
        return 'Thu';
      case 5:
        return 'Fri';
      case 6:
        return 'Sat';
      case 7:
        return 'Sun';
      default:
        return 'Undefined';
    }
  }

String num2month(int num) {
    switch (num) {
      case 1:
        return 'January';
      case 2:
        return 'Febreuary';
      case 3:
        return 'March';
      case 4:
        return 'April';
      case 5:
        return 'May';
      case 6:
        return 'June';
      case 7:
        return 'July';
      case 8:
        return 'August';
      case 9:
        return 'September';
      case 10:
        return 'October';
      case 11:
        return 'November';
      case 12:
        return 'December';
      default:
        return 'Undefined';
    }
  }