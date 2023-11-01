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
