import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:logger/logger.dart';
import 'package:unb/common/models/user_model.dart';
import 'package:unb/common/services/generic_cache.dart';

class MapService {
  final _logger = Modular.get<Logger>();
  final _imageCache = GenericCache<String, ImageProvider>();

  ImageProvider getMemberImage(final UserModel user) {
    if (_imageCache.containsKey(user.id)) {
      return _imageCache.get(user.id)!;
    }

    final value = user.profilePicture == null
        ? NetworkImage(
            'https://picsum.photos/${int.parse(user.id.substring(0, 2), radix: 16)}',
          )
        : MemoryImage(base64Decode(user.profilePicture!)) as ImageProvider;

    _logger.d('Caching image of user ${user.id}');
    _imageCache.put(user.id, value);

    return value;
  }
}
