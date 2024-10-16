class UpdateProfileEntity {
  String? ownerDid;
  String? ownerEmail;
  String? firstName;
  String? lastName;
  String? country;
  String? phoneNumber;
  String? companyName;
  String? accountType;
  String? companyRegno;
  String? city;
  String? postalCode;
  String? countryCode;
  String? description;
  String? state;
  String? addressLine1;
  String? addressLine2;

  UpdateProfileEntity(
      {this.ownerDid,
      this.ownerEmail,
      this.firstName,
      this.lastName,
      this.country,
      this.phoneNumber,
      this.companyName,
      this.accountType,
      this.companyRegno,
      this.city,
      this.postalCode,
      this.countryCode,
      this.description,
      this.state,
      this.addressLine1,
      this.addressLine2});

  UpdateProfileEntity.fromJson(Map<String, dynamic> json) {
    ownerDid = json['OwnerDid'];
    ownerEmail = json['OwnerEmail'];
    firstName = json['FirstName'];
    lastName = json['LastName'];
    country = json['Country'];
    phoneNumber = json['PhoneNumber'];
    companyName = json['CompanyName'];
    accountType = json['AccountType'];
    companyRegno = json['CompanyRegno'];
    city = json['City'];
    postalCode = json['PostalCode'];
    countryCode = json['CountryCode'];
    description = json['Description'];
    state = json['State'];
    addressLine1 = json['AddressLine1'];
    addressLine2 = json['AddressLine2'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['OwnerDid'] = this.ownerDid;
    data['OwnerEmail'] = this.ownerEmail;
    data['FirstName'] = this.firstName;
    data['LastName'] = this.lastName;
    data['Country'] = this.country;
    data['PhoneNumber'] = this.phoneNumber;
    data['CompanyName'] = this.companyName;
    data['AccountType'] = this.accountType;
    data['CompanyRegno'] = this.companyRegno;
    data['City'] = this.city;
    data['PostalCode'] = this.postalCode;
    data['CountryCode'] = this.countryCode;
    data['Description'] = this.description;
    data['State'] = this.state;
    data['AddressLine1'] = this.addressLine1;
    data['AddressLine2'] = this.addressLine2;
    return data;
  }
}