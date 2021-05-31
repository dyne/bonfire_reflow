# Immutable fields for signing

**This a draft**

## Event

All fields other than `resourceInventoriedAs` and `toResourceInventoriedAs`, 
these will change per event, as they are resources. We can basically assume that
all fields in event themselves are immutable.

### GraphQL with removed fields
```graphql
type EconomicEvent {
  id: ID!

  """
  Relates an economic event to a verb, such as consume, produce, work, improve, etc.
  """
  action: Action!
  """
  Defines the process to which this event is an input.
  """
  inputOf: Process

  """
  Defines the process for which this event is an output.
  """
  outputOf: Process

  """
  The economic agent from whom the actual economic event is initiated.
  """
  provider: Agent!

  """
  The economic agent whom the actual economic event is for.
  """
  receiver: Agent!

  """
  The primary resource specification or definition of an existing or potential economic resource. A resource will have only one, as this specifies exactly what the resource is.
  """
  resourceConformsTo: ResourceSpecification

  """
  The amount and unit of the economic resource counted or inventoried. This is the quantity that could be used to increment or decrement a resource, depending on the type of resource and resource effect of action.
  """
  resourceQuantity: Measure

  """
  The amount and unit of the work or use or citation effort-based action. This is often a time duration, but also could be cycle counts or other measures of effort or usefulness.
  """
  effortQuantity: Measure

  """
  The beginning of the economic event.
  """
  hasBeginning: DateTime

  """
  The end of the economic event.
  """
  hasEnd: DateTime

  """
  The date/time at which the economic event occurred. Can be used instead of beginning and end.
  """
  hasPointInTime: DateTime

  """
  A textual description or comment.
  """
  note: String

  """
  Reference to an agreement between agents which specifies the rules or policies or calculations which govern this economic event.
  """
  agreedIn: URI

  """
  References another economic event that implied this economic event, often based on a prior agreement.
  """
  triggeredBy: EconomicEvent
  track(recurseLimit: Int): [ProductionFlowItem!]
  trace(recurseLimit: Int): [ProductionFlowItem!]

  """
  The economic event can be safely deleted, has no dependent information.
  """
  deletable: Boolean

  """
  This economic event occurs as part of this agreement.
  """
  realizationOf: Agreement
  appreciationOf: [Appreciation!]
  appreciatedBy: [Appreciation!]

  """
  The place where an economic event occurs.  Usually mappable.
  """
  atLocation: SpatialThing

  """
  The commitment which is completely or partially fulfilled by an economic event.
  """
  fulfills: [Fulfillment!]

  """
  An intent satisfied fully or partially by an economic event or commitment.
  """
  satisfies: [Satisfaction!]
}
```

[Source](https://github.com/bonfire-networks/bonfire_valueflows/blob/main/lib/schema.gql#L1151)

## Process

Similar thing with process, most fields can be considered immutable. The issue with process
is that functions (not fields) like `inputs(...)` or `outputs(...)` can change if more events
are added.

### GraphQL with removed fields

```graphql
type Process {
  id: ID!

  """
  An informal or formal textual identifier for a process. Does not imply uniqueness.
  """
  name: String!

  """
  The planned beginning of the process.
  """
  hasBeginning: DateTime

  """
  The planned end of the process.
  """
  hasEnd: DateTime

  """
  The process is complete or not.  This is irrespective of if the original goal has been met, and indicates that no more will be done.
  """
  finished: Boolean

  """
  The definition or specification for a process.
  """
  basedOn: ProcessSpecification

  """
  A textual description or comment.
  """
  note: String

  inputs(action: ID): [EconomicEvent!]
  outputs(action: ID): [EconomicEvent!]
  unplannedEconomicEvents(action: ID): [EconomicEvent!]
  nextProcesses: [Process!]
  previousProcesses: [Process!]
  workingAgents: [Agent!]

  trace(recurseLimit: Int): [ProductionFlowItem!]
  track(recurseLimit: Int): [ProductionFlowItem!]

  """
  The process can be safely deleted, has no dependent information.
  """
  deletable: Boolean

  """
  The process with its inputs and outputs is part of the plan.
  """
  plannedWithin: Plan
  committedInputs(action: ID): [Commitment!]
  committedOutputs(action: ID): [Commitment!]
  intendedInputs(action: ID): [Intent!]
  intendedOutputs(action: ID): [Intent!]

  """
  The process with its inputs and outputs is part of the scenario.
  """
  nestedIn: Scenario
}
```

[Source](https://github.com/bonfire-networks/bonfire_valueflows/blob/main/lib/schema.gql#L2293)

## Agent

Agent is a bit more complicated, as fields can change more frequently, e.g. an agent is allowed to
change their email or their username. We can only really rely on the `id` field, which is a ULID 
(See our [repo][1] and this [twitter thread][2]) and the canonical URL, which is a unique URL
that refers to an agent on a specific instance.


### Graphql with removed fields

```graphql
interface Agent {
  id: ID!

  canonicalUrl: String
}
```

[Source](https://github.com/bonfire-networks/bonfire_valueflows/blob/main/lib/schema.gql#L55)


[1]: https://github.com/bonfire-networks/pointers_ulid
[2]: https://twitter.com/techpractical/status/1395354059872342017
