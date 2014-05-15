## ponominalu [![Gem Version](https://badge.fury.io/rb/ponominalu.svg)](http://badge.fury.io/rb/ponominalu) [![Build Status](https://travis-ci.org/crossaidi/ponominalu.svg?branch=master)](https://travis-ci.org/crossaidi/ponominalu) [![Code Climate](https://codeclimate.com/github/crossaidi/ponominalu.png)](https://codeclimate.com/github/crossaidi/ponominalu) [![Dependency Status](https://gemnasium.com/crossaidi/ponominalu.png)](https://gemnasium.com/crossaidi/ponominalu)

`ponominalu` - Ruby-адаптер для работы с API, предоставляемым билетным агентством [ponominalu.ru](http://ponominalu.ru). Он позволяет вызывать все  методы API, перечисленные [в официальной документации](http://api.cultserv.ru/public/docs/methods/) используя интерфейс Ruby.

## Установка

``` ruby
# Gemfile
gem 'ponominalu', '~> 0.1.0'
```

или просто

``` sh
$ gem install ponominalu
```

## Использование

### Вызов методов

### Прочее

По умолчанию автоматически создается короткий синоним `Pn` для модуля `Ponominalu`.

``` ruby
Pn # => Ponominalu
```

При необходимости его можно удалить методом `Ponominalu.unregister_alias`:

``` ruby
Pn.unregister_alias
Pn # => NameError: uninitialized constant Pn
```

### Обработка ошибок

Если API ponominalu.ru возвращает ошибку, выбрасывается исключение класса `Ponominalu::Error`.

``` ruby
Pn.get_artist
# Ponominalu::Error: Ponominalu returned an error -200: 'alias Required' after calling method 'get_artist' without parameters. App session is '123'.
```

### Логгирование

`ponominalu` логгирует служебную информацию о запросах при вызове методов. По умолчанию все пишется в `STDOUT`, однако в настройке можно указать любой другой совместимый логгер, например `Rails.logger`.

Есть возможность логгирования 3 типов информации (параметры запросов, удачные ответы и ошибки), каждому соответствует ключ в глобальных настройках.

|                        | ключ настройки  | по-умолчанию | уровень логгирования |
| ---------------------- | --------------- | ------------ | -------------------- |
| URL запроса            | `log_requests`  | `true`       | `debug`              |
| JSON ответа при ошибке | `log_errors`    | `true`       | `warn`               |
| JSON удачного ответа   | `log_responses` | `false`      | `debug`              |

Таким образом, в rails-приложении с настройками по умолчанию в production записываются только ответы сервера при ошибках; в development также логгируются URL-ы запросов.

## Настройка

Конфигурирование `ponominalu` производится либо в блоке `Ponominalu.configure` следующим образом:

``` ruby
Ponominalu.configure do |config|
  config.session       = '123abc123'

  # faraday-адаптер для запросов
  config.adapter = :net_http
  # HTTP-метод для вызова методов API (:get или :post)
  config.http_verb = :post
  # параметры для faraday-соединения
  config.faraday_options = {
    ssl: {
      ca_path:  '/usr/lib/ssl/certs'
    },
    proxy: {
      uri:      'http://proxy.example.com',
      user:     'foo',
      password: 'bar'
    }
  }
  # максимальное количество повторов запроса при ошибках
  config.max_retries = 2

  # получить ответ JSON-ом в виде строки
  config.raw_json = false

  # выбрасывать исключение, если в результате запроса ничего не было найдено
  config.empty_strict = false

  # результат возвращается в соответствии с форматом указанном в документации, вместе с ключами "code", "ts" а также параметрами запроса, которые могут пригодиться в дальнейшем, в ходе выполнения программы. По умолчанию возвращается непосредственно ответ (ключ "message").
  config.wrap_response = false

  # логгер
  config.logger        = Rails.logger
  config.log_requests  = true  # параметры запросов
  config.log_responses = false # удачные ответы
end
```

Либо вызовом `Ponominalu.configure` с хэшем в качестве параметра:

``` ruby
Ponominalu.configure({
  adapter: :net_http,
  session: '123abc123',
  max_retries: 2,
  empty_strict: false,
  raw_json: false
  ...
})
```

Либо напрямую через сеттеры параметров:

``` ruby
Ponominalu.adapter = :net_http
Ponominalu.session = '123abc123'
Ponominalu.max_retries = 2
...
```

По умолчанию для HTTP-запросов используется `Net::HTTP`; можно выбрать [любой другой адаптер](https://github.com/technoweenie/faraday/blob/master/lib/faraday/adapter.rb), поддерживаемый `faraday`.

Ponominalu.ru [позволяет](http://api.cultserv.ru/public/docs/) использовать как `GET`-, так и `POST`-запросы при вызове методов API. По умолчанию `ponominalu` использует `POST`, но в настройке `http_verb` можно указать `:get`, чтобы совершать `GET`-запросы.

При необходимости можно указать параметры для faraday-соединения - например, параметры прокси-сервера или путь к SSL-сертификатам.

Чтобы сгенерировать файл с настройками по умолчанию в Rails-приложении, можно воспользоваться генератором `ponominalu:install`:

``` sh
$ cd /path/to/app
$ rails generate ponominalu:install
```

## JSON-парсер

`ponominalu` использует парсер [Oj](https://github.com/ohler55/oj), как наиболее быстрый на данный момент.


## Участие в разработке

Если вы хотите поучаствовать в разработке проекта, необходимо сделать форк репозитория, запушить свои изменения в отдельную ветку, написать для них спеки и отправить pull request.

`ponominalu` тестируется под MRI `1.9.3`, `2.0.0` и `2.1.0`. Если в одной из этих сред что-либо работает некорректно, либо вообще не работает, то это следует считать багом, и создать [issue на Github](https://github.com/crossaidi/ponominalu/issues).
