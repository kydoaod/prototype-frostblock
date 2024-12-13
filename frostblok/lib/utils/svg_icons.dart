import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SvgIcons {
  static const String _basePath = 'assets/icons/';

  static SvgPicture cloudSunny({double size = 64, Color? color}) =>
      SvgPicture.asset('${_basePath}cloud_sunny.svg', height: size, color: color);
  static SvgPicture cloudSunshower({double size = 64, Color? color}) =>
      SvgPicture.asset('${_basePath}cloud_sunshower.svg', height: size, color: color);
  static SvgPicture cloudSnow({double size = 64, Color? color}) =>
      SvgPicture.asset('${_basePath}cloud_snow.svg', height: size, color: color);
  static SvgPicture cloudClouds({double size = 64, Color? color}) =>
      SvgPicture.asset('${_basePath}cloud_clouds.svg', height: size, color: color);
  static SvgPicture cloudThunderstorm({double size = 64, Color? color}) =>
      SvgPicture.asset('${_basePath}cloud_thunderstorm.svg', height: size, color: color);
  static SvgPicture cloudDrizzle({double size = 64, Color? color}) =>
      SvgPicture.asset('${_basePath}cloud_drizzle.svg', height: size, color: color);
  static SvgPicture cloudMistFog({double size = 64, Color? color}) =>
      SvgPicture.asset('${_basePath}cloud_mist_fog.svg', height: size, color: color);
  static SvgPicture cloudHelpOutline({double size = 64, Color? color}) =>
      SvgPicture.asset('${_basePath}cloud_sunshower.svg', height: size, color: color);

  // Indicator icons
  static SvgPicture indicatorWindDir({double size = 20, Color? color}) =>
      SvgPicture.asset('${_basePath}indicator_wind_dir.svg', height: size, color: color);
  static SvgPicture indicatorSnow({double size = 20, Color? color}) =>
      SvgPicture.asset('${_basePath}indicator_snow.svg', height: size, color: color);
  static SvgPicture indicatorTemperature({double size = 20, Color? color}) =>
      SvgPicture.asset('${_basePath}indicator_temperature.svg', height: size, color: color);
  static SvgPicture indicatorHumidity({double size = 20, Color? color}) =>
      SvgPicture.asset('${_basePath}indicator_humidity.svg', height: size, color: color);
  static SvgPicture actionDefrostOn({double size = 24, Color? color}) =>
      SvgPicture.asset('${_basePath}action_defrost_on.svg', height: size, color: color);
  static SvgPicture actionDefrostOff({double size = 24, Color? color}) =>
      SvgPicture.asset('${_basePath}action_defrost_off.svg', height: size, color: color);    
}
