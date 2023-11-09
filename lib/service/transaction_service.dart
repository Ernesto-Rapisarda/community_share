import 'package:community_share/model/basic/community_basic.dart';
import 'package:community_share/reporitory/product_repository.dart';
import 'package:community_share/reporitory/user_repository.dart';
import 'package:flutter/cupertino.dart';

import '../model/product.dart';

class TransactionService{
  final ProductRepository productRepository = ProductRepository();

  Future<bool> createAndConfirmOrder(BuildContext context, Product product, CommunityBasic communityBasic) async{
    return true;
  }
}