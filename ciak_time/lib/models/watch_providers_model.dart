class WatchProvidersModel {
  int id;
  Results results;

  WatchProvidersModel({this.id, this.results});

  WatchProvidersModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    results =
        json['results'] != null ? new Results.fromJson(json['results']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.results != null) {
      data['results'] = this.results.toJson();
    }
    return data;
  }
}

class Results {
  CountryResults aR;
  CountryResults aT;
  CountryResults aU;
  CountryResults bE;
  CountryResults bR;
  CountryResults cA;
  CountryResults cL;
  CountryResults cO;
  CountryResults dE;
  CountryResults dK;
  CountryResults eS;
  CountryResults fI;
  CountryResults fR;
  CountryResults gB;
  CountryResults iE;
  CountryResults iT;

  CountryResults mX;
  CountryResults nL;
  CountryResults nO;
  CountryResults nZ;
  CountryResults pT;
  CountryResults sE;
  CountryResults uS;

  Results(
      {this.aR,
      this.aT,
      this.aU,
      this.bE,
      this.bR,
      this.cA,
      this.cL,
      this.cO,
      this.dE,
      this.dK,
      this.eS,
      this.fI,
      this.fR,
      this.gB,
      this.iE,
      this.iT,
      this.mX,
      this.nL,
      this.nO,
      this.nZ,
      this.pT,
      this.sE,
      this.uS});

  Results.fromJson(Map<String, dynamic> json) {
    aR = json['AR'] != null ? new CountryResults.fromJson(json['AR']) : null;
    aT = json['AT'] != null ? new CountryResults.fromJson(json['AT']) : null;
    aU = json['AU'] != null ? new CountryResults.fromJson(json['AU']) : null;
    bE = json['BE'] != null ? new CountryResults.fromJson(json['BE']) : null;
    bR = json['BR'] != null ? new CountryResults.fromJson(json['BR']) : null;
    cA = json['CA'] != null ? new CountryResults.fromJson(json['CA']) : null;
    cL = json['CL'] != null ? new CountryResults.fromJson(json['CL']) : null;
    cO = json['CO'] != null ? new CountryResults.fromJson(json['CO']) : null;
    dE = json['DE'] != null ? new CountryResults.fromJson(json['DE']) : null;
    dK = json['DK'] != null ? new CountryResults.fromJson(json['DK']) : null;
    eS = json['ES'] != null ? new CountryResults.fromJson(json['ES']) : null;
    fI = json['FI'] != null ? new CountryResults.fromJson(json['FI']) : null;
    fR = json['FR'] != null ? new CountryResults.fromJson(json['FR']) : null;
    gB = json['GB'] != null ? new CountryResults.fromJson(json['GB']) : null;
    iE = json['IE'] != null ? new CountryResults.fromJson(json['IE']) : null;
    iT = json['IT'] != null ? new CountryResults.fromJson(json['IT']) : null;

    mX = json['MX'] != null ? new CountryResults.fromJson(json['MX']) : null;
    nL = json['NL'] != null ? new CountryResults.fromJson(json['NL']) : null;
    nO = json['NO'] != null ? new CountryResults.fromJson(json['NO']) : null;
    nZ = json['NZ'] != null ? new CountryResults.fromJson(json['NZ']) : null;
    pT = json['PT'] != null ? new CountryResults.fromJson(json['PT']) : null;
    sE = json['SE'] != null ? new CountryResults.fromJson(json['SE']) : null;
    uS = json['US'] != null ? new CountryResults.fromJson(json['US']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.aR != null) {
      data['AR'] = this.aR.toJson();
    }
    if (this.aT != null) {
      data['AT'] = this.aT.toJson();
    }
    if (this.aU != null) {
      data['AU'] = this.aU.toJson();
    }
    if (this.bE != null) {
      data['BE'] = this.bE.toJson();
    }
    if (this.bR != null) {
      data['BR'] = this.bR.toJson();
    }
    if (this.cA != null) {
      data['CA'] = this.cA.toJson();
    }
    if (this.cL != null) {
      data['CL'] = this.cL.toJson();
    }
    if (this.cO != null) {
      data['CO'] = this.cO.toJson();
    }
    if (this.dE != null) {
      data['DE'] = this.dE.toJson();
    }
    if (this.dK != null) {
      data['DK'] = this.dK.toJson();
    }
    if (this.eS != null) {
      data['ES'] = this.eS.toJson();
    }
    if (this.fI != null) {
      data['FI'] = this.fI.toJson();
    }
    if (this.fR != null) {
      data['FR'] = this.fR.toJson();
    }
    if (this.gB != null) {
      data['GB'] = this.gB.toJson();
    }
    if (this.iE != null) {
      data['IE'] = this.iE.toJson();
    }
    if (this.iT != null) {
      data['IT'] = this.iT.toJson();
    }

    if (this.mX != null) {
      data['MX'] = this.mX.toJson();
    }
    if (this.nL != null) {
      data['NL'] = this.nL.toJson();
    }
    if (this.nO != null) {
      data['NO'] = this.nO.toJson();
    }
    if (this.nZ != null) {
      data['NZ'] = this.nZ.toJson();
    }
    if (this.pT != null) {
      data['PT'] = this.pT.toJson();
    }
    if (this.sE != null) {
      data['SE'] = this.sE.toJson();
    }
    if (this.uS != null) {
      data['US'] = this.uS.toJson();
    }
    return data;
  }
}

class CountryResults {
  String link;
  List<Providers> providers = [];

  CountryResults({this.link, this.providers});

  CountryResults.fromJson(Map<String, dynamic> json) {
    link = json['link'];
    if (json['flatrate'] != null) {
      json['flatrate'].forEach((v) {
        providers.add(new Providers.fromJson(v));
      });
    }

    if (json['rent'] != null) {
      json['rent'].forEach((v) {
        providers.add(new Providers.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['link'] = this.link;
    if (this.providers != null) {
      data['providers'] = this.providers.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Providers {
  int displayPriority;
  String logoPath;
  int providerId;
  String providerName;

  Providers(
      {this.displayPriority,
      this.logoPath,
      this.providerId,
      this.providerName});

  Providers.fromJson(Map<String, dynamic> json) {
    displayPriority = json['display_priority'];
    logoPath = json['logo_path'];
    providerId = json['provider_id'];
    providerName = json['provider_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['display_priority'] = this.displayPriority;
    data['logo_path'] = this.logoPath;
    data['provider_id'] = this.providerId;
    data['provider_name'] = this.providerName;
    return data;
  }
}
