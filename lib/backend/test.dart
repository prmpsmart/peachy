import 'package:peachy/backend/client.dart';

import 'core.dart';
// import 'database.dart';

void main(List<String> args) {
  // var db = User_DB();
  // print(db);
  User user = User('ade1', name: 'ade1');
  var tag = Tag({
    'NAME': 'ade1',
    'ID': 'ade1',
    'ICON': "",
    'DESCRIPTION': "",
    'EXT': "",
    'users': [
      Tag({
        'NAME': 'ade2',
        'ID': 'ade2',
        'ICON': "",
        'DESCRIPTION': "",
        'EXT': "",
      }),
      Tag({
        'NAME': 'ade3',
        'ID': 'ade3',
        'ICON': "",
        'DESCRIPTION': "",
        'EXT': "",
      }),
      Tag({
        'NAME': 'ade4',
        'ID': 'ade4',
        'ICON': "",
        'DESCRIPTION': "",
        'EXT': "",
      }),
    ],
    'groups': [
      Tag({
        'NAME': 'G_ade1',
        'ID': 'g_ade1',
        'ICON': "",
        'DESCRIPTION': "",
        'EXT': "",
        'CREATOR': 'ade1',
        'admins': [
          'ade1',
        ],
        'users': [
          Tag({
            'NAME': 'ade1',
            'ID': 'ade1',
            'ICON': "",
            'DESCRIPTION': "",
            'EXT': "",
          }),
          Tag({
            'NAME': 'ade2',
            'ID': 'ade2',
            'ICON': "",
            'DESCRIPTION': "",
            'EXT': "",
          }),
          Tag({
            'NAME': 'ade3',
            'ID': 'ade3',
            'ICON': "",
            'DESCRIPTION': "",
            'EXT': "",
          }),
          Tag({
            'NAME': 'ade4',
            'ID': 'ade4',
            'ICON': "",
            'DESCRIPTION': "",
            'EXT': "",
          })
        ],
        'only_admin': false,
      }),
      Tag({
        'NAME': 'G_ade2',
        'ID': 'g_ade2',
        'ICON': "",
        'DESCRIPTION': "",
        'EXT': "",
        'CREATOR': 'ade1',
        'admins': [
          'ade1',
        ],
        'users': [
          Tag({
            'NAME': 'ade1',
            'ID': 'ade1',
            'ICON': "",
            'DESCRIPTION': "",
            'EXT': "",
          }),
          Tag({
            'NAME': 'ade2',
            'ID': 'ade2',
            'ICON': "",
            'DESCRIPTION': "",
            'EXT': "",
          }),
          Tag({
            'NAME': 'ade3',
            'ID': 'ade3',
            'ICON': "",
            'DESCRIPTION': "",
            'EXT': "",
          }),
          Tag({
            'NAME': 'ade4',
            'ID': 'ade4',
            'ICON': "",
            'DESCRIPTION': "",
            'EXT': "",
          })
        ],
        'only_admin': false,
      }),
      Tag({
        'NAME': 'G_ade3',
        'ID': 'g_ade3',
        'ICON': "",
        'DESCRIPTION': "",
        'EXT': "",
        'CREATOR': 'ade1',
        'admins': [
          'ade1',
        ],
        'users': [
          Tag({
            'NAME': 'ade1',
            'ID': 'ade1',
            'ICON': "",
            'DESCRIPTION': "",
            'EXT': "",
          }),
          Tag({
            'NAME': 'ade2',
            'ID': 'ade2',
            'ICON': "",
            'DESCRIPTION': "",
            'EXT': "",
          }),
          Tag({
            'NAME': 'ade3',
            'ID': 'ade3',
            'ICON': "",
            'DESCRIPTION': "",
            'EXT': "",
          }),
          Tag({
            'NAME': 'ade4',
            'ID': 'ade4',
            'ICON': "",
            'DESCRIPTION': "",
            'EXT': "",
          })
        ],
        'only_admin': false,
      }),
      Tag({
        'NAME': 'G_ade4',
        'ID': 'g_ade4',
        'ICON': "",
        'DESCRIPTION': "",
        'EXT': "",
        'CREATOR': 'ade1',
        'admins': [
          'ade1',
        ],
        'users': [
          Tag({
            'NAME': 'ade1',
            'ID': 'ade1',
            'ICON': "",
            'DESCRIPTION': "",
            'EXT': "",
          }),
          Tag({
            'NAME': 'ade2',
            'ID': 'ade2',
            'ICON': "",
            'DESCRIPTION': "",
            'EXT': "",
          }),
          Tag({
            'NAME': 'ade3',
            'ID': 'ade3',
            'ICON': "",
            'DESCRIPTION': "",
            'EXT': "",
          }),
          Tag({
            'NAME': 'ade4',
            'ID': 'ade4',
            'ICON': "",
            'DESCRIPTION': "",
            'EXT': "",
          })
        ],
        'only_admin': false,
      }),
    ],
    'channels': [
      Tag({
        'NAME': 'C_ade1',
        'ID': 'c_ade1',
        'ICON': "",
        'DESCRIPTION': "",
        'EXT': "",
        'CREATOR': 'ade1',
        'admins': [
          'ade1',
        ],
        'users': [
          Tag({
            'NAME': 'ade1',
            'ID': 'ade1',
            'ICON': "",
            'DESCRIPTION': "",
            'EXT': "",
          }),
          Tag({
            'NAME': 'ade2',
            'ID': 'ade2',
            'ICON': "",
            'DESCRIPTION': "",
            'EXT': "",
          }),
          Tag({
            'NAME': 'ade3',
            'ID': 'ade3',
            'ICON': "",
            'DESCRIPTION': "",
            'EXT': "",
          }),
          Tag({
            'NAME': 'ade4',
            'ID': 'ade4',
            'ICON': "",
            'DESCRIPTION': "",
            'EXT': "",
          })
        ],
        'only_admin': true,
      }),
      Tag({
        'NAME': 'C_ade2',
        'ID': 'c_ade2',
        'ICON': "",
        'DESCRIPTION': "",
        'EXT': "",
        'CREATOR': 'ade1',
        'admins': ['ade1', 'ade2'],
        'users': [
          Tag({
            'NAME': 'ade1',
            'ID': 'ade1',
            'ICON': "",
            'DESCRIPTION': "",
            'EXT': "",
          }),
          Tag({
            'NAME': 'ade2',
            'ID': 'ade2',
            'ICON': "",
            'DESCRIPTION': "",
            'EXT': "",
          }),
          Tag({
            'NAME': 'ade3',
            'ID': 'ade3',
            'ICON': "",
            'DESCRIPTION': "",
            'EXT': "",
          }),
          Tag({
            'NAME': 'ade4',
            'ID': 'ade4',
            'ICON': "",
            'DESCRIPTION': "",
            'EXT': "",
          })
        ],
        'only_admin': true,
      }),
      Tag({
        'NAME': 'C_ade3',
        'ID': 'c_ade3',
        'ICON': "",
        'DESCRIPTION': "",
        'EXT': "",
        'CREATOR': 'ade1',
        'admins': [
          'ade1',
        ],
        'users': [
          Tag({
            'NAME': 'ade1',
            'ID': 'ade1',
            'ICON': "",
            'DESCRIPTION': "",
            'EXT': "",
          }),
          Tag({
            'NAME': 'ade2',
            'ID': 'ade2',
            'ICON': "",
            'DESCRIPTION': "",
            'EXT': "",
          }),
          Tag({
            'NAME': 'ade3',
            'ID': 'ade3',
            'ICON': "",
            'DESCRIPTION': "",
            'EXT': "",
          }),
          Tag({
            'NAME': 'ade4',
            'ID': 'ade4',
            'ICON': "",
            'DESCRIPTION': "",
            'EXT': "",
          })
        ],
        'only_admin': true,
      }),
      Tag({
        'NAME': 'C_ade4',
        'ID': 'c_ade4',
        'ICON': "",
        'DESCRIPTION': "",
        'EXT': "",
        'CREATOR': 'ade1',
        'admins': [
          'ade1',
        ],
        'users': [
          Tag({
            'NAME': 'ade1',
            'ID': 'ade1',
            'ICON': "",
            'DESCRIPTION': "",
            'EXT': "",
          }),
          Tag({
            'NAME': 'ade2',
            'ID': 'ade2',
            'ICON': "",
            'DESCRIPTION': "",
            'EXT': "",
          }),
          Tag({
            'NAME': 'ade3',
            'ID': 'ade3',
            'ICON': "",
            'DESCRIPTION': "",
            'EXT': "",
          }),
          Tag({
            'NAME': 'ade4',
            'ID': 'ade4',
            'ICON': "",
            'DESCRIPTION': "",
            'EXT': "",
          })
        ],
        'only_admin': true,
      })
    ]
  });
  user.load_data(tag);
  print(user.groups!.objects_);
}
