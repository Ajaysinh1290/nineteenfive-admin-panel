// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:nineteenfive_admin_panel/models/chat_data.dart';
// import 'package:nineteenfive_admin_panel/models/order.dart';
// import 'package:nineteenfive_admin_panel/models/poster.dart';
// import 'package:nineteenfive_admin_panel/models/product.dart';
// import 'package:nineteenfive_admin_panel/models/user_data.dart';
//
// List<Order> orders = [
//   Order(
//       userId: 'Joe Trump',
//       productId: DateTime.now().millisecondsSinceEpoch.toString(),
//       numberOfItems: 2,
//       totalAmount: 20000,
//       orderId: DateTime.now().millisecondsSinceEpoch.toString(),
//       transactionId: "pay_" + DateTime.now().millisecondsSinceEpoch.toString(),
//       orderTime: DateTime.now()),
//   Order(
//       userId: 'Donald Trump',
//       productId: DateTime.now().millisecondsSinceEpoch.toString(),
//       numberOfItems: 2,
//       totalAmount: 20000,
//       orderId: DateTime.now().millisecondsSinceEpoch.toString(),
//       transactionId: "pay_" + DateTime.now().millisecondsSinceEpoch.toString(),
//       orderTime: DateTime.now()),
//   Order(
//       userId: 'Olive Yew',
//       productId: DateTime.now().millisecondsSinceEpoch.toString(),
//       numberOfItems: 2,
//       totalAmount: 20000,
//       orderId: DateTime.now().millisecondsSinceEpoch.toString(),
//       transactionId: "pay_" + DateTime.now().millisecondsSinceEpoch.toString(),
//       orderTime: DateTime.now()),
//   Order(
//       userId: 'Rose Bush',
//       productId: DateTime.now().millisecondsSinceEpoch.toString(),
//       numberOfItems: 2,
//       totalAmount: 20000,
//       orderId: DateTime.now().millisecondsSinceEpoch.toString(),
//       transactionId: "pay_" + DateTime.now().millisecondsSinceEpoch.toString(),
//       orderTime: DateTime.now()),
//   Order(
//       userId: 'Anne Thurium',
//       productId: DateTime.now().millisecondsSinceEpoch.toString(),
//       numberOfItems: 2,
//       totalAmount: 20000,
//       orderId: DateTime.now().millisecondsSinceEpoch.toString(),
//       transactionId: "pay_" + DateTime.now().millisecondsSinceEpoch.toString(),
//       orderTime: DateTime.now()),
// ];
//
// List<UserData> users = [
//   UserData(
//       userId: '1',
//       email: 'harrieupp@gmail.com',
//       userName: 'Harriet Upp',
//       userProfilePic:
//           'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80',
//       mobileNumber: '+90278273827'),
//   UserData(
//       userId: '2',
//       email: 'harrieupp@gmail.com',
//       userName: 'Al Annnon',
//       userProfilePic:
//           'https://images.unsplash.com/photo-1620012253295-c15cc3e65df4?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=701&q=80',
//       mobileNumber: '+90278273827'),
//   UserData(
//       userId: '3',
//       email: 'harrieupp@gmail.com',
//       userName: 'Mustafa Leek',
//       userProfilePic:
//           'https://images.unsplash.com/photo-1622445275463-afa2ab738c34?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=634&q=80',
//       mobileNumber: '+90278273827'),
//   UserData(
//       userId: '4',
//       email: 'harrieupp@gmail.com',
//       userName: 'Anna Domino',
//       userProfilePic:
//           'https://images.unsplash.com/photo-1618001789159-ffffe6f96ef2?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=634&q=80',
//       mobileNumber: '+90278273827'),
//   UserData(
//       userId: '5',
//       email: 'harrieupp@gmail.com',
//       userName: 'Ivan Itchinos',
//       userProfilePic:
//           'https://images.unsplash.com/photo-1581863293459-1a1ee19e0857?ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mjl8fHNoaXJ0fGVufDB8fDB8fA%3D%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60',
//       mobileNumber: '+90278273827'),
//   UserData(
//       userId: '6',
//       email: 'harrieupp@gmail.com',
//       userName: 'Anna Littlical',
//       userProfilePic:
//           'https://images.unsplash.com/photo-1548864789-7393f2b4baa5?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=674&q=80',
//       mobileNumber: '+90278273827'),
//   UserData(
//       userId: '7',
//       email: 'harrieupp@gmail.com',
//       userName: 'Don Messwidme',
//       userProfilePic:
//           'https://images.unsplash.com/photo-1604695573706-53170668f6a6?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=634&q=80',
//       mobileNumber: '+90278273827'),
//   UserData(
//       userId: '8',
//       email: 'harrieupp@gmail.com',
//       userName: 'Dulcie Veeta',
//       userProfilePic:
//           'https://images.unsplash.com/photo-1593757107729-eae8bcc74f8e?ixid=MnwxMjA3fDB8MHxzZWFyY2h8NjR8fHNoaXJ0fGVufDB8fDB8fA%3D%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60',
//       mobileNumber: '+90278273827'),
//   UserData(
//       userId: '9',
//       email: 'harrieupp@gmail.com',
//       userName: 'Annie Versaree',
//       userProfilePic:
//           'https://images.unsplash.com/photo-1548916699-f5d72cd05b5b?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=634&q=80',
//       mobileNumber: '+90278273827'),
//   UserData(
//       userId: '10',
//       email: 'harrieupp@gmail.com',
//       userName: 'Wiley Waites',
//       userProfilePic:
//           'https://images.unsplash.com/photo-1599418175586-9355fef5c483?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=634&q=80',
//       mobileNumber: '+90278273827'),
//   UserData(
//       userId: '11',
//       email: 'harrieupp@gmail.com',
//       userName: 'Sarah Moanees',
//       userProfilePic:
//           'https://images.unsplash.com/photo-1607125435956-323bd982580a?ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTM2fHxzaGlydHxlbnwwfHwwfHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60',
//       mobileNumber: '+90278273827'),
// ];
//
// List<Product> products = [
//   Product(
//       productId: DateTime.now().millisecondsSinceEpoch.toString(),
//       productName: "Black shirt for men",
//       productCreatedOn: DateTime.now(),
//       productCategory: "Shirts",
//       productPrice: 350,
//       availableStock: 10,
//       productMrp: 1000,
//       productImages: [
//         'https://images.unsplash.com/photo-1563389234808-52344934935c?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=634&q=80'
//       ],
//       productDescription: ''),
//   Product(
//       productId: DateTime.now().millisecondsSinceEpoch.toString(),
//       productName: "Black shirt for men",
//       productCreatedOn: DateTime.now(),
//       productCategory: "Shirts",
//       productPrice: 350,
//       availableStock: 10,
//       productImages: [
//         'https://images.unsplash.com/photo-1620012253295-c15cc3e65df4?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=701&q=80'
//       ],
//       productDescription: ''),
//   Product(
//       productId: DateTime.now().millisecondsSinceEpoch.toString(),
//       productName: "Black shirt for men",
//       productCreatedOn: DateTime.now(),
//       productCategory: "Shirts",
//       productPrice: 350,
//       availableStock: 10,
//       productImages: [
//         'https://images.unsplash.com/photo-1622445275463-afa2ab738c34?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=634&q=80'
//       ],
//       productDescription: ''),
//   Product(
//       productId: DateTime.now().millisecondsSinceEpoch.toString(),
//       productName: "Black shirt for men",
//       productCreatedOn: DateTime.now(),
//       productCategory: "Shirts",
//       productPrice: 350,
//       productMrp: 1000,
//       availableStock: 10,
//       productImages: [
//         'https://images.unsplash.com/photo-1618001789159-ffffe6f96ef2?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=634&q=80'
//       ],
//       productDescription: ''),
//   Product(
//       productId: DateTime.now().millisecondsSinceEpoch.toString(),
//       productName: "Black shirt for men",
//       productCreatedOn: DateTime.now(),
//       productCategory: "Shirts",
//       productPrice: 350,
//       availableStock: 10,
//       productImages: [
//         'https://images.unsplash.com/photo-1581863293459-1a1ee19e0857?ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mjl8fHNoaXJ0fGVufDB8fDB8fA%3D%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60'
//       ],
//       productDescription: ''),
//   Product(
//       productId: DateTime.now().millisecondsSinceEpoch.toString(),
//       productName: "Black shirt for men",
//       productCreatedOn: DateTime.now(),
//       productCategory: "Shirts",
//       productPrice: 350,
//       availableStock: 10,
//       productImages: [
//         'https://images.unsplash.com/photo-1548864789-7393f2b4baa5?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=674&q=80'
//       ],
//       productDescription: ''),
//   Product(
//       productId: DateTime.now().millisecondsSinceEpoch.toString(),
//       productName: "Black shirt for men",
//       productCreatedOn: DateTime.now(),
//       productCategory: "Shirts",
//       productPrice: 350,
//       availableStock: 10,
//       productImages: [
//         'https://images.unsplash.com/photo-1604695573706-53170668f6a6?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=634&q=80'
//       ],
//       productDescription: ''),
//   Product(
//       productId: DateTime.now().millisecondsSinceEpoch.toString(),
//       productName: "Black shirt for men",
//       productCreatedOn: DateTime.now(),
//       productCategory: "Shirts",
//       productPrice: 350,
//       availableStock: 10,
//       productMrp: 1000,
//       productImages: [
//         'https://images.unsplash.com/photo-1593757107729-eae8bcc74f8e?ixid=MnwxMjA3fDB8MHxzZWFyY2h8NjR8fHNoaXJ0fGVufDB8fDB8fA%3D%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60'
//       ],
//       productDescription: ''),
//   Product(
//       productId: DateTime.now().millisecondsSinceEpoch.toString(),
//       productName: "Black shirt for men",
//       productCreatedOn: DateTime.now(),
//       productCategory: "Shirts",
//       productPrice: 350,
//       availableStock: 10,
//       productMrp: 1000,
//       productImages: [
//         'https://images.unsplash.com/photo-1548916699-f5d72cd05b5b?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=634&q=80'
//       ],
//       productDescription: ''),
// ];
// List<Poster> posters = [
//   Poster(
//       imageUrl:
//           'https://images.unsplash.com/photo-1593757107729-eae8bcc74f8e?ixid=MnwxMjA3fDB8MHxzZWFyY2h8NjR8fHNoaXJ0fGVufDB8fDB8fA%3D%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60',
//       categoryId: "Shirts",
//       position: "Top",
//       posterId: DateTime.now().millisecondsSinceEpoch.toString()),
//   Poster(
//       imageUrl:
//           'https://images.unsplash.com/photo-1548916699-f5d72cd05b5b?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=634&q=80',
//       categoryId: "Shirts",
//       position: "Top",
//       posterId: DateTime.now().millisecondsSinceEpoch.toString()),
//   Poster(
//       imageUrl:
//           'https://images.unsplash.com/photo-1581863293459-1a1ee19e0857?ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mjl8fHNoaXJ0fGVufDB8fDB8fA%3D%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60',
//       categoryId: "Shirts",
//       position: "Top",
//       posterId: DateTime.now().millisecondsSinceEpoch.toString()),
//   Poster(
//       imageUrl:
//           'https://images.unsplash.com/photo-1604695573706-53170668f6a6?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=634&q=80',
//       categoryId: "Shirts",
//       position: "Top",
//       posterId: DateTime.now().millisecondsSinceEpoch.toString()),
//   Poster(
//       imageUrl:
//           'https://images.unsplash.com/photo-1593757107729-eae8bcc74f8e?ixid=MnwxMjA3fDB8MHxzZWFyY2h8NjR8fHNoaXJ0fGVufDB8fDB8fA%3D%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60',
//       categoryId: "Shirts",
//       position: "Bottom",
//       posterId: DateTime.now().millisecondsSinceEpoch.toString()),
//   Poster(
//       imageUrl:
//           'https://images.unsplash.com/photo-1548916699-f5d72cd05b5b?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=634&q=80',
//       categoryId: "Shirts",
//       position: "Bottom",
//       posterId: DateTime.now().millisecondsSinceEpoch.toString()),
//   Poster(
//       imageUrl:
//           'https://images.unsplash.com/photo-1581863293459-1a1ee19e0857?ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mjl8fHNoaXJ0fGVufDB8fDB8fA%3D%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60',
//       categoryId: "Shirts",
//       position: "Bottom",
//       posterId: DateTime.now().millisecondsSinceEpoch.toString()),
//   Poster(
//       imageUrl:
//           'https://images.unsplash.com/photo-1604695573706-53170668f6a6?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=634&q=80',
//       categoryId: "Shirts",
//       position: "Bottom",
//       posterId: DateTime.now().millisecondsSinceEpoch.toString()),
// ];
// Map<String, List<ChatData>> chats = {
//   "1": [
//     ChatData(
//         chatId: DateTime.now().millisecondsSinceEpoch.toString(),
//         message: "Hi How can i help you ?",
//         messageDateTime: DateTime.now(),
//         isSeenByReceiver: true,
//         isSendByUser: false),
//     ChatData(
//         chatId: DateTime.now().millisecondsSinceEpoch.toString(),
//         message: "Why my order is still not delivered ?",
//         messageDateTime: DateTime.now(),
//         isSeenByReceiver: true,
//         isSendByUser: true),
//     ChatData(
//         chatId: DateTime.now().millisecondsSinceEpoch.toString(),
//         message: "On the way sir !",
//         messageDateTime: DateTime.now(),
//         isSeenByReceiver: true,
//         isSendByUser: false),
//     ChatData(
//         chatId: DateTime.now().millisecondsSinceEpoch.toString(),
//         message: "Okay..!",
//         messageDateTime: DateTime.now(),
//         isSeenByReceiver: true,
//         isSendByUser: true),
//   ],
//   "2" :[
//     ChatData(
//         chatId: DateTime.now().millisecondsSinceEpoch.toString(),
//         message: "Need Help..!",
//         messageDateTime: DateTime.now(),
//         isSeenByReceiver: false,
//         isSendByUser: true),
//   ],
//   "3" : [
//     ChatData(
//         chatId: DateTime.now().millisecondsSinceEpoch.toString(),
//         message: "When will my order arrived?",
//         messageDateTime: DateTime.now(),
//         isSeenByReceiver: false,
//         isSendByUser: true),
//   ],
//   "4" : [
//     ChatData(
//         chatId: DateTime.now().millisecondsSinceEpoch.toString(),
//         message: "When will my order arrived?",
//         messageDateTime: DateTime.now(),
//         isSeenByReceiver: false,
//         isSendByUser: true),
//   ],
//   "5" : [
//     ChatData(
//         chatId: DateTime.now().millisecondsSinceEpoch.toString(),
//         message: "When will my order arrived?",
//         messageDateTime: DateTime.now(),
//         isSeenByReceiver: false,
//         isSendByUser: true),
//   ],
// };
