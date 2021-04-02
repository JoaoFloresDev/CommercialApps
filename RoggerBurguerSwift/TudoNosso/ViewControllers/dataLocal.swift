//
//  dataLocal.swift
//  TudoNosso
//
//  Created by Joao Flores on 23/08/20.
//  Copyright © 2020 Joao Flores. All rights reserved.
//

import Foundation

class LocalData {
	var promoArray =
		[
		"Bacon Cheddar",
		"Costela Premium Quality",
		"Tradicional",
		"Rogger Pepperoni"
		]

	var drinkList =
		[
		"Bacon Cheddar",
		"Rogger Egg",
		"Rogger Onion",
		"Rogger Pepperoni",

		"Tradicional",
		"Bacon",
		"Frangrill",
		"Costela Premium Quality",
		"Especial Duplo",
		"My House",
		"Kids",
		]

	var categorysList =
		[
		"Refrigerante",
		"Cerveja",
		"Água"
		]

	var dictDescription2 =
		[
		"Refrigerante":
			[
//				"Coca-Cola",
//				"Scheweppes Citrus",
//				"Guaraná",

				"Coca-Cola • 350ml",
				"Guaraná • 350ml",
				"Scheweppes Citrus • 350ml",
				"Coca Cola • 600ml",
				"Coca Cola • 2L",
				"Guaraná • 200ml",
			],

		"Cerveja":
			["Budweiser", "Heineken", "Stela Artois"],

		"Água":
			["Sem gás", "Com gás"]
		] as [String : Array<String>]

	var dictPrice =
		[
		"Bacon Cheddar": 23,
		"Pepperoni Venture": 23,
		"Rogger Egg": 19,
		"Rogger Onion": 20,
		"Rogger Pepperoni": 25,

		"Tradicional": 17,
		"Bacon": 21,
		"Frangrill": 19,
		"Costela Premium Quality": 25,
		"Especial Duplo": 28,
		"My House": 15,
		"Kids": 13.9,


		"Duplo Salada": 40,
		"Duplo Burguer": 40,
		"Triplo Cheese": 40,
		"Duplo Cheddar": 40,


		"Refrigerante": 0,
		"Cerveja": 0,
		"Água": 0,

		"Budweiser": 7,
		"Heineken": 8,
		"Stela Artois": 7,

		"Sem gás": 3,
		"Com gás": 3,

		"Coca-Cola • 350ml" : 5,
		"Guaraná • 350ml" : 5,
		"Scheweppes Citrus • 350ml" : 5,
		"Coca Cola • 600ml" : 8,
		"Coca Cola • 2L" : 12,
		"Guaraná • 200ml" : 2,
		] as [String : Double]

	var dictDescription =
		[
			"Refrigerante":
			"Refrigerante lata 350 ml, selecione seu refrigerante",

			"Cerveja":
			"Cervejas long neck 330 ml, selecione sua cerveja",

			"Água":
			"Garrafa de água 500 ml",

			"Bacon Cheddar":
			"Pão de batata, hambúrguer angus 180g assado na brasa, fatias de bacon, cheddar, alface americana, tomate e maionese artesanal",

			"Pepperoni Venture":
			"",

			"Rogger Egg":
			"Pão de batata, hambúrguer angus 180g assado na brasa, queijo prato duplo, ovo na chapa, alface americana, tomate e maionese artesanal",

			"Rogger Onion":
			"Pão de batata, hambúrguer angus 180g assado na brasa, queijo prato duplo, cebola roxa ao molho barbecue, cebola onion, alface americana, tomate e maionese artesanal",

			"Rogger Pepperoni":
			"Pão de batata, hambúrguer angus 180g, queijo prato duplo, pepperoni, doritos, tomate e maionese artesanal",

			"Duplo Salada":
			"",

			"Duplo Burguer":
			"",

			"Triplo Cheese":
			"",

			"Duplo Cheddar":
			"",

			"Tradicional":
			"Pão de batata, hambúrguer angus 180g assado na brasa, queijo prato duplo, alface americana, tomate e maionese artesanal",

			"Bacon":
			"Pão de batata, hambúrguer angus 180g assado na brasa, queijo prato duplo, fatias de bacon, alface americana, tomate e maionese artesanal",

			"Frangrill":
			"Pão de batata, hambúrguer de frango 120g grelhado na chapa, bacon cheddar ou catupiry, alface americana, tomare e maionese artesanal",

			"Costela Premium Quality":
			"Pão australiano ou de batata, hambúrguer costela 200g assado na brasa, queijo prato, rúcula ou alface, cebola roxa frira na chapa, tomate, tomate seco e maionese artesanal",

			"Especial Duplo":
			"Pão de batata, 2 hambúrgueres angus 180g assado na brasa, duplo queijo prato, fatias de bacon, cebola roxa, alface americana, tomate e maionese artesanal",

			"My House":
			"Pão de batata, hambúrguer angus 120g, maionese artesanal e cheddar",

			"Kids":
			"Pão de batata, hambúrguer angus 180g, queijo prato duplo, pepperoni, doritos, tomate seco e maionese artesanal",
	]

	var additionals = [
		"Bacon",
		"Ovo na Chapa",
		"Molho Barbecue",
		"Cebola Roxa no Molho Barbecue",
		"Cebola Roxa na chapa",
		"Cebola Roxa salada",

		"Catupiry",
		"Cheddar",
		"Queijo Prato",
		"Doritos",
		"Tomate Seco",
		"Hamburguer Costela 200g",

		"Hamburguer Costela 200g + Queijo Prato",
		"Hamburguer Costela 200g + Cheddar",
		"Hamburguer Angus 180g",
		"Hamburguer Angus 180g + Queijo Prato",
		"Hamburguer Angus 180g + Cheddar",
		"Hamburguer de Frango 120g",

		"Porção de Onion (20 unidades)",
		"Porção de Batata Maluca Tradicional",
		"Porção de Batata Maluca com Bacon e Cheddar",
		"Pote Molho Artesanal",
		"Porção de Onion (5 unidades)",
		"Porção de Batata Maluca Pequena",

		"Rucula",
		"Salada de Alface e Tomate",
	]

	var additionalsPriceDict = [
		"Bacon" : 4,
		"Ovo na Chapa" : 2,
		"Molho Barbecue" : 3,
		"Cebola Roxa no Molho Barbecue" : 3,
		"Cebola Roxa na chapa" : 3,
		"Cebola Roxa salada" : 2,
		"Catupiry" : 4,
		"Cheddar" : 4,
		"Queijo Prato" : 4,
		"Doritos" : 3,
		"Tomate Seco" : 4,
		"Hamburguer Costela 200g" : 10,

		"Hamburguer Costela 200g + Queijo Prato" : 14,
		"Hamburguer Costela 200g + Cheddar" : 14,
		"Hamburguer Angus 180g" : 8,
		"Hamburguer Angus 180g + Queijo Prato" : 12,
		"Hamburguer Angus 180g + Cheddar" : 12,
		"Hamburguer de Frango 120g" : 6,
		"Porção de Onion (20 unidades)" : 18,
		"Porção de Batata Maluca Tradicional" : 18,
		"Porção de Batata Maluca com Bacon e Cheddar" : 24,
		"Pote Molho Artesanal" : 2,
		"Porção de Onion (5 unidades)" : 2,
		"Porção de Batata Maluca Pequena" : 2,
		
		"Rucula" : 1,
		"Salada de Alface e Tomate" : 2,

		"Refrigerante": 0,
		"Cerveja": 0,
		"Água": 0,

		"Budweiser": 7,
		"Heineken": 8,
		"Stela Artois": 7,

		"Sem gás": 3,
		"Com gás": 3,

		"Coca-Cola • 350ml" : 5,
		"Guaraná • 350ml" : 5,
		"Scheweppes Citrus • 350ml" : 5,
		"Coca Cola • 600ml" : 8,
		"Coca Cola • 2L" : 12,
		"Guaraná • 200ml" : 2
		
	] as [String : Double]

}
