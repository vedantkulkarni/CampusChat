import 'package:chat_app/utils/db_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod/riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html;

final attendanceDataProvider =
    ChangeNotifierProvider<AttendanceData>((ref) => AttendanceData());

class AttendanceData with ChangeNotifier {
  late final String username;
  late final String grade;
  late final String division;
  late final String averageAttendance;
  bool isLoaded = false;
  String? result;
  List<SubjectModel> subjectList = [];

  String? get getResult {
    return result;
  }

  Future<void> authAndRequestApi() async {
    final res = await DBHelper.getData();
    final query = res[0];
    final loginId = query['id'];
    final pass = query['pass'];
    final authUrl =
        'http://pict.ethdigitalcampus.com:80/DCWeb/authenticate.do?loginid=$loginId&password=$pass&dbConnVar=PICT&service_id';
    final attendanceUrl =
        'http://pict.ethdigitalcampus.com/DCWeb/form/jsp_sms/StudentsPersonalFolder_pict.jsp?loginid=$loginId&password=$pass&dbConnVar=PICT&service_id=&dashboard=1';

    var response = await http.post(Uri.parse(authUrl));
    if (response.statusCode == 302) {
      var sessionId = response.headers['set-cookie'];

      sessionId = sessionId!.split(';')[0];

      var getData = await http
          .post(Uri.parse(attendanceUrl), headers: {'Cookie': sessionId});

      parserLogic(getData.body);
    } else {
      throw Exception();
    }
  }

  void parserLogic(String s) {
    var document = html.parse(s);

    //get dashboard table
    var dashboardElements =
        document.getElementById('table5')!.children[0].children;
    print(dashboardElements.length);
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
          subjectTeachers: subjectTeachers);
      subjectList.add(sub);
    }

    notifyListeners();
    isLoaded = true;
  }
}

class SubjectModel {
  final String subjectName;
  final String subjectTeachers;
  final String totalLecs;
  final String attendedLecs;
  final String percent;

  SubjectModel(
      {required this.attendedLecs,
      required this.percent,
      required this.subjectName,
      required this.totalLecs,
      required this.subjectTeachers});
}
