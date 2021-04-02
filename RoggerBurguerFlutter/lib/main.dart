import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_open_whatsapp/flutter_open_whatsapp.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/home.dart';
import 'package:flutter_app/containers/main.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/containers/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_app/screens/cart.dart';
import 'package:flutter_app/screens/checkout.dart';
import 'package:flutter_app/screens/checkoutRepeat.dart';
import 'package:flutter_open_whatsapp/flutter_open_whatsapp.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_app/containers/gourmet_restaurant.dart';

// keytool -genkeypair -alias key0 -keyalg RSA -keysize 2048 -validity 9125 -keystore keystore2.jks
// Jv1355004
// key0
final List<CardImageItem> banners = [
  CardImageItem(image: 'assets/images/BaconCheddar.jpeg', 
                text: 'Bacon Cheddar', 
                price: 23,
                description: 'Pão de batata, hambúrguer angus 180g assado na brasa, fatias de bacon, cheddar, alface americana, tomate e maionese artesanal'),

  CardImageItem(image: 'assets/images/RoggerEgg.jpeg', 
                text: 'Rogger Egg', 
                price: 19, 
                description: 'Pão de batata, hambúrguer angus 180g assado na brasa, queijo prato duplo, ovo na chapa, alface americana, tomate e maionese artesanal'),

  CardImageItem(image: 'assets/images/RoggerOnion.jpeg', 
                text: 'Rogger Onion', 
                price: 20, 
                description: 'Pão de batata, hambúrguer angus 180g assado na brasa, queijo prato duplo, cebola roxa ao molho barbecue, cebola onion, alface americana, tomate e maionese artesanal'),

  CardImageItem(image: 'assets/images/RoggerPepperoni.jpeg', 
                text: 'Rogger Pepperoni Ventura', 
                price: 23, 
                description: 'Pão de batata, hambúrguer angus 180g, queijo prato duplo, pepperoni, doritos, tomate seco e maionese artesanal'),

  CardImageItem(image: 'assets/images/Tradicional.jpeg', 
                text: 'Rogger Tradicional', 
                price: 17, 
                description: 'Pão de batata, hambúrguer angus 180g assado na brasa, queijo prato duplo, alface americana, tomate e maionese artesanal'),

  CardImageItem(image: 'assets/images/Bacon.jpeg', 
                text: 'Rogger Bacon', 
                price: 21, 
                description: 'Pão de batata, hambúrguer angus 180g assado na brasa, queijo prato duplo, fatias de bacon, alface americana, tomate e maionese artesanal'),

  CardImageItem(image: 'assets/images/FrangrillCheddar.jpeg', 
                text: 'Frangrill Cheddar', 
                price: 19, 
                description: 'Pão de batata, hambúrguer de frango 120g grelhado na chapa, bacon, cheddar, alface americana, tomate e maionese artesanal'),

  CardImageItem(image: 'assets/images/FrangrillCatupiry.jpeg', 
                text: 'Frangrill Catupiry', 
                price: 19, 
                description: 'Pão de batata, hambúrguer de frango 120g grelhado na chapa, bacon, catupiry, alface americana, tomate e maionese artesanal'),

  CardImageItem(image: 'assets/images/CostelaPremiumQuality.jpeg', 
                text: 'Costela Premium Quality', 
                price: 25, 
                description: 'Pão australiano ou de batata, hambúrguer costela 200g assado na brasa, queijo prato, rúcula ou alface, cebola roxa frita na chapa, tomate, tomate seco e maionese artesanal'),

  CardImageItem(image: 'assets/images/EspecialDuplo.jpeg', 
                text: 'Especial Duplo', 
                price: 28,  
                description: 'Pão de batata, 2 hambúrgueres angus 180g assado na brasa, duplo queijo prato, fatias de bacon, cebola roxa, alface americana, tomate e maionese artesanal'),

  CardImageItem(image: 'assets/images/MyHouse.jpeg', 
                text: 'Rogger My House', 
                price: 15, 
                description: 'Pão de batata, hambúrguer angus 120g, maionese artesanal e cheddar'),

  CardImageItem(image: 'assets/images/Kids.jpeg', 
                text: 'Rogger Kids', 
                price: 13.9, 
                description: 'Pão de hambúrguer, hambúrguer angus 120g, queijo prato duplo e maionese artesanal'),
];

final List<GourmetRestaurants> listPromotions = [];

final List<CardImageItem> categories = [
  CardImageItem(image: 'assets/images/pizza.jpg', 
                text: 'Refrigerante', 
                price: 0, 
                description: 'Refrigerantes diversos sabores, selecione sua preferência'),

  CardImageItem(image: 'assets/images/lanches.jpg', 
                text: 'Cerveja', 
                price: 0, 
                description: 'Cerveja long neck 330 ml, selecione sua preferência'),

  CardImageItem(image: 'assets/images/acai.jpg', 
                text: 'Água', 
                price: 0,
                description: 'Garrafa de água 500 ml'),
];

void main() {
  
  SystemChrome.setEnabledSystemUIOverlays([]);
  runApp(Home(categories: categories, banners: banners, listPromotions: listPromotions));
}