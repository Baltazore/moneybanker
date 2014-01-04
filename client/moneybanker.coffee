addCost = (item, value) ->
  costs = Session.get("costs")
  costs.push({name: item, cost: value})
  Session.set("costs", costs)

removeCost = (data) ->
  costs = Session.get("costs")
  for index, cost of costs
    if cost.name == data.name && cost.cost == data.cost
      costs.splice(index, 1)
  Session.set("costs", costs)

costs = [
  {name: "RubyRoid", cost: "$1500" }
  {name: "TutsPlus", cost: "$20"}
]
costs = Session.set("costs", costs)

Template.main.greeting = ->
  "Welcome to MoneyBanker."

Template.main.costs = ->
  Session.get("costs")

Template.main.events
  'click input' : (e, t) ->
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
      addCost(name.value, cost.value)
      name.value = ""
      cost.value = ""


Template.cost.events
  'click' : (e, t) ->
    removeCost(t.data)
