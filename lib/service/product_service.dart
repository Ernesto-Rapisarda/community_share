import 'package:community_share/model/basic/community_basic.dart';
import 'package:community_share/model/basic/product_basic.dart';
import 'package:community_share/model/basic/user_details_basic.dart';
import 'package:community_share/model/conversation.dart';
import 'package:community_share/model/enum/order_status.dart';
import 'package:community_share/model/enum/product_availability.dart';
import 'package:community_share/model/message.dart';
import 'package:community_share/model/product.dart';
import 'package:community_share/model/product_order.dart';
import 'package:community_share/providers/UserProvider.dart';
import 'package:community_share/providers/product_provider.dart';
import 'package:community_share/reporitory/product_repository.dart';
import 'package:community_share/service/conversation_service.dart';
import 'package:community_share/utils/id_generator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/enum/product_category.dart';

class ProductService {
  final ProductRepository _productRepository = ProductRepository();
  final ConversationService _conversationService = ConversationService();

  Future<void> createProduct(BuildContext context, Product product) async {
    return await _productRepository.createProduct(context,product);
    //context.read<ProductProvider>().setProductVisualized(context, product);

    //product.docRef= docRef;

  }

  Future<List<Product>> getProducts(BuildContext context, List<ProductCategory> categories) async {
    return await _productRepository.getProducts(context,categories);
  }

  void setLike(BuildContext context, Product product, bool calledFromCard) async{
    UserDetailsBasic tmp = context.read<UserProvider>().getUserBasic();
    bool adding = false;
    Product tmpProduct = product;

    print(context.read<UserProvider>().productLiked.contains(product));
    if(!context.read<UserProvider>().productLiked.contains(product)){
      adding = true;
      tmpProduct.likesNumber =tmpProduct.likesNumber + 1;
    }
    else{
      tmpProduct.likesNumber = tmpProduct.likesNumber -1;
    }
    await _productRepository.setLikes(context, tmpProduct, tmp,adding);
    if(!calledFromCard){
      context.read<ProductProvider>().setOrRemoveLikes(context, adding, tmp);
      context.read<UserProvider>().setOrRemoveLikes(context, tmpProduct);
    }
    else{
      context.read<UserProvider>().setOrRemoveLikes(context, tmpProduct);
    }

  }

  getProductLikes(BuildContext context,String? id) async{
    return await _productRepository.getProductLikes(context, id);
  }

  Future<void> updateProduct(BuildContext context, Product product) async{
    return await _productRepository.updateProduct(context, product);

  }

  Future<bool> createOrder(BuildContext context,ProductOrder productOrder) async{
    bool orderCreated = await _productRepository.createOrder(context,productOrder);
    bool messageSended = false;
    if(orderCreated){
      ProductBasic productBasic = ProductBasic(id: productOrder.product.id, title: productOrder.product.title, urlImages: productOrder.product.urlImages, uploadDate: productOrder.product.uploadDate, availability: productOrder.product.availability, docRefCompleteProduct: productOrder.product.docRef!);
      String textMessage = 'L\'utente ${productOrder.receiver.fullName} is asking to receive your product ${productBasic.title}.\n Please, check your order\'s page for the details.\nThanks to be so great! ';
      Message message = Message(id: IdGenerator.generateUniqueMessageId(productOrder.receiver.id, productOrder.product.giver.id), sender: productOrder.receiver, receiver: productOrder.product.giver, text: textMessage, date: DateTime.now());
      //todo gestire il doppio bool
      messageSended = await _conversationService.createOrderConversation(productOrder);

    }

    if(orderCreated && messageSended){
      return true;
    }
    else{
      return false;
    }
  }

  Future<ProductOrder> updateOrderStatus(BuildContext context, ProductOrder productOrder, OrderStatus orderStatus) async{

    if(productOrder.orderStatus == OrderStatus.pending || productOrder.orderStatus == OrderStatus.productDeliveredToHotSpot){
      ProductOrder tmp = productOrder;
      tmp.orderStatus = orderStatus;
      if(tmp.orderStatus == OrderStatus.completed){
        tmp.product.availability = ProductAvailability.donated;

      }
      bool updated = await _productRepository.updateOrderStatus(context, tmp);
      if(updated){
        //todo add notifica pronto al ritiro
        return tmp;
      }
      else{
        return productOrder;
      }
    }
    return productOrder;
  }

  Future<List<Product>> search(String text) async{
    try{
      return await _productRepository.search(text);
    }catch (error){
      rethrow;
    }
  }

}

