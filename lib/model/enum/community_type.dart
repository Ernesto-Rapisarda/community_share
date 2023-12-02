import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


enum CommunityType {
  private,
  charityInstitution,
  religiousInstitution,
  recreationalInstitution,
  undefined
}

CommunityType communityTypeFromString(String value) {
  switch (value) {
    case 'private':
      return CommunityType.private;
    case 'charityInstitution':
      return CommunityType.charityInstitution;
    case 'religiousInstitution':
      return CommunityType.religiousInstitution;
    case 'recreationalInstitution':
      return CommunityType.recreationalInstitution;
    default:
      return CommunityType.undefined;
  }
}

String communityTypeToString(CommunityType type,BuildContext context) {
  switch (type) {
    case CommunityType.private:
      return AppLocalizations.of(context)!.private;
    case CommunityType.charityInstitution:
      return AppLocalizations.of(context)!.charityInstitution;
    case CommunityType.religiousInstitution:
      return AppLocalizations.of(context)!.religiousInstitution;
    case CommunityType.recreationalInstitution:
      return AppLocalizations.of(context)!.recreationalInstitution;
    default:
      return AppLocalizations.of(context)!.undefined;
  }
}