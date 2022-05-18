import 'backend/tag.dart';
import 'backend/user.dart';
// import 'backend/client.dart';

void main(List<String> args) {
  var tag = Tag({
    "ID": "ade3",
    "ACTION": "DATA",
    "TYPE": "CONTACT",
    "DATE_TIME": 1650648934067,
    "response": "SUCCESSFUL",
    "action": "DATA",
    "data": {
      "NAME": "ade3",
      "ID": "ade3",
      "ICON": "",
      "BIO": "",
      "DATE_TIME": 1650648934067,
      "STATUS": "ONLINE",
      "users": [
        {
          "NAME": "ade1",
          "ID": "ade1",
          "ICON": "",
          "BIO": "",
          "DATE_TIME": 1650648934067,
          "STATUS": "OFFLINE"
        },
        {
          "NAME": "ade2",
          "ID": "ade2",
          "ICON": "",
          "BIO": "",
          "DATE_TIME": 1650648934067,
          "STATUS": "OFFLINE"
        },
        {
          "NAME": "ade4",
          "ID": "ade4",
          "ICON": "",
          "BIO": "",
          "DATE_TIME": 1650648934067,
          "STATUS": "OFFLINE"
        }
      ],
      "groups": [
        {
          "NAME": "G_ade1",
          "ID": "g_ade1",
          "ICON": "",
          "BIO": "",
          "CREATOR": "ade1",
          "admins": ["ade1"],
          "users": ["ade1", "ade2", "ade3", "ade4"],
          "only_admin": false,
          "DATE_TIME": 1650648934067
        },
        {
          "NAME": "G_ade2",
          "ID": "g_ade2",
          "ICON": "",
          "BIO": "",
          "CREATOR": "ade1",
          "admins": ["ade1"],
          "users": ["ade1", "ade2", "ade3", "ade4"],
          "only_admin": false,
          "DATE_TIME": 1650648934067
        },
        {
          "NAME": "G_ade3",
          "ID": "g_ade3",
          "ICON": "",
          "BIO": "",
          "CREATOR": "ade1",
          "admins": ["ade1"],
          "users": ["ade1", "ade2", "ade3", "ade4"],
          "only_admin": false,
          "DATE_TIME": 1650648934067
        },
        {
          "NAME": "G_ade4",
          "ID": "g_ade4",
          "ICON": "",
          "BIO": "",
          "CREATOR": "ade1",
          "admins": ["ade1"],
          "users": ["ade1", "ade2", "ade3", "ade4"],
          "only_admin": false,
          "DATE_TIME": 1650648934067
        }
      ],
      "channels": [
        {
          "NAME": "C_ade1",
          "ID": "c_ade1",
          "ICON": "",
          "BIO": "",
          "CREATOR": "ade1",
          "admins": ["ade1"],
          "users": ["ade1", "ade2", "ade3", "ade4"],
          "only_admin": true,
          "DATE_TIME": 1650648934067
        },
        {
          "NAME": "C_ade2",
          "ID": "c_ade2",
          "ICON": "",
          "BIO": "",
          "CREATOR": "ade1",
          "admins": ["ade1", "ade2"],
          "users": ["ade1", "ade2", "ade3", "ade4"],
          "only_admin": true,
          "DATE_TIME": 1650648934067
        },
        {
          "NAME": "C_ade3",
          "ID": "c_ade3",
          "ICON": "",
          "BIO": "",
          "CREATOR": "ade1",
          "admins": ["ade1"],
          "users": ["ade1", "ade2", "ade3", "ade4"],
          "only_admin": true,
          "DATE_TIME": 1650648934067
        },
        {
          "NAME": "C_ade4",
          "ID": "c_ade4",
          "ICON": "",
          "BIO": "",
          "CREATOR": "ade1",
          "admins": ["ade1"],
          "users": ["ade1", "ade2", "ade3", "ade4"],
          "only_admin": true,
          "DATE_TIME": 1650648934067
        }
      ]
    }
  });
  User user = User('ade3', 'ade3', name: 'ade3');
  user.load_data(tag);
  // print(user.recv_data);
  print(user.contacts.objects_);
  print(user.groups?.objects_);
  print(user.channels?.objects_);
}
