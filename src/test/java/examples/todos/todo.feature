Feature: Todos CRUD (environment-driven base URL)

  Background:
    * url baseUrl

  Scenario: simple crud flow
    # create first todo and save id
    Given path 'todos'
    And request { title: 'First', complete: false }
    When method post
    Then status 201
    And match response == { id: '#number', title: 'First', complete: false }
    * def firstId = response.id

    # get newly created todo by id
    Given path 'todos', firstId
    When method get
    Then status 200
    And match response == { id: '#(firstId)', title: 'First', complete: false }

    # get all todos and verify the first is present
    Given path 'todos'
    When method get
    Then status 200
    And match response contains { id: '#(firstId)', title: 'First', complete: false }

    # create a second todo and save id
    Given path 'todos'
    And request { title: 'Second', complete: false }
    When method post
    Then status 201
    And match response == { id: '#number', title: 'Second', complete: false }
    * def secondId = response.id

    # get all todos and verify both ids are present
    Given path 'todos'
    When method get
    Then status 200
    And match response contains
    """
    [
      { id: '#(firstId)',  title: 'First',  complete: false },
      { id: '#(secondId)', title: 'Second', complete: false }
    ]
    """
