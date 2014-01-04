Costs = new Meteor.Collection("costs")
Incomes = new Meteor.Collection("incomes")

Costs.allow
  insert: (userId, doc) ->
    (userId && doc.owner == userId)
  update: (userId, docs, fields, modifier) ->
    _.all(docs, (doc) ->
      doc.owner == userId)
  remove: (userId, doc) ->
    (userId && doc.owner == userId)
Costs.deny
  update: (userID, docs, fields, modifier) ->
    fields.indexOf("owner") > -1

Incomes.allow
  insert: (userId, doc) ->
    (userId && doc.owner == userId)
  update: (userId, docs, fields, modifier) ->
    _.all(docs, (doc) ->
      doc.owner == userId)
  remove: (userId, doc) ->
    (userId && doc.owner == userId)
Incomes.deny
  update: (userID, docs, fields, modifier) ->
    fields.indexOf("owner") > -1

if Meteor.isClient
  Meteor.subscribe "costs", Meteor.userId()
  Meteor.subscribe "incomes", Meteor.userId()

  Template.main.greeting = ->
    "Welcome to MoneyBanker"

  Template.main.costs = ->
    Costs.find().fetch()

  Template.main.incomes = ->
    Incomes.find().fetch()

  Template.main.totalCosts = ->
    result = 0.0
    Costs.find().map (doc) ->
      result += parseFloat(doc.cost)
    result

  Template.main.totalIncomes = ->
    result = 0.0
    Incomes.find().map (doc) ->
      result += parseFloat(doc.cost)
    result

  Template.main.events
    'click .btn' : (e, t) ->
      if e.toElement.id == "add-cost"
        name = t.find('input#cost-name')
        value= t.find('input#cost-value')
        Costs.insert({name: name.value, cost: value.value, owner: Meteor.userId()})
        name.value = ""
        value.value = ""
      if e.toElement.id == "add-income"
        name = t.find('input#income-name')
        value= t.find('input#income-value')
        Incomes.insert({name: name.value, cost: value.value, owner: Meteor.userId()})
        name.value = ""
        value.value = ""

    'keypress input' : (e, t) ->
      if e.keyCode == 13
        costName = t.find('input#cost-name')
        costValue= t.find('input#cost-value')
        incomeName = t.find('input#income-name')
        incomeValue= t.find('input#income-value')
        if costName.value != '' && costValue.value != ''
          Costs.insert({name: costName.value, cost: costValue.value, owner: Meteor.userId()})
          costName.value = ""
          costValue.value = ""
        if incomeName.value != '' && incomeValue.value != ''
          Incomes.insert({name: incomeName.value, cost: incomeValue.value, owner: Meteor.userId()})
          incomeName.value = ""
          incomeValue.value = ""

  Template.elem.editing = ->
    !!Session.get("edit-"+this._id)

  Template.elem.rendered = ->
    input = this.find("input")
    if input
      input.focus()

  Template.elem.events
    'click .name' : (e, t) ->
      Session.set("edit-"+t.data._id, true)

    'keydown input' : (e, t) ->
      if e.keyCode == 13
        name = t.find('input#edit-name').value
        cost = t.find('input#edit-cost').value
        if Costs.find(t.data._id)
          Costs.update(t.data._id, { $set: {name: name, cost: cost} })
        if Incomes.find(t.data._id)
          Incomes.update(t.data._id, { $set: {name: name, cost: cost} })
        Session.set("edit-"+t.data._id, false)

    'keydown' : (e, t) ->
      if e.keyCode == 27
        Session.set("edit-"+t.data._id, false)

    'click .icon-remove' : (e, t) ->
      if Costs.find(t.data._id)
        Costs.remove(t.data._id)
      if Incomes.find(t.data._id)
        Incomes.remove(t.data._id)

if Meteor.isServer
  Meteor.publish "costs", (user) ->
    Costs.find({ owner: user})
  Meteor.publish "incomes", (user) ->
    Incomes.find({ owner: user})

