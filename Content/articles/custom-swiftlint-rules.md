---
date: 2021-02-06 11:39
description: Enforcing code style
tags: swiftlint
---
# Using custom Swiftlint rules
Swiftlint is an amazing tool that help us not only write cleaner code, but also better code. 
Thanks to Swiftlint, I once got a job because my code was clean. Thanks to Swiftlint, I learned that delegates should be class protocols and weak. 

### Enforcing Extensions
Extensions are one of my favorite features of the Swift language. They are really helpful to add tricks to current classes, avoiding those huge “Utils” files we see in many projects. One problem though, when working on a team bigger than 1 developer, is to remember these extensions exist and we end up creating our own extensions or doing it in the “old”, uglier way.
Let’s take for example my favorite extensions:

```
extension UITableViewCell {
    
    static var reuseIdentifier: String {
        return NSStringFromClass(self)
    }
}

extension UITableView {
    
    public func register<T: UITableViewCell>(type: T.Type) {
        register(type, forCellReuseIdentifier: type.reuseIdentifier)
    }
    
    public func dequeue<T: UITableViewCell>(type: T.Type, indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: type.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Cell not registered: \(T.self)")
        }
        return cell
    }
}
```
 Thanks to this extension and the power of generics, we can reduce a lot of boilerplate:

```
// Old

override func viewDidLoad() {
    super.viewDidLoad()
    tableView.register(NameCell.self, forCellReuseIdentifier: "NameCell")
}

func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "NameCell", for: indexPath) as? NameCell else {
        fatalError("Name cell not registered")
    }
    cell.name = ""
    
    return cell
}
```

```
// New
override func viewDidLoad() {
    super.viewDidLoad()
    tableView.register(type: NameCell.self)
}

func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeue(type: NameCell.self, indexPath: indexPath)
    cell.name = ""
    return cell
}
```

One problem though, is that the new developer that just arrived in my team doesn’t know about these extensions, so there’s a great chance that the developer will open a PR using the regular methods instead of our shiny extension.

##### Custom lint rules to the rescue!
We can create a rule that detects when the developer is using the regular method and presents a warning teaching the dev about our amazing extension.
Swiftlint rules are all based on Regex, so I’ve been using [Regex website] to help me out while writing our regex.

```ruby
// .swiftlint.yml
custom_rules:
  tableview_register_extension:
    included: ".*\\.swift"
    excluded: ".*\\Extensions.swift"
    name: "TableView Register Extension"
    regex: "(register).*(forCellReuseIdentifier)"
    message: "Please use our extension instead: tableView.register(type: CellClass.self)"
    severity: warning
    
  tableview_dequeue_extension:\
    included: ".*\\.swift"
    excluded: ".*\\Extensions.swift"\
    name: "TableView Dequeue Extension"
    regex: "(dequeueReusableCell\\(withIdentifier)"
    message: "Please use our extension instead: dequeue(type: CellClass.self, indexPath: indexPath)"
    severity: warning
```
<img src="/images/custom-swiftlint-rules/table-register-warning.png" alt="Table Register Warning" width="800"/>
<img src="/images/custom-swiftlint-rules/table-dequeue-warning.png" alt="Table Dequeue Warning" width="800"/>


### Enforcing a design pattern
At one of my previous companies, we were using MVVM + Repository with a separate framework for the API. So one idea we had to enforce our design pattern was to only allow the Repository classes to import API.

```ruby
api_outside_repository:
  included: ".*\\.swift"
  excluded: ".*\\Repository.swift"
  name: "Import API outside Repository"
  regex: "(import API)"
  message: "Only Repository classes can import API"
  severity: warning
```

Another of our projects used Coordinators, so we created another rule to enforce that no ViewController was presenting another ViewController

```ruby 
present_outside_coordinator:
  included: ".*\\.swift"
  excluded: ".*\\Coordinator.swift"
  name: "Use present outside Coordinator"
  regex: "(present).*(animated)"
  message: "Only Coordinators can present ViewControllers"
  severity: warning
```

### Magic number in constraints
Views can become quite complex, so organizing our constraints was also really important for our team. We created a rule to avoid magic numbers in constraints, asking the dev to use a constant that was defined somewhere else in the code.

``` // Lint rule 
```

### Conclusion
These are some examples, but sky is the limit. The important thing when introducing these rules is to discuss with your team. Swiftlint should be your helper,  not a dictator.
