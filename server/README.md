разрешение на публикацию данного кода было получено либо код не находился под NDA либо уже более не находится под NDA тоесть я могу его показать не нарушая соглашений о коммерческой тайне.

черновик архитектуры сервера в desktop\project architecture.txt

забор входящих данных клиентов из netty происходит сразу в channelHandler как и генерации внутриигровых сообщений(входящие - для бизнес логики игры). генерацию(парсинг) можно сделать отдельным тредом чтобы полностью разгрузить netty на прием данных от клиентов

1 тред для обработки игровых сообщений и генерации внутриигровых событий(исходящие - для клиентов)

2 тред для отправки событий игры клиентам (включая генерацию сетевых сообщений на базе игровых событий)

сделано не совсем оптимально в плане размещения кода. например у сообщения кроме данных модели сообщения есть метод аналог toString который пишет в channel context двоичные данные

в идеале все события сети вначале копируются в память чтобы освободить сокеты клиентов далее они парсятся и превращаются в события игры которые далее обрабатываются и генерируются события сети(сейчас так сделано для всех сообщений кроме входа нового или существующего игрока на сервер).

добавление или выбор комнат сделано без событий - прямо после получения сообщения от клиента. этого следует избегать при больших нагрузках на сервер.

функционал сервера:

1 на подключение, потерю связи, переподключение есть реакция в комнате и отправляются уведомления остальным онлайн пользователям комнаты в клиенты

2 при переподключении пользователь сообщает свой ИД и получает от сервера сессию(текущее состояние игры) - данные игрового поля и ИД игрока который сейчас может сделать ход

3 сейчас поддерживатся игровое поле любых размеров

4 хотел добавить чат, выбор размеров игрового поля. не успел тк работа с ASwing во flash занимет время как и архитектура клиента она оказалась сложна, у меня уже был флеш клиент я решил что смогу сразу его использовать. оказалось что я уже давно не помню архитектуру своих проектов во flash пришлось заново изучать

основной код:

GameRoom->processIncomingEvent

обработка входящих уже распарсенных сообщений от клиента. изменение состояния игрового мира(доски) и создание событий оповещений игроков в комнате о новых событиях

ClientHandler->channelRead

здесь куски игровой бизнес логики(их можно вынести отдельно по аналогии с GameRoom) вместе с парсингом бинарных данных - MessageFactory.constructIncomingMessage(buf, playerId);

GameMessage->writeToContext

в идеале в плане лучшей архитектуры нужно вынести в encoder но это увеличивает количество кода



