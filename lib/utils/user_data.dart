import 'package:chat_app/utils/db_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html;

final attendanceDataProvider =
    ChangeNotifierProvider<AttendanceData>((ref) => AttendanceData());

class AttendanceData with ChangeNotifier {
  late String username;
  late String? grade;
  late String division;
  late String averageAttendance;
  late String compareId;
  late String loginId;
  late String pass;
  late String password;
  bool isLoaded = false;
  String? result;
  List<SubjectModel> subjectList = [];

  String? get getResult {
    return result;
  }

  void setCompareId(String s) {
    compareId = s;
  }

  String passEncoder(String s) {
    if (s.contains('!')) {
      s = s.replaceAll('!', '%20');
      return s;
    }
    if (s.contains('#')) {
      s = s.replaceAll('#', '%23');
      return s;
    }
    if (s.contains('\$')) {
      s = s.replaceAll('\$', '%24');
      return s;
    }
    if (s.contains('%')) {
      s = s.replaceAll('%', '%25');
      return s;
    }
    if (s.contains('&')) {
      s = s.replaceAll('&', '%26');
      return s;
    }
    if (s.contains('?')) {
      s = s.replaceAll('?', '%3F');
      return s;
    }
    if (s.contains('@')) {
      s = s.replaceAll('@', '%40');
      return s;
    }
    if (s.contains('^')) {
      s = s.replaceAll('^', '%5E');
      return s;
    }
    if (s.contains('_')) {
      s = s.replaceAll('_', '%5F');
      return s;
    }

    if (s.contains('*')) {
      s = s.replaceAll('*', '%2A');
      return s;
    }

    return s;
  }

  Future<void> authAndRequestApi() async {
    if (isLoaded) return;
    final res = await DBHelper.getData();
    final query = res.firstWhere((element) => element['id'] == compareId);

    loginId = query['id'];
    password = query['pass'];
    pass = passEncoder(query['pass']);

    final authUrl =
        'http://pict.ethdigitalcampus.com:80/DCWeb/authenticate.do?loginid=$loginId&password=$pass&dbConnVar=PICT&service_id';
    final attendanceUrl =
        'http://pict.ethdigitalcampus.com/DCWeb/form/jsp_sms/StudentsPersonalFolder_pict.jsp?loginid=$loginId&password=$pass&dbConnVar=PICT&service_id=&dashboard=1';

    var response = await http.post(Uri.parse(authUrl));

    if (response.statusCode == 302) {
      var sessionId = response.headers['set-cookie'];

      sessionId = sessionId!.split(';')[0].trim();

      var getData = await http
          .get(Uri.parse(attendanceUrl), headers: {'Cookie': sessionId});

      if (getData == null || getData.body.contains('Session Expired')) {
        throw Error();
      }
      parserLogic(getData.body);
    }
  }

  int calcStatus(String s) {
    s = s.toLowerCase();
    if (s.contains('-th'))
      return 1;
    else if (s.contains('-pr') || s.contains(' lab'))
      return 2;
    else if (s.contains('-tut') || s.contains('tutorial'))
      return 3;
    else
      return 1;
  }

  void parserLogic(String s) {
    if (isLoaded) return;
    var document = html.parse(s);

    //get dashboard table
    var dashboardElements =
        document.getElementById('table5')!.children[0].children;

    username = dashboardElements[4].children[1].text.trim();

    grade = dashboardElements[8].children[1].text.trim();
    division = dashboardElements[8].children[3].text.trim();

    //get attendance table
    var attendanceTable =
        document.getElementById('table10')!.children[0].children;
    averageAttendance =
        attendanceTable[attendanceTable.length - 1].children[2].text;

    var teacherList = document.getElementById('table2')!.children[0].children;

    for (int i = 2; i < attendanceTable.length - 1; i++) {
      var subjectTeachers = 'Not Found';

      var subjectName = attendanceTable[i].children[0].text.trim();
      var status = calcStatus(subjectName);
      var totalLecs = attendanceTable[i].children[1].text.trim();
      var attendedLecs = attendanceTable[i].children[2].text.trim();
      var percent = attendanceTable[i].children[3].text.trim();
      for (int i = 3; i < teacherList.length; i++) {
        var element = teacherList[i].children[0].text.trim();
        if (element == subjectName) {
          subjectTeachers = teacherList[i].children[1].text.trim();
          break;
        }
      }
      SubjectModel sub = SubjectModel(
          attendedLecs: attendedLecs,
          percent: percent,
          subjectName: subjectName,
          totalLecs: totalLecs,
          subjectTeachers: subjectTeachers,
          status: status);
      subjectList.add(sub);
    }

    // notifyListeners();
    isLoaded = true;
  }
}

class SubjectModel {
  final String subjectName;
  final String subjectTeachers;
  final String totalLecs;
  final String attendedLecs;
  final String percent;
  final int status;

  SubjectModel(
      {required this.attendedLecs,
      required this.percent,
      required this.subjectName,
      required this.totalLecs,
      required this.subjectTeachers,
      required this.status});
}
