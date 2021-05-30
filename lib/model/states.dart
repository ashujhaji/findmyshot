import 'dart:convert';

StatesResponse statesResponseFromJson(String str) => StatesResponse.fromJson(json.decode(str));

class StatesResponse {
  StatesResponse({
    this.states,
    this.ttl,
  });

  List<State> states;
  int ttl;

  factory StatesResponse.fromJson(Map<String, dynamic> json) => StatesResponse(
    states: List<State>.from(json["states"].map((x) => State.fromJson(x))),
    ttl: json["ttl"],
  );
}

class State {
  State({
    this.stateId,
    this.stateName,
  });

  int stateId;
  String stateName;

  factory State.fromJson(Map<String, dynamic> json) => State(
    stateId: json["state_id"],
    stateName: json["state_name"],
  );
}
