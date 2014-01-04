Costs = new Meteor.Collection("costs")

addCost = (name, cost) ->
  Costs.insert({name: name, cost: cost})

removeCost = (data) ->
  debugger

if Meteor.isClient

  Template.main.greeting = ->
    "Welcome to MoneyBanker."

  Template.main.costs = ->
    Costs.find().fetch()

  Template.main.events
    'click button' : (e, t) ->
      if e.toElement.id == "add-cost"
        name = t.find('input#name')
        cost = t.find('input#cost')
        addCost(name.value, cost.value)
        name.value = ""
        cost.value = ""

    'keypress input' : (e, t) ->
      if e.keyCode == 13
        name = t.find('input#name')
        cost = t.find('input#cost')
        if name.value != '' && cost.value != ''
          addCost(name.value, cost.value)
          name.value = ""
          cost.value = ""

  Template.cost.editing = ->
    return Session.get("edit-"+this._id)

  Template.cost.events
    'click li' : (e, t) ->
      Session.set("edit-"+t.data._id, true)

    'keypress input' : (e, t) ->
      if e.keyCode == 13
        name = t.find('input#edit-name').value
        cost = t.find('input#edit-cost').value
        Costs.update(t.data._id, { $set: {name: name, cost: cost} })
        Session.set("edit-"+t.data._id, false)
