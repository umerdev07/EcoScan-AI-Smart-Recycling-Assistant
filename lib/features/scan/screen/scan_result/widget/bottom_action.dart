import 'package:flutter/cupertino.dart';

import '../../../models/scan_result_model.dart';
import 'bottom_action_state.dart';

class BottomActions extends StatefulWidget {
  final ScanResult result;
  const BottomActions({required this.result});

  @override
  State<BottomActions> createState() => BottomActionsState();
}
