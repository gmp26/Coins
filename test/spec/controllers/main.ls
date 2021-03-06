'use strict'

describe 'Controller: MainCtrl', (_) ->

  # load the controller's module
  beforeEach module 'coinsApp'

  MainCtrl = {}
  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope := $rootScope.$new()
    MainCtrl := $controller 'MainCtrl', {
      $scope: scope
    }

  it 'should attach a list of awesomeThings to the scope', ->
    expect scope.awesomeThings.length .toBe 7
