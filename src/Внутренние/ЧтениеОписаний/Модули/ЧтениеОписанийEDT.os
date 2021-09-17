///////////////////////////////////////////////////////////////////////////////
//
// Модуль для чтения описаний метаданных 1с из EDT выгрузки
//
///////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС
///////////////////////////////////////////////////////////////////////////////

// Выполняет чтение описания объекта с учетом параметров
//
// Параметры:
//   ИмяФайла - Строка - Путь к файлу описания
//   ПараметрыЧтения - Структура - Описание трансформации данных описания в объект. См. ПараметрыСериализации.ПараметрыСериализации
//
//  Возвращаемое значение:
//   Структура - Данные описания
//
Функция ПрочитатьСвойстваИзФайла(ИмяФайла, ПараметрыЧтения) Экспорт

	ЧтениеXML = Новый ЧтениеXML;
	ЧтениеXML.ОткрытьФайл(ИмяФайла);
	
	СырыеДанные = ПрочитатьСвойстваXML(ЧтениеXML, ПараметрыЧтения);
	
	ЧтениеXML.Закрыть();
	
	СвойстваОписания = ОбработатьСырыеДанные(СырыеДанные, ПараметрыЧтения);
	
	Возврат СвойстваОписания;

КонецФункции

///////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЙ ПРОГРАММНЫЙ ИНТЕРФЕЙС
///////////////////////////////////////////////////////////////////////////////

#Область МетодыЧтения

// Читает строку на разных языках
//
// Параметры:
//   ЧтениеXML - ЧтениеXML - Читатель данных
//
//  Возвращаемое значение:
//   Строка - Данные строки
//
Функция МногоязычнаяСтрока(Знач ЧтениеXML) Экспорт
	
	Возврат ЧтениеОписанийБазовый.ЗначениеВложенногоТэга(ЧтениеXML, "value");

КонецФункции

// Читает Версию совместимости
//
// Параметры:
//   ЧтениеXML - ЧтениеXML - Читатель данных
//
//  Возвращаемое значение:
//   Строка - Данные строки, версия формата  8.3.10
//
Функция ВерсияСовместимости(Знач ЧтениеXML) Экспорт
	
	ЧтениеXML.Прочитать();

	Возврат ЧтениеXML.Значение;

КонецФункции


// Читает описание типа
//
// Параметры:
//   ЧтениеXML - ЧтениеXML - Читатель данных
//
//  Возвращаемое значение:
//   Строка - Значение типа
//
Функция ПолучитьТип(Знач ЧтениеXML) Экспорт
	
	Значение = ЧтениеОписанийБазовый.ЗначениеВложенногоТэга(ЧтениеXML, "types");

	Возврат ЧтениеОписанийБазовый.ПреобразоватьТип(Значение, Истина);

КонецФункции

// Читает логическое значение
//
// Параметры:
//   Значение - Строка - Данные содержащие булево
//
//  Возвращаемое значение:
//   Булево - Значение
//
Функция ЗначениеБулево(Знач ЧтениеXML) Экспорт
	
	ЧтениеXML.Прочитать();
	Возврат ЧтениеXML.ИмеетЗначение И СтрСравнить(ЧтениеXML.Значение, "true") = 0;
	
КонецФункции

// Читает состав подсистемы
//
// Параметры:
//   ЧтениеXML - ЧтениеXML - Читатель данных
//
//  Возвращаемое значение:
//   Строка - Полное имя объекта
//
Функция СоставПодсистемы(ЧтениеXML) Экспорт

	ЧтениеXML.Прочитать();
	Возврат ЧтениеXML.Значение;
	
КонецФункции

#КонецОбласти

///////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ
///////////////////////////////////////////////////////////////////////////////

Функция ПрочитатьСвойстваXML(ЧтениеXML, ПараметрыЧтения)

	ЧтениеXML.Прочитать();
	ЧтениеXML.Прочитать();
	
	Данные = ЧтениеОписанийБазовый.ПрочитатьСвойстваXML(ЧтениеXML, ПараметрыЧтения, ЭтотОбъект);
	
	Возврат Данные;

КонецФункции

Функция ОбработатьСырыеДанные(СырыеДанные, ПараметрыЧтения)
	
	ДанныеОбъекта = ЧтениеОписанийБазовый.ОбработатьСырыеДанные(СырыеДанные, ПараметрыЧтения);
		
	Если ПараметрыЧтения.ЕстьПодчиненные Тогда
		
		Для Каждого Элемент Из СырыеДанные Цикл
			
			Если Элемент.Ключ <> "languages" И ТипыОбъектовКонфигурации.ОписаниеТипаПоИмени(Элемент.Ключ) <> Неопределено Тогда
				
				Если СтрНайти(Элемент.Значение, ".") = 0 Тогда
					
					ДанныеОбъекта.Подчиненные.Добавить(Элемент.Ключ + "." + Элемент.Значение);
					
				Иначе

					ДанныеОбъекта.Подчиненные.Добавить(Элемент.Значение);
					
				КонецЕсли;
				
			КонецЕсли;

		КонецЦикла;

	КонецЕсли;

	Возврат ДанныеОбъекта;
	
КонецФункции
