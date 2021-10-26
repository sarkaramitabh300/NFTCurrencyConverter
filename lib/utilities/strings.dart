const String alpha_vantage_api_key = "3UG2S4A6INTQVT55";
const String alcor_base_api = 'https://wax.alcor.exchange/api/markets';
const String fwf_api = alcor_base_api + '/105';
const String fwg_api = alcor_base_api + '/106';
const String fww_api = alcor_base_api + '/104';
const String waxAcc_api="https://lightapi.eosamsterdam.net/api/balances/wax/jftxk.wam";
const String fwf12_base_api =
    'https://wax.greymass.com/v1/chain/get_table_rows';
const Map<String, dynamic> fw_ac_balance_body = {
  "json": true,
  "code": "farmersworld",
  "scope": "farmersworld",
  "table": "accounts",
  "table_key": "",
  "lower_bound": "jftxk.wam",
  "upper_bound": "jftxk.wam",
  "index_position": 1,
  "key_type": "i64",
  "limit": 100,
  "reverse": false,
  "show_payer": false
};

const Map<String, dynamic> fw_ac_tools_body = {
  "json": true,
  "code": "farmersworld",
  "scope": "farmersworld",
  "table": "tools",
  "table_key": "",
  "lower_bound": "jftxk.wam",
  "upper_bound": "jftxk.wam",
  "index_position": 2,
  "key_type": "i64",
  "limit": 100,
  "reverse": false,
  "show_payer": false
};
