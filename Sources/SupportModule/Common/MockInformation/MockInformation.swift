//
//  MockInformation.swift
//
//
//  Created by Danilo Hernandez on 27/10/23.
//

import Foundation
import SwiftUI

public struct MockInformation {

    static let metaDataCheckBox: DVMetaData = DVMetaData(id: "checkBox", label: "Selecciona una opcion", saveField: true, options: [OptionItemModelV2(value: "cedula", label: "Cedula", foregroundColor: "#003865"),OptionItemModelV2(value: "tarjetaIdentidad", label: "Tarjeta de identidad", foregroundColor: "#000000")], textColor: "#003865", fontSize: 15.0, isRequired: true, name: "NoseNombre", additionalInfo: AdditionalInfo(bold: true, color: "#000000", fontSize: "15", textAlign: "Center"))
    static let metaDataCheckBox2: DVMetaData = DVMetaData(id: "checkBox", label: "Selecciona una opcion", saveField: true, options: [OptionItemModelV2(value: "cedula1", label: "Cedula", foregroundColor: "#003865"),OptionItemModelV2(value: "tarjetaIdentidad2", label: "Tarjeta de identidad", foregroundColor: "#000000")], textColor: "#003865", fontSize: 15.0, isRequired: true, name: "NoseNombre", additionalInfo: AdditionalInfo(bold: true, color: "#000000", fontSize: "15", textAlign: "Center"))
    
    static let cardModelChatHistory: CardModel = CardModel( id: "chatHistory", image: ImageModel(image: "https://solucionesbpo.com/wp-content/uploads/2021/08/young-woman-with-microphone-working-on-record-studio-scaled-e1632251040963.jpeg", backgroundColor: nil), titleFormat: textViewModel,dateFormat: TextViewModel(text: "12:03 PM (25-OCT-2023)", foregroundColor: .gray, font: .system(size: 12)), designCard: ComponentDesign(backgroundColor: .gray.opacity(0.1), cornerRaiuds: 15), action: "chat")
    static let cardModelList: CardModel = CardModel(id: "link_token",  link: "https://www.corporacionbi.com/gt/bancoindustrial/1717-2/", titleFormat: textViewModel)
    
    static let cardModel: CardModel = CardModel(id: "modelCard", image: ImageModel(image: "https://solucionesbpo.com/wp-content/uploads/2021/08/young-woman-with-microphone-working-on-record-studio-scaled-e1632251040963.jpeg"), link: "https://www.corporacionbi.com/gt/bancoindustrial/1717-2/", titleFormat: TextViewModel(text: "Thank you", foregroundColor: .black, font: .bold(Font.system(size: 15))()), dateFormat: TextViewModel(text: "12:03 PM (25-OCT-2023)", foregroundColor: .black, font: .system(size: 12)), nameFormat: TextViewModel(text: "Danilo", foregroundColor: .black, font: .bold(Font.system(size: 15))()))
    
    static let textViewModel: TextViewModel = TextViewModel(text: "Help with my token Help with my token Help with my token Help with m p with my token Help with my token Help with my token sss ", foregroundColor: .black, font: .system(size: 14), expandable: false)
    static let cardListArray : [CardModel] = [
        CardModel(id: "1", link: "https://www.corporacionbi.com/gt/bancoindustrial/atencion-al-cliente-1137/", titleFormat: TextViewModel(text: "Ayuda con Token",foregroundColor: .black, font: .system(size: 14))),
        CardModel(id: "2", link: "https://www.apple.com/co/", titleFormat: TextViewModel(text:"Ayuda con mi clave",foregroundColor: .black, font: .system(size: 14))),
        CardModel(id: "3", link: "https://menudigital.bi.com.gt/?__hstc=24312037.fb623fbeae4f891229fb6b9cf2f5e484.1681769456424.1684434476501.1684445879713.21&__hssc=24312037.1.1684445879713&__hsfp=805642184", titleFormat: TextViewModel(text: "Atencion al cliente",foregroundColor: .black, font: .system(size: 14))),
        CardModel(id: "4", link: "https://www.apple.com/co/", titleFormat: TextViewModel(text: "Ayuda con transferencia",foregroundColor: .black, font: .system(size: 14)))]
    
    static let cardListZonas : [CardModel] = [
        CardModel(id: "1",image: ImageModel(image: "https://www.estrategiaynegocios.net/binrepository/1350x900/75c0/1200d900/none/26086/QUOJ/banco-industria-gt_1437769_20220502084737.jpg"), titleFormat: TextViewModel(text: "Banco IndustrialZona 13 Interior Combex Guatemala Agencia",foregroundColor: .black, font: .system(size: 14))),
        CardModel(id: "2", image: ImageModel(image: "https://www.corporacionbi.com/gt/bancoindustrial/wp-content/uploads/2020/09/1991.jpg", backgroundColor: .yellow), titleFormat: TextViewModel(text:" Banco Industrial Zona 14 Interior Camboa Guatemala Agencia",foregroundColor: .black, font: .system(size: 14))),
        CardModel(id: "1",image: ImageModel(image: "https://www.estrategiaynegocios.net/binrepository/1350x900/75c0/1200d900/none/26086/QUOJ/banco-industria-gt_1437769_20220502084737.jpg", backgroundColor: .pink), titleFormat: TextViewModel(text: "Banco IndustrialZona 15 Interior Combex Guatemala Agencia",foregroundColor: .black, font: .system(size: 14))),
        CardModel(id: "2", image: ImageModel(image: "https://www.corporacionbi.com/gt/bancoindustrial/wp-content/uploads/2020/09/1991.jpg", backgroundColor: .blue), titleFormat: TextViewModel(text:" Banco Industrial Zona 16  Camboa Guatemala Agencia",foregroundColor: .black, font: .system(size: 14)))]
    
    static let generalConfiguration: GeneralConfiguration = GeneralConfiguration(buttonInformationStartChat: buttonModel, placeHolderSearchBar: "Buscar articulo", titleModule: TextViewModel(text: "Bienvenido a soporte", foregroundColor: .black, font: .bold(Font.system(size: 20))()), titleLastChat: TextViewModel(text: "Ultima conversación", foregroundColor: .black, font: .bold(Font.system(size: 16))()), titleChatButton: "Iniciar chat")
    
    static let buttonModel: ButtonModel = ButtonModel(image: Image(systemName: "person"), designButton: ComponentDesign(backgroundColor: .gray.opacity(0.1), cornerRaiuds: 15), title: TextViewModel(text: "Iniciar conversación", foregroundColor: .black))
    
    static let queryTypesModelArray: [QueryTypesModel] = [QueryTypesModel(id: "1", title: TextViewModel(text: "Ayuda con mi clave")), QueryTypesModel(id: "2", title: TextViewModel(text: "Consulta en general"))]
    
    static  var messages: [MessagesStruct] = [
        MessagesStruct(id: "1", message: TextViewModel(text: "Hola, necesito ayuda"), date: TextViewModel(text: "8/11/2023"), receive: false),
        MessagesStruct(id: "4", linkImage: "https://media.licdn.com/dms/image/C4E0BAQE2XFQtSRiHZQ/company-logo_200_200/0/1656405313746/tribal_spain_logo?e=2147483647&v=beta&t=R7R5-tGgcQAoTvGbs6hLScx4xEczAnesII9r4PAoSWs", date: TextViewModel(text: "8/11/2023"), receive: true, specialMessage: SpecialMessage(metaData: MockInformation.metaDataCheckBox2)),
        MessagesStruct(id: "2", linkImage: "https://media.licdn.com/dms/image/C4E0BAQE2XFQtSRiHZQ/company-logo_200_200/0/1656405313746/tribal_spain_logo?e=2147483647&v=beta&t=R7R5-tGgcQAoTvGbs6hLScx4xEczAnesII9r4PAoSWs", message: TextViewModel(text: "Hola, Juaquin, un gusto en saludarte"), date: TextViewModel(text: "8/11/2023"), receive: true),
        MessagesStruct(id: "4", linkImage: "https://media.licdn.com/dms/image/C4E0BAQE2XFQtSRiHZQ/company-logo_200_200/0/1656405313746/tribal_spain_logo?e=2147483647&v=beta&t=R7R5-tGgcQAoTvGbs6hLScx4xEczAnesII9r4PAoSWs", date: TextViewModel(text: "8/11/2023"), receive: true, specialMessage: SpecialMessage(metaData: MockInformation.metaDataCheckBox)),
        MessagesStruct(id: "2", linkImage: "https://media.licdn.com/dms/image/C4E0BAQE2XFQtSRiHZQ/company-logo_200_200/0/1656405313746/tribal_spain_logo?e=2147483647&v=beta&t=R7R5-tGgcQAoTvGbs6hLScx4xEczAnesII9r4PAoSWs", message: TextViewModel(text: "Cuentame, en que te puedo colaborar"), date: TextViewModel(text: "8/11/2023"), receive: true),
        MessagesStruct(id: "1", message: TextViewModel(text: "No puedo hacer una transferencia, me sale error de conexion"), date: TextViewModel(text: "8/11/2023"), receive: false), MessagesStruct(id: "1", message: TextViewModel(text: "Hola, necesito ayuda"), date: TextViewModel(text: "8/11/2023"), receive: false),
        MessagesStruct(id: "2", linkImage: "https://media.licdn.com/dms/image/C4E0BAQE2XFQtSRiHZQ/company-logo_200_200/0/1656405313746/tribal_spain_logo?e=2147483647&v=beta&t=R7R5-tGgcQAoTvGbs6hLScx4xEczAnesII9r4PAoSWs", message: TextViewModel(text: "Hola, Juaquin, un gusto en saludarte"), date: TextViewModel(text: "8/11/2023"), receive: true),
        MessagesStruct(id: "2", linkImage: "https://media.licdn.com/dms/image/C4E0BAQE2XFQtSRiHZQ/company-logo_200_200/0/1656405313746/tribal_spain_logo?e=2147483647&v=beta&t=R7R5-tGgcQAoTvGbs6hLScx4xEczAnesII9r4PAoSWs", message: TextViewModel(text: "Hola, en qué te puedo colaborar? Hola, en qué te puedo colaborar? Hola, en Hola, en qué te puedo colaborar? Hola, en qué te puedo colaborar? Hola, en Hola, en qué te puedo colaborar? Hola, en qué te puedo colaborar? Hola, en Hola, en qué te puedo colaborar? Hola, en qué te puedo colaborar? Hola, en Hola, en qué te puedo colaborar? Hola, en qué te puedo colaborar? Hola, en Hola, en qué te puedo colaborar? Hola, en qué te puedo colaborar? Hola, en Hola, en qué te puedo colaborar? Hola, en qué te puedo colaborar? Hola, en Hola, en qué te puedo colaborar? Hola, en qué te puedo colaborar? Hola, en hola", expandable: true), date: TextViewModel(text: "8/11/2023"), receive: true),
        MessagesStruct(id: "1", message: TextViewModel(text: "No puedo hacer una transferencia, me sale error de conexion"), date: TextViewModel(text: "8/11/2023"), receive: false)]
}

