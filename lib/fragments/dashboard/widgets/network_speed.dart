import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/models/models.dart';
import 'package:fl_clash/state.dart';
import 'package:fl_clash/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NetworkSpeed extends StatefulWidget {
  const NetworkSpeed({super.key});

  @override
  State<NetworkSpeed> createState() => _NetworkSpeedState();
}

class _NetworkSpeedState extends State<NetworkSpeed> {
  List<Point> initPoints = const [Point(0, 0), Point(1, 0)];

  List<Point> _getPoints(List<Traffic> traffics) {
    List<Point> trafficPoints = traffics
        .toList()
        .asMap()
        .map(
          (index, e) => MapEntry(
            index,
            Point(
              (index + initPoints.length).toDouble(),
              e.speed.toDouble(),
            ),
          ),
        )
        .values
        .toList();

    return [...initPoints, ...trafficPoints];
  }

  Traffic _getLastTraffic(List<Traffic> traffics) {
    if (traffics.isEmpty) return Traffic();
    return traffics.last;
  }

  Widget _getLabel({
    required String label,
    required IconData iconData,
    required TrafficValue value,
  }) {
    final showValue = value.showValue;
    final showUnit = "${value.showUnit}/s";
    final titleLargeSoftBold =
        Theme.of(context).textTheme.titleLarge?.toSoftBold;
    final bodyMedium = Theme.of(context).textTheme.bodySmall?.toLight;
    final valueText = Text(
      showValue,
      style: titleLargeSoftBold,
      maxLines: 1,
    );
    final unitText = Text(
      showUnit,
      style: bodyMedium,
      maxLines: 1,
    );
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          iconData,
        ),
        SizedBox(
          width: 8,
        ),
        Flexible(
          child: valueText,
        ),
        SizedBox(
          width: 4,
        ),
        Flexible(
          child: unitText,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: getWidgetHeight(3),
      child: CommonCard.info(
        onPressed: () {},
        info: Info(
          label: appLocalizations.networkSpeed,
          iconData: Icons.speed_sharp,
        ),
        child: Selector<AppFlowingState, List<Traffic>>(
          selector: (_, appFlowingState) => appFlowingState.traffics,
          builder: (_, traffics, __) {
            return Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                    child: SizedBox(
                      child: LineChart(
                        color: Theme.of(context).colorScheme.primary,
                        points: _getPoints(traffics),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 32,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        flex: 1,
                        child: _getLabel(
                          iconData: Icons.upload,
                          label: appLocalizations.upload,
                          value: _getLastTraffic(traffics).up,
                        ),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Expanded(
                        flex: 1,
                        child: _getLabel(
                          iconData: Icons.download,
                          label: appLocalizations.download,
                          value: _getLastTraffic(traffics).down,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
