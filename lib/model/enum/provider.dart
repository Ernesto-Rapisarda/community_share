enum ProviderName{
  email,
  google,
  facebook,
  undefined
}

ProviderName providerNameFromString(String value) {
  switch (value) {
    case 'email':
      return ProviderName.email;
    case 'google':
      return ProviderName.google;
    case 'facebook':
      return ProviderName.facebook;

    default:
      return ProviderName.undefined;
  }
}