# VK Messenger
> Семестровое домашнее задание по курсу Highload. Технопарк ВК МГТУ им. Баумана, весна 2023. Илларионов Георгий WEB-31

> [Методические указания](https://github.com/init/highload/blob/main/homework_architecture.md)

## 1 Тема 
**VK Messenger** - сервис для обмена сообщениями между пользователями. Включает такие функции как: обмен текстовыми сообщениями, стикерами, голосовыми сообщениями и вложениями в личных и групповых чатах. Также имеется возможность совершать голосовые и видео- звонки и создавать конференции.

### MVP

Ключевой функционал мессенжера- обмен сообщениями в реальном времени.

1. Профиль пользователя 
2. Создание, удаление личных чатов
3. Отправка, редактирование, удаление сообщений
4. Возможность прикреплять вложения к сообщениям.
5. Возможность отправлять голосовые сообщения
6. Поиск пользователей
7. Функционал Multilogin () **TODO**

### Целевая аудитория
- Суммарная аудитория 100 млн пользователей [^1] [^2] **ПРОВЕРИТЬ! кажется что более 300 млн**
- Месячная аудитория 76,9 млн пользователей [^1] [^2]
- Дневная аудитория 49,4 млн пользователей [^1] [^2]
- 15 млрд сообщений в день в среднем [^3]
- 33 млн пользователей в месяц пользуются голосовыми сообщениями [^3]
- Распределение по странам (Подавляющее большинство из стран СНГ): [^4]

| Страна | Посетителей в месяц |
| ------ | ------------------- |

|           | %    | Млн. чел. |
| --------- | ---- | --------- |
| Россия    | 65,7 | 50,5      |
| Украина   | 18,3 | 14,1      |
| Норвегия  | 5,6  | 4,3       |
| Беларусь  | 2,5  | 1,9       |
| Польша    | 1,7  | 1,3       |
| Казахстан | 1,1  | 0,8       |
| Остальные | 5    | 3,8       |

## 2 Расчёт нагрузки

### Продуктовые метрики
- Месячная аудитория - 76,9 млн. пользователей [^1] [^2] 
- Дневная аудитория - 49,4 млн. пользователей [^1] [^2]
- Ежедневно пользователи отправляют около 15 миллиардов сообщений [^3]
- Ежедневно пользователи создают более 3 миллионов чатов [^5]
- 33 млн пользователей ежемесячно используют голосовые сообщения [^1]

#### Средний размер хранилища пользователя
Предположим, что:
- **размер аватарки** пользователя *2 мб*
- **Имя и фамилия** пользователя занимает *14 байт* [^6]
  > 7 букв на имя + 7 букв на фамилию = 14 символов = *14 байт*
- **Информация о себе** *40 байт*
  > 40 символов = *40 байт*

#### Среднее количество действий пользователя по типам в день

1. Регистрация новых пользователей в день: *0,078 млн. чел. в день*
   > Рост за месяц составил 2,4% [^1] [^2]
   > D - прирост пользователей за день, Х - Число пользователей в новом месяце, Y - Число пользователей в старом месяце
   > Y = X * (100% + 2,4%) = X * 1,024
   > X = Y / 1,024 = 97,66 млн. чел.
   > D = (Y - X) / 30 = 2,34 млн. чел. в мес. / 30 дней = 0,078 млн. чел. в день
   
   **RPS на регистрацию:** *0,9*
   > 0,078 * 1000000 / (24 * 60 * 60) = 0,9 
1. Авторизация пользователей в день: *15 раз*
   > Пользователь заходит в мессенджеры в среднем 25 раз в день[^7], а доля ВК на рынке мессенджеров составляет 62% [^8], то есть на ВК по грубой оценке приходится около 15 посещений в сутки от одного пользователя. 
   > Будем считать, что при каждом посещении сервиса пользователь единожды авторизуется, получает куку и далее использует её. 

   **RPS на авторизацию:** *8576*
   >  49,4 * 1000000 * 15 / (24 * 60 * 60) = 8576
2. Создание чатов в день: *0,06 раз*
   > В среднем за сутки создаётся 3 млн чатов [^5], получается, что каждый пользаватель в день создаёт  3 / 49,4 = 0,06 чатов в день
   
   **RPS на создание чатов:** *35*
   > 3 * 1000000 / (24 * 60 * 60) = 34,7 = 35
3. Удаление чатов в сутки: предположим, что оно *пренебрежительно мало*
4. Отправка новых сообщений в день: *272 текстовых и 26 голосовых сообщения*
   > По статистике голосовыми сообщениями пользуется 33 млн пользователей [^1] из 76,9 млн [^1] ежемесячно. 
   > Тогда доля пользователей, использующих голосовые сообщения, есть 33 / 76,9 = 0,43, а не использующих ГС - 0,57.
   > Будем считать, что такое соотношение сохраняется ежедневно и каждый месяц.
   > Также предположим, что пользователи использующие ГС, отправляют его в 25% случаях, а в остальных 75% используют текстовые сообщения.
   > Пользователи, не использующие ГС, оправляют текстовые в 100% случаев.

   > Используя данные выше, определим вероятность того, что новое отправленное сообщение 
   > а) не является голосовым: 1 * 0,57 + 0,8 * 0,43 = 0,914
   > б) является голосовым: 0 * 0,57 + 0,2 * 0,43 = 0,086
   > Проверка: Сумма (а) и (б) = 1 - верно.  
   
   > Ежедневно пользователи отправляют около 15 млрд сообщений [^3], тогда каждый пользователь в среднем за сутки отправляет:
   > 0,914 * 15 млрд * 1000 / 49,4 млн = 277 не голосовых сообщения
   > 0,086 * 15 млрд * 1000 / 49,4 млн = 26 голосовых сообщения

   **RPS на отправку текстовых сообщений:** *158680*
   > 0,914 * 15 * 10^9 / (24 * 60 * 60) = 158680
   
   **RPS на отправку голосовых сообщений:** *14930*
   > 0,086 * 15 * 10^9 / (24 * 60 * 60) = 14930
5. Изменение отправленных сообщений в день: *28 сообщения*
   > Предположим, что в каждом десятом сообщении пользователь делает ошибку и исправляет его, тогда 10% * 277 = 28 редактирования в сутки на одного пользователя
   
   **RPS на изменение сообщения:** *16009*
   > 28 * 49,4 * 1000000 / (24 * 60 * 60) = 16009
6. Удаление отправленных сообщений в день: *3 сообщения*
   > Будем считать, что только 1% сообщений удаляется, тогда (277 + 26) * 1% = 3 сообщения удаляет пользователь в день.
   
   **RPS на удаление сообщений:** *1715*
   > 3 * 49,4 * 1000000 / (24 * 60 * 60) = 1715
7. Поиск пользователей за день: *0,06 раз*
   > Будем считать, что необходимость искать пользователя возникает при создании чата. Используем п.3: 0,06 раз за день пользователь создает диалог/чат, следовательно столько же раз и выполяется поиск.  
   
   **RPS на поиск пользователей:** *35*
8. Получение списка диалогов: *15 раз*
   > Полагаем, что запрос на получение списка диалогов происходит при каждом посещении мессенджера. Используем п.1.

   **RPS на получение списка диалогов:** *8576*
9.  Загрузка новых вложений в день: *6*
    > Предположим что только 2% текстовых сообщений имеет вложения. Тогда в день пользователь в среднем загружает 272 * 0.02 = 6 вложений

    **RPS на загрузку вложений**: *3430*
    > 6 * 49,4 * 1000000 / (24 * 60 * 60) = 3430
10. Получение вложений из сообщений в день: *15 штук*
    > Из п.9 считаем, что 2% сообщений имеют вложения, из п.1 и п.8 имеем, что в день пользователь заходит в сервис и получает список диалогов 15 раз. Будем считать, что в среднем пользователь имеет 5 активных диалогов, в которых каждый раз проверяет последние сообщения, количество которых примем равным 10.
    > Тогда в день пользователь получает вложений 15 * 5 * 10 * 2% = 15

    **RPS на получение вложений**: *8576*
    > 15 * 49,4 * 1000000 / (24 * 60 * 60) = 8576
11. Получение списка сообщений в диалоге: *80 раз*
    > Используем предположения из п.10, получаем: 15 раз в день * 5 активных диалогов = 80 раз

    **RPS на получение списка сообщений в диалоге**: *45741*
    > 80 * 49,4 * 1000000 / (24 * 60 * 60) = 45741

#### Сводная таблица RPS

**Среднее количество RPS по типовым действиям**
|   №   | Действие                      |  Тип   |  RPS   |
| :---: | ----------------------------- | :----: | :----: |
|   1   | Регистрация                   | Запись |   1    |
|   2   | Авторизация                   | Запись |  8576  |
|   3   | Создание чата                 | Запись |   35   |
|   4   | Отправка текстового сообщение | Запись | 158680 |
|   5   | Отправка голосового сообщения | Запись | 14930  |
|   6   | Изменение сообщения           | Запись | 16009  |
|   7   | Удаление сообщений            | Запись |  1715  |
|   8   | Поиск пользователя            | Чтение |   35   |
|   9   | Получение списка диалогов     | Чтение |  8576  |
|  10   | Загрузка вложений             | Запись |  3430  |
|  11   | Получение вложений            | Чтение |  8576  |
|  11   | Получение сообщений в диалоге | Чтение | 45741  |

#### Суммарное RPS на чтение и на запись

- На чтение: 62 928 RPS
- На запись: 203 376 RPS


## Список литературы
[^1]: [Исследование соцсетей и мессенджеров](https://vk.com/press/mediascope-october-2022)

[^2]: [Статистика ВК за 1 кв. 2022 г.](https://habr.com/ru/news/t/663492/)

[^3]: [Статистика Вконтакте](https://3dnews.ru/1061274/auditoriya-vkontakte-v-rossii-virosla-do-725-mln-polzovateley-v-2021-godu)

[^4]: [География Вконтакте](https://yandex.ru/images/search?pos=4&img_url=http%3A%2F%2Fmyslide.ru%2Fdocuments_4%2Ff4c31844a42fc2099f9afe5bc0b49186%2Fimg23.jpg&text=%D1%80%D0%B0%D1%81%D0%BF%D1%80%D0%B5%D0%B4%D0%B5%D0%BB%D0%B5%D0%BD%D0%B8%D0%B5%20%D0%B0%D1%83%D0%B4%D0%B8%D1%82%D0%BE%D1%80%D0%B8%D0%B8%20%D0%B2%D0%BA%20%D0%BF%D0%BE%20%D1%81%D1%82%D1%80%D0%B0%D0%BD%D0%B0%D0%BC&lr=213&rpt=simage&source=serp)

[^5]: [Количество созданых чатов за день](https://team.vk.company/vacancy/30137/)

[^6]: [Длина имени и фамилии](https://ch-pik.ru/kakova-sredniaia-dlina-familii)

[^7]: [Посещаемость мессенджеров за день](https://www.cnews.ru/news/top/2018-02-28_whatsapp_stal_samym_populyarnym_messendzheram_v)

[^8]: [Распределении аудитории по мессенджерам в СНГ](https://wciom.ru/analytical-reviews/analiticheskii-obzor/rossiiskaja-auditorija-socialnykh-setei-i-messendzherov-izmenenija-na-fone-specoperacii)