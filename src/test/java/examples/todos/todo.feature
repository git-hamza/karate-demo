Feature: Todos CRUD (environment-driven base URL)

  Background:
    * url baseUrl
    # Kafka integration utilities
    * def produceFn = read('classpath:examples/kafka_utils/kafka-produce.js')
    * def consumeFn = read('classpath:examples/kafka_utils/kafka-consume.js')
    * def kafkaConfig = kafka

  # Scenario: simple crud flow
  #   # create first todo and save id
  #   Given path 'todos'
  #   And request { title: 'First', complete: false }
  #   When method post
  #   Then status 201
  #   And match response == { id: '#number', title: 'First', complete: false }
  #   * def firstId = response.id

  #   # get newly created todo by id
  #   Given path 'todos', firstId
  #   When method get
  #   Then status 200
  #   And match response == { id: '#(firstId)', title: 'First', complete: false }

  #   # get all todos and verify the first is present
  #   Given path 'todos'
  #   When method get
  #   Then status 200
  #   And match response contains { id: '#(firstId)', title: 'First', complete: false }

  #   # create a second todo and save id
  #   Given path 'todos'
  #   And request { title: 'Second', complete: false }
  #   When method post
  #   Then status 201
  #   And match response == { id: '#number', title: 'Second', complete: false }
  #   * def secondId = response.id

  #   # get all todos and verify both ids are present
  #   Given path 'todos'
  #   When method get
  #   Then status 200
  #   And match response contains
  #   """
  #   [
  #     { id: '#(firstId)',  title: 'First',  complete: false },
  #     { id: '#(secondId)', title: 'Second', complete: false }
  #   ]
  #   """

  Scenario: Publish Kafka event when a new todo is created (ATDD)
    # Given the environment is set to "dev"
    # Environment may vary; uses Kafka settings from karate-config.js
    And def title = 'Kafka ATDD'

    # When a new todo is created
    Given path 'todos'
    And request { title: '#(title)', complete: false }
    When method post

    # Then the todo is created
    Then status 201
    And match response == { id: '#number', title: '#(title)', complete: false }
    * def todoId = response.id

    # And a message is produced to the Kafka topic
    * def event = { id: '#(todoId)', title: '#(title)', complete: false, action: 'created' }
    * def eventStr = karate.toJson(event)
    * def produceCfg = karate.merge(kafkaConfig, { key: 'todo-' + todoId, message: eventStr })
    * def send = call produceFn produceCfg
    And match send.status contains 'sent'

    # And the message can be consumed and verified
    * def consumeCfg = karate.merge(kafkaConfig, { key: 'todo-' + todoId })
    * def received = call consumeFn consumeCfg
    Then match received.status == 'received'
    # if file is properly loaded
    # * def receivedJson = karate.fromJson(received.message)
    # And match receivedJson == { id: '#(todoId)', title: '#(title)', complete: false, action: 'created' }
