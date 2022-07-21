//
//  QuoteCardState_CN.swift
//  CalmingNotifications
//
//  Created by Maxim on 13.02.2022.
//  Copyright © 2022 Max. All rights reserved.
//

import Foundation
import MommysEye


protocol QuoteCardStateProtocol_CN {
    var quotes: Publisher<[String]> { get }
    var quoteCards: Publisher<[QuoteCard_CN]> { get }
    var networkProgress: Publisher<Double> { get }
}

final class QuoteCardState_CN: QuoteCardStateProtocol_CN {
    
    var quotes = Publisher(value: [String]())
    var quoteCards = Publisher(value: [QuoteCard_CN]())
    var networkProgress = Publisher(value: 0.0)
}




//Publisher(value: ["Цель нашей жизни - быть счастливыми",
//                                "Жизнь - это то, что происходит с вами, пока вы строите другие планы",
//                                "Я думаю, что любознательность к жизни во всех ее аспектах все же является секретом великих творческих людей.",
//                                "Жизнь - это не проблема, которую нужно решить, а реальность, которую нужно пережить",
//                                "Неисследованная жизнь не стоит того, чтобы жить",
//                                "Превратите свои раны в мудрость",
//                                "Как я это вижу, если вы хотите радугу, вам нужно примириться с дождем",
//                                "Пережить все, что положено судьбой - значит всецело ее принять",
//                                "Не соглашайтесь на то, что дает вам жизнь, сделайте жизнь лучше и стройте что-нибудь",
//                                "Вы никогда не научитесь многому, слушая, как вы говорите",
//                                "Жизнь навязывает вам вещи, которые вы не можете контролировать, но у вас все еще есть выбор, как это пережить",
//                                "Жизнь никогда не бывает легкой. Есть работа, которую нужно сделать, и обязательства, которые нужно выполнить, обязательства перед правдой, справедливостью и свободой",
//                                " Жизнь, на самом деле, проста, но люди настойчиво ее усложняют",
//                                " Жизнь - как вождение велосипеда. Чтобы сохранять равновесие, нужно продолжать двигаться",
//                                "Моя мама всегда говорила: жизнь - как коробка шоколадных конфет. Никогда не знаешь, что попадется",
//                                "Жизнь - это череда уроков, которые нужно прожить, чтобы понять"])


//Publisher(value: [
//    QuoteCard_CN(quote: quotes.value[0], image: UIImage(named: "image\(0)")!, id: UUID(uuidString: "7a2e9e4c-c004-4fda-81fd-33d25433cc20")!, isFavorite: false),
//    QuoteCard_CN(quote: quotes.value[1], image: UIImage(named: "image\(1)")!, id: UUID(uuidString: "08f42fc5-2e0a-4820-bebb-956c4819d4bc")!, isFavorite: false),
//    QuoteCard_CN(quote: quotes.value[2], image: UIImage(named: "image\(2)")!, id: UUID(uuidString: "667e81ba-e620-4322-88b6-1f40af033997")!, isFavorite: false),
//    QuoteCard_CN(quote: quotes.value[3], image: UIImage(named: "image\(3)")!, id: UUID(uuidString: "45f9ad48-622b-43e7-bbe5-28e787e7b082")!, isFavorite: false),
//    QuoteCard_CN(quote: quotes.value[4], image: UIImage(named: "image\(4)")!, id: UUID(uuidString: "1aacb596-7f0e-46bd-a3bf-d325bdcbb693")!, isFavorite: false),
//    QuoteCard_CN(quote: quotes.value[5], image: UIImage(named: "image\(5)")!, id: UUID(uuidString: "ededf6e0-dfcb-4603-90d3-c92ecbf871be")!, isFavorite: false),
//    QuoteCard_CN(quote: quotes.value[6], image: UIImage(named: "image\(6)")!, id: UUID(uuidString: "3a30955c-18f8-4a40-9f12-6a6c86d47a6d")!, isFavorite: false),
//    QuoteCard_CN(quote: quotes.value[7], image: UIImage(named: "image\(7)")!, id: UUID(uuidString: "285e5793-6b02-41e7-97ff-cb3418336a85")!, isFavorite: false),
//    QuoteCard_CN(quote: quotes.value[8], image: UIImage(named: "image\(8)")!, id: UUID(uuidString: "8ddd0891-f884-4afa-a3f2-10e590922e71")!, isFavorite: false),
//    QuoteCard_CN(quote: quotes.value[9], image: UIImage(named: "image\(9)")!, id: UUID(uuidString: "2fdd225d-e2b3-452a-b17d-09ef7da8b0fb")!, isFavorite: false),
//    QuoteCard_CN(quote: quotes.value[10], image: UIImage(named: "image\(10)")!, id: UUID(uuidString: "2bc5b7cc-3a4f-48df-99b6-60cbaf392f91")!, isFavorite: false)
//])
